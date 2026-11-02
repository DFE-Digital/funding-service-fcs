Feature: YE2223FundingClaims

@AcceptanceTest @Withdrawn25072024
@FundingClaims
Scenario: S018 Create and approve an EDSK2223 contract with AEBC-19TRN2223, AEBC-ASCL2223, AEBC-NSF2223 and ALLBC2223 allocs. Process YearEnd Funding Claim BELOW profile
    
    # 1. Create and approve an EDSK2223 contract with all four FCR allocs. Check CRM and feed
    # 2. Populate the stub with Claim data
    # 3. Consume stub data and check CRM
    # 4. Update FCR and check CRM
    # 5. Publish FCR. Check CRM and feed
    # 6. Validate new field addition EarningsBoostValue
    
    Given there are no allocations marked as Under Termination for UKPRN '10018018' 
    And   there are no terminated or closed allocations for UKPRN '10018018' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018018' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018018' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018018' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-018      |
    | AECT-018      |
    | ALLC-018      |
    | NSFC-018      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-018      |
    | AECT-018      |
    | ALLC-018      |
    | NSFC-018      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-19TRN2223    |
    | AEBC-ASCL2223     |
    | AEBC-NSF2223      |
    | ALLBC2223         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-1018       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018018'

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Year End      | 1920   |
    | Year End      | 2021   |
    | Year End      | 2122   |
    | Year End      | 2223   |
    | Final         | 1718   |
    | Final         | 1819   |
    | Final         | 1920   |
    | Final         | 2021   |
    | Final         | 2122   |
    | Final         | 2223   |



    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10018018 |

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    Given there is no data in the Reconciliation Profiling table for UKPRN '10018018' and FundingPeriod 'AY2223'

 #  # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
 #  And   the Reconciliation Profiling table includes a row for UKPRN '10018018' and FundingPeriod 'AY2223'

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECT-018      |
    | AECA-018      |
    | NSFC-018      |
    | ALLC-018      |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018018' 
    And   there is no caseload advisor for UKPRN '10018018' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018018 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018018' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018018 Co Ltd' with UKPRN '10018018' and OrgId 'ORG0018018' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018018 | 118018 | 10018018 Co Ltd | 0              | In Administration     | Yes           | AA118018      | ?             | 7 Coventry Hill        | ?                      | ?                      | ?                      | High Wycombe           | Coventry        | HP13 6NS  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018018 |





    # Part 1: Create and approve an EDSK2223 contract with all four FCR allocs. Check CRM and feed
    
    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-1018'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-1018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType                           | Period | CRMIntent    | OrgId      |
    | 10018018 | 10018018 Co Ltd      | ESFA-1018            | EDSK-1018      | 1                     | 01/08/2022        | 31/07/2023      | 95978.00      |                       | Conditions of Funding (Grant) (HEI)    | 2223   | New          | ORG0018018 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName    | UoPCode    | AllocationDescription        | CRMIntent    | DeliveryOrg |
    | 10018018 | EDSK-1018       | AECA-018      | AEBC-ASCL         | AEBC-ASCL2223           | AY                      | 01/08/2022          | 31/07/2023        | 35651.00        |            |            |                              | New          |             |
    | 10018018 | EDSK-1018       | AECT-018      | AEBC-19TRN        | AEBC-19TRN2223          | AY                      | 01/08/2022          | 31/07/2023        | 21854.00        |            |            |                              | New          |             |
    | 10018018 | EDSK-1018       | ALLC-018      | ALLBC             | ALLBC2223               | AY                      | 01/08/2022          | 31/07/2023        | 20478.00        |            |            |                              | New          |             |
    | 10018018 | EDSK-1018       | NSFC-018      | AEBC-NSF          | AEBC-NSF2223            | AY                      | 01/08/2022          | 31/07/2023        | 17995.00        |            |            |                              | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription                              | CRMIntent    | DeliveryOrg |
    | 10018018 | EDSK-1018       | AECA-018      | 1               | 0                     | 35651.00  | 22628.00  | 13023.00  | 3026.00  | 2883.00  | 2330.00  | 3989.00  | 2710.00  | 3832.00  | 466.00   | 3392.00  | 3753.00  | 3421.00  | 2680.00  | 3169.00  | Adult Skills and Community Learning Total Funding   | New          |             | 
    | 10018018 | EDSK-1018       | AECA-018      | 2               | 1                     | 11604.00  | 8072.00   | 3532.00   | 926.00   | 585.00   | 625.00   | 506.00   | 862.00   | 3496.00  | 279.00   | 793.00   | 1969.00  | 175.00   | 121.00   | 1267.00  | Adult Skills Total Funding                          | New          |             | 
    | 10018018 | EDSK-1018       | AECA-018      | 5               | 1                     | 24047.00  | 14556.00  | 9491.00   | 2100.00  | 2298.00  | 1705.00  | 3483.00  | 1848.00  | 336.00   | 187.00   | 2599.00  | 1784.00  | 3246.00  | 2559.00  | 1902.00  | Community Learning                                  | New          |             | 
    | 10018018 | EDSK-1018       | AECT-018      | 1               | 0                     | 21854.00  | 16140.00  | 5714.00   | 2199.00  | 2935.00  | 1709.00  | 1685.00  | 775.00   | 785.00   | 2722.00  | 3330.00  | 523.00   | 2524.00  | 222.00   | 2445.00  | 19-24 Traineeships Total Funding                    | New          |             | 
    | 10018018 | EDSK-1018       | ALLC-018      | 1               | 0                     | 20478.00  | 15221.00  | 5257.00   | 2013.00  | 3288.00  | 447.00   | 3303.00  | 3120.00  | 2685.00  | 289.00   | 76.00    | 1697.00  | 536.00   | 1302.00  | 1722.00  | Total Advanced Learner Loans Bursary Funding        | New          |             | 
    | 10018018 | EDSK-1018       | NSFC-018      | 1               | 0                     | 17995.00  | 10848.00  | 7147.00   | 1736.00  | 2566.00  | 76.00    | 145.00   | 1672.00  | 1775.00  | 2447.00  | 431.00   | 2779.00  | 1173.00  | 2289.00  | 906.00   | Total 16-18 Traineeships Funding                    | New          |             | 
    | 10018018 | EDSK-1018       | NSFC-018      | 2               | 1                     | 17995.00  | 10848.00  | 7147.00   | 1736.00  | 2566.00  | 76.00    | 145.00   | 1672.00  | 1775.00  | 2447.00  | 431.00   | 2779.00  | 1173.00  | 2289.00  | 906.00   | Level 3 Offer for 24 year olds and over             | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'
    
    # Check the deliverables have all been created in CRM. Essentially a 'wait'
   #And   there are '84' deliverable period rows in CRM linked to the latest version of contract number 'EDSK-1018'
    And   there are '84' deliverable period rows in CRM linked to the latest version of contract 'EDSK-1018'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-1018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-1018' and ContractNumber 'EDSK-1018' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-1018' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018018 | EDSK-1018          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10018018 | ESFA-1018          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-1018' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '192' deliverable period rows in CRM linked to the latest version of contract number 'EDSK-1018'
    And   there are '192' deliverable period rows in CRM linked to the latest version of contract 'EDSK-1018'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECT-018        | 2355775          | Jul-23 | Reconciliation |
    | AECA-018        | 2371175          | Jul-23 | Reconciliation |
    | NSFC-018        | 100946           | Jul-23 | Reconciliation |
    | ALLC-018        | 2303975          | Jul-23 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '7' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10018018 | EDSK-1018       | 1               | AECA-018      | 1               | 0                     | 35651.00     | 0             | 0        | Adult Skills and Community Learning Total Funding               | ?                                                           |
    | 10018018 | EDSK-1018       | 1               | AECA-018      | 2               | 1                     | 11604.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
    | 10018018 | EDSK-1018       | 1               | AECA-018      | 5               | 1                     | 24047.00     | 0             | 0        | Community Learning                                              | ?                                                           |
    | 10018018 | EDSK-1018       | 1               | AECT-018      | 1               | 0                     | 21854.00     | 0             | 0        | 19-24 Traineeships Total Funding                                | ?                                                           |
    | 10018018 | EDSK-1018       | 1               | ALLC-018      | 1               | 0                     | 20478.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding                    | ?                                                           |
    | 10018018 | EDSK-1018       | 1               | NSFC-018      | 1               | 0                     | 17995.00     | 0             | 0        | Total 16-18 Traineeships Funding                                | ?                                                           |
    | 10018018 | EDSK-1018       | 1               | NSFC-018      | 2               | 1                     | 17995.00     | 0             | 0        | Level 3 Offer for 24 year olds and over                         | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-1018' agree with the most recent entry for this contract in the ContractManagement feed





    # Part 2: Populate stub with Claim data

    # Change the date
    Given the override date is '16/06/2023'

    #Set up claim data from DC for a 'Year End'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0018018     | 10018018 | 2                  | Year End   		 | AY             | 2223   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0018018     | 10018018 | 2                  | Year End  		 | AY             | 2223   | AECT-018      | AEBC-19TRN2223          |
    | ORG0018018     | 10018018 | 2                  | Year End	     	 | AY             | 2223   | AECA-018      | AEBC-ASCL2223           |
    | ORG0018018     | 10018018 | 2                  | Year End  	     | AY             | 2223   | NSFC-018      | AEBC-NSF2223            |
    | ORG0018018     | 10018018 | 2                  | Year End   		 | AY             | 2223   | ALLC-018      | ALLBC2223               |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | AECT-018      | 2               | 3300.00     | 69.96         | 6.08            | 3376.04    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | AECT-018      | 3               | 3410.00     | 53.69         | 8.14            | 3471.83    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | AECT-018      | 5               | 3139.00     | 38.17         | 14.66           | 3191.83    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | AECT-018      | 6               | 3112.00     | 50.61         | 9.72            | 3172.33    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | AECT-018      | 7               | 3130.00     | 65.97         | 6.50            | 3202.47    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | AECT-018      | 8               | 3526.00     | 58.45         | 10.86           | 3595.31    |
    #                                                                                                                                                                           £ 20009.81  
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | AECA-018      | 3               | 4019.00     | 73.38         | 5.80            | 4098.18    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | AECA-018      | 4               | 4291.00     | 69.54         | 9.50            | 4370.04    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | AECA-018      | 5               | 4148.00     | 70.28         | 5.90            | 4224.18    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | AECA-018      | 6               | 3871.00     | 71.92         | 11.81           | 3954.73    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | AECA-018      | 7               | 3853.00     | 42.54         | 12.71           | 3908.25    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | AECA-018      | 8               | 4395.00     | 49.39         | 7.12            | 4451.51    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | AECA-018      | 9               | 4013.00     | 25.00         | 5.86            | 4043.86    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | AECA-018      | 11              | 3818.00     | 34.90         | 10.91           | 3863.81    |
    #                                                                                                                                                                           £ 32914.56  
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | NSFC-018      | 3               | 2571.00     | 34.88         | 13.72           | 2619.60    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | NSFC-018      | 4               | 2743.00     | 34.43         | 5.43            | 2782.86    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | NSFC-018      | 5               | 2907.00     | 51.42         | 10.52           | 2968.94    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | NSFC-018      | 6               | 2663.00     | 51.13         | 10.30           | 2724.43    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | NSFC-018      | 7               | 2661.00     | 40.26         | 6.79            | 2708.05    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | NSFC-018      | 8               | 2716.00     | 51.75         | 7.54            | 2775.29    |
    #                                                                                                                                                                           £ 16579.17  
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | ALLC-018      | 2               | 2558.00     | 33.54         | 6.30            | 2597.84    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | ALLC-018      | 3               | 2813.00     | 30.24         | 8.55            | 2851.79    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | ALLC-018      | 4               | 2840.00     | 39.00         | 5.59            | 2884.59    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | ALLC-018      | 5               | 2514.00     | 35.52         | 12.32           | 2561.84    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | ALLC-018      | 6               | 2912.00     | 64.23         | 14.41           | 2990.64    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | ALLC-018      | 7               | 2535.00     | 43.25         | 7.44            | 2585.69    |
    | ORG0018018     | 10018018 | 2                  | Year End      | AY             | 2223   | ALLC-018      | 8               | 2873.00     | 54.26         | 8.13            | 2935.39    |
    #                                                                                                                                                                           £ 19407.78  





    # Part 3: Consume stub data and check CRM

    # Change the date
    Given the override date is '18/06/2023'

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | 2                  | 21854.00     | 20009.81     | -1844.19                    |  0.00               | -1844.19            | 20009.81         | 0.00            | 20009.81                 | Draft      |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | 2                  | 35651.00     | 32914.56     | -2736.44                    |  0.00               | -2736.44            | 32914.56         | 0.00            | 32914.56                 | Draft      |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | 2                  | 17995.00     | 16579.17     | -1415.83                    |  0.00               | -1415.83            | 16579.17         | 0.00            | 16579.17                 | Draft      |
    | 10018018 | 2223          | Year End         | ALLBC2223           | 2                  | 20478.00     | 19407.78     | -1070.22                    |  0.00               | -1070.22            | 19407.78         | 0.00            | 19407.78                 | Draft      |


    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  |ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | AECT-018      | 21854.00     | 20009.81     | -1844.19                    | 0.00                | -1844.19            | 20009.81         | 0.00            | ?                     | 20009.81                 |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | AECA-018      | 35651.00     | 32914.56     | -2736.44                    | 0.00                | -2736.44            | 32914.56         | 0.00            | ?                     | 32914.56                 |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | NSFC-018      | 17995.00     | 16579.17     | -1415.83                    | 0.00                | -1415.83            | 16579.17         | 0.00            | ?                     | 16579.17                 |
    | 10018018 | 2223          | Year End         | ALLBC2223           | ALLC-018      | 20478.00     | 19407.78     | -1070.22                    | 0.00                | -1070.22            | 19407.78         | 0.00            | ?                     | 19407.78                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | AECT-018      | AEBC-19TRN2223       | 2               | 19-24 Traineeships Programme Funding                   | 0.00         | 3376.04      |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | AECT-018      | AEBC-19TRN2223       | 3               | 19-24 Traineeships Learning Support                    | 0.00         | 3471.83      |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | AECT-018      | AEBC-19TRN2223       | 5               | 19-24 Traineeships Admin Expenditure                   | 0.00         | 3191.83      |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | AECT-018      | AEBC-19TRN2223       | 6               | 19-24 Traineeships 19+ Hardship                        | 0.00         | 3172.33      |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | AECT-018      | AEBC-19TRN2223       | 7               | 19-24 Traineeships 20+ Childcare                       | 0.00         | 3202.47      |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | AECT-018      | AEBC-19TRN2223       | 8               | 19-24 Traineeships Residential Access Funding          | 0.00         | 3595.31      |
    #
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | AECA-018      | AEBC-ASCL-2223       | 3               | Adult Skills Programme Funding                         | 0.00         | 4098.18      |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | AECA-018      | AEBC-ASCL-2223       | 4               | Adult Skills Learning Support                          | 0.00         | 4370.04      |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | AECA-018      | AEBC-ASCL-2223       | 5               | Community Learning                                     | 24047.00     | 4224.18      |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | AECA-018      | AEBC-ASCL-2223       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 3954.73      |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | AECA-018      | AEBC-ASCL-2223       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 3908.25      |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | AECA-018      | AEBC-ASCL-2223       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 4451.51      |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | AECA-018      | AEBC-ASCL-2223       | 9               | Adult Skills Administration Expenditure                | 0.00         | 4043.86      |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | AECA-018      | AEBC-ASCL-2223       | 11              | Adult Skills IT Devices and Connectivity Costs         | 0.00         | 3863.81      |
    #
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | NSFC-018      | AEBC-NSF2223         | 3               | National Skills Fund Programme Funding                 | 0.00         | 2619.60      |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | NSFC-018      | AEBC-NSF2223         | 4               | National Skills Fund Learning Support                  | 0.00         | 2782.86      |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | NSFC-018      | AEBC-NSF2223         | 5               | National Skills Fund 19+ Hardship                      | 0.00         | 2968.94      |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | NSFC-018      | AEBC-NSF2223         | 6               | National Skills Fund 20+ Childcare                     | 0.00         | 2724.43      |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | NSFC-018      | AEBC-NSF2223         | 7               | National Skills Fund Residential Access Funding        | 0.00         | 2708.05      |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | NSFC-018      | AEBC-NSF2223         | 8               | National Skills Fund Administration Expenditure        | 0.00         | 2775.29      |
    #
    | 10018018 | 2223          | Year End         | ALLBC2223           | ALLC-018      | ALLBC2223            | 2               | Loans - Bursary Funding                                | 0.00         | 2597.84      |
    | 10018018 | 2223          | Year End         | ALLBC2223           | ALLC-018      | ALLBC2223            | 3               | Loans - Area Costs                                     | 0.00         | 2851.79      |
    | 10018018 | 2223          | Year End         | ALLBC2223           | ALLC-018      | ALLBC2223            | 4               | Loans - Excess Claims                                  | 0.00         | 2884.59      |
    | 10018018 | 2223          | Year End         | ALLBC2223           | ALLC-018      | ALLBC2223            | 5               | Loans - Hardship                                       | 0.00         | 2561.84      |
    | 10018018 | 2223          | Year End         | ALLBC2223           | ALLC-018      | ALLBC2223            | 6               | Loans - Childcare                                      | 0.00         | 2990.64      |
    | 10018018 | 2223          | Year End         | ALLBC2223           | ALLC-018      | ALLBC2223            | 7               | Loans - Residential Access Fund                        | 0.00         | 2585.69      |
    | 10018018 | 2223          | Year End         | ALLBC2223           | ALLC-018      | ALLBC2223            | 8               | Loans - Administration Expenditure                     | 0.00         | 2935.39      |





    # Part 4: Update FCR and check CRM

    # Change the date 
    Given the override date is '20/06/2023'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither. In this case, only Claim adjustment ...
    # User can update the EarningsBoostValue or introduce a Claim Adjustment or both or neither.     
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | 2                  | AECT-018      | 21854.00     | 20009.81     | -1844.19                    |   0.00              | -1844.19            | 20009.81         | -410.24         | Ineligible Data       |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | 2                  | AECA-018      | 35651.00     | 32914.56     | -2736.44                    |   274.35            | -2736.44            | 32914.56         | 0.00            | ?                     |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | 2                  | NSFC-018      | 17995.00     | 16579.17     | -1415.83                    |   358.45            |  -1415.83           | 16579.17         | -358.45         | Other                 |
    | 10018018 | 2223          | Year End         | ALLBC2223           | 2                  | ALLC-018      | 20478.00     | 19407.78     | -1070.22                    |   81.34             |  -1070.22           | 19407.78         | 88.88           | Ineligible Data       |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | 2                  | 21854.00     | 20009.81     | -2254.43                    |   0.00              | -2254.43            | 20009.81         | -410.24         | 19599.57                 | Draft      |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | 2                  | 35651.00     | 32914.56     | -2736.44                    |   274.35            | -2462.09            | 32914.56         | 0.00            | 32914.56                 | Draft      |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | 2                  | 17995.00     | 16579.17     | -1774.28                    |   358.45            | -1415.83            | 16579.17         | -358.45         | 16220.72                 | Draft      |
    | 10018018 | 2223          | Year End         | ALLBC2223           | 2                  | 20478.00     | 19407.78     | -981.34                     |   81.34             | -900.00             | 19407.78         | 88.88           | 19496.66                 | Draft      |
 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | AECT-018      | 21854.00     | 20009.81     | -2254.43                    |   0.00              | -2254.43            | 20009.81         | -410.24         | Ineligible Data       | 19599.57                 |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | AECA-018      | 35651.00     | 32914.56     | -2736.44                    |   274.35            | -2462.09            | 32914.56         | 0.00            | ?                     | 32914.56                 |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | NSFC-018      | 17995.00     | 16579.17     | -1774.28                    |   358.45            | -1415.83            | 16579.17         | -358.45         | Other                 | 16220.72                 |
    | 10018018 | 2223          | Year End         | ALLBC2223           | ALLC-018      | 20478.00     | 19407.78     | -981.34                     |   81.34             | -900.00             | 19407.78         | 88.88           | Ineligible Data       | 19496.66                 |





    # Part 5: Publish FCR. Check CRM and feed

    # Change the date
    Given the override date is '22/06/2023'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2223-YearEnd' and Allocation Group Code 'ALLBC2223'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2223-YearEnd' and Allocation Group Code 'ALLBC2223'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | 2                  |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | 2                  |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | 2                  |
    | 10018018 | 2223          | Year End         | ALLBC2223           | 2                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | 2                  |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | 2                  |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | 2                  |
    | 10018018 | 2223          | Year End         | ALLBC2223           | 2                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | 2                  |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | 2                  |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | 2                  |
    | 10018018 | 2223          | Year End         | ALLBC2223           | 2                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                       | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10018018 | ALLC-018         | 2223   | Year End      | Advanced Learner Loans Bursary (Grant) 22/23              | 20478.00     | 19407.78     | -981.34                     | 81.34               | -900.00                  | 19407.78           | 88.88           | Ineligible Data       | 19496.66                 |
    | 10018018 | AECT-018         | 2223   | Year End      | AEB (Grant) - 19 to 24 Traineeships 22/23                 | 21854.00     | 20009.81     | -2254.43                    | 0.00                | -2254.43                 | 20009.81           | -410.24         | Ineligible Data       | 19599.57                 |
    | 10018018 | AECA-018         | 2223   | Year End      | AEB (Grant) - Adult Skills and Community Learning 22/23   | 35651.00     | 32914.56     | -2736.44                    | 274.35              | -2462.09                 | 32914.56           | ?               | ?                     | 32914.56                 |
    | 10018018 | NSFC-018         | 2223   | Year End      | AEB (Grant) - National Skills Fund 22/23                  | 17995.00     | 16579.17     | -1774.28                    | 358.45              | -1415.83                 | 16579.17           | -358.45         | Other                 | 16220.72                 |


    


    # Part 5: Withdraw FCR. Check CRM and feed

    # Change the date
    Given the override date is '22/07/2023'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2223-YearEnd' and Allocation Group Code 'ALLBC2223'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2223-YearEnd' and Allocation Group Code 'ALLBC2223'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Withdrawn
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | 2                  |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | 2                  |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | 2                  |
    | 10018018 | 2223          | Year End         | ALLBC2223           | 2                  |

   #Then  the following funding claim reconciliations will have a status of 'Withdrawn'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Withdrawn'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | 2                  |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | 2                  |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | 2                  |
    | 10018018 | 2223          | Year End         | ALLBC2223           | 2                  |


    # Part 6: Update FCR and check CRM

    # Change the date 
    Given the override date is '28/07/2023'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither. 
    # User can update the EarningsBoostValue or introduce a Claim Adjustment or both or neither.     
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | 2                  | AECT-018      | 21854.00     | 20009.81     | -1844.19                    |   0.00              | -1844.19            | 20009.81         | -510.24         | Ineligible Data       |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | 2                  | AECA-018      | 35651.00     | 32914.56     | -2736.44                    |   274.35            | -2736.44            | 32914.56         | 0.00            | ?                     |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | 2                  | NSFC-018      | 17995.00     | 16579.17     | -1415.83                    |   358.45            |  -1415.83           | 16579.17         | -358.45         | Other                 |
    | 10018018 | 2223          | Year End         | ALLBC2223           | 2                  | ALLC-018      | 20478.00     | 19407.78     | -1070.22                    |   81.34             |  -1070.22           | 19407.78         | 88.88           | Ineligible Data       |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | 2                  | 21854.00     | 20009.81     | -2354.43                    |   0.00              | -2354.43            | 20009.81         | -510.24         | 19599.57                 | Draft      |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | 2                  | 35651.00     | 32914.56     | -2736.44                    |   274.35            |  7462.09            | 32914.56         | 0.00            | 32914.56                 | Draft      |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | 2                  | 17995.00     | 16579.17     | -1774.28                    |   358.45            | -1415.83            | 16579.17         | -358.45         | 16220.72                 | Draft      |
    | 10018018 | 2223          | Year End         | ALLBC2223           | 2                  | 20478.00     | 19407.78     | -981.34                     |   900.00            |  0.00               | 19407.78         | 88.88           | 19496.66                 | Draft      |
 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | AECT-018      | 21854.00     | 20009.81     | -2354.43                    |   0.00              | -2354.43            | 20009.81         | -510.24         | Ineligible Data       | 19599.57                 |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | AECA-018      | 35651.00     | 32914.56     | -2736.44                    |   274.35            |  7462.09            | 32914.56         | 0.00            | ?                     | 32914.56                 |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | NSFC-018      | 17995.00     | 16579.17     | -1774.28                    |   358.45            | -1415.83            | 16579.17         | -358.45         | Other                 | 16220.72                 |
    | 10018018 | 2223          | Year End         | ALLBC2223           | ALLC-018      | 20478.00     | 19407.78     | -981.34                     |   900.00            |  0.00               | 19407.78         | 88.88           | Ineligible Data       | 19496.66                 |


    
    # Part 7: RePublish FCR. Check CRM and feed

    # Change the date
    Given the override date is '29/07/2023'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2223-YearEnd' and Allocation Group Code 'ALLBC2223'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2223-YearEnd' and Allocation Group Code 'ALLBC2223'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | 2                  |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | 2                  |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | 2                  |
    | 10018018 | 2223          | Year End         | ALLBC2223           | 2                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | 2                  |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | 2                  |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | 2                  |
    | 10018018 | 2223          | Year End         | ALLBC2223           | 2                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018018 | 2223          | Year End         | AEBC-19TRN2223      | 2                  |
    | 10018018 | 2223          | Year End         | AEBC-ASCL2223       | 2                  |
    | 10018018 | 2223          | Year End         | AEBC-NSF2223        | 2                  |
    | 10018018 | 2223          | Year End         | ALLBC2223           | 2                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                       | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10018018 | ALLC-018         | 2223   | Year End      | Advanced Learner Loans Bursary (Grant) 22/23              | 20478.00     | 19407.78     | -981.34                     | 900.00              |  0.00                    | 19407.78           | 88.88           | Ineligible Data       | 19496.66                 |
    | 10018018 | AECT-018         | 2223   | Year End      | AEB (Grant) - 19 to 24 Traineeships 22/23                 | 21854.00     | 20009.81     | -2354.43                    | 0.00                | -2354.43                 | 20009.81           | -510.24         | Ineligible Data       | 19599.57                 |
    | 10018018 | AECA-018         | 2223   | Year End      | AEB (Grant) - Adult Skills and Community Learning 22/23   | 35651.00     | 32914.56     | -2736.44                    | 274.35              |  7462.09                 | 32914.56           | ?               | ?                     | 32914.56                 |
    | 10018018 | NSFC-018         | 2223   | Year End      | AEB (Grant) - National Skills Fund 22/23                  | 17995.00     | 16579.17     | -1774.28                    | 358.45              | -1415.83                 | 16579.17           | -358.45         | Other                 | 16220.72                 |


    # Tidy up
    Given the override date is reset


   
