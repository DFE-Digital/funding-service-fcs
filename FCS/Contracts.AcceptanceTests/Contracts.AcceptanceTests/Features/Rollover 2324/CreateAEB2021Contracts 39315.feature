Feature: CreateAEB2021Contracts 39315

@AcceptanceTest @Withdrawn20251024
@Long2Run @Long2Run123
Scenario: S023 Create and approve a 21/22, 22/23 AEB2021 contract. Add 23/24 contract with shared Master. Publish and approve. Add actuals for 23/24. Payment Batch. Check docs, CRM and feed

    # 1. Create and approve a 21/22 contract
    # 2. Create and approve a 22/23 contract
    # 3. Bulk import a 23/24 contract (New Amendment)
    # 3. Check docs
    # 4. Publish and approve 23/24 v1 and check feed
    # 5. Add Actuals for 23/24 then check CRM
    # 6. Create and check the contents of the CDA report
    # 7. Payment Batch for AEB-AS2324, AEB-NSF2324 and check feed
    # 8. Run Consolidated Payment Summary Report

    Given there are no allocations marked as Under Termination for UKPRN '10018023' 
    And   there are no terminated or closed allocations for UKPRN '10018023' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018023' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018023' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018023' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-0023      |
    | NSF-0023       |
	| STFI-0023		| 
    #
    | AEBA-00231     |
    | NSF-00231      |
	| STFI-00231		| 
	


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-0023      |
    | NSF-0023       |
	| STFI-0023		| 
    #
    | AEBA-00231     |
    | NSF-00231      |
	| STFI-00231		| 
	

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-AS2122        |
    | AEB-NSF2122       |
	| STFI2122       	|
    #
    | AEB-AS2223        |
    | AEB-NSF2223       |
	| STFI2223			|
    #
    | AEB-AS2324        |
    | AEB-NSF2324       |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP21-0023     | 1                     | 0                        |
    | AEBP21-00231    | 1                     | 0                        |

#
#    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
#    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018023'
#
#    # Set the 'base' timestamp for each of the 21/22 and 22/23 AEB document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
#    And   the following document templates have Upload timestamps as indicated 
#    | DocumentTemplateName                            | UploadTimestamp         | 
#    | SOF_AEB2021_2021-08-01.docx                     | 2021-06-20 12:00:00.000 | 
#    #
#    | AEB2021_2122_TAC_2021-08-01.docx                | 2021-06-20 12:00:00.000 | 
#    | AEB2021_2122_S1_2021-08-01.docx                 | 2021-06-20 12:00:00.000 | 
#    | AEB2021_2122_S2_2021-08-01.docx                 | 2021-06-20 12:00:00.000 | 
#    | FA_AEB2021_2122_2021-08-01.docx                 | 2021-06-20 12:00:00.000 | 
#    | AEB2021_2122_S3ON_2021-08-01.docx               | 2021-06-20 12:00:00.000 | 
#    #
#    | AEB2021_2223_TAC_2022-08-01.docx                | 2022-06-20 12:00:00.000 | 
#    | AEB2021_2223_S1_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
#    | AEB2021_2223_S2_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
#    | FA_AEB2021_2223_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
#    | AEB2021_2223_S3ON_2022-08-01.docx               | 2022-06-20 12:00:00.000 | 
#


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018023' 
    And   there is no caseload advisor for UKPRN '10018023' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018023 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018023' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018023 Co Ltd' with UKPRN '10018023' and OrgId 'ORG0018023' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018023 | 118023 | 10018023 Co Ltd | 0              | Active                | Yes           | AA018023      | ?             | 345 The Meadway        | Tilehurst              | ?                      | ?                      | Reading                | Berkshire              | RG30 4NU  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018023 |





    # Part 1: Create and approve a 21/22 contract
  
    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP21-0023'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP21-0023'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018023 | 10018023 Co Ltd      | ESFA-0023            | AEBP21-0023    | 1                     | 01/08/2021        | 31/07/2022      | 179004.00     |                                       | Contract for Services                      | 2122   | New          | ORG0018023 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018023 | AEBP21-0023    | AEBA-0023     | AEB-AS            | AEB-AS2122              | AY                      | 01/08/2021          | 31/07/2022        | 43859.00        |                                         |            |                                                             | New          |             |
    | 10018023 | AEBP21-0023    | NSF-0023      | AEB-NSF           | AEB-NSF2122             | AY                      | 01/08/2021          | 31/07/2022        | 41465.00        |                                         |            |                                                             | New          |             |
    | 10018023 | AEBP21-0023    | STFI-0023     | STFI              | STFI2122                | AY                      | 01/08/2021          | 31/07/2022        | 93680.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10018023 | AEBP21-0023    | AEBA-0023      | 1               | 0                     | 43859.00  | 28552.00  | 15307.00  | 3217.00  | 3201.00  | 4229.00  | 1146.00  | 3977.00  | 6586.00  | 5178.00  | 1018.00  | 2396.00  | 4911.00  | 3785.00  | 4215.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10018023 | AEBP21-0023    | AEBA-0023      | 4               | 1                     | 19067.00  | 10517.00  | 8550.00   | 93.00    | 1081.00  | 1817.00  | 592.00   | 567.00   | 3359.00  | 2386.00  | 622.00   | 2213.00  | 3107.00  | 424.00   | 2806.00  | Adult Skills                                                    | New          |             | 
    | 10018023 | AEBP21-0023    | AEBA-0023      | 5               | 1                     | 24792.00  | 18035.00  | 6757.00   | 3124.00  | 2120.00  | 2412.00  | 554.00   | 3410.00  | 3227.00  | 2792.00  | 396.00   | 183.00   | 1804.00  | 3361.00  | 1409.00  | Adult Skills Learner Support                                    | New          |             | 
    #
    | 10018023 | AEBP21-0023    | NSF-0023       | 1               | 0                     | 41465.00  | 27612.00  | 13853.00  | 6461.00  | 3915.00  | 2413.00  | 2236.00  | 2537.00  | 6317.00  | 3361.00  | 372.00   | 955.00   | 941.00   | 5670.00  | 6287.00  | National Skills Fund Total Funding                              | New          |             | 
    | 10018023 | AEBP21-0023    | NSF-0023       | 2               | 1                     | 22473.00  | 15005.00  | 7468.00   | 3383.00  | 3106.00  | 235.00   | 463.00   | 1515.00  | 3042.00  | 3145.00  | 116.00   | 818.00   | 448.00   | 2543.00  | 3659.00  | Level 3 Offer for 24 year olds and over                         | New          |             | 
    | 10018023 | AEBP21-0023    | NSF-0023       | 5               | 1                     | 18992.00  | 12607.00  | 6385.00   | 3078.00  | 809.00   | 2178.00  | 1773.00  | 1022.00  | 3275.00  | 216.00   | 256.00   | 137.00   | 493.00   | 3127.00  | 2628.00  | National Skills Fund Learner Support                            | New          |             | 
    #
    | 10018023 | AEBP21-0023    | STFI-0023      | 1               | 0                     | 23332.00  | 12783.00  | 10549.00  | 253.00   | 2413.00  | 3337.00  | 3282.00  | 728.00   | 989.00   | 1187.00  | 594.00   | 2373.00  | 3455.00  | 2926.00  | 1795.00  | Short Term Funding Initiative 1                                 | New          |             | 
    | 10018023 | AEBP21-0023    | STFI-0023      | 2               | 0                     | 23892.00  | 17435.00  | 6457.00   | 1538.00  | 1706.00  | 3168.00  | 1498.00  | 1824.00  | 2812.00  | 3549.00  | 1340.00  | 2299.00  | 1389.00  | 416.00   | 2353.00  | Short Term Funding Initiative 2                                 | New          |             | 
    | 10018023 | AEBP21-0023    | STFI-0023      | 3               | 0                     | 22506.00  | 14371.00  | 8135.00   | 2038.00  | 1950.00  | 250.00   | 2631.00  | 171.00   | 2869.00  | 3160.00  | 1302.00  | 3175.00  | 275.00   | 3541.00  | 1144.00  | Short Term Funding Initiative 3                                 | New          |             | 
    | 10018023 | AEBP21-0023    | STFI-0023      | 4               | 0                     | 23950.00  | 15334.00  | 8616.00   | 1503.00  | 3124.00  | 979.00   | 2728.00  | 2165.00  | 1888.00  | 2719.00  | 228.00   | 1281.00  | 2807.00  | 1928.00  | 2600.00  | Short Term Funding Initiative 4                                 | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP21-0023     | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-0023'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-0023' and ContractNumber 'AEBP21-0023' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP21-0023' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018023 | AEBP21-0023         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10018023 | ESFA-0023           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract 'AEBP21-0023' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check the deliverable count in CRM includes all the monitoring deliverables
