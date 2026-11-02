Feature: UpdateDraftContract 32941

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A060 Create a 2122 EDSK contract with an ALLB alloc 'Awaiting Documentation. Import then release a 1619ED CFS Funding Allocation. Publish and approve contract. Check docs CRM, FA and FA Workflow History
    Given there are no allocations marked as Under Termination for UKPRN '10017060' 
    And   there are no terminated or closed allocations for UKPRN '10017060' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017060' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017060' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017080' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017060' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLB-060      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLB-060      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLB2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-060       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017060'

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
    Given there is no Organisation data for UKPRN '10017060' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017060 Co Ltd' with UKPRN '10017060' and OrgId 'ORG0017060' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017060' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017060 | 117060 | 10017060 Co Ltd | 0              | Provider Under Change | Yes           | AA017060      | ?             | 12-50 Kingsgate Road   | Kingston upon Thames   | Surrey                 | ?                      | ?                      | ?                      | KT2 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017060 |




    # Change the date
    Given the override date is '01/07/2021'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType                             | Period | CRMIntent    | OrgId      |
    | 10017060 | 10017060 Co Ltd      | ESFA-060             | EDSK-060       | 1                     | 01/08/2021        | 31/07/2022      | 20480.00      |                       | Conditions of Funding (Grant) (College)  | 2122   | New          | ORG0017060 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName     | UoPCode    | AllocationDescription    | CRMIntent    | DeliveryOrg |
    | 10017060 | EDSK-060       | ALLB-060      | ALLB              | ALLB2122                | AY                      | 01/08/2021          | 31/07/2022        | 20480.00        |             |            |                          | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017060 | EDSK-060       | ALLB-060      | 1               | 0                     | 20480.00  | 11725.00  | 8755.00   | 1348.00  | 690.00   | 1679.00  | 2415.00  | 1189.00  | 1165.00  | 256.00   | 2983.00  | 1219.00  | 2810.00  | 3704.00  | 1022.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-060       | 1                     | 0                        | 2021-07-01 09:12:35.000 |





    # Funding Allocation

    # Change the date 
    Given the override date is '16/07/2021'
    
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017060'
    And   there is no Funding Allocation data in CRM for UKPRN '10017060'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017060' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) |





    # Populate the stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017060 | 1619-AS-2122-Contract-Provider-10017060-1_0           | 1_0            | 1619                        | AS-2122            | 66736.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017060-1_0  | 1_0                    | 1619-AS-2122-Contract-Provider-10017060-1_0           | 10017060      | Furth        | 01GFE           | 66736.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017060-1_0  | 1619-003        | 18913.00         | Payment         |
    | 1619-AS-2122-10017060-1_0  | 1619-006        | 16152.00         | Payment         |
    | 1619-AS-2122-10017060-1_0  | 1619-007        | 13404.00         | Payment         |
    | 1619-AS-2122-10017060-1_0  | 1619-013        | 18267.00         | Payment         |

    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017060-1_0  | 1619-003        | FY-2122              | September              | 2021              | 3067.00                   |
    | 1619-AS-2122-10017060-1_0  | 1619-003        | FY-2122              | November               | 2021              | 3932.00                   |
    | 1619-AS-2122-10017060-1_0  | 1619-003        | FY-2122              | February               | 2022              | 3462.00                   |
    | 1619-AS-2122-10017060-1_0  | 1619-003        | FY-2122              | April                  | 2022              | 4872.00                   |
    | 1619-AS-2122-10017060-1_0  | 1619-003        | FY-2122              | June                   | 2022              | 3580.00                   |
    #
    | 1619-AS-2122-10017060-1_0  | 1619-006        | FY-2122              | September              | 2021              | 2291.00                   |
    | 1619-AS-2122-10017060-1_0  | 1619-006        | FY-2122              | November               | 2021              | 4247.00                   |
    | 1619-AS-2122-10017060-1_0  | 1619-006        | FY-2122              | February               | 2022              | 4257.00                   |
    | 1619-AS-2122-10017060-1_0  | 1619-006        | FY-2122              | April                  | 2022              | 2350.00                   |
    | 1619-AS-2122-10017060-1_0  | 1619-006        | FY-2122              | June                   | 2022              | 3007.00                   |
    #
    | 1619-AS-2122-10017060-1_0  | 1619-007        | FY-2122              | November               | 2021              | 2967.00                   |
    | 1619-AS-2122-10017060-1_0  | 1619-007        | FY-2122              | February               | 2022              | 5403.00                   |
    | 1619-AS-2122-10017060-1_0  | 1619-007        | FY-2122              | June                   | 2022              | 5034.00                   |
    #
    | 1619-AS-2122-10017060-1_0  | 1619-013        | FY-2122              | October                | 2021              | 2461.00                   |
    | 1619-AS-2122-10017060-1_0  | 1619-013        | FY-2122              | December               | 2021              | 3049.00                   |
    | 1619-AS-2122-10017060-1_0  | 1619-013        | FY-2122              | March                  | 2022              | 3161.00                   |
    | 1619-AS-2122-10017060-1_0  | 1619-013        | FY-2122              | May                    | 2022              | 3887.00                   |
    | 1619-AS-2122-10017060-1_0  | 1619-013        | FY-2122              | July                   | 2022              | 5709.00                   |
 




    # Consume stub data
 
    # Change the date 
    Given the override date is '17/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017060 | 10017060 Co Ltd  | 1619-AS-2122-Contract-Provider-10017060-1_0             | 1_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 66736.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2122-Contract-Provider-10017060-1_0             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 66736.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017060 | 1619-AS-2122-Contract-Provider-10017060-1_0             | 1_0            | AS-2122 | 1619                        | 66736.00    | [CofG_College] |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '18/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 66736.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017060' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017060' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017060 | 10017060 Co Ltd  | 1619-AS-2122-Contract-Provider-10017060-1_0             | 1_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Released          | Released          | 66736.00    | EDSK-060      | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017060-1_0             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017060-1_0             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   |
    | 10017060 | 1619-AS-2122-Contract-Provider-10017060-1_0             | 1_0            | AS-2122 | 1619                        | 66736.00    | [CofG_College] |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017060-1_0             | EDSK-060     | 1               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017060' for FundingType 'EDSK' and period '2122'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017060 | EDSK-060           | 1                     | 1                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017060 | ESFA-060           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM (£20,480 + £66,736 = £87,216)
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017060 | EDSK-060           | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 87216.00      | 1                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | FCS2 TEST     | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | ESFA-060           | AY2122 | ?               | 10017060 Co Ltd  | Active | Document Management Team  |
    | 10017060 | ESFA-060           | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017060 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017060 | EDSK-060           | ALLB-060              | ?                             | 20480.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | ALLB          | ALLB2122            | Contract Allocation   |
    | 10017060 | EDSK-060           | [AllocRef_16ED]       | ?                             | 66736.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | EDSK-060       | ALLB-060        | 1               | 20480.00  | 1348.00  | 690.00   | 1679.00  | 2415.00  | 1189.00  | 1165.00  | 256.000  | 2983.00  | 1219.00  | 2810.00  | 3704.00  | 1022.00  | Total Advanced Learner Loans Bursary Funding   |                          |
    #
    | EDSK-060       | [AllocRef_16ED] | 33              | 18913.00  | 0.00     | 3067.00  | 0.00     | 3932.00  | 0.00     | 0.00     | 3462.00  | 0.00     | 4872.00  | 0.00     | 3580.00  | 0.00     | Residential Bursary Fund                       |                          |
    | EDSK-060       | [AllocRef_16ED] | 22              | 16152.00  | 0.00     | 2291.00  | 0.00     | 4247.00  | 0.00     | 0.00     | 4257.00  | 0.00     | 2350.00  | 0.00     | 3007.00  | 0.00     | 16-19 High Needs Element 2                     |                          |
    | EDSK-060       | [AllocRef_16ED] | 112             | 13404.00  | 0.00     | 0.00     | 0.00     | 2967.00  | 0.00     | 0.00     | 5403.00  | 0.00     | 0.00     | 0.00     | 5034.00  | 0.00     | 16-19 Capacity and Delivery                    |                          |
    | EDSK-060       | [AllocRef_16ED] | 18              | 18267.00  | 0.00     | 0.00     | 2461.00  | 0.00     | 3049.00  | 0.00     | 0.00     | 3161.00  | 0.00     | 3887.00  | 0.00     | 5709.00  | Maintained Special SSF Bursary Support         |                          |


    # Contract status is now at 'Awaiting Documentation'

    # Check the contents of the Appendices
    Then  the file named '10017060_EDSK-060_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017060 Co Ltd UKPRN: 10017060
    Master Contract Number: ESFA-060
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    Advanced Learner Loans Bursary ALLB-060 £11,725 £8,755 £20,480
    16 to 19 Education [AllocRef_16ED] £38,297 £28,439 £66,736
    Total Funding for this contract: £87,216
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017060 Co Ltd
    Advanced Learner Loans
    Funding for
    16 to 19 Education
    Master Agreement Number ESFA-060
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017060 Co Ltd THE SECRETARY OF STATE FOR
    12-50 Kingsgate Road EDUCATION
    Kingston upon Thames DEPARTMENT FOR EDUCATION
    Surrey AND 20 GREAT SMITH STREET
    KT2 5AA LONDON
    SW1P 3BT
    Company No: AA017060
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 79
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2021) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2021) – Page 9

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2021) – Page 11

    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2021) – Page 1
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2021) – Page 2

    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017060 Co Ltd UKPRN: 10017060
    Master Contract Number: ESFA-060 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: ALLB-060
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Advanced Learner Loans Bursary Funding £20,480 £1,348 £690 £1,679 £2,415 £1,189 £1,165 £256 £2,983 £1,219 £2,810 £3,704 £1,022
    Total Funding £20,480 £1,348 £690 £1,679 £2,415 £1,189 £1,165 £256 £2,983 £1,219 £2,810 £3,704 £1,022
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLB-060 – Page 1 Ref (for internal use only):  EDSK-060 v1

    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017060 Co Ltd UKPRN: 10017060
    Master Contract Number: ESFA-060 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 High Needs Element 2 £16,152 £0.00 £2,291.00 £0.00 £4,247.00 £0.00 £0.00 £4,257.00 £0.00 £2,350.00 £0.00 £3,007.00 £0.00
    16-19 Capacity and Delivery £13,404 £0.00 £0.00 £0.00 £2,967.00 £0.00 £0.00 £5,403.00 £0.00 £0.00 £0.00 £5,034.00 £0.00
    Maintained Special SSF Bursary Support £18,267 £0.00 £0.00 £2,461.00 £0.00 £3,049.00 £0.00 £0.00 £3,161.00 £0.00 £3,887.00 £0.00 £5,709.00
    Residential Bursary Fund £18,913 £0.00 £3,067.00 £0.00 £3,932.00 £0.00 £0.00 £3,462.00 £0.00 £4,872.00 £0.00 £3,580.00 £0.00
    Total Funding £66,736 £0.00 £5,358.00 £2,461.00 £11,146.00 £3,049.00 £0.00 £13,122.00 £3,161.00 £7,222.00 £3,887.00 £11,621.00 £5,709.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-060 v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017060_EDSK-060_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A060.pdf'

    # Check the deliverable count in CRM [(1x12)+(4x12) = 60]
    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract 'EDSK-060'

    # Check the current state of the Tasks for this contract  ?? Problem here: Will there be one or two Tasks ??
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017060'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017060 - 10017060 Co Ltd Awaiting documentation  | ALLB-060        | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017060 | ESFA-060           | EDSK-060       | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017060 | ESFA-060           | EDSK-060       | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017060 | ESFA-060           | EDSK-060       | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |




    # Publish and approve the contract (32385)

    # Change the date
    Given the override date is '26/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-060'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-060' and ContractNumber 'EDSK-060' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-060' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017060 | EDSK-060           | 1                     | 1                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017060 | ESFA-060           | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the deliverable count in CRM [(4x12)+(4x12) = 60]
    Then  there are '96' deliverable period rows in CRM linked to the latest version of contract 'EDSK-060'

    # Check the CRM Funding Allocations data
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017060 | 10017060 Co Ltd  | 1619-AS-2122-Contract-Provider-10017060-1_0             | 1_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (College)  | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 66736.00    | EDSK-060      | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A061 Create a 2122 EDSK contract with 16TR alloc 'In Review'. Import and release 1619 and NMSS Funding Allocations. Publish and approve contract. Check docs, CRM, FA, FA Workflow History and Feed
    Given there are no allocations marked as Under Termination for UKPRN '10017061' 
    And   there are no terminated or closed allocations for UKPRN '10017061' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017061' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017061' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017061' 

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017061' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-061      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-061      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2122      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-061       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017061'

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
    Given there is no Organisation data for UKPRN '10017061' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017061 Co Ltd' with UKPRN '10017061' and OrgId 'ORG0017061' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017061' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017061 | 117061 | 10017061 Co Ltd | 0              | Active                | Yes           | AA017061      | ?             | 91 Rupert Road         | Liverpool              | ?                      | ?                      | ?                      | Merseyside             | L36 9TD   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017061 |




    # Change the date
    Given the override date is '01/07/2021'

    # Create contract (NMSS)
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017061 | 10017061 Co Ltd      | ESFA-061             | EDSK-061       | 1                     | 01/08/2021        | 31/07/2022      | 47299.00      |                                       | Conditions of Funding (Grant) (NMSS)       | 2122   | New          | ORG0017061 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017061 | EDSK-061       | 16TR-061      | 16-18TRN          | 16-18TRN2122            | AY                      | 01/08/2021          | 31/07/2022        | 47299.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017061 | EDSK-061       | 16TR-061      | 1               | 0                     | 47299.00  | 31049.00  | 16250.00  | 2743.00  | 3326.00  | 3312.00  | 4340.00  | 4957.00  | 4087.00  | 2996.00  | 5288.00  | 4828.00  | 6207.00  | 1320.00  | 3895.00  | Total 16-18 Traineeships Funding                                | New          |             | 
    | 10017061 | EDSK-061       | 16TR-061      | 2               | 1                     | 23150.00  | 15972.00  | 7178.00   | 1878.00  | 1221.00  | 2210.00  | 2946.00  | 1720.00  | 1696.00  | 787.00   | 3514.00  | 1750.00  | 3341.00  | 534.00   | 1553.00  | 16-18 Traineeships Programme Funding                            | New          |             | 
    | 10017061 | EDSK-061       | 16TR-061      | 3               | 1                     | 24149.00  | 15077.00  | 9072.00   | 865.00   | 2105.00  | 1102.00  | 1394.00  | 3237.00  | 2391.00  | 2209.00  | 1774.00  | 3078.00  | 2866.00  | 786.00   | 2342.00  | 16-18 Traineeships Bursary Funding                              | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-061       | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'In Review'
    And   the contract sub-status is updated to 'In Review' on the latest version of contract 'EDSK-061'





    # Funding Allocation

    # Change the date 
    Given the override date is '04/07/2021'
    
    And   there is no Funding Allocation Workflow History data in CRM for UKPRN '10017061'
    And   there is no Funding Allocation data in CRM for UKPRN '10017061'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017061' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (HEI)     |





    # Populate the stub

    # Funding Allocation (1) (HEI)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017061 | 1619-AS-2122-Contract-Provider-10017061-1_0           | 1_0            | 1619                        | AS-2122            | 33109.00          |
 
    # Provider Funding Allocation (1)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017061-1_0  | 1_0                    | 1619-AS-2122-Contract-Provider-10017061-1_0           | 10017061      | Furth        | 07HEP           | 33109.00                  |
 
    # Funding Allocation Line (aka Deliverable) (1)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017061-1_0  | 1619-003        | 9720.00          | Payment         |
    | 1619-AS-2122-10017061-1_0  | 1619-004        | 8435.00          | Payment         |
    | 1619-AS-2122-10017061-1_0  | 1619-013        | 5701.00          | Payment         |
    | 1619-AS-2122-10017061-1_0  | 1619-021        | 9253.00          | Payment         |
 
    # Funding Allocation Profile Period (1)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017061-1_0  | 1619-003        | FY-2122              | November               | 2021              | 5557.00                   |
    | 1619-AS-2122-10017061-1_0  | 1619-003        | FY-2122              | April                  | 2022              | 4163.00                   |
    #
    | 1619-AS-2122-10017061-1_0  | 1619-004        | FY-2122              | September              | 2021              | 5358.00                   |
    | 1619-AS-2122-10017061-1_0  | 1619-004        | FY-2122              | June                   | 2022              | 3077.00                   |
    #
    | 1619-AS-2122-10017061-1_0  | 1619-013        | FY-2122              | December               | 2021              | 5701.00                   |
    #
    | 1619-AS-2122-10017061-1_0  | 1619-021        | FY-2122              | August                 | 2021              | 4229.00                   |
    | 1619-AS-2122-10017061-1_0  | 1619-021        | FY-2122              | April                  | 2022              | 5024.00                   |
 
 



    # Funding Allocation (2) (HEI)
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017061 | NMSS-AY-2122-Contract-Provider-10017061-1_7           | 1_7            | NMSS                        | AY-2122            | 32642.00          |
 
    # Provider Funding Allocation (2)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10017061-1_7  | 1_7                    | NMSS-AY-2122-Contract-Provider-10017061-1_7           | 10017061      | Furth        | 07HEP           | 32642.00                  |
 
    # Funding Allocation Line (aka Deliverable) (2)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10017061-1_7  | NMSS-002        | 3362.00          | Payment         |
    | NMSS-AY-2122-10017061-1_7  | NMSS-003        | 5378.00          | Payment         |
    | NMSS-AY-2122-10017061-1_7  | NMSS-007        | 5421.00          | Payment         |
    | NMSS-AY-2122-10017061-1_7  | NMSS-008        | 18481.00         | Payment         |
 
    # Funding Allocation Profile Period (2)
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10017061-1_7  | NMSS-002        | FY-2122              | July                   | 2022              | 3362.00                   |
    #
    | NMSS-AY-2122-10017061-1_7  | NMSS-003        | FY-2122              | March                  | 2022              | 5378.00                   |
    #
    | NMSS-AY-2122-10017061-1_7  | NMSS-007        | FY-2122              | December               | 2021              | 3202.00                   |
    | NMSS-AY-2122-10017061-1_7  | NMSS-007        | FY-2122              | July                   | 2022              | 2219.00                   |
    #
    | NMSS-AY-2122-10017061-1_7  | NMSS-008        | FY-2122              | September              | 2021              | 4632.00                   |
    | NMSS-AY-2122-10017061-1_7  | NMSS-008        | FY-2122              | January                | 2022              | 2624.00                   |
    | NMSS-AY-2122-10017061-1_7  | NMSS-008        | FY-2122              | April                  | 2022              | 5711.00                   |
    | NMSS-AY-2122-10017061-1_7  | NMSS-008        | FY-2122              | June                   | 2022              | 5514.00                   |
 
  
  


    # Consume stub data
 
    # Change the date 
    Given the override date is '07/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017061 | 10017061 Co Ltd  | 1619-AS-2122-Contract-Provider-10017061-1_0             | 1_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (HEI)      | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 33109.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |
    | 10017061 | 10017061 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017061-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (HEI)      | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 32642.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2122-Contract-Provider-10017061-1_0             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |
    | NMSS-AY-2122-Contract-Provider-10017061-1_7             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Conditions of Funding (Grant) (HEI)     | CofG_HEI                  |

    # Check the state of Release Groups in CRM (J129)
    Then  Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 65751.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017061 | 1619-AS-2122-Contract-Provider-10017061-1_0             | 1_0            | AS-2122 | 1619                        | 33109.00    | [CofG_HEI]   |
    | 10017061 | NMSS-AY-2122-Contract-Provider-10017061-1_7             | 1_7            | AY-2122 | NMSS                        | 32642.00    | [CofG_HEI]   |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_HEI]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '12/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_HEI]        |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_HEI]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 65751.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017061' for FundingType 'EDSK' and period '2122'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017061 | 10017061 Co Ltd  | 1619-AS-2122-Contract-Provider-10017061-1_0             | 1_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (HEI)      | 1619                        | 16-19ED2122     | Released          | Released          | 33109.00    | EDSK-061      | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |
    | 10017061 | 10017061 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017061-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (HEI)      | NMSS                        | 16-19ED2122     | Released          | Released          | 32642.00    | EDSK-061      | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017061-1_0             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017061-1_0             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    #
    | NMSS-AY-2122-Contract-Provider-10017061-1_7             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | NMSS-AY-2122-Contract-Provider-10017061-1_7             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |


    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017061 | 1619-AS-2122-Contract-Provider-10017061-1_0             | 1_0            | AS-2122 | 1619                        | 33109.00    | [CofG_HEI]   |
    | 10017061 | NMSS-AY-2122-Contract-Provider-10017061-1_7             | 1_7            | AY-2122 | NMSS                        | 32642.00    | [CofG_HEI]   |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017061-1_0             | EDSK-061     | 1               | 1                  | Yes            |
    | NMSS-AY-2122-Contract-Provider-10017061-1_7             | EDSK-061     | 1               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_HEI]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017061 | EDSK-061           | 1                     | 1                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017061 | ESFA-061           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                          | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017061 | EDSK-061           | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 113050.00     | 1                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Conditions of Funding (Grant) (NMSS)  | ?                        | ?             | Initiate Document Merge  | Yes                   | ESFA-061           | AY2122 | ?               | 10017061 Co Ltd  | Active | Document Management Team  |
    | 10017061 | ESFA-061           | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Conditions of Funding (Grant) (NMSS)  | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017061 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017061 | EDSK-061           | 16TR-061              | ?                             | 47299.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 16-18TRN      | 16-18TRN2122        | Contract Allocation   |
    | 10017061 | EDSK-061           | [AllocRef_16ED]       | ?                             | 65751.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | EDSK-061       | 16TR-061        | 1               | 47299.00  | 2743.00  | 3326.00  | 3312.00  | 4340.00  | 4957.00  | 4087.00  | 2996.00  | 5288.00  | 4828.00  | 6207.00  | 1320.00  | 3895.00  | Total 16-18 Traineeships Funding               |                          |
    | EDSK-061       | 16TR-061        | 2               | 23150.00  | 1878.00  | 1221.00  | 2210.00  | 2946.00  | 1720.00  | 1696.00  | 787.00   | 3514.00  | 1750.00  | 3341.00  | 534.00   | 1553.00  | 16-18 Traineeships Programme Funding           |                          |
    | EDSK-061       | 16TR-061        | 3               | 24149.00  | 865.00   | 2105.00  | 1102.00  | 1394.00  | 3237.00  | 2391.00  | 2209.00  | 1774.00  | 3078.00  | 2866.00  | 786.00   | 2342.00  | 16-18 Traineeships Bursary Funding             |                          |
    #
    | EDSK-061       | [AllocRef_16ED] | 33              | 9720.00   | 0.00     | 0.00     | 0.00     | 5557.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4163.00  | 0.00     | 0.00     | 0.00     | Residential Bursary Fund                       |                          |
    | EDSK-061       | [AllocRef_16ED] | 85              | 8435.00   | 0.00     | 5358.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3077.00  | 0.00     | Residential Support Scheme                     |                          |
    | EDSK-061       | [AllocRef_16ED] | 18              | 5701.00   | 0.00     | 0.00     | 0.00     | 0.00     | 5701.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Maintained Special SSF Bursary Support         |                          |
    | EDSK-061       | [AllocRef_16ED] | 53              | 9253.00   | 4229.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5024.00  | 0.00     | 0.00     | 0.00     | Alternative Completions - Creative Sector      |                          |
    #
    | EDSK-061       | [AllocRef_16ED] | 15              | 3362.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3362.00  | SSF High Needs Element 2                       |                          |
    | EDSK-061       | [AllocRef_16ED] | 13              | 5378.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5378.00  | 0.00     | 0.00     | 0.00     | 0.00     | SSF Bursary Funds                              |                          |
    | EDSK-061       | [AllocRef_16ED] | 135             | 5421.00   | 0.00     | 0.00     | 0.00     | 0.00     | 3202.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2219.00  | Teachers Pension Scheme (NMSS)                 |                          |
    | EDSK-061       | [AllocRef_16ED] | 140             | 18481.00  | 0.00     | 4632.00  | 0.00     | 0.00     | 0.00     | 2624.00  | 0.00     | 0.00     | 5711.00  | 0.00     | 5514.00  | 0.00     | Pupil Premium (NMSS)                           |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '132' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