@AcceptanceTest @Withdrawn20260521
@FundingClaims
Scenario: S019 Create and approve an EDSK2223 contract with all four FCR allocs. Process YearEnd Funding Claim ABOVE profile. Amend contract. Publish claim. Check CRM and financials. 

    # 1. Create and approve and EDSK2223 with all four FCR allocs
    # 2. Populate stub with Claim data
    # 3. Consume stub data and check CRM
    # 4. Update FCR and check CRM
    # 5. Bulk amend and approve the contract to change the Profile values and force a recalc
    # 6. Publish and Approve contract v2 and check financials
    # 7. Publish the FCR. Check CRM and feed
    # 8. Validate new field addition EarningsBoostValue

    Given there are no allocations marked as Under Termination for UKPRN '10018019' 
    And   there are no terminated or closed allocations for UKPRN '10018019' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018019' 
    And   there are no notifications in CRM of type 'Amendment Approval' for UKPRN '10018019' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018019' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-019      |
    | AECT-019      |
    | ALLC-019      |
    | NSFC-019      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-019      |
    | AECT-019      |
    | ALLC-019      |
    | NSFC-019      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-19TRN2223    |
    | AEBC-ASCL2223     |
    | AEBC-NSF2223      |
    | ALLBC2223         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-019       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018019'

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECA-019      |
    | AECT-019      |
    | ALLC-019      |
    | NSFC-019      |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Year End      | 1920   |
    | Year End      | 2021   |
    | Year End      | 2122   |
    | Year End      | 2223   |
    | Final         | 1718   |
    | Final         | 1819   |
    | Final         | 1920   |
    | Final         | 2021   |
    | Final         | 2122   |
    | Final         | 2223   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10018019 |

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    Given there is no data in the Reconciliation Profiling table for UKPRN '10018019' and FundingPeriod 'AY2223'

 #  # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
 #  And   the Reconciliation Profiling table includes a row for UKPRN '10018019' and FundingPeriod 'AY2223'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018019' 
    And   there is no caseload advisor for UKPRN '10018019' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018019 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018019' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018019 Co Ltd' with UKPRN '10018019' and OrgId 'ORG0018019' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018019 | 118019 | 10018019 Co Ltd | 0              | Active                | Yes           | AA018019      | ?             | 244 The Quardrant      | Aztec West             | Almondsbury            | Bristol                | ?                      | ?                      | BS32 4AQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018019 |





    # Part 1: Create and approve and EDSK2223 with all four FCR allocs
    
    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-019'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018019 | 10018019 Co Ltd      | ESFA-019             | EDSK-019       | 1                     | 01/08/2022        | 31/07/2023      | 110438.00     |                                       | Conditions of Funding (Grant) (LA)         | 2223   | New          | ORG0018019 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018019 | EDSK-019       | AECA-019      | AEBC-ASCL         | AEBC-ASCL2223           | AY                      | 01/08/2022          | 31/07/2023        | 43562.00        |                                         |            |                                                             | New          |             |
    | 10018019 | EDSK-019       | AECT-019      | AEBC-19TRN        | AEBC-19TRN2223          | AY                      | 01/08/2022          | 31/07/2023        | 22055.00        |                                         |            |                                                             | New          |             |
    | 10018019 | EDSK-019       | ALLC-019      | ALLBC             | ALLBC2223               | AY                      | 01/08/2022          | 31/07/2023        | 17573.00        |                                         |            |                                                             | New          |             |
    | 10018019 | EDSK-019       | NSFC-019      | AEBC-NSF          | AEBC-NSF2223            | AY                      | 01/08/2022          | 31/07/2023        | 27248.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10018019 | EDSK-019       | AECA-019      | 1               | 0                     | 43562.00  | 26542.00  | 17020.00  | 2016.00  | 2634.00  | 1764.00  | 4373.00  | 2966.00  | 2506.00  | 3884.00  | 6399.00  | 1572.00  | 5703.00  | 3662.00  | 6083.00  | Adult Skills and Community Learning Total Funding               | New          |             | 
    | 10018019 | EDSK-019       | AECA-019      | 2               | 1                     | 18053.00  | 12511.00  | 5542.00   | 1548.00  | 323.00   | 298.00   | 3090.00  | 2117.00  | 353.00   | 1944.00  | 2838.00  | 155.00   | 2537.00  | 76.00    | 2774.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10018019 | EDSK-019       | AECA-019      | 5               | 1                     | 25509.00  | 14031.00  | 11478.00  | 468.00   | 2311.00  | 1466.00  | 1283.00  | 849.00   | 2153.00  | 1940.00  | 3561.00  | 1417.00  | 3166.00  | 3586.00  | 3309.00  | Community Learning                                              | New          |             | 
    | 10018019 | EDSK-019       | AECT-019      | 1               | 0                     | 22055.00  | 12384.00  | 9671.00   | 98.00    | 325.00   | 1378.00  | 2904.00  | 3008.00  | 3680.00  | 681.00   | 310.00   | 2406.00  | 3522.00  | 1155.00  | 2588.00  | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10018019 | EDSK-019       | ALLC-019      | 1               | 0                     | 17573.00  | 11537.00  | 6036.00   | 2914.00  | 2509.00  | 1758.00  | 310.00   | 952.00   | 992.00   | 873.00   | 1229.00  | 161.00   | 3363.00  | 176.00   | 2336.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             | 
    | 10018019 | EDSK-019       | NSFC-019      | 1               | 0                     | 27248.00  | 19547.00  | 7701.00   | 1936.00  | 1882.00  | 3028.00  | 3290.00  | 3488.00  | 2895.00  | 973.00   | 2055.00  | 1526.00  | 395.00   | 2806.00  | 2974.00  | Total 16-18 Traineeships Funding                                | New          |             | 
    | 10018019 | EDSK-019       | NSFC-019      | 2               | 1                     | 27248.00  | 19547.00  | 7701.00   | 1936.00  | 1882.00  | 3028.00  | 3290.00  | 3488.00  | 2895.00  | 973.00   | 2055.00  | 1526.00  | 395.00   | 2806.00  | 2974.00  | Level 3 Offer for 24 year olds and over                         | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-019' and ContractNumber 'EDSK-019' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-019' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018019 | EDSK-019           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10018019 | ESFA-019           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-019' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '192' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '192' deliverable period rows in CRM linked to the latest version of contract 'EDSK-019'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECT-019        | 2355775          | Jul-23 | Reconciliation |
    | AECA-019        | 2371175          | Jul-23 | Reconciliation |
    | NSFC-019        | 100946           | Jul-23 | Reconciliation |
    | ALLC-019        | 2303975          | Jul-23 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '7' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10018019 | EDSK-019       | 1               | AECA-019      | 1               | 0                     | 43562.00     | 0             | 0        | Adult Skills and Community Learning Total Funding               | ?                                                           |
    | 10018019 | EDSK-019       | 1               | AECA-019      | 2               | 1                     | 18053.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
    | 10018019 | EDSK-019       | 1               | AECA-019      | 5               | 1                     | 25509.00     | 0             | 0        | Community Learning                                              | ?                                                           |
    | 10018019 | EDSK-019       | 1               | AECT-019      | 1               | 0                     | 22055.00     | 0             | 0        | 19-24 Traineeships Total Funding                                | ?                                                           |
    | 10018019 | EDSK-019       | 1               | ALLC-019      | 1               | 0                     | 17573.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding                    | ?                                                           |
    | 10018019 | EDSK-019       | 1               | NSFC-019      | 1               | 0                     | 27248.00     | 0             | 0        | Total 16-18 Traineeships Funding                                | ?                                                           |
    | 10018019 | EDSK-019       | 1               | NSFC-019      | 2               | 1                     | 27248.00     | 0             | 0        | Level 3 Offer for 24 year olds and over                         | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-019' agree with the most recent entry for this contract in the ContractManagement feed





    # Part 2: Populate stub with Claim data

    # Change the date
    Given the override date is '16/06/2023'

    #Set up claim data from SLD for a 'YearEnd'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0018019     | 10018019 | 1                  | Year End	     | AY             | 2223   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0018019     | 10018019 | 1                  | Year End    	 | AY             | 2223   | AECT-019      | AEBC-19TRN2223          |
    | ORG0018019     | 10018019 | 1                  | Year End 	 | AY             | 2223   | AECA-019      | AEBC-ASCL2223           |
    | ORG0018019     | 10018019 | 1                  | Year End 	 | AY             | 2223   | NSFC-019      | AEBC-NSF2223            |
    | ORG0018019     | 10018019 | 1                  | Year End 	 | AY             | 2223   | ALLC-019      | ALLBC2223               |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | AECT-019      | 2               | 3750.00     | 72.71         | 13.82           | 3836.53    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | AECT-019      | 3               | 4021.00     | 62.26         | 10.19           | 4093.45    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | AECT-019      | 5               | 3812.00     | 55.07         | 13.60           | 3880.67    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | AECT-019      | 6               | 3847.00     | 60.76         | 14.13           | 3921.89    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | AECT-019      | 7               | 3692.00     | 61.77         | 13.86           | 3767.63    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | AECT-019      | 8               | 3853.00     | 39.17         | 12.74           | 3904.91    |
    #                                                                                                                                                                           £ 23405.08  
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | AECA-019      | 3               | 5953.00     | 65.28         | 5.10            | 6023.38    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | AECA-019      | 4               | 5705.00     | 28.26         | 10.00           | 5743.26    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | AECA-019      | 5               | 5532.00     | 62.17         | 14.01           | 5608.18    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | AECA-019      | 6               | 6190.00     | 43.12         | 12.39           | 6245.51    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | AECA-019      | 7               | 6157.00     | 43.66         | 6.06            | 6206.72    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | AECA-019      | 8               | 5760.00     | 52.51         | 12.34           | 5824.85    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | AECA-019      | 9               | 5519.00     | 49.21         | 8.45            | 5576.66    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | AECA-019      | 11              | 5710.00     | 56.91         | 6.33            | 5773.24    |
    #                                                                                                                                                                           £ 47001.80  
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | NSFC-019      | 3               | 5069.00     | 32.81         | 5.27            | 5107.08    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | NSFC-019      | 4               | 4920.00     | 73.93         | 8.75            | 5002.68    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | NSFC-019      | 5               | 4634.00     | 34.16         | 9.82            | 4677.98    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | NSFC-019      | 6               | 5196.00     | 41.70         | 14.75           | 5252.45    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | NSFC-019      | 7               | 4689.00     | 59.38         | 11.15           | 4759.53    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | NSFC-019      | 8               | 5222.00     | 64.07         | 8.19            | 5294.26    |
    #                                                                                                                                                                           £ 30093.98  
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | ALLC-019      | 2               | 2886.00     | 38.51         | 14.60           | 2939.11    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | ALLC-019      | 3               | 2535.00     | 33.12         | 13.12           | 2581.24    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | ALLC-019      | 4               | 2693.00     | 39.49         | 8.38            | 2740.87    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | ALLC-019      | 5               | 2885.00     | 27.91         | 9.53            | 2922.44    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | ALLC-019      | 6               | 2678.00     | 30.66         | 11.10           | 2719.76    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | ALLC-019      | 7               | 2005.00     | 49.87         | 7.12            | 2689.99    |
    | ORG0018019     | 10018019 | 1                  | Year End      | AY             | 2223   | ALLC-019      | 8               | 2818.00     | 46.74         | 7.17            | 2871.91    |
    #                                                                                                                                                                           £ 19465.32  





    # Part 3: Consume stub data and check CRM

    # Change the date
    Given the override date is '18/06/2023'

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018019 | 2223          | Year End         | AEBC-19TRN2223      | 1                  | 22055.00     | 23405.08     | 1350.08                     | 0.00                | 1350.08             | 23405.08         | 0.00            | 23405.08                 | Draft      |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | 1                  | 43562.00     | 47001.80     | 3439.80                     | 0.00                | 3439.80             | 47001.80         | 0.00            | 47001.80                 | Draft      |
    | 10018019 | 2223          | Year End         | AEBC-NSF2223        | 1                  | 27248.00     | 30093.98     | 2724.80                     | 0.00                | 2724.80             | 30093.98         | 0.00            | 30093.98                 | Draft      |
    | 10018019 | 2223          | Year End         | ALLBC2223           | 1                  | 17573.00     | 19465.32     | 0.00                        | 0.00                | 0.00                | 19465.32         | 0.00            | 19465.32                 | Draft      |
 
    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018019 | 2223          | Year End         | AEBC-19TRN2223      | AECT-019      | 22055.00     | 23405.08     | 1350.08                     | 0.00                | 1350.08             | 23405.08         | 0.00            | ?                     | 23405.08                 |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | AECA-019      | 43562.00     | 47001.80     | 3439.80                     | 0.00                | 3439.80             | 47001.80         | 0.00            | ?                     | 47001.80                 |
    | 10018019 | 2223          | Year End         | AEBC-NSF2223        | NSFC-019      | 27248.00     | 30093.98     | 2724.80                     | 0.00                | 2724.80             | 30093.98         | 0.00            | ?                     | 30093.98                 |
    | 10018019 | 2223          | Year End         | ALLBC2223           | ALLC-019      | 17573.00     | 19465.32     | 0.00                        | 0.00                | 0.00                | 19465.32         | 0.00            | ?                     | 19465.32                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10018019 | 2223          | Year End         | AEBC-19TRN2223      | AECT-019      | AEBC-19TRN2223       | 2               | 19-24 Traineeships Programme Funding                   | 0.00         | 3836.53      |
    | 10018019 | 2223          | Year End         | AEBC-19TRN2223      | AECT-019      | AEBC-19TRN2223       | 3               | 19-24 Traineeships Learning Support                    | 0.00         | 4093.45      |
    | 10018019 | 2223          | Year End         | AEBC-19TRN2223      | AECT-019      | AEBC-19TRN2223       | 5               | 19-24 Traineeships Admin Expenditure                   | 0.00         | 3880.67      |
    | 10018019 | 2223          | Year End         | AEBC-19TRN2223      | AECT-019      | AEBC-19TRN2223       | 6               | 19-24 Traineeships 19+ Hardship                        | 0.00         | 3921.89      |
    | 10018019 | 2223          | Year End         | AEBC-19TRN2223      | AECT-019      | AEBC-19TRN2223       | 7               | 19-24 Traineeships 20+ Childcare                       | 0.00         | 3767.63      |
    | 10018019 | 2223          | Year End         | AEBC-19TRN2223      | AECT-019      | AEBC-19TRN2223       | 8               | 19-24 Traineeships Residential Access Funding          | 0.00         | 3904.91      |
    #
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | AECA-019      | AEBC-ASCL-2223       | 3               | Adult Skills Programme Funding                         | 0.00         | 6023.38      |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | AECA-019      | AEBC-ASCL-2223       | 4               | Adult Skills Learning Support                          | 0.00         | 5743.26      |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | AECA-019      | AEBC-ASCL-2223       | 5               | Community Learning                                     | 25509.00     | 5608.18      |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | AECA-019      | AEBC-ASCL-2223       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 6245.51      |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | AECA-019      | AEBC-ASCL-2223       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 6206.72      |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | AECA-019      | AEBC-ASCL-2223       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 5824.85      |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | AECA-019      | AEBC-ASCL-2223       | 9               | Adult Skills Administration Expenditure                | 0.00         | 5576.66      |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | AECA-019      | AEBC-ASCL-2223       | 11              | Adult Skills IT Devices and Connectivity Costs         | 0.00         | 5773.24      |
    #
    | 10018019 | 2223          | Year End         | AEBC-NSF2223        | NSFC-019      | AEBC-NSF2223         | 3               | National Skills Fund Programme Funding                 | 0.00         | 5107.08      |
    | 10018019 | 2223          | Year End         | AEBC-NSF2223        | NSFC-019      | AEBC-NSF2223         | 4               | National Skills Fund Learning Support                  | 0.00         | 5002.68      |
    | 10018019 | 2223          | Year End         | AEBC-NSF2223        | NSFC-019      | AEBC-NSF2223         | 5               | National Skills Fund 19+ Hardship                      | 0.00         | 4677.98      |
    | 10018019 | 2223          | Year End         | AEBC-NSF2223        | NSFC-019      | AEBC-NSF2223         | 6               | National Skills Fund 20+ Childcare                     | 0.00         | 5252.45      |
    | 10018019 | 2223          | Year End         | AEBC-NSF2223        | NSFC-019      | AEBC-NSF2223         | 7               | National Skills Fund Residential Access Funding        | 0.00         | 4759.53      |
    | 10018019 | 2223          | Year End         | AEBC-NSF2223        | NSFC-019      | AEBC-NSF2223         | 8               | National Skills Fund Administration Expenditure        | 0.00         | 5294.26      |
    #
    | 10018019 | 2223          | Year End         | ALLBC2223           | ALLC-019      | ALLBC2223            | 2               | Loans - Bursary Funding                                | 0.00         | 2939.11      |
    | 10018019 | 2223          | Year End         | ALLBC2223           | ALLC-019      | ALLBC2223            | 3               | Loans - Area Costs                                     | 0.00         | 2581.24      |
    | 10018019 | 2223          | Year End         | ALLBC2223           | ALLC-019      | ALLBC2223            | 4               | Loans - Excess Claims                                  | 0.00         | 2740.87      |
    | 10018019 | 2223          | Year End         | ALLBC2223           | ALLC-019      | ALLBC2223            | 5               | Loans - Hardship                                       | 0.00         | 2922.44      |
    | 10018019 | 2223          | Year End         | ALLBC2223           | ALLC-019      | ALLBC2223            | 6               | Loans - Childcare                                      | 0.00         | 2719.76      |
    | 10018019 | 2223          | Year End         | ALLBC2223           | ALLC-019      | ALLBC2223            | 7               | Loans - Residential Access Fund                        | 0.00         | 2689.99      |
    | 10018019 | 2223          | Year End         | ALLBC2223           | ALLC-019      | ALLBC2223            | 8               | Loans - Administration Expenditure                     | 0.00         | 2871.91      |





    # Part 4: Update FCR and check CRM

    # Change the date 
    Given the override date is '20/06/2023'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither. In this case, both ... 
    # User can update the EarningsBoost value or introduce a Claim Adjustment or both or neither. 

    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10018019 | 2223          | Year End         | AEBC-19TRN2223      | 1                  | AECT-019      | 22055.00     | 23405.08     | 1350.08                     | 99.86               |  -101.86            | 23405.08         | 320.22          | Claim Error           |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | 1                  | AECA-019      | 43562.00     | 47001.80     | 3439.80                     | 0.00                | 3439.80             | 47001.80         | 374.96          | Other                 |
    | 10018019 | 2223          | Year End         | AEBC-NSF2223        | 1                  | NSFC-019      | 27248.00     | 30093.98     | 2724.80                     | 292.30              | 2724.80             | 30093.98         | -292.30         | Other                 |
    | 10018019 | 2223          | Year End         | ALLBC2223           | 1                  | ALLC-019      | 17573.00     | 19465.32     | 0.00                        | 137.17              | 0.00                | 19465.32         | 0.00            | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018019 | 2223          | Year End         | AEBC-19TRN2223      | 1                  | 22055.00     | 23405.08     | 1670.30                     | 99.86               | -101.86             | 23405.08         | 320.22          | 23725.30                 | Draft      |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | 1                  | 43562.00     | 47001.80     | 3814.76                     | 0.00                | 3814.76             | 47001.80         | 374.96          | 47376.76                 | Draft      |
    | 10018019 | 2223          | Year End         | AEBC-NSF2223        | 1                  | 27248.00     | 30093.98     | 2553.68                     | 292.30              | 2845.98             | 30093.98         | -292.30         | 29801.68                 | Draft      |
    | 10018019 | 2223          | Year End         | ALLBC2223           | 1                  | 17573.00     | 19465.32     | 0.00                        | 137.17              | 137.17              | 19465.32         | 0.00            | 19465.32                 | Draft      |
 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018019 | 2223          | Year End         | AEBC-19TRN2223      | AECT-019      | 22055.00     | 23405.08     | 1670.30                     | 99.86               | -101.86             | 23405.08         | 320.22          | Claim Error           | 23725.30                 |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | AECA-019      | 43562.00     | 47001.80     | 3814.76                     | 0.00                | 3814.76             | 47001.80         | 374.96          | Other                 | 47376.76                 |
    | 10018019 | 2223          | Year End         | AEBC-NSF2223        | NSFC-019      | 27248.00     | 30093.98     | 2553.68                     | 292.30              | 2845.98             | 30093.98         | -292.30         | Other                 | 29801.68                 |
    | 10018019 | 2223          | Year End         | ALLBC2223           | ALLC-019      | 17573.00     | 19465.32     | 0.00                        | 137.17              | 137.17              | 19465.32         | 0.00            | ?                     | 19465.32                 |





    # Part 5: Bulk amend the contract to change the Profile values and force a recalc

    # Change the date
    Given the override date is '24/06/2023'

    # Bulk file to update Profile values
    And   there are no files prefixed '10018019' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 04052022084106 v3_S019' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 04052022084106 v3_S019' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 04052022084106 v3_S019' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 04052022084106 v3_S019' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 04052022084106 v3_S019.xlsx' exists in the Datafiles folder and UKPRN '10018019' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Part 6: Publish and Approve contract v2 and check financials
    
    # Change the date
    Given the override date is '25/06/2023'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-019' and ContractNumber 'EDSK-019' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-019' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018019 | EDSK-019           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | Variation     |
    | 10018019 | EDSK-019           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10018019 | ESFA-019           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'EDSK-019' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '192' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '192' deliverable period rows in CRM linked to the latest version of contract 'EDSK-019'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECT-019        | 2355775          | Jul-23 | Reconciliation |
    | AECA-019        | 2371175          | Jul-23 | Reconciliation |
    | NSFC-019        | 100946           | Jul-23 | Reconciliation |
    | ALLC-019        | 2303975          | Jul-23 | Reconciliation |


    # Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | EDSK-019       | AECA-019           | 1               | 43891.00  | 6488.00  | 1892.00  | 1522.00  | 3395.00  | 10011.00 | 3213.00  | 2897.00  | 4120.00  | 2614.00  | 2492.00  | 1708.00  | 3539.00  | 
    | EDSK-019       | AECA-019           | 2               | 23272.00  | 4433.00  | 1355.00  | 591.00   | 1707.00  | 4421.00  | 1217.00  | 1843.00  | 2852.00  | 1036.00  | 644.00   | 661.00   | 2512.00  | 
    | EDSK-019       | AECA-019           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-019       | AECA-019           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-019       | AECA-019           | 5               | 20619.00  | 2055.00  | 537.00   | 931.00   | 1688.00  | 5590.00  | 1996.00  | 1054.00  | 1268.00  | 1578.00  | 1848.00  | 1047.00  | 1027.00  | 
    | EDSK-019       | AECT-019           | 1               | 22253.00  | 1460.00  | 2709.00  | 1851.00  | 1376.00  | 2964.00  | 1087.00  | 718.00   | 1036.00  | 1983.00  | 4030.00  | 1939.00  | 1100.00  | 
    | EDSK-019       | AECT-019           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-019       | AECT-019           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-019       | ALLC-019           | 1               | 17826.00  | 1057.00  | 1654.00  | 1024.00  | 1014.00  | 1647.00  | 1314.00  | 1225.00  | 1048.00  | 2002.00  | 1043.00  | 1924.00  | 2874.00  | 
    | EDSK-019       | ALLC-019           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-019       | ALLC-019           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-019       | ALLC-019           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-019       | NSFC-019           | 1               | 26991.00  | 81.00    | 1236.00  | 3786.00  | 1185.00  | 1101.00  | 4179.00  | 1119.00  | 2249.00  | 4635.00  | 1525.00  | 2905.00  | 2990.00  | 
    | EDSK-019       | NSFC-019           | 2               | 26991.00  | 81.00    | 1236.00  | 3786.00  | 1185.00  | 1101.00  | 4179.00  | 1119.00  | 2249.00  | 4635.00  | 1525.00  | 2905.00  | 2990.00  | 
    | EDSK-019       | NSFC-019           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-019       | NSFC-019           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Jul-23   |
    | EDSK-019       | AECA-019           | 1               | 0.00     | 
    | EDSK-019       | AECA-019           | 2               | 5481.00  | 
    | EDSK-019       | AECA-019           | 3               | 0.00     | 
    | EDSK-019       | AECA-019           | 4               | 0.00     | 
    | EDSK-019       | AECA-019           | 5               | -2608.00 | 
    #
    | EDSK-019       | AECT-019           | 1               | 1686.00  | 
    | EDSK-019       | AECT-019           | 2               | 0.00     | 
    | EDSK-019       | AECT-019           | 3               | 0.00     | 
    #
    | EDSK-019       | ALLC-019           | 1               | -285.00  | 
    | EDSK-019       | ALLC-019           | 2               | 0.00     | 
    | EDSK-019       | ALLC-019           | 3               | 0.00     | 
    | EDSK-019       | ALLC-019           | 4               | 0.00     | 
    #
    | EDSK-019       | NSFC-019           | 1               | 0.00     | 
    | EDSK-019       | NSFC-019           | 2               | -273.00  | 
    | EDSK-019       | NSFC-019           | 3               | 0.00     | 
    | EDSK-019       | NSFC-019           | 4               | 0.00     | 


	# Check FCR values
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018019 | 2223          | Year End         | AEBC-19TRN2223      | 1                  | 22253.00     | 23405.08     | 1472.30                     | 99.86               | -101.86             | 23405.08         | 320.22          | 23725.30                 | Draft      |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | 1                  | 43891.00     | 47001.80     | 3485.76                     | 0.00                | 3814.76             | 47001.80         | 374.96          | 47376.76                 | Draft      |
    | 10018019 | 2223          | Year End         | AEBC-NSF2223        | 1                  | 26991.00     | 30093.98     | 2699.10                     | 292.30              | 2845.98             | 30093.98         | -292.30         | 29801.68                 | Draft      |
    | 10018019 | 2223          | Year End         | ALLBC2223           | 1                  | 17826.00     | 19465.32     | 0.00                        | 137.17              | 137.17              | 19465.32         | 0.00            | 19465.32                 | Draft      |
    




    # Part 7: Publish the FCR. Check CRM and feed

	# Change the date
    Given the override date is '25/06/2023'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2223-YearEnd' and Allocation Group Code 'AEB-LS1819'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2223-YearEnd' and Allocation Group Code 'AEBC-19TRN2223'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2223-YearEnd' and Allocation Group Code 'AEBC-ASCL2223'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2223-YearEnd' and Allocation Group Code 'AEBC-NSF2223'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2223-YearEnd' and Allocation Group Code 'ALLBC2223'


    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018019 | 2223          | Year End         | AEBC-19TRN2223      | 1                  |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | 1                  |
    | 10018019 | 2223          | Year End         | AEBC-NSF2223        | 1                  |
    | 10018019 | 2223          | Year End         | ALLBC2223           | 1                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018019 | 2223          | Year End         | AEBC-19TRN2223      | 1                  |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | 1                  |
    | 10018019 | 2223          | Year End         | AEBC-NSF2223        | 1                  |
    | 10018019 | 2223          | Year End         | ALLBC2223           | 1                  |

    And   group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue   | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018019 | 2223          | Year End         | AEBC-19TRN2223      | 1                  | 22253.00     | 23405.08     | 1472.30                     | 99.86                | -101.86             | 23405.08         | 320.22          | 23725.30                 | Published  |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | 1                  | 43891.00     | 47001.80     | 3485.76                     | 0.00                 | 3814.76             | 47001.80         | 374.96          | 47376.76                 | Published  |
    | 10018019 | 2223          | Year End         | AEBC-NSF2223        | 1                  | 26991.00     | 30093.98     | 2699.10                     | 292.30               | 2845.98             | 30093.98         | -292.30         | 29801.68                 | Published  |
    | 10018019 | 2223          | Year End         | ALLBC2223           | 1                  | 17826.00     | 19465.32     | 0.00                        | 137.17               | 137.17              | 19465.32         | 0.00            | 19465.32                 | Published  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018019 | 2223          | Year End         | AEBC-19TRN2223      | 1                  |
    | 10018019 | 2223          | Year End         | AEBC-ASCL2223       | 1                  |
    | 10018019 | 2223          | Year End         | AEBC-NSF2223        | 1                  |
    | 10018019 | 2223          | Year End         | ALLBC2223           | 1                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                       | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue   | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10018019 | AECT-019         | 2223   | Year End      | AEB (Grant) - 19 to 24 Traineeships 22/23                 | 22253.00     | 23405.08     | 1472.30                     | 99.86                | -101.86                  | 23405.08           | 320.22          | Claim Error           | 23725.30                 |
    | 10018019 | AECA-019         | 2223   | Year End      | AEB (Grant) - Adult Skills and Community Learning 22/23   | 43891.00     | 47001.80     | 3485.76                     | 0.00                 | 3814.76                  | 47001.80           | 374.96          | Other                 | 47376.76                 |
    | 10018019 | NSFC-019         | 2223   | Year End      | AEB (Grant) - National Skills Fund 22/23                  | 26991.00     | 30093.98     | 2699.10                     | 292.30               | 2845.98                  | 30093.98           | -292.30         | Other                 | 29801.68                 |
    | 10018019 | ALLC-019         | 2223   | Year End      | Advanced Learner Loans Bursary (Grant) 22/23              | 17826.00     | 19465.32     | 0.00                        | 137.17               | 137.17                   | 19465.32           | ?               | ?                     | 19465.32                 |
     

    # Tidy up
    Given the override date is reset
 
 



