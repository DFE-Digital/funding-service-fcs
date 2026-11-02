Feature: Final2425FundingClaims

@AcceptanceTest @Withdrawn20260521
@FundingClaims
Scenario: S072 Create and approve an EDSK2425 contract with ASFC-ASCL2425, ASFC-FCFJ2425 and ALLBC2425 allocs. Process Final Funding Claim BELOW profile

    # 1. Create and approve an EDSK2425 contract with all four FCR allocs. Check CRM and feed
    # 2. Populate the stub with Claim data
    # 3. Consume stub data and check CRM
    # 4. Update FCR and check CRM
    # 5. Publish FCR. Check CRM and feed
    # 6. Validate new field addition EarningsBoostValue
    
    Given there are no allocations marked as Under Termination for UKPRN '10018072' 
    And   there are no terminated or closed allocations for UKPRN '10018072' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018072' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018072' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018072' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ASCA-172      |
    | ALLC-172      |
    | ASFC-172      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ASCA-172      |
    | ALLC-172      |
    | ASFC-172      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ASFC-ASCL2425     |
    | ASFC-FCFJ2425     |
    | ALLBC2425         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-1172      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018072'

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Final         | 1718   |
    | Final         | 1819   |
    | Final         | 1920   |
    | Final         | 2021   |
    | Final         | 2122   |
    | Final         | 2425   |
    | Final         | 1718   |
    | Final         | 1819   |
    | Final         | 1920   |
    | Final         | 2021   |
    | Final         | 2122   |
    | Final         | 2425   |



    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10018072 |

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    Given there is no data in the Reconciliation Profiling table for UKPRN '10018072' and FundingPeriod 'AY2425'

 #  # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
 #  And   the Reconciliation Profiling table includes a row for UKPRN '10018072' and FundingPeriod 'AY2425'

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | ASCA-172      |
    | ASFC-172      |
    | ALLC-172      |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018072' 
    And   there is no caseload advisor for UKPRN '10018072' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018072 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018072' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018072 Co Ltd' with UKPRN '10018072' and OrgId 'ORG0018072' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018072 | 100072 | 10018072 Co Ltd | 0              | In Administration     | Yes           | AA110072      | ?             | 7 Coventry Hill        | ?                      | ?                      | ?                      | Huddersfield           | Yorkshire        		 | HP13 6NS  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018072 |





    # Part 1: Create and approve an EDSK2425 contract with all four FCR allocs. Check CRM and feed
    
    # Change the date
    Given the override date is '01/07/2024'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-1172'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-1172'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType                           | Period | CRMIntent    | OrgId      |
    | 10018072 | 10018072 Co Ltd      | ESFA-1172            | EDSK-1172      | 1                     | 01/08/2024        | 31/07/2025      | 95978.00      |                       | Conditions of Funding (Grant) (HEI)    | 2425   | New          | ORG0018072 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName    | UoPCode    | AllocationDescription        | CRMIntent    | DeliveryOrg |
    | 10018072 | EDSK-1172       | ASCA-172      | ASFC-ASCL         | ASFC-ASCL2425           | AY                      | 01/08/2024          | 31/07/2025        | 35651.00        |            |            |                              | New          |             |
    | 10018072 | EDSK-1172       | ALLC-172      | ALLBC             | ALLBC2425               | AY                      | 01/08/2024          | 31/07/2025        | 20478.00        |            |            |                              | New          |             |
    | 10018072 | EDSK-1172       | ASFC-172      | ASFC-FCFJ         | ASFC-FCFJ2425           | AY                      | 01/08/2024          | 31/07/2025        | 17995.00        |            |            |                              | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber  | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableDescription                              | CRMIntent    | DeliveryOrg |
    | 10018072 | EDSK-1172       | ASCA-172      | 1               | 0                     | 35651.00  | 22628.00  | 13023.00  | 3026.00  | 2883.00  | 2330.00  | 3989.00  | 2710.00  | 3832.00  | 466.00   | 3392.00  | 3753.00  | 3421.00  | 2680.00  | 3169.00  | Adult Skills Fund (Grant) Total Funding             | New          |             | 
    | 10018072 | EDSK-1172       | ASCA-172      | 2               | 1                     | 11604.00  | 8072.00   | 3532.00   | 926.00   | 585.00   | 625.00   | 506.00   | 862.00   | 3496.00  | 279.00   | 793.00   | 1969.00  | 175.00   | 121.00   | 1267.00  | Adult Skills Total Funding                          | New          |             | 
    | 10018072 | EDSK-1172       | ASCA-172      | 5               | 1                     | 24047.00  | 14556.00  | 9491.00   | 2100.00  | 2298.00  | 1705.00  | 3483.00  | 1848.00  | 336.00   | 187.00   | 2599.00  | 1784.00  | 3246.00  | 2559.00  | 1902.00  | Tailored Learning                                   | New          |             | 
    | 10018072 | EDSK-1172       | ALLC-172      | 1               | 0                     | 20478.00  | 15221.00  | 5257.00   | 2013.00  | 3288.00  | 447.00   | 3303.00  | 3120.00  | 2685.00  | 289.00   | 76.00    | 1697.00  | 536.00   | 1302.00  | 1722.00  | Total Advanced Learner Loans Bursary Funding        | New          |             | 
    | 10018072 | EDSK-1172       | ASFC-172      | 1               | 0                     | 17995.00  | 10848.00  | 7147.00   | 1736.00  | 2566.00  | 76.00    | 145.00   | 1672.00  | 1775.00  | 2447.00  | 431.00   | 2779.00  | 1173.00  | 2289.00  | 906.00   | NSF Free Courses for Jobs Total Funding             | New          |             | 
    | 10018072 | EDSK-1172       | ASFC-172      | 2               | 1                     | 17995.00  | 10848.00  | 7147.00   | 1736.00  | 2566.00  | 76.00    | 145.00   | 1672.00  | 1775.00  | 2447.00  | 431.00   | 2779.00  | 1173.00  | 2289.00  | 906.00   | NSF Free Courses for Jobs                           | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'
    
    # Check the deliverables have all been created in CRM. Essentially a 'wait'
   #And   there are '84' deliverable period rows in CRM linked to the latest version of contract number 'EDSK-1172'
   #And   there are '84' deliverable period rows in CRM linked to the latest version of contract 'EDSK-1172'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-1172'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-1172' and ContractNumber 'EDSK-1172' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-1172' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018072 | EDSK-1172          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10018072 | ESFA-1172          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-1172' agree with the most recent entry for this contract in the ContractManagement feed

   # # Check the deliverable count in CRM includes all the monitoring deliverables
   ##And   there are '192' deliverable period rows in CRM linked to the latest version of contract number 'EDSK-1172'
   #And   there are '192' deliverable period rows in CRM linked to the latest version of contract 'EDSK-1172'

    # Check that the CRM subnominals have been created before moving on
    #And   CRM subnominals have been created for the following allocations
    #| AllocationRef   | Subnominal Code  | Period | Payment Type   |
    #| ASCA-172        | 2371175          | Jul-25 | Reconciliation |
    #| ASFC-172        | 100946           | Jul-25 | Reconciliation |
    #| ALLC-172        | 2303975          | Jul-25 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    #Then  the Legal Contract CM feed contains the following '7' deliverables
    #| UKPRN    | ContractNumber  | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    #| 10018072 | EDSK-1172       | 1               | ASCA-172      | 1               | 0                     | 35651.00     | 0             | 0        | Adult Skills and Community Learning Total Funding               | ?                                                           |
    #| 10018072 | EDSK-1172       | 1               | ASCA-172      | 2               | 1                     | 11604.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
    #| 10018072 | EDSK-1172       | 1               | ASCA-172      | 5               | 1                     | 24047.00     | 0             | 0        | Community Learning                                              | ?                                                           |
    #| 10018072 | EDSK-1172       | 1               | ALLC-172      | 1               | 0                     | 20478.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding                    | ?                                                           |
    #| 10018072 | EDSK-1172       | 1               | ASFC-172      | 1               | 0                     | 17995.00     | 0             | 0        | Total 16-18 Traineeships Funding                                | ?                                                           |
    #| 10018072 | EDSK-1172       | 1               | ASFC-172      | 2               | 1                     | 17995.00     | 0             | 0        | Level 3 Offer for 24 year olds and over                         | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    #Then  the details in CRM for version '1' of contract 'EDSK-1172' agree with the most recent entry for this contract in the ContractManagement feed
 
 
 
 # Part 2: Populate stub with Claim data

 # Change the date
 Given the override date is '16/07/2024'

 #Set up claim data from DC for a 'Final'