#    # Check the contents of the Appendices
#    And   the file named '10017061_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
#    """
#    blah
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#    And   Sharepoint file '10017061_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A061.pdf'

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017056'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017061 - 10017061 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017061 | ESFA-061           | EDSK-061       | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017061 | ESFA-061           | EDSK-061       | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017061 | ESFA-061           | EDSK-061       | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |



 

    # Publish and approve the contract (32385)

    # Change the date 
    Given the override date is '17/07/2021'

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
    | 10017061 | EDSK-061           | 1                     | 1                        | Approved         | Approved                | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017061 | ESFA-061           | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the CRM Funding Allocations data (Status\Substatus updated)
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                |                
    | 10017061 | 10017061 Co Ltd  | 1619-AS-2122-Contract-Provider-10017061-1_0             | 1_0            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (HEI)      | 1619                        | 16-19ED2122     | Contract Approved | Contract Approved | 33109.00    | EDSK-061      | 1                 | CRM Integration       | CRM Integration           | ?                         |
    | 10017061 | 10017061 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017061-1_7             | 1_7            | Education & Skills Funding | AY2122  | Conditions of Funding (Grant) (HEI)      | NMSS                        | 16-19ED2122     | Contract Approved | Contract Approved | 32642.00    | EDSK-061      | 1                 | CRM Integration       | CRM Integration           | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-061' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '11' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
    | 10017061 | EDSK-061       | 1               | 16TR-061         | 1               | 0                     | 47299.00     | 0             | 0        | Total 16-18 Traineeships Funding               | ?                           |
    | 10017061 | EDSK-061       | 1               | 16TR-061         | 2               | 1                     | 23150.00     | 0             | 0        | 16-18 Traineeships Programme Funding           | ?                           |
    | 10017061 | EDSK-061       | 1               | 16TR-061         | 3               | 1                     | 24149.00     | 0             | 0        | 16-18 Traineeships Bursary Funding             | ?                           |
    #
    | 10017061 | EDSK-061       | 1               | [AllocRef_16ED]  | 33              | 0                     | 9720.00      | 0             | 0        | Residential Bursary Fund                       | ?                           |
    | 10017061 | EDSK-061       | 1               | [AllocRef_16ED]  | 85              | 0                     | 8435.00      | 0             | 0        | Residential Support Scheme                     | ?                           |
    | 10017061 | EDSK-061       | 1               | [AllocRef_16ED]  | 18              | 0                     | 5701.00      | 0             | 0        | Maintained Special SSF Bursary Support         | ?                           |
    | 10017061 | EDSK-061       | 1               | [AllocRef_16ED]  | 53              | 0                     | 9253.00      | 0             | 0        | Alternative Completions - Creative Sector      | ?                           |

    | 10017061 | EDSK-061       | 1               | [AllocRef_16ED]  | 15              | 0                     | 3362.00      | 0             | 0        | SSF High Needs Element 2                       | ?                           |
    | 10017061 | EDSK-061       | 1               | [AllocRef_16ED]  | 13              | 0                     | 5378.00      | 0             | 0        | SSF Bursary Funds                              | ?                           |
    | 10017061 | EDSK-061       | 1               | [AllocRef_16ED]  | 135             | 0                     | 5421.00      | 0             | 0        | Teachers Pension Scheme (NMSS)                 | ?                           |
    | 10017061 | EDSK-061       | 1               | [AllocRef_16ED]  | 140             | 0                     | 18481.00     | 0             | 0        | Pupil Premium (NMSS)                           | ?                           |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
