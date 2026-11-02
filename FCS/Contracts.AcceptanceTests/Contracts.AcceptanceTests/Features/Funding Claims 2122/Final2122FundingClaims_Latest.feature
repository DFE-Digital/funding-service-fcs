Feature: Final2122FundingClaims Latest

@AcceptanceTest @Withdrawn20231002
@FundingClaims
Scenario: S003 Create and approve an EDSK2122 contract with AEBC-19TRN2122, AEBC-ASCL2122, AEBC-NSF2122 and ALLBC2122 allocs. Process Final Funding Claim BELOW profile
    
    # 1. Create and approve an EDSK2122 contract with all four FCR allocs. Check CRM and feed
    # 2. Populate the stub with Claim data
    # 3. Consume stub data and check CRM
    # 4. Update FCR and check CRM
    # 5. Publish FCR. Check CRM and feed
    
    Given there are no allocations marked as Under Termination for UKPRN '10018003' 
    And   there are no terminated or closed allocations for UKPRN '10018003' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018003' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018003' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018003' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-003      |
    | AECT-003      |
    | ALLC-003      |
    | NSFC-003      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-003      |
    | AECT-003      |
    | ALLC-003      |
    | NSFC-003      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-19TRN2122    |
    | AEBC-ASCL2122     |
    | AEBC-NSF2122      |
    | ALLBC2122         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-003       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018003'

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Final      | 1718   |
    | Final      | 1819   |
    | Final      | 1920   |
    | Final      | 2021   |
    | Final      | 2122   |
    | Final      | 1718   |
    | Final      | 1819   |
    | Final      | 1920   |
    | Final      | 2021   |
    | Final      | 2122   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10018003 |

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    Given there is no data in the Reconciliation Profiling table for UKPRN '10018003' and FundingPeriod 'AY2122'

 #  # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
 #  And   the Reconciliation Profiling table includes a row for UKPRN '10018003' and FundingPeriod 'AY2122'

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECT-003      |
    | AECA-003      |
    | NSFC-003      |
    | ALLC-003      |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018003' 
    And   there is no caseload advisor for UKPRN '10018003' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018003 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018003' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018003 Co Ltd' with UKPRN '10018003' and OrgId 'ORG0018003' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018003 | 117003 | 10018003 Co Ltd | 0              | In Administration     | Yes           | AA017003      | ?             | 7 Coventry Hill        | ?                      | ?                      | ?                      | High Wycombe           | Coventry        | HP13 6NS  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018003 |





    # Part 1: Create and approve an EDSK2122 contract with all four FCR allocs. Check CRM and feed
    
    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-003'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-003'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType                           | Period | CRMIntent    | OrgId      |
    | 10018003 | 10018003 Co Ltd      | ESFA-003             | EDSK-003       | 1                     | 01/08/2021        | 31/07/2022      | 95978.00      |                       | Conditions of Funding (Grant) (HEI)    | 2122   | New          | ORG0018003 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName    | UoPCode    | AllocationDescription        | CRMIntent    | DeliveryOrg |
    | 10018003 | EDSK-003       | AECA-003      | AEBC-ASCL         | AEBC-ASCL2122           | AY                      | 01/08/2021          | 31/07/2022        | 35651.00        |            |            |                              | New          |             |
    | 10018003 | EDSK-003       | AECT-003      | AEBC-19TRN        | AEBC-19TRN2122          | AY                      | 01/08/2021          | 31/07/2022        | 21854.00        |            |            |                              | New          |             |
    | 10018003 | EDSK-003       | ALLC-003      | ALLBC             | ALLBC2122               | AY                      | 01/08/2021          | 31/07/2022        | 20478.00        |            |            |                              | New          |             |
    | 10018003 | EDSK-003       | NSFC-003      | AEBC-NSF          | AEBC-NSF2122            | AY                      | 01/08/2021          | 31/07/2022        | 17995.00        |            |            |                              | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                              | CRMIntent    | DeliveryOrg |
    | 10018003 | EDSK-003       | AECA-003      | 1               | 0                     | 35651.00  | 22628.00  | 13023.00  | 3026.00  | 2883.00  | 2330.00  | 3989.00  | 2710.00  | 3832.00  | 466.00   | 3392.00  | 3753.00  | 3421.00  | 2680.00  | 3169.00  | Adult Skills and Community Learning Total Funding   | New          |             | 
    | 10018003 | EDSK-003       | AECA-003      | 2               | 1                     | 11604.00  | 8072.00   | 3532.00   | 926.00   | 585.00   | 625.00   | 506.00   | 862.00   | 3496.00  | 279.00   | 793.00   | 1969.00  | 175.00   | 121.00   | 1267.00  | Adult Skills Total Funding                          | New          |             | 
    | 10018003 | EDSK-003       | AECA-003      | 5               | 1                     | 24047.00  | 14556.00  | 9491.00   | 2100.00  | 2298.00  | 1705.00  | 3483.00  | 1848.00  | 336.00   | 187.00   | 2599.00  | 1784.00  | 3246.00  | 2559.00  | 1902.00  | Community Learning                                  | New          |             | 
    | 10018003 | EDSK-003       | AECT-003      | 1               | 0                     | 21854.00  | 16140.00  | 5714.00   | 2199.00  | 2935.00  | 1709.00  | 1685.00  | 775.00   | 785.00   | 2722.00  | 3330.00  | 523.00   | 2524.00  | 222.00   | 2445.00  | 19-24 Traineeships Total Funding                    | New          |             | 
    | 10018003 | EDSK-003       | ALLC-003      | 1               | 0                     | 20478.00  | 15221.00  | 5257.00   | 2013.00  | 3288.00  | 447.00   | 3303.00  | 3120.00  | 2685.00  | 289.00   | 76.00    | 1697.00  | 536.00   | 1302.00  | 1722.00  | Total Advanced Learner Loans Bursary Funding        | New          |             | 
    | 10018003 | EDSK-003       | NSFC-003      | 1               | 0                     | 17995.00  | 10848.00  | 7147.00   | 1736.00  | 2566.00  | 76.00    | 145.00   | 1672.00  | 1775.00  | 2447.00  | 431.00   | 2779.00  | 1173.00  | 2289.00  | 906.00   | Total 16-18 Traineeships Funding                    | New          |             | 
    | 10018003 | EDSK-003       | NSFC-003      | 2               | 1                     | 17995.00  | 10848.00  | 7147.00   | 1736.00  | 2566.00  | 76.00    | 145.00   | 1672.00  | 1775.00  | 2447.00  | 431.00   | 2779.00  | 1173.00  | 2289.00  | 906.00   | Level 3 Offer for 24 year olds and over             | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'
    
    # Check the deliverables have all been created in CRM. Essentially a 'wait'
   #And   there are '84' deliverable period rows in CRM linked to the latest version of contract number 'EDSK-003'
    And   there are '84' deliverable period rows in CRM linked to the latest version of contract 'EDSK-003'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-003'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-003' and ContractNumber 'EDSK-003' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-003' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018003 | EDSK-003           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10018003 | ESFA-003           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-003' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '192' deliverable period rows in CRM linked to the latest version of contract number 'EDSK-003'
    And   there are '192' deliverable period rows in CRM linked to the latest version of contract 'EDSK-003'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECT-003        | 2355775          | Jul-22 | Reconciliation |
    | AECA-003        | 2371175          | Jul-22 | Reconciliation |
    | NSFC-003        | 100946           | Jul-22 | Reconciliation |
    | ALLC-003        | 2303975          | Jul-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '7' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10018003 | EDSK-003       | 1               | AECA-003      | 1               | 0                     | 35651.00     | 0             | 0        | Adult Skills and Community Learning Total Funding               | ?                                                           |
    | 10018003 | EDSK-003       | 1               | AECA-003      | 2               | 1                     | 11604.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
    | 10018003 | EDSK-003       | 1               | AECA-003      | 5               | 1                     | 24047.00     | 0             | 0        | Community Learning                                              | ?                                                           |
    | 10018003 | EDSK-003       | 1               | AECT-003      | 1               | 0                     | 21854.00     | 0             | 0        | 19-24 Traineeships Total Funding                                | ?                                                           |
    | 10018003 | EDSK-003       | 1               | ALLC-003      | 1               | 0                     | 20478.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding                    | ?                                                           |
    | 10018003 | EDSK-003       | 1               | NSFC-003      | 1               | 0                     | 17995.00     | 0             | 0        | Total 16-18 Traineeships Funding                                | ?                                                           |
    | 10018003 | EDSK-003       | 1               | NSFC-003      | 2               | 1                     | 17995.00     | 0             | 0        | Level 3 Offer for 24 year olds and over                         | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-003' agree with the most recent entry for this contract in the ContractManagement feed




    # Add actuals to the contract for EDSK2022

    # Change the date
    Given the override date is '04/08/2022'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018003'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for July 2022 (Four deliverables)
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode  | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2122        | R12                  | ORG0018003     | CM             | 202207 | AEBC-19TRN2122           | AECT-003            |        | 2              | 0           | 8229.83     |
    | ILR2122        | R12                  | ORG0018003     | CM             | 202207 | AEBC-19TRN2122           | AECT-003            |        | 3             | 0            | 547.07      |
    | ILR2122        | R12                  | ORG0018003     | CM             | 202207 | AEBC-ASCL2122            | AECA-003            |        | 3             | 0            | 552.44      |
    | ILR2122        | R12                  | ORG0018003     | CM             | 202207 | AEBC-ASCL2122            | AECA-003            |        | 4             | 0            | 1002.62     |
    | ILR2122        | R12                  | ORG0018003     | CM             | 202207 | AEBC-NSF2122             | NSFC-003            |        | 3             | 0            | 648.52      |
    | ILR2122        | R12                  | ORG0018003     | CM             | 202207 | AEBC-NSF2122             | NSFC-003            |        | 4             | 0            | 1648.52     |
    | ILR2122        | R12                  | ORG0018003     | CM             | 202207 | ALLBC2122                | ALLC-003            |        | 2             | 0            | 648.52      |
    | ILR2122        | R12                  | ORG0018003     | CM             | 202207 | ALLBC2122                | ALLC-003            |        | 3             | 0            | 1648.52     |
	
	


    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-003   | AECT-003      | 2      | 8229.83   | ?  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 8229.83     | 
    | EDSK-003   | AECT-003      | 3      | 547.07    | ?  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 547.07      | 
    | EDSK-003   | AECA-003      | 3      | 552.44    | ?  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 552.44      | 
    | EDSK-003   | AECA-003      | 4      | 1002.62   | ?  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1002.62     | 
    | EDSK-003   | NSFC-003      | 3      | 648.52    | ?  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 648.52      | 
    | EDSK-003   | NSFC-003      | 4      | 1648.52   | ?  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1648.52     | 
    | EDSK-003   | ALLC-003      | 2      | 648.52    | ?  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 648.52      | 
    | EDSK-003   | ALLC-003      | 3      | 1648.52   | ?  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1648.52     | 


