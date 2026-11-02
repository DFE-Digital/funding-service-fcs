Feature: ActualsAndBack-DatedTerminationsD 24613

@AcceptanceTest @Withdrawn20230123
Scenario: A856 Create and approve a 3-allocation 1819 Loans contract. Consume actuals. Initiate future-dated termination (without amendment) and approve initiation. Check CRM, PaaS and Feed. Update termination details. Check CRM, PaaS and Feed.
    Given there are no allocations marked as Under Termination for UKPRN '10017856' 
    And   there are no terminated or closed allocations for UKPRN '10017856' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017856' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLC-856      |
    | ALLF-856      |
    | CLP-856       |

    # Clear down PaymentSchedule.DeliverablePayment data for an allocation
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLC-856      |
    | ALLF-856      |
    | CLP-856       |

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS




    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017856' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017856 Co Ltd' with UKPRN '10017856' and OrgId 'ORG0017856' and has 'FCS1 Test' as a manager 
    And   UPIN '117856' is associated with UKPRN '10017856' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017856 | 117856 | 10017856 Co Ltd | 0              | Active | Yes           | AA017856      | ?             | 

    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017856 | 10017856 Co Ltd      | ESFA-856             | LOANS-856      | 1                     | 01/08/2018        | 31/07/2019      | 68816.00      |                                | Contract for Services | 1819   | New          | ORG0017856 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017856 | LOANS-856      | ALLC-856      | ALLBC             | ALLBC1819               | AY                      | 01/08/2018          | 31/07/2019        | 24560.00        |                                         |            |                                                             | New          |             |
    | 10017856 | LOANS-856      | ALLF-856      | ALLF              | ALLF1819                | AY                      | 01/08/2018          | 31/07/2019        | 25527.00        |                                         |            |                                                             | New          |             |
    | 10017856 | LOANS-856      | CLP-856       | CLP               | CLP1819                 | AY                      | 01/08/2018          | 31/07/2019        | 18729.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017856 | LOANS-856      | ALLC-856      | 1               | 0                     | 24560.00  | 2898.00  | 2873.00  | 1964.00  | 990.00   | 2928.00  | 817.00   | 1712.00  | 2730.00  | 1410.00  | 2651.00  | 1648.00  | 1939.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             |
    | 10017856 | LOANS-856      | ALLF-856      | 5               | 0                     | 25527.00  | 773.00   | 3629.00  | 3446.00  | 3011.00  | 615.00   | 402.00   | 2023.00  | 3580.00  | 1628.00  | 2048.00  | 1771.00  | 2601.00  | Advanced Learner Loans Facility                                 | New          |             |
    | 10017856 | LOANS-856      | CLP-856       | 1               | 0                     | 18729.00  | 1269.00  | 2321.00  | 147.00   | 250.00   | 922.00   | 1624.00  | 1254.00  | 3349.00  | 764.00   | 2099.00  | 3531.00  | 1199.00  | Career Learning Pilots                                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'LOANS-856' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-856' and actual ContractNumber 'LOANS-856'

    # Check that the contract is now approved
    Then  the latest version of contract 'LOANS-856' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017856 | LOANS-856          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017856 | ESFA-856           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '108' deliverable period rows in CRM linked to the latest version of contract 'LOANS-856'




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/12/2018'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017856'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Nov 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201808 | ALLBC1819               | ALLC-856                 | ?          | 2               | 0            | 1119.61     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201808 | ALLBC1819               | ALLC-856                 | ?          | 3               | 0            | 935.11      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201808 | ALLBC1819               | ALLC-856                 | ?          | 4               | 0            | 2424.81     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201809 | ALLBC1819               | ALLC-856                 | ?          | 2               | 0            | 997.17      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201809 | ALLBC1819               | ALLC-856                 | ?          | 3               | 0            | 205.71      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201809 | ALLBC1819               | ALLC-856                 | ?          | 4               | 0            | 853.17      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201810 | ALLBC1819               | ALLC-856                 | ?          | 2               | 0            | 2141.51     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201810 | ALLBC1819               | ALLC-856                 | ?          | 3               | 0            | 1634.37     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201810 | ALLBC1819               | ALLC-856                 | ?          | 4               | 0            | 1932.21     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201811 | ALLBC1819               | ALLC-856                 | ?          | 2               | 0            | 2252.27     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201811 | ALLBC1819               | ALLC-856                 | ?          | 3               | 0            | 661.94      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201811 | ALLBC1819               | ALLC-856                 | ?          | 4               | 0            | 1669.89     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201812 | ALLBC1819               | ALLC-856                 | ?          | 2               | 0            | 1385.17     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201812 | ALLBC1819               | ALLC-856                 | ?          | 3               | 0            | 471.99      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201812 | ALLBC1819               | ALLC-856                 | ?          | 4               | 0            | 1163.50     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201901 | ALLBC1819               | ALLC-856                 | ?          | 2               | 0            | 882.98      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201901 | ALLBC1819               | ALLC-856                 | ?          | 3               | 0            | 2192.55     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201901 | ALLBC1819               | ALLC-856                 | ?          | 4               | 0            | 909.80      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201902 | ALLBC1819               | ALLC-856                 | ?          | 2               | 0            | 1470.21     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201902 | ALLBC1819               | ALLC-856                 | ?          | 3               | 0            | 502.51      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201902 | ALLBC1819               | ALLC-856                 | ?          | 4               | 0            | 2315.03     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201903 | ALLBC1819               | ALLC-856                 | ?          | 2               | 0            | 1799.23     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201903 | ALLBC1819               | ALLC-856                 | ?          | 3               | 0            | 431.43      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201903 | ALLBC1819               | ALLC-856                 | ?          | 4               | 0            | 1730.38     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201904 | ALLBC1819               | ALLC-856                 | ?          | 2               | 0            | 2496.87     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201904 | ALLBC1819               | ALLC-856                 | ?          | 3               | 0            | 2257.41     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201904 | ALLBC1819               | ALLC-856                 | ?          | 4               | 0            | 1445.75     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201905 | ALLBC1819               | ALLC-856                 | ?          | 2               | 0            | 1720.82     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201905 | ALLBC1819               | ALLC-856                 | ?          | 3               | 0            | 1225.33     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201905 | ALLBC1819               | ALLC-856                 | ?          | 4               | 0            | 972.58      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201906 | ALLBC1819               | ALLC-856                 | ?          | 2               | 0            | 1998.47     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201906 | ALLBC1819               | ALLC-856                 | ?          | 3               | 0            | 967.94      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201906 | ALLBC1819               | ALLC-856                 | ?          | 4               | 0            | 1368.16     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201907 | ALLBC1819               | ALLC-856                 | ?          | 2               | 0            | 1720.82     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201907 | ALLBC1819               | ALLC-856                 | ?          | 3               | 0            | 1225.33     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201907 | ALLBC1819               | ALLC-856                 | ?          | 4               | 0            | 972.58      |
    #
    | ILR1819        | R04                  | ORG0017856     | CM             | 201808 | ALLF1819                | ALLF-856                 | ?          | 2               | 0            | 2252.27     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201808 | ALLF1819                | ALLF-856                 | ?          | 6               | 0            | 661.94      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201808 | ALLF1819                | ALLF-856                 | ?          | 7               | 0            | 1669.89     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201809 | ALLF1819                | ALLF-856                 | ?          | 2               | 0            | 1385.17     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201809 | ALLF1819                | ALLF-856                 | ?          | 6               | 0            | 471.99      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201809 | ALLF1819                | ALLF-856                 | ?          | 7               | 0            | 1163.50     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201810 | ALLF1819                | ALLF-856                 | ?          | 2               | 0            | 882.98      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201810 | ALLF1819                | ALLF-856                 | ?          | 6               | 0            | 2192.55     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201810 | ALLF1819                | ALLF-856                 | ?          | 7               | 0            | 909.80      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201811 | ALLF1819                | ALLF-856                 | ?          | 2               | 0            | 1470.21     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201811 | ALLF1819                | ALLF-856                 | ?          | 6               | 0            | 502.51      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201811 | ALLF1819                | ALLF-856                 | ?          | 7               | 0            | 2315.03     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201812 | ALLF1819                | ALLF-856                 | ?          | 2               | 0            | 1799.23     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201812 | ALLF1819                | ALLF-856                 | ?          | 6               | 0            | 431.43      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201812 | ALLF1819                | ALLF-856                 | ?          | 7               | 0            | 1730.38     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201901 | ALLF1819                | ALLF-856                 | ?          | 2               | 0            | 2496.87     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201901 | ALLF1819                | ALLF-856                 | ?          | 6               | 0            | 2257.41     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201901 | ALLF1819                | ALLF-856                 | ?          | 7               | 0            | 1445.75     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201902 | ALLF1819                | ALLF-856                 | ?          | 2               | 0            | 1720.82     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201902 | ALLF1819                | ALLF-856                 | ?          | 6               | 0            | 1225.33     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201902 | ALLF1819                | ALLF-856                 | ?          | 7               | 0            | 972.58      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201903 | ALLF1819                | ALLF-856                 | ?          | 2               | 0            | 1998.47     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201903 | ALLF1819                | ALLF-856                 | ?          | 6               | 0            | 967.94      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201903 | ALLF1819                | ALLF-856                 | ?          | 7               | 0            | 1368.16     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201904 | ALLF1819                | ALLF-856                 | ?          | 2               | 0            | 291.57      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201904 | ALLF1819                | ALLF-856                 | ?          | 6               | 0            | 599.10      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201904 | ALLF1819                | ALLF-856                 | ?          | 7               | 0            | 1693.17     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201905 | ALLF1819                | ALLF-856                 | ?          | 2               | 0            | 611.02      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201905 | ALLF1819                | ALLF-856                 | ?          | 6               | 0            | 1307.31     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201905 | ALLF1819                | ALLF-856                 | ?          | 7               | 0            | 1918.91     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201906 | ALLF1819                | ALLF-856                 | ?          | 2               | 0            | 2032.79     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201906 | ALLF1819                | ALLF-856                 | ?          | 6               | 0            | 1695.10     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201906 | ALLF1819                | ALLF-856                 | ?          | 7               | 0            | 1946.29     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201907 | ALLF1819                | ALLF-856                 | ?          | 2               | 0            | 928.33      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201907 | ALLF1819                | ALLF-856                 | ?          | 6               | 0            | 425.41      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201907 | ALLF1819                | ALLF-856                 | ?          | 7               | 0            | 1654.52     |
    #
    | ILR1819        | R04                  | ORG0017856     | CM             | 201808 | CLP1819                 | CLP-856                  | ?          | 1               | 0            | 456.12      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201809 | CLP1819                 | CLP-856                  | ?          | 1               | 0            | 1234.55     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201810 | CLP1819                 | CLP-856                  | ?          | 1               | 0            | 599.52      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201811 | CLP1819                 | CLP-856                  | ?          | 1               | 0            | 2192.55     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201812 | CLP1819                 | CLP-856                  | ?          | 1               | 0            | 909.80      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201901 | CLP1819                 | CLP-856                  | ?          | 1               | 0            | 1470.21     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201902 | CLP1819                 | CLP-856                  | ?          | 1               | 0            | 502.51      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201903 | CLP1819                 | CLP-856                  | ?          | 1               | 0            | 2315.03     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201904 | CLP1819                 | CLP-856                  | ?          | 1               | 0            | 1799.23     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201905 | CLP1819                 | CLP-856                  | ?          | 1               | 0            | 431.43      |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201906 | CLP1819                 | CLP-856                  | ?          | 1               | 0            | 1730.38     |
    | ILR1819        | R04                  | ORG0017856     | CM             | 201907 | CLP1819                 | CLP-856                  | ?          | 1               | 0            | 2496.87     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service




    # Check CRM and PaaS BEFORE the Termination

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-856      | ALLC-856        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLC-856        | 2               | 6510.56  | 1119.61  | 997.17   | 2141.51  | 2252.27  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLC-856        | 3               | 3437.13  | 935.11   | 205.71   | 1634.37  | 661.94   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLC-856        | 4               | 6880.08  | 2424.81  | 853.17   | 1932.21  | 1669.89  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | LOANS-856      | ALLF-856        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLF-856        | 2               | 17869.73 | 2252.27  | 1385.17  | 882.98   | 1470.21  | 1799.23  | 2496.87  | 1720.82  | 1998.47  | 291.57   | 611.02   | 2032.79  | 928.33   | 
    | LOANS-856      | ALLF-856        | 6               | 12738.02 | 661.94   | 471.99   | 2192.55  | 502.51   | 431.43   | 2257.41  | 1225.33  | 967.94   | 599.10   | 1307.31  | 1695.10  | 425.41   | 
    | LOANS-856      | ALLF-856        | 7               | 18787.98 | 1669.89  | 1163.50  | 909.80   | 2315.03  | 1730.38  | 1445.75  | 972.58   | 1368.16  | 1693.17  | 1918.91  | 1946.29  | 1654.52  | 
    #
    | LOANS-856      | CLP-856         | 1               | 4482.74  | 456.12   | 1234.55  | 599.52   | 2192.55  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-856      | ALLC-856        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | LOANS-856      | ALLF-856        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 7               | 6058.22  | 1669.89  | 1163.50  | 909.80   | 2315.03  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | LOANS-856      | CLP-856         | 1               | 4482.74  | 0.00     | 0.00     | 0.00     | 4482.74  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-856      | ALLC-856        | 1               | 24560.00 | 2898.00  | 2873.00  | 1964.00  | 990.00   | 2928.00  | 817.00   | 1712.00  | 2730.00  | 1410.00  | 2651.00  | 1648.00  | 1939.00  | 
    | LOANS-856      | ALLC-856        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | LOANS-856      | ALLF-856        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 7               | 6058.22  | 1669.89  | 1163.50  | 909.80   | 2315.03  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | LOANS-856      | CLP-856         | 1               | 4482.74  | 0.00     | 0.00     | 0.00     | 4482.74  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
	
    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | ALLC-856         | 1             | 1               | 201808 | 2              | 0             | 2898.00      | 2898.00              | 0.00                | 0.00                   | 0.00                        | 2898.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1119.61     |
    | ALLC-856         | 1             | 3               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 935.11      |
    | ALLC-856         | 1             | 4               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2424.81     |
    | ALLC-856         | 1             | 1               | 201809 | 2              | 0             | 2873.00      | 2873.00              | 0.00                | 0.00                   | 0.00                        | 2873.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 997.17      |
    | ALLC-856         | 1             | 3               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 205.71      |
    | ALLC-856         | 1             | 4               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 853.17      |
    | ALLC-856         | 1             | 1               | 201810 | 2              | 0             | 1964.00      | 1964.00              | 0.00                | 0.00                   | 0.00                        | 1964.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2141.51     |
    | ALLC-856         | 1             | 3               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1634.37     |
    | ALLC-856         | 1             | 4               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1932.21     |
    | ALLC-856         | 1             | 1               | 201811 | 2              | 0             | 990.00       | 990.00               | 0.00                | 0.00                   | 0.00                        | 990.00           | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2252.27     |
    | ALLC-856         | 1             | 3               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 661.94      |
    | ALLC-856         | 1             | 4               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1669.89     |
    | ALLC-856         | 1             | 1               | 201812 | 2              | 0             | 2928.00      | 2928.00              | 0.00                | 0.00                   | 0.00                        | 2928.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201901 | 2              | 0             | 817.00       | 817.00               | 0.00                | 0.00                   | 0.00                        | 817.00           | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201902 | 2              | 0             | 1712.00      | 1712.00              | 0.00                | 0.00                   | 0.00                        | 1712.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201903 | 2              | 0             | 2730.00      | 2730.00              | 0.00                | 0.00                   | 0.00                        | 2730.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201904 | 2              | 0             | 1410.00      | 1410.00              | 0.00                | 0.00                   | 0.00                        | 1410.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201905 | 2              | 0             | 2651.00      | 2651.00              | 0.00                | 0.00                   | 0.00                        | 2651.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201906 | 2              | 0             | 1648.00      | 1648.00              | 0.00                | 0.00                   | 0.00                        | 1648.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201907 | 2              | 0             | 1939.00      | 1939.00              | 0.00                | 0.00                   | 0.00                        | 1939.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | ALLF-856         | 1             | 2               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2252.27     |
    | ALLF-856         | 1             | 5               | 201808 | 2              | 0             | 773.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 661.94      |
    | ALLF-856         | 1             | 7               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1669.89                     | 1669.89          | 0            | 1669.89     |
    | ALLF-856         | 1             | 2               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1385.17     |
    | ALLF-856         | 1             | 5               | 201809 | 2              | 0             | 3629.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 471.99      |
    | ALLF-856         | 1             | 7               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1163.50                     | 1163.50          | 0            | 1163.50     |
    | ALLF-856         | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 882.98      |
    | ALLF-856         | 1             | 5               | 201810 | 2              | 0             | 3446.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2192.55     |
    | ALLF-856         | 1             | 7               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 909.80                      | 909.80           | 0            | 909.80      |
    | ALLF-856         | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1470.21     |
    | ALLF-856         | 1             | 5               | 201811 | 2              | 0             | 3011.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 502.51      |
    | ALLF-856         | 1             | 7               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 2315.03                     | 2315.03          | 0            | 2315.03     |
    | ALLF-856         | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1799.23     |
    | ALLF-856         | 1             | 5               | 201812 | 2              | 0             | 615.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 431.43      |
    | ALLF-856         | 1             | 7               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1730.38     |
    | ALLF-856         | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2496.87     |
    | ALLF-856         | 1             | 5               | 201901 | 2              | 0             | 402.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2257.41     |
    | ALLF-856         | 1             | 7               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1445.75     |
    | ALLF-856         | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1720.82     |
    | ALLF-856         | 1             | 5               | 201902 | 2              | 0             | 2023.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1225.33     |
    | ALLF-856         | 1             | 7               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 972.58      |
    | ALLF-856         | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1998.47     |
    | ALLF-856         | 1             | 5               | 201903 | 2              | 0             | 3580.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 967.94      |
    | ALLF-856         | 1             | 7               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1368.16     |
    | ALLF-856         | 1             | 2               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 291.57      |
    | ALLF-856         | 1             | 5               | 201904 | 2              | 0             | 1628.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 599.10      |
    | ALLF-856         | 1             | 7               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1693.17     |
    | ALLF-856         | 1             | 2               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 611.02      |
    | ALLF-856         | 1             | 5               | 201905 | 2              | 0             | 2048.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1307.31     |
    | ALLF-856         | 1             | 7               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1918.91     |
    | ALLF-856         | 1             | 2               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2032.79     |
    | ALLF-856         | 1             | 5               | 201906 | 2              | 0             | 1771.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1695.10     |
    | ALLF-856         | 1             | 7               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1946.29     |
    | ALLF-856         | 1             | 2               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 928.33      |
    | ALLF-856         | 1             | 5               | 201907 | 2              | 0             | 2601.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 425.41      |
    | ALLF-856         | 1             | 7               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1654.52     |
    #
    | CLP-856          | 1             | 1               | 201808 | 2              | 0             | 1269.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 456.12      |
    | CLP-856          | 1             | 1               | 201809 | 2              | 0             | 2321.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1234.55     |
    | CLP-856          | 1             | 1               | 201810 | 2              | 0             | 147.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 599.52      |
    | CLP-856          | 1             | 1               | 201811 | 2              | 0             | 250.00       | 0.00                 | 0.00                | 0.00                   | 4482.74                     | 4482.74          | 0            | 2192.55     |
    | CLP-856          | 1             | 1               | 201812 | 2              | 0             | 922.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201901 | 2              | 0             | 1624.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201902 | 2              | 0             | 1254.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201903 | 2              | 0             | 3349.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201904 | 2              | 0             | 764.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201905 | 2              | 0             | 2099.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201906 | 2              | 0             | 3531.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201907 | 2              | 0             | 1199.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |

	
	
	
	# Initiate a TERMINATION

    # Change the date
    Given the override date is '18/12/2018'

    # Request termination of the contract 
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'LOANS-856' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | ?                        | ?                       | No                          | Other                   | ?                       |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ALLC-856         | 12/01/2019                  | 13/01/2019                |
    | ALLF-856         | 16/02/2019                  | 19/02/2019                |
    | CLP-856          | 24/03/2019                  | 26/03/2019                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task
    Given the following Tasks are created against version '1' of contract 'LOANS-856' for UKPRN '10017856'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017856 - 10017856 Co Ltd     | LOANS-856      | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017856 | LOANS-856           | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017856 | ESFA-856            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | LOANS-856      | 1                     | 0                        | ?                       | ?                       |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | ALLC-856         | 1                     | 0                        | 12/01/2019        | 13/01/2019                |
    | ALLF-856         | 1                     | 0                        | 16/02/2019        | 19/02/2019                |
    | CLP-856          | 1                     | 0                        | 24/03/2019        | 26/03/2019                |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '20/12/2018'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'LOANS-856' for provider '10017856' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus   | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017856 | LOANS-856           | 1                     | 0                        | Approved       | Under Termination   | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017856 | ESFA-856            | 1                     | 0                        | Draft          | ?                   | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Check CRM and PaaS AFTER the Termination Initiation Approval                                                    

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
	# No change
    | LOANS-856      | ALLC-856        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLC-856        | 2               | 6510.56  | 1119.61  | 997.17   | 2141.51  | 2252.27  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLC-856        | 3               | 3437.13  | 935.11   | 205.71   | 1634.37  | 661.94   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLC-856        | 4               | 6880.08  | 2424.81  | 853.17   | 1932.21  | 1669.89  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
	# Actuals in months after Termination date (19/02/2019) should be zeroised
    | LOANS-856      | ALLF-856        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLF-856        | 2               | 17869.73 | 2252.27  | 1385.17  | 882.98   | 1470.21  | 1799.23  | 2496.87  | 1720.82  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLF-856        | 6               | 12738.02 | 661.94   | 471.99   | 2192.55  | 502.51   | 431.43   | 2257.41  | 1225.33  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLF-856        | 7               | 18787.98 | 1669.89  | 1163.50  | 909.80   | 2315.03  | 1730.38  | 1445.75  | 972.58   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
	# No change
    | LOANS-856      | CLP-856         | 1               | 4482.74  | 456.12   | 1234.55  | 599.52   | 2192.55  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-856      | ALLC-856        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | LOANS-856      | ALLF-856        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 7               | 7788.60  | 1669.89  | 1163.50  | 909.80   | 2315.03  | 1730.38  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | LOANS-856      | CLP-856         | 1               | 4482.74  | 0.00     | 0.00     | 0.00     | 4482.74  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-856      | ALLC-856        | 1               | 24560.00 | 2898.00  | 2873.00  | 1964.00  | 990.00   | 2928.00  | 817.00   | 1712.00  | 2730.00  | 1410.00  | 2651.00  | 1648.00  | 1939.00  | 
    | LOANS-856      | ALLC-856        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | LOANS-856      | ALLF-856        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 7               | 7788.60  | 1669.89  | 1163.50  | 909.80   | 2315.03  | 1730.38  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | LOANS-856      | CLP-856         | 1               | 4482.74  | 0.00     | 0.00     | 0.00     | 4482.74  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | ALLC-856         | 1             | 1               | 201808 | 2              | 0             | 2898.00      | 2898.00              | 0.00                | 0.00                   | 0.00                        | 2898.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1119.61     |
    | ALLC-856         | 1             | 3               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 935.11      |
    | ALLC-856         | 1             | 4               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2424.81     |
    | ALLC-856         | 1             | 1               | 201809 | 2              | 0             | 2873.00      | 2873.00              | 0.00                | 0.00                   | 0.00                        | 2873.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 997.17      |
    | ALLC-856         | 1             | 3               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 205.71      |
    | ALLC-856         | 1             | 4               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 853.17      |
    | ALLC-856         | 1             | 1               | 201810 | 2              | 0             | 1964.00      | 1964.00              | 0.00                | 0.00                   | 0.00                        | 1964.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2141.51     |
    | ALLC-856         | 1             | 3               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1634.37     |
    | ALLC-856         | 1             | 4               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1932.21     |
    | ALLC-856         | 1             | 1               | 201811 | 2              | 0             | 990.00       | 990.00               | 0.00                | 0.00                   | 0.00                        | 990.00           | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2252.27     |
    | ALLC-856         | 1             | 3               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 661.94      |
    | ALLC-856         | 1             | 4               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1669.89     |
    | ALLC-856         | 1             | 1               | 201812 | 2              | 0             | 2928.00      | 2928.00              | 0.00                | 0.00                   | 0.00                        | 2928.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201901 | 2              | 0             | 817.00       | 817.00               | 0.00                | 0.00                   | 0.00                        | 817.00           | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201902 | 2              | 0             | 1712.00      | 1712.00              | 0.00                | 0.00                   | 0.00                        | 1712.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201903 | 2              | 0             | 2730.00      | 2730.00              | 0.00                | 0.00                   | 0.00                        | 2730.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201904 | 2              | 0             | 1410.00      | 1410.00              | 0.00                | 0.00                   | 0.00                        | 1410.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201905 | 2              | 0             | 2651.00      | 2651.00              | 0.00                | 0.00                   | 0.00                        | 2651.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201906 | 2              | 0             | 1648.00      | 1648.00              | 0.00                | 0.00                   | 0.00                        | 1648.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201907 | 2              | 0             | 1939.00      | 1939.00              | 0.00                | 0.00                   | 0.00                        | 1939.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | ALLF-856         | 1             | 2               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2252.27     |
    | ALLF-856         | 1             | 5               | 201808 | 2              | 0             | 773.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 661.94      |
    | ALLF-856         | 1             | 7               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1669.89                     | 1669.89          | 0            | 1669.89     |
    | ALLF-856         | 1             | 2               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1385.17     |
    | ALLF-856         | 1             | 5               | 201809 | 2              | 0             | 3629.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 471.99      |
    | ALLF-856         | 1             | 7               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1163.50                     | 1163.50          | 0            | 1163.50     |
    | ALLF-856         | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 882.98      |
    | ALLF-856         | 1             | 5               | 201810 | 2              | 0             | 3446.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2192.55     |
    | ALLF-856         | 1             | 7               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 909.80                      | 909.80           | 0            | 909.80      |
    | ALLF-856         | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1470.21     |
    | ALLF-856         | 1             | 5               | 201811 | 2              | 0             | 3011.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 502.51      |
    | ALLF-856         | 1             | 7               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 2315.03                     | 2315.03          | 0            | 2315.03     |
    | ALLF-856         | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1799.23     |
    | ALLF-856         | 1             | 5               | 201812 | 2              | 0             | 615.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 431.43      |
    | ALLF-856         | 1             | 7               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1730.38                     | 1730.38          | 0            | 1730.38     |
    | ALLF-856         | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2496.87     |
    | ALLF-856         | 1             | 5               | 201901 | 2              | 0             | 402.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2257.41     |
    | ALLF-856         | 1             | 7               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1445.75     |
    | ALLF-856         | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1720.82     |
    | ALLF-856         | 1             | 5               | 201902 | 2              | 0             | 2023.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1225.33     |
    | ALLF-856         | 1             | 7               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 972.58      |
    | ALLF-856         | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201903 | 2              | 0             | 3580.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 2               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201904 | 2              | 0             | 1628.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 2               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201905 | 2              | 0             | 2048.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 2               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201906 | 2              | 0             | 1771.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 2               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201907 | 2              | 0             | 2601.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    #
    | CLP-856          | 1             | 1               | 201808 | 2              | 0             | 1269.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 456.12      |
    | CLP-856          | 1             | 1               | 201809 | 2              | 0             | 2321.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1234.55     |
    | CLP-856          | 1             | 1               | 201810 | 2              | 0             | 147.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 599.52      |
    | CLP-856          | 1             | 1               | 201811 | 2              | 0             | 250.00       | 0.00                 | 0.00                | 0.00                   | 4482.74                     | 4482.74          | 0            | 2192.55     |
    | CLP-856          | 1             | 1               | 201812 | 2              | 0             | 922.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201901 | 2              | 0             | 1624.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201902 | 2              | 0             | 1254.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201903 | 2              | 0             | 3349.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201904 | 2              | 0             | 764.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201905 | 2              | 0             | 2099.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201906 | 2              | 0             | 3531.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201907 | 2              | 0             | 1199.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |




    # Check AllocationDeliveryEntry table

    # Check all activity has finished
    When   there are no messages left in the system

    # Check the ADP feed for a category 4 (ActualsUpdated) event for ALLF
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events 
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | AllocationNumber | ContractVersionNumber |
    | ContractAllocationActualsUpdated  | 4      | LOANS-856      | ALLC-856         | 1                     | 
    | ContractAllocationActualsUpdated  | 4      | LOANS-856      | ALLF-856         | 1                     | 
    | ContractAllocationActualsUpdated  | 4      | LOANS-856      | CLP-856          | 1                     | 

    # Check the ADP feed event header information
    And   the Allocation Delivery feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                     | CategoryLabel                        | Title                                                                               |
    | 10017856 | LOANS-856      | 1               | 0                  | ContractAllocationActualsUpdated | Contract Allocation Actuals Updated  | Actuals for Allocation ALLC-856 of Contract LOANS-856: 1.0 have been updated        |
	| 10017856 | LOANS-856      | 1               | 0                  | ContractAllocationActualsUpdated | Contract Allocation Actuals Updated  | Actuals for Allocation ALLF-856 of Contract LOANS-856: 1.0 have been updated        |
    | 10017856 | LOANS-856      | 1               | 0                  | ContractAllocationActualsUpdated | Contract Allocation Actuals Updated  | Actuals for Allocation CLP-856 of Contract LOANS-856: 1.0 have been updated         |
	
    # Check AllocationDelivery.AllocationDeliveryEntry (ADP) feed for ContractAllocationActualsUpdated information (type4 event)
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
    | AllocationDeliveryEntryCategory   | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201808 | ?           | 2898.00        | 0.00             | 0.00                  | 0.00           | 2898.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201808 | 1119.61     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201808 | 935.11      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201808 | 2424.81     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201809 | ?           | 2873.00        | 0.00             | 0.00                  | 0.00           | 2873.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201809 | 997.17      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201809 | 205.71      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201809 | 853.17      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201810 | ?           | 1964.00        | 0.00             | 0.00                  | 0.00           | 1964.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201810 | 2141.51     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201810 | 1634.37     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201810 | 1932.21     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201811 | ?           | 990.00         | 0.00             | 0.00                  | 0.00           | 990.00     |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201811 | 2252.27     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201811 | 661.94      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201811 | 1669.89     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201812 | ?           | 2928.00        | 0.00             | 0.00                  | 0.00           | 2928.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201901 | ?           | 817.00         | 0.00             | 0.00                  | 0.00           | 817.00     |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201902 | ?           | 1712.00        | 0.00             | 0.00                  | 0.00           | 1712.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201903 | ?           | 2730.00        | 0.00             | 0.00                  | 0.00           | 2730.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201904 | ?           | 1410.00        | 0.00             | 0.00                  | 0.00           | 1410.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201905 | ?           | 2651.00        | 0.00             | 0.00                  | 0.00           | 2651.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201906 | ?           | 1648.00        | 0.00             | 0.00                  | 0.00           | 1648.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201907 | ?           | 1939.00        | 0.00             | 0.00                  | 0.00           | 1939.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201808 | 2252.27     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201808 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201808 | 661.94      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201808 | 1669.89     | 0.00           | 0.00             | 1669.89               | 0.00           | 1669.89    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201809 | 1385.17     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201809 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201809 | 471.99      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201809 | 1163.50     | 0.00           | 0.00             | 1163.50               | 0.00           | 1163.50    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201810 | 882.98      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201810 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201810 | 2192.55     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201810 | 909.80      | 0.00           | 0.00             | 909.80                | 0.00           | 909.80     |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201811 | 1470.21     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201811 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201811 | 502.51      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201811 | 2315.03     | 0.00           | 0.00             | 2315.03               | 0.00           | 2315.03    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201812 | 1799.23     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201812 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201812 | 431.43      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201812 | 1730.38     | 0.00           | 0.00             | 1730.38               | 0.00           | 1730.38    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201901 | 2496.87     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201901 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201901 | 2257.41     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201901 | 1445.75     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201902 | 1720.82     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201902 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201902 | 1225.33     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201902 | 972.58      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201808 | 456.12      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201809 | 1234.55     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201810 | 599.52      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201811 | 2192.55     | 0.00           | 0.00             | 4482.74               | 0.00           | 4482.74    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |   
   

    # Initiate UPDATE TERMINATION DETAILS  (23812)
    #   Contract  : Set date into future. Reason and comments unchanged
    #   Allocation: Add a month to each date

    # Change the date
    Given the override date is '21/12/2018' 

    # Clear down the ADP and CM feeds prior to updating the termination details
    And   the Allocation Delivery Monitoring Service atom feed is empty
    And   the Contract Management atom feed is empty

    # Issue an 'Update termination details' request (23812)
    When  CRM user 'FCS8 Test' updates contract termination details for Contract 'LOANS-856' Version '1' SubVersion '0' with the following options
    | ContractTerminationDate | TerminationReason       | TerminationComments     |
    | 26/04/2019              | Other                   | ?                       |

    And   with the following updated allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ALLC-856         | 12/02/2019                  | 13/02/2019                |
    | ALLF-856         | 16/03/2019                  | 19/03/2019                |
    | CLP-856          | 24/04/2019                  | 26/04/2019                |

    # Use either the CRM UI (slow) or the SDK (fast) to amend the termination details
