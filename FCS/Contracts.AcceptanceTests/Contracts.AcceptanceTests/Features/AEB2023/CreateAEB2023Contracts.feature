Feature: CreateAEB2023Contracts 38490

@AcceptanceTest @Withdrawn_11062024
@Long2Run @Long2Run123
Scenario: S024 Create and approve 23/24 AEB2023 contract. Publish and approve. Add actuals for 23/24. Payment Batch. Check docs, CRM and feed

    # 1. Create and approve a 23/24 contract
    # 5. Add Actuals for 23/24 then check CRM
    # 6. Create and check the contents of the CDA report
    # 7. Payment Batch for AEB2023-AS2324, AEB2023-NSF2324, AEB23-AEB2023-STFI2324 and check feed
    # 8. Run Consolidated Payment Summary Report

    Given there are no allocations marked as Under Termination for UKPRN '10018024' 
    And   there are no terminated or closed allocations for UKPRN '10018024' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018024' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018024' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018024' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA23-0024   |
    | NSF23-0024    |
	| STFI23-0024	| 
	


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA23-0024   |
    | NSF23-0024    |
	| STFI23-0024	| 
	

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB2023-AS2324      |
    | AEB2023-NSF2324     |
	| AEB2023-STFI2324    |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP23-0024    | 1                     | 0                        |


    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018024'

    # Set the 'base' timestamp for each of the 21/22 and 22/23 AEB document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_AEB2023_2023-08-01.docx                     | 2023-06-20 12:00:00.000 | 
    #
    | AEB2023_2324_TAC_2023-08-01.docx                | 2023-06-20 12:00:00.000 | 
    | AEB2023_2324_S1_2023-08-01.docx                 | 2023-06-20 12:00:00.000 | 
    | AEB2023_2324_S2_2023-08-01.docx                 | 2023-06-20 12:00:00.000 | 
    | FA_AEB2023_2324_2023-08-01.docx                 | 2023-06-20 12:00:00.000 | 
    | AEB2023_2324_S3ON_2023-08-01.docx               | 2023-06-20 12:00:00.000 | 








    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018024' 
    And   there is no caseload advisor for UKPRN '10018024' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018024 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018024' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018024 Co Ltd' with UKPRN '10018024' and OrgId 'ORG0018024' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018024 | 118024 | 10018024 Co Ltd | 0              | Active                | Yes           | AA018024      | ?             | 345 The Meadway        | Tilehurst              | ?                      | ?                      | Reading                | Berkshire              | RG30 4NU  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018024 |





    # Part 1: Create and approve a 23/24 contract
  
    # Change the date
    Given the override date is '01/07/2023'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP23-0024'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP23-0024'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018024 | 10018024 Co Ltd      | ESFA-0024            | AEBP23-0024    | 1                     | 01/08/2023        | 31/07/2024      | 179004.00     |                                       | Contract for Services                      | 2324   | New          | ORG0018024 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018024 | AEBP23-0024    | AEBA23-0024     | AEB23-AS            | AEB2023-AS2324              | AY                      | 01/08/2023          | 31/07/2024        | 43859.00        |                                         |            |                                                             | New          |             |
    | 10018024 | AEBP23-0024    | NSF23-0024      | AEB23-NSF           | AEB2023-NSF2324             | AY                      | 01/08/2023          | 31/07/2024        | 41465.00        |                                         |            |                                                             | New          |             |
    | 10018024 | AEBP23-0024    | STFI23-0024     | AEB23-STFI          | AEB2023-STFI2324            | AY                      | 01/08/2023          | 31/07/2024        | 93680.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10018024 | AEBP23-0024    | AEBA23-0024      | 1               | 0                     | 43859.00  | 28552.00  | 15307.00  | 3217.00  | 3201.00  | 4229.00  | 1146.00  | 3977.00  | 6586.00  | 5178.00  | 1018.00  | 2396.00  | 4911.00  | 3785.00  | 4215.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10018024 | AEBP23-0024    | AEBA23-0024      | 4               | 1                     | 19067.00  | 10517.00  | 8550.00   | 93.00    | 1081.00  | 1817.00  | 592.00   | 567.00   | 3359.00  | 2386.00  | 622.00   | 2213.00  | 3107.00  | 424.00   | 2806.00  | Adult Skills                                                    | New          |             | 
    | 10018024 | AEBP23-0024    | AEBA23-0024      | 5               | 1                     | 24792.00  | 18035.00  | 6757.00   | 3124.00  | 2120.00  | 2412.00  | 554.00   | 3410.00  | 3227.00  | 2792.00  | 396.00   | 183.00   | 1804.00  | 3361.00  | 1409.00  | Adult Skills Learner Support                                    | New          |             | 
    #
    | 10018024 | AEBP23-0024    | NSF23-0024       | 1               | 0                     | 41465.00  | 27612.00  | 13853.00  | 6461.00  | 3915.00  | 2413.00  | 2236.00  | 2537.00  | 6317.00  | 3361.00  | 372.00   | 955.00   | 941.00   | 5670.00  | 6287.00  | National Skills Fund Total Funding                              | New          |             | 
    | 10018024 | AEBP23-0024    | NSF23-0024       | 2               | 1                     | 22473.00  | 15005.00  | 7468.00   | 3383.00  | 3106.00  | 235.00   | 463.00   | 1515.00  | 3042.00  | 3145.00  | 116.00   | 818.00   | 448.00   | 2543.00  | 3659.00  | Level 3 Offer for 24 year olds and over                         | New          |             | 
    | 10018024 | AEBP23-0024    | NSF23-0024       | 5               | 1                     | 18992.00  | 12607.00  | 6385.00   | 3078.00  | 809.00   | 2178.00  | 1773.00  | 1022.00  | 3275.00  | 216.00   | 256.00   | 137.00   | 493.00   | 3127.00  | 2628.00  | National Skills Fund Learner Support                            | New          |             | 
    #
    | 10018024 | AEBP23-0024    | STFI23-0024      | 1               | 0                     | 23332.00  | 12783.00  | 10549.00  | 253.00   | 2413.00  | 3337.00  | 3282.00  | 728.00   | 989.00   | 1187.00  | 594.00   | 2373.00  | 3455.00  | 2926.00  | 1795.00  | Short Term Funding Initiative 1                                 | New          |             | 
    | 10018024 | AEBP23-0024    | STFI23-0024      | 2               | 0                     | 23892.00  | 17435.00  | 6457.00   | 1538.00  | 1706.00  | 3168.00  | 1498.00  | 1824.00  | 2812.00  | 3549.00  | 1340.00  | 2299.00  | 1389.00  | 416.00   | 2353.00  | Short Term Funding Initiative 2                                 | New          |             | 
    | 10018024 | AEBP23-0024    | STFI23-0024      | 3               | 0                     | 22506.00  | 14371.00  | 8135.00   | 2038.00  | 1950.00  | 250.00   | 2631.00  | 171.00   | 2869.00  | 3160.00  | 1302.00  | 3175.00  | 275.00   | 3541.00  | 1144.00  | Short Term Funding Initiative 3                                 | New          |             | 
    | 10018024 | AEBP23-0024    | STFI23-0024      | 4               | 0                     | 23950.00  | 15334.00  | 8616.00   | 1503.00  | 3124.00  | 979.00   | 2728.00  | 2165.00  | 1888.00  | 2719.00  | 228.00   | 1281.00  | 2807.00  | 1928.00  | 2600.00  | Short Term Funding Initiative 4                                 | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP23-0024    | 1                     | 0                        | 2023-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP23-0024'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber 'AEBP23-0024' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-0024' and ContractNumber 'AEBP23-0024' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP23-0024' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018024 | AEBP23-0024        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018024 | ESFA-0024          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract 'AEBP23-0024' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check the deliverable count in CRM includes all the monitoring deliverables
