Feature: CreateEDSKcontractsC 36958

@AcceptanceTest @Withdrawn25072024
@Long2Run @Long2Run123
@CFS
Scenario: A381 Create and approve 22/23 EDSK contract. Import 1619ED FA. Approve. CofG_College. Actuals. Payment Batch. Check financials and feed

    # 1. Create a draft EDSK2223 contract with 16-18TRN(PoA) alloc with ContractType=CofG College
    # 2. Import and release 1619ED FA (PoP) (AFScode=UIFSM, ProviderSubType=Further education, ContractType=CofG College) Update Draft
    # 3. Publish and approve v1.1
    # 4. Add actuals to the contract for 16-18TRN2223
    # 5. CDA for 1619ED2223
    # 6. Payment batch for 1619ED(PoP) and 16-18TRN(PoA). Check feed
    # Run Consolidated Payment Summary Report and check manually
    # Run Payment Summary Report in CRM and check manually 

    Given there are no allocations marked as Under Termination for UKPRN '10017381' 
    And   there are no terminated or closed allocations for UKPRN '10017381' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017381' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017381' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017381' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-381      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-381      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2223      |
    | 1619ED2223        |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-381       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017381'

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
    Given there is no Organisation data in CRM for UKPRN '10017381' 
    And   there is no caseload advisor for UKPRN '10017381' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017381 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017381' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017381 Co Co' with UKPRN '10017381' and OrgId 'ORG0017381' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017381 | 117381 | 10017381 Co Co  | 0              | Active                | Yes           | AA017381      | ?             | 29 Church Street       | Basingstoke            | ?                      | ?                      | ?                      | ?                      | RG21 7QQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017381 |





    # Part 1: Create a draft EDSK2223 contract with 16-18TRN(PoA) alloc with ContractType=CofG College
    
    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-381'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-381'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017381 | 10017381 Co Co       | ESFA-381             | EDSK-381       | 1                     | 01/08/2022        | 31/07/2023      | 42124.00      |                                       | Conditions of Funding (Grant) (College)    | 2223   | New          | ORG0017381 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017381 | EDSK-381       | 16TR-381      | 16-18TRN          | 16-18TRN2223            | AY                      | 01/08/2022          | 31/07/2023        | 42124.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017381 | EDSK-381       | 16TR-381      | 1               | 0                     | 42124.00  | 26036.00  | 16088.00  | 4377.00  | 5405.00  | 2322.00  | 1452.00  | 360.00   | 6354.00  | 2194.00  | 3572.00  | 6087.00  | 1260.00  | 5392.00  | 3350.00  | Total 16-18 Traineeships Funding                                | New          |             | 
    | 10017381 | EDSK-381       | 16TR-381      | 2               | 1                     | 22674.00  | 13640.00  | 9034.00   | 1669.00  | 2405.00  | 1180.00  | 1155.00  | 246.00   | 2974.00  | 1210.00  | 2801.00  | 3695.00  | 1012.00  | 3394.00  | 933.00   | 16-18 Traineeships Programme Funding                            | New          |             | 
    | 10017381 | EDSK-381       | 16TR-381      | 3               | 1                     | 19450.00  | 12396.00  | 7054.00   | 2708.00  | 3000.00  | 1142.00  | 297.00   | 114.00   | 3380.00  | 984.00   | 771.00   | 2392.00  | 248.00   | 1997.00  | 2417.00  | 16-18 Traineeships Bursary Funding                              | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-381       | 1                     | 0                        | 2022-07-01 09:12:35.000 |