#
#    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
#    And   the Reconciliation Data is calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
#    | EDSK-003   | [AllocRef_SB]      | 72              | 8229.83   | 8229.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | EDSK-003   | [AllocRef_SB]      | 115             | 547.07    | 547.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | EDSK-003   | [AllocRef_SB]      | 189             | 552.44    | 552.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | EDSK-003   | [AllocRef_SB]      | 238             | 1002.62   | 1002.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | EDSK-003   | [AllocRef_SB]      | 239             | 648.52    | 648.52   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | EDSK-003   | [AllocRef_SB]      | 240             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    #                                                       £ 12629.00
#
#    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
#    And   the Capping Amounts are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
#    | EDSK-003   | [AllocRef_SB]      | 72              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | EDSK-003   | [AllocRef_SB]      | 115             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | EDSK-003   | [AllocRef_SB]      | 189             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | EDSK-003   | [AllocRef_SB]      | 238             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | EDSK-003   | [AllocRef_SB]      | 239             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | EDSK-003   | [AllocRef_SB]      | 240             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
#
#    # Check the NET AMOUNTS in CRM on the latest approved contract
#    And   the Net Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
#    | EDSK-003   | [AllocRef_SB]      | 72              | 8229.83   | 8229.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | EDSK-003   | [AllocRef_SB]      | 115             | 547.07    | 547.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | EDSK-003   | [AllocRef_SB]      | 189             | 552.44    | 552.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | EDSK-003   | [AllocRef_SB]      | 238             | 1002.62   | 1002.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | EDSK-003   | [AllocRef_SB]      | 239             | 648.52    | 648.52   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | EDSK-003   | [AllocRef_SB]      | 240             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#  #                                                         £ 12629.00
#

#
#    # Payment Batch for EDSK2022(PoA)
#
#    # Change the date
#    Given the override date is '08/08/2022 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod 'AEBC-ASCL2122' AccountingPaymentPeriod '202204' CensusEndDate '06/07/2022' and LinkCodeSuffix 'A'
#    And   there is no data in the Payment feed for FundingStreamPeriod 'AEBC-19TRN2122' AccountingPaymentPeriod '202204' CensusEndDate '06/07/2022' and LinkCodeSuffix 'A'
#    And   there is no data in the Payment feed for FundingStreamPeriod 'AEBC-NSF2122' AccountingPaymentPeriod '202204' CensusEndDate '06/07/2022' and LinkCodeSuffix 'A'
#    And   there is no data in the Payment feed for FundingStreamPeriod 'ALLBC2122' AccountingPaymentPeriod '202204' CensusEndDate '06/07/2022' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | AECT-003            | 202207 |
#	| AECA-003            | 202207 |
#	| NSFC-003            | 202207 |
#	| ALLC-003            | 202207 |
#	
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | AEBC-ASCL2122            | 202207               |                      | A              | NotStarted |
#    | AEBC-19TRN2122           | 202207               |                      | A              | NotStarted |
#    | AEBC-NSF2122             | 202207               |                      | A              | NotStarted |
#    | ALLBC2122                | 202207               |                      | A              | NotStarted |
#
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | AEBC-ASCL2122            	 | 202207               | Completed |
#    | AEBC-19TRN2122          	 | 202207               | Completed |
#    | AEBC-NSF2122          	 | 202207               | Completed |
#    | ALLBC2122              	 | 202207               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'AEBC-ASCL2122' PaymentPeriod '202204' CensusEndDate '06/07/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S0031.xml'
#    And   the Payment feed xml for FundingStreamPeriod 'AEBC-19TRN2122' PaymentPeriod '202204' CensusEndDate '06/07/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S0032.xml'
#    And   the Payment feed xml for FundingStreamPeriod 'AEBC-NSF2122' PaymentPeriod '202204' CensusEndDate '06/07/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S0033.xml'
#    And   the Payment feed xml for FundingStreamPeriod 'ALLBC2122' PaymentPeriod '202204' CensusEndDate '06/07/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S0034.xml'
#
#    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'AEBC-ASCL2122' PaymentPeriod '202204' CensusEndDate '06/07/2022' and LinkCodeSuffix 'A' includes the following values
#    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue   | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    | AECA              | 2022          | 04             | 07          | ?       | AECA-003     | 1555.06          | RECONCILIATION   | AEBGrantAdultSkllsCL       | 2022-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10018003 | 2371175     |
#  
#  #
#  #  | AEBC-19TRN             | 2022          | 04             | 07          | ?       | AECT-003     | 8776.09          | RECONCILIATION   | 19-24TrnGrant   		    | 2022-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10018003 | 2355775     |
#  #  | AEBC-NSF               | 2022          | 04             | 07          | ?       | NSFC-003     | 2297.04          | RECONCILIATION   | National Skills Fund       | 2022-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10018003 | 100946     |
#  #  | ALLBC                  | 2022          | 04             | 07          | ?       | ALLC-003     | 2297.04          | RECONCILIATION   | Adv LL Bursary       		| 2022-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10018003 | 2303975     |
#
##
##    # Check the RECONCILIATION subnominal aggregations in CRM
##    And   the Reconciliation Subnominal Amounts are calculated as follows
##    | UKPRN    | ContractNumber | AllocationRef     | ReconciliationSubnominal | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    | Aug-23    | Sep-23    |
##    | 10018003 | EDSK-003   | AECA-003     | 2371175                   | 12629.00  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
##    | 10018003 | EDSK-003   | AECT-003     | 2355775                   | 12629.00  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
##    | 10018003 | EDSK-003   | NSFC-003     | 100946                   | 12629.00  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
##    | 10018003 | EDSK-003   | ALLC-003     | 2303975                   | 12629.00  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
##

	

    
	



    # Part 2: Populate stub with Claim data

    # Change the date
    Given the override date is '16/10/2022'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0018003     | 10018003 | 2                  | Final   		 | AY             | 2122   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0018003     | 10018003 | 2                  | Final  		 | AY             | 2122   | AECT-003      | AEBC-19TRN2122          |
    | ORG0018003     | 10018003 | 2                  | Final     	 | AY             | 2122   | AECA-003      | AEBC-ASCL2122           |
    | ORG0018003     | 10018003 | 2                  | Final  	     | AY             | 2122   | NSFC-003      | AEBC-NSF2122            |
    | ORG0018003     | 10018003 | 2                  | Final   		 | AY             | 2122   | ALLC-003      | ALLBC2122               |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | AECT-003      | 2               | 3300.00     | 69.96         | 6.08            | 3376.04    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | AECT-003      | 3               | 3410.00     | 53.69         | 8.14            | 3471.83    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | AECT-003      | 5               | 3139.00     | 38.17         | 14.66           | 3191.83    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | AECT-003      | 6               | 3112.00     | 50.61         | 9.72            | 3172.33    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | AECT-003      | 7               | 3130.00     | 65.97         | 6.50            | 3202.47    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | AECT-003      | 8               | 3526.00     | 58.45         | 10.86           | 3595.31    |
    #                                                                                                                                                                           £ 20009.81  
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | AECA-003      | 3               | 4019.00     | 73.38         | 5.80            | 4098.18    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | AECA-003      | 4               | 4291.00     | 69.54         | 9.50            | 4370.04    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | AECA-003      | 5               | 4148.00     | 70.28         | 5.90            | 4224.18    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | AECA-003      | 6               | 3871.00     | 71.92         | 11.81           | 3954.73    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | AECA-003      | 7               | 3853.00     | 42.54         | 12.71           | 3908.25    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | AECA-003      | 8               | 4395.00     | 49.39         | 7.12            | 4451.51    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | AECA-003      | 9               | 4013.00     | 25.00         | 5.86            | 4043.86    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | AECA-003      | 10              | 3818.00     | 34.90         | 10.91           | 3863.81    |
    #                                                                                                                                                                           £ 32914.56  
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | NSFC-003      | 3               | 2571.00     | 34.88         | 13.72           | 2619.60    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | NSFC-003      | 4               | 2743.00     | 34.43         | 5.43            | 2782.86    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | NSFC-003      | 5               | 2907.00     | 51.42         | 10.52           | 2968.94    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | NSFC-003      | 6               | 2663.00     | 51.13         | 10.30           | 2724.43    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | NSFC-003      | 7               | 2661.00     | 40.26         | 6.79            | 2708.05    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | NSFC-003      | 8               | 2716.00     | 51.75         | 7.54            | 2775.29    |
    #                                                                                                                                                                           £ 16579.17  
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | ALLC-003      | 2               | 2558.00     | 33.54         | 6.30            | 2597.84    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | ALLC-003      | 3               | 2813.00     | 30.24         | 8.55            | 2851.79    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | ALLC-003      | 4               | 2840.00     | 39.00         | 5.59            | 2884.59    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | ALLC-003      | 5               | 2514.00     | 35.52         | 12.32           | 2561.84    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | ALLC-003      | 6               | 2912.00     | 64.23         | 14.41           | 2990.64    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | ALLC-003      | 7               | 2535.00     | 43.25         | 7.44            | 2585.69    |
    | ORG0018003     | 10018003 | 2                  | Final      | AY             | 2122   | ALLC-003      | 8               | 2873.00     | 54.26         | 8.13            | 2935.39    |
    #                                                                                                                                                                           £ 19407.78  





    # Part 3: Consume stub data and check CRM

    # Change the date
    Given the override date is '18/10/2022'

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018003 | 2122          | Final         | AEBC-19TRN2122      | 2                  | 21854.00     | 20009.81     | -1844.19                    | -1844.19            | 20009.81         | 0.00            | 20009.81                 | Draft      |
    | 10018003 | 2122          | Final         | AEBC-ASCL2122       | 2                  | 35651.00     | 32914.56     | -2736.44                    | -2736.44            | 32914.56         | 0.00            | 32914.56                 | Draft      |
    | 10018003 | 2122          | Final         | AEBC-NSF2122        | 2                  | 17995.00     | 16579.17     | -1415.83                    | -1415.83            | 16579.17         | 0.00            | 16579.17                 | Draft      |
    | 10018003 | 2122          | Final         | ALLBC2122           | 2                  | 20478.00     | 19407.78     | -1070.22                    | -1070.22            | 19407.78         | 0.00            | 19407.78                 | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018003 | 2122          | Final         | AEBC-19TRN2122      | AECT-003      | 21854.00     | 20009.81     | -1844.19                    | -1844.19            | 20009.81         | 0.00            | ?                     | 20009.81                 |
    | 10018003 | 2122          | Final         | AEBC-ASCL2122       | AECA-003      | 35651.00     | 32914.56     | -2736.44                    | -2736.44            | 32914.56         | 0.00            | ?                     | 32914.56                 |
    | 10018003 | 2122          | Final         | AEBC-NSF2122        | NSFC-003      | 17995.00     | 16579.17     | -1415.83                    | -1415.83            | 16579.17         | 0.00            | ?                     | 16579.17                 |
    | 10018003 | 2122          | Final         | ALLBC2122           | ALLC-003      | 20478.00     | 19407.78     | -1070.22                    | -1070.22            | 19407.78         | 0.00            | ?                     | 19407.78                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10018003 | 2122          | Final         | AEBC-19TRN2122      | AECT-003      | AEBC-19TRN2122       | 2               | 19-24 Traineeships Programme Funding                   | 0.00         | 3376.04      |
    | 10018003 | 2122          | Final         | AEBC-19TRN2122      | AECT-003      | AEBC-19TRN2122       | 3               | 19-24 Traineeships Learning Support                    | 0.00         | 3471.83      |
    | 10018003 | 2122          | Final         | AEBC-19TRN2122      | AECT-003      | AEBC-19TRN2122       | 5               | 19-24 Traineeships Admin Expenditure                   | 0.00         | 3191.83      |
    | 10018003 | 2122          | Final         | AEBC-19TRN2122      | AECT-003      | AEBC-19TRN2122       | 6               | 19-24 Traineeships 19+ Hardship                        | 0.00         | 3172.33      |
    | 10018003 | 2122          | Final         | AEBC-19TRN2122      | AECT-003      | AEBC-19TRN2122       | 7               | 19-24 Traineeships 20+ Childcare                       | 0.00         | 3202.47      |
    | 10018003 | 2122          | Final         | AEBC-19TRN2122      | AECT-003      | AEBC-19TRN2122       | 8               | 19-24 Traineeships Residential Access Funding          | 0.00         | 3595.31      |
    #
    | 10018003 | 2122          | Final         | AEBC-ASCL2122       | AECA-003      | AEBC-ASCL-2122       | 3               | Adult Skills Programme Funding                         | 0.00         | 4098.18      |
    | 10018003 | 2122          | Final         | AEBC-ASCL2122       | AECA-003      | AEBC-ASCL-2122       | 4               | Adult Skills Learning Support                          | 0.00         | 4370.04      |
    | 10018003 | 2122          | Final         | AEBC-ASCL2122       | AECA-003      | AEBC-ASCL-2122       | 5               | Community Learning                                     | 24047.00     | 4224.18      |
    | 10018003 | 2122          | Final         | AEBC-ASCL2122       | AECA-003      | AEBC-ASCL-2122       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 3954.73      |
    | 10018003 | 2122          | Final         | AEBC-ASCL2122       | AECA-003      | AEBC-ASCL-2122       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 3908.25      |
    | 10018003 | 2122          | Final         | AEBC-ASCL2122       | AECA-003      | AEBC-ASCL-2122       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 4451.51      |
    | 10018003 | 2122          | Final         | AEBC-ASCL2122       | AECA-003      | AEBC-ASCL-2122       | 9               | Adult Skills Administration Expenditure                | 0.00         | 4043.86      |
    | 10018003 | 2122          | Final         | AEBC-ASCL2122       | AECA-003      | AEBC-ASCL-2122       | 10              | Learner Support - COVID-19 Response                    | 0.00         | 3863.81      |
    #
    | 10018003 | 2122          | Final         | AEBC-NSF2122        | NSFC-003      | AEBC-NSF2122         | 3               | National Skills Fund Programme Funding                 | 0.00         | 2619.60      |
    | 10018003 | 2122          | Final         | AEBC-NSF2122        | NSFC-003      | AEBC-NSF2122         | 4               | National Skills Fund Learning Support                  | 0.00         | 2782.86      |
    | 10018003 | 2122          | Final         | AEBC-NSF2122        | NSFC-003      | AEBC-NSF2122         | 5               | National Skills Fund 19+ Hardship                      | 0.00         | 2968.94      |
    | 10018003 | 2122          | Final         | AEBC-NSF2122        | NSFC-003      | AEBC-NSF2122         | 6               | National Skills Fund 20+ Childcare                     | 0.00         | 2724.43      |
    | 10018003 | 2122          | Final         | AEBC-NSF2122        | NSFC-003      | AEBC-NSF2122         | 7               | National Skills Fund Residential Access Funding        | 0.00         | 2708.05      |
    | 10018003 | 2122          | Final         | AEBC-NSF2122        | NSFC-003      | AEBC-NSF2122         | 8               | National Skills Fund Administration Expenditure        | 0.00         | 2775.29      |
    #
    | 10018003 | 2122          | Final         | ALLBC2122           | ALLC-003      | ALLBC2122            | 2               | Loans - Bursary Funding                                | 0.00         | 2597.84      |
    | 10018003 | 2122          | Final         | ALLBC2122           | ALLC-003      | ALLBC2122            | 3               | Loans - Area Costs                                     | 0.00         | 2851.79      |
    | 10018003 | 2122          | Final         | ALLBC2122           | ALLC-003      | ALLBC2122            | 4               | Loans - Excess Claims                                  | 0.00         | 2884.59      |
    | 10018003 | 2122          | Final         | ALLBC2122           | ALLC-003      | ALLBC2122            | 5               | Loans - Hardship                                       | 0.00         | 2561.84      |
    | 10018003 | 2122          | Final         | ALLBC2122           | ALLC-003      | ALLBC2122            | 6               | Loans - Childcare                                      | 0.00         | 2990.64      |
    | 10018003 | 2122          | Final         | ALLBC2122           | ALLC-003      | ALLBC2122            | 7               | Loans - Residential Access Fund                        | 0.00         | 2585.69      |
    | 10018003 | 2122          | Final         | ALLBC2122           | ALLC-003      | ALLBC2122            | 8               | Loans - Administration Expenditure                     | 0.00         | 2935.39      |





    # Part 4: Update FCR and check CRM

    # Change the date 
    Given the override date is '20/10/2022'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither. In this case, both ... 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10018003 | 2122          | Final         | AEBC-19TRN2122      | 2                  | AECT-003      | 21854.00     | 20009.81     | -1844.19                    | -1658.54            | 20009.81         | -410.24         | Ineligible Data       |
    | 10018003 | 2122          | Final         | AEBC-ASCL2122       | 2                  | AECA-003      | 35651.00     | 32914.56     | -2736.44                    | -2717.05            | 32914.56         | 274.35          | Claim Error           |
    | 10018003 | 2122          | Final         | AEBC-NSF2122        | 2                  | NSFC-003      | 17995.00     | 16579.17     | -1415.83                    | -1295.89            | 16579.17         | -358.45         | Other                 |
    | 10018003 | 2122          | Final         | ALLBC2122           | 2                  | ALLC-003      | 20478.00     | 19407.78     | -1070.22                    | -1198.38            | 19407.78         | 88.88           | Ineligible Data       |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018003 | 2122          | Final         | AEBC-19TRN2122      | 2                  | 21854.00     | 20009.81     | -2254.43                    | -1658.54            | 20009.81         | -410.24         | 19599.57                 | Draft      |
    | 10018003 | 2122          | Final         | AEBC-ASCL2122       | 2                  | 35651.00     | 32914.56     | -2462.09                    | -2717.05            | 32914.56         | 274.35          | 33188.91                 | Draft      |
    | 10018003 | 2122          | Final         | AEBC-NSF2122        | 2                  | 17995.00     | 16579.17     | -1774.28                    | -1295.89            | 16579.17         | -358.45         | 16220.72                 | Draft      |
    | 10018003 | 2122          | Final         | ALLBC2122           | 2                  | 20478.00     | 19407.78     | -981.34                     | -1198.38            | 19407.78         | 88.88           | 19496.66                 | Draft      |
 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018003 | 2122          | Final         | AEBC-19TRN2122      | AECT-003      | 21854.00     | 20009.81     | -2254.43                    | -1658.54            | 20009.81         | -410.24         | Ineligible Data       | 19599.57                 |
    | 10018003 | 2122          | Final         | AEBC-ASCL2122       | AECA-003      | 35651.00     | 32914.56     | -2462.09                    | -2717.05            | 32914.56         | 274.35          | Claim Error           | 33188.91                 |
    | 10018003 | 2122          | Final         | AEBC-NSF2122        | NSFC-003      | 17995.00     | 16579.17     | -1774.28                    | -1295.89            | 16579.17         | -358.45         | Other                 | 16220.72                 |
    | 10018003 | 2122          | Final         | ALLBC2122           | ALLC-003      | 20478.00     | 19407.78     | -981.34                     | -1198.38            | 19407.78         | 88.88           | Ineligible Data       | 19496.66                 |





    # Part 5: Publish FCR. Check CRM and feed

    # Change the date
    Given the override date is '22/10/2022'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2122-Final' and Allocation Group Code 'ALLBC2122'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2122-Final' and Allocation Group Code 'ALLBC2122'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018003 | 2122          | Final         | AEBC-19TRN2122      | 2                  |
    | 10018003 | 2122          | Final         | AEBC-ASCL2122       | 2                  |
    | 10018003 | 2122          | Final         | AEBC-NSF2122        | 2                  |
    | 10018003 | 2122          | Final         | ALLBC2122           | 2                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018003 | 2122          | Final         | AEBC-19TRN2122      | 2                  |
    | 10018003 | 2122          | Final         | AEBC-ASCL2122       | 2                  |
    | 10018003 | 2122          | Final         | AEBC-NSF2122        | 2                  |
    | 10018003 | 2122          | Final         | ALLBC2122           | 2                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018003 | 2122          | Final         | AEBC-19TRN2122      | 2                  |
    | 10018003 | 2122          | Final         | AEBC-ASCL2122       | 2                  |
    | 10018003 | 2122          | Final         | AEBC-NSF2122        | 2                  |
    | 10018003 | 2122          | Final         | ALLBC2122           | 2                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                       | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10018003 | ALLC-003         | 2122   | Final      | Advanced Learner Loans Bursary (Grant) 21/22              | 20478.00     | 19407.78     | -981.34                     | -1198.38                 | 19407.78           | 88.88           | Ineligible Data       | 19496.66                 |
    | 10018003 | AECT-003         | 2122   | Final      | AEB (Grant) - 19 to 24 Traineeships 21/22                 | 21854.00     | 20009.81     | -2254.43                    | -1658.54                 | 20009.81           | -410.24         | Ineligible Data       | 19599.57                 |
    | 10018003 | AECA-003         | 2122   | Final      | AEB (Grant) - Adult Skills and Community Learning 21/22   | 35651.00     | 32914.56     | -2462.09                    | -2717.05                 | 32914.56           | 274.35          | Claim Error           | 33188.91                 |
    | 10018003 | NSFC-003         | 2122   | Final      | AEB (Grant) - National Skills Fund 21/22                  | 17995.00     | 16579.17     | -1774.28                    | -1295.89                 | 16579.17           | -358.45         | Other                 | 16220.72                 |


    # Tidy up
    Given the override date is reset


