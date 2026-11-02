Feature: AppsCarryIn2 22087

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run67
Scenario: A766SLD Create and approve a Mainstream contract with a 16-18TRN1819 and APPS1819 (Carry-in) allocations. Consume R06 actuals. Park ILR-APPS data but process ILR-TRN data. Consume APPS21 actuals. Release ILR-APPS data with APPS21 data. Check CRM, PaaS, Payment files\feed and HeldReportedActualGroup
    Given there is no Contract, Task or Workflow data for UKPRN '10017766' 

    # Month End is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Clear down the DEDS
    And   there are no entries in the DCFS stub table 

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for this provider
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017766'

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16TR-766      |
    | APPS-766      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017766' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017766 Co Ltd' with UKPRN '10017766' and OrgId 'ORG0017766' and has 'FCS1 Test' as a manager 
    And   UPIN '117766' is associated with UKPRN '10017766' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017766 | 117766 | 10017766 Co Ltd | 0              | Active | Yes           | AA017766      | ?             | 

    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017766 | 10017766 Co Ltd      | ESFA-766             | MAIN-766       | 1                     | 01/08/2018        | 31/07/2019      | 104365.00     |                                | Contract for Services | 1819   | New          | ORG0017766 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017766 | MAIN-766       | 16TR-766      | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2018          | 31/07/2019        | 40330.00        |                         |            |                                                             | New          |             |
    | 10017766 | MAIN-766       | APPS-766      | APPS              | APPS1819                | AY                      | 01/08/2018          | 31/07/2019        | 64035.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017766 | MAIN-766       | 16TR-766      | 1               | 0                     | 40330.00  | 5934.00  | 3261.00  | 3879.00  | 2026.00  | 1917.00  | 4209.00  | 3750.00  | 4145.00  | 2960.00  | 3799.00  | 3245.00  | 1205.00  | 16-18 Traineeships Funding                                      | New          |             |
    | 10017766 | MAIN-766       | 16TR-766      | 2               | 1                     | 19443.00  | 3024.00  | 1418.00  | 2535.00  | 168.00   | 1601.00  | 2969.00  | 2565.00  | 1813.00  | 366.00   | 1008.00  | 1047.00  | 929.00   | 16-18 Traineeships Programme Funding                            | New          |             |
    | 10017766 | MAIN-766       | 16TR-766      | 3               | 1                     | 20887.00  | 2910.00  | 1843.00  | 1344.00  | 1858.00  | 316.00   | 1240.00  | 1185.00  | 2332.00  | 2594.00  | 2791.00  | 2198.00  | 276.00   | 16-18 Traineeships Bursary Funding                              | New          |             |
    | 10017766 | MAIN-766       | APPS-766      | 1               | 0                     | 64035.00  | 12281.00 | 11752.00 | 6621.00  | 13032.00 | 3200.00  | 962.00   | 2993.00  | 3319.00  | 606.00   | 1342.00  | 2835.00  | 5092.00  | Apprenticeships Carry-In Total Funding                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-766' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2018'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-766' and actual ContractNumber 'MAIN-766'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-766' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017766 | MAIN-766           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017766 | ESFA-766           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '324' deliverable period rows in CRM linked to the latest version of contract 'MAIN-766'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
	| AllocationRef | Subnominal Code | Period | Payment Type   |
	| 16TR-766      | 2201300         | Jan-19 | Reconciliation |
	| 16TR-766      | 2201350         | Jan-19 | Reconciliation |
	| APPS-766      | 2240100         | Jan-19 | Reconciliation |
	| APPS-766      | 2240150         | Jan-19 | Reconciliation |
	| APPS-766      | 2240160         | Jan-19 | Reconciliation |
	| APPS-766      | 2240170         | Jan-19 | Reconciliation |
	| APPS-766      | 2340100         | Jan-19 | Reconciliation |
	| APPS-766      | 2340150         | Jan-19 | Reconciliation |
	| APPS-766      | 2340160         | Jan-19 | Reconciliation |
	| APPS-766      | 2340170         | Jan-19 | Reconciliation |

    # Change the date
    Given the override date is '04/02/2019'
    And there are no entries in the summarised actuals PaaS table

    # Populate DC stub with ILR actuals for R06 for APPS-766 and 16TR-766 for Jan 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 2               | 0            | 841.30      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 3               | 0            | 690.51      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 4               | 0            | 1092.23     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 5               | 0            | 1351.59     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 6               | 0            | 642.46      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 7               | 0            | 375.45      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 11              | 0            | 922.11      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 12              | 0            | 1357.78     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 13              | 0            | 1086.34     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 14              | 0            | 806.48      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 15              | 0            | 291.08      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 16              | 0            | 214.66      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 17              | 0            | 1374.23     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 18              | 0            | 1317.17     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 19              | 0            | 585.91      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 20              | 0            | 1199.47     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |            | 21              | 0            | 161.93      |
    #
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 2               | 0            | 1477.64     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 3               | 0            | 1083.77     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 4               | 0            | 1318.16     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 5               | 0            | 919.12      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 6               | 0            | 416.37      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 7               | 0            | 986.65      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 11              | 0            | 602.23      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 12              | 0            | 838.70      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 13              | 0            | 692.16      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 14              | 0            | 405.72      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 15              | 0            | 555.71      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 16              | 0            | 1096.20     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 17              | 0            | 1315.93     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 18              | 0            | 295.71      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 19              | 0            | 151.90      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 20              | 0            | 659.12      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |            | 21              | 0            | 922.61      |
    #
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 2               | 0            | 1339.28     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 3               | 0            | 580.36      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 4               | 0            | 246.35      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 5               | 0            | 1293.07     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 6               | 0            | 381.36      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 7               | 0            | 543.70      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 11              | 0            | 1037.54     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 12              | 0            | 1425.93     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 13              | 0            | 1213.61     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 14              | 0            | 304.51      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 15              | 0            | 932.41      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 16              | 0            | 359.43      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 17              | 0            | 508.72      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 18              | 0            | 482.21      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 19              | 0            | 960.19      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 20              | 0            | 343.40      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |            | 21              | 0            | 704.82      |
    #
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 2               | 0            | 1199.94     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 3               | 0            | 839.01      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 4               | 0            | 561.02      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 5               | 0            | 839.82      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 6               | 0            | 181.40      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 7               | 0            | 485.19      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 11              | 0            | 1000.74     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 12              | 0            | 335.84      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 13              | 0            | 997.79      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 14              | 0            | 472.70      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 15              | 0            | 1078.19     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 16              | 0            | 333.53      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 17              | 0            | 664.61      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 18              | 0            | 1442.51     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 19              | 0            | 1407.99     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 20              | 0            | 1176.51     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |            | 21              | 0            | 1388.59     |
    #
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 2               | 0            | 1061.92     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 3               | 0            | 325.68      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 4               | 0            | 245.63      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 5               | 0            | 264.54      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 6               | 0            | 1134.00     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 7               | 0            | 559.58      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 11              | 0            | 1343.51     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 12              | 0            | 322.24      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 13              | 0            | 1056.94     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 14              | 0            | 852.63      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 15              | 0            | 628.75      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 16              | 0            | 923.31      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 17              | 0            | 1433.41     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 18              | 0            | 534.32      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 19              | 0            | 900.43      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 20              | 0            | 1108.04     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |            | 21              | 0            | 1029.94     |
    #
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 2               | 0            | 242.53      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 3               | 0            | 1032.40     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 4               | 0            | 492.35      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 5               | 0            | 1086.32     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 6               | 0            | 195.40      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 7               | 0            | 1157.71     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 11              | 0            | 514.61      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 12              | 0            | 174.94      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 13              | 0            | 213.24      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 14              | 0            | 1202.96     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 15              | 0            | 432.53      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 16              | 0            | 610.22      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 17              | 0            | 1490.39     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 18              | 0            | 1172.67     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 19              | 0            | 670.00      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 20              | 0            | 1207.90     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |            | 21              | 0            | 317.03      |
    #
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 2               | 0            | 383.69      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 3               | 0            | 914.05      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 4               | 0            | 194.48      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 5               | 0            | 351.19      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 6               | 0            | 1249.53     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 7               | 0            | 1361.62     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 11              | 0            | 1266.58     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 12              | 0            | 1440.51     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 13              | 0            | 814.74      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 14              | 0            | 116.49      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 15              | 0            | 400.31      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 16              | 0            | 1394.14     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 17              | 0            | 839.34      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 18              | 0            | 736.21      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 19              | 0            | 1010.66     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 20              | 0            | 904.66      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |            | 21              | 0            | 1433.13     |
    #
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 2               | 0            | 528.84      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 3               | 0            | 1460.84     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 4               | 0            | 419.90      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 5               | 0            | 640.07      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 6               | 0            | 199.95      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 7               | 0            | 1121.68     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 11              | 0            | 164.86      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 12              | 0            | 1372.72     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 13              | 0            | 1249.43     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 14              | 0            | 1181.02     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 15              | 0            | 513.55      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 16              | 0            | 496.52      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 17              | 0            | 918.37      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 18              | 0            | 203.05      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 19              | 0            | 1310.88     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 20              | 0            | 664.28      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |            | 21              | 0            | 1485.97     |
    #
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 2               | 0            | 1237.72     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 3               | 0            | 144.51      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 4               | 0            | 100.41      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 5               | 0            | 316.35      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 6               | 0            | 1080.08     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 7               | 0            | 766.80      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 11              | 0            | 935.46      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 12              | 0            | 1255.54     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 13              | 0            | 879.68      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 14              | 0            | 866.60      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 15              | 0            | 1090.32     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 16              | 0            | 1178.20     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 17              | 0            | 299.92      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 18              | 0            | 1191.15     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 19              | 0            | 510.75      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 20              | 0            | 684.62      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |            | 21              | 0            | 427.48      |
    #
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 2               | 0            | 1017.99     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 3               | 0            | 751.68      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 4               | 0            | 1147.55     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 5               | 0            | 1431.64     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 6               | 0            | 976.79      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 7               | 0            | 711.56      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 11              | 0            | 709.05      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 12              | 0            | 573.63      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 13              | 0            | 621.24      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 14              | 0            | 1116.82     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 15              | 0            | 427.42      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 16              | 0            | 366.12      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 17              | 0            | 550.95      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 18              | 0            | 956.14      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 19              | 0            | 974.04      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 20              | 0            | 282.47      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |            | 21              | 0            | 683.29      |
    #
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 2               | 0            | 1264.94     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 3               | 0            | 1080.23     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 4               | 0            | 1416.19     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 5               | 0            | 275.28      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 6               | 0            | 859.63      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 7               | 0            | 534.18      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 11              | 0            | 290.24      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 12              | 0            | 1095.46     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 13              | 0            | 822.11      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 14              | 0            | 727.75      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 15              | 0            | 1216.49     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 16              | 0            | 1145.76     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 17              | 0            | 934.04      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 18              | 0            | 1353.44     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 19              | 0            | 1005.03     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 20              | 0            | 1333.41     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |            | 21              | 0            | 661.28      |
    #
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 2               | 0            | 251.14      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 3               | 0            | 623.58      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 4               | 0            | 1292.76     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 5               | 0            | 488.25      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 6               | 0            | 605.14      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 7               | 0            | 406.83      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 11              | 0            | 1157.21     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 12              | 0            | 802.29      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 13              | 0            | 290.91      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 14              | 0            | 1215.87     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 15              | 0            | 881.03      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 16              | 0            | 1128.04     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 17              | 0            | 1172.03     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 18              | 0            | 347.49      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 19              | 0            | 1311.29     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 20              | 0            | 1111.82     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |            | 21              | 0            | 546.99      |
    #
    # 16-18 Traineeships 1819
    #
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | 16-18TRN1819            | 16TR-766                 |            | 2               | 0            | 1926.35     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201808 | 16-18TRN1819            | 16TR-766                 |            | 3               | 0            | 1130.83     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | 16-18TRN1819            | 16TR-766                 |            | 2               | 0            | 1489.88     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201809 | 16-18TRN1819            | 16TR-766                 |            | 3               | 0            | 1545.22     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | 16-18TRN1819            | 16TR-766                 |            | 2               | 0            | 831.78      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201810 | 16-18TRN1819            | 16TR-766                 |            | 3               | 0            | 864.33      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | 16-18TRN1819            | 16TR-766                 |            | 2               | 0            | 1539.96     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201811 | 16-18TRN1819            | 16TR-766                 |            | 3               | 0            | 1843.20     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | 16-18TRN1819            | 16TR-766                 |            | 2               | 0            | 1593.11     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201812 | 16-18TRN1819            | 16TR-766                 |            | 3               | 0            | 1414.53     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | 16-18TRN1819            | 16TR-766                 |            | 2               | 0            | 1586.84     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201901 | 16-18TRN1819            | 16TR-766                 |            | 3               | 0            | 2010.20     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | 16-18TRN1819            | 16TR-766                 |            | 2               | 0            | 769.26      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201902 | 16-18TRN1819            | 16TR-766                 |            | 3               | 0            | 654.61      |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | 16-18TRN1819            | 16TR-766                 |            | 2               | 0            | 2160.92     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201903 | 16-18TRN1819            | 16TR-766                 |            | 3               | 0            | 1204.95     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | 16-18TRN1819            | 16TR-766                 |            | 2               | 0            | 1034.03     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201904 | 16-18TRN1819            | 16TR-766                 |            | 3               | 0            | 2113.25     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | 16-18TRN1819            | 16TR-766                 |            | 2               | 0            | 1226.22     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201905 | 16-18TRN1819            | 16TR-766                 |            | 3               | 0            | 1485.42     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | 16-18TRN1819            | 16TR-766                 |            | 2               | 0            | 1163.52     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201906 | 16-18TRN1819            | 16TR-766                 |            | 3               | 0            | 1812.07     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | 16-18TRN1819            | 16TR-766                 |            | 2               | 0            | 2467.85     |
    | ILR1819        | R06                  | ORG0017766     | CM             | 201907 | 16-18TRN1819            | 16TR-766                 |            | 3               | 0            | 2146.28     |

    # Pull actuals from new Submit Learner Data (SLD) interface (24329)
    When  the FCT system polls the SLD service 

    # Check MonitoringDeliverables.HeldReportedActualGroup. Is the data showing as unprocessed ?
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017766' and Collection 'R06' marked as unprocessed

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-766       | 16TR-766        | 1               | 40330.00 | 5934.00  | 3261.00  | 3879.00  | 2026.00  | 1917.00  | 4209.00  | 3750.00  | 4145.00  | 2960.00  | 3799.00  | 3245.00  | 1205.00  | 
    | MAIN-766       | 16TR-766        | 2               | 19443.00 | 3024.00  | 1418.00  | 2535.00  | 168.00   | 1601.00  | 2969.00  | 2565.00  | 1813.00  | 366.00   | 1008.00  | 1047.00  | 929.00   | 
    | MAIN-766       | 16TR-766        | 3               | 20887.00 | 2910.00  | 1843.00  | 1344.00  | 1858.00  | 316.00   | 1240.00  | 1185.00  | 2332.00  | 2594.00  | 2791.00  | 2198.00  | 276.00   | 
    | MAIN-766       | APPS-766        | 1               | 64035.00 | 12281.00 | 11752.00 | 6621.00  | 13032.00 | 3200.00  | 962.00   | 2993.00  | 3319.00  | 606.00   | 1342.00  | 2835.00  | 5092.00  |

     # Check the ACTUALS in CRM. 16-18 Traineeships actuals should be present but nothing for APPS. The APPS data has been parked
    And   the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-766       | 16TR-766        | 1               | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | 16TR-766        | 2               | 8967.92  | 1926.35  | 1489.88  | 831.78   | 1539.96  | 1593.11  | 1586.84  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | 16TR-766        | 3               | 8808.31  | 1130.83  | 1545.22  | 864.33   | 1843.20  | 1414.53  | 2010.20  | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | MAIN-766       | APPS-766        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 8               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 9               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 10              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 11              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 12              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 13              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 14              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 15              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 16              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 17              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 18              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 19              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 20              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 21              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 22              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 23              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 24              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-766       | 16TR-766        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | 16TR-766        | 2               | 8967.92  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8967.92  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | 16TR-766        | 3               | 8808.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8808.31  | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
	| MAIN-766       | APPS-766        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 8               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 9               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 10              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 11              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 12              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 13              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 14              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 15              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 16              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 17              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 18              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 19              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 20              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 21              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 22              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 23              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 24              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-766       | 16TR-766        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | 16TR-766        | 2               | 8967.92  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8967.92  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | 16TR-766        | 3               | 8808.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8808.31  | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
	| MAIN-766       | APPS-766        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 8               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 9               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 10              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 11              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 12              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 13              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 14              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 15              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 16              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 17              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 18              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 19              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 20              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 21              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 22              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 23              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 24              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts in CRM are as follows
    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   |
    | MAIN-766       | 16TR-766        | 2201300                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8967.92  | 
    | MAIN-766       | 16TR-766        | 2201350                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8808.31  | 

    # Check the RECONCILIATION subnominal aggregations in PaaS for Jan 2019
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017766 | ORG0017766 | 16TR-766          | 2201300         | 16-18TRN1819               | 201901               | RECONCILIATION  | CM             | False       | 8967.92         |
    | 10017766 | ORG0017766 | 16TR-766          | 2201350         | 16-18TRN1819               | 201901               | RECONCILIATION  | CM             | False       | 8808.31         |

    # Check that MonitoringDeliverables.HeldReportedActualGroup shows the ILR-sourced APPS1819 data has not been processed
	# Unprocessed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017766' and Collection 'R06' marked as unprocessed
    And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017766' and Collection 'APPS21' marked as unprocessed
    And   there are '0' rows on table HeldReportedActualGroup for FSP '16-18TRN1819' OrgId 'ORG0017766' and Collection 'R06' marked as unprocessed
	# Processed
    And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017766' and Collection 'R06' marked as processed
    And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017766' and Collection 'APPS21' marked as processed
    And   there are '0' rows on table HeldReportedActualGroup for FSP '16-18TRN1819' OrgId 'ORG0017766' and Collection 'R06' marked as processed


    #
    # Second pull of data
    #


    # Clear down the DEDS
    Given there are no entries in the DCFS stub table 

    # Month End is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Change the date
    And   the override date is '05/02/2019'

    # Pull APPS actuals from DC for APPS21 for APPS-766 for Jan 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS21               | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |         | 8               | 0            | 1087.77     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |         | 9               | 0            | 846.79      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |         | 10              | 0            | 911.33      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |         | 22              | 0            | 505.39      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |         | 23              | 0            | 522.73      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201808 | APPS1819                | APPS-766                 |         | 24              | 0            | 1184.64     |
    #
    | APPS           | APPS21               | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |         | 8               | 0            | 119.62      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |         | 9               | 0            | 1165.02     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |         | 10              | 0            | 1240.29     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |         | 22              | 0            | 1092.66     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |         | 23              | 0            | 163.49      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201809 | APPS1819                | APPS-766                 |         | 24              | 0            | 679.64      |
    #
    | APPS           | APPS21               | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |         | 8               | 0            | 1307.67     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |         | 9               | 0            | 1206.67     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |         | 10              | 0            | 622.95      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |         | 22              | 0            | 1446.74     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |         | 23              | 0            | 1320.03     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201810 | APPS1819                | APPS-766                 |         | 24              | 0            | 178.73      |
    #
    | APPS           | APPS21               | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |         | 8               | 0            | 1429.38     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |         | 9               | 0            | 609.62      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |         | 10              | 0            | 834.82      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |         | 22              | 0            | 1173.96     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |         | 23              | 0            | 174.90      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201811 | APPS1819                | APPS-766                 |         | 24              | 0            | 929.44      |
    #
    | APPS           | APPS21               | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |         | 8               | 0            | 756.18      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |         | 9               | 0            | 517.43      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |         | 10              | 0            | 971.78      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |         | 22              | 0            | 1006.95     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |         | 23              | 0            | 469.31      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201812 | APPS1819                | APPS-766                 |         | 24              | 0            | 491.08      |
    #
    | APPS           | APPS21               | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |         | 8               | 0            | 1261.73     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |         | 9               | 0            | 1254.45     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |         | 10              | 0            | 924.83      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |         | 22              | 0            | 1480.54     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |         | 23              | 0            | 1375.35     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201901 | APPS1819                | APPS-766                 |         | 24              | 0            | 417.61      |
    #
    | APPS           | APPS21               | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |         | 8               | 0            | 1073.16     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |         | 9               | 0            | 1472.01     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |         | 10              | 0            | 441.50      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |         | 22              | 0            | 847.42      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |         | 23              | 0            | 248.91      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201902 | APPS1819                | APPS-766                 |         | 24              | 0            | 1499.19     |
    #
    | APPS           | APPS21               | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |         | 8               | 0            | 1046.65     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |         | 9               | 0            | 121.98      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |         | 10              | 0            | 905.26      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |         | 22              | 0            | 240.07      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |         | 23              | 0            | 244.23      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201903 | APPS1819                | APPS-766                 |         | 24              | 0            | 1218.44     |
    #
    | APPS           | APPS21               | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |         | 8               | 0            | 498.27      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |         | 9               | 0            | 163.90      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |         | 10              | 0            | 514.08      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |         | 22              | 0            | 634.81      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |         | 23              | 0            | 521.36      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201904 | APPS1819                | APPS-766                 |         | 24              | 0            | 1428.00     |
    #
    | APPS           | APPS21               | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |         | 8               | 0            | 1471.77     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |         | 9               | 0            | 661.92      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |         | 10              | 0            | 489.59      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |         | 22              | 0            | 324.61      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |         | 23              | 0            | 327.95      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201905 | APPS1819                | APPS-766                 |         | 24              | 0            | 1005.22     |
    #
    | APPS           | APPS21               | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |         | 8               | 0            | 674.10      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |         | 9               | 0            | 677.87      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |         | 10              | 0            | 1097.82     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |         | 22              | 0            | 556.69      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |         | 23              | 0            | 986.45      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201906 | APPS1819                | APPS-766                 |         | 24              | 0            | 390.58      |
    #
    | APPS           | APPS21               | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |         | 8               | 0            | 360.42      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |         | 9               | 0            | 916.70      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |         | 10              | 0            | 213.00      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |         | 22              | 0            | 741.16      |
    | APPS           | APPS21               | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |         | 23              | 0            | 1368.03     |
    | APPS           | APPS21               | ORG0017766     | CM             | 201907 | APPS1819                | APPS-766                 |         | 24              | 0            | 465.91      |

    # Pull actuals from new Submit Learner Data (SLD) interface (24329)
    When  the FCT system polls the SLD service

    # Check MonitoringDeliverables.HeldReportedActualGroup. Is the data showing as unprocessed ?
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017766' and Collection 'R06' marked as unprocessed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017766' and Collection 'APPS21' marked as unprocessed

    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered

    # Check the RECONCILIATION subnominal aggregations in PaaS for Jan 2019
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017766 | ORG0017766 | 16TR-766          | 2201300         | 16-18TRN1819               | 201901               | RECONCILIATION  | CM             | False       | 8967.92         |
    | 10017766 | ORG0017766 | 16TR-766          | 2201350         | 16-18TRN1819               | 201901               | RECONCILIATION  | CM             | False       | 8808.31         |
    | 10017766 | ORG0017766 | APPS-766          | 2240100         | APPS1819                   | 201901               | RECONCILIATION  | CM             | False       | 23375.53        |
    | 10017766 | ORG0017766 | APPS-766          | 2240150         | APPS1819                   | 201901               | RECONCILIATION  | CM             | False       | 11562.33        |
    | 10017766 | ORG0017766 | APPS-766          | 2240160         | APPS1819                   | 201901               | RECONCILIATION  | CM             | False       | 5506.00         |
    | 10017766 | ORG0017766 | APPS-766          | 2240170         | APPS1819                   | 201901               | RECONCILIATION  | CM             | False       | 4108.28         |
    | 10017766 | ORG0017766 | APPS-766          | 2340100         | APPS1819                   | 201901               | RECONCILIATION  | CM             | False       | 43795.42        |
    | 10017766 | ORG0017766 | APPS-766          | 2340150         | APPS1819                   | 201901               | RECONCILIATION  | CM             | False       | 10732.05        |
    | 10017766 | ORG0017766 | APPS-766          | 2340160         | APPS1819                   | 201901               | RECONCILIATION  | CM             | False       | 3881.14         |
    | 10017766 | ORG0017766 | APPS-766          | 2340170         | APPS1819                   | 201901               | RECONCILIATION  | CM             | False       | 9769.51         |

    # Check the CAPPING subnominal aggregations in PaaS for Jan 2019
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017766 | ORG0017766 | APPS-766          | 2240100         | APPS1819                   | 201901               | CAPPING         | CM             | False       | -15303.25       |
    | 10017766 | ORG0017766 | APPS-766          | 2240150         | APPS1819                   | 201901               | CAPPING         | CM             | False       | -7569.51        |
    | 10017766 | ORG0017766 | APPS-766          | 2240160         | APPS1819                   | 201901               | CAPPING         | CM             | False       | 0.00            |
    | 10017766 | ORG0017766 | APPS-766          | 2240170         | APPS1819                   | 201901               | CAPPING         | CM             | False       | 0.00            |
    | 10017766 | ORG0017766 | APPS-766          | 2340100         | APPS1819                   | 201901               | CAPPING         | CM             | False       | -28671.56       |
    | 10017766 | ORG0017766 | APPS-766          | 2340150         | APPS1819                   | 201901               | CAPPING         | CM             | False       | -7025.95        |
    | 10017766 | ORG0017766 | APPS-766          | 2340160         | APPS1819                   | 201901               | CAPPING         | CM             | False       | 0.00            |
    | 10017766 | ORG0017766 | APPS-766          | 2340170         | APPS1819                   | 201901               | CAPPING         | CM             | False       | 0.00            |

   # Check the ACTUAL VALUES in CRM
   #And   the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-766       | 16TR-766        | 1               | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | 16TR-766        | 2               | 8967.92  | 1926.35  | 1489.88  | 831.78   | 1539.96  | 1593.11  | 1586.84  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | 16TR-766        | 3               | 8808.31  | 1130.83  | 1545.22  | 864.33   | 1843.20  | 1414.53  | 2010.20  | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | MAIN-766       | APPS-766        | 1               | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 2               | 6162.61  | 841.30   | 1477.64  | 1339.28  | 1199.94  | 1061.92  | 242.53   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 3               | 4551.73  | 690.51   | 1083.77  | 580.36   | 839.01   | 325.68   | 1032.40  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 4               | 3955.74  | 1092.23  | 1318.16  | 246.35   | 561.02   | 245.63   | 492.35   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 5               | 5754.46  | 1351.59  | 919.12   | 1293.07  | 839.82   | 264.54   | 1086.32  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 6               | 2950.99  | 642.46   | 416.37   | 381.36   | 181.40   | 1134.00  | 195.40   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 7               | 4108.28  | 375.45   | 986.65   | 543.70   | 485.19   | 559.58   | 1157.71  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 8               | 5962.35  | 1087.77  | 119.62   | 1307.67  | 1429.38  | 756.18   | 1261.73  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 9               | 5599.98  | 846.79   | 1165.02  | 1206.67  | 609.62   | 517.43   | 1254.45  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 10              | 5506.00  | 911.33   | 1240.29  | 622.95   | 834.82   | 971.78   | 924.83   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 11              | 5420.74  | 922.11   | 602.23   | 1037.54  | 1000.74  | 1343.51  | 514.61   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 12              | 4455.43  | 1357.78  | 838.70   | 1425.93  | 335.84   | 322.24   | 174.94   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 13              | 5260.08  | 1086.34  | 692.16   | 1213.61  | 997.79   | 1056.94  | 213.24   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 14              | 4045.00  | 806.48   | 405.72   | 304.51   | 472.70   | 852.63   | 1202.96  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 15              | 3918.67  | 291.08   | 555.71   | 932.41   | 1078.19  | 628.75   | 432.53   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 16              | 3537.35  | 214.66   | 1096.20  | 359.43   | 333.53   | 923.31   | 610.22   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 17              | 6787.29  | 1374.23  | 1315.93  | 508.72   | 664.61   | 1433.41  | 1490.39  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 18              | 5244.59  | 1317.17  | 295.71   | 482.21   | 1442.51  | 534.32   | 1172.67  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 19              | 4676.42  | 585.91   | 151.90   | 960.19   | 1407.99  | 900.43   | 670.00   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 20              | 5694.44  | 1199.47  | 659.12   | 343.40   | 1176.51  | 1108.04  | 1207.90  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 21              | 4524.92  | 161.93   | 922.61   | 704.82   | 1388.59  | 1029.94  | 317.03   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 22              | 6706.24  | 505.39   | 1092.66  | 1446.74  | 1173.96  | 1006.95  | 1480.54  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 23              | 4025.81  | 522.73   | 163.49   | 1320.03  | 174.90   | 469.31   | 1375.35  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 24              | 3881.14  | 1184.64  | 679.64   | 178.73   | 929.44   | 491.08   | 417.61   | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-766       | 16TR-766        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | 16TR-766        | 2               | 8967.92  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8967.92  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | 16TR-766        | 3               | 8808.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8808.31  | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | MAIN-766       | APPS-766        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 2               | 6162.61  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6162.61  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 3               | 4551.73  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4551.73  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 4               | 3955.74  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3955.74  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 5               | 5754.46  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5754.46  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 6               | 2950.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2950.99  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 7               | 4108.28  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4108.28  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 8               | 5962.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5962.35  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 9               | 5599.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5599.98  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 10              | 5506.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5506.00  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 11              | 5420.74  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5420.74  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 12              | 4455.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4455.43  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 13              | 5260.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5260.08  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 14              | 4045.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4045.00  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 15              | 3918.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3918.67  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 16              | 3537.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3537.35  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 17              | 6787.29  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6787.29  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 18              | 5244.59  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5244.59  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 19              | 4676.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4676.42  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 20              | 5694.44  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5694.44  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 21              | 4524.92  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4524.92  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 22              | 6706.24  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6706.24  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 23              | 4025.81  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4025.81  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 24              | 3881.14  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3881.14  | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-766       | 16TR-766        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | 16TR-766        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | 16TR-766        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    #    
    | MAIN-766       | APPS-766        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 2               | -4034.48 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4034.48 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 3               | -2979.88 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2979.88 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 4               | -2589.70 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2589.70 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 5               | -3767.27 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -3767.27 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 6               | -1931.92 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1931.92 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 7               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 8               | -3903.37 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -3903.37 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 9               | -3666.14 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -3666.14 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 10              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 11              | -3548.80 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -3548.80 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 12              | -2916.84 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2916.84 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 13              | -3443.62 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -3443.62 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 14              | -2648.14 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2648.14 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 15              | -2565.44 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2565.44 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 16              | -2315.80 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2315.80 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 17              | -4443.43 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4443.43 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 18              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 19              | -3061.51 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -3061.51 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 20              | -3727.98 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -3727.98 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 21              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 22              | -4390.37 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4390.37 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 23              | -2635.58 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2635.58 | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 24              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-766       | 16TR-766        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | 16TR-766        | 2               | 8967.92  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8967.92  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | 16TR-766        | 3               | 8808.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8808.31  | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | MAIN-766       | APPS-766        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 2               | 2128.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2128.13  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 3               | 1571.85  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1571.85  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 4               | 1366.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1366.04  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 5               | 1987.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1987.19  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 6               | 1019.07  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1019.07  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 7               | 4108.28  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4108.28  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 8               | 2058.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2058.98  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 9               | 1933.84  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1933.84  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 10              | 5506.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5506.00  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 11              | 1871.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1871.94  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 12              | 1538.59  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1538.59  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 13              | 1816.46  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1816.46  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 14              | 1396.86  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1396.86  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 15              | 1353.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1353.23  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 16              | 1221.55  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1221.55  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 17              | 2343.86  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2343.86  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 18              | 5244.59  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5244.59  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 19              | 1614.91  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1614.91  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 20              | 1966.46  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1966.46  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 21              | 4524.92  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4524.92  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 22              | 2315.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2315.87  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 23              | 1390.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1390.23  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-766       | APPS-766        | 24              | 3881.14  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3881.14  | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts in CRM are as follows
    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19    |
    | MAIN-766       | 16TR-766        | 2201300                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8967.92   | 
    | MAIN-766       | 16TR-766        | 2201350                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8808.31   | 
    | MAIN-766       | APPS-766        | 2240100                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 23375.53  | 
    | MAIN-766       | APPS-766        | 2240150                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 11562.33  | 
    | MAIN-766       | APPS-766        | 2240160                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5506.00   | 
    | MAIN-766       | APPS-766        | 2240170                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4108.28   | 
    | MAIN-766       | APPS-766        | 2340100                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 43795.42  | 
    | MAIN-766       | APPS-766        | 2340150                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 10732.05  | 
    | MAIN-766       | APPS-766        | 2340160                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3881.14   | 
    | MAIN-766       | APPS-766        | 2340170                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 9769.51   | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | CappingSubnominal        | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19    |
    | MAIN-766       | 16TR-766        | 2201300                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-766       | 16TR-766        | 2201350                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-766       | APPS-766        | 2240100                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -15303.25 | 
    | MAIN-766       | APPS-766        | 2240150                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7569.51  | 
    | MAIN-766       | APPS-766        | 2240160                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-766       | APPS-766        | 2240170                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-766       | APPS-766        | 2340100                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -28671.56 | 
    | MAIN-766       | APPS-766        | 2340150                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7025.95  | 
    | MAIN-766       | APPS-766        | 2340160                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-766       | APPS-766        | 2340170                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 

    # All held data should now have been processed. Check MonitoringDeliverables.HeldReportedActualGroup
    Then  there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017766' and Collection 'R06' marked as unprocessed
    And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017766' and Collection 'APPS21' marked as unprocessed
    And   there are '0' rows on table HeldReportedActualGroup for FSP '16-18TRN1819' OrgId 'ORG0017766' and Collection 'R06' marked as unprocessed

    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017766' and Collection 'R06' marked as processed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017766' and Collection 'APPS21' marked as processed
    And   there are '0' rows on table HeldReportedActualGroup for FSP '16-18TRN1819' OrgId 'ORG0017766' and Collection 'R06' marked as processed