#    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-381'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-381' and ContractNumber 'EDSK-381' and Version '1'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract 'EDSK-381' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017381 | EDSK-381           | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017381 | ESFA-381           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract 'EDSK-381' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check the deliverable count in CRM includes all the monitoring deliverables
#   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
#    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'EDSK-381'
#
#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | ALLB-381        | 2303800          | Jul-23 | Reconciliation |
#    | 16TR-381        | 2201300          | Jul-23 | Reconciliation |
#    | NSFC-381        | 100946           | Jul-23 | Reconciliation |




    
    # Part 2: Import and release 1619ED FA (PoP) (AFScode=UIFSM, ProviderSubType=Further education, ContractType=CofG College) Update Draft

    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017381'
    And   there is no Funding Allocation data in CRM for UKPRN '10017381'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017381'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017381'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017381' in the Sharepoint 'EDSK-2223-Input-Appendices' folder

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
    | Contracting    | 10017381 | UIFSM-AY-2223-Contract-Provider-10017381-1_3          | 1_3            | UIFSM                       | AY-2223            | 50906.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | UIFSM-AY-2223-10017381-1_3 | 1_3                    | UIFSM-AY-2223-Contract-Provider-10017381-1_3          | 10017381      | Colleges                           | Further education                | 50906.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | UIFSM-AY-2223-10017381-1_3 | UIFSM-001       | 26784.00         | Payment         |
    | UIFSM-AY-2223-10017381-1_3 | UIFSM-002       | 24122.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | UIFSM-AY-2223-10017381-1_3 | UIFSM-001       | FY-2223              | August                 | 2022              | 2937.00                   |
    | UIFSM-AY-2223-10017381-1_3 | UIFSM-001       | FY-2223              | November               | 2022              | 4486.00                   |
    | UIFSM-AY-2223-10017381-1_3 | UIFSM-001       | FY-2223              | January                | 2023              | 5966.00                   |
    | UIFSM-AY-2223-10017381-1_3 | UIFSM-001       | FY-2223              | February               | 2023              | 5528.00                   |
    | UIFSM-AY-2223-10017381-1_3 | UIFSM-001       | FY-2223              | April                  | 2023              | 4716.00                   |
    | UIFSM-AY-2223-10017381-1_3 | UIFSM-001       | FY-2223              | June                   | 2023              | 3151.00                   |
    #
    | UIFSM-AY-2223-10017381-1_3 | UIFSM-002       | FY-2223              | August                 | 2022              | 3285.00                   |
    | UIFSM-AY-2223-10017381-1_3 | UIFSM-002       | FY-2223              | October                | 2022              | 5176.00                   |
    | UIFSM-AY-2223-10017381-1_3 | UIFSM-002       | FY-2223              | December               | 2022              | 5630.00                   |
    | UIFSM-AY-2223-10017381-1_3 | UIFSM-002       | FY-2223              | February               | 2023              | 5331.00                   |
    | UIFSM-AY-2223-10017381-1_3 | UIFSM-002       | FY-2223              | May                    | 2023              | 2227.00                   |
    | UIFSM-AY-2223-10017381-1_3 | UIFSM-002       | FY-2223              | July                   | 2023              | 2473.00                   |
 
 
 
 
 
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
    | 10017381 | 10017381 Co Co  | UIFSM-AY-2223-Contract-Provider-10017381-1_3            | 1_3            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (College)  | UIFSM                       | 16-19ED2223     | Scheduling        | Awaiting Release  | 50906.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CofG_College]    | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | UIFSM-AY-2223-Contract-Provider-10017381-1_3            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 50906.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017381 | UIFSM-AY-2223-Contract-Provider-10017381-1_3            | 1_3            | AY-2223 | UIFSM                       | 50906.00    | [CofG_College]  | ?                 | ?                                 |

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
    When  I retrieve the latest contract details from CRM for provider '10017381' for FundingType 'EDSK' and period '2223'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017381' for FundingType 'EDSK' and period '2223' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017381 | 10017381 Co Co  | UIFSM-AY-2223-Contract-Provider-10017381-1_3            | 1_3            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (College)  | UIFSM                       | 16-19ED2223     | Released          | Released          | 50906.00    | EDSK-381      | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CofG_College]  | ?          | ?                   |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | UIFSM-AY-2223-Contract-Provider-10017381-1_3            | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | UIFSM-AY-2223-Contract-Provider-10017381-1_3            | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017381 | UIFSM-AY-2223-Contract-Provider-10017381-1_3            | 1_3            | AY-2223 | UIFSM                       | 50906.00    | [CofG_College]  | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | UIFSM-AY-2223-Contract-Provider-10017381-1_3            | EDSK-381     | 1               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus     | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017381 | EDSK-381           | 1                     | 1                        | Draft              | Awaiting Documentation                    | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017381 | EDSK-381           | 1                     | 0                        | Superseded Draft   | ?                                         | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017381 | ESFA-381           | 1                     | 0                        | Draft              | ?                                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017381 | EDSK-381           | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 93030.00      | 1                     | 1                        | 01/08/2022        | 31/07/2023      | True          | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | Initiate Document Merge  | Yes                   | ESFA-381           | AY2223 | ?               | 10017381 Co Co  | Active | Document Management Team  | ?                      |
    | 10017381 | ESFA-381           | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2022        | 31/07/2023      | False         | False               | ?             | Conditions of Funding (Grant) (College)   | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017381 Co Co  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocation has been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017381 | EDSK-381           | [AllocRef_16ED]       | ?                             | 50906.00        | ?             | ?                | 01/08/2022 | 31/07/2023 | 1619ED        | 1619ED2223          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableName                                                       | DeliverableDescription   |
    | EDSK-381       | [AllocRef_16ED] | 934             | 26784.00  | 2937.00  | 0.00     | 0.00     | 4486.00  | 0.00     | 5966.00  | 5528.00  | 0.00     | 4716.00  | 0.00     | 3151.00  | 0.00     | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)    |                          |
    | EDSK-381       | [AllocRef_16ED] | 935             | 24122.00  | 3285.00  | 0.00     | 5176.00  | 0.00     | 5630.00  | 0.00     | 5331.00  | 0.00     | 0.00     | 2227.00  | 0.00     | 2473.00  | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)      |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM
    Then  there are '60' deliverable period rows in CRM linked to the latest version of contract 'EDSK-381'





    # Part 3: Publish and approve v1.1
    
    # Publish contract v1.1

    # Change the date 
    Given the override date is '07/07/2022'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017381_EDSK-381_v1.pdf' is created in 'EDSK-2223-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract 'EDSK-381'
    And   the latest version of contract 'EDSK-381' and master 'ESFA-381' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus     | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017381 | EDSK-381           | 1                     | 1                        | Draft              | Published to Provider   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017381 | EDSK-381           | 1                     | 0                        | Superseded Draft   | ?                       | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017381 | ESFA-381           | 1                     | 0                        | Draft              | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |





    # Approve contract v1.1

    # Change the date 
    Given the override date is '09/07/2022'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-381' and ContractNumber 'EDSK-381' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-381' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus     | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017381 | EDSK-381           | 1                     | 1                        | Approved           | Approved                | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017381 | EDSK-381           | 1                     | 0                        | Superseded Draft   | ?                       | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017381 | ESFA-381           | 1                     | 0                        | Draft              | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    And   the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy                | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017381 | 10017381 Co Co  | UIFSM-AY-2223-Contract-Provider-10017381-1_3            | 1_3            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (College)  | UIFSM                       | 16-19ED2223     | Contract Approved | Contract Approved | 50906.00    | [ContractNo]  | 1                 | CRM Integration       | CRM Integration           | ?                         | [CofG_College]  | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017381 | UIFSM-AY-2223-Contract-Provider-10017381-1_3            | 1_3            | AY-2223 | UIFSM                       | 50906.00    | [CofG_College]  | ContractApproved  | ContractApproved                  |



 
 
    # Part 4: Add actuals to the contract for 16-18TRN2223

    # Change the date
    Given the override date is '02/10/2022'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017381'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2022
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202208 | 16-18TRN2223            | 16TR-381                 | ?          | 2               | 0            | 266.84      |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202208 | 16-18TRN2223            | 16TR-381                 | ?          | 3               | 0            | 1210.72     |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202209 | 16-18TRN2223            | 16TR-381                 | ?          | 2               | 0            | 434.08      |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202209 | 16-18TRN2223            | 16TR-381                 | ?          | 3               | 0            | 895.93      |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202210 | 16-18TRN2223            | 16TR-381                 | ?          | 2               | 0            | 973.93      |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202210 | 16-18TRN2223            | 16TR-381                 | ?          | 3               | 0            | 1271.18     |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202211 | 16-18TRN2223            | 16TR-381                 | ?          | 2               | 0            | 270.10      |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202211 | 16-18TRN2223            | 16TR-381                 | ?          | 3               | 0            | 398.16      |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202212 | 16-18TRN2223            | 16TR-381                 | ?          | 2               | 0            | 748.78      |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202212 | 16-18TRN2223            | 16TR-381                 | ?          | 3               | 0            | 1164.46     |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202301 | 16-18TRN2223            | 16TR-381                 | ?          | 2               | 0            | 749.26      |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202301 | 16-18TRN2223            | 16TR-381                 | ?          | 3               | 0            | 1296.23     |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202302 | 16-18TRN2223            | 16TR-381                 | ?          | 2               | 0            | 1360.58     |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202302 | 16-18TRN2223            | 16TR-381                 | ?          | 3               | 0            | 973.65      |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202303 | 16-18TRN2223            | 16TR-381                 | ?          | 2               | 0            | 450.40      |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202303 | 16-18TRN2223            | 16TR-381                 | ?          | 3               | 0            | 1369.11     |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202304 | 16-18TRN2223            | 16TR-381                 | ?          | 2               | 0            | 1425.44     |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202304 | 16-18TRN2223            | 16TR-381                 | ?          | 3               | 0            | 1491.06     |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202305 | 16-18TRN2223            | 16TR-381                 | ?          | 2               | 0            | 824.74      |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202305 | 16-18TRN2223            | 16TR-381                 | ?          | 3               | 0            | 1028.88     |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202306 | 16-18TRN2223            | 16TR-381                 | ?          | 2               | 0            | 410.27      |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202306 | 16-18TRN2223            | 16TR-381                 | ?          | 3               | 0            | 956.52      |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202307 | 16-18TRN2223            | 16TR-381                 | ?          | 2               | 0            | 980.92      |
    | ILR2223        | R02                  | ORG0017381     | CM             | 202307 | 16-18TRN2223            | 16TR-381                 | ?          | 3               | 0            | 1465.21     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-381       | 16TR-381           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-381       | 16TR-381           | 2               | 700.92    | 266.84   | 434.08   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-381       | 16TR-381           | 3               | 2106.65   | 1210.72  | 895.93   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-381       | 16TR-381           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-381       | 16TR-381           | 2               | 700.92    | 0.00     | 700.92   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-381       | 16TR-381           | 3               | 2106.65   | 0.00     | 2106.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-381       | 16TR-381           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-381       | 16TR-381           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-381       | 16TR-381           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-381       | 16TR-381           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-381       | 16TR-381           | 2               | 700.92    | 0.00     | 700.92   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-381       | 16TR-381           | 3               | 2106.65   | 0.00     | 2106.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    |
    | 10017381 | EDSK-381       | 16TR-381           | 2201300                  | 0.00      | 700.92    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017381 | EDSK-381       | 16TR-381           | 2201350                  | 0.00      | 2106.65   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 