#And   funding claim data is present in the DEDS stub as follows
 And   funding claim data is present in the funding claim stub as follows
 | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
 | ORG0018072     | 10018072 | 1                  | Final   	  | AY             | 2425   | False         |

#And   allocation data is present in the DEDS stub as follows 
 And   allocation data is present in the funding claim stub as follows 
 | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
 | ORG0018072     | 10018072 | 1                  | Final	     | AY             | 2425   | ASCA-172      | ASFC-ASCL2425           |
 | ORG0018072     | 10018072 | 1                  | Final  	     | AY             | 2425   | ASFC-172      | ASFC-FCFJ2425           |
 | ORG0018072     | 10018072 | 1                  | Final        | AY             | 2425   | ALLC-172      | ALLBC2425               |

#And   deliverable data is present in the DEDS stub as follows
#totalvalue=(ActualValue+ForecastValue+ AdjustmentValue)
 And   deliverable data is present in the funding claim stub as follows
 | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
 | ORG0018072     | 10018072 | 1                  | Final         | AY             | 2425   | ASCA-172      | 3               | 4019.00     | 73.38         | 5.80            | 4098.18    |
 | ORG0018072     | 10018072 | 1                  | Final         | AY             | 2425   | ASCA-172      | 4               | 4291.00     | 69.54         | 9.50            | 4370.04    |
 | ORG0018072     | 10018072 | 1                  | Final         | AY             | 2425   | ASCA-172      | 5               | 4148.00     | 70.28         | 5.90            | 4224.18    |
 | ORG0018072     | 10018072 | 1                  | Final         | AY             | 2425   | ASCA-172      | 12              | 3818.00     | 34.90         | 10.91           | 3863.81    |
 #                                                                                                                                                                              £ 32914.56  
 | ORG0018072     | 10018072 | 1                  | Final         | AY             | 2425   | ASFC-172      | 3               | 2571.00     | 34.88         | 13.72           | 2619.60    |
 | ORG0018072     | 10018072 | 1                  | Final         | AY             | 2425   | ASFC-172      | 4               | 2743.00     | 34.43         | 5.43            | 2782.86    |
 #                                                                                                                                                                              £ 16579.17  
 | ORG0018072     | 10018072 | 1                  | Final         | AY             | 2425   | ALLC-172      | 2               | 2558.00     | 33.54         | 6.30            | 2597.84    |
 | ORG0018072     | 10018072 | 1                  | Final         | AY             | 2425   | ALLC-172      | 3               | 2813.00     | 30.24         | 8.55            | 2851.79    |
 | ORG0018072     | 10018072 | 1                  | Final         | AY             | 2425   | ALLC-172      | 4               | 2840.00     | 39.00         | 5.59            | 2884.59    |
 #                                                                                                                                                                           £ 19407.78  
#
#
 # Part 3: Consume stub data and check CRM

 # Change the date
 Given the override date is '18/07/2025'

 # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