@AcceptanceTest @Withdrawn20231002
@FundingClaims
Scenario: S005 Create and approve an EDSK2122 contract with all four FCR allocs. Process Final Funding Claim ABOVE profile. Amend contract. Publish claim. Check CRM and financials

    # 1. Create and approve and EDSK2122 with all four FCR allocs
    # 2. Populate stub with Claim data
    # 3. Consume stub data and check CRM
    # 4. Update FCR and check CRM
    # 5. Bulk amend and approve the contract to change the Profile values and force a recalc
    # 6. Publish and Approve contract v2 and check financials
    # 7. Publish the FCR. Check CRM and feed

    Given there are no allocations marked as Under Termination for UKPRN '10018005' 
    And   there are no terminated or closed allocations for UKPRN '10018005' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018005' 
    And   there are no notifications in CRM of type 'Amendment Approval' for UKPRN '10018005' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018005' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-005      |
    | AECT-005      |
    | ALLC-005      |
    | NSFC-005      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-005      |
    | AECT-005      |
    | ALLC-005      |
    | NSFC-005      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-19TRN2122    |
    | AEBC-ASCL2122     |
    | AEBC-NSF2122      |
    | ALLBC2122         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-005       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018005'

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECA-005      |
    | AECT-005      |
    | ALLC-005      |
    | NSFC-005      |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Final      | 1718   |
    | Final      | 1819   |
    | Final      | 1920   |
    | Final      | 2021   |
    | Final      | 2122   |
    | Final      | 1718   |
    | Final      | 1819   |
    | Final      | 1920   |
    | Final      | 2021   |
    | Final      | 2122   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10018005 |

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    Given there is no data in the Reconciliation Profiling table for UKPRN '10018005' and FundingPeriod 'AY2122'

 #  # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
 #  And   the Reconciliation Profiling table includes a row for UKPRN '10018005' and FundingPeriod 'AY2122'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018005' 
    And   there is no caseload advisor for UKPRN '10018005' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018005 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018005' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018005 Co Ltd' with UKPRN '10018005' and OrgId 'ORG0018005' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018005 | 118005 | 10018005 Co Ltd | 0              | Active                | Yes           | AA018005      | ?             | 244 The Quardrant      | Aztec West             | Almondsbury            | Bristol                | ?                      | ?                      | BS32 4AQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018005 |





    # Part 1: Create and approve and EDSK2122 with all four FCR allocs
    
    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-005'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-005'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018005 | 10018005 Co Ltd      | ESFA-005             | EDSK-005       | 1                     | 01/08/2021        | 31/07/2022      | 110438.00     |                                       | Conditions of Funding (Grant) (LA)         | 2122   | New          | ORG0018005 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018005 | EDSK-005       | AECA-005      | AEBC-ASCL         | AEBC-ASCL2122           | AY                      | 01/08/2021          | 31/07/2022        | 43562.00        |                                         |            |                                                             | New          |             |
    | 10018005 | EDSK-005       | AECT-005      | AEBC-19TRN        | AEBC-19TRN2122          | AY                      | 01/08/2021          | 31/07/2022        | 22055.00        |                                         |            |                                                             | New          |             |
    | 10018005 | EDSK-005       | ALLC-005      | ALLBC             | ALLBC2122               | AY                      | 01/08/2021          | 31/07/2022        | 17573.00        |                                         |            |                                                             | New          |             |
    | 10018005 | EDSK-005       | NSFC-005      | AEBC-NSF          | AEBC-NSF2122            | AY                      | 01/08/2021          | 31/07/2022        | 27248.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10018005 | EDSK-005       | AECA-005      | 1               | 0                     | 43562.00  | 26542.00  | 17020.00  | 2016.00  | 2634.00  | 1764.00  | 4373.00  | 2966.00  | 2506.00  | 3884.00  | 6399.00  | 1572.00  | 5703.00  | 3662.00  | 6083.00  | Adult Skills and Community Learning Total Funding               | New          |             | 
    | 10018005 | EDSK-005       | AECA-005      | 2               | 1                     | 18053.00  | 12511.00  | 5542.00   | 1548.00  | 323.00   | 298.00   | 3090.00  | 2117.00  | 353.00   | 1944.00  | 2838.00  | 155.00   | 2537.00  | 76.00    | 2774.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10018005 | EDSK-005       | AECA-005      | 5               | 1                     | 25509.00  | 14031.00  | 11478.00  | 468.00   | 2311.00  | 1466.00  | 1283.00  | 849.00   | 2153.00  | 1940.00  | 3561.00  | 1417.00  | 3166.00  | 3586.00  | 3309.00  | Community Learning                                              | New          |             | 
    | 10018005 | EDSK-005       | AECT-005      | 1               | 0                     | 22055.00  | 12384.00  | 9671.00   | 98.00    | 325.00   | 1378.00  | 2904.00  | 3008.00  | 3680.00  | 681.00   | 310.00   | 2406.00  | 3522.00  | 1155.00  | 2588.00  | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10018005 | EDSK-005       | ALLC-005      | 1               | 0                     | 17573.00  | 11537.00  | 6036.00   | 2914.00  | 2509.00  | 1758.00  | 310.00   | 952.00   | 992.00   | 873.00   | 1229.00  | 161.00   | 3363.00  | 176.00   | 2336.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             | 
    | 10018005 | EDSK-005       | NSFC-005      | 1               | 0                     | 27248.00  | 19547.00  | 7701.00   | 1936.00  | 1882.00  | 3028.00  | 3290.00  | 3488.00  | 2895.00  | 973.00   | 2055.00  | 1526.00  | 395.00   | 2806.00  | 2974.00  | Total 16-18 Traineeships Funding                                | New          |             | 
    | 10018005 | EDSK-005       | NSFC-005      | 2               | 1                     | 27248.00  | 19547.00  | 7701.00   | 1936.00  | 1882.00  | 3028.00  | 3290.00  | 3488.00  | 2895.00  | 973.00   | 2055.00  | 1526.00  | 395.00   | 2806.00  | 2974.00  | Level 3 Offer for 24 year olds and over                         | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-005'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-005' and ContractNumber 'EDSK-005' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-005' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018005 | EDSK-005           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10018005 | ESFA-005           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-005' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '192' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '192' deliverable period rows in CRM linked to the latest version of contract 'EDSK-005'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECT-005        | 2355775          | Jul-22 | Reconciliation |
    | AECA-005        | 2371175          | Jul-22 | Reconciliation |
    | NSFC-005        | 100946           | Jul-22 | Reconciliation |
    | ALLC-005        | 2303975          | Jul-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '7' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10018005 | EDSK-005       | 1               | AECA-005      | 1               | 0                     | 43562.00     | 0             | 0        | Adult Skills and Community Learning Total Funding               | ?                                                           |
    | 10018005 | EDSK-005       | 1               | AECA-005      | 2               | 1                     | 18053.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
    | 10018005 | EDSK-005       | 1               | AECA-005      | 5               | 1                     | 25509.00     | 0             | 0        | Community Learning                                              | ?                                                           |
    | 10018005 | EDSK-005       | 1               | AECT-005      | 1               | 0                     | 22055.00     | 0             | 0        | 19-24 Traineeships Total Funding                                | ?                                                           |
    | 10018005 | EDSK-005       | 1               | ALLC-005      | 1               | 0                     | 17573.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding                    | ?                                                           |
    | 10018005 | EDSK-005       | 1               | NSFC-005      | 1               | 0                     | 27248.00     | 0             | 0        | Total 16-18 Traineeships Funding                                | ?                                                           |
    | 10018005 | EDSK-005       | 1               | NSFC-005      | 2               | 1                     | 27248.00     | 0             | 0        | Level 3 Offer for 24 year olds and over                         | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-005' agree with the most recent entry for this contract in the ContractManagement feed





    # Part 2: Populate stub with Claim data

    # Change the date
    Given the override date is '16/06/2022'

    #Set up claim data from SLD for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0018005     | 10018005 | 1                  | Final	     | AY             | 2122   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0018005     | 10018005 | 1                  | Final    	 | AY             | 2122   | AECT-005      | AEBC-19TRN2122          |
    | ORG0018005     | 10018005 | 1                  | Final 	     | AY             | 2122   | AECA-005      | AEBC-ASCL2122           |
    | ORG0018005     | 10018005 | 1                  | Final 	     | AY             | 2122   | NSFC-005      | AEBC-NSF2122            |
    | ORG0018005     | 10018005 | 1                  | Final 	     | AY             | 2122   | ALLC-005      | ALLBC2122               |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | AECT-005      | 2               | 3750.00     | 72.71         | 13.82           | 3836.53    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | AECT-005      | 3               | 4021.00     | 62.26         | 10.19           | 4093.45    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | AECT-005      | 5               | 3812.00     | 55.07         | 13.60           | 3880.67    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | AECT-005      | 6               | 3847.00     | 60.76         | 14.13           | 3921.89    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | AECT-005      | 7               | 3692.00     | 61.77         | 13.86           | 3767.63    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | AECT-005      | 8               | 3853.00     | 39.17         | 12.74           | 3904.91    |
    #                                                                                                                                                                           £ 23405.08  
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | AECA-005      | 3               | 5953.00     | 65.28         | 5.10            | 6023.38    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | AECA-005      | 4               | 5705.00     | 28.26         | 10.00           | 5743.26    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | AECA-005      | 5               | 5532.00     | 62.17         | 14.01           | 5608.18    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | AECA-005      | 6               | 6190.00     | 43.12         | 12.39           | 6245.51    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | AECA-005      | 7               | 6157.00     | 43.66         | 6.06            | 6206.72    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | AECA-005      | 8               | 5760.00     | 52.51         | 12.34           | 5824.85    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | AECA-005      | 9               | 5519.00     | 49.21         | 8.45            | 5576.66    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | AECA-005      | 10              | 5710.00     | 56.91         | 6.33            | 5773.24    |
    #                                                                                                                                                                           £ 47001.80  
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | NSFC-005      | 3               | 5069.00     | 32.81         | 5.27            | 5107.08    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | NSFC-005      | 4               | 4920.00     | 73.93         | 8.75            | 5002.68    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | NSFC-005      | 5               | 4634.00     | 34.16         | 9.82            | 4677.98    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | NSFC-005      | 6               | 5196.00     | 41.70         | 14.75           | 5252.45    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | NSFC-005      | 7               | 4689.00     | 59.38         | 11.15           | 4759.53    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | NSFC-005      | 8               | 5222.00     | 64.07         | 8.19            | 5294.26    |
    #                                                                                                                                                                           £ 30093.98  
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | ALLC-005      | 2               | 2886.00     | 38.51         | 14.60           | 2939.11    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | ALLC-005      | 3               | 2535.00     | 33.12         | 13.12           | 2581.24    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | ALLC-005      | 4               | 2693.00     | 39.49         | 8.38            | 2740.87    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | ALLC-005      | 5               | 2885.00     | 27.91         | 9.53            | 2922.44    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | ALLC-005      | 6               | 2678.00     | 30.66         | 11.10           | 2719.76    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | ALLC-005      | 7               | 2005.00     | 49.87         | 7.12            | 2689.99    |
    | ORG0018005     | 10018005 | 1                  | Final      | AY             | 2122   | ALLC-005      | 8               | 2818.00     | 46.74         | 7.17            | 2871.91    |
    #                                                                                                                                                                           £ 19465.32  





    # Part 3: Consume stub data and check CRM

    # Change the date
    Given the override date is '18/06/2022'

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018005 | 2122          | Final         | AEBC-19TRN2122      | 1                  | 22055.00     | 23405.08     | 1350.08                     | 1350.08             | 23405.08         | 0.00            | 23405.08                 | Draft      |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | 1                  | 43562.00     | 47001.80     | 3439.80                     | 3439.80             | 47001.80         | 0.00            | 47001.80                 | Draft      |
    | 10018005 | 2122          | Final         | AEBC-NSF2122        | 1                  | 27248.00     | 30093.98     | 2724.80                     | 2724.80             | 30093.98         | 0.00            | 30093.98                 | Draft      |
    | 10018005 | 2122          | Final         | ALLBC2122           | 1                  | 17573.00     | 19465.32     | 0.00                        | 0.00                | 19465.32         | 0.00            | 19465.32                 | Draft      |
 
    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018005 | 2122          | Final         | AEBC-19TRN2122      | AECT-005      | 22055.00     | 23405.08     | 1350.08                     | 1350.08             | 23405.08         | 0.00            | ?                     | 23405.08                 |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | AECA-005      | 43562.00     | 47001.80     | 3439.80                     | 3439.80             | 47001.80         | 0.00            | ?                     | 47001.80                 |
    | 10018005 | 2122          | Final         | AEBC-NSF2122        | NSFC-005      | 27248.00     | 30093.98     | 2724.80                     | 2724.80             | 30093.98         | 0.00            | ?                     | 30093.98                 |
    | 10018005 | 2122          | Final         | ALLBC2122           | ALLC-005      | 17573.00     | 19465.32     | 0.00                        | 0.00                | 19465.32         | 0.00            | ?                     | 19465.32                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10018005 | 2122          | Final         | AEBC-19TRN2122      | AECT-005      | AEBC-19TRN2122       | 2               | 19-24 Traineeships Programme Funding                   | 0.00         | 3836.53      |
    | 10018005 | 2122          | Final         | AEBC-19TRN2122      | AECT-005      | AEBC-19TRN2122       | 3               | 19-24 Traineeships Learning Support                    | 0.00         | 4093.45      |
    | 10018005 | 2122          | Final         | AEBC-19TRN2122      | AECT-005      | AEBC-19TRN2122       | 5               | 19-24 Traineeships Admin Expenditure                   | 0.00         | 3880.67      |
    | 10018005 | 2122          | Final         | AEBC-19TRN2122      | AECT-005      | AEBC-19TRN2122       | 6               | 19-24 Traineeships 19+ Hardship                        | 0.00         | 3921.89      |
    | 10018005 | 2122          | Final         | AEBC-19TRN2122      | AECT-005      | AEBC-19TRN2122       | 7               | 19-24 Traineeships 20+ Childcare                       | 0.00         | 3767.63      |
    | 10018005 | 2122          | Final         | AEBC-19TRN2122      | AECT-005      | AEBC-19TRN2122       | 8               | 19-24 Traineeships Residential Access Funding          | 0.00         | 3904.91      |
    #
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | AECA-005      | AEBC-ASCL-2122       | 3               | Adult Skills Programme Funding                         | 0.00         | 6023.38      |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | AECA-005      | AEBC-ASCL-2122       | 4               | Adult Skills Learning Support                          | 0.00         | 5743.26      |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | AECA-005      | AEBC-ASCL-2122       | 5               | Community Learning                                     | 25509.00     | 5608.18      |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | AECA-005      | AEBC-ASCL-2122       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 6245.51      |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | AECA-005      | AEBC-ASCL-2122       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 6206.72      |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | AECA-005      | AEBC-ASCL-2122       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 5824.85      |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | AECA-005      | AEBC-ASCL-2122       | 9               | Adult Skills Administration Expenditure                | 0.00         | 5576.66      |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | AECA-005      | AEBC-ASCL-2122       | 10              | Learner Support - COVID-19 Response                    | 0.00         | 5773.24      |
    #
    | 10018005 | 2122          | Final         | AEBC-NSF2122        | NSFC-005      | AEBC-NSF2122         | 3               | National Skills Fund Programme Funding                 | 0.00         | 5107.08      |
    | 10018005 | 2122          | Final         | AEBC-NSF2122        | NSFC-005      | AEBC-NSF2122         | 4               | National Skills Fund Learning Support                  | 0.00         | 5002.68      |
    | 10018005 | 2122          | Final         | AEBC-NSF2122        | NSFC-005      | AEBC-NSF2122         | 5               | National Skills Fund 19+ Hardship                      | 0.00         | 4677.98      |
    | 10018005 | 2122          | Final         | AEBC-NSF2122        | NSFC-005      | AEBC-NSF2122         | 6               | National Skills Fund 20+ Childcare                     | 0.00         | 5252.45      |
    | 10018005 | 2122          | Final         | AEBC-NSF2122        | NSFC-005      | AEBC-NSF2122         | 7               | National Skills Fund Residential Access Funding        | 0.00         | 4759.53      |
    | 10018005 | 2122          | Final         | AEBC-NSF2122        | NSFC-005      | AEBC-NSF2122         | 8               | National Skills Fund Administration Expenditure        | 0.00         | 5294.26      |
    #
    | 10018005 | 2122          | Final         | ALLBC2122           | ALLC-005      | ALLBC2122            | 2               | Loans - Bursary Funding                                | 0.00         | 2939.11      |
    | 10018005 | 2122          | Final         | ALLBC2122           | ALLC-005      | ALLBC2122            | 3               | Loans - Area Costs                                     | 0.00         | 2581.24      |
    | 10018005 | 2122          | Final         | ALLBC2122           | ALLC-005      | ALLBC2122            | 4               | Loans - Excess Claims                                  | 0.00         | 2740.87      |
    | 10018005 | 2122          | Final         | ALLBC2122           | ALLC-005      | ALLBC2122            | 5               | Loans - Hardship                                       | 0.00         | 2922.44      |
    | 10018005 | 2122          | Final         | ALLBC2122           | ALLC-005      | ALLBC2122            | 6               | Loans - Childcare                                      | 0.00         | 2719.76      |
    | 10018005 | 2122          | Final         | ALLBC2122           | ALLC-005      | ALLBC2122            | 7               | Loans - Residential Access Fund                        | 0.00         | 2689.99      |
    | 10018005 | 2122          | Final         | ALLBC2122           | ALLC-005      | ALLBC2122            | 8               | Loans - Administration Expenditure                     | 0.00         | 2871.91      |





    # Part 4: Update FCR and check CRM

    # Change the date 
    Given the override date is '20/06/2022'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither. In this case, both ... 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10018005 | 2122          | Final         | AEBC-19TRN2122      | 1                  | AECT-005      | 22055.00     | 23405.08     | 1670.30                     | -101.86             | 23405.08         | 320.22          | Claim Error           |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | 1                  | AECA-005      | 43562.00     | 47001.80     | 3814.76                     | -133.98             | 47001.80         | 374.96          | Other                 |
    | 10018005 | 2122          | Final         | AEBC-NSF2122        | 1                  | NSFC-005      | 27248.00     | 30093.98     | 2553.68                     | 135.91              | 30093.98         | -292.30         | Other                 |
    | 10018005 | 2122          | Final         | ALLBC2122           | 1                  | ALLC-005      | 17573.00     | 19465.32     | 0.00                        | 100.52              | 19465.32         | 137.17          | Other                 |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018005 | 2122          | Final         | AEBC-19TRN2122      | 1                  | 22055.00     | 23405.08     | 1670.30                     | -101.86             | 23405.08         | 320.22          | 23725.30                 | Draft      |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | 1                  | 43562.00     | 47001.80     | 3814.76                     | -133.98             | 47001.80         | 374.96          | 47376.76                 | Draft      |
    | 10018005 | 2122          | Final         | AEBC-NSF2122        | 1                  | 27248.00     | 30093.98     | 2553.68                     | 135.91              | 30093.98         | -292.30         | 29801.68                 | Draft      |
    | 10018005 | 2122          | Final         | ALLBC2122           | 1                  | 17573.00     | 19465.32     | 0.00                        | 100.52              | 19465.32         | 137.17          | 19602.49                 | Draft      |
 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018005 | 2122          | Final         | AEBC-19TRN2122      | AECT-005      | 22055.00     | 23405.08     | 1670.30                     | -101.86             | 23405.08         | 320.22          | Claim Error           | 23725.30                 |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | AECA-005      | 43562.00     | 47001.80     | 3814.76                     | -133.98             | 47001.80         | 374.96          | Other                 | 47376.76                 |
    | 10018005 | 2122          | Final         | AEBC-NSF2122        | NSFC-005      | 27248.00     | 30093.98     | 2553.68                     | 135.91              | 30093.98         | -292.30         | Other                 | 29801.68                 |
    | 10018005 | 2122          | Final         | ALLBC2122           | ALLC-005      | 17573.00     | 19465.32     | 0.00                        | 100.52              | 19465.32         | 137.17          | Other                 | 19602.49                 |





    # Part 5: Bulk amend the contract to change the Profile values and force a recalc

    # Change the date
    Given the override date is '24/06/2022'

    # Bulk file to update Profile values
    And   there are no files prefixed '10018005' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2122 04052022084106 v3_S005' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2122 04052022084106 v3_S005' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2122 04052022084106 v3_S005' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2122 04052022084106 v3_S005' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2122 04052022084106 v3_S005.xlsx' exists in the Datafiles folder and UKPRN '10018005' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Part 6: Publish and Approve contract v2 and check financials
    
    # Change the date
    Given the override date is '25/06/2022'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-005'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-005' and ContractNumber 'EDSK-005' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-005' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018005 | EDSK-005           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10018005 | EDSK-005           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10018005 | ESFA-005           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'EDSK-005' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '192' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '192' deliverable period rows in CRM linked to the latest version of contract 'EDSK-005'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECT-005        | 2355775          | Jul-22 | Reconciliation |
    | AECA-005        | 2371175          | Jul-22 | Reconciliation |
    | NSFC-005        | 100946           | Jul-22 | Reconciliation |
    | ALLC-005        | 2303975          | Jul-22 | Reconciliation |


    # Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-005       | AECA-005           | 1               | 43891.00  | 6488.00  | 1892.00  | 1522.00  | 3395.00  | 10011.00 | 3213.00  | 2897.00  | 4120.00  | 2614.00  | 2492.00  | 1708.00  | 3539.00  | 
    | EDSK-005       | AECA-005           | 2               | 23272.00  | 4433.00  | 1355.00  | 591.00   | 1707.00  | 4421.00  | 1217.00  | 1843.00  | 2852.00  | 1036.00  | 644.00   | 661.00   | 2512.00  | 
    | EDSK-005       | AECA-005           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-005       | AECA-005           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-005       | AECA-005           | 5               | 20619.00  | 2055.00  | 537.00   | 931.00   | 1688.00  | 5590.00  | 1996.00  | 1054.00  | 1268.00  | 1578.00  | 1848.00  | 1047.00  | 1027.00  | 
    | EDSK-005       | AECT-005           | 1               | 22253.00  | 1460.00  | 2709.00  | 1851.00  | 1376.00  | 2964.00  | 1087.00  | 718.00   | 1036.00  | 1983.00  | 4030.00  | 1939.00  | 1100.00  | 
    | EDSK-005       | AECT-005           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-005       | AECT-005           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-005       | ALLC-005           | 1               | 17826.00  | 1057.00  | 1654.00  | 1024.00  | 1014.00  | 1647.00  | 1314.00  | 1225.00  | 1048.00  | 2002.00  | 1043.00  | 1924.00  | 2874.00  | 
    | EDSK-005       | ALLC-005           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-005       | ALLC-005           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-005       | ALLC-005           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-005       | NSFC-005           | 1               | 26991.00  | 81.00    | 1236.00  | 3786.00  | 1185.00  | 1101.00  | 4179.00  | 1119.00  | 2249.00  | 4635.00  | 1525.00  | 2905.00  | 2990.00  | 
    | EDSK-005       | NSFC-005           | 2               | 26991.00  | 81.00    | 1236.00  | 3786.00  | 1185.00  | 1101.00  | 4179.00  | 1119.00  | 2249.00  | 4635.00  | 1525.00  | 2905.00  | 2990.00  | 
    | EDSK-005       | NSFC-005           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-005       | NSFC-005           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Jul-22   |
    | EDSK-005       | AECA-005           | 1               | 0.00     | 
    | EDSK-005       | AECA-005           | 2               | 5481.00  | 
    | EDSK-005       | AECA-005           | 3               | 0.00     | 
    | EDSK-005       | AECA-005           | 4               | 0.00     | 
    | EDSK-005       | AECA-005           | 5               | -2608.00 | 
    #
    | EDSK-005       | AECT-005           | 1               | 1686.00  | 
    | EDSK-005       | AECT-005           | 2               | 0.00     | 
    | EDSK-005       | AECT-005           | 3               | 0.00     | 
    #
    | EDSK-005       | ALLC-005           | 1               | -285.00  | 
    | EDSK-005       | ALLC-005           | 2               | 0.00     | 
    | EDSK-005       | ALLC-005           | 3               | 0.00     | 
    | EDSK-005       | ALLC-005           | 4               | 0.00     | 
    #
    | EDSK-005       | NSFC-005           | 1               | 0.00     | 
    | EDSK-005       | NSFC-005           | 2               | -273.00  | 
    | EDSK-005       | NSFC-005           | 3               | 0.00     | 
    | EDSK-005       | NSFC-005           | 4               | 0.00     | 


	# Check FCR values
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018005 | 2122          | Final         | AEBC-19TRN2122      | 1                  | 22253.00     | 23405.08     | 1472.30                     | -101.86             | 23405.08         | 320.22          | 23725.30                 | Draft      |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | 1                  | 43891.00     | 47001.80     | 3485.76                     | -133.98             | 47001.80         | 374.96          | 47376.76                 | Draft      |
    | 10018005 | 2122          | Final         | AEBC-NSF2122        | 1                  | 26991.00     | 30093.98     | 2699.10                     | 135.91              | 30093.98         | -292.30         | 29801.68                 | Draft      |
    | 10018005 | 2122          | Final         | ALLBC2122           | 1                  | 17826.00     | 19465.32     | 0.00                        | 100.52              | 19465.32         | 137.17          | 19602.49                 | Draft      |
    


        

    # Part 7: Publish the FCR. Check CRM and feed

	# Change the date
    Given the override date is '25/06/2022'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2122-Final' and Allocation Group Code 'AEB-LS1819'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2122-Final' and Allocation Group Code 'AEBC-19TRN2122'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2122-Final' and Allocation Group Code 'AEBC-ASCL2122'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2122-Final' and Allocation Group Code 'AEBC-NSF2122'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2122-Final' and Allocation Group Code 'ALLBC2122'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2122-Final' and Allocation Group Code 'ALLBC2122'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2122-Final' and Allocation Group Code 'ALLBC2122'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018005 | 2122          | Final         | AEBC-19TRN2122      | 1                  |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | 1                  |
    | 10018005 | 2122          | Final         | AEBC-NSF2122        | 1                  |
    | 10018005 | 2122          | Final         | ALLBC2122           | 1                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018005 | 2122          | Final         | AEBC-19TRN2122      | 1                  |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | 1                  |
    | 10018005 | 2122          | Final         | AEBC-NSF2122        | 1                  |
    | 10018005 | 2122          | Final         | ALLBC2122           | 1                  |

    And   group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018005 | 2122          | Final         | AEBC-19TRN2122      | 1                  | 22253.00     | 23405.08     | 1472.30                     | -101.86             | 23405.08         | 320.22          | 23725.30                 | Published  |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | 1                  | 43891.00     | 47001.80     | 3485.76                     | -133.98             | 47001.80         | 374.96          | 47376.76                 | Published  |
    | 10018005 | 2122          | Final         | AEBC-NSF2122        | 1                  | 26991.00     | 30093.98     | 2699.10                     | 135.91              | 30093.98         | -292.30         | 29801.68                 | Published  |
    | 10018005 | 2122          | Final         | ALLBC2122           | 1                  | 17826.00     | 19465.32     | 0.00                        | 100.52              | 19465.32         | 137.17          | 19602.49                 | Published  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018005 | 2122          | Final         | AEBC-19TRN2122      | 1                  |
    | 10018005 | 2122          | Final         | AEBC-ASCL2122       | 1                  |
    | 10018005 | 2122          | Final         | AEBC-NSF2122        | 1                  |
    | 10018005 | 2122          | Final         | ALLBC2122           | 1                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                       | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10018005 | AECT-005         | 2122   | Final      | AEB (Grant) - 19 to 24 Traineeships 21/22                 | 22253.00     | 23405.08     | 1472.30                     | -101.86                  | 23405.08           | 320.22          | Claim Error           | 23725.30                 |
    | 10018005 | AECA-005         | 2122   | Final      | AEB (Grant) - Adult Skills and Community Learning 21/22   | 43891.00     | 47001.80     | 3485.76                     | -133.98                  | 47001.80           | 374.96          | Other                 | 47376.76                 |
    | 10018005 | NSFC-005         | 2122   | Final      | AEB (Grant) - National Skills Fund 21/22                  | 26991.00     | 30093.98     | 2699.10                     | 135.91                   | 30093.98           | -292.30         | Other                 | 29801.68                 |
    | 10018005 | ALLC-005         | 2122   | Final      | Advanced Learner Loans Bursary (Grant) 21/22              | 17826.00     | 19465.32     | 0.00                        | 100.52                   | 19465.32           | 137.17          | Other                 | 19602.49                 |
     

    # Tidy up
    Given the override date is reset
 
 