#   #And   there are '120' deliverable period rows in CRM linked to the latest version of contract number 'AEBP23-0024'
#    And   there are '120' deliverable period rows in CRM linked to the latest version of contract 'AEBP23-0024'
#
#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | AEBA23-0024        | 2372010          | Jul-24 | Reconciliation |
#    | NSF23-0024         | 100942           | Jul-24 | Reconciliation |
#    | STFI23-0024        | 2374010          | Jul-24 | Reconciliation |
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)  
#    Then  the Legal Contract CM feed contains the following '10' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
#    | 10018024 | AEBP23-0024     | 1               | AEBA23-0024      | 1               | 0                     | 43859.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
#    | 10018024 | AEBP23-0024     | 1               | AEBA23-0024      | 4               | 1                     | 19067.00     | 0             | 0        | Adult Skills                                                    | ?                                                           |
#    | 10018024 | AEBP23-0024     | 1               | AEBA23-0024      | 5               | 1                     | 24792.00     | 0             | 0        | Adult Skills Learner Support                                    | ?                                                           |
#    #
#    | 10018024 | AEBP23-0024     | 1               | NSF23-0024       | 1               | 0                     | 41465.00     | 0             | 0        | National Skills Fund Total Funding                              | ?                                                           |
#    | 10018024 | AEBP23-0024     | 1               | NSF23-0024       | 2               | 1                     | 22473.00     | 0             | 0        | Level 3 Offer for 24 year olds and over                         | ?                                                           |
#    | 10018024 | AEBP23-0024     | 1               | NSF23-0024       | 5               | 1                     | 18992.00     | 0             | 0        | National Skills Fund Learner Support                            | ?                                                           |
#    #
#    | 10018024 | AEBP23-0024     | 1               | STFI23-0024      | 1               | 0                     | 23332.00     | 0             | 0        | Short Term Funding Initiative 1                                 | ?                                                           |
#    | 10018024 | AEBP23-0024     | 1               | STFI23-0024      | 2               | 0                     | 23892.00     | 0             | 0        | Short Term Funding Initiative 2                                 | ?                                                           |
#    | 10018024 | AEBP23-0024     | 1               | STFI23-0024      | 3               | 0                     | 22506.00     | 0             | 0        | Short Term Funding Initiative 3                                 | ?                                                           |
#    | 10018024 | AEBP23-0024     | 1               | STFI23-0024      | 4               | 0                     | 23950.00     | 0             | 0        | Short Term Funding Initiative 4                                 | ?                                                           |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract 'AEBP23-0024' agree with the most recent entry for this contract in the ContractManagement feed





    # Part 5: Add Actuals for 23/24 then check CRM

    # Add actuals to the contract for AEB2023-AS2324, AEB2023-NSF2324 

    # Change the date
    Given the override date is '04/10/2023'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018024'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-AS2324              | AEBA23-0024          | ?          | 2               | 0            | 656.38      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-AS2324              | AEBA23-0024          | ?          | 3               | 0            | 514.81      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-AS2324              | AEBA23-0024          | ?          | 6               | 0            | 564.11      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-AS2324              | AEBA23-0024          | ?          | 7               | 0            | 1411.24     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-AS2324              | AEBA23-0024          | ?          | 8               | 0            | 478.56      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-AS2324              | AEBA23-0024          | ?          | 9               | 0            | 1469.21     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-AS2324              | AEBA23-0024          | ?          | 10              | 0            | 1163.17     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-AS2324              | AEBA23-0024          | ?          | 2               | 0            | 2352.37     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-AS2324              | AEBA23-0024          | ?          | 3               | 0            | 465.26      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-AS2324              | AEBA23-0024          | ?          | 6               | 0            | 2003.87     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-AS2324              | AEBA23-0024          | ?          | 7               | 0            | 699.93      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-AS2324              | AEBA23-0024          | ?          | 8               | 0            | 844.84      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-AS2324              | AEBA23-0024          | ?          | 9               | 0            | 1604.57     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-AS2324              | AEBA23-0024          | ?          | 10              | 0            | 860.77      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-AS2324              | AEBA23-0024          | ?          | 2               | 0            | 2029.73     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-AS2324              | AEBA23-0024          | ?          | 3               | 0            | 1578.92     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-AS2324              | AEBA23-0024          | ?          | 6               | 0            | 456.94      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-AS2324              | AEBA23-0024          | ?          | 7               | 0            | 1664.81     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-AS2324              | AEBA23-0024          | ?          | 8               | 0            | 1759.15     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-AS2324              | AEBA23-0024          | ?          | 9               | 0            | 691.06      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-AS2324              | AEBA23-0024          | ?          | 10              | 0            | 2444.27     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-AS2324              | AEBA23-0024          | ?          | 2               | 0            | 2456.58     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-AS2324              | AEBA23-0024          | ?          | 3               | 0            | 647.63      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-AS2324              | AEBA23-0024          | ?          | 6               | 0            | 759.23      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-AS2324              | AEBA23-0024          | ?          | 7               | 0            | 2063.91     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-AS2324              | AEBA23-0024          | ?          | 8               | 0            | 450.22      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-AS2324              | AEBA23-0024          | ?          | 9               | 0            | 1934.00     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-AS2324              | AEBA23-0024          | ?          | 10              | 0            | 1123.20     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-AS2324              | AEBA23-0024          | ?          | 2               | 0            | 1427.78     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-AS2324              | AEBA23-0024          | ?          | 3               | 0            | 1516.24     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-AS2324              | AEBA23-0024          | ?          | 6               | 0            | 1788.03     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-AS2324              | AEBA23-0024          | ?          | 7               | 0            | 1329.88     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-AS2324              | AEBA23-0024          | ?          | 8               | 0            | 2026.43     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-AS2324              | AEBA23-0024          | ?          | 9               | 0            | 789.27      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-AS2324              | AEBA23-0024          | ?          | 10              | 0            | 1287.03     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-AS2324              | AEBA23-0024          | ?          | 2               | 0            | 903.61      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-AS2324              | AEBA23-0024          | ?          | 3               | 0            | 1218.05     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-AS2324              | AEBA23-0024          | ?          | 6               | 0            | 1600.94     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-AS2324              | AEBA23-0024          | ?          | 7               | 0            | 2117.38     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-AS2324              | AEBA23-0024          | ?          | 8               | 0            | 1741.50     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-AS2324              | AEBA23-0024          | ?          | 9               | 0            | 1842.61     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-AS2324              | AEBA23-0024          | ?          | 10              | 0            | 1337.66     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-AS2324              | AEBA23-0024          | ?          | 2               | 0            | 701.10      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-AS2324              | AEBA23-0024          | ?          | 3               | 0            | 533.70      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-AS2324              | AEBA23-0024          | ?          | 6               | 0            | 1360.83     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-AS2324              | AEBA23-0024          | ?          | 7               | 0            | 923.42      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-AS2324              | AEBA23-0024          | ?          | 8               | 0            | 1747.44     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-AS2324              | AEBA23-0024          | ?          | 9               | 0            | 608.77      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-AS2324              | AEBA23-0024          | ?          | 10              | 0            | 418.35      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-AS2324              | AEBA23-0024          | ?          | 2               | 0            | 2227.66     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-AS2324              | AEBA23-0024          | ?          | 3               | 0            | 829.39      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-AS2324              | AEBA23-0024          | ?          | 6               | 0            | 1203.95     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-AS2324              | AEBA23-0024          | ?          | 7               | 0            | 1434.69     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-AS2324              | AEBA23-0024          | ?          | 8               | 0            | 1798.00     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-AS2324              | AEBA23-0024          | ?          | 9               | 0            | 1085.30     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-AS2324              | AEBA23-0024          | ?          | 10              | 0            | 1960.48     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-AS2324              | AEBA23-0024          | ?          | 2               | 0            | 1417.38     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-AS2324              | AEBA23-0024          | ?          | 3               | 0            | 1918.11     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-AS2324              | AEBA23-0024          | ?          | 6               | 0            | 1045.39     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-AS2324              | AEBA23-0024          | ?          | 7               | 0            | 1643.91     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-AS2324              | AEBA23-0024          | ?          | 8               | 0            | 2101.00     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-AS2324              | AEBA23-0024          | ?          | 9               | 0            | 1190.52     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-AS2324              | AEBA23-0024          | ?          | 10              | 0            | 1883.35     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-AS2324              | AEBA23-0024          | ?          | 2               | 0            | 1589.44     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-AS2324              | AEBA23-0024          | ?          | 3               | 0            | 1711.23     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-AS2324              | AEBA23-0024          | ?          | 6               | 0            | 2444.42     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-AS2324              | AEBA23-0024          | ?          | 7               | 0            | 492.88      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-AS2324              | AEBA23-0024          | ?          | 8               | 0            | 1272.18     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-AS2324              | AEBA23-0024          | ?          | 9               | 0            | 1953.95     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-AS2324              | AEBA23-0024          | ?          | 10              | 0            | 2268.45     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-AS2324              | AEBA23-0024          | ?          | 2               | 0            | 1989.29     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-AS2324              | AEBA23-0024          | ?          | 3               | 0            | 702.52      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-AS2324              | AEBA23-0024          | ?          | 6               | 0            | 829.25      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-AS2324              | AEBA23-0024          | ?          | 7               | 0            | 2068.54     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-AS2324              | AEBA23-0024          | ?          | 8               | 0            | 1235.99     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-AS2324              | AEBA23-0024          | ?          | 9               | 0            | 1246.41     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-AS2324              | AEBA23-0024          | ?          | 10              | 0            | 670.54      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-AS2324              | AEBA23-0024          | ?          | 2               | 0            | 750.74      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-AS2324              | AEBA23-0024          | ?          | 3               | 0            | 596.14      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-AS2324              | AEBA23-0024          | ?          | 6               | 0            | 670.68      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-AS2324              | AEBA23-0024          | ?          | 7               | 0            | 2008.59     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-AS2324              | AEBA23-0024          | ?          | 8               | 0            | 529.00      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-AS2324              | AEBA23-0024          | ?          | 9               | 0            | 909.14      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-AS2324              | AEBA23-0024          | ?          | 10              | 0            | 1313.35     |
    #
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0024           | ?          | 3               | 0            | 1951.00     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0024           | ?          | 4               | 0            | 627.27      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0024           | ?          | 6               | 0            | 1274.11     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0024           | ?          | 7               | 0            | 1790.98     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0024           | ?          | 8               | 0            | 615.15      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0024           | ?          | 9               | 0            | 1977.70     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0024           | ?          | 10              | 0            | 1956.70     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0024           | ?          | 3               | 0            | 804.17      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0024           | ?          | 4               | 0            | 855.21      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0024           | ?          | 6               | 0            | 631.06      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0024           | ?          | 7               | 0            | 938.44      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0024           | ?          | 8               | 0            | 995.84      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0024           | ?          | 9               | 0            | 1931.92     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0024           | ?          | 10              | 0            | 2158.27     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0024           | ?          | 3               | 0            | 1047.32     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0024           | ?          | 4               | 0            | 1860.24     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0024           | ?          | 6               | 0            | 1778.15     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0024           | ?          | 7               | 0            | 1313.84     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0024           | ?          | 8               | 0            | 560.35      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0024           | ?          | 9               | 0            | 1744.40     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0024           | ?          | 10              | 0            | 1768.41     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0024           | ?          | 3               | 0            | 1027.36     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0024           | ?          | 4               | 0            | 979.42      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0024           | ?          | 6               | 0            | 420.79      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0024           | ?          | 7               | 0            | 850.88      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0024           | ?          | 8               | 0            | 407.36      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0024           | ?          | 9               | 0            | 469.54      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0024           | ?          | 10              | 0            | 2122.51     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0024           | ?          | 3               | 0            | 1242.00     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0024           | ?          | 4               | 0            | 1707.76     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0024           | ?          | 6               | 0            | 709.66      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0024           | ?          | 7               | 0            | 540.85      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0024           | ?          | 8               | 0            | 1633.41     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0024           | ?          | 9               | 0            | 1106.69     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0024           | ?          | 10              | 0            | 1255.89     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0024           | ?          | 3               | 0            | 1285.57     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0024           | ?          | 4               | 0            | 1961.54     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0024           | ?          | 6               | 0            | 2148.01     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0024           | ?          | 7               | 0            | 1767.36     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0024           | ?          | 8               | 0            | 407.44      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0024           | ?          | 9               | 0            | 1239.62     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0024           | ?          | 10              | 0            | 1895.13     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0024           | ?          | 3               | 0            | 994.41      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0024           | ?          | 4               | 0            | 2233.51     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0024           | ?          | 6               | 0            | 1402.23     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0024           | ?          | 7               | 0            | 1597.45     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0024           | ?          | 8               | 0            | 1779.48     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0024           | ?          | 9               | 0            | 664.64      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0024           | ?          | 10              | 0            | 512.30      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0024           | ?          | 3               | 0            | 1169.29     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0024           | ?          | 4               | 0            | 1720.29     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0024           | ?          | 6               | 0            | 1635.78     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0024           | ?          | 7               | 0            | 1230.69     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0024           | ?          | 8               | 0            | 1531.22     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0024           | ?          | 9               | 0            | 945.68      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0024           | ?          | 10              | 0            | 1638.53     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0024           | ?          | 3               | 0            | 1248.17     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0024           | ?          | 4               | 0            | 1864.06     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0024           | ?          | 6               | 0            | 1103.86     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0024           | ?          | 7               | 0            | 1856.37     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0024           | ?          | 8               | 0            | 829.96      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0024           | ?          | 9               | 0            | 1025.21     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0024           | ?          | 10              | 0            | 1113.23     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0024           | ?          | 3               | 0            | 562.25      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0024           | ?          | 4               | 0            | 1572.82     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0024           | ?          | 6               | 0            | 1277.62     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0024           | ?          | 7               | 0            | 775.62      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0024           | ?          | 8               | 0            | 778.81      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0024           | ?          | 9               | 0            | 1924.50     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0024           | ?          | 10              | 0            | 1381.12     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0024           | ?          | 3               | 0            | 1152.10     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0024           | ?          | 4               | 0            | 1750.97     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0024           | ?          | 6               | 0            | 565.78      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0024           | ?          | 7               | 0            | 1246.40     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0024           | ?          | 8               | 0            | 1701.23     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0024           | ?          | 9               | 0            | 1981.15     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0024           | ?          | 10              | 0            | 2105.12     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0024           | ?          | 3               | 0            | 1501.39     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0024           | ?          | 4               | 0            | 1579.87     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0024           | ?          | 6               | 0            | 876.86      |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0024           | ?          | 7               | 0            | 1035.48     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0024           | ?          | 8               | 0            | 1670.15     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0024           | ?          | 9               | 0            | 1406.46     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0024           | ?          | 10              | 0            | 860.95      |
	#
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-STFI2324                | STFI23-0024          | ?          | 5               | 0            | 3062.68     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-STFI2324                | STFI23-0024          | ?          | 6               | 0            | 1921.44     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-STFI2324                | STFI23-0024          | ?          | 7               | 0            | 3923.76     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-STFI2324                | STFI23-0024          | ?          | 8               | 0            | 1974.73     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-STFI2324                | STFI23-0024          | ?          | 9               | 0            | 2866.75     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-STFI2324                | STFI23-0024          | ?          | 10              | 0            | 3299.57     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-STFI2324                | STFI23-0024          | ?          | 11              | 0            | 1543.30     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202308 | AEB2023-STFI2324                | STFI23-0024          | ?          | 12              | 0            | 4679.30     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-STFI2324                | STFI23-0024          | ?          | 5               | 0            | 2288.45     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-STFI2324                | STFI23-0024          | ?          | 6               | 0            | 3053.34     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-STFI2324                | STFI23-0024          | ?          | 7               | 0            | 2450.38     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-STFI2324                | STFI23-0024          | ?          | 8               | 0            | 2277.92     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-STFI2324                | STFI23-0024          | ?          | 9               | 0            | 2758.03     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-STFI2324                | STFI23-0024          | ?          | 10              | 0            | 2873.23     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-STFI2324                | STFI23-0024          | ?          | 11              | 0            | 3429.78     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202309 | AEB2023-STFI2324                | STFI23-0024          | ?          | 12              | 0            | 2147.47     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-STFI2324                | STFI23-0024          | ?          | 5               | 0            | 2151.15     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-STFI2324                | STFI23-0024          | ?          | 6               | 0            | 1913.51     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-STFI2324                | STFI23-0024          | ?          | 7               | 0            | 2274.98     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-STFI2324                | STFI23-0024          | ?          | 8               | 0            | 2038.74     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-STFI2324                | STFI23-0024          | ?          | 9               | 0            | 4121.72     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-STFI2324                | STFI23-0024          | ?          | 10              | 0            | 1793.75     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-STFI2324                | STFI23-0024          | ?          | 11              | 0            | 2583.48     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202310 | AEB2023-STFI2324                | STFI23-0024          | ?          | 12              | 0            | 2090.50     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-STFI2324                | STFI23-0024          | ?          | 5               | 0            | 1859.62     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-STFI2324                | STFI23-0024          | ?          | 6               | 0            | 2525.45     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-STFI2324                | STFI23-0024          | ?          | 7               | 0            | 2877.09     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-STFI2324                | STFI23-0024          | ?          | 8               | 0            | 4468.58     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-STFI2324                | STFI23-0024          | ?          | 9               | 0            | 2273.67     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-STFI2324                | STFI23-0024          | ?          | 10              | 0            | 2563.53     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-STFI2324                | STFI23-0024          | ?          | 11              | 0            | 3047.25     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202311 | AEB2023-STFI2324                | STFI23-0024          | ?          | 12              | 0            | 3929.91     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-STFI2324                | STFI23-0024          | ?          | 5               | 0            | 1499.26     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-STFI2324                | STFI23-0024          | ?          | 6               | 0            | 2982.96     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-STFI2324                | STFI23-0024          | ?          | 7               | 0            | 1725.33     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-STFI2324                | STFI23-0024          | ?          | 8               | 0            | 2311.61     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-STFI2324                | STFI23-0024          | ?          | 9               | 0            | 4131.33     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-STFI2324                | STFI23-0024          | ?          | 10              | 0            | 2580.26     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-STFI2324                | STFI23-0024          | ?          | 11              | 0            | 4377.97     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202312 | AEB2023-STFI2324                | STFI23-0024          | ?          | 12              | 0            | 4045.05     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-STFI2324                | STFI23-0024          | ?          | 5               | 0            | 3682.03     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-STFI2324                | STFI23-0024          | ?          | 6               | 0            | 3700.14     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-STFI2324                | STFI23-0024          | ?          | 7               | 0            | 2527.35     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-STFI2324                | STFI23-0024          | ?          | 8               | 0            | 2594.85     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-STFI2324                | STFI23-0024          | ?          | 9               | 0            | 3463.68     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-STFI2324                | STFI23-0024          | ?          | 10              | 0            | 2386.97     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-STFI2324                | STFI23-0024          | ?          | 11              | 0            | 3296.57     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202401 | AEB2023-STFI2324                | STFI23-0024          | ?          | 12              | 0            | 4023.07     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-STFI2324                | STFI23-0024          | ?          | 5               | 0            | 1996.45     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-STFI2324                | STFI23-0024          | ?          | 6               | 0            | 2461.42     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-STFI2324                | STFI23-0024          | ?          | 7               | 0            | 3679.89     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-STFI2324                | STFI23-0024          | ?          | 8               | 0            | 1878.11     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-STFI2324                | STFI23-0024          | ?          | 9               | 0            | 2341.28     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-STFI2324                | STFI23-0024          | ?          | 10              | 0            | 4021.98     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-STFI2324                | STFI23-0024          | ?          | 11              | 0            | 1938.07     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202402 | AEB2023-STFI2324                | STFI23-0024          | ?          | 12              | 0            | 2408.94     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-STFI2324                | STFI23-0024          | ?          | 5               | 0            | 2457.61     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-STFI2324                | STFI23-0024          | ?          | 6               | 0            | 2671.53     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-STFI2324                | STFI23-0024          | ?          | 7               | 0            | 3218.73     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-STFI2324                | STFI23-0024          | ?          | 8               | 0            | 4404.03     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-STFI2324                | STFI23-0024          | ?          | 9               | 0            | 2886.26     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-STFI2324                | STFI23-0024          | ?          | 10              | 0            | 2768.93     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-STFI2324                | STFI23-0024          | ?          | 11              | 0            | 2901.56     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202403 | AEB2023-STFI2324                | STFI23-0024          | ?          | 12              | 0            | 2955.46     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-STFI2324                | STFI23-0024          | ?          | 5               | 0            | 2057.17     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-STFI2324                | STFI23-0024          | ?          | 6               | 0            | 1805.53     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-STFI2324                | STFI23-0024          | ?          | 7               | 0            | 3768.73     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-STFI2324                | STFI23-0024          | ?          | 8               | 0            | 3948.03     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-STFI2324                | STFI23-0024          | ?          | 9               | 0            | 2322.28     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-STFI2324                | STFI23-0024          | ?          | 10              | 0            | 2006.79     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-STFI2324                | STFI23-0024          | ?          | 11              | 0            | 4300.15     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202404 | AEB2023-STFI2324                | STFI23-0024          | ?          | 12              | 0            | 3073.22     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-STFI2324                | STFI23-0024          | ?          | 5               | 0            | 3613.33     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-STFI2324                | STFI23-0024          | ?          | 6               | 0            | 2958.78     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-STFI2324                | STFI23-0024          | ?          | 7               | 0            | 4293.80     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-STFI2324                | STFI23-0024          | ?          | 8               | 0            | 1968.35     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-STFI2324                | STFI23-0024          | ?          | 9               | 0            | 4524.62     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-STFI2324                | STFI23-0024          | ?          | 10              | 0            | 1659.81     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-STFI2324                | STFI23-0024          | ?          | 11              | 0            | 4711.05     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202405 | AEB2023-STFI2324                | STFI23-0024          | ?          | 12              | 0            | 2080.61     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-STFI2324                | STFI23-0024          | ?          | 5               | 0            | 4220.87     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-STFI2324                | STFI23-0024          | ?          | 6               | 0            | 3296.95     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-STFI2324                | STFI23-0024          | ?          | 7               | 0            | 1746.92     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-STFI2324                | STFI23-0024          | ?          | 8               | 0            | 2656.09     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-STFI2324                | STFI23-0024          | ?          | 9               | 0            | 1870.04     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-STFI2324                | STFI23-0024          | ?          | 10              | 0            | 3147.59     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-STFI2324                | STFI23-0024          | ?          | 11              | 0            | 1525.50     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202406 | AEB2023-STFI2324                | STFI23-0024          | ?          | 12              | 0            | 2853.88     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-STFI2324                | STFI23-0024          | ?          | 5               | 0            | 3501.13     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-STFI2324                | STFI23-0024          | ?          | 6               | 0            | 2306.02     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-STFI2324                | STFI23-0024          | ?          | 7               | 0            | 2620.15     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-STFI2324                | STFI23-0024          | ?          | 8               | 0            | 4685.11     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-STFI2324                | STFI23-0024          | ?          | 9               | 0            | 3286.95     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-STFI2324                | STFI23-0024          | ?          | 10              | 0            | 4435.01     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-STFI2324                | STFI23-0024          | ?          | 11              | 0            | 2498.86     |
    | ILR2324        | R02                  | ORG0018024     | CM             | 202407 | AEB2023-STFI2324                | STFI23-0024          | ?          | 12              | 0            | 3577.04     |


    Then wait '60' seconds


    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then wait '60' seconds


    # Check financials