#When  data is retrieved from the DEDS stub and is consumed
 When  data is retrieved from the SLD stub and is consumed

 # Check the details in CRM
 #claimedvalue = totalvalue=(ActualValue+ForecastValue+ AdjustmentValue)
 #ProposedReconciliationValue=(PlannedValue - ClaimedValue)

 Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
 | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
 | 10018072 | 2425          | Final            | ASFC-ASCL2425       | 1                  | 35651.00     | 16556.21    | -22958.60                    |  0.00               | -22958.60           | 12692.40        | 0.00            | 12692.40                | Draft        |
 | 10018072 | 2425          | Final            | ASFC-FCFJ2425       | 1                  | 17995.00     | 5402.46     | -12592.54                    |  0.00               | -12592.54           | 5402.46         | 0.00            | 5402.46                 | Draft        |
 | 10018072 | 2425          | Final            | ALLBC2425           | 1                  | 20478.00     | 8334.22     | -12143.78                    |  0.00               | -12143.78           | 8334.22         | 0.00            | 8334.22                 | Draft        |


 # FCR Allocation 
 And   allocation data is present in the CRM funding claim reconciliation tables as follows 
 | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  |ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
 | 10018072 | 2425          | Final            | ASFC-ASCL2425       | ASCA-172      | 35651.00     | 16556.21     | -22958.60                    | 0.00                | -22958.60            | 12692.40        | 0.00            | ?                     | 12692.40                |
 | 10018072 | 2425          | Final            | ASFC-FCFJ2425       | ASFC-172      | 17995.00     | 5402.46      | -12592.54                    | 0.00                | -12592.54            | 5402.46         | 0.00            | ?                     | 5402.46                 |
 | 10018072 | 2425          | Final            | ALLBC2425           | ALLC-172      | 20478.00     | 8334.22      | -12143.78                    | 0.00                | -12143.78            | 8334.22         | 0.00            | ?                     | 8334.22                 |

 # FCR Allocation Deliverable
 And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
 | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
 | 10018072 | 2425          | Final         | ASFC-ASCL2425       | ASCA-172      | ASFC-ASCL-2425       | 3               | Adult Skills Programme Funding                            | 0.00         | 4098.18      |
 | 10018072 | 2425          | Final         | ASFC-ASCL2425       | ASCA-172      | ASFC-ASCL-2425       | 4               | Adult Skills Learning Support                             | 0.00         | 4370.04      |
 | 10018072 | 2425          | Final         | ASFC-ASCL2425       | ASCA-172      | ASFC-ASCL-2425       | 5               | Tailored Learning                                        | 24047.00     | 4224.18      |
 | 10018072 | 2425          | Final         | ASFC-ASCL2425       | ASCA-172      | ASFC-ASCL-2425       | 12              | Funding for Innovative Provision                          | 0.00         | 3863.81      |
 #                                                                                                                                                                                     
 | 10018072 | 2425          | Final         | ASFC-FCFJ2425        | ASFC-172      | ASFC-FCFJ2425         | 3               | NSF Free Courses for Jobs Programme Funding                    | 0.00         | 2619.60      |
 | 10018072 | 2425          | Final         | ASFC-FCFJ2425        | ASFC-172      | ASFC-FCFJ2425         | 4               | NSF Free Courses for Jobs Learning Support                     | 0.00         | 2782.86      |
 #                                                                                                                                                                                     
 | 10018072 | 2425          | Final         | ALLBC2425           | ALLC-172      | ALLBC2425            | 2               | Loans - Bursary Funding                                   | 0.00         | 2597.84      |
 | 10018072 | 2425          | Final         | ALLBC2425           | ALLC-172      | ALLBC2425            | 3               | Loans - Area Costs                                        | 0.00         | 2851.79      |
 | 10018072 | 2425          | Final         | ALLBC2425           | ALLC-172      | ALLBC2425            | 4               | Loans - Excess Claims                                     | 0.00         | 2884.59      |


 

#    # Part 4: Update FCR and check CRM
#
    # Change the date 
    Given the override date is '20/07/2025'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither. In this case, only Claim adjustment ...
    # User can update the EarningsBoostValue or introduce a Claim Adjustment or both or neither.     
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10018072 | 2425          | Final            | ASFC-ASCL2425       | 1                  | ASCA-172      | 35651.00     | 16556.21     | -22,958.60                  |   274.35            | -2736.44            | 12,692.40        | 0.00            | ?                     |
    | 10018072 | 2425          | Final            | ASFC-FCFJ2425       | 1                  | ASFC-172      | 17995.00     | 5402.46      | -12,950.99                  |   358.45            |  -1415.83           | 5,402.46         | 358.45          | Other                 |
    | 10018072 | 2425          | Final            | ALLBC2425           | 1                  | ALLC-172      | 20478.00     | 8334.22      | -12,054.90                  |   81.34             |  -1070.22           | 8,334.22         | 88.88           | Ineligible Data       |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018072 | 2425          | Final         | ASFC-ASCL2425       | 1                     | 35651.00     | 16556.21     |  -22,958.60                 |   274.35            | -2736.44             | 12,692.40         | 0.00            | 12,692.40                | Draft      |
    | 10018072 | 2425          | Final         | ASFC-FCFJ2425       | 1                     | 17995.00     | 5402.46      |  -12,234.09                 |   358.45            |  -1415.83            | 5,402.46          | 358.45          | 5,760.91                 | Draft      |
    | 10018072 | 2425          | Final         | ALLBC2425           | 1                     | 20478.00     | 8334.22      |  -12,054.90                 |   81.34             |  -1070.22            | 8,334.22          | 88.88           | 8,423.10                 | Draft      |
 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018072 | 2425          | Final         | ASFC-ASCL2425       | ASCA-172      | 35651.00     |  16556.21     | -22,958.60                    |   274.35            | -2736.44             | 12,692.40         | 0.00            | ?                     |  12,692.40                 |
    | 10018072 | 2425          | Final         | ASFC-FCFJ2425       | ASFC-172      | 17995.00     |  5402.46      | -12,234.09                    |   358.45            |  -1415.83            | 5,402.46          | 358.45         | Other                 |  5,760.91                |
    | 10018072 | 2425          | Final         | ALLBC2425           | ALLC-172      | 20478.00     |  8334.22      | -12,054.90                    |   81.34             |  -1070.22            | 8,334.22          | 88.88           | Ineligible Data       |  8,423.10                 |





#    # Part 5: Publish FCR. Check CRM and feed
#
#    # Change the date
    Given the override date is '22/07/2025'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2425-Final' and Allocation Group Code 'ALLBC2425'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2425-Final' and Allocation Group Code 'ALLBC2425'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2425-Final' and Allocation Group Code 'ASFC-ASCL2425'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2425-Final' and Allocation Group Code 'ASFC-FCFJ2425'


    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018072 | 2425          | Final         | ASFC-ASCL2425       | 1                  |
    | 10018072 | 2425          | Final         | ASFC-FCFJ2425       | 1                  |
    | 10018072 | 2425          | Final         | ALLBC2425           | 1                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018072 | 2425          | Final         | ASFC-ASCL2425       | 1                  |
    | 10018072 | 2425          | Final         | ASFC-FCFJ2425       | 1                  |
    | 10018072 | 2425          | Final         | ALLBC2425           | 1                  |

     #Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018072 | 2425          | Final         | ASFC-ASCL2425       | 1                  |
    | 10018072 | 2425          | Final         | ASFC-FCFJ2425       | 1                  |
    | 10018072 | 2425          | Final         | ALLBC2425           | 1                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                       | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10018072 | ALLC-172         | 2425   | Final         | Advanced Learner Loans Bursary (Grant) 24/25              | 20478.00     |  8334.22     | -12,054.90                  |   81.34             |  -1070.22                | 8,334.22           | 88.88           | Ineligible Data         |  8,423.10                 |
    | 10018072 | ASCA-172         | 2425   | Final         | Adult Skills Fund (Grant) 24/25                           | 35651.00     |  16556.21    | -22,958.60                  |   274.35            | -2736.44                 | 12,692.40          |     ?           | ?                       |  12,692.40               |
    | 10018072 | ASFC-172         | 2425   | Final         | Adult Skills Fund (Grant) - Free Courses for Jobs 24/25   | 17995.00     |  5402.46     | -12,234.09                  |   358.45            |  -1415.83                | 5,402.46           | 358.45          | Other                   |  5,760.91                 |