@AcceptanceTest @Withdrawn20231002
@FundingClaims
Scenario: S006 Create and approve an EDSK contract with an AEBC-ASCL2122 alloc. Process a Final Funding Claim with D5. Deliver nothing. Publish. Clawback everything but staggered recovery in 4 months. 
    Given there are no allocations marked as Under Termination for UKPRN '10018006' 
    And   there are no terminated or closed allocations for UKPRN '10018006' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018006' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018006' 
 
    # Clear down ContractRequest.FundingAllocationRelease table (J146). 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018006' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-006      |

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECA-006      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-006      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-ASCL2122     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-006       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018006'

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Year End      | 1920   |
    | Year End      | 2021   |
	| Year End      | 2122   |
    | Final         | 1718   |
    | Final         | 1819   |
    | Final         | 1920   |
    | Final         | 2021   |
	| Final         | 2122   |
	
	

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10018006 |

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    Given there is no data in the Reconciliation Profiling table for UKPRN '10018006' and FundingPeriod 'AY2122'

   # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
    And   the Reconciliation Profiling table includes a row for UKPRN '10018006' and FundingPeriod 'AY2122'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018006' 
    And   there is no caseload advisor for UKPRN '10018006' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018006 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018006' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018006 Co Ltd' with UKPRN '10018006' and OrgId 'ORG0018006' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018006 | 118006 | 10018006 Co Ltd | 0              | Active                | Yes           | AA018006      | ?             | 41 Send Barns Lane     | Send                   | Woking                 | ?                      | ?                      | Surrey                 | GU23 7BS  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018006 |



    # Part 1: Create and approve and EDSK2122 with one FCR allocs

    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-006'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-006'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018006 | 10018006 Co Ltd      | ESFA-006             | EDSK-006       | 1                     | 01/08/2021        | 31/07/2022      | 46756.00      |                                       | Conditions of Funding (Grant) (LA)         | 2122   | New          | ORG0018006 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018006 | EDSK-006       | AECA-006      | AEBC-ASCL         | AEBC-ASCL2122           | AY                      | 01/08/2021          | 31/07/2022        | 46756.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10018006 | EDSK-006       | AECA-006      | 1               | 0                     | 46756.00  | 28797.00  | 17959.00  | 6110.00  | 4608.00  | 1713.00  | 2014.00  | 2093.00  | 5557.00  | 2568.00  | 4134.00  | 4119.00  | 5147.00  | 4782.00  | 3911.00  | Adult Skills and Community Learning Total Funding               | New          |             | 
    | 10018006 | EDSK-006       | AECA-006      | 2               | 1                     | 18779.00  | 10388.00  | 8391.00   | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | Adult Skills Total Funding                                      | New          |             | 
    | 10018006 | EDSK-006       | AECA-006      | 5               | 1                     | 27977.00  | 18409.00  | 9568.00   | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | Community Learning                                              | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-006'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
   #When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-006' and actual ContractNumber 'EDSK-006'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-006' and ContractNumber 'EDSK-006' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-006' has a substatus of 'Approved'





    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018006 | EDSK-006           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10018006 | ESFA-006           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-006' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'EDSK-006'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECA-006        | 2371175          | Jul-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10018006 | EDSK-006       | 1               | AECA-006      | 1               | 0                     | 46756.00     | 0             | 0        | Adult Skills and Community Learning Total Funding               | ?                                                           |
    | 10018006 | EDSK-006       | 1               | AECA-006      | 2               | 1                     | 18779.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
    | 10018006 | EDSK-006       | 1               | AECA-006      | 5               | 1                     | 27977.00     | 0             | 0        | Community Learning                                              | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-006' agree with the most recent entry for this contract in the ContractManagement feed


    


    # Funding Claims ...
    
    # Populate stub with Claim data

    # Change the date
    Given the override date is '14/11/2022'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0018006     | 10018006 | 2                  | Final         | AY             | 2122   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0018006     | 10018006 | 2                  | Final         | AY             | 2122   | AECA-006      | AEBC-ASCL2122           |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0018006     | 10018006 | 2                  | Final         | AY             | 2122   | AECA-006      | 3               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018006     | 10018006 | 2                  | Final         | AY             | 2122   | AECA-006      | 4               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018006     | 10018006 | 2                  | Final         | AY             | 2122   | AECA-006      | 5               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018006     | 10018006 | 2                  | Final         | AY             | 2122   | AECA-006      | 6               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018006     | 10018006 | 2                  | Final         | AY             | 2122   | AECA-006      | 7               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018006     | 10018006 | 2                  | Final         | AY             | 2122   | AECA-006      | 8               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018006     | 10018006 | 2                  | Final         | AY             | 2122   | AECA-006      | 9               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018006     | 10018006 | 2                  | Final         | AY             | 2122   | AECA-006      | 10              | 0.00        | 0.00          | 0.00            | 0.00       |
    #                                                                                                                                                                            £ 0.00  





    # Consume stub data

    # Change the date
    Given the override date is '16/11/2022'

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018006 | 2122          | Final            | AEBC-ASCL2122       | 2                  | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | 0.00            | 0.00                     | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018006 | 2122          | Final            | AEBC-ASCL2122       | AECA-006      | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | 0.00            | ?                     | 0.00                     |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10018006 | 2122          | Final            | AEBC-ASCL2122       | AECA-006      | AEBC-ASCL-2122       | 3               | Adult Skills Programme Funding                         | 0.00         | 0.00         |
    | 10018006 | 2122          | Final            | AEBC-ASCL2122       | AECA-006      | AEBC-ASCL-2122       | 4               | Adult Skills Learning Support                          | 0.00         | 0.00         |
    | 10018006 | 2122          | Final            | AEBC-ASCL2122       | AECA-006      | AEBC-ASCL-2122       | 5               | Community Learning                                     | 27977.00     | 0.00         |
    | 10018006 | 2122          | Final            | AEBC-ASCL2122       | AECA-006      | AEBC-ASCL-2122       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 0.00         |
    | 10018006 | 2122          | Final            | AEBC-ASCL2122       | AECA-006      | AEBC-ASCL-2122       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 0.00         |
    | 10018006 | 2122          | Final            | AEBC-ASCL2122       | AECA-006      | AEBC-ASCL-2122       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 0.00         |
    | 10018006 | 2122          | Final            | AEBC-ASCL2122       | AECA-006      | AEBC-ASCL-2122       | 9               | Adult Skills Administration Expenditure                | 0.00         | 0.00         |
    | 10018006 | 2122          | Final            | AEBC-ASCL2122       | AECA-006      | AEBC-ASCL-2122       | 10              | Learner Support - COVID-19 Response                    | 0.00         | 0.00         |





    # Update FCR

    # Change the date 
    Given the override date is '18/11/2022'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither ... 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10018006 | 2122          | Final            | AEBC-ASCL2122       | 2                  | AECA-006      | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | ?               | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018006 | 2122          | Final            | AEBC-ASCL2122       | 2                  | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | ?               | 0.00                     | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018006 | 2122          | Final            | AEBC-ASCL2122       | AECA-006      | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | ?               | ?                     | 0.00                     |





    # Publish FCR

    # Change the date
    Given the override date is '20/11/2022'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2022-Final' and Allocation Group Code 'AEBC-ASCL2122'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2122-Final' and Allocation Group Code 'AEBC-ASCL2122'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018006 | 2122          | Final            | AEBC-ASCL2122       | 2                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018006 | 2122          | Final            | AEBC-ASCL2122       | 2                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018006 | 2122          | Final            | AEBC-ASCL2122       | 2                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                               | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10018006 | AECA-006         | 2122   | Final         | AEB (Grant) - Adult Skills and Community Learning 21/22           | 46756.00     | 0.00         | -46756.00                   | -46756.00                | 0.00               | ?               | ?                     | 0.00                     |

 

     # Check Financials 


    # Check the deliverable count in CRM (12 mths x 5 deliverables) + (4 mths x 5 deliverables) = 80 deliverable periods
    And   there are '80' deliverable period rows in CRM linked to the latest version of contract 'EDSK-006'

   # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | EDSK-006       | AECA-006           | 1               | 46756.00  | 6110.00  | 4608.00  | 1713.00  | 2014.00  | 2093.00  | 5557.00  | 2568.00  | 4134.00  | 4119.00  | 5147.00  | 4782.00  | 3911.00  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 2               | 18779.00  | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 5               | 27977.00  | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | EDSK-006       | AECA-006           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 2               | 18779.00  | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 5               | 27977.00  | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | EDSK-006       | AECA-006           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | EDSK-006       | AECA-006           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 2               | -18779.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4694.75 | -4694.75 | -4694.75 | -4694.75 | 
    | EDSK-006       | AECA-006           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 5               | -27977.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6994.25 | -6994.25 | -6994.25 | -6994.25 | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | EDSK-006       | AECA-006           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 2               | 0.00      | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | -4694.75 | -4694.75 | -4694.75 | -4694.75 | 
    | EDSK-006       | AECA-006           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 5               | 0.00      | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | -6994.25 | -6994.25 | -6994.25 | -6994.25 | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    | Apr-22    | May-22    | Jun-22    | Jul-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    |
    | 10018006 | EDSK-006       | AECA-006           | 2371110                  | 3160.00   | 2631.00   | 1500.00   | 210.00    | 378.00    | 1841.00   | 171.00    | 497.00    | 1485.00   | 2221.00   | 3714.00   | 971.00    | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10018006 | EDSK-006       | AECA-006           | 2371130                  | 2950.00   | 1977.00   | 213.00    | 1804.00   | 1715.00   | 3716.00   | 2397.00   | 3637.00   | 2634.00   | 2926.00   | 1068.00   | 2940.00   | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    | Apr-22    | May-22    | Jun-22    | Jul-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    |
    | 10018006 | EDSK-006       | AECA-006           | 2371175                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | -11689.00 | -11689.00 | -11689.00 | -11689.00 | 
    




    # Amend contract
    
    # Change the date
    Given the override date is '12/01/2022'
    
    # Bulk file
    And   there are no files prefixed '10018006' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2122 30092022164257 v3_S006' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2122 30092022164257 v3_S006' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2122 30092022164257 v3_S006' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2122 30092022164257 v3_S006' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2122 30092022164257 v3_S006.xlsx' exists in the Datafiles folder and UKPRN '10018006' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-006'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-006' and actual ContractNumber 'EDSK-006'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-006' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018006 | EDSK-006           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10018006 | EDSK-006           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10018006 | ESFA-006           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Check the deliverable count in CRM (12 mths x 5 deliverables) + (4 mths x 5 deliverables) = 80 deliverable periods
    And   there are '80' deliverable period rows in CRM linked to the latest version of contract 'EDSK-006'

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | EDSK-006       | AECA-006           | 1               | 45921.00  | 3862.00  | 3266.00  | 3118.00  | 1929.00  | 5497.00  | 3586.00  | 3108.00  | 4605.00  | 6439.00  | 3987.00  | 5114.00  | 1410.00  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 2               | 21473.00  | 3120.00  | 1961.00  | 1389.00  | 1474.00  | 1220.00  | 1984.00  | 1642.00  | 1570.00  | 1174.00  | 3362.00  | 1347.00  | 1230.00  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 5               | 24448.00  | 742.00   | 1305.00  | 1729.00  | 455.00   | 4277.00  | 1602.00  | 1466.00  | 3035.00  | 5265.00  | 625.00   | 3767.00  | 180.00   | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | EDSK-006       | AECA-006           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 2               | 18779.00  | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 5               | 27977.00  | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | EDSK-006       | AECA-006           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | EDSK-006       | AECA-006           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 2               | -18779.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4694.75 | -4694.75 | -4694.75 | -4694.75 | 
    | EDSK-006       | AECA-006           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 5               | -27977.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6994.25 | -6994.25 | -6994.25 | -6994.25 | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | EDSK-006       | AECA-006           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 2               | 0.00      | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | -4694.75 | -4694.75 | -4694.75 | -4694.75 | 
    | EDSK-006       | AECA-006           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-006       | AECA-006           | 5               | 0.00      | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | -6994.25 | -6994.25 | -6994.25 | -6994.25 | 
    

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    | Apr-22    | May-22    | Jun-22    | Jul-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    |
    | 10018006 | EDSK-006       | AECA-006           | 2371110                  | 3160.00   | 2631.00   | 1500.00   | 210.00    | 378.00    | 1841.00   | 171.00    | 497.00    | 1485.00   | 2221.00   | 3714.00   | 971.00    | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10018006 | EDSK-006       | AECA-006           | 2371130                  | 2950.00   | 1977.00   | 213.00    | 1804.00   | 1715.00   | 3716.00   | 2397.00   | 3637.00   | 2634.00   | 2926.00   | 1068.00   | 2940.00   | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    | Apr-22    | May-22    | Jun-22    | Jul-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    |
    | 10018006 | EDSK-006       | AECA-006           | 2371175                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | -11689.00 | -11689.00 | -11689.00 | -11689.00 | 


    # Tidy up
    Given the override date is reset

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    And   there is no data in the Reconciliation Profiling table for UKPRN '10018006' and FundingPeriod 'AY2122'



