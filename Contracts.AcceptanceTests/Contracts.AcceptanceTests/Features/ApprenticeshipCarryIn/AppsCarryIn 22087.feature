Feature: AppsCarryIn 22087

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run67
Scenario: A760 Create and approve a Mainstream contract with just an APPS1819 (Carry-in) allocation. Consume actuals from APPS only. Park Carry-In actuals. Check CRM, PaaS and HeldReportedActualGroup
    Given there is no Contract, Task or Workflow data for UKPRN '10017760' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Clear down the DEDS
    And   there are no entries in the DCFS stub table 

    # Clear down the MonitoringDeliverables.HeldReportedActualGroup data for specified Collection Returns
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017760'

    # Clear down subnominal data
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | APPS-760      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017760' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017760 Co Ltd' with UKPRN '10017760' and OrgId 'ORG0017760' and has 'FCS1 Test' as a manager 
    And   UPIN '117760' is associated with UKPRN '10017760' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017760 | 117760 | 10017760 Co Ltd | 0              | Active | Yes           | AA017760      | ?             | 

    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017760 | 10017760 Co Ltd      | ESFA-760             | MAIN-760       | 1                     | 01/08/2018        | 31/07/2019      | 55130.00      |                                | Contract for Services | 1819   | New          | ORG0017760 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017760 | MAIN-760       | APPS-760      | APPS              | APPS1819                | AY                      | 01/08/2018          | 31/07/2019        | 55130.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017760 | MAIN-760       | APPS-760      | 1               | 0                     | 55130.00  | 3588.00  | 2906.00  | 3287.00  | 7827.00  | 3524.00  | 7115.00  | 4958.00  | 7113.00  | 2930.00  | 2495.00  | 4800.00  | 4587.00  | Apprenticeships Carry-In Total Funding                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-760' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '06/07/2018'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-760' and actual ContractNumber 'MAIN-760'


    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-760' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017760 | MAIN-760           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017760 | ESFA-760           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract 'MAIN-760'

    # Change the date
    Given the override date is '06/12/2018'

    # Define DC actuals for Nov 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS19               | ORG0017760     | CM             | 201808 | APPS1819                | APPS-760                 |         | 8               | 0            | 1087.77     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201808 | APPS1819                | APPS-760                 |         | 9               | 0            | 846.79      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201808 | APPS1819                | APPS-760                 |         | 10              | 0            | 911.33      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201808 | APPS1819                | APPS-760                 |         | 22              | 0            | 505.39      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201808 | APPS1819                | APPS-760                 |         | 23              | 0            | 522.73      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201808 | APPS1819                | APPS-760                 |         | 24              | 0            | 1184.64     |
    #
    | APPS           | APPS19               | ORG0017760     | CM             | 201809 | APPS1819                | APPS-760                 |         | 8               | 0            | 119.62      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201809 | APPS1819                | APPS-760                 |         | 9               | 0            | 1165.02     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201809 | APPS1819                | APPS-760                 |         | 10              | 0            | 1240.29     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201809 | APPS1819                | APPS-760                 |         | 22              | 0            | 1092.66     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201809 | APPS1819                | APPS-760                 |         | 23              | 0            | 163.49      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201809 | APPS1819                | APPS-760                 |         | 24              | 0            | 679.64      |
    #
    | APPS           | APPS19               | ORG0017760     | CM             | 201810 | APPS1819                | APPS-760                 |         | 8               | 0            | 1307.67     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201810 | APPS1819                | APPS-760                 |         | 9               | 0            | 1206.67     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201810 | APPS1819                | APPS-760                 |         | 10              | 0            | 622.95      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201810 | APPS1819                | APPS-760                 |         | 22              | 0            | 1446.74     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201810 | APPS1819                | APPS-760                 |         | 23              | 0            | 1320.03     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201810 | APPS1819                | APPS-760                 |         | 24              | 0            | 178.73      |
    #
    | APPS           | APPS19               | ORG0017760     | CM             | 201811 | APPS1819                | APPS-760                 |         | 8               | 0            | 1429.38     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201811 | APPS1819                | APPS-760                 |         | 9               | 0            | 609.62      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201811 | APPS1819                | APPS-760                 |         | 10              | 0            | 834.82      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201811 | APPS1819                | APPS-760                 |         | 22              | 0            | 1173.96     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201811 | APPS1819                | APPS-760                 |         | 23              | 0            | 174.90      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201811 | APPS1819                | APPS-760                 |         | 24              | 0            | 929.44      |
    #
    | APPS           | APPS19               | ORG0017760     | CM             | 201812 | APPS1819                | APPS-760                 |         | 8               | 0            | 756.18      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201812 | APPS1819                | APPS-760                 |         | 9               | 0            | 517.43      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201812 | APPS1819                | APPS-760                 |         | 10              | 0            | 971.78      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201812 | APPS1819                | APPS-760                 |         | 22              | 0            | 1006.95     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201812 | APPS1819                | APPS-760                 |         | 23              | 0            | 469.31      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201812 | APPS1819                | APPS-760                 |         | 24              | 0            | 491.08      |
    #
    | APPS           | APPS19               | ORG0017760     | CM             | 201901 | APPS1819                | APPS-760                 |         | 8               | 0            | 1261.73     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201901 | APPS1819                | APPS-760                 |         | 9               | 0            | 1254.45     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201901 | APPS1819                | APPS-760                 |         | 10              | 0            | 924.83      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201901 | APPS1819                | APPS-760                 |         | 22              | 0            | 1480.54     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201901 | APPS1819                | APPS-760                 |         | 23              | 0            | 1375.35     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201901 | APPS1819                | APPS-760                 |         | 24              | 0            | 417.61      |
    #
    | APPS           | APPS19               | ORG0017760     | CM             | 201902 | APPS1819                | APPS-760                 |         | 8               | 0            | 1073.16     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201902 | APPS1819                | APPS-760                 |         | 9               | 0            | 1472.01     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201902 | APPS1819                | APPS-760                 |         | 10              | 0            | 441.50      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201902 | APPS1819                | APPS-760                 |         | 22              | 0            | 847.42      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201902 | APPS1819                | APPS-760                 |         | 23              | 0            | 248.91      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201902 | APPS1819                | APPS-760                 |         | 24              | 0            | 1499.19     |
    #
    | APPS           | APPS19               | ORG0017760     | CM             | 201903 | APPS1819                | APPS-760                 |         | 8               | 0            | 1046.65     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201903 | APPS1819                | APPS-760                 |         | 9               | 0            | 121.98      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201903 | APPS1819                | APPS-760                 |         | 10              | 0            | 905.26      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201903 | APPS1819                | APPS-760                 |         | 22              | 0            | 240.07      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201903 | APPS1819                | APPS-760                 |         | 23              | 0            | 244.23      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201903 | APPS1819                | APPS-760                 |         | 24              | 0            | 1218.44     |
    #
    | APPS           | APPS19               | ORG0017760     | CM             | 201904 | APPS1819                | APPS-760                 |         | 8               | 0            | 498.27      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201904 | APPS1819                | APPS-760                 |         | 9               | 0            | 163.90      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201904 | APPS1819                | APPS-760                 |         | 10              | 0            | 514.08      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201904 | APPS1819                | APPS-760                 |         | 22              | 0            | 634.81      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201904 | APPS1819                | APPS-760                 |         | 23              | 0            | 521.36      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201904 | APPS1819                | APPS-760                 |         | 24              | 0            | 1428.00     |
    #
    | APPS           | APPS19               | ORG0017760     | CM             | 201905 | APPS1819                | APPS-760                 |         | 8               | 0            | 1471.77     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201905 | APPS1819                | APPS-760                 |         | 9               | 0            | 661.92      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201905 | APPS1819                | APPS-760                 |         | 10              | 0            | 489.59      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201905 | APPS1819                | APPS-760                 |         | 22              | 0            | 324.61      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201905 | APPS1819                | APPS-760                 |         | 23              | 0            | 327.95      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201905 | APPS1819                | APPS-760                 |         | 24              | 0            | 1005.22     |
    #
    | APPS           | APPS19               | ORG0017760     | CM             | 201906 | APPS1819                | APPS-760                 |         | 8               | 0            | 674.10      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201906 | APPS1819                | APPS-760                 |         | 9               | 0            | 677.87      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201906 | APPS1819                | APPS-760                 |         | 10              | 0            | 1097.82     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201906 | APPS1819                | APPS-760                 |         | 22              | 0            | 556.69      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201906 | APPS1819                | APPS-760                 |         | 23              | 0            | 986.45      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201906 | APPS1819                | APPS-760                 |         | 24              | 0            | 390.58      |
    #
    | APPS           | APPS19               | ORG0017760     | CM             | 201907 | APPS1819                | APPS-760                 |         | 8               | 0            | 360.42      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201907 | APPS1819                | APPS-760                 |         | 9               | 0            | 916.70      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201907 | APPS1819                | APPS-760                 |         | 10              | 0            | 213.00      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201907 | APPS1819                | APPS-760                 |         | 22              | 0            | 741.16      |
    | APPS           | APPS19               | ORG0017760     | CM             | 201907 | APPS1819                | APPS-760                 |         | 23              | 0            | 1368.03     |
    | APPS           | APPS19               | ORG0017760     | CM             | 201907 | APPS1819                | APPS-760                 |         | 24              | 0            | 465.91      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the PLANNED VALUES in CRM
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-760       | APPS-760        | 1               | 55130.00 | 3588.00  | 2906.00  | 3287.00  | 7827.00  | 3524.00  | 7115.00  | 4958.00  | 7113.00  | 2930.00  | 2495.00  | 4800.00  | 4587.00  | 

    # Check the ACTUALS in CRM (No data for APPS. This will have been parked)
    And   the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-760       | APPS-760        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 8               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 9               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 10              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 11              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 12              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 13              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 14              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 15              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 16              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 17              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 18              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 19              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 20              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 21              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 22              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 23              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 24              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-760       | APPS-760        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 8               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 9               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 10              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 11              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 12              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 13              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 14              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 15              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 16              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 17              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 18              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 19              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 20              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 21              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 22              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 23              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 24              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-760       | APPS-760        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 8               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 9               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 10              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 11              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 12              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 13              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 14              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 15              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 16              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 17              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 18              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 19              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 20              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 21              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 22              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 23              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 24              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-760       | APPS-760        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 8               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 9               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 10              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 11              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 12              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 13              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 14              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 15              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 16              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 17              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 18              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 19              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 20              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 21              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 22              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 23              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-760       | APPS-760        | 24              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualValue |
    | APPS-760         | 1             | 1               | 201808 | 2              | 0             | 3588.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 1               | 201809 | 2              | 0             | 2906.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 1               | 201810 | 2              | 0             | 3287.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 1               | 201811 | 2              | 0             | 7827.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 1               | 201812 | 2              | 0             | 3524.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 1               | 201901 | 2              | 0             | 7115.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 1               | 201902 | 2              | 0             | 4958.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 1               | 201903 | 2              | 0             | 7113.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 1               | 201904 | 2              | 0             | 2930.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 1               | 201905 | 2              | 0             | 2495.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 1               | 201906 | 2              | 0             | 4800.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 1               | 201907 | 2              | 0             | 4587.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-760         | 1             | 2               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 2               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 2               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 2               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 2               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 2               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-760         | 1             | 3               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 3               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 3               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 3               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 3               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 3               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 3               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 3               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 3               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 3               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 3               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 3               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-760         | 1             | 4               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 4               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 4               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 4               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 4               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 4               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 4               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 4               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 4               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 4               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 4               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 4               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #
    | APPS-760         | 1             | 5               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 5               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 5               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 5               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 5               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 5               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 5               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 5               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 5               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 5               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 5               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 5               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-760         | 1             | 6               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 6               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 6               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 6               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 6               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 6               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 6               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 6               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 6               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 6               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 6               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 6               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									     
    | APPS-760         | 1             | 7               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 7               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 7               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 7               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 7               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 7               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 7               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 7               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 7               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 7               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 7               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 7               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-760         | 1             | 8               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 8               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 8               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 8               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 8               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 8               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 8               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 8               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 8               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 8               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 8               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 8               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #
    | APPS-760         | 1             | 9               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 9               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 9               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 9               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 9               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 9               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 9               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 9               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 9               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 9               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 9               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 9               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									       
    | APPS-760         | 1             | 10              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 10              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 10              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 10              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 10              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 10              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 10              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 10              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 10              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 10              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 10              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 10              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-760         | 1             | 11              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 11              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 11              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 11              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 11              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 11              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 11              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 11              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 11              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 11              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 11              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 11              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-760         | 1             | 12              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 12              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 12              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 12              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 12              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 12              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 12              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 12              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 12              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 12              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 12              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 12              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #
    | APPS-760         | 1             | 13              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 13              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 13              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 13              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 13              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 13              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 13              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 13              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 13              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 13              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 13              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 13              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									       
    | APPS-760         | 1             | 14              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 14              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 14              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 14              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 14              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 14              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 14              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 14              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 14              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 14              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 14              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 14              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									       
    | APPS-760         | 1             | 15              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 15              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 15              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 15              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 15              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 15              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 15              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 15              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 15              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 15              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 15              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 15              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									       
    | APPS-760         | 1             | 16              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 16              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 16              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 16              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 16              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 16              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 16              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 16              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 16              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 16              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 16              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 16              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #
    | APPS-760         | 1             | 17              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 17              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 17              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 17              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 17              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 17              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 17              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 17              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 17              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 17              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 17              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 17              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-760         | 1             | 18              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 18              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 18              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 18              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 18              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 18              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 18              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 18              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 18              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 18              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 18              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 18              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-760         | 1             | 19              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 19              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 19              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 19              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 19              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 19              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 19              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 19              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 19              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 19              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 19              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 19              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-760         | 1             | 20              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 20              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 20              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 20              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 20              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 20              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 20              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 20              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 20              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 20              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 20              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 20              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #
    | APPS-760         | 1             | 21              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 21              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 21              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 21              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 21              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 21              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 21              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 21              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 21              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 21              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 21              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 21              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-760         | 1             | 22              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 22              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 22              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 22              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 22              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 22              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 22              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 22              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 22              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 22              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 22              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 22              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-760         | 1             | 23              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 23              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 23              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 23              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 23              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 23              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 23              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 23              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 23              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 23              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 23              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 23              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-760         | 1             | 24              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 24              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 24              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 24              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 24              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 24              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 24              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 24              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 24              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 24              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 24              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-760         | 1             | 24              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |

    # Check that the MonitoringDeliverables.HeldReportedActualGroup rows show the APPS1819 data has not been processed for either of the sources
    And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017760' and Collection 'R04' marked as unprocessed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017760' and Collection 'APPS19' marked as unprocessed

    # Tidy up
     And   the override date is reset

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run67
Scenario: A765 Create and approve a Mainstream contract with a 16-18TRN1819 and APPS1819 (Carry-in) allocations. Consume actuals for APPS19 and R04. Check staging. Dont park Carry-In actuals. Check CRM, PaaS, Payment files\feed, HeldReportedActualGroup and Actuals Audit.
    Given there is no Contract, Task or Workflow data for UKPRN '10017765' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Clear down the DEDS
    And   there are no entries in the DCFS stub table 

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for this provider
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017765'

    # Clear down subnominal data
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | APPS-765      |
    | 16TR-765      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017765' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017765 Co Ltd' with UKPRN '10017765' and OrgId 'ORG0017765' and has 'FCS1 Test' as a manager 
    And   UPIN '117765' is associated with UKPRN '10017765' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017765 | 117765 | 10017765 Co Ltd | 0              | Active | Yes           | AA017765      | ?             | 

    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017765 | 10017765 Co Ltd      | ESFA-765             | MAIN-765       | 1                     | 01/08/2018        | 31/07/2019      | 138360.00     |                                | Contract for Services | 1819   | New          | ORG0017765 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName     | UoPCode    | AllocationDescription    | CRMIntent    | DeliveryOrg |
    | 10017765 | MAIN-765       | 16TR-765      | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2018          | 31/07/2019        | 43230.00        |             |            |                          | New          |             |
    | 10017765 | MAIN-765       | APPS-765      | APPS              | APPS1819                | AY                      | 01/08/2018          | 31/07/2019        | 95130.00        |             |            |                          | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                   | CRMIntent    | DeliveryOrg |
    | 10017765 | MAIN-765       | 16TR-765      | 1               | 0                     | 43230.00  | 2035.00  | 2114.00  | 4595.00  | 2589.00  | 3172.00  | 3157.00  | 4185.00  | 4802.00  | 3933.00  | 2841.00  | 5133.00  | 4674.00  | 16-18 Traineeships Funding               | New          |             |
    | 10017765 | MAIN-765       | 16TR-765      | 2               | 1                     | 15991.00  | 1308.00  | 493.00   | 1956.00  | 1269.00  | 612.00   | 1600.00  | 2336.00  | 1110.00  | 1086.00  | 177.00   | 2904.00  | 1140.00  | 16-18 Traineeships Programme Funding     | New          |             |
    | 10017765 | MAIN-765       | 16TR-765      | 3               | 1                     | 27239.00  | 727.00   | 1621.00  | 2639.00  | 1320.00  | 2560.00  | 1557.00  | 1849.00  | 3692.00  | 2847.00  | 2664.00  | 2229.00  | 3534.00  | 16-18 Traineeships Bursary Funding       | New          |             |
    | 10017765 | MAIN-765       | APPS-765      | 1               | 0                     | 95130.00  | 13588.00 | 12906.00 | 13287.00 | 7827.00  | 3524.00  | 7115.00  | 4958.00  | 7113.00  | 7930.00  | 7495.00  | 4800.00  | 4587.00  | Apprenticeships Carry-In Total Funding   | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '04/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-765' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '07/07/2018'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-765' and actual ContractNumber 'MAIN-765'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-765' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017765 | MAIN-765           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017765 | ESFA-765           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '324' deliverable period rows in CRM linked to the latest version of contract 'MAIN-765'

	# Check that the CRM subnominals have been created 
	And   CRM subnominals have been created for the following allocations
	| AllocationRef | Subnominal Code  | Period | Payment Type   |
	| 16TR-765      | 2201300		   | Jul-19 | Reconciliation |
	| APPS-765      | 2240100          | Jul-19 | Reconciliation |


	

    # Change the date
    Given the override date is '06/12/2018'

    # Inject DC Actuals for Nov 2018 for APPS19 (APPS-765 only) and R04 (APPS-765 and 16TR-765)
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS19               | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 8               | 0            | 1087.77     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 9               | 0            | 846.79      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 10              | 0            | 911.33      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 22              | 0            | 505.39      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 23              | 0            | 522.73      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 24              | 0            | 1184.64     |
    #
    | APPS           | APPS19               | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 8               | 0            | 119.62      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 9               | 0            | 1165.02     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 10              | 0            | 1240.29     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 22              | 0            | 1092.66     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 23              | 0            | 163.49      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 24              | 0            | 679.64      |
    #
    | APPS           | APPS19               | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 8               | 0            | 1307.67     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 9               | 0            | 1206.67     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 10              | 0            | 622.95      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 22              | 0            | 1446.74     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 23              | 0            | 1320.03     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 24              | 0            | 178.73      |
    #
    | APPS           | APPS19               | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 8               | 0            | 1429.38     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 9               | 0            | 609.62      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 10              | 0            | 834.82      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 22              | 0            | 1173.96     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 23              | 0            | 174.90      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 24              | 0            | 929.44      |
    #
    | APPS           | APPS19               | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 8               | 0            | 756.18      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 9               | 0            | 517.43      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 10              | 0            | 971.78      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 22              | 0            | 1006.95     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 23              | 0            | 469.31      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 24              | 0            | 491.08      |
    #
    | APPS           | APPS19               | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 8               | 0            | 1261.73     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 9               | 0            | 1254.45     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 10              | 0            | 924.83      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 22              | 0            | 1480.54     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 23              | 0            | 1375.35     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 24              | 0            | 417.61      |
    #
    | APPS           | APPS19               | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 8               | 0            | 1073.16     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 9               | 0            | 1472.01     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 10              | 0            | 441.50      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 22              | 0            | 847.42      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 23              | 0            | 248.91      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 24              | 0            | 1499.19     |
    #
    | APPS           | APPS19               | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 8               | 0            | 1046.65     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 9               | 0            | 121.98      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 10              | 0            | 905.26      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 22              | 0            | 240.07      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 23              | 0            | 244.23      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 24              | 0            | 1218.44     |
    #
    | APPS           | APPS19               | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 8               | 0            | 498.27      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 9               | 0            | 163.90      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 10              | 0            | 514.08      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 22              | 0            | 634.81      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 23              | 0            | 521.36      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 24              | 0            | 1428.00     |
    #
    | APPS           | APPS19               | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 8               | 0            | 1471.77     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 9               | 0            | 661.92      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 10              | 0            | 489.59      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 22              | 0            | 324.61      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 23              | 0            | 327.95      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 24              | 0            | 1005.22     |
    #
    | APPS           | APPS19               | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 8               | 0            | 674.10      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 9               | 0            | 677.87      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 10              | 0            | 1097.82     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 22              | 0            | 556.69      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 23              | 0            | 986.45      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 24              | 0            | 390.58      |
    #
    | APPS           | APPS19               | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 8               | 0            | 360.42      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 9               | 0            | 916.70      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 10              | 0            | 213.00      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 22              | 0            | 741.16      |
    | APPS           | APPS19               | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 23              | 0            | 1368.03     |
    | APPS           | APPS19               | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 24              | 0            | 465.91      |
    #
    | ILR1819        | R04                  | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 2               | 0            | 1199.30     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 3               | 0            | 630.46      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 4               | 0            | 505.53      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 5               | 0            | 1387.13     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 6               | 0            | 984.44      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 11              | 0            | 978.70      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 12              | 0            | 699.84      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 13              | 0            | 237.16      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 14              | 0            | 885.46      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 15              | 0            | 1072.28     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 16              | 0            | 1379.21     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 17              | 0            | 1268.75     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 19              | 0            | 131.68      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 20              | 0            | 860.71      |
    #
    | ILR1819        | R04                  | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 2               | 0            | 1382.63     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 3               | 0            | 702.36      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 4               | 0            | 1049.13     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 5               | 0            | 803.44      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 6               | 0            | 819.23      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 11              | 0            | 748.17      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 12              | 0            | 594.86      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 13              | 0            | 666.77      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 14              | 0            | 477.62      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 15              | 0            | 177.83      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 16              | 0            | 441.38      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 17              | 0            | 1470.71     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 19              | 0            | 185.28      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201809 | APPS1819                | APPS-765                 |         | 20              | 0            | 646.41      |
    #
    | ILR1819        | R04                  | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 2               | 0            | 610.99      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 3               | 0            | 785.85      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 4               | 0            | 317.92      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 5               | 0            | 764.24      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 6               | 0            | 460.17      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 11              | 0            | 980.25      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 12              | 0            | 858.90      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 13              | 0            | 318.82      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 14              | 0            | 1413.97     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 15              | 0            | 1016.30     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 16              | 0            | 808.52      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 17              | 0            | 646.66      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 19              | 0            | 250.32      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201810 | APPS1819                | APPS-765                 |         | 20              | 0            | 1197.60     |
    #
    | ILR1819        | R04                  | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 2               | 0            | 743.50      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 3               | 0            | 1155.17     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 4               | 0            | 934.53      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 5               | 0            | 1265.83     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 6               | 0            | 126.26      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 11              | 0            | 394.51      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 12              | 0            | 203.53      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 13              | 0            | 247.63      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 14              | 0            | 564.37      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 15              | 0            | 279.55      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 16              | 0            | 100.33      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 17              | 0            | 851.51      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 19              | 0            | 1019.88     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201811 | APPS1819                | APPS-765                 |         | 20              | 0            | 861.62      |
    #
    | ILR1819        | R04                  | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 2               | 0            | 1258.38     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 3               | 0            | 214.65      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 4               | 0            | 368.69      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 5               | 0            | 1050.48     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 6               | 0            | 735.89      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 11              | 0            | 599.83      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 12              | 0            | 309.97      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 13              | 0            | 1086.16     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 14              | 0            | 1400.30     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 15              | 0            | 842.30      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 16              | 0            | 225.49      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 17              | 0            | 1160.82     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 19              | 0            | 662.58      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201812 | APPS1819                | APPS-765                 |         | 20              | 0            | 746.62      |
    #
    | ILR1819        | R04                  | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 2               | 0            | 789.03      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 3               | 0            | 390.68      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 4               | 0            | 561.63      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 5               | 0            | 233.60      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 6               | 0            | 925.71      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 11              | 0            | 337.82      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 12              | 0            | 1398.67     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 13              | 0            | 237.10      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 14              | 0            | 721.41      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 15              | 0            | 482.12      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 16              | 0            | 1321.57     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 17              | 0            | 1150.97     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 19              | 0            | 482.12      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201901 | APPS1819                | APPS-765                 |         | 20              | 0            | 1043.11     |
    #
    | ILR1819        | R04                  | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 2               | 0            | 459.28      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 3               | 0            | 225.85      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 4               | 0            | 143.33      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 5               | 0            | 551.80      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 6               | 0            | 1206.18     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 11              | 0            | 516.16      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 12              | 0            | 429.39      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 13              | 0            | 772.66      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 14              | 0            | 456.44      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 15              | 0            | 576.85      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 16              | 0            | 162.90      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 17              | 0            | 775.40      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 19              | 0            | 388.42      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201902 | APPS1819                | APPS-765                 |         | 20              | 0            | 1310.35     |
    #
    | ILR1819        | R04                  | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 2               | 0            | 924.08      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 3               | 0            | 1156.87     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 4               | 0            | 1399.04     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 5               | 0            | 563.42      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 6               | 0            | 860.12      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 11              | 0            | 212.96      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 12              | 0            | 988.12      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 13              | 0            | 674.05      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 14              | 0            | 1444.60     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 15              | 0            | 260.47      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 16              | 0            | 1392.83     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 17              | 0            | 968.29      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 19              | 0            | 586.82      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201903 | APPS1819                | APPS-765                 |         | 20              | 0            | 308.94      |
    #
    | ILR1819        | R04                  | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 2               | 0            | 771.97      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 3               | 0            | 407.17      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 4               | 0            | 1491.23     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 5               | 0            | 282.58      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 6               | 0            | 140.44      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 11              | 0            | 583.55      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 12              | 0            | 866.74      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 13              | 0            | 1392.14     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 14              | 0            | 853.55      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 15              | 0            | 668.99      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 16              | 0            | 1286.15     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 17              | 0            | 1256.72     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 19              | 0            | 1041.40     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201904 | APPS1819                | APPS-765                 |         | 20              | 0            | 1110.66     |
    #
    | ILR1819        | R04                  | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 2               | 0            | 1495.48     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 3               | 0            | 575.73      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 4               | 0            | 793.30      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 5               | 0            | 678.15      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 6               | 0            | 1073.40     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 11              | 0            | 350.72      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 12              | 0            | 692.08      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 13              | 0            | 860.45      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 14              | 0            | 1240.53     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 15              | 0            | 857.28      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 16              | 0            | 698.55      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 17              | 0            | 812.70      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 19              | 0            | 418.89      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201905 | APPS1819                | APPS-765                 |         | 20              | 0            | 966.86      |
    #
    | ILR1819        | R04                  | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 2               | 0            | 785.76      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 3               | 0            | 1053.15     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 4               | 0            | 1341.24     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 5               | 0            | 618.72      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 6               | 0            | 523.49      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 11              | 0            | 510.01      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 12              | 0            | 310.43      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 13              | 0            | 841.75      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 14              | 0            | 412.56      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 15              | 0            | 918.34      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 16              | 0            | 608.84      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 17              | 0            | 1326.37     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 19              | 0            | 769.22      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201906 | APPS1819                | APPS-765                 |         | 20              | 0            | 366.88      |
    #
    | ILR1819        | R04                  | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 2               | 0            | 1057.69     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 3               | 0            | 1146.38     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 4               | 0            | 959.51      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 5               | 0            | 1195.00     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 6               | 0            | 326.44      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 11              | 0            | 1230.89     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 12              | 0            | 383.66      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 13              | 0            | 1439.47     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 14              | 0            | 192.19      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 15              | 0            | 186.13      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 16              | 0            | 1210.48     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 17              | 0            | 631.45      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 19              | 0            | 749.02      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201907 | APPS1819                | APPS-765                 |         | 20              | 0            | 267.36      |
    # 16-18TRN1819
    | ILR1819        | R04                  | ORG0017765     | CM             | 201808 | 16-18TRN1819            | 16TR-765                 |         | 2               | 0            | 1199.30     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201808 | 16-18TRN1819            | 16TR-765                 |         | 3               | 0            | 630.46      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201809 | 16-18TRN1819            | 16TR-765                 |         | 2               | 0            | 505.53      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201809 | 16-18TRN1819            | 16TR-765                 |         | 3               | 0            | 1387.13     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201810 | 16-18TRN1819            | 16TR-765                 |         | 2               | 0            | 984.44      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201810 | 16-18TRN1819            | 16TR-765                 |         | 3               | 0            | 978.70      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201811 | 16-18TRN1819            | 16TR-765                 |         | 2               | 0            | 699.84      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201811 | 16-18TRN1819            | 16TR-765                 |         | 3               | 0            | 237.16      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201812 | 16-18TRN1819            | 16TR-765                 |         | 2               | 0            | 885.46      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201812 | 16-18TRN1819            | 16TR-765                 |         | 3               | 0            | 1072.28     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201901 | 16-18TRN1819            | 16TR-765                 |         | 2               | 0            | 1379.21     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201901 | 16-18TRN1819            | 16TR-765                 |         | 3               | 0            | 1268.75     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201902 | 16-18TRN1819            | 16TR-765                 |         | 2               | 0            | 131.68      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201902 | 16-18TRN1819            | 16TR-765                 |         | 3               | 0            | 860.71      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201903 | 16-18TRN1819            | 16TR-765                 |         | 2               | 0            | 1382.63     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201903 | 16-18TRN1819            | 16TR-765                 |         | 3               | 0            | 702.36      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201904 | 16-18TRN1819            | 16TR-765                 |         | 2               | 0            | 1049.13     |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201904 | 16-18TRN1819            | 16TR-765                 |         | 3               | 0            | 803.44      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201905 | 16-18TRN1819            | 16TR-765                 |         | 2               | 0            | 819.23      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201905 | 16-18TRN1819            | 16TR-765                 |         | 3               | 0            | 748.17      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201906 | 16-18TRN1819            | 16TR-765                 |         | 2               | 0            | 594.86      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201906 | 16-18TRN1819            | 16TR-765                 |         | 3               | 0            | 666.77      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201907 | 16-18TRN1819            | 16TR-765                 |         | 2               | 0            | 477.62      |
    | ILR1819        | R04                  | ORG0017765     | CM             | 201907 | 16-18TRN1819            | 16TR-765                 |         | 3               | 0            | 177.83      |

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

	# Check sample Summarised Actuals from both collections have been stored in staging
	Then the following Actuals are stored in FCT for processing
	| OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
	| ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 8               | 0            | 1087.77     |
	| ORG0017765     | CM             | 201808 | APPS1819                | APPS-765                 |         | 2               | 0            | 1199.30     |
	
    # Check MonitoringDeliverables.HeldReportedActualGroup. Is the data showing as unprocessed ?
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017765' and Collection 'R04' marked as unprocessed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017765' and Collection 'APPS19' marked as unprocessed

    # Check the ACTUALS have arrived in CRM for the non-held FSP
	And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | 
    | MAIN-765       | 16TR-765        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | MAIN-765       | 16TR-765        | 2               | 3389.11  | 1199.30  | 505.53   | 984.44   | 699.84   | ?        | 
    | MAIN-765       | 16TR-765        | 3               | 3233.45  | 630.46   | 1387.13  | 978.70   | 237.16   | ?        | 
	
	# Now that non-held actuals have arrived in CRM, mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
	When  MonthEnd processing has completed and the processing of held data is triggered

	# Check sample Actuals Audit have been written to PaaS (MonitoringDeliverables.AllocationDeliverablePeriodActualAudit) for both collections
	Then  the Actuals Audit contains the following
	| CollectionType | CollectionReturnCode | CollectionReturnPeriod | AllocationNumber | ContractNumber | ContractVersion | ContractSubVersion | AllocationStartDate | AllocationEndDate | OrganisationId | UKPRN    | FundingStreamPeriodCode | UopCode | DeliverableCode | ParentDeliverableCode | Period | PeriodTypeCode | ActualValue | ActualVolume |
	| APPS           | APPS19               | 201811                 | APPS-765         | MAIN-765       | 1               | 0                  | 01/08/2018          | 31/07/2019        | ORG0017765     | 10017765 | APPS1819                |         | 8               | 1                     | 201808 | CM             | 1087.77     | 0            |
	| ILR1819        | R04                  | 201811                 | APPS-765         | MAIN-765       | 1               | 0                  | 01/08/2018          | 31/07/2019        | ORG0017765     | 10017765 | APPS1819                |         | 2               | 1                     | 201808 | CM             | 1199.30     | 0            |
    
	# Check the RECONCILIATION subnominal aggregations in PaaS for Nov 2018
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017765 | ORG0017765 | 16TR-765          | 2201300         | 16-18TRN1819               | 201811               | RECONCILIATION  | CM             | False       | 3389.11         |
    | 10017765 | ORG0017765 | 16TR-765          | 2201350         | 16-18TRN1819               | 201811               | RECONCILIATION  | CM             | False       | 3233.45         |
    #
    | 10017765 | ORG0017765 | APPS-765          | 2240100         | APPS1819                   | 201811               | RECONCILIATION  | CM             | False       | 16628.11        |
    | 10017765 | ORG0017765 | APPS-765          | 2240150         | APPS1819                   | 201811               | RECONCILIATION  | CM             | False       | 7772.54         |
    | 10017765 | ORG0017765 | APPS-765          | 2240160         | APPS1819                   | 201811               | RECONCILIATION  | CM             | False       | 3609.39         |
    | 10017765 | ORG0017765 | APPS-765          | 2340100         | APPS1819                   | 201811               | RECONCILIATION  | CM             | False       | 24937.09        |
    | 10017765 | ORG0017765 | APPS-765          | 2340150         | APPS1819                   | 201811               | RECONCILIATION  | CM             | False       | 6399.90         |
    | 10017765 | ORG0017765 | APPS-765          | 2340160         | APPS1819                   | 201811               | RECONCILIATION  | CM             | False       | 2972.45         |

    # Check the CAPPING subnominal aggregations in PaaS for Nov 2018
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017765 | ORG0017765 | 16TR-765          | 2201300         | 16-18TRN1819               | 201811               | CAPPING         | CM             | False       | 0.00            |
    | 10017765 | ORG0017765 | 16TR-765          | 2201350         | 16-18TRN1819               | 201811               | CAPPING         | CM             | False       | 0.00            |
    #
    | 10017765 | ORG0017765 | APPS-765          | 2240100         | APPS1819                   | 201811               | CAPPING         | CM             | False       | 0.00            |
    | 10017765 | ORG0017765 | APPS-765          | 2240150         | APPS1819                   | 201811               | CAPPING         | CM             | False       | 0.00            |
    | 10017765 | ORG0017765 | APPS-765          | 2240160         | APPS1819                   | 201811               | CAPPING         | CM             | False       | 0.00            |
    | 10017765 | ORG0017765 | APPS-765          | 2340100         | APPS1819                   | 201811               | CAPPING         | CM             | False       | 0.00            |
    | 10017765 | ORG0017765 | APPS-765          | 2340150         | APPS1819                   | 201811               | CAPPING         | CM             | False       | 0.00            |
    | 10017765 | ORG0017765 | APPS-765          | 2340160         | APPS1819                   | 201811               | CAPPING         | CM             | False       | 0.00            |

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-765       | 16TR-765        | 1               | 43230.00 | 2035.00  | 2114.00  | 4595.00  | 2589.00  | 3172.00  | 3157.00  | 4185.00  | 4802.00  | 3933.00  | 2841.00  | 5133.00  | 4674.00  | 
    | MAIN-765       | 16TR-765        | 2               | 15991.00 | 1308.00  | 493.00   | 1956.00  | 1269.00  | 612.00   | 1600.00  | 2336.00  | 1110.00  | 1086.00  | 177.00   | 2904.00  | 1140.00  | 
    | MAIN-765       | 16TR-765        | 3               | 27239.00 | 727.00   | 1621.00  | 2639.00  | 1320.00  | 2560.00  | 1557.00  | 1849.00  | 3692.00  | 2847.00  | 2664.00  | 2229.00  | 3534.00  | 
    | MAIN-765       | APPS-765        | 1               | 95130.00 | 13588.00 | 12906.00 | 13287.00 | 7827.00  | 3524.00  | 7115.00  | 4958.00  | 7113.00  | 7930.00  | 7495.00  | 4800.00  | 4587.00  | 

    # Check the ACTUALS in CRM. (Data is from both the APPS and ILR sources)
	And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   |
    | MAIN-765       | 16TR-765        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | 16TR-765        | 2               | 3389.11  | 1199.30  | 505.53   | 984.44   | 699.84   | ?        |
    | MAIN-765       | 16TR-765        | 3               | 3233.45  | 630.46   | 1387.13  | 978.70   | 237.16   | ?        |
    #
    | MAIN-765       | APPS-765        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 2               | 3936.42  | 1199.30  | 1382.63  | 610.99   | 743.50   | ?        |
    | MAIN-765       | APPS-765        | 3               | 3273.84  | 630.46   | 702.36   | 785.85   | 1155.17  | ?        |
    | MAIN-765       | APPS-765        | 4               | 2807.11  | 505.53   | 1049.13  | 317.92   | 934.53   | ?        |
    | MAIN-765       | APPS-765        | 5               | 4220.64  | 1387.13  | 803.44   | 764.24   | 1265.83  | ?        |
    | MAIN-765       | APPS-765        | 6               | 2390.10  | 984.44   | 819.23   | 460.17   | 126.26   | ?        |
    | MAIN-765       | APPS-765        | 7               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 8               | 3944.44  | 1087.77  | 119.62   | 1307.67  | 1429.38  | ?        |
    | MAIN-765       | APPS-765        | 9               | 3828.10  | 846.79   | 1165.02  | 1206.67  | 609.62   | ?        |
    | MAIN-765       | APPS-765        | 10              | 3609.39  | 911.33   | 1240.29  | 622.95   | 834.82   | ?        |
    | MAIN-765       | APPS-765        | 11              | 3101.63  | 978.70   | 748.17   | 980.25   | 394.51   | ?        |
    | MAIN-765       | APPS-765        | 12              | 2357.13  | 699.84   | 594.86   | 858.90   | 203.53   | ?        |
    | MAIN-765       | APPS-765        | 13              | 1470.38  | 237.16   | 666.77   | 318.82   | 247.63   | ?        |
    | MAIN-765       | APPS-765        | 14              | 3341.42  | 885.46   | 477.62   | 1413.97  | 564.37   | ?        |
    | MAIN-765       | APPS-765        | 15              | 2545.96  | 1072.28  | 177.83   | 1016.30  | 279.55   | ?        |
    | MAIN-765       | APPS-765        | 16              | 2729.44  | 1379.21  | 441.38   | 808.52   | 100.33   | ?        |
    | MAIN-765       | APPS-765        | 17              | 4237.63  | 1268.75  | 1470.71  | 646.66   | 851.51   | ?        |
    | MAIN-765       | APPS-765        | 18              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 19              | 1587.16  | 131.68   | 185.28   | 250.32   | 1019.88  | ?        |
    | MAIN-765       | APPS-765        | 20              | 3566.34  | 860.71   | 646.41   | 1197.60  | 861.62   | ?        |
    | MAIN-765       | APPS-765        | 21              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 22              | 4218.75  | 505.39   | 1092.66  | 1446.74  | 1173.96  | ?        |
    | MAIN-765       | APPS-765        | 23              | 2181.15  | 522.73   | 163.49   | 1320.03  | 174.90   | ?        |
    | MAIN-765       | APPS-765        | 24              | 2972.45  | 1184.64  | 679.64   | 178.73   | 929.44   | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | 
    | MAIN-765       | 16TR-765        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | MAIN-765       | 16TR-765        | 2               | 3389.11  | 0.00     | 0.00     | 0.00     | 3389.11  | ?        | 
    | MAIN-765       | 16TR-765        | 3               | 3233.45  | 0.00     | 0.00     | 0.00     | 3233.45  | ?        | 
    #
    | MAIN-765       | APPS-765        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | MAIN-765       | APPS-765        | 2               | 3936.42  | 0.00     | 0.00     | 0.00     | 3936.42  | ?        | 
    | MAIN-765       | APPS-765        | 3               | 3273.84  | 0.00     | 0.00     | 0.00     | 3273.84  | ?        | 
    | MAIN-765       | APPS-765        | 4               | 2807.11  | 0.00     | 0.00     | 0.00     | 2807.11  | ?        | 
    | MAIN-765       | APPS-765        | 5               | 4220.64  | 0.00     | 0.00     | 0.00     | 4220.64  | ?        | 
    | MAIN-765       | APPS-765        | 6               | 2390.10  | 0.00     | 0.00     | 0.00     | 2390.10  | ?        | 
    | MAIN-765       | APPS-765        | 7               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | MAIN-765       | APPS-765        | 8               | 3944.44  | 0.00     | 0.00     | 0.00     | 3944.44  | ?        | 
    | MAIN-765       | APPS-765        | 9               | 3828.10  | 0.00     | 0.00     | 0.00     | 3828.10  | ?        | 
    | MAIN-765       | APPS-765        | 10              | 3609.39  | 0.00     | 0.00     | 0.00     | 3609.39  | ?        | 
    | MAIN-765       | APPS-765        | 11              | 3101.63  | 0.00     | 0.00     | 0.00     | 3101.63  | ?        | 
    | MAIN-765       | APPS-765        | 12              | 2357.13  | 0.00     | 0.00     | 0.00     | 2357.13  | ?        | 
    | MAIN-765       | APPS-765        | 13              | 1470.38  | 0.00     | 0.00     | 0.00     | 1470.38  | ?        | 
    | MAIN-765       | APPS-765        | 14              | 3341.42  | 0.00     | 0.00     | 0.00     | 3341.42  | ?        | 
    | MAIN-765       | APPS-765        | 15              | 2545.96  | 0.00     | 0.00     | 0.00     | 2545.96  | ?        | 
    | MAIN-765       | APPS-765        | 16              | 2729.44  | 0.00     | 0.00     | 0.00     | 2729.44  | ?        | 
    | MAIN-765       | APPS-765        | 17              | 4237.63  | 0.00     | 0.00     | 0.00     | 4237.63  | ?        | 
    | MAIN-765       | APPS-765        | 18              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | MAIN-765       | APPS-765        | 19              | 1587.16  | 0.00     | 0.00     | 0.00     | 1587.16  | ?        | 
    | MAIN-765       | APPS-765        | 20              | 3566.34  | 0.00     | 0.00     | 0.00     | 3566.34  | ?        | 
    | MAIN-765       | APPS-765        | 21              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | MAIN-765       | APPS-765        | 22              | 4218.75  | 0.00     | 0.00     | 0.00     | 4218.75  | ?        | 
    | MAIN-765       | APPS-765        | 23              | 2181.15  | 0.00     | 0.00     | 0.00     | 2181.15  | ?        | 
    | MAIN-765       | APPS-765        | 24              | 2972.45  | 0.00     | 0.00     | 0.00     | 2972.45  | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   |
    | MAIN-765       | 16TR-765        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | 16TR-765        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | 16TR-765        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
	#
    | MAIN-765       | APPS-765        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 7               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 8               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 9               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 10              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 11              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 12              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 13              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 14              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 15              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 16              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 17              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 18              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 19              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 20              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 21              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 22              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 23              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |
    | MAIN-765       | APPS-765        | 24              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | 
    | MAIN-765       | 16TR-765        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |  
    | MAIN-765       | 16TR-765        | 2               | 3389.11  | 0.00     | 0.00     | 0.00     | 3389.11  | ?        |  
    | MAIN-765       | 16TR-765        | 3               | 3233.45  | 0.00     | 0.00     | 0.00     | 3233.45  | ?        |  
    #
    | MAIN-765       | APPS-765        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |  
    | MAIN-765       | APPS-765        | 2               | 3936.42  | 0.00     | 0.00     | 0.00     | 3936.42  | ?        |  
    | MAIN-765       | APPS-765        | 3               | 3273.84  | 0.00     | 0.00     | 0.00     | 3273.84  | ?        |  
    | MAIN-765       | APPS-765        | 4               | 2807.11  | 0.00     | 0.00     | 0.00     | 2807.11  | ?        |  
    | MAIN-765       | APPS-765        | 5               | 4220.64  | 0.00     | 0.00     | 0.00     | 4220.64  | ?        |  
    | MAIN-765       | APPS-765        | 6               | 2390.10  | 0.00     | 0.00     | 0.00     | 2390.10  | ?        |  
    | MAIN-765       | APPS-765        | 7               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |  
    | MAIN-765       | APPS-765        | 8               | 3944.44  | 0.00     | 0.00     | 0.00     | 3944.44  | ?        |  
    | MAIN-765       | APPS-765        | 9               | 3828.10  | 0.00     | 0.00     | 0.00     | 3828.10  | ?        |  
    | MAIN-765       | APPS-765        | 10              | 3609.39  | 0.00     | 0.00     | 0.00     | 3609.39  | ?        |  
    | MAIN-765       | APPS-765        | 11              | 3101.63  | 0.00     | 0.00     | 0.00     | 3101.63  | ?        |  
    | MAIN-765       | APPS-765        | 12              | 2357.13  | 0.00     | 0.00     | 0.00     | 2357.13  | ?        |  
    | MAIN-765       | APPS-765        | 13              | 1470.38  | 0.00     | 0.00     | 0.00     | 1470.38  | ?        |  
    | MAIN-765       | APPS-765        | 14              | 3341.42  | 0.00     | 0.00     | 0.00     | 3341.42  | ?        |  
    | MAIN-765       | APPS-765        | 15              | 2545.96  | 0.00     | 0.00     | 0.00     | 2545.96  | ?        |  
    | MAIN-765       | APPS-765        | 16              | 2729.44  | 0.00     | 0.00     | 0.00     | 2729.44  | ?        |  
    | MAIN-765       | APPS-765        | 17              | 4237.63  | 0.00     | 0.00     | 0.00     | 4237.63  | ?        |  
    | MAIN-765       | APPS-765        | 18              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |  
    | MAIN-765       | APPS-765        | 19              | 1587.16  | 0.00     | 0.00     | 0.00     | 1587.16  | ?        |  
    | MAIN-765       | APPS-765        | 20              | 3566.34  | 0.00     | 0.00     | 0.00     | 3566.34  | ?        |  
    | MAIN-765       | APPS-765        | 21              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        |  
    | MAIN-765       | APPS-765        | 22              | 4218.75  | 0.00     | 0.00     | 0.00     | 4218.75  | ?        |  
    | MAIN-765       | APPS-765        | 23              | 2181.15  | 0.00     | 0.00     | 0.00     | 2181.15  | ?        |  
    | MAIN-765       | APPS-765        | 24              | 2972.45  | 0.00     | 0.00     | 0.00     | 2972.45  | ?        |  

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts in CRM are as follows
    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Aug-18   | Sep-18   | Oct-18   | Nov-18   |
    | MAIN-765       | 16TR-765        | 2201300                  | 0.00     | 0.00     | 0.00     | 3389.11  | 
    | MAIN-765       | 16TR-765        | 2201350                  | 0.00     | 0.00     | 0.00     | 3233.45  | 
	#
	| MAIN-765       | APPS-765        | 2240100                  | 0.00     | 0.00     | 0.00     | 16628.11 | 
	| MAIN-765       | APPS-765        | 2240150                  | 0.00     | 0.00     | 0.00     | 7772.54  | 
	| MAIN-765       | APPS-765        | 2240160                  | 0.00     | 0.00     | 0.00     | 3609.39  | 
	| MAIN-765       | APPS-765        | 2340100                  | 0.00     | 0.00     | 0.00     | 24937.09 | 
	| MAIN-765       | APPS-765        | 2340150                  | 0.00     | 0.00     | 0.00     | 6399.90  | 
	| MAIN-765       | APPS-765        | 2340160                  | 0.00     | 0.00     | 0.00     | 2972.45  | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | CappingSubnominal        | Aug-18   | Sep-18   | Oct-18   | Nov-18   |
    | MAIN-765       | 16TR-765        | 2201300                  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-765       | 16TR-765        | 2201350                  | 0.00     | 0.00     | 0.00     | 0.00     | 
	#
	| MAIN-765       | APPS-765        | 2240100                  | 0.00     | 0.00     | 0.00     | 0.00     | 
	| MAIN-765       | APPS-765        | 2240150                  | 0.00     | 0.00     | 0.00     | 0.00     | 
	| MAIN-765       | APPS-765        | 2240160                  | 0.00     | 0.00     | 0.00     | 0.00     | 
	| MAIN-765       | APPS-765        | 2340100                  | 0.00     | 0.00     | 0.00     | 0.00     | 
	| MAIN-765       | APPS-765        | 2340150                  | 0.00     | 0.00     | 0.00     | 0.00     | 
	| MAIN-765       | APPS-765        | 2340160                  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check MonitoringDeliverables.HeldReportedActualGroup table
    # Unprocessed
    And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017765' and Collection 'APPS19' marked as unprocessed
    And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017765' and Collection 'R04' marked as unprocessed
    And   there are '0' rows on table HeldReportedActualGroup for FSP '16-18TRN1819' OrgId 'ORG0017765' and Collection 'R04' marked as unprocessed
    # Processed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017765' and Collection 'APPS19' marked as processed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017765' and Collection 'R04' marked as processed
    And   there are '0' rows on table HeldReportedActualGroup for FSP '16-18TRN1819' OrgId 'ORG0017765' and Collection 'R04' marked as processed

    # Tidy up
    And   the override date is reset