#    And wait '20' seconds
#
#    # Check the RECONCILIATION subnominal aggregations in CRM
#    And   the Reconciliation Subnominal Amounts are calculated as follows
#    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-24    | Sep-24    | Oct-24    | Nov-24    | Dec-24    | Jan-25    | Feb-25    | Mar-25   | Apr-25    | May-25    | Jun-25    | Jul-25       | 
#    | 10018072 | EDSK-1172      | ASCA-172           | 2371175                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      |0.00       | 0.00      | 0.00     | 0.00      | 0.00      | 0.00      | -2736.44     |  
#    | 10018072 | EDSK-1172      | ALLC-172           | 2303975                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      |0.00       | 0.00      | 0.00     | 0.00      | 0.00      | 0.00      | -1070.22     |  
#    | 10018072 | EDSK-1172      | ASFC-172           | 100946                   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      |0.00       | 0.00      | 0.00     | 0.00      | 0.00      | 0.00      | -1415.83     |  
#
#    And wait '10' seconds


    # Tidy up
    Given the override date is reset

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    And   there is no data in the Reconciliation Profiling table for UKPRN '10018072' and FundingPeriod 'AY2425'
#
#

@AcceptanceTest @Withdrawn20260521
@FundingClaims
Scenario: S073 Create and approve an EDSK2425 contract with all four FCR allocs. Process YearEnd Funding Claim ABOVE profile. Amend contract. Publish claim. Check CRM and financials. 

    # 1. Create and approve and EDSK2425 with all four FCR allocs
    # 2. Populate stub with Claim data
    # 3. Consume stub data and check CRM
    # 4. Update FCR and check CRM
    # 5. Bulk amend and approve the contract to change the Profile values and force a recalc
    # 6. Publish and Approve contract v2 and check financials
    # 7. Publish the FCR. Check CRM and feed
    # 8. Validate new field addition EarningsBoostValue

    Given there are no allocations marked as Under Termination for UKPRN '10018073' 
    And   there are no terminated or closed allocations for UKPRN '10018073' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018073' 
    And   there are no notifications in CRM of type 'Amendment Approval' for UKPRN '10018073' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018073' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ASCA-173      |
    | ALLC-173      |
    | ASFC-173      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ASCA-173      |
    | ALLC-173      |
    | ASFC-173      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ASFC-ASCL2425     |
    | ASFC-FCFJ2425     |
    | ALLBC2425         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-1173      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018073'

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | ASCA-173      |
    | ALLC-173      |
    | ASFC-173      |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Year End      | 1920   |
    | Year End      | 2021   |
    | Year End      | 2122   |
    | Year End      | 2425   |
    | Final         | 1718   |
    | Final         | 1819   |
    | Final         | 1920   |
    | Final         | 2021   |
    | Final         | 2122   |
    | Final         | 2425   |
    | Final         | 2425   |


    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10018073 |

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    Given there is no data in the Reconciliation Profiling table for UKPRN '10018073' and FundingPeriod 'AY2425'

 #  # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
 #  And   the Reconciliation Profiling table includes a row for UKPRN '10018073' and FundingPeriod 'AY2425'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018073' 
    And   there is no caseload advisor for UKPRN '10018073' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018073 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018073' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018073 Co Ltd' with UKPRN '10018073' and OrgId 'ORG0018073' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018073 | 180073 | 10018073 Co Ltd | 0              | Active                | Yes           | AA018073      | ?             | 244 The Quardrant      | Aztec West             | Almondsbury            | Bristol                | ?                      | ?                      | BS32 4AQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018073 |





    # Part 1: Create and approve and EDSK2425 with all four FCR allocs
    
    # Change the date
    Given the override date is '01/07/2024'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-1173'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-1173'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018073 | 10018073 Co Ltd      | ESFA-1173            | EDSK-1173      | 1                     | 01/08/2024        | 31/07/2025      | 112438.00     |                                       | Conditions of Funding (Grant) (LA)         | 2425   | New          | ORG0018073 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018073 | EDSK-1173       | ASCA-173      | ASFC-ASCL         | ASFC-ASCL2425           | AY                      | 01/08/2024          | 31/07/2025        | 45562.00        |                                         |            |                                                             | New          |             |
    | 10018073 | EDSK-1173       | ALLC-173      | ALLBC             | ALLBC2425               | AY                      | 01/08/2024          | 31/07/2025        | 17573.00        |                                         |            |                                                             | New          |             |
    | 10018073 | EDSK-1173       | ASFC-173      | ASFC-FCFJ         | ASFC-FCFJ2425           | AY                      | 01/08/2024          | 31/07/2025        | 27248.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber  | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10018073 | EDSK-1173       | ASCA-173      | 1               | 0                     | 45562.00  | 27542.00  | 18020.00  | 3016.00  | 2634.00  | 1764.00  | 4373.00  | 2966.00  | 2506.00  | 3884.00  | 6399.00  | 1572.00  | 5703.00  | 4662.00  | 6083.00  | Adult Skills Fund (Grant) Total Funding                         | New          |             | 
    | 10018073 | EDSK-1173       | ASCA-173      | 2               | 1                     | 18053.00  | 12511.00  | 5542.00   | 1548.00  | 323.00   | 298.00   | 3090.00  | 2117.00  | 353.00   | 1944.00  | 2838.00  | 155.00   | 2537.00  | 76.00    | 2774.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10018073 | EDSK-1173       | ASCA-173      | 5               | 1                     | 25509.00  | 14031.00  | 11478.00  | 468.00   | 2311.00  | 1466.00  | 1283.00  | 849.00   | 2153.00  | 1940.00  | 3561.00  | 1417.00  | 3166.00  | 3586.00  | 3309.00  | Tailored Learning                                               | New          |             | 
    | 10018073 | EDSK-1173       | ASCA-173      | 12              | 1                     | 2000.00   | 1000.00   | 1000.00   | 1000.00  | 0.00     | 0.00  	| 0.00     | 0.00  	  | 0.00   	 | 0.00   	| 0.00     | 0.00     | 0.00  	 | 1000.00  | 0.00     | Funding for Innovative Provision                    			 | New          |             | 
    | 10018073 | EDSK-1173       | ALLC-173      | 1               | 0                     | 17573.00  | 11537.00  | 6036.00   | 2914.00  | 2509.00  | 1758.00  | 310.00   | 952.00   | 992.00   | 873.00   | 1229.00  | 161.00   | 3363.00  | 176.00   | 2336.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             | 
    | 10018073 | EDSK-1173       | ASFC-173      | 1               | 0                     | 27248.00  | 19547.00  | 7701.00   | 1936.00  | 1882.00  | 3028.00  | 3290.00  | 3488.00  | 2895.00  | 973.00   | 2055.00  | 1526.00  | 395.00   | 2806.00  | 2974.00  | NSF Free Courses for Jobs Total Funding                         | New          |             | 
    | 10018073 | EDSK-1173       | ASFC-173      | 2               | 1                     | 27248.00  | 19547.00  | 7701.00   | 1936.00  | 1882.00  | 3028.00  | 3290.00  | 3488.00  | 2895.00  | 973.00   | 2055.00  | 1526.00  | 395.00   | 2806.00  | 2974.00  | NSF Free Courses for Jobs                                       | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'


    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-1173'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-1173' and ContractNumber 'EDSK-1173' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-1173' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018073 | EDSK-1173          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10018073 | ESFA-1173          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-1173' agree with the most recent entry for this contract in the ContractManagement feed

   #  Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '192' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
   # And   there are '192' deliverable period rows in CRM linked to the latest version of contract 'EDSK-1173'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | ASCA-173        | 2371175          | Jul-25 | Reconciliation |
    | ASFC-173        | 100946           | Jul-25 | Reconciliation |
    | ALLC-173        | 2303975          | Jul-25 | Reconciliation |