#    # Check the PLANNED VALUES in CRM on the latest approved contract
#    Then  the Planned Values are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
#    | AEBP23-0024   | NSF23-0024     | 1               | 89738.00  | 7235.00  | 8287.00  | 3021.00  | 10867.00 | 9072.00  | 4890.00  | 7374.00  | 4146.00  | 3765.00  | 12363.00 | 12533.00 | 6185.00  | 
#    | AEBP23-0024   | NSF23-0024     | 2               | 41067.00  | 5587.00  | 5130.00  | 661.00   | 4006.00  | 7763.00  | 714.00   | 120.00   | 1903.00  | 2392.00  | 4653.00  | 7933.00  | 205.00   | 
#    | AEBP23-0024   | NSF23-0024     | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | NSF23-0024     | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | NSF23-0024     | 5               | 48671.00  | 1648.00  | 3157.00  | 2360.00  | 6861.00  | 1309.00  | 4176.00  | 7254.00  | 2243.00  | 1373.00  | 7710.00  | 4600.00  | 5980.00  | 
#    | AEBP23-0024   | NSF23-0024     | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | NSF23-0024     | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | NSF23-0024     | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | NSF23-0024     | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | NSF23-0024     | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    #
#    | AEBP23-0024   | AEBA23-0024    | 1               | 106975.00 | 11441.00 | 6250.00  | 6419.00  | 11750.00 | 7439.00  | 8692.00  | 8660.00  | 10868.00 | 12195.00 | 10326.00 | 7980.00  | 4955.00  | 
#    | AEBP23-0024   | AEBA23-0024    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | AEBA23-0024    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | AEBA23-0024    | 4               | 60557.00  | 6230.00  | 5572.00  | 3820.00  | 6963.00  | 5487.00  | 4075.00  | 6198.00  | 7780.00  | 5147.00  | 5094.00  | 3141.00  | 1050.00  | 
#    | AEBP23-0024   | AEBA23-0024    | 5               | 46418.00  | 5211.00  | 678.00   | 2599.00  | 4787.00  | 1952.00  | 4617.00  | 2462.00  | 3088.00  | 7048.00  | 5232.00  | 4839.00  | 3905.00  | 
#    | AEBP23-0024   | AEBA23-0024    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | AEBA23-0024    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | AEBA23-0024    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | AEBA23-0024    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | AEBA23-0024    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#	#
#    | AEBP23-0024   | STFI23-0024    | 1               | 48191.00  | 225.00   | 7921.00  | 735.00   | 6393.00  | 5321.00  | 6425.00  | 3113.00  | 5098.00  | 4981.00  | 7444.00  | 55.00    | 480.00   | 
#    | AEBP23-0024   | STFI23-0024    | 2               | 57906.00  | 7157.00  | 3028.00  | 5353.00  | 4217.00  | 1786.00  | 6967.00  | 7327.00  | 2518.00  | 6882.00  | 7582.00  | 1754.00  | 3335.00  | 
#    | AEBP23-0024   | STFI23-0024    | 3               | 45879.00  | 6542.00  | 650.00   | 6648.00  | 4557.00  | 767.00   | 4185.00  | 3994.00  | 342.00   | 5459.00  | 172.00   | 5968.00  | 6595.00  | 
#    | AEBP23-0024   | STFI23-0024    | 4               | 41802.00  | 2603.00  | 6627.00  | 395.00   | 7412.00  | 2264.00  | 1807.00  | 5289.00  | 682.00   | 4439.00  | 3230.00  | 2635.00  | 4419.00  | 
#    | AEBP23-0024   | STFI23-0024    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP23-0024   | NSF23-0024     | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | NSF23-0024     | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | NSF23-0024     | 3               | 2755.17   | 1951.00  | 804.17   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | NSF23-0024     | 4               | 1482.48   | 627.27   | 855.21   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | NSF23-0024     | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | NSF23-0024     | 6               | 1905.17   | 1274.11  | 631.06   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | NSF23-0024     | 7               | 2729.42   | 1790.98  | 938.44   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | NSF23-0024     | 8               | 1610.99   | 615.15   | 995.84   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | NSF23-0024     | 9               | 3909.62   | 1977.70  | 1931.92  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | NSF23-0024     | 10              | 4114.97   | 1956.70  | 2158.27  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | AEBP23-0024   | AEBA23-0024    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | AEBA23-0024    | 2               | 3008.75   | 656.38   | 2352.37  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | AEBA23-0024    | 3               | 980.07    | 514.81   | 465.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | AEBA23-0024    | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | AEBA23-0024    | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | AEBA23-0024    | 6               | 2567.98   | 564.11   | 2003.87  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | AEBA23-0024    | 7               | 2111.17   | 1411.24  | 699.93   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | AEBA23-0024    | 8               | 1323.40   | 478.56   | 844.84   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | AEBA23-0024    | 9               | 3073.78   | 1469.21  | 1604.57  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | AEBA23-0024    | 10              | 2023.94   | 1163.17  | 860.77   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
	#
    | AEBP23-0024   | STFI23-0024    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | STFI23-0024    | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | STFI23-0024    | 3               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | STFI23-0024    | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | STFI23-0024    | 5               | 5351.13   | 3062.68  | 2288.45  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | STFI23-0024    | 6               | 4974.78   | 1921.44  | 3053.34  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | STFI23-0024    | 7               | 6374.14   | 3923.76  | 2450.38  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | STFI23-0024    | 8               | 4252.65   | 1974.73  | 2277.92  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | STFI23-0024    | 9               | 5624.78   | 2866.75  | 2758.03  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | STFI23-0024    | 10              | 6172.80   | 3299.57  | 2873.23  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | STFI23-0024    | 11              | 4973.08   | 1543.30  | 3429.78  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0024   | STFI23-0024    | 12              | 6826.77   | 4679.30  | 2147.47  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #



##    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
##    And   the Reconciliation Data is calculated as follows 
##    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
##    | AEBP23-0024   | NSF23-0024     | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | NSF23-0024     | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | NSF23-0024     | 3               | 2755.17   | 0.00     | 2755.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | NSF23-0024     | 4               | 1482.48   | 0.00     | 1482.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | NSF23-0024     | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | NSF23-0024     | 6               | 1905.17   | 0.00     | 1905.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | NSF23-0024     | 7               | 2729.42   | 0.00     | 2729.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | NSF23-0024     | 8               | 1610.99   | 0.00     | 1610.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | NSF23-0024     | 9               | 3909.62   | 0.00     | 3909.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | NSF23-0024     | 10              | 4114.97   | 0.00     | 4114.97  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    #
##    | AEBP23-0024   | AEBA23-0024    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | AEBA23-0024    | 2               | 3008.75   | 0.00     | 3008.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | AEBA23-0024    | 3               | 980.07    | 0.00     | 980.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | AEBA23-0024    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | AEBA23-0024    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | AEBA23-0024    | 6               | 2567.98   | 0.00     | 2567.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | AEBA23-0024    | 7               | 2111.17   | 0.00     | 2111.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | AEBA23-0024    | 8               | 1323.40   | 0.00     | 1323.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | AEBA23-0024    | 9               | 3073.78   | 0.00     | 3073.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | AEBP23-0024   | AEBA23-0024    | 10              | 2023.94   | 0.00     | 2023.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    #
#    | AEBP23-0024   | STFI23-0024    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 5               | 5351.13   | 0.00     | 5351.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 6               | 4974.78   | 0.00     | 4974.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 7               | 6374.14   | 0.00     | 6374.14  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 8               | 4252.65   | 0.00     | 4252.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 9               | 5624.78   | 0.00     | 5624.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 10              | 6172.80   | 0.00     | 6172.80  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 11              | 4973.08   | 0.00     | 4973.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP23-0024   | STFI23-0024    | 12              | 6826.77   | 0.00     | 6826.77  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
##



    # Part 6: Create and check the contents of the CDA report
   
    # Change the date
    Given the override date is '05/10/2023'
    
    # Check the contents of the CDA report
    And   there is no CDA report named 'CDA Last Approved Version S024.csv'

    And   the following contracts are in the replicated CRM database
    | ContractNumber | ContractVersionNumber |
    | AEBP23-0024    | 1                     |

   #When  the following CDA reports are run
    When  the following CDA report is run
    | FundingStreamPeriod						             | Version               | Suffix |
    | AEB2023-AS2324,AEB2023-NSF2324, AEB2023-STFI2324       | Last Approved         | S024   |

    Then  a report named 'CDA Last Approved Version S024.csv' is created

    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | AEB2023-AS2324              | 10018024 | 10018024 Co Ltd             |               |                             | AEBA23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 19+ Hardship                            | Adult Skills 19+ Hardship                                       | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 564.11       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100927                   | 2372016           | Aug              |