#    # Part 5: CDA for 1619ED2223
#
#    # Change the date
#    Given the override date is '06/10/2022'
#
#    # Run the CDA report for 1619ED2223
#    Given there is no CDA report named 'CDA Last Approved Version A381.csv'
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version               | Suffix |
#    | 1619ED2223            | Last Approved Version | A381   |
#
#    Then  a report named 'CDA Last Approved Version A381.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName               | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription   | Deliverable                                                          | DeliverableParent   | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)     |                     | 8                 | 2022            | 2022/23       |              | 3285         |              | 0             |              | Yes                | 3285.00        | 0.00             | 0.00                  | 0.00           | 3285.00         |             | No            |                   |        | 2521300           |                          |                   | Aug              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)     |                     | 9                 | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2521300           |                          |                   | Sep              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)     |                     | 10                | 2022            | 2022/23       |              | 5176         |              | 0             |              | Yes                | 5176.00        |                  | 0.00                  | 0.00           | 5176.00         |             | No            |                   |        | 2521300           |                          |                   | Oct              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)     |                     | 11                | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2521300           |                          |                   | Nov              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)     |                     | 12                | 2022            | 2022/23       |              | 5630         |              | 0             |              | Yes                | 5630.00        |                  | 0.00                  | 0.00           | 5630.00         |             | No            |                   |        | 2521300           |                          |                   | Dec              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)     |                     | 1                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2521300           |                          |                   | Jan              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)     |                     | 2                 | 2023            | 2022/23       |              | 5331         |              | 0             |              | Yes                | 5331.00        |                  | 0.00                  | 0.00           | 5331.00         |             | No            |                   |        | 2521300           |                          |                   | Feb              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)     |                     | 3                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2521300           |                          |                   | Mar              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)     |                     | 4                 | 2023            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2521300           |                          |                   | Apr              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)     |                     | 5                 | 2023            | 2023/24       |              | 2227         |              | 0             |              | Yes                | 2227.00        |                  | 0.00                  | 0.00           | 2227.00         |             | No            |                   |        | 2521300           |                          |                   | May              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)     |                     | 6                 | 2023            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2521300           |                          |                   | Jun              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Final Payment) (NMSS)     |                     | 7                 | 2023            | 2023/24       |              | 2473         |              | 0             |              | Yes                | 2473.00        |                  | 0.00                  | 0.00           | 2473.00         |             | No            |                   |        | 2521300           |                          |                   | Jul              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)   |                     | 8                 | 2022            | 2022/23       |              | 2937         |              | 0             |              | Yes                | 2937.00        | 0.00             | 0.00                  | 0.00           | 2937.00         |             | No            |                   |        | 2521300           |                          |                   | Aug              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)   |                     | 9                 | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2521300           |                          |                   | Sep              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)   |                     | 10                | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2521300           |                          |                   | Oct              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)   |                     | 11                | 2022            | 2022/23       |              | 4486         |              | 0             |              | Yes                | 4486.00        |                  | 0.00                  | 0.00           | 4486.00         |             | No            |                   |        | 2521300           |                          |                   | Nov              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)   |                     | 12                | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2521300           |                          |                   | Dec              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)   |                     | 1                 | 2023            | 2022/23       |              | 5966         |              | 0             |              | Yes                | 5966.00        |                  | 0.00                  | 0.00           | 5966.00         |             | No            |                   |        | 2521300           |                          |                   | Jan              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)   |                     | 2                 | 2023            | 2022/23       |              | 5528         |              | 0             |              | Yes                | 5528.00        |                  | 0.00                  | 0.00           | 5528.00         |             | No            |                   |        | 2521300           |                          |                   | Feb              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)   |                     | 3                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2521300           |                          |                   | Mar              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)   |                     | 4                 | 2023            | 2023/24       |              | 4716         |              | 0             |              | Yes                | 4716.00        |                  | 0.00                  | 0.00           | 4716.00         |             | No            |                   |        | 2521300           |                          |                   | Apr              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)   |                     | 5                 | 2023            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2521300           |                          |                   | May              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)   |                     | 6                 | 2023            | 2023/24       |              | 3151         |              | 0             |              | Yes                | 3151.00        |                  | 0.00                  | 0.00           | 3151.00         |             | No            |                   |        | 2521300           |                          |                   | Jun              |
#    | 1619ED2223              | 10017381 | 10017381 Co Co             |               |                             | [AllocRef_16ED]          | EDSK-381       | ESFA-381                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                |                          | Pre-16 Universal Infant Free School Meals (Initial Payment) (NMSS)   |                     | 7                 | 2023            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2521300           |                          |                   | Jul              |





    # Part 16. Payment batch for 16-18TRN(PoA) and 1619ED(PoP)

    # Payment Batch for 1619ED(PoP) for Oct-22

    # Change the date
    Given the override date is '04/10/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '1619ED2223' AccountingPaymentPeriod '202207' CensusEndDate '04/10/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_16ED]          | 202210 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 1619ED2223                 | 202210               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 1619ED2223                 | 202210               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '1619ED2223' PaymentPeriod '202207' CensusEndDate '04/10/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A381_16ED.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod '1619ED2223' PaymentPeriod '202207' CensusEndDate '04/10/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef   | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | 16ED                   | 2022          | 07             | 04          | ?       | [AllocRef_16ED] | 5176.00         | PROFILE          | UIFSM-Uni Infant FSM               | 2022-10-18 | 2022-08-01   | 2023-07-31 | ?              | 10017381 | 2521300    |





    # Payment Batch for 16-18TRN2223(PoA) for Sep-22

    # Change the date
    Given the override date is '10/10/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '16-18TRN2223' AccountingPaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | 16TR-381                 | 202209 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 16-18TRN2223               | 202209               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 16-18TRN2223               | 202209               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18TRN2223' PaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A381_16TR.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18TRN2223' PaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | 16TR                   | 2022          | 06             | 10          | ?       | 16TR-381      | 700.92          | RECONCILIATION   | 16-18Traineeships                  | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017381 | 2201300    |
    | 16TR                   | 2022          | 06             | 10          | ?       | 16TR-381      | 2106.65         | RECONCILIATION   | 16-18TraineeshipBurs               | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017381 | 2201350    |



    # Tidy Up
    Given the override date is reset
    