#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '7' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost  | DeliverableName                                                 | DeliverableDescription                                      | 
#    | 10018073 | EDSK-1173       | 1               | ASCA-173      | 1               | 0                     | 45562.00    | 0             | 0         | Adult Education Budget (Grant) Total Funding	                | ?                                                           |
#    | 10018073 | EDSK-1173       | 1               | ASCA-173      | 2               | 1                     | 18053.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
#    | 10018073 | EDSK-1173       | 1               | ASCA-173      | 5               | 1                     | 25509.00     | 0             | 0        | Tailored Learning                                              | ?                                                           |
#    | 10018073 | EDSK-1173       | 1               | ASCA-173      | 12              | 1                     | 2000.00      | 0             | 0        | Funding for Innovative Provision                                | ?                                                           |
#    | 10018073 | EDSK-1173       | 1               | ALLC-173      | 1               | 0                     | 17573.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding                    | ?                                                           |
#    | 10018073 | EDSK-1173       | 1               | ASFC-173      | 1               | 0                     | 27248.00     | 0             | 0        | NSF Free Courses for Jobs Total Funding                         | ?                                                           |
#    | 10018073 | EDSK-1173       | 1               | ASFC-173      | 2               | 1                     | 27248.00     | 0             | 0        | NSF Free Courses for Jobs				                         | ?                                                           |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract 'EDSK-1173' agree with the most recent entry for this contract in the ContractManagement feed


   # Part 2: Populate stub with Claim data

    # Change the date
    Given the override date is '16/06/2025'

    #Set up claim data from SLD for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0018073     | 10018073 | 1                  | Final	     | AY             | 2425   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0018073     | 10018073 | 1                  | Final 	 | AY             | 2425   | ASCA-173      | ASFC-ASCL2425           |
    | ORG0018073     | 10018073 | 1                  | Final 	 | AY             | 2425   | ASFC-173      | ASFC-FCFJ2425           |
    | ORG0018073     | 10018073 | 1                  | Final 	 | AY             | 2425   | ALLC-173      | ALLBC2425               |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ASCA-173      | 3               | 5953.00     | 65.28         | 5.10            | 6023.38    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ASCA-173      | 4               | 5705.00     | 28.26         | 10.00           | 5743.26    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ASCA-173      | 5               | 5532.00     | 62.17         | 14.01           | 5608.18    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ASCA-173      | 6               | 6190.00     | 43.12         | 12.39           | 6245.51    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ASCA-173      | 7               | 6157.00     | 43.66         | 6.06            | 6206.72    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ASCA-173      | 8               | 5760.00     | 52.51         | 12.34           | 5824.85    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ASCA-173      | 9               | 5519.00     | 49.21         | 8.45            | 5576.66    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ASCA-173      | 11              | 5710.00     | 56.91         | 6.33            | 5773.24    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ASCA-173      | 12              | 2910.00     | 46.91         | 43.09           | 3000.00    |
    #                                                                                                                                                                  £ 50001.80  
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ASFC-173      | 3               | 5069.00     | 32.81         | 5.27            | 5107.08    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ASFC-173      | 4               | 4920.00     | 73.93         | 8.75            | 5002.68    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ASFC-173      | 5               | 4634.00     | 34.16         | 9.82            | 4677.98    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ASFC-173      | 6               | 5196.00     | 41.70         | 14.75           | 5252.45    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ASFC-173      | 7               | 4689.00     | 59.38         | 11.15           | 4759.53    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ASFC-173      | 8               | 5222.00     | 64.07         | 8.19            | 5294.26    |
    #                                                                                                                                                                  £ 30093.98  
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ALLC-173      | 2               | 2886.00     | 38.51         | 14.60           | 2939.11    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ALLC-173      | 3               | 2535.00     | 33.12         | 13.12           | 2581.24    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ALLC-173      | 4               | 2693.00     | 39.49         | 8.38            | 2740.87    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ALLC-173      | 5               | 2885.00     | 27.91         | 9.53            | 2922.44    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ALLC-173      | 6               | 2678.00     | 30.66         | 11.10           | 2719.76    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ALLC-173      | 7               | 2005.00     | 49.87         | 7.12            | 2689.99    |
    | ORG0018073      | 10018073 | 1                  | Final      | AY             | 2425   | ALLC-173      | 8               | 2818.00     | 46.74         | 7.17            | 2871.91    |
    #                                                                                                                                                                           £ 19465.32  