@AcceptanceTest @Withdrawn20221031
@FundingClaims
Scenario: S007 Create and approve an EDSK contract with an AEBC-ASCL2122   alloc (Created to support the manual testing) 
    Given there are no allocations marked as Under Termination for UKPRN '10018007' 
    And   there are no terminated or closed allocations for UKPRN '10018007' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018007' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018007' 
 
    # Clear down ContractRequest.FundingAllocationRelease table (J146). 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018007' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-007      |
	| ALLC-007      |

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECA-007      |
	| ALLC-007      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-007      |
	| ALLC-007      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-ASCL2122     |
	| ALLBC2122         |
	
	

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-007       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018007'

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Year End      | 1920   |
    | Year End      | 2021   |
	| Year End      | 2122   |
    | Final         | 1718   |
    | Final         | 1819   |
    | Final         | 1920   |
    | Final         | 2021   |
	| Final         | 2122   |
	
	

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10018007 |

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    Given there is no data in the Reconciliation Profiling table for UKPRN '10018007' and FundingPeriod 'AY2122'

   # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
    And   the Reconciliation Profiling table includes a row for UKPRN '10018007' and FundingPeriod 'AY2122'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018007' 
    And   there is no caseload advisor for UKPRN '10018007' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018007 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018007' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018007 Co Ltd' with UKPRN '10018007' and OrgId 'ORG0018007' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018007 | 118007 | 10018007 Co Ltd | 0              | Active                | Yes           | AA018007      | ?             | 41 Send Barns Lane     | Send                   | Woking                 | ?                      | ?                      | Surrey                 | GU23 7BS  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018007 |



    # Part 1: Create and approve and EDSK2122 with one FCR allocs

    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-007'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-007'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018007 | 10018007 Co Ltd      | ESFA-007             | EDSK-007       | 1                     | 01/08/2021        | 31/07/2022      | 46756.00      |                                       | Conditions of Funding (Grant) (LA)         | 2122   | New          | ORG0018007 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018007 | EDSK-007       | AECA-007      | AEBC-ASCL         | AEBC-ASCL2122           | AY                      | 01/08/2021          | 31/07/2022        | 46756.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10018007 | EDSK-007       | AECA-007      | 1               | 0                     | 46756.00  | 28797.00  | 17959.00  | 6110.00  | 4608.00  | 1713.00  | 2014.00  | 2093.00  | 5557.00  | 2568.00  | 4134.00  | 4119.00  | 5147.00  | 4782.00  | 3911.00  | Adult Skills and Community Learning Total Funding               | New          |             | 
    | 10018007 | EDSK-007       | AECA-007      | 2               | 1                     | 18779.00  | 10388.00  | 8391.00   | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | Adult Skills Total Funding                                      | New          |             | 
    | 10018007 | EDSK-007       | AECA-007      | 5               | 1                     | 27977.00  | 18409.00  | 9568.00   | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | Community Learning                                              | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-007'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
   #When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-007' and actual ContractNumber 'EDSK-007'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-007' and ContractNumber 'EDSK-007' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-007' has a substatus of 'Approved'





    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018007 | EDSK-007           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10018007 | ESFA-007           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-007' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'EDSK-007'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECA-007        | 2371175          | Jul-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10018007 | EDSK-007       | 1               | AECA-007      | 1               | 0                     | 46756.00     | 0             | 0        | Adult Skills and Community Learning Total Funding               | ?                                                           |
    | 10018007 | EDSK-007       | 1               | AECA-007      | 2               | 1                     | 18779.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
    | 10018007 | EDSK-007       | 1               | AECA-007      | 5               | 1                     | 27977.00     | 0             | 0        | Community Learning                                              | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-007' agree with the most recent entry for this contract in the ContractManagement feed


    


    # Funding Claims ...
    
    # Populate stub with Claim data

    # Change the date
    Given the override date is '14/11/2022'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0018007     | 10018007 | 2                  | Final         | AY             | 2122   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0018007     | 10018007 | 2                  | Final         | AY             | 2122   | AECA-007      | AEBC-ASCL2122           |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0018007     | 10018007 | 2                  | Final         | AY             | 2122   | AECA-007      | 3               | 25000.00    | 0.00          | 0.00            | 25000.00   |
    | ORG0018007     | 10018007 | 2                  | Final         | AY             | 2122   | AECA-007      | 4               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018007     | 10018007 | 2                  | Final         | AY             | 2122   | AECA-007      | 5               | 21756.00    | 0.00          | 0.00            | 21756.00   |
    | ORG0018007     | 10018007 | 2                  | Final         | AY             | 2122   | AECA-007      | 6               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018007     | 10018007 | 2                  | Final         | AY             | 2122   | AECA-007      | 7               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018007     | 10018007 | 2                  | Final         | AY             | 2122   | AECA-007      | 8               | 0.00   	   | 0.00          | 0.00            | 0.00       |
    | ORG0018007     | 10018007 | 2                  | Final         | AY             | 2122   | AECA-007      | 9               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018007     | 10018007 | 2                  | Final         | AY             | 2122   | AECA-007      | 10              | 0.00        | 0.00          | 0.00            | 0.00       |
    #                                                                                                                                                                            £ 46756.00  





    # Consume stub data

    # Change the date
    Given the override date is '16/11/2022'

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018007 | 2122          | Final            | AEBC-ASCL2122       | 2                  | 46756.00     | 46756.00     |  0.00      	             |  0.00            | 46756.00         | 0.00            | 46756.00                 | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018007 | 2122          | Final            | AEBC-ASCL2122       | AECA-007      | 46756.00     | 46756.00     | 0.00    	                | 0.00       	  | 46756.00         | 0.00            | ?                     | 46756.00                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10018007 | 2122          | Final            | AEBC-ASCL2122       | AECA-007      | AEBC-ASCL-2122       | 3               | Adult Skills Programme Funding                         | 0.00         | 25000.00     |
    | 10018007 | 2122          | Final            | AEBC-ASCL2122       | AECA-007      | AEBC-ASCL-2122       | 4               | Adult Skills Learning Support                          | 0.00         | 0.00         |
    | 10018007 | 2122          | Final            | AEBC-ASCL2122       | AECA-007      | AEBC-ASCL-2122       | 5               | Community Learning                                     | 27977.00     | 21756.00     |
    | 10018007 | 2122          | Final            | AEBC-ASCL2122       | AECA-007      | AEBC-ASCL-2122       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 0.00         |
    | 10018007 | 2122          | Final            | AEBC-ASCL2122       | AECA-007      | AEBC-ASCL-2122       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 0.00         |
    | 10018007 | 2122          | Final            | AEBC-ASCL2122       | AECA-007      | AEBC-ASCL-2122       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 0.00         |
    | 10018007 | 2122          | Final            | AEBC-ASCL2122       | AECA-007      | AEBC-ASCL-2122       | 9               | Adult Skills Administration Expenditure                | 0.00         | 0.00         |
    | 10018007 | 2122          | Final            | AEBC-ASCL2122       | AECA-007      | AEBC-ASCL-2122       | 10              | Learner Support - COVID-19 Response                    | 0.00         | 0.00         |



    