#    | AEB2023-AS2324              | 10018024 | 10018024 Co Ltd             |               |                             | AEBA23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 19+ Hardship                            | Adult Skills 19+ Hardship                                       | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 2003.87      | 0             |              | Yes                | 0.00           | 0.00             | 2567.98               | 0.00           | 2567.98         |             | No            |                   |        |                   | 100927                   | 2372016           | Sep              |
#    | AEB2023-AS2324              | 10018024 | 10018024 Co Ltd             |               |                             | AEBA23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 20+ Childcare                           | Adult Skills 20+ Childcare                                      | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 1411.24      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100928                   | 2372016           | Aug              |
#    | AEB2023-AS2324              | 10018024 | 10018024 Co Ltd             |               |                             | AEBA23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 20+ Childcare                           | Adult Skills 20+ Childcare                                      | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 699.93       | 0             |              | Yes                | 0.00           | 0.00             | 2111.17               | 0.00           | 2111.17         |             | No            |                   |        |                   | 100928                   | 2372016           | Sep              |
#    | AEB2023-AS2324              | 10018024 | 10018024 Co Ltd             |               |                             | AEBA23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Administration Expenditure              | Adult Skills Administration Expenditure                         | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 1469.21      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100930                   | 2372016           | Aug              |
#    | AEB2023-AS2324              | 10018024 | 10018024 Co Ltd             |               |                             | AEBA23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Administration Expenditure              | Adult Skills Administration Expenditure                         | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 1604.57      | 0             |              | Yes                | 0.00           | 0.00             | 3073.78               | 0.00           | 3073.78         |             | No            |                   |        |                   | 100930                   | 2372016           | Sep              |
#    | AEB2023-AS2324              | 10018024 | 10018024 Co Ltd             |               |                             | AEBA23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills COVID-19 Response (ICT)                 | Adult Skills COVID-19 Response (ICT)                            | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 1163.17      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100931                   | 2372016           | Aug              |
#    | AEB2023-AS2324              | 10018024 | 10018024 Co Ltd             |               |                             | AEBA23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills COVID-19 Response (ICT)                 | Adult Skills COVID-19 Response (ICT)                            | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 860.77       | 0             |              | Yes                | 0.00           | 0.00             | 2023.94               | 0.00           | 2023.94         |             | No            |                   |        |                   | 100931                   | 2372016           | Sep              |
#    | AEB2023-AS2324              | 10018024 | 10018024 Co Ltd             |               |                             | AEBA23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Learning Support                        | Adult Skills Learning Support                                   | Adult Skills                                                    | 8                 | 2022            | 2022/23       |              | 0            | 514.81       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2372060                  | 2372016           | Aug              |
#    | AEB2023-AS2324              | 10018024 | 10018024 Co Ltd             |               |                             | AEBA23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Learning Support                        | Adult Skills Learning Support                                   | Adult Skills                                                    | 9                 | 2022            | 2022/23       |              | 0            | 465.26       | 0             |              | Yes                | 0.00           | 0.00             | 980.07                | 0.00           | 980.07          |             | No            |                   |        |                   | 2372060                  | 2372016           | Sep              |
#    | AEB2023-AS2324              | 10018024 | 10018024 Co Ltd             |               |                             | AEBA23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Programme Funding                       | Adult Skills Programme Funding                                  | Adult Skills                                                    | 8                 | 2022            | 2022/23       |              | 0            | 656.38       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2372010                  | 2372016           | Aug              |
#    | AEB2023-AS2324              | 10018024 | 10018024 Co Ltd             |               |                             | AEBA23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Programme Funding                       | Adult Skills Programme Funding                                  | Adult Skills                                                    | 9                 | 2022            | 2022/23       |              | 0            | 2352.37      | 0             |              | Yes                | 0.00           | 0.00             | 3008.75               | 0.00           | 3008.75         |             | No            |                   |        |                   | 2372010                  | 2372016           | Sep              |
#    | AEB2023-AS2324              | 10018024 | 10018024 Co Ltd             |               |                             | AEBA23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Residential Access Fund                 | Adult Skills Residential Access Fund                            | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 478.56       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100929                   | 2372016           | Aug              |
#    | AEB2023-AS2324              | 10018024 | 10018024 Co Ltd             |               |                             | AEBA23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Residential Access Fund                 | Adult Skills Residential Access Fund                            | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 844.84       | 0             |              | Yes                | 0.00           | 0.00             | 1323.40               | 0.00           | 1323.40         |             | No            |                   |        |                   | 100929                   | 2372016           | Sep              |
#    #
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund 19+ Hardship                    | National Skills Fund 19+ Hardship                               | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 1274.11      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100937                   | 100944            | Aug              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund 19+ Hardship                    | National Skills Fund 19+ Hardship                               | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 631.06       | 0             |              | Yes                | 0.00           | 0.00             | 1905.17               | 0.00           | 1905.17         |             | No            |                   |        |                   | 100937                   | 100944            | Sep              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund 20+ Childcare                   | National Skills Fund 20+ Childcare                              | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 1790.98      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100938                   | 100944            | Aug              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund 20+ Childcare                   | National Skills Fund 20+ Childcare                              | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 938.44       | 0             |              | Yes                | 0.00           | 0.00             | 2729.42               | 0.00           | 2729.42         |             | No            |                   |        |                   | 100938                   | 100944            | Sep              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Administration Expenditure      | National Skills Fund Administration Expenditure                 | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 1977.7       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100940                   | 100944            | Aug              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Administration Expenditure      | National Skills Fund Administration Expenditure                 | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 1931.92      | 0             |              | Yes                | 0.00           | 0.00             | 3909.62               | 0.00           | 3909.62         |             | No            |                   |        |                   | 100940                   | 100944            | Sep              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund COVID-19 Response (ICT)         | National Skills Fund COVID-19 Response (ICT)                    | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 1956.7       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100941                   | 100944            | Aug              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund COVID-19 Response (ICT)         | National Skills Fund COVID-19 Response (ICT)                    | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 2158.27      | 0             |              | Yes                | 0.00           | 0.00             | 4114.97               | 0.00           | 4114.97         |             | No            |                   |        |                   | 100941                   | 100944            | Sep              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Learning Support                | National Skills Fund Learning Support                           | National Skills Fund Total Funding                              | 8                 | 2022            | 2022/23       |              | 0            | 627.27       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100943                   | 100944            | Aug              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Learning Support                | National Skills Fund Learning Support                           | National Skills Fund Total Funding                              | 9                 | 2022            | 2022/23       |              | 0            | 855.21       | 0             |              | Yes                | 0.00           | 0.00             | 1482.48               | 0.00           | 1482.48         |             | No            |                   |        |                   | 100943                   | 100944            | Sep              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Programme Funding               | National Skills Fund Programme Funding                          | National Skills Fund Total Funding                              | 8                 | 2022            | 2022/23       |              | 0            | 1951         | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100942                   | 100944            | Aug              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Programme Funding               | National Skills Fund Programme Funding                          | National Skills Fund Total Funding                              | 9                 | 2022            | 2022/23       |              | 0            | 804.17       | 0             |              | Yes                | 0.00           | 0.00             | 2755.17               | 0.00           | 2755.17         |             | No            |                   |        |                   | 100942                   | 100944            | Sep              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Residential Access Fund         | National Skills Fund Residential Access Fund                    | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 615.15       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100939                   | 100944            | Aug              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Residential Access Fund         | National Skills Fund Residential Access Fund                    | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 995.84       | 0             |              | Yes                | 0.00           | 0.00             | 1610.99               | 0.00           | 1610.99         |             | No            |                   |        |                   | 100939                   | 100944            | Sep              |
#    #
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Learning Support     | Short Term Funding Initiative 1 Learning Support                | Short Term Funding Initiative 1                                 | 8                 | 2022            | 2022/23       |              | 0            | 1921.44      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374010                  | 2374010           | Aug              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Learning Support     | Short Term Funding Initiative 1 Learning Support                | Short Term Funding Initiative 1                                 | 9                 | 2022            | 2022/23       |              | 0            | 3053.34      | 0             |              | Yes                | 0.00           | 0.00             | 4974.78               | 0.00           | 4974.78         |             | No            |                   |        |                   | 2374010                  | 2374010           | Sep              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Programme Funding    | Short Term Funding Initiative 1 Programme Funding               | Short Term Funding Initiative 1                                 | 8                 | 2022            | 2022/23       |              | 0            | 3062.68      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374010                  | 2374010           | Aug              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Programme Funding    | Short Term Funding Initiative 1 Programme Funding               | Short Term Funding Initiative 1                                 | 9                 | 2022            | 2022/23       |              | 0            | 2288.45      | 0             |              | Yes                | 0.00           | 0.00             | 5351.13               | 0.00           | 5351.13         |             | No            |                   |        |                   | 2374010                  | 2374010           | Sep              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Learning Support     | Short Term Funding Initiative 2 Learning Support                | Short Term Funding Initiative 2                                 | 8                 | 2022            | 2022/23       |              | 0            | 1974.73      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374020                  | 2374020           | Aug              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Learning Support     | Short Term Funding Initiative 2 Learning Support                | Short Term Funding Initiative 2                                 | 9                 | 2022            | 2022/23       |              | 0            | 2277.92      | 0             |              | Yes                | 0.00           | 0.00             | 4252.65               | 0.00           | 4252.65         |             | No            |                   |        |                   | 2374020                  | 2374020           | Sep              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Programme Funding    | Short Term Funding Initiative 2 Programme Funding               | Short Term Funding Initiative 2                                 | 8                 | 2022            | 2022/23       |              | 0            | 3923.76      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374020                  | 2374020           | Aug              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Programme Funding    | Short Term Funding Initiative 2 Programme Funding               | Short Term Funding Initiative 2                                 | 9                 | 2022            | 2022/23       |              | 0            | 2450.38      | 0             |              | Yes                | 0.00           | 0.00             | 6374.14               | 0.00           | 6374.14         |             | No            |                   |        |                   | 2374020                  | 2374020           | Sep              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Learning Support     | Short Term Funding Initiative 3 Learning Support                | Short Term Funding Initiative 3                                 | 8                 | 2022            | 2022/23       |              | 0            | 3299.57      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374030                  | 2374030           | Aug              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Learning Support     | Short Term Funding Initiative 3 Learning Support                | Short Term Funding Initiative 3                                 | 9                 | 2022            | 2022/23       |              | 0            | 2873.23      | 0             |              | Yes                | 0.00           | 0.00             | 6172.80               | 0.00           | 6172.80         |             | No            |                   |        |                   | 2374030                  | 2374030           | Sep              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Programme Funding    | Short Term Funding Initiative 3 Programme Funding               | Short Term Funding Initiative 3                                 | 8                 | 2022            | 2022/23       |              | 0            | 2866.75      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374030                  | 2374030           | Aug              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Programme Funding    | Short Term Funding Initiative 3 Programme Funding               | Short Term Funding Initiative 3                                 | 9                 | 2022            | 2022/23       |              | 0            | 2758.03      | 0             |              | Yes                | 0.00           | 0.00             | 5624.78               | 0.00           | 5624.78         |             | No            |                   |        |                   | 2374030                  | 2374030           | Sep              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Learning Support     | Short Term Funding Initiative 4 Learning Support                | Short Term Funding Initiative 4                                 | 8                 | 2022            | 2022/23       |              | 0            | 4679.3       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374040                  | 2374040           | Aug              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Learning Support     | Short Term Funding Initiative 4 Learning Support                | Short Term Funding Initiative 4                                 | 9                 | 2022            | 2022/23       |              | 0            | 2147.47      | 0             |              | Yes                | 0.00           | 0.00             | 6826.77               | 0.00           | 6826.77         |             | No            |                   |        |                   | 2374040                  | 2374040           | Sep              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Programme Funding    | Short Term Funding Initiative 4 Programme Funding               | Short Term Funding Initiative 4                                 | 8                 | 2022            | 2022/23       |              | 0            | 1543.3       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374040                  | 2374040           | Aug              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | AEBP23-0024   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Programme Funding    | Short Term Funding Initiative 4 Programme Funding               | Short Term Funding Initiative 4                                 | 9                 | 2022            | 2022/23       |              | 0            | 3429.78      | 0             |              | Yes                | 0.00           | 0.00             | 4973.08               | 0.00           | 4973.08         |             | No            |                   |        |                   | 2374040                  | 2374040           | Sep              |
#




    # Part 7a: Payment Batch for AEB2023-AS2324

    # Change the date
    Given the override date is '09/10/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB2023-AS2324' AccountingPaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | AEBA23-0024              | 202309 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB2023-AS2324             | 202309               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEB2023-AS2324             | 202309               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB2023-AS2324' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S024_AS.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB2023-AS2324' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AS23                   | 2023          | 06             | 10          | ?       | AEBA23-0024      | 3008.75         | RECONCILIATION   | AEB Other Learning                 | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372010    |
    | AS23                   | 2023          | 06             | 10          | ?       | AEBA23-0024      | 980.07          | RECONCILIATION   | AEB OthLearning LngS               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372060    |
    | AS23                   | 2023          | 06             | 10          | ?       | AEBA23-0024      | 2567.98         | RECONCILIATION   | AdltSkll19+Hardship                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100927     |
    | AS23                   | 2023          | 06             | 10          | ?       | AEBA23-0024      | 2111.17         | RECONCILIATION   | AdltSkll20+Childcare               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100928     |
    | AS23                   | 2023          | 06             | 10          | ?       | AEBA23-0024      | 1323.40         | RECONCILIATION   | AdltSkllRsdntlAccess               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100929     |
    | AS23                   | 2023          | 06             | 10          | ?       | AEBA23-0024      | 3073.78         | RECONCILIATION   | AdltSkllAdminExp                   | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100930     |
    | AS23                   | 2023          | 06             | 10          | ?       | AEBA23-0024      | 2023.94         | RECONCILIATION   | AdltSkllC19Response                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100931     |
    #                                                                                                    £15089.09




    # Part 7b: Payment Batch for AEB2023-NSF2324

    # Change the date
    Given the override date is '09/10/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB2023-NSF2324' AccountingPaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | NSF23-0024               | 202309 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB2023-NSF2324            | 202309               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEB2023-NSF2324            | 202309               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB2023-NSF2324' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S024_NSF.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB2023-NSF2324' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | NS23                    | 2023          | 06             | 10          | ?       | NSF23-0024      | 2755.17         | RECONCILIATION   | NSF Programme                      | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100942     |
    | NS23                    | 2023          | 06             | 10          | ?       | NSF23-0024      | 1482.48         | RECONCILIATION   | NSF Learning Support               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100943     |
    | NS23                    | 2023          | 06             | 10          | ?       | NSF23-0024      | 1905.17         | RECONCILIATION   | NSF 19+ Hardship                   | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100937     |
    | NS23                    | 2023          | 06             | 10          | ?       | NSF23-0024      | 2729.42         | RECONCILIATION   | NSF 20+ Childcare                  | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100938     |
    | NS23                    | 2023          | 06             | 10          | ?       | NSF23-0024      | 1610.99         | RECONCILIATION   | NSF RsdntlAccessFund               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100939     |
    | NS23                    | 2023          | 06             | 10          | ?       | NSF23-0024      | 3909.62         | RECONCILIATION   | NSF Admin Exp                      | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100940     |
    | NS23                    | 2023          | 06             | 10          | ?       | NSF23-0024      | 4114.97         | RECONCILIATION   | NSF COVID19 Response               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100941     |
    #                                                                                                    £18507.82


    # Part 7c: Payment Batch for AEB2023-STFI2324

    # Change the date
    Given the override date is '09/10/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB2023-STFI2324' AccountingPaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | STFI23-0024		       | 202309 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB2023-STFI2324           | 202309               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEB2023-STFI2324           | 202309               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB2023-STFI2324' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S024_STFI.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB2023-STFI2324' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | ST23                   | 2023          | 06             | 10          | ?       | STFI23-0024      | 10325.91        | RECONCILIATION   | ShortTermInit1Cntrct               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2374010    |
    | ST23                   | 2023          | 06             | 10          | ?       | STFI23-0024      | 10626.79        | RECONCILIATION   | ShortTermInit2Cntrct               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2374020    |
    | ST23                   | 2023          | 06             | 10          | ?       | STFI23-0024      | 11797.58        | RECONCILIATION   | ShortTermInit3Cntrct               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2374030    |
    | ST23                   | 2023          | 06             | 10          | ?       | STFI23-0024      | 11799.85        | RECONCILIATION   | ShortTermInit4Cntrct               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2374040    |
    #                                                                                                    £ 44550.13




    # Consolidated Payment Summary Report

    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    When a Consolidated Payment Summary Report is created in Sharepoint for '12/10/2023'
    # Check the above report manually


    
    # Simulate a new version of the TaC & other templates (g)

    # Change the date 
    Given the override date is '20/11/2023'

    # Update the timestamp on the TaC template to a date after contract v1 was created  (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    Given the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
   #| SOF_AEB2023_2023-08-01.docx                     | 2023-11-20 12:00:00.000 | 
    #
    | AEB2023_2324_TAC_2023-08-01.docx                | 2023-11-20 12:00:00.000 | 
    | AEB2023_2324_S1_2023-08-01.docx                 | 2023-11-20 12:00:00.000 | 
    | AEB2023_2324_S2_2023-08-01.docx                 | 2023-11-20 12:00:00.000 | 
   #| FA_AEB2023_2324_2023-08-01.docx                 | 2023-11-20 12:00:00.000 | 
    | AEB2023_2324_S3ON_2023-08-01.docx               | 2023-11-20 12:00:00.000 | 


	
    
    # Part 2: Bulk import a 23/24 contract 
    
    # Change the date
    Given the override date is '01/12/2023'

    # Bulk file 
    And   there are no files prefixed '10018024' in the Sharepoint 'AEB2023-2324-Input-Appendices' folder
    And   there are no files prefixed 'AEB2023 AY 2324 29052023112659 v2_S024' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB2023 AY 2324 29052023112659 v2_S024' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB2023 AY 2324 29052023112659 v2_S024' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB2023 AY 2324 29052023112659 v2_S024' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB2023 AY 2324 29052023112659 v2_S024.xlsx' exists in the Datafiles folder and UKPRN '10018024' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


     # Part 3: Check docs
 
     # Change the date
     Given the override date is '02/12/2023'
 
     # Retrieve parameters
    #When  I retrieve the latest EFA contract details from CRM for provider '10018024' for FundingType 'AEB2023' and period '2324' and Delivery Organisation '00000000'
     When  I retrieve the latest contract details from CRM for provider '10018024' for FundingType 'AEB2023' and period '2324'

    # Check the contents of the Appendices
    Then  the file named '10018024_AEBP23-0024_v2.pdf' in Sharepoint location 'AEB2023-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10018024 Co Ltd UKPRN: 10018024
    Master Contract Number: ESFA-0024
    Allocation
    1 August 2023 to 31 July 2024 Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 Total
    ESFA AEB - Adult Skills (procured from Aug 2023) AEBA23-0024 £74,278 £35,456 £109,734
    of which Learner Support £25,394 £21,024 £46,418
    ESFA AEB - National Skills Fund (procured from Aug 2023) NSF23-0024 £54,031 £34,846 £88,877
    of which Free Courses for Jobs £25,884 £15,183 £41,067
    of which Learner Support £28,147 £19,663 £47,810
    ESFA AEB - Short Term Funding Initiatives (procured from
    STFI23-0024 £84,398 £42,871 £127,269
    Aug 2023)
    of which Short Term Funding Initiative 1 £37,258 £19,663 £56,921
    of which Short Term Funding Initiative 2 £17,435 £6,457 £23,892
    of which Short Term Funding Initiative 3 £14,371 £8,135 £22,506
    of which Short Term Funding Initiative 4 £15,334 £8,616 £23,950
    Total: £325,880
    Total Funding for this contract: £325,880
    Summary of Funding – Page 1
    Agreement Type Contract for Services
    st st
    Funding Period 1 August 2023 to 31 July 2024
    Between the Secretary of State for Education
    And  10018024 Co Ltd
    Funding for ESFA Adult Education Budget (Contract for Services)
    Master Contract Number ESFA-0024
    ACCEPTANCE BY THE CONTRACTOR
    BY ACCEPTING THIS CONTRACT VIA THE MANAGE YOUR EDUCATION & SKILLS
    FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF THE
    CONTRACTOR REPRESENTS AND WARRANTS THAT THE CONTRACTOR HAS READ
    AND UNDERSTOOD THIS CONTRACT, THE CONTRACTOR AGREES TO BE BOUND BY
    THIS CONTRACT AND THAT HE/SHE IS DULY AUTHORISED TO ACCEPT THIS
    CONTRACT AND LEGALLY BIND THE CONTRACTOR.
    SIGNED FOR AND ON BEHALF OF THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    ESFA Adult Education Budget (Contract for Services) Version 1 (July 2023) – Page 1
    This Contract is made on the date the Contract is digitally signed by the Contractor on
    the Manage Your Education & Skills Funding Service between:
    10018024 Co Ltd
    THE SECRETARY OF STATE FOR
    345 The Meadway
    EDUCATION
    Tilehurst
    DEPARTMENT FOR EDUCATION
    Reading
    20 GREAT SMITH STREET
    AND
    Berkshire
    LONDON
    RG30 4NU
    SW1P 3BT
    Company No: AA018024
    Hereinafter called  Hereinafter called the
    “Department”
    the “Contractor”
    ESFA Adult Education Budget (Contract for Services) Version 1 (July 2023) – Page 2
    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - Adult Skills (procured from Aug 2023)
    Provider: 10018024 Co Ltd UKPRN: 10018024
    Master Contract Number: ESFA-0024 Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: AEBA23-0024
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    ESFA AEB - Adult Skills £109,734 £14,200 £6,250 £6,419 £11,750 £7,439 £8,692 £8,660 £10,868 £12,195 £10,326 £7,980 £4,955
    of which Learner Support £46,418 £5,211 £678 £2,599 £4,787 £1,952 £4,617 £2,462 £3,088 £7,048 £5,232 £4,839 £3,905
    Total Funding £109,734 £14,200 £6,250 £6,419 £11,750 £7,439 £8,692 £8,660 £10,868 £12,195 £10,326 £7,980 £4,955
    Schedule 2 – Funding Agreement AEBA23-0024 – Page 1 Ref (for internal use only):  AEBP23-0024 v2
    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - National Skills Fund (procured from Aug 2023)
    Provider: 10018024 Co Ltd UKPRN: 10018024
    Master Contract Number: ESFA-0024 Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: NSF23-0024
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    ESFA AEB - National Skills Fund Free Courses for £88,877 £6,374 £8,287 £3,021 £10,867 £9,072 £4,890 £7,374 £4,146 £3,765 £12,363 £12,533 £6,185
    Jobs
    of which Free Courses for Jobs £41,067 £5,587 £5,130 £661 £4,006 £7,763 £714 £120 £1,903 £2,392 £4,653 £7,933 £205
    of which Learner Support £47,810 £787 £3,157 £2,360 £6,861 £1,309 £4,176 £7,254 £2,243 £1,373 £7,710 £4,600 £5,980
    Total Funding £88,877 £6,374 £8,287 £3,021 £10,867 £9,072 £4,890 £7,374 £4,146 £3,765 £12,363 £12,533 £6,185
    Schedule 2 – Funding Agreement NSF23-0024 – Page 1 Ref (for internal use only):  AEBP23-0024 v2
    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - Short Term Funding Initiatives (procured from Aug 2023)
    Provider: 10018024 Co Ltd UKPRN: 10018024
    Master Contract Number: ESFA-0024 Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: STFI23-0024
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    ESFA AEB - Short Term Funding Initiative 1 £56,921 £9,898 £3,157 £2,360 £6,861 £1,309 £4,176 £7,254 £2,243 £1,373 £7,710 £4,600 £5,980
    ESFA AEB - Short Term Funding Initiative 2 £23,892 £1,538 £1,706 £3,168 £1,498 £1,824 £2,812 £3,549 £1,340 £2,299 £1,389 £416 £2,353
    ESFA AEB - Short Term Funding Initiative 3 £22,506 £2,038 £1,950 £250 £2,631 £171 £2,869 £3,160 £1,302 £3,175 £275 £3,541 £1,144
    ESFA AEB - Short Term Funding Initiative 4 £23,950 £1,503 £3,124 £979 £2,728 £2,165 £1,888 £2,719 £228 £1,281 £2,807 £1,928 £2,600
    Total Funding £127,269 £14,977 £9,937 £6,757 £13,718 £5,469 £11,745 £16,682 £5,113 £8,128 £12,181 £10,485 £12,077
    Schedule 2 – Funding Agreement STFI23-0024 – Page 1 Ref (for internal use only):  AEBP23-0024 v2
    ESFA Adult Education Budget (Contract for Services) Schedule 3 Version 1 (July 2023) – Page 1
    ESFA Adult Education Budget (Contract for Services) Schedule 13 Version 1 (July 2023) – Page 2
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP23-0024    | 2                     | 0                        | 2023-12-02 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018024_AEBP23-0024_v2.pdf' in 'AEB2023-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018024_AEBP23-0024_v2.pdf'





    # Part 4: Publish and approve 23/24 v1 and check feed

    # Change the date
    Given the override date is '05/12/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP23-0024'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-0024' and ContractNumber 'AEBP23-0024' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP23-0024' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018024 | AEBP23-0024        | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | Variation     |
    | 10018024 | AEBP23-0024        | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018024 | ESFA-0024          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'AEBP23-0024' agree with the most recent entry for this contract in the ContractManagement feed

    ## Check the deliverable count in CRM includes all the monitoring deliverables
    #And   there are '120' deliverable period rows in CRM linked to the latest version of contract number 'AEBP23-0024'


    #    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | AEBA23-0024        | 2372010          | Jul-24 | Reconciliation |