# Part 3: Consume stub data and check CRM

    # Change the date
    Given the override date is '18/06/2025'

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018073 | 2425          | Final            | ASFC-ASCL2425       | 1                  | 45562.00     | 50001.80     | 3439.80                     | 0.00                | 3439.80             | 49001.80         | 0.00            | 49001.80                 | Draft      |
    | 10018073 | 2425          | Final            | ASFC-FCFJ2425       | 1                  | 27248.00     | 30093.98     | 2724.80                     | 0.00                | 2724.80             | 30093.98         | 0.00            | 30093.98                 | Draft      |
    | 10018073 | 2425          | Final            | ALLBC2425           | 1                  | 17573.00     | 19465.32     | 0.00                        | 0.00                | 0.00                | 19465.32         | 0.00            | 19465.32                 | Draft      |
 
    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018073 | 2425          | Final         | ASFC-ASCL2425       | ASCA-173      | 45562.00     | 50001.80     | 3439.80                     | 0.00                | 3439.80             | 49001.80         | 0.00            | ?                     | 49001.80                 |
    | 10018073 | 2425          | Final         | ASFC-FCFJ2425       | ASFC-173      | 27248.00     | 30093.98     | 2724.80                     | 0.00                | 2724.80             | 30093.98         | 0.00            | ?                     | 30093.98                 |
    | 10018073 | 2425          | Final         | ALLBC2425           | ALLC-173      | 17573.00     | 19465.32     | 0.00                        | 0.00                | 0.00                | 19465.32         | 0.00            | ?                     | 19465.32                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10018073 | 2425          | Final         | ASFC-ASCL2425       | ASCA-173      | ASFC-ASCL-2425       | 3               | Adult Skills Programme Funding                         | 0.00         | 6023.38      |
    | 10018073 | 2425          | Final         | ASFC-ASCL2425       | ASCA-173      | ASFC-ASCL-2425       | 4               | Adult Skills Learning Support                          | 0.00         | 5743.26      |
    | 10018073 | 2425          | Final         | ASFC-ASCL2425       | ASCA-173      | ASFC-ASCL-2425       | 5               | Tailored Learning                                      | 25509.00     | 5608.18      |
    | 10018073 | 2425          | Final         | ASFC-ASCL2425       | ASCA-173      | ASFC-ASCL-2425       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 6245.51      |
    | 10018073 | 2425          | Final         | ASFC-ASCL2425       | ASCA-173      | ASFC-ASCL-2425       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 6206.72      |
    | 10018073 | 2425          | Final         | ASFC-ASCL2425       | ASCA-173      | ASFC-ASCL-2425       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 5824.85      |
    | 10018073 | 2425          | Final         | ASFC-ASCL2425       | ASCA-173      | ASFC-ASCL-2425       | 9               | Adult Skills Administration Expenditure                | 0.00         | 5576.66      |
    | 10018073 | 2425          | Final         | ASFC-ASCL2425       | ASCA-173      | ASFC-ASCL-2425       | 11              | Adult Skills IT Devices and Connectivity Costs         | 0.00         | 5773.24      |
    | 10018073 | 2425          | Final         | ASFC-ASCL2425       | ASCA-173      | ASFC-ASCL-2425       | 12              | Funding for Innovative Provision				       | 2000.00      | 3000.00      |
    #
    | 10018073 | 2425          | Final         | ASFC-FCFJ2425        | ASFC-173      | ASFC-FCFJ2425         | 3               | NSF Free Courses for Jobs Programme Funding            | 0.00         | 5107.08      |
    | 10018073 | 2425          | Final         | ASFC-FCFJ2425        | ASFC-173      | ASFC-FCFJ2425         | 4               | NSF Free Courses for Jobs Learning Support             | 0.00         | 5002.68      |
    | 10018073 | 2425          | Final         | ASFC-FCFJ2425        | ASFC-173      | ASFC-FCFJ2425         | 5               | National Skills Fund 19+ Hardship                      | 0.00         | 4677.98      |
    | 10018073 | 2425          | Final         | ASFC-FCFJ2425        | ASFC-173      | ASFC-FCFJ2425         | 6               | National Skills Fund 20+ Childcare                     | 0.00         | 5252.45      |
    | 10018073 | 2425          | Final         | ASFC-FCFJ2425        | ASFC-173      | ASFC-FCFJ2425         | 7               | National Skills Fund Residential Access Funding        | 0.00         | 4759.53      |
    | 10018073 | 2425          | Final         | ASFC-FCFJ2425        | ASFC-173      | ASFC-FCFJ2425         | 8               | National Skills Fund Administration Expenditure        | 0.00         | 5294.26      |
    #
    | 10018073 | 2425          | Final         | ALLBC2425           | ALLC-173      | ALLBC2425            | 2               | Loans - Bursary Funding                                | 0.00         | 2939.11      |
    | 10018073 | 2425          | Final         | ALLBC2425           | ALLC-173      | ALLBC2425            | 3               | Loans - Area Costs                                     | 0.00         | 2581.24      |
    | 10018073 | 2425          | Final         | ALLBC2425           | ALLC-173      | ALLBC2425            | 4               | Loans - Excess Claims                                  | 0.00         | 2740.87      |
    | 10018073 | 2425          | Final         | ALLBC2425           | ALLC-173      | ALLBC2425            | 5               | Loans - Hardship                                       | 0.00         | 2922.44      |
    | 10018073 | 2425          | Final         | ALLBC2425           | ALLC-173      | ALLBC2425            | 6               | Loans - Childcare                                      | 0.00         | 2719.76      |
    | 10018073 | 2425          | Final         | ALLBC2425           | ALLC-173      | ALLBC2425            | 7               | Loans - Residential Access Fund                        | 0.00         | 2689.99      |
    | 10018073 | 2425          | Final         | ALLBC2425           | ALLC-173      | ALLBC2425            | 8               | Loans - Administration Expenditure                     | 0.00         | 2871.91      |


    # Part 4: Update FCR and check CRM

    # Change the date 
    Given the override date is '20/06/2025'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither. In this case, both ... 
    # User can update the EarningsBoost value or introduce a Claim Adjustment or both or neither. 

    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10018073 | 2425          | Final            | ASFC-ASCL2425       | 1                  | ASCA-173      | 45562.00     | 50001.80     | 3439.80                     | 0.00                | 3439.80             | 49001.80         | 2000.00         | Other                 |
    | 10018073 | 2425          | Final            | ASFC-FCFJ2425       | 1                  | ASFC-173      | 27248.00     | 30093.98     | 2724.80                     | 1000.00             | 2724.80             | 30093.98         | 12000.00        | Other                 |
    | 10018073 | 2425          | Final            | ALLBC2425           | 1                  | ALLC-173      | 17573.00     | 19465.32     | 0.00                        | 137.17              | 0.00                | 19465.32         | 0.00            | ?                     |

    Then wait '10' seconds

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status |
    | 10018073 | 2425          | Final            | ASFC-ASCL2425       | 1                  | 45562.00     | 50001.80     | 4556.20                     | 0.00                  | 4556.20            | 49001.80       | 2000.00         | 51001.80                | Draft  |
    | 10018073 | 2425          | Final            | ASFC-FCFJ2425       | 1                  | 27248.00     | 30093.98     | 2724.80                     | 1000.00               | 3724.80            | 30093.98       | 12000.00        | 42093.98                | Draft  |
    | 10018073 | 2425          | Final            | ALLBC2425           | 1                  | 17573.00     | 19465.32     | 0.00                        | 137.17                | 137.17             | 19465.32       | 0.00            | 19465.32                 | Draft  |
 
    # changed value
   And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018073 | 2425          | Final            | ASFC-ASCL2425       | ASCA-173      | 45562.00     | 50001.80     | 4556.20                     | 0.00                |  4556.20            | 49001.80         | 2000.00         | Other                 | 51001.80                 |
    | 10018073 | 2425          | Final            | ASFC-FCFJ2425       | ASFC-173      | 27248.00     | 30093.98     | 2724.80                     | 1000.00             |  3724.80            | 30093.98         | 12000.00        | Other                 |  42093.98                |
    | 10018073 | 2425          | Final            | ALLBC2425           | ALLC-173      | 17573.00     | 19465.32     | 0.00                        | 137.17              |  137.17             | 19465.32         | 0.00            | ?                     | 19465.32                 |


    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018073 | 2425          | Final            | ASFC-ASCL2425       | ASCA-173      | 45562.00     | 50001.80     | 4556.20                     | 0.00                |  4556.20             | 49001.80         | 2000.00         | Other                | 51001.80                 |
    | 10018073 | 2425          | Final            | ASFC-FCFJ2425       | ASFC-173      | 27248.00     | 30093.98     | 2724.80                     | 1000.00             |  3724.80          	 | 30093.98         |12000.00         | Other                | 42093.98                 |
    | 10018073 | 2425          | Final            | ALLBC2425           | ALLC-173      | 17573.00     | 19465.32     | 0.00                        | 137.17              |  137.17            	 | 19465.32         | 0.00            | ?                    | 19465.32                 |
                                                 