#   And   the user completes the termination amendment request via UI
    And   the user completes the termination amendment request via SDK

    # Check CONTRACT termination values in CRM
    Then  the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | LOANS-856      | 1                     | 0                        | 26/04/2019              | ?                       |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | ALLC-856         | 1                     | 0                        | 12/02/2019        | 13/02/2019                |
    | ALLF-856         | 1                     | 0                        | 16/03/2019        | 19/03/2019                |
    | CLP-856          | 1                     | 0                        | 24/04/2019        | 26/04/2019                |

    # Check the CM feed for the presence of an ItemType 7 (Contract Termination Details Updated) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '7' event for version '1' of actual contract number 'LOANS-856'
    And   the ItemType '7' event for version '1' of actual contract number 'LOANS-856' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017856 | LOANS-856      | 1               | 0                  | 26/04/2019              | Other                     | ALLC-856        | 12/02/2019            | 13/02/2019                |
    | 10017856 | LOANS-856      | 1               | 0                  | 26/04/2019              | Other                     | ALLF-856        | 16/03/2019            | 19/03/2019                |
    | 10017856 | LOANS-856      | 1               | 0                  | 26/04/2019              | Other                     | CLP-856         | 24/04/2019            | 26/04/2019                |




    # As if by magic, the ALLF actuals deleted earlier will reappear for Mar19 and details will be written to CRM, PaaS and the ADP feed

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-856      | ALLC-856        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLC-856        | 2               | 6510.56  | 1119.61  | 997.17   | 2141.51  | 2252.27  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLC-856        | 3               | 3437.13  | 935.11   | 205.71   | 1634.37  | 661.94   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLC-856        | 4               | 6880.08  | 2424.81  | 853.17   | 1932.21  | 1669.89  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | LOANS-856      | ALLF-856        | 2               | 14006.02 | 2252.27  | 1385.17  | 882.98   | 1470.21  | 1799.23  | 2496.87  | 1720.82  | 1998.47  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLF-856        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLF-856        | 6               | 8711.10  | 661.94   | 471.99   | 2192.55  | 502.51   | 431.43   | 2257.41  | 1225.33  | 967.94   | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLF-856        | 7               | 11575.09 | 1669.89  | 1163.50  | 909.80   | 2315.03  | 1730.38  | 1445.75  | 972.58   | 1368.16  | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | LOANS-856      | CLP-856         | 1               | 4482.74  | 456.12   | 1234.55  | 599.52   | 2192.55  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-856      | ALLC-856        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | LOANS-856      | ALLF-856        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 7               | 7788.60  | 1669.89  | 1163.50  | 909.80   | 2315.03  | 1730.38  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | LOANS-856      | CLP-856         | 1               | 4482.74  | 0.00     | 0.00     | 0.00     | 4482.74  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-856      | ALLC-856        | 1               | 24560.00 | 2898.00  | 2873.00  | 1964.00  | 990.00   | 2928.00  | 817.00   | 1712.00  | 2730.00  | 1410.00  | 2651.00  | 1648.00  | 1939.00  | 
    | LOANS-856      | ALLC-856        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | LOANS-856      | ALLF-856        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 7               | 7788.60  | 1669.89  | 1163.50  | 909.80   | 2315.03  | 1730.38  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | LOANS-856      | CLP-856         | 1               | 4482.74  | 0.00     | 0.00     | 0.00     | 4482.74  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | ALLC-856         | 1             | 1               | 201808 | 2              | 0             | 2898.00      | 2898.00              | 0.00                | 0.00                   | 0.00                        | 2898.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1119.61     |
    | ALLC-856         | 1             | 3               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 935.11      |
    | ALLC-856         | 1             | 4               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2424.81     |
    | ALLC-856         | 1             | 1               | 201809 | 2              | 0             | 2873.00      | 2873.00              | 0.00                | 0.00                   | 0.00                        | 2873.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 997.17      |
    | ALLC-856         | 1             | 3               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 205.71      |
    | ALLC-856         | 1             | 4               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 853.17      |
    | ALLC-856         | 1             | 1               | 201810 | 2              | 0             | 1964.00      | 1964.00              | 0.00                | 0.00                   | 0.00                        | 1964.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2141.51     |
    | ALLC-856         | 1             | 3               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1634.37     |
    | ALLC-856         | 1             | 4               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1932.21     |
    | ALLC-856         | 1             | 1               | 201811 | 2              | 0             | 990.00       | 990.00               | 0.00                | 0.00                   | 0.00                        | 990.00           | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2252.27     |
    | ALLC-856         | 1             | 3               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 661.94      |
    | ALLC-856         | 1             | 4               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1669.89     |
    | ALLC-856         | 1             | 1               | 201812 | 2              | 0             | 2928.00      | 2928.00              | 0.00                | 0.00                   | 0.00                        | 2928.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201901 | 2              | 0             | 817.00       | 817.00               | 0.00                | 0.00                   | 0.00                        | 817.00           | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201902 | 2              | 0             | 1712.00      | 1712.00              | 0.00                | 0.00                   | 0.00                        | 1712.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201903 | 2              | 0             | 2730.00      | 2730.00              | 0.00                | 0.00                   | 0.00                        | 2730.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201904 | 2              | 0             | 1410.00      | 1410.00              | 0.00                | 0.00                   | 0.00                        | 1410.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201905 | 2              | 0             | 2651.00      | 2651.00              | 0.00                | 0.00                   | 0.00                        | 2651.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201906 | 2              | 0             | 1648.00      | 1648.00              | 0.00                | 0.00                   | 0.00                        | 1648.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201907 | 2              | 0             | 1939.00      | 1939.00              | 0.00                | 0.00                   | 0.00                        | 1939.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | ALLF-856         | 1             | 2               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2252.27     |
    | ALLF-856         | 1             | 5               | 201808 | 2              | 0             | 773.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 661.94      |
    | ALLF-856         | 1             | 7               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1669.89                     | 1669.89          | 0            | 1669.89     |
    | ALLF-856         | 1             | 2               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1385.17     |
    | ALLF-856         | 1             | 5               | 201809 | 2              | 0             | 3629.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 471.99      |
    | ALLF-856         | 1             | 7               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1163.50                     | 1163.50          | 0            | 1163.50     |
    | ALLF-856         | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 882.98      |
    | ALLF-856         | 1             | 5               | 201810 | 2              | 0             | 3446.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2192.55     |
    | ALLF-856         | 1             | 7               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 909.80                      | 909.80           | 0            | 909.80      |
    | ALLF-856         | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1470.21     |
    | ALLF-856         | 1             | 5               | 201811 | 2              | 0             | 3011.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 502.51      |
    | ALLF-856         | 1             | 7               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 2315.03                     | 2315.03          | 0            | 2315.03     |
    | ALLF-856         | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1799.23     |
    | ALLF-856         | 1             | 5               | 201812 | 2              | 0             | 615.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 431.43      |
    | ALLF-856         | 1             | 7               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1730.38                     | 1730.38          | 0            | 1730.38     |
    | ALLF-856         | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2496.87     |
    | ALLF-856         | 1             | 5               | 201901 | 2              | 0             | 402.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2257.41     |
    | ALLF-856         | 1             | 7               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1445.75     |
    | ALLF-856         | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1720.82     |
    | ALLF-856         | 1             | 5               | 201902 | 2              | 0             | 2023.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1225.33     |
    | ALLF-856         | 1             | 7               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 972.58      |
    | ALLF-856         | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1998.47     |
    | ALLF-856         | 1             | 5               | 201903 | 2              | 0             | 3580.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 967.94      |
    | ALLF-856         | 1             | 7               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1368.16     |
    | ALLF-856         | 1             | 2               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201904 | 2              | 0             | 1628.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 2               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201905 | 2              | 0             | 2048.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 2               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201906 | 2              | 0             | 1771.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 2               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201907 | 2              | 0             | 2601.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    #
    | CLP-856          | 1             | 1               | 201808 | 2              | 0             | 1269.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 456.12      |
    | CLP-856          | 1             | 1               | 201809 | 2              | 0             | 2321.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1234.55     |
    | CLP-856          | 1             | 1               | 201810 | 2              | 0             | 147.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 599.52      |
    | CLP-856          | 1             | 1               | 201811 | 2              | 0             | 250.00       | 0.00                 | 0.00                | 0.00                   | 4482.74                     | 4482.74          | 0            | 2192.55     |
    | CLP-856          | 1             | 1               | 201812 | 2              | 0             | 922.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201901 | 2              | 0             | 1624.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201902 | 2              | 0             | 1254.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201903 | 2              | 0             | 3349.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201904 | 2              | 0             | 764.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201905 | 2              | 0             | 2099.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201906 | 2              | 0             | 3531.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201907 | 2              | 0             | 1199.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |


    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check the ADP feed for category 4 (ActualsUpdated) events
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | AllocationNumber | ContractVersionNumber |
    | ContractAllocationActualsUpdated  | 4      | LOANS-856      | ALLC-856         | 1                     |
	| ContractAllocationActualsUpdated  | 4      | LOANS-856      | ALLF-856         | 1                     |
	| ContractAllocationActualsUpdated  | 4      | LOANS-856      | CLP-856          | 1                     |

    # Check the ADP feed event header information
    And   the Allocation Delivery feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                     | CategoryLabel                        | Title                                                                               |
    | 10017856 | LOANS-856      | 1               | 0                  | ContractAllocationActualsUpdated | Contract Allocation Actuals Updated  | Actuals for Allocation ALLC-856 of Contract LOANS-856: 1.0 have been updated        |
    | 10017856 | LOANS-856      | 1               | 0                  | ContractAllocationActualsUpdated | Contract Allocation Actuals Updated  | Actuals for Allocation ALLF-856 of Contract LOANS-856: 1.0 have been updated        |
    | 10017856 | LOANS-856      | 1               | 0                  | ContractAllocationActualsUpdated | Contract Allocation Actuals Updated  | Actuals for Allocation CLP-856 of Contract LOANS-856: 1.0 have been updated         |

    # Check AllocationDelivery.AllocationDeliveryEntry (ADP) feed for ContractAllocationActualsUpdated information (type4 event)
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
    | AllocationDeliveryEntryCategory   | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201808 | ?           | 2898.00        | 0.00             | 0.00                  | 0.00           | 2898.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201808 | 1119.61     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201808 | 935.11      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201808 | 2424.81     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201809 | ?           | 2873.00        | 0.00             | 0.00                  | 0.00           | 2873.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201809 | 997.17      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201809 | 205.71      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201809 | 853.17      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201810 | ?           | 1964.00        | 0.00             | 0.00                  | 0.00           | 1964.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201810 | 2141.51     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201810 | 1634.37     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201810 | 1932.21     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201811 | ?           | 990.00         | 0.00             | 0.00                  | 0.00           | 990.00     |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201811 | 2252.27     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201811 | 661.94      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201811 | 1669.89     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201812 | ?           | 2928.00        | 0.00             | 0.00                  | 0.00           | 2928.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201901 | ?           | 817.00         | 0.00             | 0.00                  | 0.00           | 817.00     |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201902 | ?           | 1712.00        | 0.00             | 0.00                  | 0.00           | 1712.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201903 | ?           | 2730.00        | 0.00             | 0.00                  | 0.00           | 2730.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201904 | ?           | 1410.00        | 0.00             | 0.00                  | 0.00           | 1410.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201905 | ?           | 2651.00        | 0.00             | 0.00                  | 0.00           | 2651.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201906 | ?           | 1648.00        | 0.00             | 0.00                  | 0.00           | 1648.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201907 | ?           | 1939.00        | 0.00             | 0.00                  | 0.00           | 1939.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201808 | 2252.27     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201808 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201808 | 661.94      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201808 | 1669.89     | 0.00           | 0.00             | 1669.89               | 0.00           | 1669.89    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201809 | 1385.17     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201809 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201809 | 471.99      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201809 | 1163.50     | 0.00           | 0.00             | 1163.50               | 0.00           | 1163.50    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201810 | 882.98      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201810 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201810 | 2192.55     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201810 | 909.80      | 0.00           | 0.00             | 909.80                | 0.00           | 909.80     |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201811 | 1470.21     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201811 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201811 | 502.51      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201811 | 2315.03     | 0.00           | 0.00             | 2315.03               | 0.00           | 2315.03    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201812 | 1799.23     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201812 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201812 | 431.43      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201812 | 1730.38     | 0.00           | 0.00             | 1730.38               | 0.00           | 1730.38    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201901 | 2496.87     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201901 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201901 | 2257.41     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201901 | 1445.75     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201902 | 1720.82     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201902 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201902 | 1225.33     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201902 | 972.58      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201903 | 1998.47     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201903 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201903 | 967.94      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201903 | 1368.16     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
	| ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201808 | 456.12      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201809 | 1234.55     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201810 | 599.52      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201811 | 2192.55     | 0.00           | 0.00             | 4482.74               | 0.00           | 4482.74    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |




    # Initiate UPDATE TERMINATION DETAILS a second time
    #   Contract  : Set date to Sep18 to force actuals truncation. Change reason and comments
    #   Allocation: Set all dates to Sep18

    # Change the date
    Given the override date is '08/01/2019'

    # Clear down the ADP and CM feeds prior to updating the termination details
    And   the Allocation Delivery Monitoring Service atom feed is empty
    And   the Contract Management atom feed is empty

    # Issue an 'Update termination details' request (23812)
    When  CRM user 'FCS8 Test' updates contract termination details for Contract 'LOANS-856' Version '1' SubVersion '0' with the following options
    | ContractTerminationDate | TerminationReason       | TerminationComments     |
    | 09/09/2018              | Notice from Provider    | Suspected fraud         |

    And   with the following updated allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ALLC-856         | 09/09/2018                  | 09/09/2018                |
    | ALLF-856         | 09/09/2018                  | 09/09/2018                |
    | CLP-856          | 09/09/2018                  | 09/09/2018                |

    # Use either the CRM UI (slow) or the SDK (fast) to amend the termination details