#   #And   there are '120' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
#    And   there are '120' deliverable period rows in CRM linked to the latest version of contract 'AEBP21-0023'
#
#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | AEBA-0023        | 2372010          | Jul-22 | Reconciliation |
#    | NSF-0023         | 100942           | Jul-22 | Reconciliation |
#    | STFI-0023        | 2374010          | Jul-22 | Reconciliation |
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)  
#    Then  the Legal Contract CM feed contains the following '10' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
#    | 10018023 | AEBP21-0023     | 1               | AEBA-0023      | 1               | 0                     | 43859.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
#    | 10018023 | AEBP21-0023     | 1               | AEBA-0023      | 4               | 1                     | 19067.00     | 0             | 0        | Adult Skills                                                    | ?                                                           |
#    | 10018023 | AEBP21-0023     | 1               | AEBA-0023      | 5               | 1                     | 24792.00     | 0             | 0        | Adult Skills Learner Support                                    | ?                                                           |
#    #
#    | 10018023 | AEBP21-0023     | 1               | NSF-0023       | 1               | 0                     | 41465.00     | 0             | 0        | National Skills Fund Total Funding                              | ?                                                           |
#    | 10018023 | AEBP21-0023     | 1               | NSF-0023       | 2               | 1                     | 22473.00     | 0             | 0        | Level 3 Offer for 24 year olds and over                         | ?                                                           |
#    | 10018023 | AEBP21-0023     | 1               | NSF-0023       | 5               | 1                     | 18992.00     | 0             | 0        | National Skills Fund Learner Support                            | ?                                                           |
#    #
#    | 10018023 | AEBP21-0023     | 1               | STFI-0023      | 1               | 0                     | 23332.00     | 0             | 0        | Short Term Funding Initiative 1                                 | ?                                                           |
#    | 10018023 | AEBP21-0023     | 1               | STFI-0023      | 2               | 0                     | 23892.00     | 0             | 0        | Short Term Funding Initiative 2                                 | ?                                                           |
#    | 10018023 | AEBP21-0023     | 1               | STFI-0023      | 3               | 0                     | 22506.00     | 0             | 0        | Short Term Funding Initiative 3                                 | ?                                                           |
#    | 10018023 | AEBP21-0023     | 1               | STFI-0023      | 4               | 0                     | 23950.00     | 0             | 0        | Short Term Funding Initiative 4                                 | ?                                                           |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract 'AEBP21-0023' agree with the most recent entry for this contract in the ContractManagement feed




    # Part 2: Create and approve a 22/23 contract
  
    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP21-0023'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP21-00231'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018023 | 10018023 Co Ltd      | ESFA-0023            | AEBP21-00231   | 1                     | 01/08/2022        | 31/07/2023      | 209004.00     |                                       | Contract for Services                      | 2223   | New          | ORG0018023 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018023 | AEBP21-00231    | AEBA-00231     | AEB-AS            | AEB-AS2223              | AY                      | 01/08/2022          | 31/07/2023        | 44859.00        |                                         |            |                                                             | New          |             |
    | 10018023 | AEBP21-00231    | NSF-00231      | AEB-NSF           | AEB-NSF2223             | AY                      | 01/08/2022          | 31/07/2023        | 42465.00        |                                         |            |                                                             | New          |             |
    | 10018023 | AEBP21-00231    | STFI-00231     | STFI              | STFI2223                | AY                      | 01/08/2022          | 31/07/2023        | 94680.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10018023 | AEBP21-00231    | AEBA-00231   | 1               | 0                     | 44859.00  | 29552.00  | 15307.00  | 3217.00  | 3201.00  | 5229.00  | 1146.00  | 3977.00  | 6586.00  | 5178.00  | 1018.00  | 2396.00  | 4911.00  | 3785.00  | 4215.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10018023 | AEBP21-00231    | AEBA-00231   | 4               | 1                     | 20067.00  | 11517.00  | 8550.00   | 93.00    | 1081.00  | 2817.00  | 592.00   | 567.00   | 3359.00  | 2386.00  | 622.00   | 2213.00  | 3107.00  | 424.00   | 2806.00  | Adult Skills                                                    | New          |             | 
    | 10018023 | AEBP21-00231    | AEBA-00231   | 5               | 1                     | 24792.00  | 18035.00  | 6757.00   | 3124.00  | 2120.00  | 2412.00  | 554.00   | 3410.00  | 3227.00  | 2792.00  | 396.00   | 183.00   | 1804.00  | 3361.00  | 1409.00  | Adult Skills Learner Support                                    | New          |             | 
    #
    | 10018023 | AEBP21-00231    | NSF-00231    | 1               | 0                     | 42465.00  | 28612.00  | 13853.00  | 6461.00  | 3915.00  | 2413.00  | 2236.00  | 3537.00  | 6317.00  | 3361.00  | 372.00   | 955.00   | 941.00   | 5670.00  | 6287.00  | National Skills Fund Total Funding                              | New          |             | 
    | 10018023 | AEBP21-00231    | NSF-00231    | 2               | 1                     | 22473.00  | 15005.00  | 7468.00   | 3383.00  | 3106.00  | 235.00   | 463.00   | 1515.00  | 3042.00  | 3145.00  | 116.00   | 818.00   | 448.00   | 2543.00  | 3659.00  | Level 3 Offer for 24 year olds and over                         | New          |             | 
    | 10018023 | AEBP21-00231    | NSF-00231    | 5               | 1                     | 19992.00  | 13607.00  | 6385.00   | 3078.00  | 809.00   | 2178.00  | 1773.00  | 2022.00  | 3275.00  | 216.00   | 256.00   | 137.00   | 493.00   | 3127.00  | 2628.00  | National Skills Fund Learner Support                            | New          |             | 
    #
    | 10018023 | AEBP21-00231    | STFI-00231   | 1               | 0                     | 23332.00  | 12783.00  | 10549.00  | 253.00   | 2413.00  | 3337.00  | 3282.00  | 728.00   | 989.00   | 1187.00  | 594.00   | 2373.00  | 3455.00  | 2926.00  | 1795.00  | Short Term Funding Initiative 1                                 | New          |             | 
    | 10018023 | AEBP21-00231    | STFI-00231   | 2               | 0                     | 23892.00  | 17435.00  | 6457.00   | 1538.00  | 1706.00  | 3168.00  | 1498.00  | 1824.00  | 2812.00  | 3549.00  | 1340.00  | 2299.00  | 1389.00  | 416.00   | 2353.00  | Short Term Funding Initiative 2                                 | New          |             | 
    | 10018023 | AEBP21-00231    | STFI-00231   | 3               | 0                     | 22506.00  | 14371.00  | 8135.00   | 2038.00  | 1950.00  | 250.00   | 2631.00  | 171.00   | 2869.00  | 3160.00  | 1302.00  | 3175.00  | 275.00   | 3541.00  | 1144.00  | Short Term Funding Initiative 3                                 | New          |             | 
    | 10018023 | AEBP21-00231    | STFI-00231   | 4               | 0                     | 24950.00  | 15334.00  | 9616.00   | 1503.00  | 3124.00  | 979.00   | 2728.00  | 2165.00  | 1888.00  | 2719.00  | 228.00   | 1281.00  | 2807.00  | 1928.00  | 3600.00  | Short Term Funding Initiative 4                                 | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP21-00231    | 1                     | 0                        | 2022-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-00231'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-0023' and ContractNumber 'AEBP21-00231' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP21-0023' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018023 | AEBP21-00231        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10018023 | AEBP21-0023         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10018023 | ESFA-0023           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 3: Bulk import a 23/24 contract (New Amendment)
    
    # Change the date
    Given the override date is '01/07/2023'

    # Bulk file (New Amendment)
    And   there are no files prefixed '10018023' in the Sharepoint 'AEB2021-2324-Input-Appendices' folder
    And   there are no files prefixed 'AEB2021 AY 2324 27052023112659 v3_S023' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB2021 AY 2324 27052023112659 v3_S023' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB2021 AY 2324 27052023112659 v3_S023' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB2021 AY 2324 27052023112659 v3_S023' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB2021 AY 2324 27052023112659 v3_S023.xlsx' exists in the Datafiles folder and UKPRN '10018023' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report





     # Part 3: Check docs
 
     # Change the date
     Given the override date is '02/07/2023'
 
     # Retrieve parameters
    #When  I retrieve the latest EFA contract details from CRM for provider '10018023' for FundingType 'AEB2021' and period '2324' and Delivery Organisation '00000000'
     When  I retrieve the latest contract details from CRM for provider '10018023' for FundingType 'AEB2021' and period '2324'

    # Check the contents of the Appendices
    Then  the file named '10018023_[ContractNo]_v1.pdf' in Sharepoint location 'AEB2021-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10018023 Co Ltd UKPRN: 10018023
    Master Contract Number: ESFA-0023
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) AEBA-0023 £28,552 £15,307 £43,859
    of which Learner Support £18,035 £6,757 £24,792
    ESFA AEB - National Skills Fund (procured from Aug 2021) NSF-0023 £27,612 £13,853 £41,465
    of which Level 3 Offer for 24 year olds and over £15,005 £7,468 £22,473
    of which Learner Support £12,607 £6,385 £18,992
    ESFA AEB - Short Term Funding Initiatives (procured from
    STFI-0023 £59,923 £33,757 £93,680
    Aug 2021)
    of which Short Term Funding Initiative 1 £12,783 £10,549 £23,332
    of which Short Term Funding Initiative 2 £17,435 £6,457 £23,892
    of which Short Term Funding Initiative 3 £14,371 £8,135 £22,506
    of which Short Term Funding Initiative 4 £15,334 £8,616 £23,950
    Total: £179,004
    Allocation
    1 August 2022 to 31 July 2023 Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) AEBA-00231 £29,552 £15,307 £44,859
    of which Learner Support £18,035 £6,757 £24,792
    ESFA AEB - National Skills Fund (procured from Aug 2021) NSF-00231 £28,612 £13,853 £42,465
    of which Level 3 Free Courses for Jobs £15,005 £7,468 £22,473
    of which Learner Support £13,607 £6,385 £19,992
    ESFA AEB - Short Term Funding Initiatives (procured from
    STFI-00231 £59,923 £34,757 £94,680
    Aug 2021)
    of which Short Term Funding Initiative 1 £12,783 £10,549 £23,332
    of which Short Term Funding Initiative 2 £17,435 £6,457 £23,892
    of which Short Term Funding Initiative 3 £14,371 £8,135 £22,506
    of which Short Term Funding Initiative 4 £15,334 £9,616 £24,950
    Total: £182,004
    Allocation
    1 August 2023 to 31 July 2024 Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) [AllocRef_AEBA] £71,519 £35,456 £106,975
    of which Learner Support £25,394 £21,024 £46,418
    ESFA AEB - National Skills Fund (procured from Aug 2021) [AllocRef_NSF] £54,892 £34,846 £89,738
    of which Level 3 Free Courses for Jobs £25,884 £15,183 £41,067
    of which Learner Support £29,008 £19,663 £48,671
    Total: £196,713
    Total Funding for this contract: £557,721
    Summary of Funding – Page 1
    Agreement Type Contract for Services
    Funding Period 1 August 2021 to 31 July 2024
    Between the Secretary of State for Education
    And 10018023 Co Ltd
    Funding for ESFA Adult Education Budget (Contract for Services)
    Master Contract Number ESFA-0023
    ACCEPTANCE BY THE CONTRACTOR
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10018023 Co Ltd THE SECRETARY OF STATE FOR
    345 The Meadway EDUCATION
    Tilehurst DEPARTMENT FOR EDUCATION
    Reading 20 GREAT SMITH STREET
    AND
    Berkshire LONDON
    RG30 4NU SW1P 3BT
    Company No: AA018023
    Hereinafter called Hereinafter called
    the Contractor the Department
    ESFA Adult Education Budget (Procured) Version 5 (July 2023) - Page 2
    ESFA Adult Education Budget (Procured) Version 5 (July 2023) - Page 78


    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET CONTRACT FOR SERVICES 
    SPECIFICATION
    ESFA Adult Education Budget (Procured) Schedule 1 Version 4 (July 2023) – Page 1
  
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (CONTRACT FOR SERVICES)
    ESFA Adult Education Budget (Procured) Schedule 2 Version 4 (July 2023) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 2 Version 4 (July 2023) – Page 2

    ESFA-FUNDED ADULT EDUCATION BUDGET - 2021 PROCUREMENT
    Funding Agreement – ESFA-Funded Adult Education Budget - Adult Skills (procured from Aug 2021)
    Provider: 10018023 Co Ltd UKPRN: 10018023
    Master Contract Number: ESFA-0023 Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_AEBA]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    ESFA AEB - Adult Skills £106,975 £11,441 £6,250 £6,419 £11,750 £7,439 £8,692 £8,660 £10,868 £12,195 £10,326 £7,980 £4,955
    of which Learner Support £46,418 £5,211 £678 £2,599 £4,787 £1,952 £4,617 £2,462 £3,088 £7,048 £5,232 £4,839 £3,905
    Total Funding £106,975 £11,441 £6,250 £6,419 £11,750 £7,439 £8,692 £8,660 £10,868 £12,195 £10,326 £7,980 £4,955
    
    ESFA-FUNDED ADULT EDUCATION BUDGET - 2021 PROCUREMENT
    Funding Agreement – ESFA-Funded Adult Education Budget - National Skills Fund (procured from Aug 2021)
    Provider: 10018023 Co Ltd UKPRN: 10018023
    Master Contract Number: ESFA-0023 Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_NSF]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    ESFA AEB - National Skills Fund £89,738 £7,235 £8,287 £3,021 £10,867 £9,072 £4,890 £7,374 £4,146 £3,765 £12,363 £12,533 £6,185
    of which Level 3 Free Courses for Jobs £41,067 £5,587 £5,130 £661 £4,006 £7,763 £714 £120 £1,903 £2,392 £4,653 £7,933 £205
    of which Learner Support £48,671 £1,648 £3,157 £2,360 £6,861 £1,309 £4,176 £7,254 £2,243 £1,373 £7,710 £4,600 £5,980
    Total Funding £89,738 £7,235 £8,287 £3,021 £10,867 £9,072 £4,890 £7,374 £4,146 £3,765 £12,363 £12,533 £6,185
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    ESFA Adult Education Budget (Procured) Schedule 3 Version 3 (July 2023) – Page 1

    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-07-01 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018023_[ContractNo]_v1.pdf' in 'AEB2021-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S023.pdf'





    # Part 4: Publish and approve 23/24 v1 and check feed

    # Change the date
    Given the override date is '05/07/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-0023' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018023 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    #
    | 10018023 | AEBP21-00231        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10018023 | AEBP21-0023         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10018023 | ESFA-0023           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    ## Check the deliverable count in CRM includes all the monitoring deliverables
    #And   there are '120' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_AEBA] | 2372010          | Jul-24 | Reconciliation |
    | [AllocRef_NSF]  | 100942           | Jul-24 | Reconciliation |

    ## Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    #Then  the Legal Contract CM feed contains the following '6' deliverables
    #| UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                      | DeliverableDescription   | 
    #| 10018023 | [ContractNo]   | 1               | [AllocRef_AEBA] | 1               | 0                     | 106975.00    | 0             | 0        | Adult Skills Total Funding           | ?                        |
    #| 10018023 | [ContractNo]   | 1               | [AllocRef_AEBA] | 4               | 1                     | 60557.00     | 0             | 0        | Adult Skills                         | ?                        |
    #| 10018023 | [ContractNo]   | 1               | [AllocRef_AEBA] | 5               | 1                     | 46418.00     | 0             | 0        | Adult Skills Learner Support         | ?                        |
    #| 10018023 | [ContractNo]   | 1               | [AllocRef_NSF]  | 1               | 0                     | 89738.00     | 0             | 0        | National Skills Fund Total Funding   | ?                        |
    #| 10018023 | [ContractNo]   | 1               | [AllocRef_NSF]  | 2               | 1                     | 41067.00     | 0             | 0        | Level 3 Free Courses for Jobs        | ?                        |
    #| 10018023 | [ContractNo]   | 1               | [AllocRef_NSF]  | 5               | 1                     | 48671.00     | 0             | 0        | National Skills Fund Learner Support | ?                        |

    ## Test CRM details against same in ContractManagement feed (30447)
    #Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed





    # Part 5: Add Actuals for 23/24 then check CRM

    # Add actuals to the contract for AEB-AS2223, AEB-NSF2223 

    # Change the date
    Given the override date is '04/10/2023'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018023'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2022
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202308 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 2               | 0            | 656.38      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202308 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 3               | 0            | 514.81      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202308 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 6               | 0            | 564.11      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202308 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 7               | 0            | 1411.24     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202308 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 8               | 0            | 478.56      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202308 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 9               | 0            | 1469.21     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202308 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 10              | 0            | 1163.17     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202309 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 2               | 0            | 2352.37     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202309 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 3               | 0            | 465.26      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202309 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 6               | 0            | 2003.87     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202309 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 7               | 0            | 699.93      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202309 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 8               | 0            | 844.84      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202309 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 9               | 0            | 1604.57     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202309 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 10              | 0            | 860.77      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202310 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 2               | 0            | 2029.73     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202310 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 3               | 0            | 1578.92     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202310 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 6               | 0            | 456.94      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202310 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 7               | 0            | 1664.81     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202310 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 8               | 0            | 1759.15     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202310 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 9               | 0            | 691.06      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202310 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 10              | 0            | 2444.27     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202311 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 2               | 0            | 2456.58     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202311 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 3               | 0            | 647.63      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202311 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 6               | 0            | 759.23      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202311 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 7               | 0            | 2063.91     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202311 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 8               | 0            | 450.22      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202311 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 9               | 0            | 1934.00     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202311 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 10              | 0            | 1123.20     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202312 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 2               | 0            | 1427.78     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202312 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 3               | 0            | 1516.24     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202312 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 6               | 0            | 1788.03     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202312 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 7               | 0            | 1329.88     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202312 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 8               | 0            | 2026.43     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202312 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 9               | 0            | 789.27      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202312 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 10              | 0            | 1287.03     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202401 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 2               | 0            | 903.61      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202401 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 3               | 0            | 1218.05     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202401 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 6               | 0            | 1600.94     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202401 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 7               | 0            | 2117.38     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202401 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 8               | 0            | 1741.50     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202401 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 9               | 0            | 1842.61     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202401 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 10              | 0            | 1337.66     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202402 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 2               | 0            | 701.10      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202402 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 3               | 0            | 533.70      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202402 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 6               | 0            | 1360.83     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202402 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 7               | 0            | 923.42      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202402 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 8               | 0            | 1747.44     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202402 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 9               | 0            | 608.77      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202402 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 10              | 0            | 418.35      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202403 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 2               | 0            | 2227.66     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202403 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 3               | 0            | 829.39      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202403 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 6               | 0            | 1203.95     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202403 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 7               | 0            | 1434.69     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202403 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 8               | 0            | 1798.00     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202403 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 9               | 0            | 1085.30     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202403 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 10              | 0            | 1960.48     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202404 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 2               | 0            | 1417.38     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202404 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 3               | 0            | 1918.11     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202404 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 6               | 0            | 1045.39     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202404 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 7               | 0            | 1643.91     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202404 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 8               | 0            | 2101.00     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202404 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 9               | 0            | 1190.52     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202404 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 10              | 0            | 1883.35     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202405 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 2               | 0            | 1589.44     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202405 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 3               | 0            | 1711.23     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202405 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 6               | 0            | 2444.42     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202405 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 7               | 0            | 492.88      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202405 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 8               | 0            | 1272.18     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202405 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 9               | 0            | 1953.95     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202405 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 10              | 0            | 2268.45     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202406 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 2               | 0            | 1989.29     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202406 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 3               | 0            | 702.52      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202406 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 6               | 0            | 829.25      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202406 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 7               | 0            | 2068.54     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202406 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 8               | 0            | 1235.99     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202406 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 9               | 0            | 1246.41     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202406 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 10              | 0            | 670.54      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202407 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 2               | 0            | 750.74      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202407 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 3               | 0            | 596.14      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202407 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 6               | 0            | 670.68      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202407 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 7               | 0            | 2008.59     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202407 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 8               | 0            | 529.00      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202407 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 9               | 0            | 909.14      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202407 | AEB-AS2324              | [AllocRef_AEBA]          | ?          | 10              | 0            | 1313.35     |
    #
    | ILR2324        | R02                  | ORG0018023     | CM             | 202308 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 3               | 0            | 1951.00     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202308 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 4               | 0            | 627.27      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202308 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 6               | 0            | 1274.11     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202308 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 7               | 0            | 1790.98     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202308 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 8               | 0            | 615.15      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202308 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 9               | 0            | 1977.70     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202308 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 10              | 0            | 1956.70     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202309 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 3               | 0            | 804.17      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202309 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 4               | 0            | 855.21      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202309 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 6               | 0            | 631.06      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202309 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 7               | 0            | 938.44      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202309 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 8               | 0            | 995.84      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202309 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 9               | 0            | 1931.92     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202309 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 10              | 0            | 2158.27     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202310 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 3               | 0            | 1047.32     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202310 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 4               | 0            | 1860.24     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202310 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 6               | 0            | 1778.15     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202310 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 7               | 0            | 1313.84     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202310 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 8               | 0            | 560.35      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202310 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 9               | 0            | 1744.40     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202310 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 10              | 0            | 1768.41     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202311 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 3               | 0            | 1027.36     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202311 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 4               | 0            | 979.42      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202311 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 6               | 0            | 420.79      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202311 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 7               | 0            | 850.88      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202311 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 8               | 0            | 407.36      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202311 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 9               | 0            | 469.54      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202311 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 10              | 0            | 2122.51     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202312 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 3               | 0            | 1242.00     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202312 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 4               | 0            | 1707.76     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202312 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 6               | 0            | 709.66      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202312 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 7               | 0            | 540.85      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202312 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 8               | 0            | 1633.41     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202312 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 9               | 0            | 1106.69     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202312 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 10              | 0            | 1255.89     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202401 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 3               | 0            | 1285.57     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202401 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 4               | 0            | 1961.54     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202401 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 6               | 0            | 2148.01     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202401 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 7               | 0            | 1767.36     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202401 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 8               | 0            | 407.44      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202401 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 9               | 0            | 1239.62     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202401 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 10              | 0            | 1895.13     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202402 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 3               | 0            | 994.41      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202402 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 4               | 0            | 2233.51     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202402 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 6               | 0            | 1402.23     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202402 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 7               | 0            | 1597.45     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202402 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 8               | 0            | 1779.48     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202402 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 9               | 0            | 664.64      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202402 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 10              | 0            | 512.30      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202403 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 3               | 0            | 1169.29     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202403 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 4               | 0            | 1720.29     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202403 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 6               | 0            | 1635.78     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202403 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 7               | 0            | 1230.69     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202403 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 8               | 0            | 1531.22     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202403 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 9               | 0            | 945.68      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202403 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 10              | 0            | 1638.53     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202404 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 3               | 0            | 1248.17     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202404 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 4               | 0            | 1864.06     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202404 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 6               | 0            | 1103.86     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202404 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 7               | 0            | 1856.37     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202404 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 8               | 0            | 829.96      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202404 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 9               | 0            | 1025.21     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202404 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 10              | 0            | 1113.23     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202405 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 3               | 0            | 562.25      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202405 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 4               | 0            | 1572.82     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202405 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 6               | 0            | 1277.62     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202405 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 7               | 0            | 775.62      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202405 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 8               | 0            | 778.81      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202405 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 9               | 0            | 1924.50     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202405 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 10              | 0            | 1381.12     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202406 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 3               | 0            | 1152.10     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202406 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 4               | 0            | 1750.97     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202406 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 6               | 0            | 565.78      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202406 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 7               | 0            | 1246.40     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202406 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 8               | 0            | 1701.23     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202406 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 9               | 0            | 1981.15     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202406 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 10              | 0            | 2105.12     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202407 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 3               | 0            | 1501.39     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202407 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 4               | 0            | 1579.87     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202407 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 6               | 0            | 876.86      |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202407 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 7               | 0            | 1035.48     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202407 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 8               | 0            | 1670.15     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202407 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 9               | 0            | 1406.46     |
    | ILR2324        | R02                  | ORG0018023     | CM             | 202407 | AEB-NSF2324             | [AllocRef_NSF]           | ?          | 10              | 0            | 860.95      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_NSF]     | 1               | 89738.00  | 7235.00  | 8287.00  | 3021.00  | 10867.00 | 9072.00  | 4890.00  | 7374.00  | 4146.00  | 3765.00  | 12363.00 | 12533.00 | 6185.00  | 
    | [ContractNo]   | [AllocRef_NSF]     | 2               | 41067.00  | 5587.00  | 5130.00  | 661.00   | 4006.00  | 7763.00  | 714.00   | 120.00   | 1903.00  | 2392.00  | 4653.00  | 7933.00  | 205.00   | 
    | [ContractNo]   | [AllocRef_NSF]     | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 5               | 48671.00  | 1648.00  | 3157.00  | 2360.00  | 6861.00  | 1309.00  | 4176.00  | 7254.00  | 2243.00  | 1373.00  | 7710.00  | 4600.00  | 5980.00  | 
    | [ContractNo]   | [AllocRef_NSF]     | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_AEBA]    | 1               | 106975.00 | 11441.00 | 6250.00  | 6419.00  | 11750.00 | 7439.00  | 8692.00  | 8660.00  | 10868.00 | 12195.00 | 10326.00 | 7980.00  | 4955.00  | 
    | [ContractNo]   | [AllocRef_AEBA]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 4               | 60557.00  | 6230.00  | 5572.00  | 3820.00  | 6963.00  | 5487.00  | 4075.00  | 6198.00  | 7780.00  | 5147.00  | 5094.00  | 3141.00  | 1050.00  | 
    | [ContractNo]   | [AllocRef_AEBA]    | 5               | 46418.00  | 5211.00  | 678.00   | 2599.00  | 4787.00  | 1952.00  | 4617.00  | 2462.00  | 3088.00  | 7048.00  | 5232.00  | 4839.00  | 3905.00  | 
    | [ContractNo]   | [AllocRef_AEBA]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_NSF]     | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 3               | 2755.17   | 1951.00  | 804.17   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 4               | 1482.48   | 627.27   | 855.21   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 6               | 1905.17   | 1274.11  | 631.06   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 7               | 2729.42   | 1790.98  | 938.44   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 8               | 1610.99   | 615.15   | 995.84   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 9               | 3909.62   | 1977.70  | 1931.92  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 10              | 4114.97   | 1956.70  | 2158.27  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | [ContractNo]   | [AllocRef_AEBA]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 2               | 3008.75   | 656.38   | 2352.37  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 3               | 980.07    | 514.81   | 465.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 6               | 2567.98   | 564.11   | 2003.87  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 7               | 2111.17   | 1411.24  | 699.93   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 8               | 1323.40   | 478.56   | 844.84   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 9               | 3073.78   | 1469.21  | 1604.57  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 10              | 2023.94   | 1163.17  | 860.77   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

