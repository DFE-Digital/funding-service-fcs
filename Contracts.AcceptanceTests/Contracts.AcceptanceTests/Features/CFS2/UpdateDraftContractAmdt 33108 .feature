Feature: UpdateDraftContractAmdt 33108 

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run45
@CFS
Scenario: A505 Create 2021 EDSK contract with 16TR alloc. Import and release 1619 RG. NFA (variation). 1619 FA to update deliverables. Add NMSS FA. Release both Publish and approve v2. NFA. Amend £. Check docs, CRM, PaaS and feed

    #  1. Inject EDSK contract with 16TR alloc  (£40930)
    #  2. Populate stub with 1619 FA  (£89182)
    #  3. Consume stub and release RG
    #  4. Publish and approve v1  (£130112)
    #  5. NFA -> v2
    #  6. Update 1619 FA. Change some financials and add more deliverables (+£30000)
    #  7. Add NMSS FA  (£8910)
    #  8. Consume stub and release RG (Two FAs = £38910)
    #  9. v2 = £40930 + £128092 = £169022
    # 10. Publish and approve v2
    # 11. Change timestamp on Sch1 template
    # 12. NFA -> v3 (+Sch1)
    # 13. Update NMSS FA. Swap financials on two deliverables (but still £8910)

    Given there is no Contract, Task or Workflow data for UKPRN '10017505' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017505' 
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017505'
    And   there is no Funding Allocation data in CRM for UKPRN '10017505'
    And   there is no Contract, Task or Workflow data for UKPRN '10017505'
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017505' 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017505' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-505      |

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-505      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | 16-18TRN2122   |
    | 1619ED2122     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-505       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017505'

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





    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017505' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017505 Co Ltd' with UKPRN '10017505' and OrgId 'ORG0017505' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017505' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017505 | 117505 | 10017505 Co Ltd | 0              | Active                | Yes           | AA017505      | ?             | 231a Union Street      | Aberdeen               | ?                      | ?                      | ?                      | ?                      | AB11 6BQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017505 |




    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-505'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-505'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017505 | 10017505 Co Ltd      | ESFA-505             | EDSK-505       | 1                     | 01/08/2021        | 31/07/2022      | 40930.00      |                                       | Conditions of Funding (Grant) (College)    | 2122   | New          | ORG0017505 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017505 | EDSK-505       | 16TR-505      | 16-18TRN          | 16-18TRN2122            | AY                      | 01/08/2021          | 31/07/2022        | 40930.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017505 | EDSK-505       | 16TR-505      | 1               | 0                     | 40930.00  | 26803.00  | 14127.00  | 3138.00  | 3721.00  | 3706.00  | 1033.00  | 5351.00  | 4482.00  | 3390.00  | 1982.00  | 5223.00  | 2901.00  | 1714.00  | 4289.00  | Total 16-18 Traineeships Funding                                | New          |             | 
    | 10017505 | EDSK-505       | 16TR-505      | 2               | 1                     | 23312.00  | 16080.00  | 7232.00   | 2817.00  | 2160.00  | 3148.00  | 184.00   | 2659.00  | 2635.00  | 1725.00  | 752.00   | 2689.00  | 579.00   | 1473.00  | 2491.00  | 16-18 Traineeships Programme Funding                            | New          |             | 
    | 10017505 | EDSK-505       | 16TR-505      | 3               | 1                     | 17618.00  | 10723.00  | 6895.00   | 321.00   | 1561.00  | 558.00   | 849.00   | 2692.00  | 1847.00  | 1665.00  | 1230.00  | 2534.00  | 2322.00  | 241.00   | 1798.00  | 16-18 Traineeships Bursary Funding                              | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert row with the following details (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-505       | 1                     | 0                        | 2021-07-01 09:12:35.000 |





    # Populate the stub with 1619 (03SFC) data

    # Change the date 
    Given the override date is '03/07/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017505 | 1619-AS-2122-Contract-Provider-10017505-3_5           | 3_5            | 1619                        | AS-2122            | 89182.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017505-3_5  | 3_5                    | 1619-AS-2122-Contract-Provider-10017505-3_5           | 10017505      | Furth        | 03SFC           | 89182.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017505-3_5  | 1619-001        | 19476.00         | Payment         |
    | 1619-AS-2122-10017505-3_5  | 1619-003        | 8139.00          | Payment         |
    | 1619-AS-2122-10017505-3_5  | 1619-004        | 20383.00         | Payment         |
    | 1619-AS-2122-10017505-3_5  | 1619-007        | 11678.00         | Payment         |
    | 1619-AS-2122-10017505-3_5  | 1619-011        | 2240.00          | Payment         |
    | 1619-AS-2122-10017505-3_5  | 1619-013        | 14006.00         | Payment         |
    | 1619-AS-2122-10017505-3_5  | 1619-020        | 13260.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017505-3_5  | 1619-001        | FY-2122              | August                 | 2021              | 2797.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-001        | FY-2122              | January                | 2022              | 4517.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-001        | FY-2122              | March                  | 2022              | 4421.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-001        | FY-2122              | April                  | 2022              | 2583.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-001        | FY-2122              | July                   | 2022              | 5158.00                   |
    #
    | 1619-AS-2122-10017505-3_5  | 1619-003        | FY-2122              | October                | 2021              | 2122.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-003        | FY-2122              | March                  | 2022              | 2474.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-003        | FY-2122              | April                  | 2022              | 3543.00                   |
    #
    | 1619-AS-2122-10017505-3_5  | 1619-004        | FY-2122              | August                 | 2021              | 3051.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-004        | FY-2122              | November               | 2021              | 2821.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-004        | FY-2122              | January                | 2022              | 4573.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-004        | FY-2122              | February               | 2022              | 2255.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-004        | FY-2122              | April                  | 2022              | 4146.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-004        | FY-2122              | June                   | 2022              | 3537.00                   |
    #
    | 1619-AS-2122-10017505-3_5  | 1619-007        | FY-2122              | August                 | 2021              | 3862.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-007        | FY-2122              | February               | 2022              | 5647.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-007        | FY-2122              | July                   | 2022              | 2169.00                   |
    #
    | 1619-AS-2122-10017505-3_5  | 1619-011        | FY-2122              | March                  | 2022              | 2240.00                   |
    #
    | 1619-AS-2122-10017505-3_5  | 1619-013        | FY-2122              | November               | 2021              | 5516.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-013        | FY-2122              | February               | 2022              | 5933.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-013        | FY-2122              | May                    | 2022              | 2557.00                   |
    #
    | 1619-AS-2122-10017505-3_5  | 1619-020        | FY-2122              | November               | 2021              | 2748.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-020        | FY-2122              | January                | 2022              | 4671.00                   |
    | 1619-AS-2122-10017505-3_5  | 1619-020        | FY-2122              | April                  | 2022              | 5841.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '05/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017505 | 10017505 Co Ltd  | 1619-AS-2122-Contract-Provider-10017505-3_5             | 3_5            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 89182.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2122-Contract-Provider-10017505-3_5             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 89182.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017505 | 1619-AS-2122-Contract-Provider-10017505-3_5             | 3_5            | AS-2122 | 1619                        | 89182.00    | [CofG_College] |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '07/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 89182.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017505' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017505' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017505 | 10017505 Co Ltd  | 1619-AS-2122-Contract-Provider-10017505-3_5             | 3_5            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 89182.00    | EDSK-505      | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017505-3_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-Provider-10017505-3_5             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017505-3_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017505 | 1619-AS-2122-Contract-Provider-10017505-3_5             | 3_5            | AS-2122 | 1619                        | 89182.00    | [CofG_College] |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017505-3_5             | EDSK-505     | 1               | 1                  | Yes            |
    
    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017505 | EDSK-505           | 1                     | 1                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017505 | EDSK-505           | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017505 | ESFA-505           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017505 | EDSK-505           | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 130112.00     | 1                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | ESFA-505           | AY2122 | ?               | 10017505 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017505 | ESFA-505           | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017505 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017505 | EDSK-505           | 16TR-505              | ?                             | 40930.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 16-18TRN      | 16-18TRN2122        | Contract Allocation   | ?                        |
    | 10017505 | EDSK-505           | [AllocRef_16ED]       | ?                             | 89182.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | EDSK-505       | [AllocRef_16ED] | 20              | 19476.00  | 2797.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4517.00  | 0.00     | 4421.00  | 2583.00  | 0.00     | 0.00     | 5158.00  | 16-19 Programme Funding                        |                          |
    | EDSK-505       | [AllocRef_16ED] | 33              | 8139.00   | 0.00     | 0.00     | 2122.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2474.00  | 3543.00  | 0.00     | 0.00     | 0.00     | Residential Bursary Fund                       |                          |
    | EDSK-505       | [AllocRef_16ED] | 85              | 20383.00  | 3051.00  | 0.00     | 0.00     | 2821.00  | 0.00     | 4573.00  | 2255.00  | 0.00     | 4146.00  | 0.00     | 3537.00  | 0.00     | Residential Support Scheme                     |                          |
    | EDSK-505       | [AllocRef_16ED] | 112             | 11678.00  | 3862.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5647.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2169.00  | 16-19 Capacity and Delivery                    |                          |
    | EDSK-505       | [AllocRef_16ED] | 51              | 2240.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2240.00  | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Sporting Excellence  |                          |
    | EDSK-505       | [AllocRef_16ED] | 18              | 14006.00  | 0.00     | 0.00     | 0.00     | 5516.00  | 0.00     | 0.00     | 5933.00  | 0.00     | 0.00     | 2557.00  | 0.00     | 0.00     | Maintained Special SSF Bursary Support         |                          |
    | EDSK-505       | [AllocRef_16ED] | 52              | 13260.00  | 0.00     | 0.00     | 0.00     | 2748.00  | 0.00     | 4671.00  | 0.00     | 0.00     | 5841.00  | 0.00     | 0.00     | 0.00     | Alternative Completions - Sea Fishing          |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '120' deliverable period rows in CRM linked to the latest version of contract 'EDSK-505'

    # Check the contents of the Appendices (SoF, T&C, 2xSch1, Sch2, FA, Sch2 FA, Sch3ON)
    And   the file named '10017505_EDSK-505_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017505 Co Ltd UKPRN: 10017505
    Master Contract Number: ESFA-505
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 18 Traineeships 16TR-505 £26,803 £14,127 £40,930
    16 to 19 Education [AllocRef_16ED] £59,648 £29,534 £89,182
    Total Funding for this contract: £130,112
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017505 Co Ltd
    16 to 18 Traineeships
    Funding for
    16 to 19 Education
    Master Agreement Number ESFA-505
    THIS AGREEMENT AND LEGALLY BIND THE COLLEGE.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017505 Co Ltd THE SECRETARY OF STATE FOR
    231a Union Street EDUCATION
    Aberdeen DEPARTMENT FOR EDUCATION
    AND
    AB11 6BQ 20 GREAT SMITH STREET
    LONDON
    SW1P 3BT
    Company No: AA017505
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 79

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships Version 2 (December 2021) – Page 1
    EDSK Schedule 1 – 16 to 18 Traineeships Version 2 (December 2021) – Page 6

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2021) – Page 11

    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
    EDSK Schedule 2 – 16 to 18 Traineeships Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017505 Co Ltd UKPRN: 10017505
    Master Contract Number: ESFA-505 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: 16TR-505
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16 to 18 Traineeships Programme Funding £23,312 £2,817 £2,160 £3,148 £184 £2,659 £2,635 £1,725 £752 £2,689 £579 £1,473 £2,491
    16 to 18 Traineeships Bursary Funding £17,618 £321 £1,561 £558 £849 £2,692 £1,847 £1,665 £1,230 £2,534 £2,322 £241 £1,798
    Total Funding £40,930 £3,138 £3,721 £3,706 £1,033 £5,351 £4,482 £3,390 £1,982 £5,223 £2,901 £1,714 £4,289
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement 16TR-505 – Page 1 Ref (for internal use only):  EDSK-505 v1

    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017505 Co Ltd UKPRN: 10017505
    Master Contract Number: ESFA-505 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Programme Funding £19,476 £2,797.00 £0.00 £0.00 £0.00 £0.00 £4,517.00 £0.00 £4,421.00 £2,583.00 £0.00 £0.00 £5,158.00
    16-19 Capacity and Delivery £11,678 £3,862.00 £0.00 £0.00 £0.00 £0.00 £0.00 £5,647.00 £0.00 £0.00 £0.00 £0.00 £2,169.00
    Maintained Special SSF Bursary Support £14,006 £0.00 £0.00 £0.00 £5,516.00 £0.00 £0.00 £5,933.00 £0.00 £0.00 £2,557.00 £0.00 £0.00
    Residential Bursary Fund £8,139 £0.00 £0.00 £2,122.00 £0.00 £0.00 £0.00 £0.00 £2,474.00 £3,543.00 £0.00 £0.00 £0.00
    Residential Support Scheme £20,383 £3,051.00 £0.00 £0.00 £2,821.00 £0.00 £4,573.00 £2,255.00 £0.00 £4,146.00 £0.00 £3,537.00 £0.00
    Alternative Completions - Sporting Excellence £2,240 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,240.00 £0.00 £0.00 £0.00 £0.00
    Alternative Completions - Sea Fishing £13,260 £0.00 £0.00 £0.00 £2,748.00 £0.00 £4,671.00 £0.00 £0.00 £5,841.00 £0.00 £0.00 £0.00
    Total Funding £89,182 £9,710.00 £0.00 £2,122.00 £11,085.00 £0.00 £13,761.00 £13,835.00 £9,135.00 £16,113.00 £2,557.00 £3,537.00 £7,327.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-505 v1

    SCHEDULE 3: NOT USED
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017505_EDSK-505_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A505_1.pdf'

    # Wait for row to arrive then update the CreatedDate (J106)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details are present in the ContractManagement.CreatedContract table 
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-505       | 1                     | 1                        | 2021-07-07 09:12:35.000 |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'EDSK-505' for provider '10017505'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017505 - 10017505 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract 'EDSK-505' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017505 | ESFA-505           | EDSK-505       | 1                     | Record Imported (Task generated)            | CRM Integration               | FCS2 TEST        | Document Management Team    | Draft             | Awaiting Documentation                       | ?                     | ?                         | Draft          | ?                                            |
    | 10017505 | ESFA-505           | EDSK-505       | 1                     | Create New Draft Version (Create Task)      | CRM Integration               | FCS2 TEST        | Document Management Team    | Draft             | Awaiting Documentation                       | ?                     | ?                         | Draft          | ?                                            |





    # Publish and approve v1.1 (32385)

    # Change the date 
    Given the override date is '09/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-505'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-505' and ContractNumber 'EDSK-505' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-505' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017505 | EDSK-505           | 1                     | 1                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017505 | ESFA-505           | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                |
    | 10017505 | 10017505 Co Ltd  | 1619-AS-2122-Contract-Provider-10017505-3_5             | 3_5            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 89182.00    | EDSK-505      | 1                 | CRM Integration       | CRM Integration           | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-505' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '10' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017505 | EDSK-505       | 1               | 16TR-505         | 1               | 0                     | 40930.00     | 0             | 0        | Total 16-18 Traineeships Funding               | ?                           | 
    | 10017505 | EDSK-505       | 1               | 16TR-505         | 2               | 1                     | 23312.00     | 0             | 0        | 16-18 Traineeships Programme Funding           | ?                           | 
    | 10017505 | EDSK-505       | 1               | 16TR-505         | 3               | 1                     | 17618.00     | 0             | 0        | 16-18 Traineeships Bursary Funding             | ?                           | 
    #
    | 10017505 | EDSK-505       | 1               | [AllocRef_16ED]  | 20              | 0                     | 19476.00     | 0             | 0        | 16-19 Programme Funding                        | ?                           |
    | 10017505 | EDSK-505       | 1               | [AllocRef_16ED]  | 33              | 0                     | 8139.00      | 0             | 0        | Residential Bursary Fund                       | ?                           |
    | 10017505 | EDSK-505       | 1               | [AllocRef_16ED]  | 85              | 0                     | 20383.00     | 0             | 0        | Residential Support Scheme                     | ?                           |
    | 10017505 | EDSK-505       | 1               | [AllocRef_16ED]  | 112             | 0                     | 11678.00     | 0             | 0        | 16-19 Capacity and Delivery                    | ?                           |
    | 10017505 | EDSK-505       | 1               | [AllocRef_16ED]  | 51              | 0                     | 2240.00      | 0             | 0        | Alternative Completions - Sporting Excellence  | ?                           |
    | 10017505 | EDSK-505       | 1               | [AllocRef_16ED]  | 18              | 0                     | 14006.00     | 0             | 0        | Maintained Special SSF Bursary Support         | ?                           |
    | 10017505 | EDSK-505       | 1               | [AllocRef_16ED]  | 52              | 0                     | 13260.00     | 0             | 0        | Alternative Completions - Sea Fishing          | ?                           |

  
  


    # Execute a NON-FINANCIAL amendment on EDSK-505

    # Change the date
    Given the override date is '11/07/2021'

    # Issue a non-financial VARIATION amendment on v1.1 to create v2.0
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '1' of contract 'EDSK-505' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '1' of contract 'EDSK-505' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017505 | EDSK-505           | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017505 | EDSK-505           | 1                     | 1                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017505 | EDSK-505           | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017505 | ESFA-505           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the contents of the Appendices (SoF only)
    And   the file named '10017505_EDSK-505_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    """   
    
    # There shouldn't be a T&C doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """
    
    # There shouldn't be any Sch 1 docs
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """
    
    # There shouldn't be a Sch 2 doc for 16-18 Traineeships
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    """
    
    # There shouldn't be a Sch 2 doc for 16-19 Education
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2 – 16 TO 19 EDUCATION
    """

    # There shouldn't be a Funding Agreement for 16-18 Traineeships
    And   the pdf file does not contain the following text
    """
    Funding Agreement – 16 to 18 Traineeships
    """

    # There shouldn't be a Funding Agreement for 16-19 Education
    And   the pdf file does not contain the following text
    """
    Funding Agreement – 16 to 19 Education
    """

    # There shouldn't be a Sch3ON doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017505_EDSK-505_v2.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A505_2.0.pdf'

    # Wait for row to arrive then update the CreatedDate (J106)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details are present in the ContractManagement.CreatedContract table 
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-505       | 2                     | 0                        | 2021-07-11 09:12:35.000 |

    

 
 
    # Clear down then populate the stub with 1619 (03SFC) data for v3_6. Update financials on D1 and D11. Add D21 and D24

    # Change the date 
    Given the override date is '13/07/2021'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017505 | 1619-AS-2122-Contract-Provider-10017505-3_6           | 3_6            | 1619                        | AS-2122            | 119182.00         |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017505-3_6  | 3_6                    | 1619-AS-2122-Contract-Provider-10017505-3_6           | 10017505      | Furth        | 03SFC           | 119182.00                 |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017505-3_6  | 1619-001        | 24476.00         | Payment         |
    | 1619-AS-2122-10017505-3_6  | 1619-003        | 8139.00          | Payment         |
    | 1619-AS-2122-10017505-3_6  | 1619-004        | 20383.00         | Payment         |
    | 1619-AS-2122-10017505-3_6  | 1619-007        | 11678.00         | Payment         |
    | 1619-AS-2122-10017505-3_6  | 1619-011        | 7240.00          | Payment         |
    | 1619-AS-2122-10017505-3_6  | 1619-013        | 14006.00         | Payment         |
    | 1619-AS-2122-10017505-3_6  | 1619-020        | 13260.00         | Payment         |
    | 1619-AS-2122-10017505-3_6  | 1619-021        | 10000.00         | Payment         |
    | 1619-AS-2122-10017505-3_6  | 1619-024        | 10000.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017505-3_6  | 1619-001        | FY-2122              | August                 | 2021              | 2797.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-001        | FY-2122              | September              | 2021              | 5000.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-001        | FY-2122              | January                | 2022              | 4517.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-001        | FY-2122              | March                  | 2022              | 4421.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-001        | FY-2122              | April                  | 2022              | 2583.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-001        | FY-2122              | July                   | 2022              | 5158.00                   |
    #
    | 1619-AS-2122-10017505-3_6  | 1619-003        | FY-2122              | October                | 2021              | 2122.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-003        | FY-2122              | March                  | 2022              | 2474.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-003        | FY-2122              | April                  | 2022              | 3543.00                   |
    #
    | 1619-AS-2122-10017505-3_6  | 1619-004        | FY-2122              | August                 | 2021              | 3051.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-004        | FY-2122              | November               | 2021              | 2821.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-004        | FY-2122              | January                | 2022              | 4573.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-004        | FY-2122              | February               | 2022              | 2255.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-004        | FY-2122              | April                  | 2022              | 4146.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-004        | FY-2122              | June                   | 2022              | 3537.00                   |
    #
    | 1619-AS-2122-10017505-3_6  | 1619-007        | FY-2122              | August                 | 2021              | 3862.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-007        | FY-2122              | February               | 2022              | 5647.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-007        | FY-2122              | July                   | 2022              | 2169.00                   |
    #
    | 1619-AS-2122-10017505-3_6  | 1619-011        | FY-2122              | September              | 2021              | 5000.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-011        | FY-2122              | March                  | 2022              | 2240.00                   |
    #
    | 1619-AS-2122-10017505-3_6  | 1619-013        | FY-2122              | November               | 2021              | 5516.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-013        | FY-2122              | February               | 2022              | 5933.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-013        | FY-2122              | May                    | 2022              | 2557.00                   |
    #
    | 1619-AS-2122-10017505-3_6  | 1619-020        | FY-2122              | November               | 2021              | 2748.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-020        | FY-2122              | January                | 2022              | 4671.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-020        | FY-2122              | April                  | 2022              | 5841.00                   |
    #
    | 1619-AS-2122-10017505-3_6  | 1619-021        | FY-2122              | February               | 2022              | 6000.00                   |
    | 1619-AS-2122-10017505-3_6  | 1619-021        | FY-2122              | March                  | 2022              | 4000.00                   |
    #
    | 1619-AS-2122-10017505-3_6  | 1619-024        | FY-2122              | October                | 2021              | 10000.00                  |

   



    # Populate the stub with NMSS (01GFE) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017505 | NMSS-AY-2122-Contract-Provider-10017505-3_3           | 3_3            | NMSS                        | AY-2122            | 8910.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10017505-3_3  | 3_3                    | NMSS-AY-2122-Contract-Provider-10017505-3_3           | 10017505      | Furth        | 01GFE           | 8910.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10017505-3_3  | NMSS-003        | 5653.00          | Payment         |
    | NMSS-AY-2122-10017505-3_3  | NMSS-007        | 3257.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10017505-3_3  | NMSS-003        | FY-2122              | October                | 2021              | 5653.00                   |
    | NMSS-AY-2122-10017505-3_3  | NMSS-007        | FY-2122              | June                   | 2022              | 3257.00                   |





    # Consume stub data
 
    # Change the date 
    Given the override date is '15/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017505 | 10017505 Co Ltd  | 1619-AS-2122-Contract-Provider-10017505-3_6             | 3_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 119182.00   | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |
    | 10017505 | 10017505 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017505-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 8910.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Capture the Release Group parameter value (J127)
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 128092.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017505 | 1619-AS-2122-Contract-Provider-10017505-3_6             | 3_6            | AS-2122 | 1619                        | 119182.00   | [CofG_College] |
    | 10017505 | NMSS-AY-2122-Contract-Provider-10017505-3_3             | 3_3            | AY-2122 | NMSS                        | 8910.00     | [CofG_College] |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '17/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 128092.00       |

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017505 | 10017505 Co Ltd  | 1619-AS-2122-Contract-Provider-10017505-3_6             | 3_6            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 119182.00   | EDSK-505      | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |
    | 10017505 | 10017505 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017505-3_3             | 3_3            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Released          | Released          | 8910.00     | EDSK-505      | 2                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017505 | 1619-AS-2122-Contract-Provider-10017505-3_6             | 3_6            | AS-2122 | 1619                        | 119182.00   | [CofG_College] |
    | 10017505 | NMSS-AY-2122-Contract-Provider-10017505-3_3             | 3_3            | AY-2122 | NMSS                        | 8910.00     | [CofG_College] |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017505-3_6             | EDSK-505     | 2               | 1                  | Yes            |
    | NMSS-AY-2122-Contract-Provider-10017505-3_3             | EDSK-505     | 2               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017505 | EDSK-505           | 2                     | 1                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017505 | EDSK-505           | 2                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017505 | EDSK-505           | 1                     | 1                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017505 | EDSK-505           | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017505 | ESFA-505           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017505 | EDSK-505           | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 169022.00     | 2                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017505 Co Ltd  | Active | Document Management Team  | 38910.00               |
    | 10017505 | ESFA-505           | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017505 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017505 | EDSK-505           | 16TR-505              | ?                             | 40930.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 16-18TRN      | 16-18TRN2122        | Contract Allocation   | 0                        |
    | 10017505 | EDSK-505           | [AllocRef_16ED]       | ?                             | 128092.00       | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | 38910.00                 |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                            | DeliverableDescription   |
    | EDSK-505       | 16TR-505        | 1               | 40930.00  | 3138.00  | 3721.00  | 3706.00  | 1033.00  | 5351.00  | 4482.00  | 3390.00  | 1982.00  | 5223.00  | 2901.00  | 1714.00  | 4289.00  | Total 16-18 Traineeships Funding               |                          | 
    | EDSK-505       | 16TR-505        | 2               | 23312.00  | 2817.00  | 2160.00  | 3148.00  | 184.00   | 2659.00  | 2635.00  | 1725.00  | 752.00   | 2689.00  | 579.00   | 1473.00  | 2491.00  | 16-18 Traineeships Programme Funding           |                          | 
    | EDSK-505       | 16TR-505        | 3               | 17618.00  | 321.00   | 1561.00  | 558.00   | 849.00   | 2692.00  | 1847.00  | 1665.00  | 1230.00  | 2534.00  | 2322.00  | 241.00   | 1798.00  | 16-18 Traineeships Bursary Funding             |                          | 
    #
    | EDSK-505       | [AllocRef_16ED] | 20              | 24476.00  | 2797.00  | 5000.00  | 0.00     | 0.00     | 0.00     | 4517.00  | 0.00     | 4421.00  | 2583.00  | 0.00     | 0.00     | 5158.00  | 16-19 Programme Funding                                    |                          |
    | EDSK-505       | [AllocRef_16ED] | 33              | 8139.00   | 0.00     | 0.00     | 2122.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2474.00  | 3543.00  | 0.00     | 0.00     | 0.00     | Residential Bursary Fund                                   |                          |
    | EDSK-505       | [AllocRef_16ED] | 85              | 20383.00  | 3051.00  | 0.00     | 0.00     | 2821.00  | 0.00     | 4573.00  | 2255.00  | 0.00     | 4146.00  | 0.00     | 3537.00  | 0.00     | Residential Support Scheme                                 |                          |
    | EDSK-505       | [AllocRef_16ED] | 112             | 11678.00  | 3862.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5647.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2169.00  | 16-19 Capacity and Delivery                                |                          |
    | EDSK-505       | [AllocRef_16ED] | 51              | 7240.00   | 0.00     | 5000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2240.00  | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Sporting Excellence              |                          |
    | EDSK-505       | [AllocRef_16ED] | 18              | 14006.00  | 0.00     | 0.00     | 0.00     | 5516.00  | 0.00     | 0.00     | 5933.00  | 0.00     | 0.00     | 2557.00  | 0.00     | 0.00     | Maintained Special SSF Bursary Support                     |                          |
    | EDSK-505       | [AllocRef_16ED] | 52              | 13260.00  | 0.00     | 0.00     | 0.00     | 2748.00  | 0.00     | 4671.00  | 0.00     | 0.00     | 5841.00  | 0.00     | 0.00     | 0.00     | Alternative Completions - Sea Fishing                      |                          |
    | EDSK-505       | [AllocRef_16ED] | 53              | 10000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6000.00  | 4000.00  | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Creative Sector                  |                          |
    | EDSK-505       | [AllocRef_16ED] | 149             | 10000.00  | 0.00     | 0.00     | 10000.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 High Value Courses School and College Leavers Uplift |                          |
    | EDSK-505       | [AllocRef_16ED] | 13              | 5653.00   | 0.00     | 0.00     | 5653.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF Bursary Funds                                          |                          |
    | EDSK-505       | [AllocRef_16ED] | 135             | 3257.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3257.00  | 0.00     | Teachers Pension Scheme (NMSS)                             |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '168' deliverable period rows in CRM linked to the latest version of contract 'EDSK-505'

    # Check the contents of the Appendices (SoF and 2xFA)
    And   the file named '10017505_EDSK-505_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017505 Co Ltd UKPRN: 10017505
    Master Contract Number: ESFA-505
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 18 Traineeships 16TR-505 £26,803 £14,127 £40,930
    16 to 19 Education [AllocRef_16ED] £95,301 £32,791 £128,092
    Total Funding for this contract: £169,022
    Summary of Funding – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017505 Co Ltd UKPRN: 10017505
    Master Contract Number: ESFA-505 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Programme Funding £24,476 £2,797.00 £5,000.00 £0.00 £0.00 £0.00 £4,517.00 £0.00 £4,421.00 £2,583.00 £0.00 £0.00 £5,158.00
    16-19 Capacity and Delivery £11,678 £3,862.00 £0.00 £0.00 £0.00 £0.00 £0.00 £5,647.00 £0.00 £0.00 £0.00 £0.00 £2,169.00
    SSF Bursary Funds £5,653 £0.00 £0.00 £5,653.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Maintained Special SSF Bursary Support £14,006 £0.00 £0.00 £0.00 £5,516.00 £0.00 £0.00 £5,933.00 £0.00 £0.00 £2,557.00 £0.00 £0.00
    Residential Bursary Fund £8,139 £0.00 £0.00 £2,122.00 £0.00 £0.00 £0.00 £0.00 £2,474.00 £3,543.00 £0.00 £0.00 £0.00
    Residential Support Scheme £20,383 £3,051.00 £0.00 £0.00 £2,821.00 £0.00 £4,573.00 £2,255.00 £0.00 £4,146.00 £0.00 £3,537.00 £0.00
    Alternative Completions - Sporting Excellence £7,240 £0.00 £5,000.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,240.00 £0.00 £0.00 £0.00 £0.00
    Alternative Completions - Sea Fishing £13,260 £0.00 £0.00 £0.00 £2,748.00 £0.00 £4,671.00 £0.00 £0.00 £5,841.00 £0.00 £0.00 £0.00
    Alternative Completions - Creative Sector £10,000 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £6,000.00 £4,000.00 £0.00 £0.00 £0.00 £0.00
    Teachers Pension Scheme (NMSS) £3,257 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,257.00 £0.00
    16-19 High Value Courses School and College £10,000 £0.00 £0.00 £10,000.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Leavers Uplift
    Total Funding £128,092 £9,710.00 £10,000.00 £17,775.00 £11,085.00 £0.00 £13,761.00 £19,835.00 £13,135.00 £16,113.00 £2,557.00 £6,794.00 £7,327.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-505 v2   
    """

    # There shouldn't be a T&C doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """

    # There shouldn't be any Sch 1 docs
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # There shouldn't be a Sch2 for 16-18 Traineeships
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    """

    # There shouldn't be a Sch3ON doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017505_EDSK-505_v2.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A505_2.1.pdf'

    # Wait for row to arrive then update the CreatedDate (J106)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details are present in the ContractManagement.CreatedContract table 
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-505       | 2                     | 1                        | 2021-07-17 09:12:35.000 |





    # Publish and approve the contract (32385)

    # Change the date 
    Given the override date is '19/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-505' and ContractNumber 'EDSK-505' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-505' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017505 | EDSK-505           | 2                     | 1                        | Approved         | Approved           | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017505 | EDSK-505           | 2                     | 0                        | Superseded Draft | ?                  | ?             | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017505 | EDSK-505           | 1                     | 1                        | Replaced         | Approved           | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017505 | EDSK-505           | 1                     | 0                        | Superseded Draft | ?                  | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017505 | ESFA-505           | 1                     | 0                        | Draft            | ?                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
  
    # Check the non-zero PROFILE subnominal aggregations in PaaS for 1619ED2122
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2203000         | 1619ED2122                 | 202108               | PROFILE         | CM             | False       | 2797.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2203023         | 1619ED2122                 | 202108               | PROFILE         | CM             | False       | 3862.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2206025         | 1619ED2122                 | 202108               | PROFILE         | CM             | False       | 3051.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2202032         | 1619ED2122                 | 202109               | PROFILE         | CM             | False       | 5000.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2203000         | 1619ED2122                 | 202109               | PROFILE         | CM             | False       | 5000.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2203072         | 1619ED2122                 | 202110               | PROFILE         | CM             | False       | 10000.00        |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2206020         | 1619ED2122                 | 202110               | PROFILE         | CM             | False       | 2122.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2206037         | 1619ED2122                 | 202110               | PROFILE         | CM             | False       | 5653.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2202033         | 1619ED2122                 | 202111               | PROFILE         | CM             | False       | 2748.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2206025         | 1619ED2122                 | 202111               | PROFILE         | CM             | False       | 2821.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2206029         | 1619ED2122                 | 202111               | PROFILE         | CM             | False       | 5516.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2202033         | 1619ED2122                 | 202201               | PROFILE         | CM             | False       | 4671.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2203000         | 1619ED2122                 | 202201               | PROFILE         | CM             | False       | 4517.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2206025         | 1619ED2122                 | 202201               | PROFILE         | CM             | False       | 4573.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2202034         | 1619ED2122                 | 202202               | PROFILE         | CM             | False       | 6000.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2203023         | 1619ED2122                 | 202202               | PROFILE         | CM             | False       | 5647.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2206025         | 1619ED2122                 | 202202               | PROFILE         | CM             | False       | 2255.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2206029         | 1619ED2122                 | 202202               | PROFILE         | CM             | False       | 5933.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2202032         | 1619ED2122                 | 202203               | PROFILE         | CM             | False       | 2240.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2202034         | 1619ED2122                 | 202203               | PROFILE         | CM             | False       | 4000.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2203000         | 1619ED2122                 | 202203               | PROFILE         | CM             | False       | 4421.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2206020         | 1619ED2122                 | 202203               | PROFILE         | CM             | False       | 2474.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2202033         | 1619ED2122                 | 202204               | PROFILE         | CM             | False       | 5841.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2203000         | 1619ED2122                 | 202204               | PROFILE         | CM             | False       | 2583.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2206020         | 1619ED2122                 | 202204               | PROFILE         | CM             | False       | 3543.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2206025         | 1619ED2122                 | 202204               | PROFILE         | CM             | False       | 4146.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2206029         | 1619ED2122                 | 202205               | PROFILE         | CM             | False       | 2557.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2206025         | 1619ED2122                 | 202206               | PROFILE         | CM             | False       | 3537.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2601008         | 1619ED2122                 | 202206               | PROFILE         | CM             | False       | 3257.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2203000         | 1619ED2122                 | 202207               | PROFILE         | CM             | False       | 5158.00         |
    | 10017505 | ORG0017505 | [AllocRef_16ED]   | 2203023         | 1619ED2122                 | 202207               | PROFILE         | CM             | False       | 2169.00         |

    # Test CRM details against same in ContractManagement feed (30447)"
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed





    # Execute a NON-FINANCIAL amendment on EDSK-505 to create Draft v3.0 from Approved v2.1 

    # Change the date
    Given the override date is '21/07/2021'

    # Simulate a change of template by changing the Sch1 template timestamp to a date AFTER the last contract was created
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | EDSK2122_S1_1619ED_COLLEGE_2021-08-01.docx      | 2021-07-21 12:12:12.000 | 

    # Issue a non-financial VARIATION amendment on v1 to create v2.
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '1' of contract 'EDSK-505' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '1' of contract 'EDSK-505' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017505 | EDSK-505           | 3                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017505 | EDSK-505           | 2                     | 1                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017505 | EDSK-505           | 2                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017505 | EDSK-505           | 1                     | 1                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017505 | EDSK-505           | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017505 | ESFA-505           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Check the contents of the Appendices (SoF because we always get this plus Sch1 because the template timestamp was after that used on previous approved version)
    And   the file named '10017505_EDSK-505_v3.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    """   
    
    # There shouldn't be a T&C doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """
    
    # There shouldn't be a Sch 2 doc for 16-18 Traineeships
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    """
    
    # There shouldn't be a Sch 2 doc for 16-19 Education
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2 – 16 TO 19 EDUCATION
    """

    # There shouldn't be a Funding Agreement for 16-18 Traineeships
    And   the pdf file does not contain the following text
    """
    Funding Agreement – 16 to 18 Traineeships
    """

    # There shouldn't be a Funding Agreement for 16-19 Education
    And   the pdf file does not contain the following text
    """
    Funding Agreement – 16 to 19 Education
    """

    # There shouldn't be a Sch3ON doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017505_EDSK-505_v3.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A505_3.0.pdf'

    # Wait for row to arrive then update the CreatedDate (J106)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details are present in the ContractManagement.CreatedContract table 
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-505       | 3                     | 0                        | 2021-07-21 09:12:35.000 |





    # New version of NMSS with same total value but with financials rearranged

    # Change the date
    Given the override date is '23/07/2021'

    # Clear down the CFS stub 
    And   there is no data in the CFS stub

    # Populate the stub with NMSS (01GFE) data

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017505 | NMSS-AY-2122-Contract-Provider-10017505-3_4           | 3_4            | NMSS                        | AY-2122            | 8910.00           |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10017505-3_4  | 3_4                    | NMSS-AY-2122-Contract-Provider-10017505-3_4           | 10017505      | Furth        | 01GFE           | 8910.00                   |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10017505-3_4  | NMSS-003        | 3257.00          | Payment         |
    | NMSS-AY-2122-10017505-3_4  | NMSS-007        | 5653.00          | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10017505-3_4  | NMSS-003        | FY-2122              | June                   | 2022              | 3257.00                   |
    | NMSS-AY-2122-10017505-3_4  | NMSS-007        | FY-2122              | October                | 2021              | 5653.00                   |




    # Consume stub data
 
    # Change the date 
    Given the override date is '25/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017505 | 10017505 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017505-3_4             | 3_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 8910.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Capture the Release Group parameter value (J127)
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 8910.00         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017505 | NMSS-AY-2122-Contract-Provider-10017505-3_4             | 3_4            | AY-2122 | NMSS                        | 8910.00     | [CofG_College] |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '27/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 8910.00         |

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017505 | 10017505 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017505-3_4             | 3_4            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | NMSS                        | 16-19ED2122     | Released          | Released          | 8910.00     | EDSK-505      | 3                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017505 | NMSS-AY-2122-Contract-Provider-10017505-3_4             | 3_4            | AY-2122 | NMSS                        | 8910.00     | [CofG_College] |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2122-Contract-Provider-10017505-3_4             | EDSK-505     | 3               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017505 | EDSK-505           | 3                     | 1                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017505 | EDSK-505           | 3                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017505 | EDSK-505           | 2                     | 1                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017505 | EDSK-505           | 2                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017505 | EDSK-505           | 1                     | 1                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017505 | EDSK-505           | 1                     | 0                        | Superseded Draft | ?                                         | ?             | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017505 | ESFA-505           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017505 | EDSK-505           | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 169022.00     | 3                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | Variation     | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017505 Co Ltd  | Active | Document Management Team  | 0.00                   |
    | 10017505 | ESFA-505           | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017505 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017505 | EDSK-505           | 16TR-505              | ?                             | 40930.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 16-18TRN      | 16-18TRN2122        | Contract Allocation   | 0                        |
    | 10017505 | EDSK-505           | [AllocRef_16ED]       | ?                             | 128092.00       | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | 0.00                     |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                            | DeliverableDescription   |
    | EDSK-505       | 16TR-505        | 1               | 40930.00  | 3138.00  | 3721.00  | 3706.00  | 1033.00  | 5351.00  | 4482.00  | 3390.00  | 1982.00  | 5223.00  | 2901.00  | 1714.00  | 4289.00  | Total 16-18 Traineeships Funding                           |                          | 
    | EDSK-505       | 16TR-505        | 2               | 23312.00  | 2817.00  | 2160.00  | 3148.00  | 184.00   | 2659.00  | 2635.00  | 1725.00  | 752.00   | 2689.00  | 579.00   | 1473.00  | 2491.00  | 16-18 Traineeships Programme Funding                       |                          | 
    | EDSK-505       | 16TR-505        | 3               | 17618.00  | 321.00   | 1561.00  | 558.00   | 849.00   | 2692.00  | 1847.00  | 1665.00  | 1230.00  | 2534.00  | 2322.00  | 241.00   | 1798.00  | 16-18 Traineeships Bursary Funding                         |                          | 
    #
    | EDSK-505       | [AllocRef_16ED] | 20              | 24476.00  | 2797.00  | 5000.00  | 0.00     | 0.00     | 0.00     | 4517.00  | 0.00     | 4421.00  | 2583.00  | 0.00     | 0.00     | 5158.00  | 16-19 Programme Funding                                    |                          |
    | EDSK-505       | [AllocRef_16ED] | 33              | 8139.00   | 0.00     | 0.00     | 2122.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2474.00  | 3543.00  | 0.00     | 0.00     | 0.00     | Residential Bursary Fund                                   |                          |
    | EDSK-505       | [AllocRef_16ED] | 85              | 20383.00  | 3051.00  | 0.00     | 0.00     | 2821.00  | 0.00     | 4573.00  | 2255.00  | 0.00     | 4146.00  | 0.00     | 3537.00  | 0.00     | Residential Support Scheme                                 |                          |
    | EDSK-505       | [AllocRef_16ED] | 112             | 11678.00  | 3862.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5647.00  | 0.00     | 0.00     | 0.00     | 0.00     | 2169.00  | 16-19 Capacity and Delivery                                |                          |
    | EDSK-505       | [AllocRef_16ED] | 51              | 7240.00   | 0.00     | 5000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2240.00  | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Sporting Excellence              |                          |
    | EDSK-505       | [AllocRef_16ED] | 18              | 14006.00  | 0.00     | 0.00     | 0.00     | 5516.00  | 0.00     | 0.00     | 5933.00  | 0.00     | 0.00     | 2557.00  | 0.00     | 0.00     | Maintained Special SSF Bursary Support                     |                          |
    | EDSK-505       | [AllocRef_16ED] | 52              | 13260.00  | 0.00     | 0.00     | 0.00     | 2748.00  | 0.00     | 4671.00  | 0.00     | 0.00     | 5841.00  | 0.00     | 0.00     | 0.00     | Alternative Completions - Sea Fishing                      |                          |
    | EDSK-505       | [AllocRef_16ED] | 53              | 10000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6000.00  | 4000.00  | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Creative Sector                  |                          |
    | EDSK-505       | [AllocRef_16ED] | 149             | 10000.00  | 0.00     | 0.00     | 10000.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 High Value Courses School and College Leavers Uplift |                          |
    | EDSK-505       | [AllocRef_16ED] | 135             | 5653.00   | 0.00     | 0.00     | 5653.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Teachers Pension Scheme (NMSS)                             |                          |
    | EDSK-505       | [AllocRef_16ED] | 13              | 3257.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3257.00  | 0.00     | SSF Bursary Funds                                          |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '168' deliverable period rows in CRM linked to the latest version of contract 'EDSK-505'

    # Check the contents of the Appendices (SoF, Sch1 for 1619ED because of template change, FA for 1619ED because of change to financials)
    And   the file named '10017505_EDSK-505_v3.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017505 Co Ltd UKPRN: 10017505
    Master Contract Number: ESFA-505
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 18 Traineeships 16TR-505 £26,803 £14,127 £40,930
    16 to 19 Education [AllocRef_16ED] £95,301 £32,791 £128,092
    Total Funding for this contract: £169,022
    Summary of Funding – Page 1
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2021) – Page 11

    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017505 Co Ltd UKPRN: 10017505
    Master Contract Number: ESFA-505 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Programme Funding £24,476 £2,797.00 £5,000.00 £0.00 £0.00 £0.00 £4,517.00 £0.00 £4,421.00 £2,583.00 £0.00 £0.00 £5,158.00
    16-19 Capacity and Delivery £11,678 £3,862.00 £0.00 £0.00 £0.00 £0.00 £0.00 £5,647.00 £0.00 £0.00 £0.00 £0.00 £2,169.00
    SSF Bursary Funds £3,257 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,257.00 £0.00
    Maintained Special SSF Bursary Support £14,006 £0.00 £0.00 £0.00 £5,516.00 £0.00 £0.00 £5,933.00 £0.00 £0.00 £2,557.00 £0.00 £0.00
    Residential Bursary Fund £8,139 £0.00 £0.00 £2,122.00 £0.00 £0.00 £0.00 £0.00 £2,474.00 £3,543.00 £0.00 £0.00 £0.00
    Residential Support Scheme £20,383 £3,051.00 £0.00 £0.00 £2,821.00 £0.00 £4,573.00 £2,255.00 £0.00 £4,146.00 £0.00 £3,537.00 £0.00
    Alternative Completions - Sporting Excellence £7,240 £0.00 £5,000.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,240.00 £0.00 £0.00 £0.00 £0.00
    Alternative Completions - Sea Fishing £13,260 £0.00 £0.00 £0.00 £2,748.00 £0.00 £4,671.00 £0.00 £0.00 £5,841.00 £0.00 £0.00 £0.00
    Alternative Completions - Creative Sector £10,000 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £6,000.00 £4,000.00 £0.00 £0.00 £0.00 £0.00
    Teachers Pension Scheme (NMSS) £5,653 £0.00 £0.00 £5,653.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    16-19 High Value Courses School and College £10,000 £0.00 £0.00 £10,000.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Leavers Uplift
    Total Funding £128,092 £9,710.00 £10,000.00 £17,775.00 £11,085.00 £0.00 £13,761.00 £19,835.00 £13,135.00 £16,113.00 £2,557.00 £6,794.00 £7,327.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-505 v3
    """

    # There shouldn't be a T&C doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """

    # There shouldn't be a Sch 2 doc for 16-18 Traineeships
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    """

    # There shouldn't be a Sch3ON doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017505_EDSK-505_v3.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A505_3.1.pdf'

    # Wait for row to arrive then update the CreatedDate (J106)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details are present in the ContractManagement.CreatedContract table 
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-505       | 3                     | 1                        | 2021-07-27 09:12:35.000 |


    # Tidy Up
    And   the override date is reset

      