#    | NSF23-0024         | 100942           | Jul-24 | Reconciliation |
#    | STFI23-0024        | 2374010          | Jul-24 | Reconciliation |


    ## Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    #Then  the Legal Contract CM feed contains the following '6' deliverables
    #| UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                      | DeliverableDescription   | 
    #| 10018024 | AEBP23-0024   | 1               | [AllocRef_AEBA] | 1               | 0                     | 106975.00    | 0             | 0        | Adult Skills Total Funding           | ?                        |
    #| 10018024 | AEBP23-0024   | 1               | [AllocRef_AEBA] | 4               | 1                     | 60557.00     | 0             | 0        | Adult Skills                         | ?                        |
    #| 10018024 | AEBP23-0024   | 1               | [AllocRef_AEBA] | 5               | 1                     | 46418.00     | 0             | 0        | Adult Skills Learner Support         | ?                        |
    #| 10018024 | AEBP23-0024   | 1               | [AllocRef_NSF]  | 1               | 0                     | 89738.00     | 0             | 0        | National Skills Fund Total Funding   | ?                        |
    #| 10018024 | AEBP23-0024   | 1               | [AllocRef_NSF]  | 2               | 1                     | 41067.00     | 0             | 0        | Level 3 Free Courses for Jobs        | ?                        |
    #| 10018024 | AEBP23-0024   | 1               | [AllocRef_NSF]  | 5               | 1                     | 48671.00     | 0             | 0        | National Skills Fund Learner Support | ?                        |

    ## Test CRM details against same in ContractManagement feed (30447)
    #Then  the details in CRM for version '1' of contract 'AEBP23-0024' agree with the most recent entry for this contract in the ContractManagement feed



	
    # Tidy Up
   Given the override date is reset


 @AcceptanceTest @Withdrawn20260521
 @Long2Run @Long2Run123