#    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
#    And   the Reconciliation Data is calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
#    | [ContractNo]   | [AllocRef_NSF]     | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NSF]     | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NSF]     | 3               | 2755.17   | 0.00     | 2755.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NSF]     | 4               | 1482.48   | 0.00     | 1482.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NSF]     | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NSF]     | 6               | 1905.17   | 0.00     | 1905.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NSF]     | 7               | 2729.42   | 0.00     | 2729.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NSF]     | 8               | 1610.99   | 0.00     | 1610.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NSF]     | 9               | 3909.62   | 0.00     | 3909.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NSF]     | 10              | 4114.97   | 0.00     | 4114.97  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    #
#    | [ContractNo]   | [AllocRef_AEBA]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_AEBA]    | 2               | 3008.75   | 0.00     | 3008.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_AEBA]    | 3               | 980.07    | 0.00     | 980.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_AEBA]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_AEBA]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_AEBA]    | 6               | 2567.98   | 0.00     | 2567.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_AEBA]    | 7               | 2111.17   | 0.00     | 2111.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_AEBA]    | 8               | 1323.40   | 0.00     | 1323.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_AEBA]    | 9               | 3073.78   | 0.00     | 3073.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_AEBA]    | 10              | 2023.94   | 0.00     | 2023.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
#



