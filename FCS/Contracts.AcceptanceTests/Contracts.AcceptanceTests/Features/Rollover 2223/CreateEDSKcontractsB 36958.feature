Feature: CreateEDSKcontractsB 36958

@AcceptanceTest @Withdrawn25072024
@Long2Run @Long2Run123
Scenario: A392 Create and approve 22/23 EDSK contract. Import 1619ED FA. CofG_College. Approve. Various amendments. Check doc parts logic.

    #  1. Create a draft EDSK2223 contract with ALLB(PoA), 16-18TRN(PoA) and AEBC-NSF(PoP) allocs with ContractType=CofG College
    #  2. Import and release 1619ED FA (PoP) (AFScode=UIFSM, ProviderSubType=Further education, ContractType=CofG College) Update Draft
    #  3. Check doc parts on v1.1
    #  4. Publish and approve v1.1
    #  5. Execute NFA variation amendment on v1.1 > v2.0 without changing template timestamps
    #  6. Check doc parts on v2.0: Only SoF created
    #  7. Publish and approve v2.0
    #  8. Update template timestamps on TaC and Sch3
    #  9. NFA variation amendment on v2.0 > v3.0
    # 10. Check docs parts on v3.0: SoF, TAC and Sch3 created
    # 11. Bulk Update Draft Amendment to change financials on ALLB alloc > v3.1
    # 12. Check doc parts on v3.1: SoF, TaC, FA(Loans) and Sch3 created
    # 13. Publish and approve v3.1

    Given there are no allocations marked as Under Termination for UKPRN '10017392' 
    And   there are no terminated or closed allocations for UKPRN '10017392' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017392' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017392' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017392' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-392      |
    | ALLB-392      |
    | NSFC-392      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-392      |
    | ALLB-392      |
    | NSFC-392      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLB2223          |
    | 16-18TRN2223      |
    | AEBC-NSF2223      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-392       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017392'

    # Set the 'base' timestamp for each of the 22\23 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                              | UploadTimestamp         | 
    | SOF_EDSK_2022-08-01.docx                          | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_TAC_CFS_ITP_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_COLLEGE_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_EMPLOYER_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_HEI_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_LA_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_NMSS_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_SPI_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_TRUST_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S1_1618TRN_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRN_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRNME_CFS_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1618TRNME_COFG_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_COLLEGE_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_HEI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_ITP_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_LA_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_1619ED_SPI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_AEB_COFG_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_LOANS_CFS_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_LOANS_COFG_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S2_1618TRN_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRN_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRNME_CFS_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1618TRNME_COFG_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_CFS_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_COFG_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_1619ED_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_AEB_COFG_2022-08-01.docx              | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_LOANS_CFS_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_LOANS_COFG_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    #  
    | FA_EDSK2223_2022-08-01.docx                       | 2022-04-01 12:00:00.000 | 
    #  
    | EDSK2223_S3ON_CFS_ITP_2022-08-01.docx             | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_COLLEGE_2022-08-01.docx        | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_EMPLOYER_2022-08-01.docx       | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_LA_TRUST_HEI_2022-08-01.docx   | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_NMSS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_SPI_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017392' 
    And   there is no caseload advisor for UKPRN '10017392' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017392 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017392' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017392 Co Ltd' with UKPRN '10017392' and OrgId 'ORG0017392' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017392 | 117392 | 10017392 Co Ltd | 0              | Active                | Yes           | AA017392      | ?             | 29 Church Street       | Basingstoke            | ?                      | ?                      | ?                      | ?                      | RG21 7QQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017392 |





    # Part 1: Create a draft EDSK2223 contract with ALLB(PoA), 16-18TRN(PoA) and AEBC-NSF(PoP) allocs with ContractType=CofG College
    
    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-392'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-392'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017392 | 10017392 Co Ltd      | ESFA-392             | EDSK-392       | 1                     | 01/08/2022        | 31/07/2023      | 79831.00      |                                       | Conditions of Funding (Grant) (College)    | 2223   | New          | ORG0017392 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017392 | EDSK-392       | 16TR-392      | 16-18TRN          | 16-18TRN2223            | AY                      | 01/08/2022          | 31/07/2023        | 42124.00        |                                         |            |                                                             | New          |             |
    | 10017392 | EDSK-392       | ALLB-392      | ALLB              | ALLB2223                | AY                      | 01/08/2022          | 31/07/2023        | 15535.00        |                                         |            |                                                             | New          |             |
    | 10017392 | EDSK-392       | NSFC-392      | AEBC-NSF          | AEBC-NSF2223            | AY                      | 01/08/2022          | 31/07/2023        | 22172.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017392 | EDSK-392       | 16TR-392      | 1               | 0                     | 42124.00  | 26036.00  | 16088.00  | 4377.00  | 5405.00  | 2322.00  | 1452.00  | 360.00   | 6354.00  | 2194.00  | 3572.00  | 6087.00  | 1260.00  | 5392.00  | 3350.00  | Total 16-18 Traineeships Funding                                | New          |             | 
    | 10017392 | EDSK-392       | 16TR-392      | 2               | 1                     | 22674.00  | 13640.00  | 9034.00   | 1669.00  | 2405.00  | 1180.00  | 1155.00  | 246.00   | 2974.00  | 1210.00  | 2801.00  | 3695.00  | 1012.00  | 3394.00  | 933.00   | 16-18 Traineeships Programme Funding                            | New          |             | 
    | 10017392 | EDSK-392       | 16TR-392      | 3               | 1                     | 19450.00  | 12396.00  | 7054.00   | 2708.00  | 3000.00  | 1142.00  | 297.00   | 114.00   | 3380.00  | 984.00   | 771.00   | 2392.00  | 248.00   | 1997.00  | 2417.00  | 16-18 Traineeships Bursary Funding                              | New          |             | 
    #
    | 10017392 | EDSK-392       | ALLB-392      | 1               | 0                     | 15535.00  | 7975.00   | 7560.00   | 235.00   | 1065.00  | 1292.00  | 2345.00  | 170.00   | 274.00   | 946.00   | 1648.00  | 1277.00  | 3373.00  | 788.00   | 2122.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             | 
    #
    | 10017392 | EDSK-392       | NSFC-392      | 1               | 0                     | 22172.00  | 16680.00  | 5492.00   | 2611.00  | 279.00   | 3575.00  | 2824.00  | 1376.00  | 2018.00  | 2058.00  | 1939.00  | 2295.00  | 1227.00  | 728.00   | 1242.00  | Total 16-18 Traineeships Funding                                | New          |             | 
    | 10017392 | EDSK-392       | NSFC-392      | 2               | 1                     | 22172.00  | 16680.00  | 5492.00   | 2611.00  | 279.00   | 3575.00  | 2824.00  | 1376.00  | 2018.00  | 2058.00  | 1939.00  | 2295.00  | 1227.00  | 728.00   | 1242.00  | Level 3 Free Courses for Jobs                                   | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-392       | 1                     | 0                        | 2022-07-01 09:12:35.000 |