# Part 5: Bulk amend the contract to change the Profile values and force a recalc

    # Change the date
    Given the override date is '24/06/2025'

    # Bulk file to update Profile values
    And   there are no files prefixed '10018073' in the Sharepoint 'EDSK-2425-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2425 24062025084106 v2_S073' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2425 24062025084106 v2_S073' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2425 24062025084106 v2_S073' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2425 24062025084106 v2_S073' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2425 24062025084106 v2_S073.xlsx' exists in the Datafiles folder and UKPRN '10018073' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Part 6: Publish and Approve contract v2 and check financials
    
    # Change the date
    Given the override date is '25/06/2025'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-1173'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-1173' and ContractNumber 'EDSK-1173' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-1173' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018073 | EDSK-1173          | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2024        | 31/07/2025      | Variation     |
    | 10018073 | EDSK-1173          | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
    | 10018073 | ESFA-1173          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'EDSK-1173' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '192' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    #And   there are '180' deliverable period rows in CRM linked to the latest version of contract 'EDSK-1173'

    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | ASCA-173        | 2371175          | Jul-25 | Reconciliation |
#    | ASFC-173        | 100946           | Jul-25 | Reconciliation |
#    | ALLC-173        | 2303975          | Jul-25 | Reconciliation |
#

    # Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber  | AllocationRef      | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   |
    | EDSK-1173       | ASCA-173           | 1               | 45891.00  | 7488.00  | 1892.00  | 1522.00  | 3395.00  | 10011.00 | 3213.00  | 2897.00  | 4120.00  | 2614.00  | 2492.00  | 2708.00  | 3539.00  | 
    | EDSK-1173       | ASCA-173           | 2               | 23272.00  | 4433.00  | 1355.00  | 591.00   | 1707.00  | 4421.00  | 1217.00  | 1843.00  | 2852.00  | 1036.00  | 644.00   | 661.00   | 2512.00  | 
    | EDSK-1173       | ASCA-173           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-1173       | ASCA-173           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-1173       | ASCA-173           | 5               | 20619.00  | 2055.00  | 537.00   | 931.00   | 1688.00  | 5590.00  | 1996.00  | 1054.00  | 1268.00  | 1578.00  | 1848.00  | 1047.00  | 1027.00  | 
    | EDSK-1173       | ALLC-173           | 1               | 17826.00  | 1057.00  | 1654.00  | 1024.00  | 1014.00  | 1647.00  | 1314.00  | 1225.00  | 1048.00  | 2002.00  | 1043.00  | 1924.00  | 2874.00  | 
    | EDSK-1173       | ALLC-173           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-1173       | ALLC-173           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-1173       | ALLC-173           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-1173       | ASFC-173           | 1               | 26991.00  | 81.00    | 1236.00  | 3786.00  | 1185.00  | 1101.00  | 4179.00  | 1119.00  | 2249.00  | 4635.00  | 1525.00  | 2905.00  | 2990.00  | 
    | EDSK-1173       | ASFC-173           | 2               | 26991.00  | 81.00    | 1236.00  | 3786.00  | 1185.00  | 1101.00  | 4179.00  | 1119.00  | 2249.00  | 4635.00  | 1525.00  | 2905.00  | 2990.00  | 
    | EDSK-1173       | ASFC-173           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-1173       | ASFC-173           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber  | AllocationRef      | DeliverableCode | Jul-25   |
    | EDSK-1173       | ASCA-173           | 1               | 0.00     | 
    | EDSK-1173       | ASCA-173           | 2               | 5,481.00 | 
    | EDSK-1173       | ASCA-173           | 3               | 0.00     | 
    | EDSK-1173       | ASCA-173           | 4               | 0.00     | 
    | EDSK-1173       | ASCA-173           | 5               | -2,608.00| 
    #
    | EDSK-1173       | ALLC-173           | 1               | -285.00  | 
    | EDSK-1173       | ALLC-173           | 2               | 0.00     | 
    | EDSK-1173       | ALLC-173           | 3               | 0.00     | 
    | EDSK-1173       | ALLC-173           | 4               | 0.00     | 
    #
    | EDSK-1173       | ASFC-173           | 1               | 0.00      | 
    | EDSK-1173       | ASFC-173           | 2               | -273.00   | 
    | EDSK-1173       | ASFC-173           | 3               | 0.00      | 
    | EDSK-1173       | ASFC-173           | 4               | 0.00      | 


	# Check FCR values
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue  | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018073 | 2425          | Final            | ASFC-ASCL2425       | 1                  | 45891.00     | 50001.80     | 4589.10                     | 0.00                | 4556.20             | 49001.80         | 2000            | 51001.80                 | Draft      |
    | 10018073 | 2425          | Final            | ASFC-FCFJ2425       | 1                  | 26991.00     | 30093.98     | 2699.10                     | 1000.00             | 3724.80             | 30093.98         | 12000           | 42093.98                 | Draft      |
    | 10018073 | 2425          | Final            | ALLBC2425           | 1                  | 17826.00     | 19465.32     | 0.00                        | 137.17              | 137.17              | 19465.32         | 0.00            | 19465.32                 | Draft      |
    




    # Part 7: Publish the FCR. Check CRM and feed

	# Change the date
    Given the override date is '28/10/2025'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2425-YearEnd' and Allocation Group Code 'AEB-LS1819'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2425-Final' and Allocation Group Code 'ASFC-ASCL2425'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2425-Final' and Allocation Group Code 'ASFC-FCFJ2425'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2425-Final' and Allocation Group Code 'ALLBC2425'


    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018073 | 2425          | Final            | ASFC-ASCL2425       | 1                  |
    | 10018073 | 2425          | Final            | ASFC-FCFJ2425       | 1                  |
    | 10018073 | 2425          | Final            | ALLBC2425           | 1                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018073 | 2425          | Final         | ASFC-ASCL2425       | 1                  |
    | 10018073 | 2425          | Final         | ASFC-FCFJ2425       | 1                  |
    | 10018073 | 2425          | Final         | ALLBC2425           | 1                  |