@AcceptanceTest @Withdrawn20231002
@FundingClaims
Scenario: S008 Create and approve an EDSK contract (Does not exist in ClaimReconciliationReferenceDataReconProfiling ) with an AEBC-ASCL2122 allocation. Process Final Funding Claim BELOW profile, Publish FCR and verify the recovery is ClawedBack in One single month  
    Given there are no allocations marked as Under Termination for UKPRN '10018008' 
    And   there are no terminated or closed allocations for UKPRN '10018008' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018008' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018008' 
 
    # Clear down ContractRequest.FundingAllocationRelease table (J146). 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018008' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-008      |

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECA-008      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-008      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-ASCL2122     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-008       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018008'

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Year End      | 1920   |
    | Year End      | 2021   |
	| Year End      | 2122   |
    | Final         | 1718   |
    | Final         | 1819   |
    | Final         | 1920   |
    | Final         | 2021   |
	| Final         | 2122   |
	
	

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10018008 |

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    Given there is no data in the Reconciliation Profiling table for UKPRN '10018008' and FundingPeriod 'AY2122'

#   # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
#    And   the Reconciliation Profiling table includes a row for UKPRN '10018008' and FundingPeriod 'AY2122'
#


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018008' 
    And   there is no caseload advisor for UKPRN '10018008' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018008 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018008' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018008 Co Ltd' with UKPRN '10018008' and OrgId 'ORG0018008' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018008 | 118008 | 10018008 Co Ltd | 0              | Active                | Yes           | AA018008      | ?             | 41 Send Barns Lane     | Send                   | Woking                 | ?                      | ?                      | Surrey                 | GU23 7BS  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018008 |



    # Part 1: Create and approve and EDSK2122 with one FCR allocs

    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-008'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-008'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018008 | 10018008 Co Ltd      | ESFA-008             | EDSK-008       | 1                     | 01/08/2021        | 31/07/2022      | 46756.00      |                                       | Conditions of Funding (Grant) (LA)         | 2122   | New          | ORG0018008 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018008 | EDSK-008       | AECA-008      | AEBC-ASCL         | AEBC-ASCL2122           | AY                      | 01/08/2021          | 31/07/2022        | 46756.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10018008 | EDSK-008       | AECA-008      | 1               | 0                     | 46756.00  | 28797.00  | 17959.00  | 6110.00  | 4608.00  | 1713.00  | 2014.00  | 2093.00  | 5557.00  | 2568.00  | 4134.00  | 4119.00  | 5147.00  | 4782.00  | 3911.00  | Adult Skills and Community Learning Total Funding               | New          |             | 
    | 10018008 | EDSK-008       | AECA-008      | 2               | 1                     | 18779.00  | 10388.00  | 8391.00   | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | Adult Skills Total Funding                                      | New          |             | 
    | 10018008 | EDSK-008       | AECA-008      | 5               | 1                     | 27977.00  | 18409.00  | 9568.00   | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | Community Learning                                              | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-008'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
   #When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-008' and actual ContractNumber 'EDSK-008'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-008' and ContractNumber 'EDSK-008' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-008' has a substatus of 'Approved'





    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018008 | EDSK-008           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10018008 | ESFA-008           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-008' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'EDSK-008'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECA-008        | 2371175          | Jul-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10018008 | EDSK-008       | 1               | AECA-008      | 1               | 0                     | 46756.00     | 0             | 0        | Adult Skills and Community Learning Total Funding               | ?                                                           |
    | 10018008 | EDSK-008       | 1               | AECA-008      | 2               | 1                     | 18779.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
    | 10018008 | EDSK-008       | 1               | AECA-008      | 5               | 1                     | 27977.00     | 0             | 0        | Community Learning                                              | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-008' agree with the most recent entry for this contract in the ContractManagement feed


    


    # Funding Claims ...
    
    # Populate stub with Claim data

    # Change the date
    Given the override date is '14/11/2022'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0018008     | 10018008 | 2                  | Final         | AY             | 2122   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0018008     | 10018008 | 2                  | Final         | AY             | 2122   | AECA-008      | AEBC-ASCL2122           |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0018008     | 10018008 | 2                  | Final         | AY             | 2122   | AECA-008      | 3               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018008     | 10018008 | 2                  | Final         | AY             | 2122   | AECA-008      | 4               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018008     | 10018008 | 2                  | Final         | AY             | 2122   | AECA-008      | 5               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018008     | 10018008 | 2                  | Final         | AY             | 2122   | AECA-008      | 6               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018008     | 10018008 | 2                  | Final         | AY             | 2122   | AECA-008      | 7               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018008     | 10018008 | 2                  | Final         | AY             | 2122   | AECA-008      | 8               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018008     | 10018008 | 2                  | Final         | AY             | 2122   | AECA-008      | 9               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0018008     | 10018008 | 2                  | Final         | AY             | 2122   | AECA-008      | 10              | 0.00        | 0.00          | 0.00            | 0.00       |
    #                                                                                                                                                                            £ 0.00  





    # Consume stub data

    # Change the date
    Given the override date is '16/11/2022'

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018008 | 2122          | Final            | AEBC-ASCL2122       | 2                  | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | 0.00            | 0.00                     | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018008 | 2122          | Final            | AEBC-ASCL2122       | AECA-008      | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | 0.00            | ?                     | 0.00                     |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10018008 | 2122          | Final            | AEBC-ASCL2122       | AECA-008      | AEBC-ASCL-2122       | 3               | Adult Skills Programme Funding                         | 0.00         | 0.00         |
    | 10018008 | 2122          | Final            | AEBC-ASCL2122       | AECA-008      | AEBC-ASCL-2122       | 4               | Adult Skills Learning Support                          | 0.00         | 0.00         |
    | 10018008 | 2122          | Final            | AEBC-ASCL2122       | AECA-008      | AEBC-ASCL-2122       | 5               | Community Learning                                     | 27977.00     | 0.00         |
    | 10018008 | 2122          | Final            | AEBC-ASCL2122       | AECA-008      | AEBC-ASCL-2122       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 0.00         |
    | 10018008 | 2122          | Final            | AEBC-ASCL2122       | AECA-008      | AEBC-ASCL-2122       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 0.00         |
    | 10018008 | 2122          | Final            | AEBC-ASCL2122       | AECA-008      | AEBC-ASCL-2122       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 0.00         |
    | 10018008 | 2122          | Final            | AEBC-ASCL2122       | AECA-008      | AEBC-ASCL-2122       | 9               | Adult Skills Administration Expenditure                | 0.00         | 0.00         |
    | 10018008 | 2122          | Final            | AEBC-ASCL2122       | AECA-008      | AEBC-ASCL-2122       | 10              | Learner Support - COVID-19 Response                    | 0.00         | 0.00         |





    # Update FCR

    # Change the date 
    Given the override date is '18/11/2022'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither ... 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10018008 | 2122          | Final            | AEBC-ASCL2122       | 2                  | AECA-008      | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | ?               | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10018008 | 2122          | Final            | AEBC-ASCL2122       | 2                  | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | ?               | 0.00                     | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10018008 | 2122          | Final            | AEBC-ASCL2122       | AECA-008      | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | ?               | ?                     | 0.00                     |





    # Publish FCR

    # Change the date
    Given the override date is '20/11/2022'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2022-Final' and Allocation Group Code 'AEBC-ASCL2122'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2122-Final' and Allocation Group Code 'AEBC-ASCL2122'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018008 | 2122          | Final            | AEBC-ASCL2122       | 2                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018008 | 2122          | Final            | AEBC-ASCL2122       | 2                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10018008 | 2122          | Final            | AEBC-ASCL2122       | 2                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                               | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10018008 | AECA-008         | 2122   | Final         | AEB (Grant) - Adult Skills and Community Learning 21/22           | 46756.00     | 0.00         | -46756.00                   | -46756.00                | 0.00               | ?               | ?                     | 0.00                     |

 

     # Check Financials 


    # Check the deliverable count in CRM (12 mths x 5 deliverables) + (1 mth x 5 deliverables) = 65 deliverable periods
    And   there are '65' deliverable period rows in CRM linked to the latest version of contract 'EDSK-008'

   # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | Dec-22   |
    | EDSK-008       | AECA-008           | 1               | 46756.00  | 6110.00  | 4608.00  | 1713.00  | 2014.00  | 2093.00  | 5557.00  | 2568.00  | 4134.00  | 4119.00  | 5147.00  | 4782.00  | 3911.00  | 0.00     | 
    | EDSK-008       | AECA-008           | 2               | 18779.00  | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | 0.00     | 
    | EDSK-008       | AECA-008           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-008       | AECA-008           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-008       | AECA-008           | 5               | 27977.00  | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | 0.00     |

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | Dec-22   |
    | EDSK-008       | AECA-008           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-008       | AECA-008           | 2               | 18779.00  | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | 0.00     | 
    | EDSK-008       | AECA-008           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-008       | AECA-008           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-008       | AECA-008           | 5               | 27977.00  | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | 0.00     |

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | Dec-22   |
    | EDSK-008       | AECA-008           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-008       | AECA-008           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | EDSK-008       | AECA-008           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-008       | AECA-008           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-008       | AECA-008           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | Dec-22   |
    | EDSK-008       | AECA-008           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | EDSK-008       | AECA-008           | 2               | -18779.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -18779.00|
    | EDSK-008       | AECA-008           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | EDSK-008       | AECA-008           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | EDSK-008       | AECA-008           | 5               | -27977.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -27977.00|

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | Dec-22   |
    | EDSK-008       | AECA-008           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | EDSK-008       | AECA-008           | 2               | 0.00      | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | -18779.00|
    | EDSK-008       | AECA-008           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | EDSK-008       | AECA-008           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | EDSK-008       | AECA-008           | 5               | 0.00      | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | -27977.00|


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    | Apr-22    | May-22    | Jun-22    | Jul-22    | Dec-22    |
    | 10018008 | EDSK-008       | AECA-008           | 2371110                  | 3160.00   | 2631.00   | 1500.00   | 210.00    | 378.00    | 1841.00   | 171.00    | 497.00    | 1485.00   | 2221.00   | 3714.00   | 971.00    | 0.00      |
    | 10018008 | EDSK-008       | AECA-008           | 2371130                  | 2950.00   | 1977.00   | 213.00    | 1804.00   | 1715.00   | 3716.00   | 2397.00   | 3637.00   | 2634.00   | 2926.00   | 1068.00   | 2940.00   | 0.00      |

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    | Apr-22    | May-22    | Jun-22    | Jul-22    | Dec-22    |
    | 10018008 | EDSK-008       | AECA-008           | 2371175                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | -46756.00 |
    



    # Tidy up
    Given the override date is reset