#    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-392'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-392' and ContractNumber 'EDSK-392' and Version '1'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract 'EDSK-392' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017392 | EDSK-392           | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | ESFA-392           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract 'EDSK-392' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check the deliverable count in CRM includes all the monitoring deliverables
#   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
#    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'EDSK-392'
#
#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | ALLB-392        | 2303800          | Jul-23 | Reconciliation |
#    | 16TR-392        | 2201300          | Jul-23 | Reconciliation |
#    | NSFC-392        | 100946           | Jul-23 | Reconciliation |




    
    # Part 2: Import and release 1619ED FA (PoP) (AFScode=UIFSM, ProviderSubType=Further education, ContractType=CofG College) Update Draft

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017392'
    And   there is no Funding Allocation data in CRM for UKPRN '10017392'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017392'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017392'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017392' in the Sharepoint 'EDSK-2223-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (College) |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table





    # Populate the stub with UIFSM (Further education) data

    # Change the date 
    Given the override date is '01/07/2022'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017392 | UIFSM-AY-2223-Contract-Provider-10017392-1_3          | 1_3            | UIFSM                       | AY-2223            | 50906.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | UIFSM-AY-2223-10017392-1_3 | 1_3                    | UIFSM-AY-2223-Contract-Provider-10017392-1_3          | 10017392      | Colleges                           | Further education                | 50906.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | UIFSM-AY-2223-10017392-1_3 | UIFSM-001       | 26784.00         | Payment         |
    | UIFSM-AY-2223-10017392-1_3 | UIFSM-002       | 24122.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | UIFSM-AY-2223-10017392-1_3 | UIFSM-001       | FY-2223              | August                 | 2022              | 2937.00                   |
    | UIFSM-AY-2223-10017392-1_3 | UIFSM-001       | FY-2223              | November               | 2022              | 4486.00                   |
    | UIFSM-AY-2223-10017392-1_3 | UIFSM-001       | FY-2223              | January                | 2023              | 5966.00                   |
    | UIFSM-AY-2223-10017392-1_3 | UIFSM-001       | FY-2223              | February               | 2023              | 5528.00                   |
    | UIFSM-AY-2223-10017392-1_3 | UIFSM-001       | FY-2223              | April                  | 2023              | 4716.00                   |
    | UIFSM-AY-2223-10017392-1_3 | UIFSM-001       | FY-2223              | June                   | 2023              | 3151.00                   |
    #
    | UIFSM-AY-2223-10017392-1_3 | UIFSM-002       | FY-2223              | August                 | 2022              | 3285.00                   |
    | UIFSM-AY-2223-10017392-1_3 | UIFSM-002       | FY-2223              | October                | 2022              | 5176.00                   |
    | UIFSM-AY-2223-10017392-1_3 | UIFSM-002       | FY-2223              | December               | 2022              | 5630.00                   |
    | UIFSM-AY-2223-10017392-1_3 | UIFSM-002       | FY-2223              | February               | 2023              | 5331.00                   |
    | UIFSM-AY-2223-10017392-1_3 | UIFSM-002       | FY-2223              | May                    | 2023              | 2227.00                   |
    | UIFSM-AY-2223-10017392-1_3 | UIFSM-002       | FY-2223              | July                   | 2023              | 2473.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2022'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (College) | CofG_College              |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      | QueuedOn   | QueuedDueToContract |
    | 10017392 | 10017392 Co Ltd  | UIFSM-AY-2223-Contract-Provider-10017392-1_3            | 1_3            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (College)  | UIFSM                       | 16-19ED2223     | Scheduling        | Awaiting Release  | 50906.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | UIFSM-AY-2223-Contract-Provider-10017392-1_3            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 50906.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017392 | UIFSM-AY-2223-Contract-Provider-10017392-1_3            | 1_3            | AY-2223 | UIFSM                       | 50906.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '05/07/2022'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_College]    |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_College = [CofG_College]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 50906.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017392' for FundingType 'EDSK' and period '2223'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017392' for FundingType 'EDSK' and period '2223' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017392 | 10017392 Co Ltd  | UIFSM-AY-2223-Contract-Provider-10017392-1_3            | 1_3            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (College)  | UIFSM                       | 16-19ED2223     | Released          | Released          | 50906.00    | EDSK-392      | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | UIFSM-AY-2223-Contract-Provider-10017392-1_3            | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | UIFSM-AY-2223-Contract-Provider-10017392-1_3            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017392 | UIFSM-AY-2223-Contract-Provider-10017392-1_3            | 1_3            | AY-2223 | UIFSM                       | 50906.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | UIFSM-AY-2223-Contract-Provider-10017392-1_3            | EDSK-392     | 1               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus     | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017392 | EDSK-392           | 1                     | 1                        | Draft              | Awaiting Documentation                    | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | EDSK-392           | 1                     | 0                        | Superseded Draft   | ?                                         | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | ESFA-392           | 1                     | 0                        | Draft              | ?                                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017392 | EDSK-392           | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 130737.00     | 1                     | 1                        | 01/08/2022        | 31/07/2023      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | ESFA-392           | AY2223 | ?               | 10017392 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017392 | ESFA-392           | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2022        | 31/07/2023      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017392 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocation has been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017392 | EDSK-392           | [AllocRef_16ED]       | ?                             | 50906.00        | ?             | ?                | 01/08/2022 | 31/07/2023 | 1619ED        | 1619ED2223          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableName                                                       | DeliverableDescription   |
    | EDSK-392       | [AllocRef_16ED] | 934             | 26784.00  | 2937.00  | 0.00     | 0.00     | 4486.00  | 0.00     | 5966.00  | 5528.00  | 0.00     | 4716.00  | 0.00     | 3151.00  | 0.00     | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)    |                          |
    | EDSK-392       | [AllocRef_16ED] | 935             | 24122.00  | 3285.00  | 0.00     | 5176.00  | 0.00     | 5630.00  | 0.00     | 5331.00  | 0.00     | 0.00     | 2227.00  | 0.00     | 2473.00  | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)      |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '96' deliverable period rows in CRM linked to the latest version of contract 'EDSK-392'





    # Part 3: Check doc parts on v1.1
    
    # Check the contents of the Appendices (15 doc parts)
    #    SoF, TaC, 4xSch1 (Loans, AEB, 16-18, 16-19), 4x(Sch2 and FA)(Loans, AEB, 16-18, 16-19), Sch3
    And   the file named '10017392_EDSK-392_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    
    Agreement Type Conditions of Funding (Grant) (Colleges)

    16.2.4 In the event that it is not possible or practical for any reason for
    the College to give notice to the Department in accordance with
    Clause 16.2.3 the College will notify the Department by
    whatever means the College considers appropriate and will
    confirm such notification in writing within 5 Working Days.
    EDSK Version 3 (November 2022) Page 35
    

    SCHEDULE 1: SPECIFICATION & MONITORING
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (August 2022) – Page 1
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 1 (July 2022) – Page 1
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2022) – Page 1
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2022) – Page 1
    
    SCHEDULE 2: PAYMENT
    EDSK Schedule 2 – Advanced Learner Loans Version 2 (July 2022) – Page 2
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLB-392 – Page 1 Ref (for internal use only):  EDSK-392 v1
    
    SCHEDULE 2: PAYMENT
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2022) – Page 1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement NSFC-392 – Page 1 Ref (for internal use only):  EDSK-392 v1
    
    SCHEDULE 2: PAYMENT
    EDSK Schedule 2 – 16 to 18 Traineeships Version 2 (February 2023) – Page 1
    
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement 16TR-392 – Page 1 Ref (for internal use only):  EDSK-392 v1
    
    SCHEDULE 2: PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2022) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-392 v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 3 (November 2022) – Page 1

    SCHEDULE 9: COLLEGE GOVERNANCE
    4.4 The College must obtain the written consent of the Secretary of State
    before entering into any new arrangements for Borrowing Money and for
    any amendment to such arrangements from 29 November 2022 and
    before entering into any amendment to arrangements for Borrowing
    Money that existed before 29 November 2022. Failure to do so will amount
    to a breach of this Agreement and the provisions of Part 8 (Clauses 34 to
    37) will apply.
    EDSK Schedule 9 Version 3 (November 2022) – Page 2

    SCHEDULE 10: SUB-CONTRACTING
    EDSK Schedule 10 Version 3 (November 2022) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017392_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A392.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for 'EDSK-392'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-392       | 1                     | 1                        | 2022-07-04 09:12:35.000 |





    # Part 4: Publish and approve v1.1
    
    # Publish contract v1.1

    # Change the date 
    Given the override date is '07/07/2022'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017392_EDSK-392_v1.pdf' is created in 'EDSK-2223-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract 'EDSK-392'
    And   the latest version of contract 'EDSK-392' and master 'ESFA-392' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus     | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017392 | EDSK-392           | 1                     | 1                        | Draft              | Published to Provider   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | EDSK-392           | 1                     | 0                        | Superseded Draft   | ?                       | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | ESFA-392           | 1                     | 0                        | Draft              | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |





    # Approve contract v1.1

    # Change the date 
    Given the override date is '09/07/2022'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-392' and ContractNumber 'EDSK-392' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-392' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus     | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017392 | EDSK-392           | 1                     | 1                        | Approved           | Approved                | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | EDSK-392           | 1                     | 0                        | Superseded Draft   | ?                       | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | ESFA-392           | 1                     | 0                        | Draft              | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017392 | 10017392 Co Ltd  | UIFSM-AY-2223-Contract-Provider-10017392-1_3            | 1_3            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (College)  | UIFSM                       | 16-19ED2223     | Contract Approved | Contract Approved | 50906.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017392 | UIFSM-AY-2223-Contract-Provider-10017392-1_3            | 1_3            | AY-2223 | UIFSM                       | 50906.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |





    # Part 5: Execute NFA variation amendment on v1.1 > v2.0 without changing template timestamps

    # Change the date
    Given the override date is '13/07/2022'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '1' of contract 'EDSK-392' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus     | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017392 | EDSK-392           | 2                     | 0                        | Draft              | Awaiting Documentation  | True          | False               | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017392 | EDSK-392           | 1                     | 1                        | Approved           | Approved                | False         | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | EDSK-392           | 1                     | 0                        | Superseded Draft   | ?                       | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | ESFA-392           | 1                     | 0                        | Draft              | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-392       | 2                     | 0                        | 2022-07-13 09:12:35.000 |





    # Part 6: Check doc parts on v2.0: Only SoF created
    
    # Check the contents of the Appendices: SoF only
    Then  the file named '10017392_EDSK-392_v2.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    """

    # There shouldn't be a TaC doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """

    # There shouldn't be any Sch1 docs
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # There shouldn't be any Sch2 docs
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2: PAYMENT
    """

    # There shouldn't be a Funding Agreement for Loans
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    """

    # There shouldn't be a Funding Agreement for AEB
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    """

    # There shouldn't be a Funding Agreement for 16-18
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    """

    # There shouldn't be a Funding Agreement for 16-19
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2 – 16 TO 19 EDUCATION
    """

    # There shouldn't be a Sch3 doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """


    

    
    # Part 7: Publish and approve v2.0
    
    # Publish contract v2

    # Change the date 
    Given the override date is '16/07/2022'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017392_EDSK-392_v2.pdf' is created in 'EDSK-2223-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract 'EDSK-392'
    And   the latest version of contract 'EDSK-392' and master 'ESFA-392' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus     | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017392 | EDSK-392           | 2                     | 0                        | Draft              | Published to Provider   | True          | False               | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017392 | EDSK-392           | 1                     | 1                        | Approved           | Approved                | False         | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | EDSK-392           | 1                     | 0                        | Superseded Draft   | ?                       | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | ESFA-392           | 1                     | 0                        | Draft              | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |





    # Approve contract v2

    # Change the date 
    Given the override date is '17/07/2022'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-392' and ContractNumber 'EDSK-392' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-392' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus     | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017392 | EDSK-392           | 2                     | 0                        | Approved           | Approved                | True          | True                | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017392 | EDSK-392           | 1                     | 1                        | Replaced           | Approved                | False         | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | EDSK-392           | 1                     | 0                        | Superseded Draft   | ?                       | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | ESFA-392           | 1                     | 0                        | Draft              | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |





    # Part 8: Update template timestamps on TaC and Sch3
    
    # Change the date
    Given the override date is '21/07/2022'

    # Update the timestamp on the TAC and Sch3 for CofG College (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                              | UploadTimestamp         | 
    | EDSK2223_TAC_COFG_COLLEGE_2022-08-01.docx         | 2022-07-20 11:11:11.000 | 
    | EDSK2223_S3ON_COFG_COLLEGE_2022-08-01.docx        | 2022-07-20 11:11:11.000 | 





    # Part 9: NFA variation amendment on v2.0 > v3.0

    # Change the date
    Given the override date is '22/07/2022'
    
    # Issue a non-financial VARIATION amendment on v2 to create v3
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'EDSK-392' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus     | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017392 | EDSK-392           | 3                     | 0                        | Draft              | Awaiting Documentation  | True          | False               | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017392 | EDSK-392           | 2                     | 0                        | Approved           | Approved                | False         | True                | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017392 | EDSK-392           | 1                     | 1                        | Replaced           | Approved                | False         | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | EDSK-392           | 1                     | 0                        | Superseded Draft   | ?                       | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | ESFA-392           | 1                     | 0                        | Draft              | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-392       | 3                     | 0                        | 2022-07-22 09:12:35.000 |



    
    
    # Part 10: Check docs parts on v3.0: SoF, TAC and Sch3 created
    
    # Check the contents of the Appendices: SoF, TaC and Sch3 only
    Then  the file named '10017392_EDSK-392_v3.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23

    Agreement Type Conditions of Funding (Grant) (Colleges)

    SCHEDULE 3: NOT USED
    """



    # Schedule 1 docs
    
    # There shouldn't be a Sch1 doc for Loans
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (August 2022) – Page 1
    """

    # There shouldn't be a Sch1 doc for AEB
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 1 (July 2022) – Page 1
    """

    # There shouldn't be a Sch1 doc for 16-18
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2022) – Page 1
    """

    # There shouldn't be a Sch1 doc for 16-19
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2022) – Page 1
    """


    # Schedule 2 docs

    # There shouldn't be a Sch2 doc for Loans
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2022) – Page 2
    """

    # There shouldn't be a Sch2 doc for AEB
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2022) – Page 1
    """

    # There shouldn't be a Sch2 doc for 16-18
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – 16 to 18 Traineeships Version 1 (July 2022) – Page 1
    """

    # There shouldn't be a Sch2 doc for 16-19
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2022) – Page 1
    """


    # Funding Agreements

    # There shouldn't be a Funding Agreement for Loans
    And   the pdf file does not contain the following text
    """
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLB-392 – Page 1 Ref (for internal use only):  EDSK-392 v3
    """

    # There shouldn't be a Funding Agreement for AEB
    And   the pdf file does not contain the following text
    """
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement NSFC-392 – Page 1 Ref (for internal use only):  EDSK-392 v3
    """

    # There shouldn't be a Funding Agreement for 16-18
    And   the pdf file does not contain the following text
    """
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement 16TR-392 – Page 1 Ref (for internal use only):  EDSK-392 v3
    """

    # There shouldn't be a Funding Agreement for 16-19
    And   the pdf file does not contain the following text
    """
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-392 v3
    """





    # Part 11: Bulk Update Draft Amendment to change financials on ALLB alloc > v3.1

    # Change the date 
    Given the override date is '24/07/2022'

    # Bulk file (Update Draft Amendment)
    And   there are no files prefixed '10017392' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 15062022161821 v3_A392' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 15062022161821 v3_A392' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 15062022161821 v3_A392' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 15062022161821 v3_A392' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 15062022161821 v3_A392.xlsx' exists in the Datafiles folder and UKPRN '10017392' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017392 | EDSK-392           | 3                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017392 | EDSK-392           | 3                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017392 | EDSK-392           | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017392 | EDSK-392           | 1                     | 1                        | Replaced         | Approved                  | False         | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | EDSK-392           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017392 | ESFA-392           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-392       | 3                     | 1                        | 2022-07-24 09:12:35.000 |


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017392' for FundingType 'EDSK' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017392' for FundingType 'EDSK' and period '2223'    
    
    


    
    # Part 12: Check doc parts on v3.1: SoF, TaC, FA(Loans) and Sch3 created 
    
    # Check the contents of the Appendices: SoF, TaC, FA(Loans) and Sch3
    Then  the file named '10017392_EDSK-392_v3.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23

    Agreement Type Conditions of Funding (Grant) (Colleges)

    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLB-392 – Page 1 Ref (for internal use only):  EDSK-392 v3

    SCHEDULE 3: NOT USED
    """


    # Schedule 1 docs
    
    # There shouldn't be a Sch1 doc for Loans
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (August 2022) – Page 1
    """

    # There shouldn't be a Sch1 doc for AEB
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 1 (July 2022) – Page 1
    """

    # There shouldn't be a Sch1 doc for 16-18
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2022) – Page 1
    """

    # There shouldn't be a Sch1 doc for 16-19
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – 16 to 19 Education Version 1 College (July 2022) – Page 1
    """


    # Schedule 2 docs

    # There shouldn't be a Sch2 doc for Loans
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2022) – Page 2
    """

    # There shouldn't be a Sch2 doc for AEB
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2022) – Page 1
    """

    # There shouldn't be a Sch2 doc for 16-18
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – 16 to 18 Traineeships Version 1 (July 2022) – Page 1
    """

    # There shouldn't be a Sch2 doc for 16-19
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2022) – Page 1
    """


    # Funding Agreements

    # There shouldn't be a Funding Agreement for AEB
    And   the pdf file does not contain the following text
    """
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement NSFC-392 – Page 1 Ref (for internal use only):  EDSK-392 v3
    """

    # There shouldn't be a Funding Agreement for 16-18
    And   the pdf file does not contain the following text
    """
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement 16TR-392 – Page 1 Ref (for internal use only):  EDSK-392 v3
    """

    # There shouldn't be a Funding Agreement for 16-19
    And   the pdf file does not contain the following text
    """
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-392 v3
    """


    # Tidy Up
    Given the override date is reset
    