#    And   group claim data is present in the CRM funding claim reconciliation tables as follows
#    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue   | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
#    | 10018073 | 2425          | Final            | ASFC-ASCL2425       | 1                  | 45891.00     | 50001.80     | 4589.10                     | 0.00                 |  4556.20             | 49001.80         | 2000            | 51001.80                | Published  |
#    | 10018073 | 2425          | Final            | ASFC-FCFJ2425       | 1                  | 26991.00     | 30093.98     | 13495.50                    | 1000.00              |  2724.80             | 30093.98         | 12000           | 42093.98               | Published  |
#    | 10018073 | 2425          | Final            | ALLBC2425           | 1                  | 17826.00     | 19465.32     | 0.00                        | 137.17               |  137.17              | 19465.32         | 0.00            | 19465.32                | Published  |
#
#    # Use Atom feed to inform downstream systems of claim reconciliation publication event
#    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
#    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
#    | 10018073 | 2425          | Final            | ASFC-ASCL2425       | 1                  |
#    | 10018073 | 2425          | Final            | ASFC-FCFJ2425       | 1                  |
#    | 10018073 | 2425          | Final            | ALLBC2425           | 1                  |
#
#    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
#    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
#    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                    | PlannedValue | ClaimedValue | ProposedReconciliationValue | EarningsBoostValue   | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
#    | 10018073 | ASCA-173         | 2425   | Final      | AEB (Grant) - Adult Skills and Community Learning 24/25   |45891.00     | 50001.80     | 4589.10                     | 0.00                  | 4556.20             | 49001.80         | 2000               | Other                 | 51001.80                   |
#    | 10018073 | ASFC-173         | 2425   | Final      | AEB (Grant) - National Skills Fund 24/25                  |26991.00     | 30093.98     | 13495.50                    | 1000.00               | 2724.80             | 30093.98         | 12000              | Other                 | 42093.98                   |
#    | 10018073 | ALLC-173         | 2425   | Final      | Advanced Learner Loans Bursary (Grant) 24/25              |17826.00     | 19465.32     | 0.00                        | 137.17                | 137.17              | 19465.32         | ?               | ?                     | 19465.32                   |
#     
#
#

#
#    # Part 7c: Payment Batch for ASF2526
#
#    # Change the date
#    Given the override date is '04/11/2025 22:00'
#
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod 'ASFC-ASCL2425' AccountingPaymentPeriod '202508' CensusEndDate '04/11/2025' and LinkCodeSuffix 'R'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | ASCA-173                 | 202511 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | ASFC-ASCL2425	             | 202511               |                      | R              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | ASFC-ASCL2425	         	 | 202511               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'ASFC-ASCL2425' PaymentPeriod '202508' CensusEndDate '04/11/2025' and LinkCodeSuffix 'R' is decrypted and saved to 'DataFiles/Downloads' as 'S073_ASCL.xml'
#
#    ## Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    #And   the Payment feed xml for FundingStreamPeriod 'ALLBC2425' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' includes the following values
#    #| FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 3008.75         | RECONCILIATION   | AEB Other Learning                 | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372010    |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 980.07          | RECONCILIATION   | AEB OthLearning LngS               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372060    |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2567.98         | RECONCILIATION   | AdltSkll19+Hardship                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100927     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2111.17         | RECONCILIATION   | AdltSkll20+Childcare               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100928     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 1323.40         | RECONCILIATION   | AdltSkllRsdntlAccess               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100929     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 3073.78         | RECONCILIATION   | AdltSkllAdminExp                   | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100930     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2023.94         | RECONCILIATION   | AdltSkllC19Response                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100931     |
#    ##                                                                                                    £15089.09



    # Tidy up
    Given the override date is reset
   