Scenario: AK010 AEB2023 Capping demo with 40% tolerance for FY 23/24 for alloc AEB-NSF2324
    Given there is no Contract, Task or Workflow data for UKPRN '10001010' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10001010' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NSF-0010       |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | NSF-0010       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-NSF2324       |

 #  # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
 #  And   there is no Subnominal data in CRM for the following subnominal codes
 #  | SubnominalCode |
 #  | 100937         |
 #  | 100938         |
 #  | 100939         |
 #  | 100940         |
 #  | 100941         |
 #  | 100942         |
 #  | 100943         |
 #  | 100944         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP21-0010     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10001010'

    # Set the 'base' timestamp for each of the 22/23 AEB document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_AEB2023_2023-08-01.docx                     | 2022-06-20 12:00:00.000 | 
    | AEB2023_2324_TAC_2023-08-01.docx                | 2023-06-20 12:00:00.000 | 
    | AEB2023_2324_S1_2023-08-01.docx                 | 2023-06-20 12:00:00.000 | 
    | AEB2023_2324_S2_2023-08-01.docx                 | 2023-06-20 12:00:00.000 | 
    | FA_AEB2023_2324_2023-08-01.docx                 | 2023-06-20 12:00:00.000 | 
    | AEB2022_2324_S3ON_2023-08-01.docx               | 2023-06-20 12:00:00.000 | 




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10001010' 
    And   there is no caseload advisor for UKPRN '10001010' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10001010 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10001010' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10001010 Co Ltd' with UKPRN '10001010' and OrgId 'ORG0001010' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10001010 | 101010 | 10001010 Co Ltd | 0              | Active                | Yes           | AA001010      | ?             | 111 Hagley Road        | Edgbaston              | ?                      | ?                      | Birmingham             | West Midlands          | B16 8LB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10001010 |





    # Change the date
    Given the override date is '01/07/2023'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP21-0010'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP21-0010'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10001010 | 10001010 Co Ltd      | ESFA-0001             | AEBP21-0010     | 1                     | 01/08/2023        | 31/07/2024      | 43199.00      |                                       | Contract for Services                      | 2324   | New          | ORG0001010 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription  | CRMIntent    | DeliveryOrg |
    | 10001010 | AEBP21-0010     | NSF-0010       | AEB-NSF           | AEB-NSF2324             | AY                      | 01/08/2023          | 31/07/2024        | 43199.00        |                                         |            |                        | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableDescription                | CRMIntent    | DeliveryOrg |
    | 10001010 | AEBP21-0010     | NSF-0010       | 1               | 0                     | 43199.00  | 28440.00  | 14759.00  | 4028.00  | 2022.00  | 6306.00  | 2590.00  | 3618.00  | 535.00   | 3366.00  | 5975.00  | 4567.00  | 407.00   | 5485.00  | 4300.00  | National Skills Fund Total Funding    | New          |             | 
    | 10001010 | AEBP21-0010     | NSF-0010       | 2               | 1                     | 16804.00  | 10117.00  | 6687.00   | 1027.00  | 340.00   | 3384.00  | 671.00   | 1407.00  | 182.00   | 157.00   | 2949.00  | 1976.00  | 212.00   | 1802.00  | 2697.00  | Level 3 Free Courses for Jobs         | New          |             | 
    | 10001010 | AEBP21-0010     | NSF-0010       | 5               | 1                     | 26395.00  | 18323.00  | 8072.00   | 3001.00  | 1682.00  | 2922.00  | 1919.00  | 2211.00  | 353.00   | 3209.00  | 3026.00  | 2591.00  | 195.00   | 3683.00  | 1603.00  | National Skills Fund Learner Support  | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP21-0010     | 1                     | 0                        | 2023-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-0010'





    # Publish and approve

    # Change the date
    Given the override date is '03/07/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-0010'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  contract approval messages arrive for the following contracts
    | MasterContractNumber | ContractNumber | Version |
    | ESFA-0001             | AEBP21-0010     | 1       |

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP21-0010' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001010 | AEBP21-0010         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10001010 | ESFA-0001           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    #Then  the details in CRM for version '1' of contract 'AEBP21-0010' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '120' deliverable period rows in CRM linked to the latest version of contract 'AEBP21-0010'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | NSF-0010         | 100944           | Jul-24 | Reconciliation |

    # Add actuals to the contract for AEB-NSF2324 for FY1

    # Change the date
    Given the override date is '04/04/2024'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0001010'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jul 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202308 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1732.62     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202308 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1753.25     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202308 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1424.28     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202308 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 2184.27     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202308 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 1719.45     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202308 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1165.36     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202308 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1382.58     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202309 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1037.94     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202309 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1035.19     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202309 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1800.35     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202309 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1193.56     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202309 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 2219.72     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202309 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1658.26     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202309 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1688.53     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202310 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1819.38     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202310 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 2033.75     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202310 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1304.25     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202310 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 2248.75     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202310 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 2106.59     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202310 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1280.95     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202310 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1848.58     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202311 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1670.42     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202311 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1590.11     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202311 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1547.25     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202311 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 2111.61     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202311 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 1608.04     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202311 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1909.58     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202311 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1504.35     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202312 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1356.35     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202312 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1688.23     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202312 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1288.27     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202312 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1273.02     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202312 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 1398.60     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202312 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1129.25     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202312 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1574.51     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202401 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 2048.90     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202401 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1779.56     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202401 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1573.04     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202401 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1495.61     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202401 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 1840.75     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202401 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1951.07     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202401 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1229.75     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202402 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1224.20     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202402 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1871.28     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202402 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1623.20     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202402 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1334.81     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202402 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 1557.18     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202402 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1690.33     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202402 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1774.44     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202403 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1668.38     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202403 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1807.17     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202403 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1650.79     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202403 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1924.31     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202403 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 1787.45     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202403 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1806.32     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202403 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1896.78     |
    #                                                                          
    | ILR2324        | R08                  | ORG0001010     | CM             | 202404 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1318.61     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202404 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1620.34     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202404 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1572.78     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202404 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1564.44     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202404 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 2176.97     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202404 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1773.75     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202404 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1789.61     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202405 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1645.26     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202405 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1803.06     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202405 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1902.28     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202405 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1996.15     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202405 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 1111.83     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202405 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 2007.26     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202405 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1240.43     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202406 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1441.95     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202406 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1456.12     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202406 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1891.77     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202406 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1897.21     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202406 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 2153.18     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202406 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1140.28     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202406 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1348.31     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202407 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 2163.09     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202407 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1761.52     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202407 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1809.87     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202407 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1318.26     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202407 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 1479.57     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202407 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1495.56     |
    | ILR2324        | R08                  | ORG0001010     | CM             | 202407 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1519.71     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



    # Check CRM and PaaS

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-0010     | NSF-0010            | 1               | 43199.00  | 28440.00 | 14759.00 | 4028.00  | 2022.00  | 6306.00  | 2590.00  | 3618.00  | 535.00   | 3366.00  | 5975.00  | 4567.00  | 407.00   | 5485.00  | 4300.00  | 
    | AEBP21-0010     | NSF-0010            | 2               | 16804.00  | 10117.00 | 6687.00  | 1027.00  | 340.00   | 3384.00  | 671.00   | 1407.00  | 182.00   | 157.00   | 2949.00  | 1976.00  | 212.00   | 1802.00  | 2697.00  | 
    | AEBP21-0010     | NSF-0010            | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 5               | 26395.00  | 18323.00 | 8072.00  | 3001.00  | 1682.00  | 2922.00  | 1919.00  | 2211.00  | 353.00   | 3209.00  | 3026.00  | 2591.00  | 195.00   | 3683.00  | 1603.00  | 
    | AEBP21-0010     | NSF-0010            | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-0010     | NSF-0010            | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-0010     | NSF-0010            | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-0010     | NSF-0010            | 3               | 12558.19  | 1732.62  | 1037.94  | 1819.38  | 1670.42  | 1356.35  | 2048.90  | 1224.20  | 1668.38  | ?        | ?        | ?        | ?        | 
    | AEBP21-0010     | NSF-0010            | 4               | 13558.54  | 1753.25  | 1035.19  | 2033.75  | 1590.11  | 1688.23  | 1779.56  | 1871.28  | 1807.17  | ?        | ?        | ?        | ?        | 
    | AEBP21-0010     | NSF-0010            | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-0010     | NSF-0010            | 6               | 12211.43  | 1424.28  | 1800.35  | 1304.25  | 1547.25  | 1288.27  | 1573.04  | 1623.20  | 1650.79  | ?        | ?        | ?        | ?        | 
    | AEBP21-0010     | NSF-0010            | 7               | 13765.94  | 2184.27  | 1193.56  | 2248.75  | 2111.61  | 1273.02  | 1495.61  | 1334.81  | 1924.31  | ?        | ?        | ?        | ?        | 
    | AEBP21-0010     | NSF-0010            | 8               | 14237.78  | 1719.45  | 2219.72  | 2106.59  | 1608.04  | 1398.60  | 1840.75  | 1557.18  | 1787.45  | ?        | ?        | ?        | ?        | 
    | AEBP21-0010     | NSF-0010            | 9               | 12591.12  | 1165.36  | 1658.26  | 1280.95  | 1909.58  | 1129.25  | 1951.07  | 1690.33  | 1806.32  | ?        | ?        | ?        | ?        | 
    | AEBP21-0010     | NSF-0010            | 10              | 12899.52  | 1382.58  | 1688.53  | 1848.58  | 1504.35  | 1574.51  | 1229.75  | 1774.44  | 1896.78  | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-0010     | NSF-0010            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 3               | 12558.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12558.19 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 4               | 13558.54  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13558.54 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 6               | 12211.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12211.43 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 7               | 13765.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13765.94 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 8               | 14237.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14237.78 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 9               | 12591.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12591.12 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 10              | 12899.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12899.52 | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                                                                                                £ 91822.52                
    
    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode   | Total       | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-0010     | NSF-0010            | 1               | 0           | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 2               | 0           | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 3               | -6,723.76   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-6,723.76 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 4               | -7,259.35   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-7,259.35 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 5               | 0           | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |0         | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 6               | -6,538.10   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-6,538.10 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 7               | -7,370.40   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-7,370.40 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 8               | -7,623.02   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-7,623.02 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 9               | -6,741.39   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-6,741.39 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 10              | -6,906.51   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-6,906.51 | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                                                                                                £-60538.53                                         
    
    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber  | AllocationRef        | DeliverableCode| Total      | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-0010     | NSF-0010            | 1               | 0.00       | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 2               | 0.00       | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 3               | 5,834.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5,834.43 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 4               | 6,299.19   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6,299.19 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 5               | 0          | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0        | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 6               | 5,673.33   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5,673.33 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 7               | 6,395.54   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6,395.54 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 8               | 6,614.76   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6,614.76 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 9               | 5,849.73   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5,849.73 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 10              | 5,993.01   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5,993.01 | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                                                                                                £31283.99                
 

 
    # Add actuals to the contract for AEB-NSF2324 for FY2 (FY1 unchanged)

    # Change the date
    Given the override date is '04/08/2024'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0000010'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jul 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202308 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1732.62     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202308 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1753.25     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202308 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1424.28     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202308 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 2184.27     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202308 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 1719.45     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202308 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1165.36     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202308 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1382.58     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202309 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1037.94     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202309 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1035.19     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202309 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1800.35     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202309 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1193.56     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202309 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 2219.72     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202309 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1658.26     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202309 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1688.53     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202310 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1819.38     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202310 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 2033.75     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202310 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1304.25     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202310 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 2248.75     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202310 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 2106.59     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202310 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1280.95     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202310 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1848.58     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202311 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1670.42     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202311 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1590.11     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202311 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1547.25     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202311 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 2111.61     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202311 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 1608.04     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202311 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1909.58     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202311 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1504.35     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202312 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1356.35     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202312 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1688.23     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202312 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1288.27     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202312 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1273.02     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202312 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 1398.60     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202312 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1129.25     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202312 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1574.51     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202401 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 2048.90     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202401 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1779.56     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202401 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1573.04     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202401 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1495.61     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202401 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 1840.75     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202401 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1951.07     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202401 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1229.75     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202402 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1224.20     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202402 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1871.28     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202402 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1623.20     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202402 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1334.81     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202402 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 1557.18     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202402 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1690.33     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202402 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1774.44     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202403 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1668.38     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202403 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1807.17     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202403 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1650.79     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202403 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1924.31     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202403 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 1787.45     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202403 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1806.32     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202403 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1896.78     |
    #                                                                        
    | ILR2324        | R12                  | ORG0001010     | CM             | 202404 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1318.61     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202404 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1620.34     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202404 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1572.78     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202404 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1564.44     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202404 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 2176.97     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202404 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1773.75     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202404 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1789.61     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202405 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1645.26     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202405 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1803.06     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202405 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1902.28     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202405 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1996.15     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202405 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 1111.83     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202405 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 2007.26     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202405 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1240.43     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202406 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 1441.95     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202406 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1456.12     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202406 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1891.77     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202406 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1897.21     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202406 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 2153.18     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202406 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1140.28     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202406 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1348.31     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202407 | AEB-NSF2324             | NSF-0010                  | ?          | 3               | 0            | 2163.09     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202407 | AEB-NSF2324             | NSF-0010                  | ?          | 4               | 0            | 1761.52     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202407 | AEB-NSF2324             | NSF-0010                  | ?          | 6               | 0            | 1809.87     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202407 | AEB-NSF2324             | NSF-0010                  | ?          | 7               | 0            | 1318.26     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202407 | AEB-NSF2324             | NSF-0010                  | ?          | 8               | 0            | 1479.57     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202407 | AEB-NSF2324             | NSF-0010                  | ?          | 9               | 0            | 1495.56     |
    | ILR2324        | R12                  | ORG0001010     | CM             | 202407 | AEB-NSF2324             | NSF-0010                  | ?          | 10              | 0            | 1519.71     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



    # Check CRM and PaaS

    # Check the PLANNED VALUES in CRM on the latest approved contract (Unchanged from before)
    Then  the Planned Values are calculated as follows 
    | ContractNumber  | AllocationRef       | DeliverableCode | Total     | P1-8     | P9-12    | Aug-23   | Sep-23   | Oct-23   |Nov-23   | Dec-23   |Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-0010     | NSF-0010            | 1               | 43199.00  | 28440.00 | 14759.00 | 4028.00  | 2022.00  | 6306.00  | 2590.00  | 3618.00  | 535.00   | 3366.00  | 5975.00  | 4567.00  | 407.00   | 5485.00  | 4300.00  | 
    | AEBP21-0010     | NSF-0010            | 2               | 16804.00  | 10117.00 | 6687.00  | 1027.00  | 340.00   | 3384.00  | 671.00   | 1407.00  | 182.00   | 157.00   | 2949.00  | 1976.00  | 212.00   | 1802.00  | 2697.00  | 
    | AEBP21-0010     | NSF-0010            | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 5               | 26395.00  | 18323.00 | 8072.00  | 3001.00  | 1682.00  | 2922.00  | 1919.00  | 2211.00  | 353.00   | 3209.00  | 3026.00  | 2591.00  | 195.00   | 3683.00  | 1603.00  | 
    | AEBP21-0010     | NSF-0010            | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
                        
    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber  | AllocationRef       | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   |Nov-23    | Dec-23   |Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-0010     | NSF-0010            | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-0010     | NSF-0010            | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-0010     | NSF-0010            | 3               | 19127.10  | 1732.62  | 1037.94  | 1819.38  | 1670.42  | 1356.35  | 2048.90  | 1224.20  | 1668.38  | 1318.61  | 1645.26  | 1441.95  | 2163.09  | 
    | AEBP21-0010     | NSF-0010            | 4               | 20199.58  | 1753.25  | 1035.19  | 2033.75  | 1590.11  | 1688.23  | 1779.56  | 1871.28  | 1807.17  | 1620.34  | 1803.06  | 1456.12  | 1761.52  | 
    | AEBP21-0010     | NSF-0010            | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-0010     | NSF-0010            | 6               | 19388.13  | 1424.28  | 1800.35  | 1304.25  | 1547.25  | 1288.27  | 1573.04  | 1623.20  | 1650.79  | 1572.78  | 1902.28  | 1891.77  | 1809.87  | 
    | AEBP21-0010     | NSF-0010            | 7               | 20542.00  | 2184.27  | 1193.56  | 2248.75  | 2111.61  | 1273.02  | 1495.61  | 1334.81  | 1924.31  | 1564.44  | 1996.15  | 1897.21  | 1318.26  | 
    | AEBP21-0010     | NSF-0010            | 8               | 21159.33  | 1719.45  | 2219.72  | 2106.59  | 1608.04  | 1398.60  | 1840.75  | 1557.18  | 1787.45  | 2176.97  | 1111.83  | 2153.18  | 1479.57  | 
    | AEBP21-0010     | NSF-0010            | 9               | 19007.97  | 1165.36  | 1658.26  | 1280.95  | 1909.58  | 1129.25  | 1951.07  | 1690.33  | 1806.32  | 1773.75  | 2007.26  | 1140.28  | 1495.56  | 
    | AEBP21-0010     | NSF-0010            | 10              | 18797.58  | 1382.58  | 1688.53  | 1848.58  | 1504.35  | 1574.51  | 1229.75  | 1774.44  | 1896.78  | 1789.61  | 1240.43  | 1348.31  | 1519.71  | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber  | AllocationRef       | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   |Nov-23    | Dec-23   |Jan-24    |Feb-24    | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-0010     | NSF-0010            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 3               | 25805.86  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12558.19 | 0.00     | 0.00     | 0.00     | 13292.67 | 	
    | AEBP21-0010     | NSF-0010            | 4               | 27458.93  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13558.54 | 0.00     | 0.00     | 0.00     | 13900.39 | 
    | AEBP21-0010     | NSF-0010            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 6               | 25926.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12211.43 | 0.00     | 0.00     | 0.00     | 13714.80 | 
    | AEBP21-0010     | NSF-0010            | 7               | 27912.4   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13765.94 | 0.00     | 0.00     | 0.00     | 14146.46 | 
	| AEBP21-0010     | NSF-0010            | 8               | 28781.57  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14237.78 | 0.00     | 0.00     | 0.00     | 14544.57 | 
    | AEBP21-0010     | NSF-0010            | 9               | 25749.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12591.12 | 0.00     | 0.00     | 0.00     | 13158.24 | 
    | AEBP21-0010     | NSF-0010            | 10              | 25704.09  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12899.52 | 0.00     | 0.00     | 0.00     | 12804.57 | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
     # Check the CAPPING AMOUNTS in CRM on the latest approved contract
 # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber  | AllocationRef       | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   |Nov-23    | Dec-23   |Jan-24    | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24    |
    | AEBP21-0010     | NSF-0010            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | AEBP21-0010     | NSF-0010            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | AEBP21-0010     | NSF-0010            | 3               | -16882.2  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6723.76 | 0.00     | 0.00     | 0.00     | -10158.44 | 
	| AEBP21-0010     | NSF-0010            | 4               | -17991.09 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7259.35 | 0.00     | 0.00     | 0.00     | -10731.74 | 
    | AEBP21-0010     | NSF-0010            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | AEBP21-0010     | NSF-0010            | 6               | -16828.67 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-6538.10  | 0.00     | 0.00     | 0.00     | -10290.57 | 
    | AEBP21-0010     | NSF-0010            | 7               | -18283.79 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-7370.40  | 0.00     | 0.00     | 0.00     | -10913.39 | 
    | AEBP21-0010     | NSF-0010            | 8               | -18865.1  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7623.02 | 0.00     | 0.00     | 0.00     | -11242.08 | 
    | AEBP21-0010     | NSF-0010            | 9               | -16837.95 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-6741.39  | 0.00     | 0.00     | 0.00     | -10096.56 | 
    | AEBP21-0010     | NSF-0010            | 10              | -16896.93 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6906.51 | 0.00     | 0.00     | 0.00     | -9990.42  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber   | AllocationRef       | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   |Nov-23    | Dec-23   |Jan-24    | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-0010     | NSF-0010            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 3               | 8968.66   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5834.43  | 0.00     | 0.00     | 0.00     | 3134.23  |	
    | AEBP21-0010     | NSF-0010            | 4               | 9467.84   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6299.19  | 0.00     | 0.00     | 0.00     | 3168.65  | 
    | AEBP21-0010     | NSF-0010            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-0010     | NSF-0010            | 6               | 9097.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5,673.33 | 0.00     | 0.00     | 0.00     | 3424.23  | 
    | AEBP21-0010     | NSF-0010            | 7               | 9628.61   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6395.54  | 0.00     | 0.00     | 0.00     | 3233.07  |	
    | AEBP21-0010     | NSF-0010            | 8               | 9917.25   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6614.76  | 0.00     | 0.00     | 0.00     | 3302.49  | 	
    | AEBP21-0010     | NSF-0010            | 9               | 8911.41   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5849.73  | 0.00     | 0.00     | 0.00     | 3061.68  | 
    | AEBP21-0010     | NSF-0010            | 10              | 8807.16   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5993.01  | 0.00     | 0.00     | 0.00     | 2814.15  | 