#   # Tidy up
#   Then  the override date is reset

@AcceptanceTest @Withdrawn20260521
@Long2Run @Long2Run67
Scenario: A767 Create and approve a Mainstream contract with an APPS1819 (Carry-In) allocation. Pull and park ILR-APPS data for R10. Pull an APPS25 file without data. Process ILR-APPS data. Check CRM, PaaS, Payment files\feed and HeldReportedActualGroup
    Given there is no Contract, Task or Workflow data for UKPRN '10017767' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there are no entries in the DCFS stub table 

    # Clear down the DEDS
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for this provider
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017767'

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | APPS-767      |




    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017767' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017767 Co Ltd' with UKPRN '10017767' and OrgId 'ORG0017767' and has 'FCS1 Test' as a manager 
    And   UPIN '117767' is associated with UKPRN '10017767' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017767 | 117767 | 10017767 Co Ltd | 0              | Active | Yes           | AA017767      | ?             | 




    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017767 | 10017767 Co Ltd      | ESFA-767             | MAIN-767       | 1                     | 01/08/2018        | 31/07/2019      | 26689.00      |                                | Contract for Services | 1819   | New          | ORG0017767 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName       | UoPCode    | AllocationDescription    | CRMIntent    | DeliveryOrg |
    | 10017767 | MAIN-767       | APPS-767      | APPS              | APPS1819                | AY                      | 01/08/2018          | 31/07/2019        | 26689.00        |               |            |                          | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                    | CRMIntent    | DeliveryOrg |
    | 10017767 | MAIN-767       | APPS-767      | 1               | 0                     | 26689.00  | 2817.00  | 2001.00  | 3464.00  | 2777.00  | 2120.00  | 3108.00  | 143.00   | 2619.00  | 2594.00  | 1685.00  | 712.00   | 2649.00  | Apprenticeships Carry-In Total Funding    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-767' is in a state of 'Published to Provider'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017767 | MAIN-767           | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017767 | ESFA-767           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-767' and actual ContractNumber 'MAIN-767'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-767' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017767 | MAIN-767           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017767 | ESFA-767           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract 'MAIN-767'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
	| AllocationRef | Subnominal Code | Period | Payment Type   |
	| APPS-767      | 2240100         | May-19 | Reconciliation |
	| APPS-767      | 2240150         | May-19 | Reconciliation |
	| APPS-767      | 2240160         | May-19 | Reconciliation |
	| APPS-767      | 2240170         | May-19 | Reconciliation |
	| APPS-767      | 2340100         | May-19 | Reconciliation |
	| APPS-767      | 2340150         | May-19 | Reconciliation |
	| APPS-767      | 2340160         | May-19 | Reconciliation |
	| APPS-767      | 2340170         | May-19 | Reconciliation |
	



    # Change the date
    Given the override date is '04/06/2019'

    # Clear down the MonitoringDeliverables.HeldReportedActualGroup data for specified Collection Returns
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017767'

    # Populate the DC stub with ILR actuals for May 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201808 | APPS1819                | APPS-767                 |            | 2               | 0            | 1199.30     |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201808 | APPS1819                | APPS-767                 |            | 3               | 0            | 630.46      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201808 | APPS1819                | APPS-767                 |            | 4               | 0            | 505.53      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201808 | APPS1819                | APPS-767                 |            | 20              | 0            | 702.36      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201808 | APPS1819                | APPS-767                 |            | 21              | 0            | 1049.13     |
    #
    | ILR1819        | R10                  | ORG0017767     | CM             | 201809 | APPS1819                | APPS-767                 |            | 2               | 0            | 803.44      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201809 | APPS1819                | APPS-767                 |            | 3               | 0            | 819.23      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201809 | APPS1819                | APPS-767                 |            | 4               | 0            | 748.17      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201809 | APPS1819                | APPS-767                 |            | 20              | 0            | 460.17      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201809 | APPS1819                | APPS-767                 |            | 21              | 0            | 980.25      |
    #
    | ILR1819        | R10                  | ORG0017767     | CM             | 201810 | APPS1819                | APPS-767                 |            | 2               | 0            | 858.90      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201810 | APPS1819                | APPS-767                 |            | 3               | 0            | 318.82      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201810 | APPS1819                | APPS-767                 |            | 4               | 0            | 1413.97     |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201810 | APPS1819                | APPS-767                 |            | 20              | 0            | 247.63      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201810 | APPS1819                | APPS-767                 |            | 21              | 0            | 564.37      |
    #
    | ILR1819        | R10                  | ORG0017767     | CM             | 201811 | APPS1819                | APPS-767                 |            | 2               | 0            | 279.55      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201811 | APPS1819                | APPS-767                 |            | 3               | 0            | 100.33      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201811 | APPS1819                | APPS-767                 |            | 4               | 0            | 851.51      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201811 | APPS1819                | APPS-767                 |            | 20              | 0            | 225.49      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201811 | APPS1819                | APPS-767                 |            | 21              | 0            | 1160.82     |
    #
    | ILR1819        | R10                  | ORG0017767     | CM             | 201812 | APPS1819                | APPS-767                 |            | 2               | 0            | 662.58      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201812 | APPS1819                | APPS-767                 |            | 3               | 0            | 746.62      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201812 | APPS1819                | APPS-767                 |            | 4               | 0            | 789.03      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201812 | APPS1819                | APPS-767                 |            | 20              | 0            | 1043.11     |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201812 | APPS1819                | APPS-767                 |            | 21              | 0            | 459.28      |
    #
    | ILR1819        | R10                  | ORG0017767     | CM             | 201901 | APPS1819                | APPS-767                 |            | 2               | 0            | 225.85      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201901 | APPS1819                | APPS-767                 |            | 3               | 0            | 143.33      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201901 | APPS1819                | APPS-767                 |            | 4               | 0            | 551.80      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201901 | APPS1819                | APPS-767                 |            | 20              | 0            | 1399.04     |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201901 | APPS1819                | APPS-767                 |            | 21              | 0            | 563.42      |
    #
    | ILR1819        | R10                  | ORG0017767     | CM             | 201902 | APPS1819                | APPS-767                 |            | 2               | 0            | 860.12      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201902 | APPS1819                | APPS-767                 |            | 3               | 0            | 212.96      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201902 | APPS1819                | APPS-767                 |            | 4               | 0            | 988.12      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201902 | APPS1819                | APPS-767                 |            | 20              | 0            | 583.55      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201902 | APPS1819                | APPS-767                 |            | 21              | 0            | 866.74      |
    #
    | ILR1819        | R10                  | ORG0017767     | CM             | 201903 | APPS1819                | APPS-767                 |            | 2               | 0            | 1392.14     |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201903 | APPS1819                | APPS-767                 |            | 3               | 0            | 853.55      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201903 | APPS1819                | APPS-767                 |            | 4               | 0            | 668.99      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201903 | APPS1819                | APPS-767                 |            | 20              | 0            | 1240.53     |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201903 | APPS1819                | APPS-767                 |            | 21              | 0            | 857.28      |
    #
    | ILR1819        | R10                  | ORG0017767     | CM             | 201904 | APPS1819                | APPS-767                 |            | 2               | 0            | 698.55      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201904 | APPS1819                | APPS-767                 |            | 3               | 0            | 812.70      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201904 | APPS1819                | APPS-767                 |            | 4               | 0            | 418.89      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201904 | APPS1819                | APPS-767                 |            | 20              | 0            | 1326.37     |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201904 | APPS1819                | APPS-767                 |            | 21              | 0            | 769.22      |
    #
    | ILR1819        | R10                  | ORG0017767     | CM             | 201905 | APPS1819                | APPS-767                 |            | 2               | 0            | 366.88      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201905 | APPS1819                | APPS-767                 |            | 3               | 0            | 1057.69     |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201905 | APPS1819                | APPS-767                 |            | 4               | 0            | 1146.38     |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201905 | APPS1819                | APPS-767                 |            | 20              | 0            | 261.65      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201905 | APPS1819                | APPS-767                 |            | 21              | 0            | 343.28      |
    #
    | ILR1819        | R10                  | ORG0017767     | CM             | 201906 | APPS1819                | APPS-767                 |            | 2               | 0            | 167.36      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201906 | APPS1819                | APPS-767                 |            | 3               | 0            | 1100.75     |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201906 | APPS1819                | APPS-767                 |            | 4               | 0            | 846.23      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201906 | APPS1819                | APPS-767                 |            | 20              | 0            | 703.60      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201906 | APPS1819                | APPS-767                 |            | 21              | 0            | 662.77      |
    #
    | ILR1819        | R10                  | ORG0017767     | CM             | 201907 | APPS1819                | APPS-767                 |            | 2               | 0            | 485.41      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201907 | APPS1819                | APPS-767                 |            | 3               | 0            | 1479.53     |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201907 | APPS1819                | APPS-767                 |            | 4               | 0            | 1223.63     |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201907 | APPS1819                | APPS-767                 |            | 20              | 0            | 208.75      |
    | ILR1819        | R10                  | ORG0017767     | CM             | 201907 | APPS1819                | APPS-767                 |            | 21              | 0            | 705.86      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check MonitoringDeliverables.HeldReportedActualGroup. Is the data showing as unprocessed ?
    Then there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017767' and Collection 'R10' marked as unprocessed

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-767       | APPS-767        | 1               | 26689.00 | 2817.00  | 2001.00  | 3464.00  | 2777.00  | 2120.00  | 3108.00  | 143.00   | 2619.00  | 2594.00  | 1685.00  | 712.00   | 2649.00  | 

    # Check the ACTUALS in CRM
    And   the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-767       | APPS-767        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 8               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 9               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 10              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 11              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 12              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 13              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 14              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 15              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 16              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 17              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 18              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 19              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 20              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 21              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 22              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 23              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 24              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-767       | APPS-767        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 8               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 9               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 10              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 11              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 12              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 13              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 14              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 15              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 16              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 17              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 18              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 19              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 20              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 21              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 22              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 23              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 24              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-767       | APPS-767        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 8               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 9               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 10              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 11              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 12              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 13              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 14              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 15              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 16              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 17              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 18              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 19              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 20              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 21              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 22              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 23              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 24              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualValue |
    | APPS-767         | 1             | 1               | 201808 | 2              | 0             | 2817.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 1               | 201809 | 2              | 0             | 2001.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 1               | 201810 | 2              | 0             | 3464.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 1               | 201811 | 2              | 0             | 2777.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 1               | 201812 | 2              | 0             | 2120.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 1               | 201901 | 2              | 0             | 3108.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 1               | 201902 | 2              | 0             | 143.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 1               | 201903 | 2              | 0             | 2619.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 1               | 201904 | 2              | 0             | 2594.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 1               | 201905 | 2              | 0             | 1685.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 1               | 201906 | 2              | 0             | 712.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 1               | 201907 | 2              | 0             | 2649.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 2               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 2               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 2               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 2               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 2               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 2               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 3               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 3               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 3               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 3               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 3               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 3               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 3               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 3               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 3               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 3               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 3               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 3               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 4               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 4               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 4               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 4               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 4               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 4               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 4               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 4               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 4               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 4               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 4               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 4               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 5               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 5               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 5               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 5               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 5               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 5               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 5               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 5               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 5               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 5               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 5               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 5               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 6               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 6               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 6               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 6               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 6               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 6               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 6               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 6               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 6               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 6               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 6               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 6               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 7               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 7               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 7               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 7               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 7               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 7               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 7               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 7               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 7               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 7               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 7               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 7               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 8               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 8               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 8               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 8               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 8               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 8               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 8               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 8               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 8               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 8               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 8               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 8               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 9               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 9               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 9               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 9               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 9               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 9               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 9               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 9               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 9               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 9               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 9               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 9               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 10              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 10              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 10              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 10              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 10              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 10              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 10              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 10              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 10              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 10              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 10              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 10              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 11              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 11              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 11              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 11              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 11              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 11              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 11              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 11              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 11              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 11              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 11              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 11              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 12              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 12              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 12              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 12              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 12              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 12              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 12              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 12              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 12              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 12              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 12              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 12              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 13              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 13              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 13              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 13              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 13              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 13              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 13              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 13              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 13              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 13              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 13              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 13              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 14              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 14              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 14              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 14              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 14              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 14              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 14              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 14              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 14              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 14              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 14              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 14              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 15              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 15              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 15              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 15              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 15              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 15              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 15              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 15              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 15              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 15              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 15              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 15              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 16              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 16              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 16              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 16              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 16              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 16              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 16              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 16              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 16              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 16              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 16              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 16              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 17              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 17              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 17              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 17              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 17              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 17              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 17              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 17              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 17              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 17              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 17              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 17              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 18              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 18              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 18              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 18              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 18              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 18              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 18              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 18              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 18              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 18              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 18              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 18              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 19              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 19              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 19              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 19              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 19              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 19              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 19              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 19              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 19              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 19              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 19              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 19              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 20              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 20              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 20              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 20              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 20              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 20              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 20              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 20              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 20              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 20              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 20              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 20              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 21              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 21              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 21              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 21              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 21              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 21              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 21              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 21              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 21              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 21              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 21              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 21              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 22              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 22              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 22              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 22              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 22              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 22              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 22              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 22              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 22              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 22              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 22              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 22              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 23              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 23              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 23              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 23              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 23              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 23              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 23              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 23              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 23              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 23              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 23              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 23              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | APPS-767         | 1             | 24              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 24              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 24              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 24              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 24              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 24              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 24              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 24              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 24              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 24              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 24              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-767         | 1             | 24              | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |

    # Check MonitoringDeliverables.HeldReportedActualGroup for held R10 data
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017767' and Collection 'R10' marked as unprocessed
    And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017767' and Collection 'APPS25' marked as unprocessed

    And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017767' and Collection 'R10' marked as processed
    And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017767' and Collection 'APPS25' marked as processed



    # Second pull of data 

	# Change the date
	Given the override date is '05/06/2019'

    # Clear down the stub
    And   there are no entries in the DCFS stub table 

    # Simulate a DC Collection without data for May 2019 for APPS25 (This pairs up with R10)
    And   there is a closed collection with no data for CollectionType 'APPS' and CollectionReturnCode 'APPS25'

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service   
	
    # Allow a little time for MonthEnd to start before stopping it. So ...

	# Check MonitoringDeliverables.HeldReportedActualGroup for held R10 data again 
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017767' and Collection 'R10' marked as unprocessed
 
    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When    MonthEnd processing has completed and the processing of held data is triggered

   # Check the ACTUAL VALUES in CRM
   #Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-767       | APPS-767        | 1               | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 2               | 7347.31  | 1199.30  | 803.44   | 858.90   | 279.55   | 662.58   | 225.85   | 860.12   | 1392.14  | 698.55   | 366.88   | ?        | ?        | 
    | MAIN-767       | APPS-767        | 3               | 5695.69  | 630.46   | 819.23   | 318.82   | 100.33   | 746.62   | 143.33   | 212.96   | 853.55   | 812.70   | 1057.69  | ?        | ?        | 
    | MAIN-767       | APPS-767        | 4               | 8082.39  | 505.53   | 748.17   | 1413.97  | 851.51   | 789.03   | 551.80   | 988.12   | 668.99   | 418.89   | 1146.38  | ?        | ?        | 
    | MAIN-767       | APPS-767        | 5               | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 6               | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 7               | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 8               | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 9               | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 10              | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 11              | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 12              | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 13              | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 14              | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 15              | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 16              | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 17              | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 18              | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 19              | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 20              | 7489.90  | 702.36   | 460.17   | 247.63   | 225.49   | 1043.11  | 1399.04  | 583.55   | 1240.53  | 1326.37  | 261.65   | ?        | ?        | 
    | MAIN-767       | APPS-767        | 21              | 7613.79  | 1049.13  | 980.25   | 564.37   | 1160.82  | 459.28   | 563.42   | 866.74   | 857.28   | 769.22   | 343.28   | ?        | ?        | 
    | MAIN-767       | APPS-767        | 22              | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 23              | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 
    | MAIN-767       | APPS-767        | 24              | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-767       | APPS-767        | 2               | 7347.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7347.31  | ?        | ?        | 
    | MAIN-767       | APPS-767        | 3               | 5695.69  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5695.69  | ?        | ?        | 
    | MAIN-767       | APPS-767        | 4               | 8082.39  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8082.39  | ?        | ?        | 
    | MAIN-767       | APPS-767        | 20              | 7489.90  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7489.90  | ?        | ?        | 
    | MAIN-767       | APPS-767        | 21              | 7613.79  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7613.79  | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-767       | APPS-767        | 2               | -2782.70 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2782.70 | ?        | ?        | 
    | MAIN-767       | APPS-767        | 3               | -1694.50 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1694.50 | ?        | ?        | 
    | MAIN-767       | APPS-767        | 4               | -2886.90 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2886.90 | ?        | ?        | 
    | MAIN-767       | APPS-767        | 20              | -2614.37 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2614.37 | ?        | ?        | 
    | MAIN-767       | APPS-767        | 21              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-767       | APPS-767        | 2               | 4564.61  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4564.61  | ?        | ?        | 
    | MAIN-767       | APPS-767        | 3               | 4001.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4001.19  | ?        | ?        | 
    | MAIN-767       | APPS-767        | 4               | 5195.49  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5195.49  | ?        | ?        | 
    | MAIN-767       | APPS-767        | 20              | 4875.53  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4875.53  | ?        | ?        | 
    | MAIN-767       | APPS-767        | 21              | 7613.79  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7613.79  | ?        | ?        | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts in CRM are as follows
    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   |
    | MAIN-767       | APPS-767        | 2240100                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 21125.39 | 
    | MAIN-767       | APPS-767        | 2240150                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-767       | APPS-767        | 2240160                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-767       | APPS-767        | 2240170                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-767       | APPS-767        | 2340100                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7489.90  | 
    | MAIN-767       | APPS-767        | 2340150                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-767       | APPS-767        | 2340160                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-767       | APPS-767        | 2340170                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7613.79  | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | CappingSubnominal        | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   |
    | MAIN-767       | APPS-767        | 2240100                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7364.10 | 
    | MAIN-767       | APPS-767        | 2240150                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-767       | APPS-767        | 2240160                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-767       | APPS-767        | 2240170                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-767       | APPS-767        | 2340100                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2614.37 | 
    | MAIN-767       | APPS-767        | 2340150                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-767       | APPS-767        | 2340160                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-767       | APPS-767        | 2340170                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION subnominal aggregations in PaaS for May 2019
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017767 | ORG0017767 | APPS-767          | 2240100         | APPS1819                   | 201905               | RECONCILIATION  | CM             | False       | 21125.39        |
    | 10017767 | ORG0017767 | APPS-767          | 2240150         | APPS1819                   | 201905               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017767 | ORG0017767 | APPS-767          | 2240160         | APPS1819                   | 201905               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017767 | ORG0017767 | APPS-767          | 2240170         | APPS1819                   | 201905               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017767 | ORG0017767 | APPS-767          | 2340100         | APPS1819                   | 201905               | RECONCILIATION  | CM             | False       | 7489.90         |
    | 10017767 | ORG0017767 | APPS-767          | 2340150         | APPS1819                   | 201905               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017767 | ORG0017767 | APPS-767          | 2340160         | APPS1819                   | 201905               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017767 | ORG0017767 | APPS-767          | 2340170         | APPS1819                   | 201905               | RECONCILIATION  | CM             | False       | 7613.79         |

    # Check the CAPPING subnominal aggregations in PaaS for May 2019
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017767 | ORG0017767 | APPS-767          | 2240100         | APPS1819                   | 201905               | CAPPING         | CM             | False       | -7364.10        |
    | 10017767 | ORG0017767 | APPS-767          | 2240150         | APPS1819                   | 201905               | CAPPING         | CM             | False       | 0.00            |
    | 10017767 | ORG0017767 | APPS-767          | 2240160         | APPS1819                   | 201905               | CAPPING         | CM             | False       | 0.00            |
    | 10017767 | ORG0017767 | APPS-767          | 2240170         | APPS1819                   | 201905               | CAPPING         | CM             | False       | 0.00            |
    | 10017767 | ORG0017767 | APPS-767          | 2340100         | APPS1819                   | 201905               | CAPPING         | CM             | False       | -2614.37        |
    | 10017767 | ORG0017767 | APPS-767          | 2340150         | APPS1819                   | 201905               | CAPPING         | CM             | False       | 0.00            |
    | 10017767 | ORG0017767 | APPS-767          | 2340160         | APPS1819                   | 201905               | CAPPING         | CM             | False       | 0.00            |
    | 10017767 | ORG0017767 | APPS-767          | 2340170         | APPS1819                   | 201905               | CAPPING         | CM             | False       | 0.00            |

   # Check MonitoringDeliverables.HeldReportedActualGroup after R10 data and the null file have been processed
   Then  there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017767' and Collection 'R10' marked as unprocessed
   And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017767' and Collection 'APPS25' marked as unprocessed

   And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017767' and Collection 'R10' marked as processed
   And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017767' and Collection 'APPS25' marked as processed


   # Tidy up
   And   the override date is reset
        