#    # Part 6: Create and check the contents of the CDA report
#   
#    # Change the date
#    Given the override date is '05/10/2023'
#    
#    # Check the contents of the CDA report
#    And   there is no CDA report named 'CDA Last Approved Version S023.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 1                     |
#
#   #When  the following CDA reports are run
#    When  the following CDA report is run
#    | FundingStreamPeriod             | Version               | Suffix |
#    | AEB-AS2223,AEB-NSF2223          | Last Approved         | S023   |
#
#    Then  a report named 'CDA Last Approved Version S023.csv' is created

    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | AEB-AS2223              | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 19+ Hardship                            | Adult Skills 19+ Hardship                                       | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 564.11       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100927                   | 2372016           | Aug              |
#    | AEB-AS2223              | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 19+ Hardship                            | Adult Skills 19+ Hardship                                       | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 2003.87      | 0             |              | Yes                | 0.00           | 0.00             | 2567.98               | 0.00           | 2567.98         |             | No            |                   |        |                   | 100927                   | 2372016           | Sep              |
#    | AEB-AS2223              | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 20+ Childcare                           | Adult Skills 20+ Childcare                                      | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 1411.24      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100928                   | 2372016           | Aug              |
#    | AEB-AS2223              | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 20+ Childcare                           | Adult Skills 20+ Childcare                                      | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 699.93       | 0             |              | Yes                | 0.00           | 0.00             | 2111.17               | 0.00           | 2111.17         |             | No            |                   |        |                   | 100928                   | 2372016           | Sep              |
#    | AEB-AS2223              | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Administration Expenditure              | Adult Skills Administration Expenditure                         | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 1469.21      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100930                   | 2372016           | Aug              |
#    | AEB-AS2223              | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Administration Expenditure              | Adult Skills Administration Expenditure                         | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 1604.57      | 0             |              | Yes                | 0.00           | 0.00             | 3073.78               | 0.00           | 3073.78         |             | No            |                   |        |                   | 100930                   | 2372016           | Sep              |
#    | AEB-AS2223              | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills COVID-19 Response (ICT)                 | Adult Skills COVID-19 Response (ICT)                            | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 1163.17      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100931                   | 2372016           | Aug              |
#    | AEB-AS2223              | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills COVID-19 Response (ICT)                 | Adult Skills COVID-19 Response (ICT)                            | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 860.77       | 0             |              | Yes                | 0.00           | 0.00             | 2023.94               | 0.00           | 2023.94         |             | No            |                   |        |                   | 100931                   | 2372016           | Sep              |
#    | AEB-AS2223              | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Learning Support                        | Adult Skills Learning Support                                   | Adult Skills                                                    | 8                 | 2022            | 2022/23       |              | 0            | 514.81       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2372060                  | 2372016           | Aug              |
#    | AEB-AS2223              | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Learning Support                        | Adult Skills Learning Support                                   | Adult Skills                                                    | 9                 | 2022            | 2022/23       |              | 0            | 465.26       | 0             |              | Yes                | 0.00           | 0.00             | 980.07                | 0.00           | 980.07          |             | No            |                   |        |                   | 2372060                  | 2372016           | Sep              |
#    | AEB-AS2223              | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Programme Funding                       | Adult Skills Programme Funding                                  | Adult Skills                                                    | 8                 | 2022            | 2022/23       |              | 0            | 656.38       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2372010                  | 2372016           | Aug              |
#    | AEB-AS2223              | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Programme Funding                       | Adult Skills Programme Funding                                  | Adult Skills                                                    | 9                 | 2022            | 2022/23       |              | 0            | 2352.37      | 0             |              | Yes                | 0.00           | 0.00             | 3008.75               | 0.00           | 3008.75         |             | No            |                   |        |                   | 2372010                  | 2372016           | Sep              |
#    | AEB-AS2223              | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Residential Access Fund                 | Adult Skills Residential Access Fund                            | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 478.56       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100929                   | 2372016           | Aug              |
#    | AEB-AS2223              | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Residential Access Fund                 | Adult Skills Residential Access Fund                            | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 844.84       | 0             |              | Yes                | 0.00           | 0.00             | 1323.40               | 0.00           | 1323.40         |             | No            |                   |        |                   | 100929                   | 2372016           | Sep              |
#    #
#    | AEB-NSF2223             | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund 19+ Hardship                    | National Skills Fund 19+ Hardship                               | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 1274.11      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100937                   | 100944            | Aug              |
#    | AEB-NSF2223             | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund 19+ Hardship                    | National Skills Fund 19+ Hardship                               | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 631.06       | 0             |              | Yes                | 0.00           | 0.00             | 1905.17               | 0.00           | 1905.17         |             | No            |                   |        |                   | 100937                   | 100944            | Sep              |
#    | AEB-NSF2223             | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund 20+ Childcare                   | National Skills Fund 20+ Childcare                              | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 1790.98      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100938                   | 100944            | Aug              |
#    | AEB-NSF2223             | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund 20+ Childcare                   | National Skills Fund 20+ Childcare                              | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 938.44       | 0             |              | Yes                | 0.00           | 0.00             | 2729.42               | 0.00           | 2729.42         |             | No            |                   |        |                   | 100938                   | 100944            | Sep              |
#    | AEB-NSF2223             | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Administration Expenditure      | National Skills Fund Administration Expenditure                 | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 1977.7       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100940                   | 100944            | Aug              |
#    | AEB-NSF2223             | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Administration Expenditure      | National Skills Fund Administration Expenditure                 | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 1931.92      | 0             |              | Yes                | 0.00           | 0.00             | 3909.62               | 0.00           | 3909.62         |             | No            |                   |        |                   | 100940                   | 100944            | Sep              |
#    | AEB-NSF2223             | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund COVID-19 Response (ICT)         | National Skills Fund COVID-19 Response (ICT)                    | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 1956.7       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100941                   | 100944            | Aug              |
#    | AEB-NSF2223             | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund COVID-19 Response (ICT)         | National Skills Fund COVID-19 Response (ICT)                    | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 2158.27      | 0             |              | Yes                | 0.00           | 0.00             | 4114.97               | 0.00           | 4114.97         |             | No            |                   |        |                   | 100941                   | 100944            | Sep              |
#    | AEB-NSF2223             | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Learning Support                | National Skills Fund Learning Support                           | National Skills Fund Total Funding                              | 8                 | 2022            | 2022/23       |              | 0            | 627.27       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100943                   | 100944            | Aug              |
#    | AEB-NSF2223             | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Learning Support                | National Skills Fund Learning Support                           | National Skills Fund Total Funding                              | 9                 | 2022            | 2022/23       |              | 0            | 855.21       | 0             |              | Yes                | 0.00           | 0.00             | 1482.48               | 0.00           | 1482.48         |             | No            |                   |        |                   | 100943                   | 100944            | Sep              |
#    | AEB-NSF2223             | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Programme Funding               | National Skills Fund Programme Funding                          | National Skills Fund Total Funding                              | 8                 | 2022            | 2022/23       |              | 0            | 1951         | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100942                   | 100944            | Aug              |
#    | AEB-NSF2223             | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Programme Funding               | National Skills Fund Programme Funding                          | National Skills Fund Total Funding                              | 9                 | 2022            | 2022/23       |              | 0            | 804.17       | 0             |              | Yes                | 0.00           | 0.00             | 2755.17               | 0.00           | 2755.17         |             | No            |                   |        |                   | 100942                   | 100944            | Sep              |
#    | AEB-NSF2223             | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Residential Access Fund         | National Skills Fund Residential Access Fund                    | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 615.15       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100939                   | 100944            | Aug              |
#    | AEB-NSF2223             | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Residential Access Fund         | National Skills Fund Residential Access Fund                    | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 995.84       | 0             |              | Yes                | 0.00           | 0.00             | 1610.99               | 0.00           | 1610.99         |             | No            |                   |        |                   | 100939                   | 100944            | Sep              |
#    #
#    | STFI2223                | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Learning Support     | Short Term Funding Initiative 1 Learning Support                | Short Term Funding Initiative 1                                 | 8                 | 2022            | 2022/23       |              | 0            | 1921.44      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374010                  | 2374010           | Aug              |
#    | STFI2223                | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Learning Support     | Short Term Funding Initiative 1 Learning Support                | Short Term Funding Initiative 1                                 | 9                 | 2022            | 2022/23       |              | 0            | 3053.34      | 0             |              | Yes                | 0.00           | 0.00             | 4974.78               | 0.00           | 4974.78         |             | No            |                   |        |                   | 2374010                  | 2374010           | Sep              |
#    | STFI2223                | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Programme Funding    | Short Term Funding Initiative 1 Programme Funding               | Short Term Funding Initiative 1                                 | 8                 | 2022            | 2022/23       |              | 0            | 3062.68      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374010                  | 2374010           | Aug              |
#    | STFI2223                | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Programme Funding    | Short Term Funding Initiative 1 Programme Funding               | Short Term Funding Initiative 1                                 | 9                 | 2022            | 2022/23       |              | 0            | 2288.45      | 0             |              | Yes                | 0.00           | 0.00             | 5351.13               | 0.00           | 5351.13         |             | No            |                   |        |                   | 2374010                  | 2374010           | Sep              |
#    | STFI2223                | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Learning Support     | Short Term Funding Initiative 2 Learning Support                | Short Term Funding Initiative 2                                 | 8                 | 2022            | 2022/23       |              | 0            | 1974.73      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374020                  | 2374020           | Aug              |
#    | STFI2223                | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Learning Support     | Short Term Funding Initiative 2 Learning Support                | Short Term Funding Initiative 2                                 | 9                 | 2022            | 2022/23       |              | 0            | 2277.92      | 0             |              | Yes                | 0.00           | 0.00             | 4252.65               | 0.00           | 4252.65         |             | No            |                   |        |                   | 2374020                  | 2374020           | Sep              |
#    | STFI2223                | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Programme Funding    | Short Term Funding Initiative 2 Programme Funding               | Short Term Funding Initiative 2                                 | 8                 | 2022            | 2022/23       |              | 0            | 3923.76      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374020                  | 2374020           | Aug              |
#    | STFI2223                | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Programme Funding    | Short Term Funding Initiative 2 Programme Funding               | Short Term Funding Initiative 2                                 | 9                 | 2022            | 2022/23       |              | 0            | 2450.38      | 0             |              | Yes                | 0.00           | 0.00             | 6374.14               | 0.00           | 6374.14         |             | No            |                   |        |                   | 2374020                  | 2374020           | Sep              |
#    | STFI2223                | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Learning Support     | Short Term Funding Initiative 3 Learning Support                | Short Term Funding Initiative 3                                 | 8                 | 2022            | 2022/23       |              | 0            | 3299.57      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374030                  | 2374030           | Aug              |
#    | STFI2223                | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Learning Support     | Short Term Funding Initiative 3 Learning Support                | Short Term Funding Initiative 3                                 | 9                 | 2022            | 2022/23       |              | 0            | 2873.23      | 0             |              | Yes                | 0.00           | 0.00             | 6172.80               | 0.00           | 6172.80         |             | No            |                   |        |                   | 2374030                  | 2374030           | Sep              |
#    | STFI2223                | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Programme Funding    | Short Term Funding Initiative 3 Programme Funding               | Short Term Funding Initiative 3                                 | 8                 | 2022            | 2022/23       |              | 0            | 2866.75      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374030                  | 2374030           | Aug              |
#    | STFI2223                | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Programme Funding    | Short Term Funding Initiative 3 Programme Funding               | Short Term Funding Initiative 3                                 | 9                 | 2022            | 2022/23       |              | 0            | 2758.03      | 0             |              | Yes                | 0.00           | 0.00             | 5624.78               | 0.00           | 5624.78         |             | No            |                   |        |                   | 2374030                  | 2374030           | Sep              |
#    | STFI2223                | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Learning Support     | Short Term Funding Initiative 4 Learning Support                | Short Term Funding Initiative 4                                 | 8                 | 2022            | 2022/23       |              | 0            | 4679.3       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374040                  | 2374040           | Aug              |
#    | STFI2223                | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Learning Support     | Short Term Funding Initiative 4 Learning Support                | Short Term Funding Initiative 4                                 | 9                 | 2022            | 2022/23       |              | 0            | 2147.47      | 0             |              | Yes                | 0.00           | 0.00             | 6826.77               | 0.00           | 6826.77         |             | No            |                   |        |                   | 2374040                  | 2374040           | Sep              |
#    | STFI2223                | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Programme Funding    | Short Term Funding Initiative 4 Programme Funding               | Short Term Funding Initiative 4                                 | 8                 | 2022            | 2022/23       |              | 0            | 1543.3       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374040                  | 2374040           | Aug              |
#    | STFI2223                | 10018023 | 10018023 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-0023                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Programme Funding    | Short Term Funding Initiative 4 Programme Funding               | Short Term Funding Initiative 4                                 | 9                 | 2022            | 2022/23       |              | 0            | 3429.78      | 0             |              | Yes                | 0.00           | 0.00             | 4973.08               | 0.00           | 4973.08         |             | No            |                   |        |                   | 2374040                  | 2374040           | Sep              |
#




    # Part 7a: Payment Batch for AEB-AS2324

    # Change the date
    Given the override date is '09/10/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-AS2324' AccountingPaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_AEBA]          | 202309 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB-AS2324                 | 202309               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEB-AS2324                 | 202309               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-AS2324' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S023_AS.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-AS2324' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AEBA                   | 2023          | 06             | 10          | ?       | [AllocRef_AEBA]  | 3008.75         | RECONCILIATION   | AEB Other Learning                 | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018023 | 2372010    |
    | AEBA                   | 2023          | 06             | 10          | ?       | [AllocRef_AEBA]  | 980.07          | RECONCILIATION   | AEB OthLearning LngS               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018023 | 2372060    |
    | AEBA                   | 2023          | 06             | 10          | ?       | [AllocRef_AEBA]  | 2567.98         | RECONCILIATION   | AdltSkll19+Hardship                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018023 | 100927     |
    | AEBA                   | 2023          | 06             | 10          | ?       | [AllocRef_AEBA]  | 2111.17         | RECONCILIATION   | AdltSkll20+Childcare               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018023 | 100928     |
    | AEBA                   | 2023          | 06             | 10          | ?       | [AllocRef_AEBA]  | 1323.40         | RECONCILIATION   | AdltSkllRsdntlAccess               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018023 | 100929     |
    | AEBA                   | 2023          | 06             | 10          | ?       | [AllocRef_AEBA]  | 3073.78         | RECONCILIATION   | AdltSkllAdminExp                   | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018023 | 100930     |
    | AEBA                   | 2023          | 06             | 10          | ?       | [AllocRef_AEBA]  | 2023.94         | RECONCILIATION   | AdltSkllC19Response                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018023 | 100931     |
    #                                                                                                    £15089.09




    # Part 7b: Payment Batch for AEB-NSF2223

    # Change the date
    Given the override date is '09/10/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-NSF2324' AccountingPaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_NSF]           | 202309 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB-NSF2324                | 202309               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEB-NSF2324                | 202309               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-NSF2324' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S023_NSF.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-NSF2324' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | NSF                    | 2023          | 06             | 10          | ?       | [AllocRef_NSF]   | 2755.17         | RECONCILIATION   | NSF Programme                      | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018023 | 100942     |
    | NSF                    | 2023          | 06             | 10          | ?       | [AllocRef_NSF]   | 1482.48         | RECONCILIATION   | NSF Learning Support               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018023 | 100943     |
    | NSF                    | 2023          | 06             | 10          | ?       | [AllocRef_NSF]   | 1905.17         | RECONCILIATION   | NSF 19+ Hardship                   | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018023 | 100937     |
    | NSF                    | 2023          | 06             | 10          | ?       | [AllocRef_NSF]   | 2729.42         | RECONCILIATION   | NSF 20+ Childcare                  | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018023 | 100938     |
    | NSF                    | 2023          | 06             | 10          | ?       | [AllocRef_NSF]   | 1610.99         | RECONCILIATION   | NSF RsdntlAccessFund               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018023 | 100939     |
    | NSF                    | 2023          | 06             | 10          | ?       | [AllocRef_NSF]   | 3909.62         | RECONCILIATION   | NSF Admin Exp                      | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018023 | 100940     |
    | NSF                    | 2023          | 06             | 10          | ?       | [AllocRef_NSF]   | 4114.97         | RECONCILIATION   | NSF COVID19 Response               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018023 | 100941     |
    #                                                                                                    £18507.82




    # Consolidated Payment Summary Report

    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    When a Consolidated Payment Summary Report is created in Sharepoint for '12/10/2023'
    # Check the above report manually

    
    # Tidy Up
   Given the override date is reset