#
#    # Tidy Up
#    Given the override date is reset
#
#    # Part 8: CDA
#    
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version AK010.csv'
##
##    Then  the contracts are in the replicated CRM database as follows
##    | ContractNumber | ContractVersionNumber |
##    | [ContractNo]   | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod     | Version               | Suffix |
#    | AEB-NSF2324             | Latest Version        | AK010  |
#   
#
#    Then  a report named 'CDA Latest Version AK010.csv' is created
#	# Check the above report manually




 

 @AcceptanceTest @Withdrawn20251024
 @Long2Run @Long2Run123
Scenario: AK011 AEB2023 Capping demo with 40% tolerance for FY 23/24 for alloc AEB2023-NSF2324
    Given there is no Contract, Task or Workflow data for UKPRN '10001011' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10001011' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NSF23-0011       |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | NSF23-0011       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB2023-NSF2324       |

 #  # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
 #  And   there is no Subnominal data in CRM for the following subnominal codes
 #  | SubnominalCode |
 #  | 100937         |
 #  | 100938         |
 #  | 100939         |
 #  | 100940         |
 #  | 100941         |
 #  | 100942         |
 #  | 100943         |
 #  | 100944         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP23-0011     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10001011'

    # Set the 'base' timestamp for each of the 22/23 AEB document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_AEB2023_2023-08-01.docx                     | 2022-06-20 12:00:00.000 | 
    | AEB2023_2324_TAC_2023-08-01.docx                | 2023-06-20 12:00:00.000 | 
    | AEB2023_2324_S1_2023-08-01.docx                 | 2023-06-20 12:00:00.000 | 
    | AEB2023_2324_S2_2023-08-01.docx                 | 2023-06-20 12:00:00.000 | 
    | FA_AEB2023_2324_2023-08-01.docx                 | 2023-06-20 12:00:00.000 | 
    | AEB2023_2324_S3ON_2023-08-01.docx               | 2023-06-20 12:00:00.000 | 




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10001011' 
    And   there is no caseload advisor for UKPRN '10001011' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10001011 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10001011' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10001011 Co Ltd' with UKPRN '10001011' and OrgId 'ORG0001011' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10001011 | 101011 | 10001011 Co Ltd | 0              | Active                | Yes           | AA001011      | ?             | 111 Hagley Road        | Edgbaston              | ?                      | ?                      | Birmingham             | West Midlands          | B16 8LB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10001011 |





    # Change the date
    Given the override date is '01/07/2023'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP23-0011'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP23-0011'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10001011 | 10001011 Co Ltd      | ESFA-0011             | AEBP23-0011     | 1                     | 01/08/2023        | 31/07/2024      | 43199.00      |                                       | Contract for Services                      | 2324   | New          | ORG0001011 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef     | FundingStreamCode       | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription  | CRMIntent    | DeliveryOrg |
    | 10001011 | AEBP23-0011     | NSF23-0011       | AEB23-NSF           | AEB2023-NSF2324             | AY                      | 01/08/2023          | 31/07/2024        | 43199.00        |                                         |            |                        | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber  | AllocationRef    | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableDescription                | CRMIntent    | DeliveryOrg |
    | 10001011 | AEBP23-0011     | NSF23-0011       | 1               | 0                     | 43199.00  | 28440.00  | 14759.00  | 4028.00  | 2022.00  | 6306.00  | 2590.00  | 3618.00  | 535.00   | 3366.00  | 5975.00  | 4567.00  | 407.00   | 5485.00  | 4300.00  | NSF Free Courses for Jobs Total Funding    | New          |             | 
    | 10001011 | AEBP23-0011     | NSF23-0011       | 2               | 1                     | 16804.00  | 10117.00  | 6687.00   | 1027.00  | 340.00   | 3384.00  | 671.00   | 1407.00  | 182.00   | 157.00   | 2949.00  | 1976.00  | 212.00   | 1802.00  | 2697.00  | NSF Free Courses for Jobs                  | New          |             | 
    | 10001011 | AEBP23-0011     | NSF23-0011       | 5               | 1                     | 26395.00  | 18323.00  | 8072.00   | 3001.00  | 1682.00  | 2922.00  | 1919.00  | 2211.00  | 353.00   | 3209.00  | 3026.00  | 2591.00  | 195.00   | 3683.00  | 1603.00  | NSF Free Courses for Jobs Learner Support  | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP23-0011     | 1                     | 0                        | 2023-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP23-0011'





    # Publish and approve

    # Change the date
    Given the override date is '03/07/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP23-0011'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  contract approval messages arrive for the following contracts
    | MasterContractNumber | ContractNumber | Version |
    | ESFA-0011             | AEBP23-0011     | 1       |

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP23-0011' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10001011 | AEBP23-0011         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10001011 | ESFA-0011           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    #Then  the details in CRM for version '1' of contract 'AEBP23-0011' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '120' deliverable period rows in CRM linked to the latest version of contract 'AEBP23-0011'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | NSF23-0011         | 100944           | Jul-24 | Reconciliation |



     # Add actuals to the contract for AEB2023-NSF2324 for FY1

    # Change the date
    Given the override date is '04/04/2024'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0001011'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jul 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1732.62     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1753.25     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1424.28     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 2184.27     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 1719.45     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1165.36     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1382.58     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1037.94     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1035.19     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1800.35     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1193.56     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 2219.72     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1658.26     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1688.53     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1819.38     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 2033.75     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1304.25     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 2248.75     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 2106.59     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1280.95     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1848.58     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1670.42     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1590.11     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1547.25     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 2111.61     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 1608.04     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1909.58     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1504.35     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1356.35     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1688.23     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1288.27     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1273.02     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 1398.60     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1129.25     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1574.51     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 2048.90     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1779.56     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1573.04     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1495.61     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 1840.75     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1951.07     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1229.75     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1224.20     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1871.28     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1623.20     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1334.81     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 1557.18     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1690.33     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1774.44     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1668.38     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1807.17     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1650.79     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1924.31     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 1787.45     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1806.32     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1896.78     |
    #                                                                          
    | ILR2324        | R08                  | ORG0001011     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1318.61     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1620.34     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1572.78     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1564.44     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 2176.97     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1773.75     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1789.61     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1645.26     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1803.06     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1902.28     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1996.15     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 1111.83     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 2007.26     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1240.43     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1441.95     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1456.12     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1891.77     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1897.21     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 2153.18     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1140.28     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1348.31     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 2163.09     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1761.52     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1809.87     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1318.26     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 1479.57     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1495.56     |
    | ILR2324        | R08                  | ORG0001011     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1519.71     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



    # Check CRM and PaaS

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP23-0011     | NSF23-0011            | 1               | 43199.00  | 28440.00 | 14759.00 | 4028.00  | 2022.00  | 6306.00  | 2590.00  | 3618.00  | 535.00   | 3366.00  | 5975.00  | 4567.00  | 407.00   | 5485.00  | 4300.00  | 
    | AEBP23-0011     | NSF23-0011            | 2               | 16804.00  | 10117.00 | 6687.00  | 1027.00  | 340.00   | 3384.00  | 671.00   | 1407.00  | 182.00   | 157.00   | 2949.00  | 1976.00  | 212.00   | 1802.00  | 2697.00  | 
    | AEBP23-0011     | NSF23-0011            | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 5               | 26395.00  | 18323.00 | 8072.00  | 3001.00  | 1682.00  | 2922.00  | 1919.00  | 2211.00  | 353.00   | 3209.00  | 3026.00  | 2591.00  | 195.00   | 3683.00  | 1603.00  | 
    | AEBP23-0011     | NSF23-0011            | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP23-0011     | NSF23-0011            | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0011     | NSF23-0011            | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0011     | NSF23-0011            | 3               | 12558.19  | 1732.62  | 1037.94  | 1819.38  | 1670.42  | 1356.35  | 2048.90  | 1224.20  | 1668.38  | ?        | ?        | ?        | ?        | 
    | AEBP23-0011     | NSF23-0011            | 4               | 13558.54  | 1753.25  | 1035.19  | 2033.75  | 1590.11  | 1688.23  | 1779.56  | 1871.28  | 1807.17  | ?        | ?        | ?        | ?        | 
    | AEBP23-0011     | NSF23-0011            | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0011     | NSF23-0011            | 6               | 12211.43  | 1424.28  | 1800.35  | 1304.25  | 1547.25  | 1288.27  | 1573.04  | 1623.20  | 1650.79  | ?        | ?        | ?        | ?        | 
    | AEBP23-0011     | NSF23-0011            | 7               | 13765.94  | 2184.27  | 1193.56  | 2248.75  | 2111.61  | 1273.02  | 1495.61  | 1334.81  | 1924.31  | ?        | ?        | ?        | ?        | 
    | AEBP23-0011     | NSF23-0011            | 8               | 14237.78  | 1719.45  | 2219.72  | 2106.59  | 1608.04  | 1398.60  | 1840.75  | 1557.18  | 1787.45  | ?        | ?        | ?        | ?        | 
    | AEBP23-0011     | NSF23-0011            | 9               | 12591.12  | 1165.36  | 1658.26  | 1280.95  | 1909.58  | 1129.25  | 1951.07  | 1690.33  | 1806.32  | ?        | ?        | ?        | ?        | 
    | AEBP23-0011     | NSF23-0011            | 10              | 12899.52  | 1382.58  | 1688.53  | 1848.58  | 1504.35  | 1574.51  | 1229.75  | 1774.44  | 1896.78  | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP23-0011     | NSF23-0011            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 3               | 12558.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12558.19 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 4               | 13558.54  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13558.54 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 6               | 12211.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12211.43 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 7               | 13765.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13765.94 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 8               | 14237.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14237.78 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 9               | 12591.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12591.12 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 10              | 12899.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12899.52 | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                                                                                                £ 91822.52                
    
    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode   | Total       | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP23-0011     | NSF23-0011            | 1               | 0           | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 2               | 0           | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 3               | -6,723.76   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-6,723.76 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 4               | -7,259.35   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-7,259.35 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 5               | 0           | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |0         | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 6               | -6,538.10   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-6,538.10 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 7               | -7,370.40   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-7,370.40 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 8               | -7,623.02   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-7,623.02 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 9               | -6,741.39   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-6,741.39 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 10              | -6,906.51   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-6,906.51 | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                                                                                                £-60538.53                                         
    
    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber  | AllocationRef        | DeliverableCode| Total      | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP23-0011     | NSF23-0011            | 1               | 0.00       | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 2               | 0.00       | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 3               | 5,834.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5,834.43 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 4               | 6,299.19   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6,299.19 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 5               | 0          | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0        | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 6               | 5,673.33   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5,673.33 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 7               | 6,395.54   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6,395.54 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 8               | 6,614.76   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6,614.76 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 9               | 5,849.73   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5,849.73 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 10              | 5,993.01   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5,993.01 | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                                                                                                £31283.99                
 
  # Add actuals to the contract for AEB2023-NSF2324 for FY2 (FY1 unchanged)

    # Change the date
    Given the override date is '04/08/2024'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0000010'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jul 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1732.62     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1753.25     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1424.28     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 2184.27     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 1719.45     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1165.36     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202308 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1382.58     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1037.94     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1035.19     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1800.35     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1193.56     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 2219.72     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1658.26     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202309 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1688.53     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1819.38     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 2033.75     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1304.25     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 2248.75     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 2106.59     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1280.95     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202310 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1848.58     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1670.42     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1590.11     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1547.25     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 2111.61     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 1608.04     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1909.58     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202311 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1504.35     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1356.35     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1688.23     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1288.27     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1273.02     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 1398.60     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1129.25     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202312 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1574.51     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 2048.90     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1779.56     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1573.04     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1495.61     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 1840.75     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1951.07     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202401 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1229.75     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1224.20     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1871.28     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1623.20     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1334.81     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 1557.18     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1690.33     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202402 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1774.44     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1668.38     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1807.17     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1650.79     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1924.31     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 1787.45     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1806.32     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202403 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1896.78     |
    #                                                                        
    | ILR2324        | R12                  | ORG0001011     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1318.61     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1620.34     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1572.78     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1564.44     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 2176.97     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1773.75     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202404 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1789.61     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1645.26     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1803.06     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1902.28     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1996.15     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 1111.83     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 2007.26     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202405 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1240.43     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 1441.95     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1456.12     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1891.77     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1897.21     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 2153.18     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1140.28     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202406 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1348.31     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 3               | 0            | 2163.09     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 4               | 0            | 1761.52     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 6               | 0            | 1809.87     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 7               | 0            | 1318.26     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 8               | 0            | 1479.57     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 9               | 0            | 1495.56     |
    | ILR2324        | R12                  | ORG0001011     | CM             | 202407 | AEB2023-NSF2324             | NSF23-0011                  | ?          | 10              | 0            | 1519.71     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



    # Check CRM and PaaS

    # Check the PLANNED VALUES in CRM on the latest approved contract (Unchanged from before)
    Then  the Planned Values are calculated as follows 
    | ContractNumber  | AllocationRef       | DeliverableCode | Total     | P1-8     | P9-12    | Aug-23   | Sep-23   | Oct-23   |Nov-23   | Dec-23   |Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP23-0011     | NSF23-0011            | 1               | 43199.00  | 28440.00 | 14759.00 | 4028.00  | 2022.00  | 6306.00  | 2590.00  | 3618.00  | 535.00   | 3366.00  | 5975.00  | 4567.00  | 407.00   | 5485.00  | 4300.00  | 
    | AEBP23-0011     | NSF23-0011            | 2               | 16804.00  | 10117.00 | 6687.00  | 1027.00  | 340.00   | 3384.00  | 671.00   | 1407.00  | 182.00   | 157.00   | 2949.00  | 1976.00  | 212.00   | 1802.00  | 2697.00  | 
    | AEBP23-0011     | NSF23-0011            | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 5               | 26395.00  | 18323.00 | 8072.00  | 3001.00  | 1682.00  | 2922.00  | 1919.00  | 2211.00  | 353.00   | 3209.00  | 3026.00  | 2591.00  | 195.00   | 3683.00  | 1603.00  | 
    | AEBP23-0011     | NSF23-0011            | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
                        
    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber  | AllocationRef       | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   |Nov-23    | Dec-23   |Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP23-0011     | NSF23-0011            | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0011     | NSF23-0011            | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0011     | NSF23-0011            | 3               | 19127.10  | 1732.62  | 1037.94  | 1819.38  | 1670.42  | 1356.35  | 2048.90  | 1224.20  | 1668.38  | 1318.61  | 1645.26  | 1441.95  | 2163.09  | 
    | AEBP23-0011     | NSF23-0011            | 4               | 20199.58  | 1753.25  | 1035.19  | 2033.75  | 1590.11  | 1688.23  | 1779.56  | 1871.28  | 1807.17  | 1620.34  | 1803.06  | 1456.12  | 1761.52  | 
    | AEBP23-0011     | NSF23-0011            | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP23-0011     | NSF23-0011            | 6               | 19388.13  | 1424.28  | 1800.35  | 1304.25  | 1547.25  | 1288.27  | 1573.04  | 1623.20  | 1650.79  | 1572.78  | 1902.28  | 1891.77  | 1809.87  | 
    | AEBP23-0011     | NSF23-0011            | 7               | 20542.00  | 2184.27  | 1193.56  | 2248.75  | 2111.61  | 1273.02  | 1495.61  | 1334.81  | 1924.31  | 1564.44  | 1996.15  | 1897.21  | 1318.26  | 
    | AEBP23-0011     | NSF23-0011            | 8               | 21159.33  | 1719.45  | 2219.72  | 2106.59  | 1608.04  | 1398.60  | 1840.75  | 1557.18  | 1787.45  | 2176.97  | 1111.83  | 2153.18  | 1479.57  | 
    | AEBP23-0011     | NSF23-0011            | 9               | 19007.97  | 1165.36  | 1658.26  | 1280.95  | 1909.58  | 1129.25  | 1951.07  | 1690.33  | 1806.32  | 1773.75  | 2007.26  | 1140.28  | 1495.56  | 
    | AEBP23-0011     | NSF23-0011            | 10              | 18797.58  | 1382.58  | 1688.53  | 1848.58  | 1504.35  | 1574.51  | 1229.75  | 1774.44  | 1896.78  | 1789.61  | 1240.43  | 1348.31  | 1519.71  | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber  | AllocationRef       | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   |Nov-23    | Dec-23   |Jan-24    |Feb-24    | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP23-0011     | NSF23-0011            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 3               | 25805.86  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12558.19 | 0.00     | 0.00     | 0.00     | 13292.67 | 	
    | AEBP23-0011     | NSF23-0011            | 4               | 27458.93  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13558.54 | 0.00     | 0.00     | 0.00     | 13900.39 | 
    | AEBP23-0011     | NSF23-0011            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0011     | NSF23-0011            | 6               | 25926.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12211.43 | 0.00     | 0.00     | 0.00     | 13714.80 | 
    | AEBP23-0011     | NSF23-0011            | 7               | 27912.4   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13765.94 | 0.00     | 0.00     | 0.00     | 14146.46 | 
	| AEBP23-0011     | NSF23-0011            | 8               | 28781.57  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14237.78 | 0.00     | 0.00     | 0.00     | 14544.57 | 
    | AEBP23-0011     | NSF23-0011            | 9               | 25749.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12591.12 | 0.00     | 0.00     | 0.00     | 13158.24 | 
    | AEBP23-0011     | NSF23-0011            | 10              | 25704.09  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12899.52 | 0.00     | 0.00     | 0.00     | 12804.57 | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
     # Check the CAPPING AMOUNTS in CRM on the latest approved contract
 # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber  | AllocationRef       | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   |Nov-23    | Dec-23   |Jan-24    | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24    |
    | AEBP23-0011     | NSF23-0011            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | AEBP23-0011     | NSF23-0011            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | AEBP23-0011     | NSF23-0011            | 3               | -16882.2  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6723.76 | 0.00     | 0.00     | 0.00     | -10158.44 | 
	| AEBP23-0011     | NSF23-0011            | 4               | -17991.09 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7259.35 | 0.00     | 0.00     | 0.00     | -10731.74 | 
    | AEBP23-0011     | NSF23-0011            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | AEBP23-0011     | NSF23-0011            | 6               | -16828.67 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-6538.10  | 0.00     | 0.00     | 0.00     | -10290.57 | 
    | AEBP23-0011     | NSF23-0011            | 7               | -18283.79 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-7370.40  | 0.00     | 0.00     | 0.00     | -10913.39 | 
    | AEBP23-0011     | NSF23-0011            | 8               | -18865.1  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7623.02 | 0.00     | 0.00     | 0.00     | -11242.08 | 
    | AEBP23-0011     | NSF23-0011            | 9               | -16837.95 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |-6741.39  | 0.00     | 0.00     | 0.00     | -10096.56 | 
    | AEBP23-0011     | NSF23-0011            | 10              | -16896.93 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6906.51 | 0.00     | 0.00     | 0.00     | -9990.42  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber   | AllocationRef       | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   |Nov-23    | Dec-23   |Jan-24    | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP23-0010     | NSF23-0011            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0010     | NSF23-0011            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0010     | NSF23-0011            | 3               | 8968.66   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5834.43  | 0.00     | 0.00     | 0.00     | 3134.23  |	
    | AEBP23-0010     | NSF23-0011            | 4               | 9467.84   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6299.19  | 0.00     | 0.00     | 0.00     | 3168.65  | 
    | AEBP23-0010     | NSF23-0011            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP23-0010     | NSF23-0011            | 6               | 9097.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5,673.33 | 0.00     | 0.00     | 0.00     | 3424.23  | 
    | AEBP23-0010     | NSF23-0011            | 7               | 9628.61   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6395.54  | 0.00     | 0.00     | 0.00     | 3233.07  |	
    | AEBP23-0010     | NSF23-0011            | 8               | 9917.25   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6614.76  | 0.00     | 0.00     | 0.00     | 3302.49  | 	
    | AEBP23-0010     | NSF23-0011            | 9               | 8911.41   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5849.73  | 0.00     | 0.00     | 0.00     | 3061.68  | 
    | AEBP23-0010     | NSF23-0011            | 10              | 8807.16   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5993.01  | 0.00     | 0.00     | 0.00     | 2814.15  | 



    # Tidy Up
    Given the override date is reset



    # Part 8: CDA
    
    # Run the CDA report
    Given there is no CDA report named 'CDA Latest Version AK011.csv'
#
#    Then  the contracts are in the replicated CRM database as follows
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 1                     |

    When  the following CDA report is run
    | FundingStreamPeriod     | Version               | Suffix |
    | AEB2023-NSF2324             | Latest Version        | AK011  |
   

    Then  a report named 'CDA Latest Version AK011.csv' is created
	# Check the above report manuall