@CFS
Scenario: A062 Import and release a 1619 FA. Import and release an NFF FA for the same provider, ie Update Draft. Check CRM, docs and feed
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017062'
    And   there is no Funding Allocation data in CRM for UKPRN '10017062'
    And   there is no Contract, Task or Workflow data for UKPRN '10017062'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017062'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017062'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017062' in the Sharepoint 'EDSK-2122-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017062' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017062 Co Ltd' with UKPRN '10017062' and OrgId 'ORG0017062' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017062' 


    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017062 | 117062 | 10017062 Co Ltd | 0              | Locked Restructure    | Yes           | AA017062      | ?             | 7 Lovers Walk          | Preston Park           | ?                      | ?                      | Brighton               | East Sussex            | BN1 6AH   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017062 |


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





    # Populate the stub with 1619 (02IPP) data

    # Change the date 
    Given the override date is '14/06/2021'

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017062 | 1619-AS-2122-Contract-Provider-10017062-2_1           | 2_1            | 1619                        | AS-2122            | 49562.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017062-2_1  | 2_1                    | 1619-AS-2122-Contract-Provider-10017062-2_1           | 10017062      | Furth        | 02IPP           | 49562.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017062-2_1  | 1619-005        | 11879.00         | Payment         |
    | 1619-AS-2122-10017062-2_1  | 1619-010        | 5515.00          | Payment         |
    | 1619-AS-2122-10017062-2_1  | 1619-011        | 3579.00          | Payment         |
    | 1619-AS-2122-10017062-2_1  | 1619-013        | 11056.00         | Payment         |
    | 1619-AS-2122-10017062-2_1  | 1619-021        | 17533.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017062-2_1  | 1619-005        | FY-2022              | September              | 2021              | 3985.00                   |
    | 1619-AS-2122-10017062-2_1  | 1619-005        | FY-2022              | March                  | 2022              | 5122.00                   |
    | 1619-AS-2122-10017062-2_1  | 1619-005        | FY-2022              | April                  | 2022              | 2772.00                   |
    #
    | 1619-AS-2122-10017062-2_1  | 1619-010        | FY-2022              | October                | 2021              | 5515.00                   |
    #
    | 1619-AS-2122-10017062-2_1  | 1619-011        | FY-2022              | June                   | 2022              | 3579.00                   |
    #
    | 1619-AS-2122-10017062-2_1  | 1619-013        | FY-2022              | August                 | 2021              | 2355.00                   |
    | 1619-AS-2122-10017062-2_1  | 1619-013        | FY-2022              | February               | 2022              | 5304.00                   |
    | 1619-AS-2122-10017062-2_1  | 1619-013        | FY-2022              | July                   | 2022              | 3397.00                   |
    #
    | 1619-AS-2122-10017062-2_1  | 1619-021        | FY-2022              | September              | 2021              | 4088.00                   |
    | 1619-AS-2122-10017062-2_1  | 1619-021        | FY-2022              | November               | 2021              | 3618.00                   |
    | 1619-AS-2122-10017062-2_1  | 1619-021        | FY-2022              | April                  | 2022              | 5028.00                   |
    | 1619-AS-2122-10017062-2_1  | 1619-021        | FY-2022              | May                    | 2022              | 4799.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '17/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017062 | 10017062 Co Ltd  | 1619-AS-2122-Contract-Provider-10017062-2_1             | 2_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 49562.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | 1619-AS-2122-Contract-Provider-10017062-2_1             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             | CfS_ITP                   |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 49562.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017062 | 1619-AS-2122-Contract-Provider-10017062-2_1             | 2_1            | AS-2122 | 1619                        | 49562.00    | [CfS_ITP]    |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '20/06/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS_ITP]         |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 49562.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017062' for FundingType 'EDSK' and period '2122'

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017062 | 10017062 Co Ltd  | 1619-AS-2122-Contract-Provider-10017062-2_1             | 2_1            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Released          | Released          | 49562.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017062-2_1             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | 1619-AS-2122-Contract-Provider-10017062-2_1             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017062-2_1             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017062 | 1619-AS-2122-Contract-Provider-10017062-2_1             | 2_1            | AS-2122 | 1619                        | 49562.00    | [CfS_ITP]    |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017062-2_1             | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017062 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017062 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017062 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 49562.00      | 1                     | 0                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017062 Co Ltd  | Active | Document Management Team  |
    | 10017062 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017062 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017062 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 49562.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 31              | 11879.00  | 0.00     | 3985.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5122.00  | 2772.00  | 0.00     | 0.00     | 0.00     | 16-19 Free Meals                               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 125             | 5515.00   | 0.00     | 0.00     | 5515.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Teacher's Pension Scheme 1619                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 51              | 3579.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3579.00  | 0.00     | Alternative Completions - Sporting Excellence  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 18              | 11056.00  | 2355.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5304.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3397.00  | Maintained Special SSF Bursary Support         |                          |
    | [ContractNo]   | [AllocRef_16ED] | 53              | 17533.00  | 0.00     | 4088.00  | 0.00     | 3618.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5028.00  | 4799.00  | 0.00     | 0.00     | Alternative Completions - Creative Sector      |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017062_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017062 Co Ltd UKPRN: 10017062
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £29,987 £19,575 £49,562
    Total Funding for this contract: £49,562
    Summary of Funding – Page 1

    Agreement Type Contract for Services
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017062 Co Ltd
    Funding for 16 to 19 Education
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017062 Co Ltd THE SECRETARY OF STATE FOR
    7 Lovers Walk EDUCATION
    Preston Park DEPARTMENT FOR EDUCATION
    Brighton 20 GREAT SMITH STREET
    AND
    East Sussex LONDON
    BN1 6AH SW1P 3BT
    Company No: AA017062
    Hereinafter called Hereinafter called
    the Contractor the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 75
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 ITP (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 ITP (July 2021) – Page 12
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017062 Co Ltd UKPRN: 10017062
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Free Meals £11,879 £0.00 £3,985.00 £0.00 £0.00 £0.00 £0.00 £0.00 £5,122.00 £2,772.00 £0.00 £0.00 £0.00
    Maintained Special SSF Bursary Support £11,056 £2,355.00 £0.00 £0.00 £0.00 £0.00 £0.00 £5,304.00 £0.00 £0.00 £0.00 £0.00 £3,397.00
    Alternative Completions - Sporting Excellence £3,579 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,579.00 £0.00
    Alternative Completions - Creative Sector £17,533 £0.00 £4,088.00 £0.00 £3,618.00 £0.00 £0.00 £0.00 £0.00 £5,028.00 £4,799.00 £0.00 £0.00
    Teacher's Pension Scheme 1619 £5,515 £0.00 £0.00 £5,515.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Total Funding £49,562 £2,355.00 £8,073.00 £5,515.00 £3,618.00 £0.00 £0.00 £5,304.00 £5,122.00 £7,800.00 £4,799.00 £3,579.00 £3,397.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017062_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A062_1.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate              |
    | [ContractNo]   | 1                     | 0                        | 2021-06-20 11:00:15.000  |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017056'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017062 - 10017062 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the CRM Contract Workflow History data
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
   #| 10017062 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version                | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
   #| 10017062 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |
    | 10017062 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                   |





    # Populate the stub again with NMSS (02IPP) data

    # Change the date
    Given the override date is '23/06/2021'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017062 | NMSS-AY-2122-Contract-Provider-10017062-3_4           | 3_4            | NMSS                        | AY-2122            | 38811.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | NMSS-AY-2122-10017062-3_4  | 3_4                    | NMSS-AY-2122-Contract-Provider-10017062-3_4           | 10017062      | Furth        | 02IPP           | 38811.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | NMSS-AY-2122-10017062-3_4  | NMSS-001        | 3453.00          | Payment         |
    | NMSS-AY-2122-10017062-3_4  | NMSS-002        | 11322.00         | Payment         |
    | NMSS-AY-2122-10017062-3_4  | NMSS-005        | 4914.00          | Payment         |
    | NMSS-AY-2122-10017062-3_4  | NMSS-006        | 2755.00          | Payment         |
    | NMSS-AY-2122-10017062-3_4  | NMSS-008        | 16367.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | NMSS-AY-2122-10017062-3_4  | NMSS-001        | FY-2022              | February               | 2022              | 3453.00                   |
    #
    | NMSS-AY-2122-10017062-3_4  | NMSS-002        | FY-2022              | November               | 2021              | 3845.00                   |
    | NMSS-AY-2122-10017062-3_4  | NMSS-002        | FY-2022              | December               | 2021              | 4059.00                   |
    | NMSS-AY-2122-10017062-3_4  | NMSS-002        | FY-2022              | July                   | 2022              | 3418.00                   |
    #
    | NMSS-AY-2122-10017062-3_4  | NMSS-005        | FY-2022              | January                | 2022              | 2179.00                   |
    | NMSS-AY-2122-10017062-3_4  | NMSS-005        | FY-2022              | February               | 2022              | 2735.00                   |
    #
    | NMSS-AY-2122-10017062-3_4  | NMSS-006        | FY-2022              | March                  | 2022              | 2755.00                   |
    #
    | NMSS-AY-2122-10017062-3_4  | NMSS-008        | FY-2022              | September              | 2021              | 3791.00                   |
    | NMSS-AY-2122-10017062-3_4  | NMSS-008        | FY-2022              | November               | 2021              | 2738.00                   |
    | NMSS-AY-2122-10017062-3_4  | NMSS-008        | FY-2022              | March                  | 2022              | 4832.00                   |
    | NMSS-AY-2122-10017062-3_4  | NMSS-008        | FY-2022              | April                  | 2022              | 2551.00                   |
    | NMSS-AY-2122-10017062-3_4  | NMSS-008        | FY-2022              | June                   | 2022              | 2455.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '26/06/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Check the CRM Funding Allocations data
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017062 | 10017062 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017062-3_4             | 3_4            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | NMSS                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 38811.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action               | CompletedBy       | NewStatus          | NewSubStatus          | PreviousStatus | PreviousSubStatus     | Comment               |
    | NMSS-AY-2122-Contract-Provider-10017062-3_4             | Record Imported      | CRM Integration   | Scheduling         | Awaiting Release      | ?              | ?                     | ?                     |

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             | CfS_ITP                   |

    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 38811.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017062 | NMSS-AY-2122-Contract-Provider-10017062-3_4             | 3_4            | AY-2122 | NMSS                        | 38811.00    | [CfS_ITP]    |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '29/06/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS_ITP]         |

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 38811.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017062' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017062' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (Contract No and version added and Status\Substatus updated)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
    | 10017062 | 10017062 Co Ltd  | NMSS-AY-2122-Contract-Provider-10017062-3_4             | 3_4            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | NMSS                        | 16-19ED2122     | Released          | Released          | 38811.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | NMSS-AY-2122-Contract-Provider-10017062-3_4             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
#   | NMSS-AY-2122-Contract-Provider-10017062-3_4             | Initiate Release                | CRM Integration   | In Release         | Release in Progress             | Scheduling     | Awaiting Release                | ?                             |
    | NMSS-AY-2122-Contract-Provider-10017062-3_4             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup |
    | 10017062 | NMSS-AY-2122-Contract-Provider-10017062-3_4             | 3_4            | AY-2122 | NMSS                        | 38811.00    | [CfS_ITP]    |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | NMSS-AY-2122-Contract-Provider-10017062-3_4             | [ContractNo] | 1               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017062 | [ContractNo]       | 1                     | 1                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017062 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017062 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 88373.00      | 1                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017062 Co Ltd  | Active | Document Management Team  |
    | 10017062 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017062 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         |
    | 10017062 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 88373.00        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 31              | 11879.00  | 0.00     | 3985.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5122.00  | 2772.00  | 0.00     | 0.00     | 0.00     | 16-19 Free Meals                               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 125             | 5515.00   | 0.00     | 0.00     | 5515.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Teacher's Pension Scheme 1619                  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 51              | 3579.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3579.00  | 0.00     | Alternative Completions - Sporting Excellence  |                          |
    | [ContractNo]   | [AllocRef_16ED] | 18              | 11056.00  | 2355.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5304.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3397.00  | Maintained Special SSF Bursary Support         |                          |
    | [ContractNo]   | [AllocRef_16ED] | 53              | 17533.00  | 0.00     | 4088.00  | 0.00     | 3618.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5028.00  | 4799.00  | 0.00     | 0.00     | Alternative Completions - Creative Sector      |                          |
    #
    | [ContractNo]   | [AllocRef_16ED] | 39              | 3453.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3453.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | NMF Pre-16 Funding (NMSS)                      |                          |
    | [ContractNo]   | [AllocRef_16ED] | 15              | 11322.00  | 0.00     | 0.00     | 0.00     | 3845.00  | 4059.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3418.00  | SSF High Needs Element 2                       |                          |
    | [ContractNo]   | [AllocRef_16ED] | 43              | 4914.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2179.00  | 2735.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Primary PE and Sport Premium (1)     |                          |
    | [ContractNo]   | [AllocRef_16ED] | 118             | 2755.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2755.00  | 0.00     | 0.00     | 0.00     | 0.00     | Teachers Pay Grant (NMSS)                      |                          |
    | [ContractNo]   | [AllocRef_16ED] | 140             | 16367.00  | 0.00     | 3791.00  | 0.00     | 2738.00  | 0.00     | 0.00     | 0.00     | 4832.00  | 2551.00  | 0.00     | 2455.00  | 0.00     | Pupil Premium (NMSS)                           |                          |

    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '120' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices
    And   the file named '10017062_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017062 Co Ltd UKPRN: 10017062
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 19 Education [AllocRef_16ED] £60,374 £27,999 £88,373
    Total Funding for this contract: £88,373
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017062 Co Ltd
    Funding for 16 to 19 Education
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017062 Co Ltd THE SECRETARY OF STATE FOR
    7 Lovers Walk EDUCATION
    Preston Park DEPARTMENT FOR EDUCATION
    Brighton 20 GREAT SMITH STREET
    AND
    East Sussex LONDON
    BN1 6AH SW1P 3BT
    Company No: AA017062
    Hereinafter called Hereinafter called
    the Contractor the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 75
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 ITP (July 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 ITP (July 2021) – Page 12
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2021) – Page 1
       
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017062 Co Ltd UKPRN: 10017062
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16-19 Free Meals £11,879 £0.00 £3,985.00 £0.00 £0.00 £0.00 £0.00 £0.00 £5,122.00 £2,772.00 £0.00 £0.00 £0.00
    SSF High Needs Element 2 £11,322 £0.00 £0.00 £0.00 £3,845.00 £4,059.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,418.00
    Maintained Special SSF Bursary Support £11,056 £2,355.00 £0.00 £0.00 £0.00 £0.00 £0.00 £5,304.00 £0.00 £0.00 £0.00 £0.00 £3,397.00
    NMF Pre-16 Funding (NMSS) £3,453 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,453.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Alternative Completions - Sporting Excellence £3,579 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,579.00 £0.00
    Alternative Completions - Creative Sector £17,533 £0.00 £4,088.00 £0.00 £3,618.00 £0.00 £0.00 £0.00 £0.00 £5,028.00 £4,799.00 £0.00 £0.00
    Teachers Pay Grant (NMSS) £2,755 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,755.00 £0.00 £0.00 £0.00 £0.00
    Teacher's Pension Scheme 1619 £5,515 £0.00 £0.00 £5,515.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Pupil Premium (NMSS) £16,367 £0.00 £3,791.00 £0.00 £2,738.00 £0.00 £0.00 £0.00 £4,832.00 £2,551.00 £0.00 £2,455.00 £0.00
    Total Funding £88,373 £2,355.00 £11,864.00 £5,515.00 £10,201.00 £4,059.00 £2,179.00 £11,492.00 £12,709.00 £10,351.00 £4,799.00 £6,034.00 £6,815.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """
 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017062_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A062_2.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate              |
    | [ContractNo]   | 1                     | 1                        | 2021-06-29 15:06:33.000  |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017056'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10017062 - 10017062 Co Ltd Awaiting documentation  | [AllocRef_16ED] | Document Management Team  | ?                | Open       | Not Started   |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                  | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner  | PreviousStatus  | PreviousSubStatus       |
    | 10017062 | [MasterContractNo] | [ContractNo]   | 1                     | Create New Draft Version (Create Task)  | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                  | Draft           | ?                       |  
    | 10017062 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)        | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                  | Draft           | ?                       |  


    # Tidy Up
    And   the override date is reset
    