@AcceptanceTest @Complete
@CFS
Scenario: A382 Import 1619ED2223 FAs for a Local Authority with three Delivery Orgs. CofG_LA. Publish and approve. Check docs, PaaS and CRM

    # 1. Import FAs for Local Authority (10017382 Council) with funding plus three Delivery Orgs
    # 2. Release the Release Group
    # 3. Check that the Contract Allocations have been created correctly in CRM for the Contracting Org. Check docs
    # 4. Check that the Contract Allocations have been created correctly in CRM for Delivery Org 1 (10002637, Harrolds School). Check docs
    # 5. Check that the Contract Allocations have been created correctly in CRM for Delivery Org 2 (10004989, Parkside School). Check docs
    # 6. Check that the Contract Allocations have been created correctly in CRM for Delivery Org 3 (10007285, Westlake School). Check docs
    # 7. Publish and approve the contract


    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017382'
    And   there is no Funding Allocation data in CRM for UKPRN '10017382'
    And   there is no Contract, Task or Workflow data for UKPRN '10017382'
   #And   there are no notifications of type 'Release Rejected'
    And   there are no notifications in CRM of type 'Release Rejected' for UKPRN '10017382'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017382'

    # Cleardown Sharepoint appendix docs
    And   there are no files prefixed '10017382' in the Sharepoint 'EDSK-2223-Input-Appendices' folder

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables

    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (LA)      |

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017382' 
    And   there is no Organisation data in CRM for UKPRN '10002637' 
    And   there is no Organisation data in CRM for UKPRN '10004989' 
    And   there is no Organisation data in CRM for UKPRN '10007285' 

    And   there is no caseload advisor for UKPRN '10017382' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017382 |
    | 10002637 |
    | 10004989 | 
    | 10007285 |

    And   caseload advisor 'FCS2 Test' is assigned to provider '10017382 Co Ltd' with UKPRN '10017382' and OrgId 'ORG0017382' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name             | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017382 | 117382 | 10017382 Council | 0              | Active                | Yes           | AA017382      | ?             | 102 Handside Lane      | ?                      | ?                      | ?                      | Welwyn Garden City     | Hertfordshire          | AL8 6SY   |
    | 10002637 | 102637 | Harrolds School  | 0              | Active                | Yes           | AA002637      | ?             | 1 Christies Warehouse  | Wherry Quay            | ?                      | ?                      | Ipswich                | Suffolk                | IP4 1AS   |
    | 10004989 | 104989 | Parkside School  | 0              | Active                | Yes           | AA004989      | ?             | 26a High Street        | Hounslow               | Middlesex              | ?                      | ?                      | ?                      | TW3 1NW   |
    | 10007285 | 107285 | Westlake School  | 0              | Active                | Yes           | AA007285      | ?             | 5 Alton House          | Gatehouse Way          | ?                      | ?                      | Alyesbury              | Buckinghamshire        | HP19 8HN  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017382 |
    | 10002637 |
    | 10004989 |
    | 10007285 |





    # Part 1: Import FA for Loacal Authority (10017382 Council) with funding plus three Delivery Orgs

    # Populate the stub with 1619 (Local authority) data for the Contracting Org

    # Change the date 
    Given the override date is '01/07/2022'

    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017382 | 1619-AS-2223-Contract-LocalAuthority-10017382-2_3     | 2_3            | 1619                        | AS-2223            | 76744.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | 1619-AS-2223-10017382-2_3  | 2_3                    | 1619-AS-2223-Contract-LocalAuthority-10017382-2_3     | 10017382      | Local authority                    | Local authority                  | 76744.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2223-10017382-2_3  | 1619-002        | 13252.00         | Payment         |
    | 1619-AS-2223-10017382-2_3  | 1619-003        | 11052.00         | Payment         |
    | 1619-AS-2223-10017382-2_3  | 1619-005        | 8854.00          | Payment         |
    | 1619-AS-2223-10017382-2_3  | 1619-008        | 28085.00         | Payment         |
    | 1619-AS-2223-10017382-2_3  | 1619-025        | 15501.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2223-10017382-2_3  | 1619-002        | FY-2223              | August                 | 2022              | 2514.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-002        | FY-2223              | December               | 2022              | 4026.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-002        | FY-2223              | March                  | 2023              | 2429.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-002        | FY-2223              | July                   | 2023              | 4283.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-003        | FY-2223              | August                 | 2022              | 2411.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-003        | FY-2223              | January                | 2023              | 5530.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-003        | FY-2223              | July                   | 2023              | 3111.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-005        | FY-2223              | September              | 2022              | 2918.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-005        | FY-2223              | June                   | 2023              | 5936.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-008        | FY-2223              | August                 | 2022              | 4562.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-008        | FY-2223              | November               | 2022              | 5085.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-008        | FY-2223              | January                | 2023              | 5640.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-008        | FY-2223              | March                  | 2023              | 2911.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-008        | FY-2223              | May                    | 2023              | 4973.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-008        | FY-2223              | June                   | 2023              | 4914.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-025        | FY-2223              | September              | 2022              | 3392.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-025        | FY-2223              | November               | 2022              | 3536.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-025        | FY-2223              | March                  | 2023              | 2040.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-025        | FY-2223              | May                    | 2023              | 2527.00                   |
    | 1619-AS-2223-10017382-2_3  | 1619-025        | FY-2223              | June                   | 2023              | 4006.00                   |
 
 
 
 
 
    # Populate the stub with 1619 data for three Delivery Orgs

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017382 | 1619-AS-2223-Contract-LocalAuthoritySsf-10017382-4_2  | 4_2            | 1619                        | AS-2223            | 206525.00         |
 
    # Provider Funding Allocation (One row per delivery org)
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType                       | ProviderSubType                  | ProviderFundingTotalValue |
    | 1619-AS-2223-10002637-4_2  | 4_2                    | 1619-AS-2223-Contract-LocalAuthoritySsf-10017382-4_2  | 10002637      | Local authority maintained schools | Community school                 | 80194.00                  |
    | 1619-AS-2223-10004989-4_2  | 4_2                    | 1619-AS-2223-Contract-LocalAuthoritySsf-10017382-4_2  | 10004989      | Local authority maintained schools | Foundation school                | 60294.00                  |
    | 1619-AS-2223-10007285-4_2  | 4_2                    | 1619-AS-2223-Contract-LocalAuthoritySsf-10017382-4_2  | 10007285      | Local authority maintained schools | Voluntary controlled school      | 66037.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2223-10002637-4_2  | 1619-002        | 23429.00         | Payment         |
    | 1619-AS-2223-10002637-4_2  | 1619-006        | 7044.00          | Payment         |
    | 1619-AS-2223-10002637-4_2  | 1619-007        | 18851.00         | Payment         |
    | 1619-AS-2223-10002637-4_2  | 1619-008        | 18426.00         | Payment         |
    | 1619-AS-2223-10002637-4_2  | 1619-011        | 12444.00         | Payment         |    
    #
    | 1619-AS-2223-10004989-4_2  | 1619-001        | 3670.00          | Payment         |
    | 1619-AS-2223-10004989-4_2  | 1619-005        | 15756.00         | Payment         |
    | 1619-AS-2223-10004989-4_2  | 1619-006        | 11656.00         | Payment         |
    | 1619-AS-2223-10004989-4_2  | 1619-009        | 21299.00         | Payment         |
    | 1619-AS-2223-10004989-4_2  | 1619-020        | 7913.00          | Payment         |
    #
    | 1619-AS-2223-10007285-4_2  | 1619-002        | 3061.00          | Payment         |
    | 1619-AS-2223-10007285-4_2  | 1619-009        | 17992.00         | Payment         |
    | 1619-AS-2223-10007285-4_2  | 1619-010        | 5471.00          | Payment         |
    | 1619-AS-2223-10007285-4_2  | 1619-011        | 16761.00         | Payment         |
    | 1619-AS-2223-10007285-4_2  | 1619-025        | 22752.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2223-10002637-4_2  | 1619-002        | FY-2223              | September              | 2022              | 5161.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-002        | FY-2223              | November               | 2022              | 5785.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-002        | FY-2223              | March                  | 2023              | 4973.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-002        | FY-2223              | May                    | 2023              | 3408.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-002        | FY-2223              | July                   | 2023              | 4102.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-006        | FY-2223              | January                | 2023              | 2817.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-006        | FY-2223              | February               | 2023              | 4227.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-007        | FY-2223              | August                 | 2022              | 4882.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-007        | FY-2223              | December               | 2022              | 2975.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-007        | FY-2223              | March                  | 2023              | 3633.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-007        | FY-2223              | May                    | 2023              | 4599.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-007        | FY-2223              | June                   | 2023              | 2762.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-008        | FY-2223              | August                 | 2022              | 2032.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-008        | FY-2223              | November               | 2022              | 5975.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-008        | FY-2223              | February               | 2023              | 3213.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-008        | FY-2223              | April                  | 2023              | 3496.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-008        | FY-2223              | July                   | 2023              | 3710.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-011        | FY-2223              | September              | 2022              | 5234.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-011        | FY-2223              | December               | 2022              | 3429.00                   |
    | 1619-AS-2223-10002637-4_2  | 1619-011        | FY-2223              | July                   | 2023              | 3781.00                   |
    #
    | 1619-AS-2223-10004989-4_2  | 1619-001        | FY-2223              | June                   | 2023              | 3670.00                   |
    | 1619-AS-2223-10004989-4_2  | 1619-005        | FY-2223              | August                 | 2022              | 3584.00                   |
    | 1619-AS-2223-10004989-4_2  | 1619-005        | FY-2223              | November               | 2022              | 4310.00                   |
    | 1619-AS-2223-10004989-4_2  | 1619-005        | FY-2223              | March                  | 2023              | 2131.00                   |
    | 1619-AS-2223-10004989-4_2  | 1619-005        | FY-2223              | July                   | 2023              | 5731.00                   |
    | 1619-AS-2223-10004989-4_2  | 1619-006        | FY-2223              | September              | 2022              | 2261.00                   |
    | 1619-AS-2223-10004989-4_2  | 1619-006        | FY-2223              | November               | 2022              | 2165.00                   |
    | 1619-AS-2223-10004989-4_2  | 1619-006        | FY-2223              | March                  | 2023              | 4328.00                   |
    | 1619-AS-2223-10004989-4_2  | 1619-006        | FY-2223              | July                   | 2023              | 2902.00                   |
    | 1619-AS-2223-10004989-4_2  | 1619-009        | FY-2223              | September              | 2022              | 4633.00                   |
    | 1619-AS-2223-10004989-4_2  | 1619-009        | FY-2223              | December               | 2022              | 2042.00                   |
    | 1619-AS-2223-10004989-4_2  | 1619-009        | FY-2223              | February               | 2023              | 5813.00                   |
    | 1619-AS-2223-10004989-4_2  | 1619-009        | FY-2223              | April                  | 2023              | 3564.00                   |
    | 1619-AS-2223-10004989-4_2  | 1619-009        | FY-2223              | July                   | 2023              | 5247.00                   |
    | 1619-AS-2223-10004989-4_2  | 1619-020        | FY-2223              | August                 | 2022              | 4859.00                   |
    | 1619-AS-2223-10004989-4_2  | 1619-020        | FY-2223              | February               | 2023              | 3054.00                   |
    #
    | 1619-AS-2223-10007285-4_2  | 1619-002        | FY-2223              | September              | 2022              | 3061.00                   |
    | 1619-AS-2223-10007285-4_2  | 1619-009        | FY-2223              | October                | 2022              | 5929.00                   |
    | 1619-AS-2223-10007285-4_2  | 1619-009        | FY-2223              | November               | 2022              | 3818.00                   |
    | 1619-AS-2223-10007285-4_2  | 1619-009        | FY-2223              | April                  | 2023              | 4272.00                   |
    | 1619-AS-2223-10007285-4_2  | 1619-009        | FY-2223              | June                   | 2023              | 3973.00                   |
    | 1619-AS-2223-10007285-4_2  | 1619-010        | FY-2223              | August                 | 2022              | 5471.00                   |
    | 1619-AS-2223-10007285-4_2  | 1619-011        | FY-2223              | October                | 2022              | 4955.00                   |
    | 1619-AS-2223-10007285-4_2  | 1619-011        | FY-2223              | January                | 2023              | 3289.00                   |
    | 1619-AS-2223-10007285-4_2  | 1619-011        | FY-2223              | April                  | 2023              | 4288.00                   |
    | 1619-AS-2223-10007285-4_2  | 1619-011        | FY-2223              | May                    | 2023              | 4229.00                   |
    | 1619-AS-2223-10007285-4_2  | 1619-025        | FY-2223              | August                 | 2022              | 2761.00                   |
    | 1619-AS-2223-10007285-4_2  | 1619-025        | FY-2223              | January                | 2023              | 4310.00                   |
    | 1619-AS-2223-10007285-4_2  | 1619-025        | FY-2223              | March                  | 2023              | 5789.00                   |
    | 1619-AS-2223-10007285-4_2  | 1619-025        | FY-2223              | May                    | 2023              | 5352.00                   |
    | 1619-AS-2223-10007285-4_2  | 1619-025        | FY-2223              | June                   | 2023              | 4540.00                   |

 



    # Consume stub data
 
    # Change the date 
    Given the override date is '03/07/2022'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2223        | 16-19ED2223  | Conditions of Funding (Grant) (LA)      | CofG_LA                   |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA = [CofG_LA]' is written to the Output window

    # Check the CRM Funding Allocations data (J125) {F7}
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017382 | 10017382 Council | 1619-AS-2223-Contract-LocalAuthority-10017382-2_3       | 2_3            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2223     | Scheduling        | Awaiting Release        | 76744.00    | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |
    | 10017382 | 10017382 Council | 1619-AS-2223-Contract-LocalAuthoritySsf-10017382-4_2    | 4_2            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2223     | Scheduling        | Awaiting Release        | 206525.00   | ?             | ?                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |

    # Check the CRM Funding Allocation History data {F8}
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2223-Contract-LocalAuthority-10017382-2_3       | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |
    | 1619-AS-2223-Contract-LocalAuthoritySsf-10017382-4_2    | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 2               | 283269.00       |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017382 | 1619-AS-2223-Contract-LocalAuthority-10017382-2_3       | 2_3            | AS-2223 | 1619                        | 76744.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017382 | 1619-AS-2223-Contract-LocalAuthoritySsf-10017382-4_2    | 4_2            | AS-2223 | 1619                        | 206525.00   | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Part 2: Release the Release Group

    # Change the date 
    Given the override date is '05/07/2022'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CofG_LA]         |

    # Write the following values to the output window
    And   message 'ReleaseGroup CofG_LA = [CofG_LA]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CofG_LA]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 2               | 283269.00       |

    # Retrieve parameters from CRM 
    When  I retrieve the latest EFA contract details from CRM for provider '10017382' for FundingType 'EDSK' and period '2223' and Delivery Organisation '10017382' 

    # Check the CRM Funding Allocations data (J125) {F7}   Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017382 | 10017382 Council | 1619-AS-2223-Contract-LocalAuthority-10017382-2_3       | 2_3            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2223     | Released          | Released                | 76744.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |
    | 10017382 | 10017382 Council | 1619-AS-2223-Contract-LocalAuthoritySsf-10017382-4_2    | 4_2            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2223     | Released          | Released                | 206525.00   | [ContractNo]  | 1                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017382 | 1619-AS-2223-Contract-LocalAuthority-10017382-2_3       | 2_3            | AS-2223 | 1619                        | 76744.00    | [CofG_LA]       | ?                 | ?                                 |
    | 10017382 | 1619-AS-2223-Contract-LocalAuthoritySsf-10017382-4_2    | 4_2            | AS-2223 | 1619                        | 206525.00   | [CofG_LA]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2223-Contract-LocalAuthority-10017382-2_3       | [ContractNo] | 1               | 0                  | Yes            |
    | 1619-AS-2223-Contract-LocalAuthoritySsf-10017382-4_2    | [ContractNo] | 1               | 0                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CofG_LA]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017382 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017382 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017382 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 283269.00     | 1                     | 0                        | 01/08/2022        | 31/07/2023      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2223 | ?               | 10017382 Council | Active | Document Management Team  | ?                      |
    | 10017382 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2022        | 31/07/2023      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017382 Council | Active | CRM Integration           | ?                      |





    # Part 3: Check that the Contract Allocations have been created correctly in CRM for the Contracting Org. Check docs

    # Check CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider  | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017382 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 76744.00        | 10017382      | 10017382 Council  | 01/08/2022 | 31/07/2023 | 1619ED        | 1619ED2223          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableName                                          | DeliverableDescription   |
    | [ContractNo]   | [AllocRef_16ED] | 19              | 13252.00  | 2514.00  | 0.00     | 0.00     | 0.00     | 4026.00  | 0.00     | 0.00     | 2429.00  | 0.00     | 0.00     | 0.00     | 4283.00  | 16-19 Bursary Funds                                      |                          |
    | [ContractNo]   | [AllocRef_16ED] | 31              | 8854.00   | 0.00     | 2918.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5936.00  | 0.00     | 16-19 Free Meals                                         |                          |
    | [ContractNo]   | [AllocRef_16ED] | 33              | 11052.00  | 2411.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5530.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3111.00  | Residential Bursary Fund                                 |                          |
    | [ContractNo]   | [AllocRef_16ED] | 143             | 15501.00  | 0.00     | 3392.00  | 0.00     | 3536.00  | 0.00     | 0.00     | 0.00     | 2040.00  | 0.00     | 2527.00  | 4006.00  | 0.00     | 16-19 Tuition Fund                                       |                          |
    | [ContractNo]   | [AllocRef_16ED] | 914             | 28085.00  | 4562.00  | 0.00     | 0.00     | 5085.00  | 0.00     | 5640.00  | 0.00     | 2911.00  | 0.00     | 4973.00  | 4914.00  | 0.00     | 16-19 Advanced Maths Premium                             |                          |

    # Contract is now at 'Draft\Awaiting Documentation'

    # Check the deliverable count in CRM (5 deliverables * 12 mths * 4 allocations = 240)
    Then  there are '240' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check the contents of the Appendices for the Contracting Org (10017382, 10017382 Council)
    And   the file named '10017382_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017382 Council UKPRN: 10017382
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    16 to 19 Education
    10017382 Council [AllocRef_16ED] £46,994 £29,750 £76,744
    Total Funding for this contract: £283,269
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10017382 Council
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE PROVIDER
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 2 (July 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017382 Council THE SECRETARY OF STATE FOR
    102 Handside Lane EDUCATION
    Welwyn Garden City DEPARTMENT FOR EDUCATION
    Hertfordshire 20 GREAT SMITH STREET
    AND
    AL8 6SY LONDON
    SW1P 3BT
    Company No: AA017382
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 2 (July 2022) Page 2
    EDSK Version 2 (July 2022) Page 73
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2022) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 1 LA (July 2022) – Page 11
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2022) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017382 Council UKPRN: 10017382
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16-19 Bursary Funds £13,252 £2,514.00 £0.00 £0.00 £0.00 £4,026.00 £0.00 £0.00 £2,429.00 £0.00 £0.00 £0.00 £4,283.00
    16-19 Free Meals £8,854 £0.00 £2,918.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £5,936.00 £0.00
    16-19 Advanced Maths Premium £28,085 £4,562.00 £0.00 £0.00 £5,085.00 £0.00 £5,640.00 £0.00 £2,911.00 £0.00 £4,973.00 £4,914.00 £0.00
    Residential Bursary Fund £11,052 £2,411.00 £0.00 £0.00 £0.00 £0.00 £5,530.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,111.00
    16-19 Tuition Fund £15,501 £0.00 £3,392.00 £0.00 £3,536.00 £0.00 £0.00 £0.00 £2,040.00 £0.00 £2,527.00 £4,006.00 £0.00
    Total Funding £76,744 £9,487.00 £6,310.00 £0.00 £8,621.00 £4,026.00 £11,170.00 £0.00 £7,380.00 £0.00 £7,500.00 £14,856.00 £7,394.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2022) – Page 1
    EDSK Schedule 9 Version 2 (July 2022) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017382_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A382.pdf'

    
    
   
   
    # Part 4: Check that the Contract Allocations have been created correctly in CRM for Delivery Org 1 (10002637, Harrolds School). Check docs

    # Retrieve parameters from CRM for Delivery Org 1 (10002637, Harrolds School)
    When  I retrieve the latest EFA contract details from CRM for provider '10017382' for FundingType 'EDSK' and period '2223' and Delivery Organisation '10002637' 
    
     # Check that the Contract Allocations have been created correctly in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017382 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 80194.00        | 10002637      | Harrolds School  | 01/08/2022 | 31/07/2023 | 1619ED        | 1619ED2223          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableName                                          | DeliverableDescription   |  
    | [ContractNo]   | [AllocRef_16ED] | 13              | 23429.00  | 0.00     | 5161.00  | 0.00     | 5785.00  | 0.00     | 0.00     | 0.00     | 4973.00  | 0.00     | 3408.00  | 0.00     | 4102.00  | SSF Bursary Funds                                        |                          |
    | [ContractNo]   | [AllocRef_16ED] | 22              | 7044.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2817.00  | 4227.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 High Needs Element 2                               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 48              | 18426.00  | 2032.00  | 0.00     | 0.00     | 5975.00  | 0.00     | 0.00     | 3213.00  | 0.00     | 3496.00  | 0.00     | 0.00     | 3710.00  | SSF Advanced Maths Premium                               |                          |
    | [ContractNo]   | [AllocRef_16ED] | 51              | 12444.00  | 0.00     | 5234.00  | 0.00     | 0.00     | 3429.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3781.00  | Alternative Completions - Sporting Excellence            |                          |
    | [ContractNo]   | [AllocRef_16ED] | 114             | 18851.00  | 4882.00  | 0.00     | 0.00     | 0.00     | 2975.00  | 0.00     | 0.00     | 3633.00  | 0.00     | 4599.00  | 2762.00  | 0.00     | SSF Capacity and Delivery                                |                          |

    # Check the contents of the SoF and FA for Contracting Org 1 (10002637)
    And   the file named '10017382_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017382 Council UKPRN: 10017382
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    16 to 19 Education
    Harrolds School [AllocRef_16ED] £54,336 £25,858 £80,194
    Total Funding for this contract: £283,269
    Summary of Funding – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: Harrolds School UKPRN: 10002637
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16-19 High Needs Element 2 £7,044 £0.00 £0.00 £0.00 £0.00 £0.00 £2,817.00 £4,227.00 £0.00 £0.00 £0.00 £0.00 £0.00
    SSF Bursary Funds £23,429 £0.00 £5,161.00 £0.00 £5,785.00 £0.00 £0.00 £0.00 £4,973.00 £0.00 £3,408.00 £0.00 £4,102.00
    SSF Capacity and Delivery £18,851 £4,882.00 £0.00 £0.00 £0.00 £2,975.00 £0.00 £0.00 £3,633.00 £0.00 £4,599.00 £2,762.00 £0.00
    SSF Advanced Maths Premium £18,426 £2,032.00 £0.00 £0.00 £5,975.00 £0.00 £0.00 £3,213.00 £0.00 £3,496.00 £0.00 £0.00 £3,710.00
    Alternative Completions - Sporting Excellence £12,444 £0.00 £5,234.00 £0.00 £0.00 £3,429.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,781.00
    Total Funding £80,194 £6,914.00 £10,395.00 £0.00 £11,760.00 £6,404.00 £2,817.00 £7,440.00 £8,606.00 £3,496.00 £8,007.00 £2,762.00 £11,593.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """
    
    
    
    

    # Part 5: Check that the Contract Allocations have been created correctly in CRM for Delivery Org 2 (10004989, Parkside School). Check docs
    
    # Retrieve parameters from CRM for Delivery Org 2 (10004989, Parkside School)
    When  I retrieve the latest EFA contract details from CRM for provider '10017382' for FundingType 'EDSK' and period '2223' and Delivery Organisation '10004989' 
    
     # Check that the Contract Allocations have been created correctly in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017382 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 60294.00        | 10004989      | Parkside School  | 01/08/2022 | 31/07/2023 | 1619ED        | 1619ED2223          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableName                                       | DeliverableDescription   |  
    | [ContractNo]   | [AllocRef_16ED]    | 2               | 3670.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3670.00  | 0.00     | SSF Programme Funding                                 |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 22              | 11656.00  | 0.00     | 2261.00  | 0.00     | 2165.00  | 0.00     | 0.00     | 0.00     | 4328.00  | 0.00     | 0.00     | 0.00     | 2902.00  | 16-19 High Needs Element 2                            |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 47              | 15756.00  | 3584.00  | 0.00     | 0.00     | 4310.00  | 0.00     | 0.00     | 0.00     | 2131.00  | 0.00     | 0.00     | 0.00     | 5731.00  | SSF Free Meals                                        |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 52              | 7913.00   | 4859.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3054.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Alternative Completions - Sea Fishing                 |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 138             | 21299.00  | 0.00     | 4633.00  | 0.00     | 0.00     | 2042.00  | 0.00     | 5813.00  | 0.00     | 3564.00  | 0.00     | 0.00     | 5247.00  | SSF High Value Courses Premium                        |                          |

    # Check the contents of the SoF and FA for Contracting Org 1 (10002637)
    And   the file named '10017382_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """ 
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017382 Council UKPRN: 10017382
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    16 to 19 Education
    Parkside School [AllocRef_16ED] £39,180 £21,114 £60,294
    Total Funding for this contract: £283,269
    Summary of Funding – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: Parkside School UKPRN: 10004989
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16-19 High Needs Element 2 £11,656 £0.00 £2,261.00 £0.00 £2,165.00 £0.00 £0.00 £0.00 £4,328.00 £0.00 £0.00 £0.00 £2,902.00
    SSF Programme Funding £3,670 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,670.00 £0.00
    SSF Free Meals £15,756 £3,584.00 £0.00 £0.00 £4,310.00 £0.00 £0.00 £0.00 £2,131.00 £0.00 £0.00 £0.00 £5,731.00
    Alternative Completions - Sea Fishing £7,913 £4,859.00 £0.00 £0.00 £0.00 £0.00 £0.00 £3,054.00 £0.00 £0.00 £0.00 £0.00 £0.00
    SSF High Value Courses Premium £21,299 £0.00 £4,633.00 £0.00 £0.00 £2,042.00 £0.00 £5,813.00 £0.00 £3,564.00 £0.00 £0.00 £5,247.00
    Total Funding £60,294 £8,443.00 £6,894.00 £0.00 £6,475.00 £2,042.00 £0.00 £8,867.00 £6,459.00 £3,564.00 £0.00 £3,670.00 £13,880.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """
    
    
    


    # Part 6: Check that the Contract Allocations have been created correctly in CRM for Delivery Org 3 (10007285, Westlake School). Check docs
    
    # Retrieve parameters from CRM for Delivery Org 3 (10007285, Westlake School)
    When  I retrieve the latest EFA contract details from CRM for provider '10017382' for FundingType 'EDSK' and period '2223' and Delivery Organisation '10007285' 
    
     # Check that the Contract Allocations have been created correctly in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017382 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 66037.00        | 10007285      | Westlake School  | 01/08/2022 | 31/07/2023 | 1619ED        | 1619ED2223          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableName                                       | DeliverableDescription   |  
    | [ContractNo]   | [AllocRef_16ED]    | 13              | 3061.00   | 0.00     | 3061.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF Bursary Funds                                           |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 51              | 16761.00  | 0.00     | 0.00     | 4955.00  | 0.00     | 0.00     | 3289.00  | 0.00     | 0.00     | 4288.00  | 4229.00  | 0.00     | 0.00     | Alternative Completions - Sporting Excellence               |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 125             | 5471.00   | 5471.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Teacher's Pension Scheme 1619                               |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 138             | 17992.00  | 0.00     | 0.00     | 5929.00  | 3818.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4272.00  | 0.00     | 3973.00  | 0.00     | SSF High Value Courses Premium                              |                          |
    | [ContractNo]   | [AllocRef_16ED]    | 146             | 22752.00  | 2761.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4310.00  | 0.00     | 5789.00  | 0.00     | 5352.00  | 4540.00  | 0.00     | SSF Tuition Fund                                            |                          |

    # Check the contents of the SoF and FA for Contracting Org 1 (10002637)
    And   the file named '10017382_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """ 
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017382 Council UKPRN: 10017382
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    16 to 19 Education
    Westlake School [AllocRef_16ED] £39,383 £26,654 £66,037
    Total Funding for this contract: £283,269
    Summary of Funding – Page 1

    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: Westlake School UKPRN: 10007285
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    SSF Bursary Funds £3,061 £0.00 £3,061.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Alternative Completions - Sporting Excellence £16,761 £0.00 £0.00 £4,955.00 £0.00 £0.00 £3,289.00 £0.00 £0.00 £4,288.00 £4,229.00 £0.00 £0.00
    Teacher's Pension Scheme 1619 £5,471 £5,471.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    SSF High Value Courses Premium £17,992 £0.00 £0.00 £5,929.00 £3,818.00 £0.00 £0.00 £0.00 £0.00 £4,272.00 £0.00 £3,973.00 £0.00
    SSF Tuition Fund £22,752 £2,761.00 £0.00 £0.00 £0.00 £0.00 £4,310.00 £0.00 £5,789.00 £0.00 £5,352.00 £4,540.00 £0.00
    Total Funding £66,037 £8,232.00 £3,061.00 £10,884.00 £3,818.00 £0.00 £7,599.00 £0.00 £5,789.00 £8,560.00 £9,581.00 £8,513.00 £0.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """





    # Remove all details from ContractManagement.CreatedContract for a contract
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-04 09:12:35.000 |





    # Part 7: Publish and approve the contract
    
    # Publish the contract

    # Change the date 
    Given the override date is '07/07/2022'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10017382_[ContractNo]_v1.pdf' is created in 'EDSK-2223-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017382 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017382 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |





    # Approve the contract

    # Change the date 
    Given the override date is '09/07/2022'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017382 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017382 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check the CRM Funding Allocations data (J125)  Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus               | Value       | ContractNo    | ContractVersionNo | CreatedBy        | ModifiedBy           | HoldReason                | ReleaseGroup    | QueuedOn   | QueuedDueToContract |
    | 10017382 | 10017382 Council | 1619-AS-2223-Contract-LocalAuthority-10017382-2_3       | 2_3            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2223     | Contract Approved | Contract Approved       | 76744.00    | [ContractNo]  | 1                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |
    | 10017382 | 10017382 Council | 1619-AS-2223-Contract-LocalAuthoritySsf-10017382-4_2    | 4_2            | Education & Skills Funding | AY2223  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2223     | Contract Approved | Contract Approved       | 206525.00   | [ContractNo]  | 1                 | CRM Integration  | CRM Integration      | ?                         | [CofG_LA]       | ?          | ?                   |

    # Check PaaS FundingAllocation.FundingAllocation (J131) {F9}
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017382 | 1619-AS-2223-Contract-LocalAuthority-10017382-2_3       | 2_3            | AS-2223 | 1619                        | 76744.00    | [CofG_LA]       | ContractApproved  | ContractApproved                  |
    | 10017382 | 1619-AS-2223-Contract-LocalAuthoritySsf-10017382-4_2    | 4_2            | AS-2223 | 1619                        | 206525.00   | [CofG_LA]       | ContractApproved  | ContractApproved                  |



    # Tidy Up
    Given the override date is reset

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    And   there is no data in the ContractRequest.FundingAllocationRelease table 

    # Clear down FundingAllocation.BulkUploadStatus (J148)
    And   there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @Withdrawn25072024
Scenario: A027 Bulk load an EDSK2223 contract with four FSP Groups. Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017027' 
    And   there are no terminated or closed allocations for UKPRN '10017027' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017027' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017027' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017027' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2223      |
    | AEBC-19TRN2223    |
    | 1619ED2223        |
    | STFIC2223         |
    | ALLB2223          |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017027'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017027' 
    And   there is no caseload advisor for UKPRN '10017027' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017027 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017027' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017027 Co Ltd' with UKPRN '10017027' and OrgId 'ORG0017027' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017027 | 117027 | 10017027 Co Ltd | 0              | Active                | Yes           | AA017027      | ?             | 5 Whittle Parkway      | ?                      | ?                      | ?                      | Slough                 | Berkshire              | SL1 6DQ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017027 |





    # Change the date
    Given the override date is '01/07/2022'

    # Bulk file CofG_LA with four FSP groups
    And   there are no files prefixed '10017027' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 06072022133711 v3_A027' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 06072022133711 v3_A027' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 06072022133711 v3_A027' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 06072022133711 v3_A027' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 06072022133711 v3_A027.xlsx' exists in the Datafiles folder and UKPRN '10017027' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017027' for FundingType 'EDSK' and period '2223'

    # Check that there isn't a blank page after 'EDSK Version 2 (July 2022) Page 1' 
    #    ie there should be data present before 'EDSK Version 2 (July 2022) Page 2' is detected
    Then  the file named '10017027_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: 10017027 Co Ltd UKPRN: 10017027
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    Advanced Learner Loans Bursary [AllocRef_ALLB] £36,235 £18,291 £54,526
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AECT] £19,546 £8,892 £28,438
    ESFA AEB - Short Term Funding Initiatives [AllocRef_STFC] £70,582 £31,666 £102,248
    of which Short Term Funding Initiative 1 £33,078 £21,746 £54,824
    of which Short Term Funding Initiative 2 £37,504 £9,920 £47,424
    16 to 18 Traineeships [AllocRef_16TR] £63,486 £43,952 £107,438
    16 to 19 Education [AllocRef_16ED] £643,520 £293,517 £937,037
    Total Funding for this contract: £1,229,687
    Summary of Funding – Page 1

    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10017027 Co Ltd
    Advanced Learner Loans
    ESFA-Funded Adult Education Budget
    Funding for
    16 to 18 Traineeships
    16 to 19 Education
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE PROVIDER
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 2 (July 2022) Page 1

    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017027 Co Ltd THE SECRETARY OF STATE FOR
    5 Whittle Parkway EDUCATION
    Slough DEPARTMENT FOR EDUCATION
    Berkshire 20 GREAT SMITH STREET
    AND
    SL1 6DQ LONDON
    SW1P 3BT
    Company No: AA017027
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 2 (July 2022) Page 2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017027_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A027.pdf'

    # Tidy Up
    Given the override date is reset
      