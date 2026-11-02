Feature: AllocLevelAllocDuration 28922

@AcceptanceTest @Withdrawn20211216
Scenario: A041 OPA Rewrite. Create and approve an EDSK contract with 16-18TRN1920 alloc. Consume actuals twice. Bulk amend and approve. Consume actuals again. Check CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017041' 
    And   there are no terminated or closed allocations for UKPRN '10017041' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017041' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017041' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-041      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-041      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN1920      |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017041' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017041 Co Ltd' with UKPRN '10017041' and OrgId 'ORG0017041' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017041' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017041 | 117041 | 10017041 Co Ltd | 0              | In Administration     | Yes           | AA017041      | ?             | 36 Kings Street        | Covent Garden          | London                 | ?                      | ?                      | ?                      | WC2 8JS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017041 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017041 | 10017041 Co Ltd      | ESFA-041             | EDSK-041       | 1                     | 01/08/2019        | 31/03/2020      | 30227.00      |                                       | Conditions of Funding (Grant) (LA)         | 1920   | New          | ORG0017041 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017041 | EDSK-041       | 16TR-041      | 16-18TRN          | 16-18TRN1920            | AY                      | 01/08/2019          | 31/03/2020        | 30227.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017041 | EDSK-041       | 16TR-041      | 1               | 0                     | 30227.00  | 4601.00  | 2783.00  | 1537.00  | 5693.00  | 3909.00  | 2997.00  | 4314.00  | 4393.00  | 16-18 Traineeships Funding                                      | New          |             | 
    | 10017041 | EDSK-041       | 16TR-041      | 2               | 1                     | 19303.00  | 3042.00  | 329.00   | 1065.00  | 3541.00  | 3516.00  | 2607.00  | 1633.00  | 3570.00  | 16-18 Traineeships Programme Funding                            | New          |             | 
    | 10017041 | EDSK-041       | 16TR-041      | 3               | 1                     | 10924.00  | 1559.00  | 2454.00  | 472.00   | 2152.00  | 393.00   | 390.00   | 2681.00  | 823.00   | 16-18 Traineeships Bursary Funding                              | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-041' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-041'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-041' and actual ContractNumber 'EDSK-041'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-041' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017041 | EDSK-041           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/03/2020      | ?             |
    | 10017041 | ESFA-041           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/03/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'EDSK-041'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | 16TR-041      | 2201300          | Mar-20 | Reconciliation |
    | 16TR-041      | 2201350          | Mar-20 | Reconciliation |




    # Add actuals to the contract (No capping)

    # Change the date
    Given the override date is '04/09/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017041'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R01                  | ORG0017041     | CM             | 201908 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 14582.97    |
    | ILR1920        | R01                  | ORG0017041     | CM             | 201908 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 12479.16    |
    | ILR1920        | R01                  | ORG0017041     | CM             | 201909 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 3340.25     |
    | ILR1920        | R01                  | ORG0017041     | CM             | 201909 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 1258.03     |
    | ILR1920        | R01                  | ORG0017041     | CM             | 201910 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 1951.59     |
    | ILR1920        | R01                  | ORG0017041     | CM             | 201910 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 1980.16     |
    | ILR1920        | R01                  | ORG0017041     | CM             | 201911 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 216.74      |
    | ILR1920        | R01                  | ORG0017041     | CM             | 201911 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 1390.05     |
    | ILR1920        | R01                  | ORG0017041     | CM             | 201912 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 1670.98     |
    | ILR1920        | R01                  | ORG0017041     | CM             | 201912 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 675.70      |
    | ILR1920        | R01                  | ORG0017041     | CM             | 202001 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 1569.01     |
    | ILR1920        | R01                  | ORG0017041     | CM             | 202001 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 816.67      |
    | ILR1920        | R01                  | ORG0017041     | CM             | 202002 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 740.90      |
    | ILR1920        | R01                  | ORG0017041     | CM             | 202002 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 2416.51     |
    | ILR1920        | R01                  | ORG0017041     | CM             | 202003 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 2494.82     |
    | ILR1920        | R01                  | ORG0017041     | CM             | 202003 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 1794.51     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



	# Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 38227.00  | 4601.00  | 2783.00  | 1537.00  | 5693.00  | 3909.00  | 2997.00  | 4314.00  | 4393.00  | 
    | EDSK-041       | 16TR-041           | 2               | 19303.00  | 3042.00  | 329.00   | 1065.00  | 3541.00  | 3516.00  | 2607.00  | 1633.00  | 3570.00  | 
    | EDSK-041       | 16TR-041           | 3               | 10924.00  | 1559.00  | 2454.00  | 472.00   | 2152.00  | 393.00   | 390.00   | 2681.00  | 823.00   | 

	# Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-041       | 16TR-041           | 2               | 14582.97  | 14582.97 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-041       | 16TR-041           | 3               | 12479.16  | 12479.16 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 2               | 14582.97  | 14582.97 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 3               | 12479.16  | 12479.16 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 2               | 14582.97  | 14582.97 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 3               | 12479.16  | 12479.16 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    | Jan-20    | Feb-20    | Mar-20    |
    | 10017041 | MAIN-041       | 16TR-041           | 2201300                  | 14582.97  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017041 | MAIN-041       | 16TR-041           | 2201350                  | 12479.16  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    | Jan-20    | Feb-20    | Mar-20    |
    | 10017041 | MAIN-041       | 16TR-041           | 2201300                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017041 | MAIN-041       | 16TR-041           | 2201350                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 




    # Add actuals to the contract (Capping occurs)

    # Change the date
    Given the override date is '04/10/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017041'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Sep 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R02                  | ORG0017041     | CM             | 201908 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 13023.06    |
    | ILR1920        | R02                  | ORG0017041     | CM             | 201908 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 11815.13    |
    | ILR1920        | R02                  | ORG0017041     | CM             | 201909 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 9963.59     |
    | ILR1920        | R02                  | ORG0017041     | CM             | 201909 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 4494.24     |
    | ILR1920        | R02                  | ORG0017041     | CM             | 201910 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 1524.20     |
    | ILR1920        | R02                  | ORG0017041     | CM             | 201910 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 2118.57     |
    | ILR1920        | R02                  | ORG0017041     | CM             | 201911 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 832.77      |
    | ILR1920        | R02                  | ORG0017041     | CM             | 201911 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 1248.23     |
    | ILR1920        | R02                  | ORG0017041     | CM             | 201912 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 1777.67     |
    | ILR1920        | R02                  | ORG0017041     | CM             | 201912 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 1311.86     |
    | ILR1920        | R02                  | ORG0017041     | CM             | 202001 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 1591.77     |
    | ILR1920        | R02                  | ORG0017041     | CM             | 202001 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 2154.65     |
    | ILR1920        | R02                  | ORG0017041     | CM             | 202002 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 2108.25     |
    | ILR1920        | R02                  | ORG0017041     | CM             | 202002 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 1370.74     |
    | ILR1920        | R02                  | ORG0017041     | CM             | 202003 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 1263.38     |
    | ILR1920        | R02                  | ORG0017041     | CM             | 202003 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 1795.07     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


	# Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 38227.00  | 4601.00  | 2783.00  | 1537.00  | 5693.00  | 3909.00  | 2997.00  | 4314.00  | 4393.00  | 
    | EDSK-041       | 16TR-041           | 2               | 19303.00  | 3042.00  | 329.00   | 1065.00  | 3541.00  | 3516.00  | 2607.00  | 1633.00  | 3570.00  | 
    | EDSK-041       | 16TR-041           | 3               | 10924.00  | 1559.00  | 2454.00  | 472.00   | 2152.00  | 393.00   | 390.00   | 2681.00  | 823.00   |

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-041       | 16TR-041           | 2               | 22986.65  | 13023.06 | 9963.59  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-041       | 16TR-041           | 3               | 16309.37  | 11815.13 | 4494.24  | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 2               | 22986.65  | 14582.97 | 8403.68  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 3               | 16309.37  | 12479.16 | 3830.21  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 2               | -5305.03  | 0.00     | -5305.03 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 3               | -3763.99  | 0.00     | -3763.99 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 2               | 17681.62  | 14582.97 | 3098.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 3               | 12545.38  | 12479.16 | 66.22    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    | Jan-20    | Feb-20    | Mar-20    |
    | 10017041 | MAIN-041       | 16TR-041           | 2201300                  | 14582.97  | 8403.68   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017041 | MAIN-041       | 16TR-041           | 2201350                  | 12479.16  | 3830.21   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    | Jan-20    | Feb-20    | Mar-20    |
    | 10017041 | MAIN-041       | 16TR-041           | 2201300                  | 0.00      | -5305.03  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017041 | MAIN-041       | 16TR-041           | 2201350                  | 0.00      | -3763.99  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 




    # Bulk amend the contract. Increase the contract value from £30,227 to £39,000
	
	# Change the date
    Given the override date is '16/10/2019'

    # Bulk file
    And   there are no files prefixed '10017041' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 03032020124751 v3_A041' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 1920 03032020124751 v3_A041' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 03032020124751 v3_A041' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 03032020124751 v3_A041' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 03032020124751 v3_A041.xlsx' exists in the Datafiles folder and UKPRN '10017041' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Change the date
	Given the override date is '20/10/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-041' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-041'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-041' and actual ContractNumber 'EDSK-041'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-041' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017041 | EDSK-041           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/03/2020      | Variation     |
    | 10017041 | EDSK-041           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/03/2020      | ?             |
    | 10017041 | ESFA-041           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/03/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'EDSK-041'
	
	# Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | 16TR-041      | 2201300          | Mar-20 | Reconciliation |
    | 16TR-041      | 2201350          | Mar-20 | Reconciliation |




	# Check CRM financials after approval of v2

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 39000.00  | 4626.00  | 922.00   | 3924.00  | 4659.00  | 6664.00  | 10708.00 | 3487.00  | 4010.00  | 
    | EDSK-041       | 16TR-041           | 2               | 15843.00  | 2552.00  | 801.00   | 1943.00  | 2467.00  | 1055.00  | 3178.00  | 1720.00  | 2127.00  | 
    | EDSK-041       | 16TR-041           | 3               | 23157.00  | 2074.00  | 121.00   | 1981.00  | 2192.00  | 5609.00  | 7530.00  | 1767.00  | 1883.00  | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 2               | 22986.65  | 13023.06 | 9963.59  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 3               | 16309.37  | 11815.13 | 4494.24  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 2               | 28291.68  | 14582.97 | 8403.68  | 5305.03  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 3               | 20073.36  | 12479.16 | 3830.21  | 3763.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 2               | -5478.19  | 0.00     | -5305.03 | -173.16  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 3               | -3886.85  | 0.00     | -3763.99 | -122.86  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 2               | 22813.49  | 14582.97 | 3098.65  | 5131.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 3               | 16186.51  | 12479.16 | 66.22    | 3641.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    | Jan-20    | Feb-20    | Mar-20    |
    | 10017041 | MAIN-041       | 16TR-041           | 2201300                  | 14582.97  | 8403.68   | 5305.03   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017041 | MAIN-041       | 16TR-041           | 2201350                  | 12479.16  | 3830.21   | 3763.99   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    | Jan-20    | Feb-20    | Mar-20    |
    | 10017041 | MAIN-041       | 16TR-041           | 2201300                  | 0.00      | -5305.03  | -173.16   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017041 | MAIN-041       | 16TR-041           | 2201350                  | 0.00      | -3763.99  | -122.86   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 




    # Add actuals to the contract (Capping occurs)

    # Change the date
    Given the override date is '04/02/2020'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017041'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Jan 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R06                  | ORG0017041     | CM             | 201908 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 8174.76     |
    | ILR1920        | R06                  | ORG0017041     | CM             | 201908 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 550.66      |
    | ILR1920        | R06                  | ORG0017041     | CM             | 201909 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 5185.13     |
    | ILR1920        | R06                  | ORG0017041     | CM             | 201909 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 1845.23     |
    | ILR1920        | R06                  | ORG0017041     | CM             | 201910 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 3024.38     |
    | ILR1920        | R06                  | ORG0017041     | CM             | 201910 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 2258.64     |
    | ILR1920        | R06                  | ORG0017041     | CM             | 201911 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 5090.70     |
    | ILR1920        | R06                  | ORG0017041     | CM             | 201911 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 2040.08     |
    | ILR1920        | R06                  | ORG0017041     | CM             | 201912 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 5105.25     |
    | ILR1920        | R06                  | ORG0017041     | CM             | 201912 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 4819.75     |
    | ILR1920        | R06                  | ORG0017041     | CM             | 202001 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 1596.22     |
    | ILR1920        | R06                  | ORG0017041     | CM             | 202001 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 2356.90     |
    | ILR1920        | R06                  | ORG0017041     | CM             | 202002 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 854.62      |
    | ILR1920        | R06                  | ORG0017041     | CM             | 202002 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 2272.23     |
    | ILR1920        | R06                  | ORG0017041     | CM             | 202003 | 16-18TRN1920            | 16TR-041                 | ?          | 2               | 0            | 2337.03     |
    | ILR1920        | R06                  | ORG0017041     | CM             | 202003 | 16-18TRN1920            | 16TR-041                 | ?          | 3               | 0            | 1639.75     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


	# Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 39000.00  | 4626.00  | 922.00   | 3924.00  | 4659.00  | 6664.00  | 10708.00 | 3487.00  | 4010.00  | 
    | EDSK-041       | 16TR-041           | 2               | 15843.00  | 2552.00  | 801.00   | 1943.00  | 2467.00  | 1055.00  | 3178.00  | 1720.00  | 2127.00  | 
    | EDSK-041       | 16TR-041           | 3               | 23157.00  | 2074.00  | 121.00   | 1981.00  | 2192.00  | 5609.00  | 7530.00  | 1767.00  | 1883.00  | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-041       | 16TR-041           | 2               | 28176.44  | 8174.76  | 5185.13  | 3024.38  | 5090.70  | 5105.25  | 1596.22  | ?        | ?        | 
    | EDSK-041       | 16TR-041           | 3               | 13871.26  | 550.66   | 1845.23  | 2258.64  | 2040.08  | 4819.75  | 2356.90  | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 2               | 33654.63  | 14582.97 | 8403.68  | 5305.03  | 0.00     | 0.00     | 5362.95  | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 3               | 17758.11  | 12479.16 | 3830.21  | 3763.99  | 0.00     | 0.00     | -2315.25 | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 2               | -7520.47  | 0.00     | -5305.03 | -173.16  | 0.00     | 0.00     | -2042.28 | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 3               | -4892.27  | 0.00     | -3763.99 | -122.86  | 0.00     | 0.00     | -1005.42 | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | EDSK-041       | 16TR-041           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 2               | 26134.16  | 14582.97 | 3098.65  | 5131.87  | 0.00     | 0.00     | 3320.67  | 0.00     | 0.00     | 
    | EDSK-041       | 16TR-041           | 3               | 12865.84  | 12479.16 | 66.22    | 3641.13  | 0.00     | 0.00     | -3320.67 | 0.00     | 0.00     | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    | Jan-20    | Feb-20    | Mar-20    |
    | 10017041 | MAIN-041       | 16TR-041           | 2201300                  | 14582.97  | 8403.68   | 5305.03   | 0.00      | 0.00      | 5362.95   | 0.00      | 0.00      | 
    | 10017041 | MAIN-041       | 16TR-041           | 2201350                  | 12479.16  | 3830.21   | 3763.99   | 0.00      | 0.00      | -2315.25  | 0.00      | 0.00      | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    | Jan-20    | Feb-20    | Mar-20    |
    | 10017041 | MAIN-041       | 16TR-041           | 2201300                  | 0.00      | -5305.03  | -173.16   | 0.00      | 0.00      | -2042.28  | 0.00      | 0.00      | 
    | 10017041 | MAIN-041       | 16TR-041           | 2201350                  | 0.00      | -3763.99  | -122.86   | 0.00      | 0.00      | -1005.42  | 0.00      | 0.00      | 



    # Tidy Up
    And the override date is reset