#   And   the user completes the termination amendment request via UI
    And   the user completes the termination amendment request via SDK

    # Check CONTRACT termination values in CRM
    Then  the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | LOANS-856      | 1                     | 0                        | 09/09/2018              | ?                       |
#   | LOANS-856      | 1                     | 0                        | 09/09/2018              | Suspected fraud         |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | ALLC-856         | 1                     | 0                        | 09/09/2018        | 09/09/2018                |
    | ALLF-856         | 1                     | 0                        | 09/09/2018        | 09/09/2018                |
    | CLP-856          | 1                     | 0                        | 09/09/2018        | 09/09/2018                |

    # Check the CM feed for the presence of an ItemType 7 (Contract Termination Details Updated) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '7' event for version '1' of actual contract number 'LOANS-856'
    And   the ItemType '7' event for version '1' of actual contract number 'LOANS-856' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017856 | LOANS-856      | 1               | 0                  | 09/09/2018              | Notice from Provider      | ALLC-856        | 09/09/2018            | 09/09/2018                |
    | 10017856 | LOANS-856      | 1               | 0                  | 09/09/2018              | Notice from Provider      | ALLF-856        | 09/09/2018            | 09/09/2018                |
    | 10017856 | LOANS-856      | 1               | 0                  | 09/09/2018              | Notice from Provider      | CLP-856         | 09/09/2018            | 09/09/2018                |




    # Actuals for Oct18 and beyond should be truncated
	
    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-856      | ALLC-856        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLC-856        | 2               | 2116.78  | 1119.61  | 997.17   | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLC-856        | 3               | 1140.82  | 935.11   | 205.71   | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLC-856        | 4               | 3277.98  | 2424.81  | 853.17   | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | LOANS-856      | ALLF-856        | 2               | 3637.44  | 2252.27  | 1385.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLF-856        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLF-856        | 6               | 1133.93  | 661.94   | 471.99   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLF-856        | 7               | 2833.39  | 1669.89  | 1163.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | LOANS-856      | CLP-856         | 1               | 1690.67  | 456.12   | 1234.55  | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-856      | ALLC-856        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | LOANS-856      | ALLF-856        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 7               | 2833.39  | 1669.89  | 1163.50  | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | LOANS-856      | CLP-856         | 1               | 1690.67  | 0.00     | 0.00     | 0.00     | 4482.74  | -2792.07 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-856      | ALLC-856        | 1               | 24560.00 | 2898.00  | 2873.00  | 1964.00  | 990.00   | 2928.00  | 817.00   | 1712.00  | 2730.00  | 1410.00  | 2651.00  | 1648.00  | 1939.00  | 
    | LOANS-856      | ALLC-856        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-856      | ALLC-856        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | LOANS-856      | ALLF-856        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-856      | ALLF-856        | 7               | 2833.39  | 1669.89  | 1163.50  | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | LOANS-856      | CLP-856         | 1               | 1690.67  | 0.00     | 0.00     | 0.00     | 4482.74  | -2792.07 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 


    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | ALLC-856         | 1             | 1               | 201808 | 2              | 0             | 2898.00      | 2898.00              | 0.00                | 0.00                   | 0.00                        | 2898.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1119.61     |
    | ALLC-856         | 1             | 3               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 935.11      |
    | ALLC-856         | 1             | 4               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2424.81     |
    | ALLC-856         | 1             | 1               | 201809 | 2              | 0             | 2873.00      | 2873.00              | 0.00                | 0.00                   | 0.00                        | 2873.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 997.17      |
    | ALLC-856         | 1             | 3               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 205.71      |
    | ALLC-856         | 1             | 4               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 853.17      |
    | ALLC-856         | 1             | 1               | 201810 | 2              | 0             | 1964.00      | 1964.00              | 0.00                | 0.00                   | 0.00                        | 1964.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLC-856         | 1             | 3               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLC-856         | 1             | 4               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLC-856         | 1             | 1               | 201811 | 2              | 0             | 990.00       | 990.00               | 0.00                | 0.00                   | 0.00                        | 990.00           | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLC-856         | 1             | 3               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLC-856         | 1             | 4               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLC-856         | 1             | 1               | 201812 | 2              | 0             | 2928.00      | 2928.00              | 0.00                | 0.00                   | 0.00                        | 2928.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201901 | 2              | 0             | 817.00       | 817.00               | 0.00                | 0.00                   | 0.00                        | 817.00           | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201902 | 2              | 0             | 1712.00      | 1712.00              | 0.00                | 0.00                   | 0.00                        | 1712.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201903 | 2              | 0             | 2730.00      | 2730.00              | 0.00                | 0.00                   | 0.00                        | 2730.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201904 | 2              | 0             | 1410.00      | 1410.00              | 0.00                | 0.00                   | 0.00                        | 1410.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201905 | 2              | 0             | 2651.00      | 2651.00              | 0.00                | 0.00                   | 0.00                        | 2651.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201906 | 2              | 0             | 1648.00      | 1648.00              | 0.00                | 0.00                   | 0.00                        | 1648.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 1               | 201907 | 2              | 0             | 1939.00      | 1939.00              | 0.00                | 0.00                   | 0.00                        | 1939.00          | ?            | ?           |
    | ALLC-856         | 1             | 2               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 3               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-856         | 1             | 4               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | ALLF-856         | 1             | 2               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2252.27     |
    | ALLF-856         | 1             | 5               | 201808 | 2              | 0             | 773.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 661.94      |
    | ALLF-856         | 1             | 7               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1669.89                     | 1669.89          | 0            | 1669.89     |
    | ALLF-856         | 1             | 2               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1385.17     |
    | ALLF-856         | 1             | 5               | 201809 | 2              | 0             | 3629.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 471.99      |
    | ALLF-856         | 1             | 7               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1163.50                     | 1163.50          | 0            | 1163.50     |
    | ALLF-856         | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201810 | 2              | 0             | 3446.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201811 | 2              | 0             | 3011.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201812 | 2              | 0             | 615.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201901 | 2              | 0             | 402.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201902 | 2              | 0             | 2023.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201903 | 2              | 0             | 3580.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 2               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201904 | 2              | 0             | 1628.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 2               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201905 | 2              | 0             | 2048.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 2               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201906 | 2              | 0             | 1771.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 2               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 5               | 201907 | 2              | 0             | 2601.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 6               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-856         | 1             | 7               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    #
    | CLP-856          | 1             | 1               | 201808 | 2              | 0             | 1269.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 456.12      |
    | CLP-856          | 1             | 1               | 201809 | 2              | 0             | 2321.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1234.55     |
    | CLP-856          | 1             | 1               | 201810 | 2              | 0             | 147.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | CLP-856          | 1             | 1               | 201811 | 2              | 0             | 250.00       | 0.00                 | 0.00                | 0.00                   | 4482.74                     | 4482.74          | 0            | 0.00        |
    | CLP-856          | 1             | 1               | 201812 | 2              | 0             | 922.00       | 0.00                 | 0.00                | 0.00                   | -2792.07                    | -2792.07         | ?            | ?           |
    | CLP-856          | 1             | 1               | 201901 | 2              | 0             | 1624.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201902 | 2              | 0             | 1254.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201903 | 2              | 0             | 3349.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201904 | 2              | 0             | 764.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201905 | 2              | 0             | 2099.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201906 | 2              | 0             | 3531.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | CLP-856          | 1             | 1               | 201907 | 2              | 0             | 1199.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |


    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check the ADP feed for category 4 (ActualsUpdated) events
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | AllocationNumber | ContractVersionNumber |
    | ContractAllocationActualsUpdated  | 4      | LOANS-856      | ALLF-856         | 1                     |

    # Check the ADP feed event header information
    And   the Allocation Delivery feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                     | CategoryLabel                        | Title                                                                               |
    | 10017856 | LOANS-856      | 1               | 0                  | ContractAllocationActualsUpdated | Contract Allocation Actuals Updated  | Actuals for Allocation ALLC-856 of Contract LOANS-856: 1.0 have been updated        |
    | 10017856 | LOANS-856      | 1               | 0                  | ContractAllocationActualsUpdated | Contract Allocation Actuals Updated  | Actuals for Allocation ALLF-856 of Contract LOANS-856: 1.0 have been updated        |
    | 10017856 | LOANS-856      | 1               | 0                  | ContractAllocationActualsUpdated | Contract Allocation Actuals Updated  | Actuals for Allocation CLP-856 of Contract LOANS-856: 1.0 have been updated         |

    # Check AllocationDelivery.AllocationDeliveryEntry (ADP) feed for ContractAllocationActualsUpdated information (type4 event)
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
    | AllocationDeliveryEntryCategory   | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201808 | ?           | 2898.00        | 0.00             | 0.00                  | 0.00           | 2898.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201808 | 1119.61     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201808 | 935.11      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201808 | 2424.81     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201809 | ?           | 2873.00        | 0.00             | 0.00                  | 0.00           | 2873.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201809 | 997.17      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201809 | 205.71      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201809 | 853.17      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201810 | ?           | 1964.00        | 0.00             | 0.00                  | 0.00           | 1964.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201810 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201810 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201810 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201811 | ?           | 990.00         | 0.00             | 0.00                  | 0.00           | 990.00     |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201811 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201811 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201811 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201812 | ?           | 2928.00        | 0.00             | 0.00                  | 0.00           | 2928.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201901 | ?           | 817.00         | 0.00             | 0.00                  | 0.00           | 817.00     |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201902 | ?           | 1712.00        | 0.00             | 0.00                  | 0.00           | 1712.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201903 | ?           | 2730.00        | 0.00             | 0.00                  | 0.00           | 2730.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201904 | ?           | 1410.00        | 0.00             | 0.00                  | 0.00           | 1410.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201905 | ?           | 2651.00        | 0.00             | 0.00                  | 0.00           | 2651.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201906 | ?           | 1648.00        | 0.00             | 0.00                  | 0.00           | 1648.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 1               | 201907 | ?           | 1939.00        | 0.00             | 0.00                  | 0.00           | 1939.00    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 2               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 3               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLC-856         | 4               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201808 | 2252.27     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201808 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201808 | 661.94      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201808 | 1669.89     | 0.00           | 0.00             | 1669.89               | 0.00           | 1669.89    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201809 | 1385.17     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201809 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201809 | 471.99      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201809 | 1163.50     | 0.00           | 0.00             | 1163.50               | 0.00           | 1163.50    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201810 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201810 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201810 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201810 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201811 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201811 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201811 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201811 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 2               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 5               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 6               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | ALLF-856         | 7               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201808 | 456.12      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201809 | 1234.55     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201810 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201811 | ?           | 0.00           | 0.00             | 4482.74               | 0.00           | 4482.74    |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201812 | ?           | 0.00           | 0.00             | -2792.07              | 0.00           | -2792.07   |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201904 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201905 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201906 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | LOANS-856      | 1             | CLP-856          | 1               | 201907 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |

    # Check the Workflow History comments 
    And   the workflow history on contract 'LOANS-856' version '1' includes the following
    | Action                      | CompletedBy    | Comment           |
    | Update Termination Details  | FCS8 TEST      | Suspected fraud   |


    # Tidy up
    And   the override date is reset 
   
