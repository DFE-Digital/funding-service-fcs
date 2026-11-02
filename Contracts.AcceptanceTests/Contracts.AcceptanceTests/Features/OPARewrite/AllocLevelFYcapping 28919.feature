Feature: AllocLevelFYcapping 28919

@AcceptanceTest @Withdrawn20211216
@Long2Run @Long2Run123
Scenario: A317 OPA Rewrite. Create and approve an 1819 Mainstream contract with an 16-18TRN1819 alloc. Consume actuals 2x. Bulk amend and approve. Consume actuals 5x inc R14. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017317' 
    And   there are no terminated or closed allocations for UKPRN '10017317' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017317' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017317' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-317      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-317      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN1819      |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017317' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017317 Co Ltd' with UKPRN '10017317' and OrgId 'ORG0017317' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017317' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017317 | 117317 | 10017317 Co Ltd | 0              | Active                | Yes           | AA017317      | ?             | 23 The Landway         | Kemsing                | Kent                   | ?                      | ?                      | ?                      | TN15 6TG  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017317 |




    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017317 | 10017317 Co Ltd      | ESFA-317             | MAIN-317       | 1                     | 01/08/2018        | 31/07/2019      | 45728.00      |                                       | Contract for Services                      | 1819   | New          | ORG0017317 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017317 | MAIN-317       | 16TR-317      | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2018          | 31/07/2019        | 45728.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg | 3%       | 10%      | 
    | 10017317 | MAIN-317       | 16TR-317      | 1               | 0                     | 45728.00  | 28768.00  | 16960.00  | 1996.00  | 2579.00  | 2564.00  | 3591.00  | 4209.00  | 3339.00  | 5949.00  | 4541.00  | 4081.00  | 5459.00  | 4273.00  | 3147.00  | 16-18 Traineeships Funding                                      | New          |             | n/a      | n/a      |
    | 10017317 | MAIN-317       | 16TR-317      | 2               | 1                     | 18786.00  | 11829.00  | 6957.00   | 898.00   | 241.00   | 1229.00  | 1965.00  | 740.00   | 715.00   | 3507.00  | 2534.00  | 770.00   | 2360.00  | 3255.00  | 572.00   | 16-18 Traineeships Programme Funding                            | New          |             | n/a      | n/a      |
    | 10017317 | MAIN-317       | 16TR-317      | 3               | 1                     | 26942.00  | 16939.00  | 10003.00  | 1098.00  | 2338.00  | 1335.00  | 1626.00  | 3469.00  | 2624.00  | 2442.00  | 2007.00  | 3311.00  | 3099.00  | 1018.00  | 2575.00  | 16-18 Traineeships Bursary Funding                              | New          |             | n/a      | n/a      |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'MAIN-317' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'MAIN-317'




    # Change the date
    Given the override date is '17/07/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-317' and actual ContractNumber 'MAIN-317'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-317' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017317 | MAIN-317           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017317 | ESFA-317           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'MAIN-317'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | 16TR-317      | 2201300          | Jul-19 | Reconciliation |
	| 16TR-317      | 2201350          | Jul-19 | Reconciliation |




    # Add actuals to the contract (no Capping)

    # Change the date
    Given the override date is '04/09/2018'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Aug 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201808 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1998.55     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201808 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1345.49     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201809 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1952.17     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201809 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1639.61     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201810 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 5904.86     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201810 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 4976.35     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201811 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 6410.16     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201811 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 5213.86     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201812 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7537.37     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201812 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 2012.98     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201901 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 4297.75     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201901 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1958.69     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201902 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 680.03      |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201902 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1653.55     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201903 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1770.37     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201903 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1757.84     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201904 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1231.62     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201904 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 751.73      |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201905 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 417.01      |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201905 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1794.26     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201906 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1793.24     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201906 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 2454.17     |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201907 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 147.80      |
    | ILR1819        | R01                  | ORG0017317     | CM             | 201907 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 687.64      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


	# Check CRM

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 45728.00  | 1996.00  | 2579.00  | 2564.00  | 3591.00  | 4209.00  | 3339.00  | 5949.00  | 4541.00  | 4081.00  | 5459.00  | 4273.00  | 3147.00  | 
    | MAIN-317       | 16TR-317           | 2               | 18786.00  | 898.00   | 241.00   | 1229.00  | 1965.00  | 740.00   | 715.00   | 3507.00  | 2534.00  | 770.00   | 2360.00  | 3255.00  | 572.00   | 
    | MAIN-317       | 16TR-317           | 3               | 26942.00  | 1098.00  | 2338.00  | 1335.00  | 1626.00  | 3469.00  | 2624.00  | 2442.00  | 2007.00  | 3311.00  | 3099.00  | 1018.00  | 2575.00  | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-317       | 16TR-317           | 2               | 1998.55   | 1998.55  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-317       | 16TR-317           | 3               | 1345.49   | 1345.49  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 1998.55   | 1998.55  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | 1345.49   | 1345.49  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 1998.55   | 1998.55  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | 1345.49   | 1345.49  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/10/2018'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Sep 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201808 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7636.51     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201808 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 6106.59     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201809 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 9643.83     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201809 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 9439.59     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201810 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 5879.93     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201810 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 8826.13     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201811 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7135.81     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201811 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 2711.88     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201812 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1818.31     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201812 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1645.17     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201901 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1776.15     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201901 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 598.51      |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201902 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 335.57      |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201902 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1561.92     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201903 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 620.25      |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201903 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 2283.21     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201904 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1230.52     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201904 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 830.03      |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201905 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 2357.13     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201905 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1448.93     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201906 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 804.25      |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201906 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1896.14     |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201907 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 396.90      |
    | ILR1819        | R02                  | ORG0017317     | CM             | 201907 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1815.35     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

	# Check CRM
    
    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 45728.00  | 1996.00  | 2579.00  | 2564.00  | 3591.00  | 4209.00  | 3339.00  | 5949.00  | 4541.00  | 4081.00  | 5459.00  | 4273.00  | 3147.00  | 
    | MAIN-317       | 16TR-317           | 2               | 18786.00  | 898.00   | 241.00   | 1229.00  | 1965.00  | 740.00   | 715.00   | 3507.00  | 2534.00  | 770.00   | 2360.00  | 3255.00  | 572.00   | 
    | MAIN-317       | 16TR-317           | 3               | 26942.00  | 1098.00  | 2338.00  | 1335.00  | 1626.00  | 3469.00  | 2624.00  | 2442.00  | 2007.00  | 3311.00  | 3099.00  | 1018.00  | 2575.00  | 
	
    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-317       | 16TR-317           | 2               | 17280.34  | 7636.51  | 9643.83  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-317       | 16TR-317           | 3               | 15546.18  | 6106.59  | 9439.59  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
	
    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 17280.34  | 1998.55  | 15281.79 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | 15546.18  | 1345.49  | 14200.69 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | -2136.46  | 0.00     | -2136.46 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | -1922.06  | 0.00     | -1922.06 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 15143.88  | 1998.55  | 13145.33 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | 13624.12  | 1345.49  | 12278.63 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
	
	


    # Change the date
    Given the override date is '05/11/2018'

    # Bulk file to amend the profile values and adjust the capping amounts
    And   there are no files prefixed '10017317' in the Sharepoint 'MAIN-1819-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1819 09032020165637 v3_A317' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1819 09032020165637 v3_A317' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1819 09032020165637 v3_A317' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1819 09032020165637 v3_A317' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 1819 09032020165637 v3_A317.xlsx' exists in the Datafiles folder and UKPRN '10017317' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'MAIN-317' is in a state of 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'MAIN-317'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-317' and actual ContractNumber 'MAIN-317'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-317' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017317 | MAIN-317           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017317 | MAIN-317           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017317 | ESFA-317           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'MAIN-317'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | 16TR-317      | 2201300          | Jul-19 | Reconciliation |
	| 16TR-317      | 2201350          | Jul-19 | Reconciliation |




    # Check CRM financials after the recalc triggered by the amendment approval. Cap should be rolled back

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 47305.00  | 33406.00 | 13899.00 | 6553.00  | 1360.00  | 5531.00  | 2860.00  | 2549.00  | 5803.00  | 3771.00  | 4979.00  | 3305.00  | 4437.00  | 2091.00  | 4066.00  | 
    | MAIN-317       | 16TR-317           | 2               | 20222.00  | 14569.00 | 5653.00  | 1786.00  | 1127.00  | 3376.00  | 1518.00  | 1042.00  | 1631.00  | 1754.00  | 2335.00  | 1702.00  | 2650.00  | 696.00   | 605.00   | 
    | MAIN-317       | 16TR-317           | 3               | 27083.00  | 27083.00 | 18837.00 | 4767.00  | 233.00   | 2155.00  | 1342.00  | 1507.00  | 4172.00  | 2017.00  | 2644.00  | 1603.00  | 1787.00  | 1395.00  | 3461.00  | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 19416.80  | 1998.55  | 15281.79 | 2136.46  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | 17468.24  | 1345.49  | 14200.69 | 1922.06  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | -2136.46  | 0.00     | -2136.46 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | -1922.06  | 0.00     | -1922.06 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 17280.34  | 1998.55  | 13145.33 | 2136.46  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | 15546.18  | 1345.49  | 12278.63 | 1922.06  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/04/2019'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Mar 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201808 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7636.51     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201808 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 6106.59     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201809 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 9643.83     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201809 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 9439.59     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201810 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 5879.93     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201810 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 8826.13     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201811 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7135.81     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201811 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 2711.88     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201812 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1818.31     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201812 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1645.17     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201901 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1776.15     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201901 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 598.51      |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201902 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 335.57      |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201902 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1561.92     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201903 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 620.25      |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201903 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 2283.21     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201904 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1230.52     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201904 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 830.03      |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201905 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 2357.13     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201905 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1448.93     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201906 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 804.25      |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201906 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1896.14     |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201907 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 396.90      |
    | ILR1819        | R08                  | ORG0017317     | CM             | 201907 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1815.35     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

	# Check CRM

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 47305.00  | 33406.00 | 13899.00 | 6553.00  | 1360.00  | 5531.00  | 2860.00  | 2549.00  | 5803.00  | 3771.00  | 4979.00  | 3305.00  | 4437.00  | 2091.00  | 4066.00  | 
    | MAIN-317       | 16TR-317           | 2               | 20222.00  | 14569.00 | 5653.00  | 1786.00  | 1127.00  | 3376.00  | 1518.00  | 1042.00  | 1631.00  | 1754.00  | 2335.00  | 1702.00  | 2650.00  | 696.00   | 605.00   | 
    | MAIN-317       | 16TR-317           | 3               | 27083.00  | 27083.00 | 18837.00 | 4767.00  | 233.00   | 2155.00  | 1342.00  | 1507.00  | 4172.00  | 2017.00  | 2644.00  | 1603.00  | 1787.00  | 1395.00  | 3461.00  | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-317       | 16TR-317           | 2               | 34846.36  | 7636.51  | 9643.83  | 5879.93  | 7135.81  | 1818.31  | 1776.15  | 335.57   | 620.25   | ?        | ?        | ?        | ?        | 
    | MAIN-317       | 16TR-317           | 3               | 33173.00  | 6106.59  | 9439.59  | 8826.13  | 2711.88  | 1645.17  | 598.51   | 1561.92  | 2283.21  | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 36982.82  | 1998.55  | 15281.79 | 2136.46  | 0.00     | 0.00     | 0.00     | 0.00     | 17566.02 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | 35095.06  | 1345.49  | 14200.69 | 1922.06  | 0.00     | 0.00     | 0.00     | 0.00     | 17626.82 | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19    | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | -19868.91 | 0.00     | -2136.46 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -17732.45 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | -18802.97 | 0.00     | -1922.06 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -16880.91 | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 17113.91  | 1998.55  | 13145.33 | 2136.46  | 0.00     | 0.00     | 0.00     | 0.00     | -166.43  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | 16292.09  | 1345.49  | 12278.63 | 1922.06  | 0.00     | 0.00     | 0.00     | 0.00     | 745.91   | 0.00     | 0.00     | 0.00     | 0.00     | 




    # Add actuals to the contract for the second financial period. No capping in FP2

    # Change the date
    Given the override date is '04/05/2019'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Apr 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201808 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7636.51     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201808 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 6106.59     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201809 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 9643.83     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201809 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 9439.59     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201810 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 5879.93     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201810 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 8826.13     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201811 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7135.81     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201811 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 2711.88     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201812 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1818.31     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201812 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1645.17     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201901 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1776.15     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201901 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 598.51      |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201902 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 335.57      |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201902 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1561.92     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201903 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 620.25      |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201903 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 2283.21     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201904 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1230.52     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201904 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 830.03      |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201905 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 2357.13     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201905 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 9448.93     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201906 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7804.25     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201906 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1896.14     |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201907 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 396.90      |
    | ILR1819        | R09                  | ORG0017317     | CM             | 201907 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1815.35     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

	# Check CRM

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 47305.00  | 33406.00 | 13899.00 | 6553.00  | 1360.00  | 5531.00  | 2860.00  | 2549.00  | 5803.00  | 3771.00  | 4979.00  | 3305.00  | 4437.00  | 2091.00  | 4066.00  | 
    | MAIN-317       | 16TR-317           | 2               | 20222.00  | 14569.00 | 5653.00  | 1786.00  | 1127.00  | 3376.00  | 1518.00  | 1042.00  | 1631.00  | 1754.00  | 2335.00  | 1702.00  | 2650.00  | 696.00   | 605.00   | 
    | MAIN-317       | 16TR-317           | 3               | 27083.00  | 27083.00 | 18837.00 | 4767.00  | 233.00   | 2155.00  | 1342.00  | 1507.00  | 4172.00  | 2017.00  | 2644.00  | 1603.00  | 1787.00  | 1395.00  | 3461.00  | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-317       | 16TR-317           | 2               | 36076.88  | 7636.51  | 9643.83  | 5879.93  | 7135.81  | 1818.31  | 1776.15  | 335.57   | 620.25   | 1230.52  | ?        | ?        | ?        | 
    | MAIN-317       | 16TR-317           | 3               | 34003.03  | 6106.59  | 9439.59  | 8826.13  | 2711.88  | 1645.17  | 598.51   | 1561.92  | 2283.21  | 830.03   | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 55945.79  | 1998.55  | 15281.79 | 2136.46  | 0.00     | 0.00     | 0.00     | 0.00     | 17566.02 | 18962.97 | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | 52806.00  | 1345.49  | 14200.69 | 1922.06  | 0.00     | 0.00     | 0.00     | 0.00     | 17626.82 | 17710.94 | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | -37601.36 | 0.00     | -2136.46 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -17732.45| -17732.45| 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | -35683.88 | 0.00     | -1922.06 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -16880.91| -16880.91| 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 18344.43  | 1998.55  | 13145.33 | 2136.46  | 0.00     | 0.00     | 0.00     | 0.00     | -166.43  | 1230.52  | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | 17122.12  | 1345.49  | 12278.63 | 1922.06  | 0.00     | 0.00     | 0.00     | 0.00     | 745.91   | 830.03   | 0.00     | 0.00     | 0.00     | 




    # Add actuals to the contract for the second financial period. Capping occurs in FP2

    # Change the date
    Given the override date is '04/06/2019'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for May 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201808 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7636.51     |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201808 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 6106.59     |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201809 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 9643.83     |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201809 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 9439.59     |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201810 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 5879.93     |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201810 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 8826.13     |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201811 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7135.81     |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201811 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 2711.88     |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201812 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1818.31     |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201812 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1645.17     |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201901 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1776.15     |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201901 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 0.25        |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201902 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 0.33        |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201902 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1561.92     |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201903 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 620.25      |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201903 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 2283.21     |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201904 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1230.52     |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201904 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 830.03      |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201905 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 12357.13    |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201905 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 29448.93    |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201906 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7804.25     |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201906 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1896.14     |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201907 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 396.90      |
    | ILR1819        | R10                  | ORG0017317     | CM             | 201907 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1815.35     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

	# Check CRM

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 47305.00  | 33406.00 | 13899.00 | 6553.00  | 1360.00  | 5531.00  | 2860.00  | 2549.00  | 5803.00  | 3771.00  | 4979.00  | 3305.00  | 4437.00  | 2091.00  | 4066.00  | 
    | MAIN-317       | 16TR-317           | 2               | 20222.00  | 14569.00 | 5653.00  | 1786.00  | 1127.00  | 3376.00  | 1518.00  | 1042.00  | 1631.00  | 1754.00  | 2335.00  | 1702.00  | 2650.00  | 696.00   | 605.00   | 
    | MAIN-317       | 16TR-317           | 3               | 27083.00  | 27083.00 | 18837.00 | 4767.00  | 233.00   | 2155.00  | 1342.00  | 1507.00  | 4172.00  | 2017.00  | 2644.00  | 1603.00  | 1787.00  | 1395.00  | 3461.00  | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-317       | 16TR-317           | 2               | 48098.77  | 7636.51  | 9643.83  | 5879.93  | 7135.81  | 1818.31  | 1776.15  | 0.33     | 620.25   | 1230.52  | 12357.13 | ?        | ?        | 
    | MAIN-317       | 16TR-317           | 3               | 62853.70  | 6106.59  | 9439.59  | 8826.13  | 2711.88  | 1645.17  | 0.25     | 1561.92  | 2283.21  | 830.03   | 29448.93 | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 85700.13  | 1998.55  | 15281.79 | 2136.46  | 0.00     | 0.00     | 0.00     | 0.00     | 17566.02 | 18962.97 | 29754.34 | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | 98537.58  | 1345.49  | 14200.69 | 1922.06  | 0.00     | 0.00     | 0.00     | 0.00     | 17626.82 | 17710.94 | 45731.58 | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | -64209.81 | 0.00     | -2136.46 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -17732.45| -17732.45| -26608.45| 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | -72722.91 | 0.00     | -1922.06 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -16880.91| -16880.91| -37039.02| 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 21490.32  | 1998.55  | 13145.33 | 2136.46  | 0.00     | 0.00     | 0.00     | 0.00     | -166.43  | 1230.52  | 3145.89  | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | 25814.68  | 1345.49  | 12278.63 | 1922.06  | 0.00     | 0.00     | 0.00     | 0.00     | 745.91   | 830.03   | 8692.56  | 0.00     | 0.00     | 




    # Add actuals to the contract in the second financial period. Capping occurs

    # Change the date
    Given the override date is '04/08/2019'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Jul 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201808 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7636.51     |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201808 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 6106.59     |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201809 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 9643.83     |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201809 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 9439.59     |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201810 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 5879.93     |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201810 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 8826.13     |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201811 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7135.81     |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201811 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 2711.88     |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201812 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1818.31     |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201812 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1645.17     |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201901 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1776.15     |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201901 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 0.25        |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201902 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 0.33        |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201902 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1561.92     |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201903 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 620.25      |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201903 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 2283.21     |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201904 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1230.52     |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201904 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 830.03      |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201905 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 12357.13    |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201905 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 29448.93    |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201906 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7804.25     |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201906 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1896.14     |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201907 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 396.90      |
    | ILR1819        | R12                  | ORG0017317     | CM             | 201907 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1815.35     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

	# Check CRM

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 47305.00  | 33406.00 | 13899.00 | 6553.00  | 1360.00  | 5531.00  | 2860.00  | 2549.00  | 5803.00  | 3771.00  | 4979.00  | 3305.00  | 4437.00  | 2091.00  | 4066.00  | 
    | MAIN-317       | 16TR-317           | 2               | 20222.00  | 14569.00 | 5653.00  | 1786.00  | 1127.00  | 3376.00  | 1518.00  | 1042.00  | 1631.00  | 1754.00  | 2335.00  | 1702.00  | 2650.00  | 696.00   | 605.00   | 
    | MAIN-317       | 16TR-317           | 3               | 27083.00  | 27083.00 | 18837.00 | 4767.00  | 233.00   | 2155.00  | 1342.00  | 1507.00  | 4172.00  | 2017.00  | 2644.00  | 1603.00  | 1787.00  | 1395.00  | 3461.00  | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-317       | 16TR-317           | 2               | 56299.92  | 7636.51  | 9643.83  | 5879.93  | 7135.81  | 1818.31  | 1776.15  | 0.33     | 620.25   | 1230.52  | 12357.13 | 7804.25  | 396.90   | 
    | MAIN-317       | 16TR-317           | 3               | 66565.19  | 6106.59  | 9439.59  | 8826.13  | 2711.88  | 1645.17  | 0.25     | 1561.92  | 2283.21  | 830.03   | 29448.93 | 1896.14  | 1815.35  | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 120509.70 | 1998.55  | 15281.79 | 2136.46  | 0.00     | 0.00     | 0.00     | 0.00     | 17566.02 | 18962.97 | 29754.34 | 0.00     | 34809.60 | 
    | MAIN-317       | 16TR-317           | 3               | 139288.10 | 1345.49  | 14200.69 | 1922.06  | 0.00     | 0.00     | 0.00     | 0.00     | 17626.82 | 17710.94 | 45731.58 | 0.00     | 40750.51 | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | -97895.31 | 0.00     | -2136.46 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -17732.45| -17732.45| -26608.45| 0.00     | -33685.50| 
    | MAIN-317       | 16TR-317           | 3               | -114597.50| 0.00     | -1922.06 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -16880.91| -16880.91| -37039.02| 0.00     | -41874.61| 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 22614.42  | 1998.55  | 13145.33 | 2136.46  | 0.00     | 0.00     | 0.00     | 0.00     | -166.43  | 1230.52  | 3145.89  | 0.00     | 1124.10  | 
    | MAIN-317       | 16TR-317           | 3               | 24690.58  | 1345.49  | 12278.63 | 1922.06  | 0.00     | 0.00     | 0.00     | 0.00     | 745.91   | 830.03   | 8692.56  | 0.00     | -1124.10 | 




    # Post Year-End

    # Change the date
    Given the override date is '04/10/2019'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Sep 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201808 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7636.51     |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201808 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 6106.59     |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201809 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 9643.83     |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201809 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 9439.59     |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201810 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 5879.93     |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201810 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 8826.13     |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201811 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7135.81     |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201811 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 2711.88     |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201812 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1818.31     |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201812 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1645.17     |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201901 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1776.15     |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201901 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 588.25      |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201902 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 654.33      |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201902 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1561.92     |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201903 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 620.25      |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201903 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 2283.21     |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201904 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 1230.52     |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201904 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 830.03      |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201905 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 12357.13    |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201905 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 29448.93    |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201906 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 7804.25     |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201906 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1896.14     |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201907 | 16-18TRN1819            | 16TR-317                 | ?          | 2               | 0            | 396.90      |
    | ILR1819        | R14                  | ORG0017317     | CM             | 201907 | 16-18TRN1819            | 16TR-317                 | ?          | 3               | 0            | 1815.35     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

	# Check CRM

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Nov-19   |
    | MAIN-317       | 16TR-317           | 1               | 47305.00  | 6553.00  | 1360.00  | 5531.00  | 2860.00  | 2549.00  | 5803.00  | 3771.00  | 4979.00  | 3305.00  | 4437.00  | 2091.00  | 4066.00  | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 20222.00  | 1786.00  | 1127.00  | 3376.00  | 1518.00  | 1042.00  | 1631.00  | 1754.00  | 2335.00  | 1702.00  | 2650.00  | 696.00   | 605.00   | 0.00     | 
    | MAIN-317       | 16TR-317           | 3               | 27083.00  | 4767.00  | 233.00   | 2155.00  | 1342.00  | 1507.00  | 4172.00  | 2017.00  | 2644.00  | 1603.00  | 1787.00  | 1395.00  | 3461.00  | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Nov-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-317       | 16TR-317           | 2               | 56953.91  | 7636.51  | 9643.83  | 5879.93  | 7135.81  | 1818.31  | 1776.15  | 654.33   | 620.25   | 1230.52  | 12357.13 | 7804.25  | 396.90   | ?        | 
    | MAIN-317       | 16TR-317           | 3               | 67153.19  | 6106.59  | 9439.59  | 8826.13  | 2711.88  | 1645.17  | 588.25   | 1561.92  | 2283.21  | 830.03   | 29448.93 | 1896.14  | 1815.35  | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Nov-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 154849.20 | 1998.55  | 15281.79 | 2136.46  | 0.00     | 0.00     | 0.00     | 0.00     | 17566.02 | 18962.97 | 29754.34 | 0.00     | 34809.60 | 34339.50 | 
    | MAIN-317       | 16TR-317           | 3               | 181750.70 | 1345.49  | 14200.69 | 1922.06  | 0.00     | 0.00     | 0.00     | 0.00     | 17626.82 | 17710.94 | 45731.58 | 0.00     | 40750.51 | 42462.61 | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total      | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19    | Apr-19    | May-19    | Jun-19   | Jul-19    | Nov-19    |
    | MAIN-317       | 16TR-317           | 1               | 0.00       | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00      | 0.00      | 0.00     | 0.00      | 0.00      | 
    | MAIN-317       | 16TR-317           | 2               | -132227.40 | 0.00     | -2136.46 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -17732.45 | -17732.45 | -26608.45 | 0.00     | -33685.50 | -34332.13 | 
    | MAIN-317       | 16TR-317           | 3               | -157067.50 | 0.00     | -1922.06 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -16880.91 | -16880.91 | -37039.02 | 0.00     | -41874.61 | -42469.98 | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Nov-19   |
    | MAIN-317       | 16TR-317           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-317       | 16TR-317           | 2               | 22621.79  | 1998.55  | 13145.33 | 2136.46  | 0.00     | 0.00     | 0.00     | 0.00     | -166.43  | 1230.52  | 3145.89  | 0.00     | 1124.10  | 7.37     | 
    | MAIN-317       | 16TR-317           | 3               | 24683.21  | 1345.49  | 12278.63 | 1922.06  | 0.00     | 0.00     | 0.00     | 0.00     | 745.91   | 830.03   | 8692.56  | 0.00     | -1124.10 | -7.37    | 


	# Tidy up
    And   the override date is reset