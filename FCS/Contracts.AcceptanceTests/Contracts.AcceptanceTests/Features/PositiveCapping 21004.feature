Feature: PositiveCapping 21004

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run45
Scenario: A435 Create and approve a 1718 Mainstream contract with a 16-18Apps(PoA) allocation. Consume -ve actuals in month 1 to generate a +ve cap. Persist in Paas and CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017435' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   the override date is reset 
 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16AP-435      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017435' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017435 Co Ltd' with UKPRN '10017435' and OrgId 'ORG0017435' and has 'FCS1 Test' as a manager 
    And   UPIN '117435' is associated with UKPRN '10017435' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | 
    | 10017435 | 117435 | 10017435 Co Ltd | 0              | Active |  

    # Change the date
	And   the override date is '15/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017435 | 10017435 Co Ltd      | ESFA-435             | MAIN-435       | 1                     | 01/08/2017        | 31/07/2018      | 19696.00      |                                | Contract for Services | 1718   | New          | ORG0017435 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode    | AllocationDescription | CRMIntent    |
    | 10017435 | MAIN-435       | 16AP-435      | 16-18 APPS        | 16-18APPS1718           | AY                      | 01/08/2017          | 31/07/2018        | 19696.00        |         |            |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    |
    | 10017435 | MAIN-435       | 16AP-435      | 2               | 0                     | 19696.00  | 1617.00  | 1282.00  | 567.00   | 2480.00  | 3255.00  | 1879.00  | 359.00   | 2664.00  | 1436.00  | 1643.00  | 1748.00  | 766.00   | 16-18 Apprenticeships Total Funding                             | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract 'MAIN-435' is in a state of 'Published to Provider'

    # Check the deliverable count in CRM 
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MAIN-435'

    # Change the date
	And   the override date is '18/07/2017'

	# Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-435' and actual ContractNumber 'MAIN-435'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-435' is in status 'Approved'

    # Check the deliverable count in CRM has increased to reflect the addition of monitoring deliverables 
    #Then  there are '72' deliverable period rows in CRM linked to the latest version of contract 'MAIN-435'
    And   there are '72' deliverable periods in CRM linked to the latest version of contract 'MAIN-435' and allocation '16AP-435'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
	| AllocationRef | Subnominal Code  | Period | Payment Type   |
	| 16AP-435      | 2240100          | Aug-17 | Reconciliation |
	| 16AP-435      | 2240100          | Aug-17 | Capping 		 |




    # Change the date
	Given the override date is '07/09/2017'

    # Clear down DCFS stub
    And   there are no entries in the DCFS stub table

	# Consume DCFS-format actuals
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201708 | 16-18APPS1718           | 16AP-435                 |         | 6               | 0            | -12757.09   |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201709 | 16-18APPS1718           | 16AP-435                 |         | 6               | 0            | 1595.13     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201710 | 16-18APPS1718           | 16AP-435                 |         | 6               | 0            | 3463.83     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201711 | 16-18APPS1718           | 16AP-435                 |         | 6               | 0            | 2118.66     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201712 | 16-18APPS1718           | 16AP-435                 |         | 6               | 0            | 2643.32     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201801 | 16-18APPS1718           | 16AP-435                 |         | 6               | 0            | 1036.27     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201802 | 16-18APPS1718           | 16AP-435                 |         | 6               | 0            | 3153.47     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201803 | 16-18APPS1718           | 16AP-435                 |         | 6               | 0            | 2973.11     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201804 | 16-18APPS1718           | 16AP-435                 |         | 6               | 0            | 1172.42     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201805 | 16-18APPS1718           | 16AP-435                 |         | 6               | 0            | 3034.13     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201806 | 16-18APPS1718           | 16AP-435                 |         | 6               | 0            | 1816.89     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201807 | 16-18APPS1718           | 16AP-435                 |         | 6               | 0            | 774.33      |
    #
	| ILR1718        | R01                  | ORG0017435     | CM             | 201708 | 16-18APPS1718           | 16AP-435                 |         | 7               | 0            | 23106.69    |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201709 | 16-18APPS1718           | 16AP-435                 |         | 7               | 0            | 1729.98     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201710 | 16-18APPS1718           | 16AP-435                 |         | 7               | 0            | 3445.92     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201711 | 16-18APPS1718           | 16AP-435                 |         | 7               | 0            | 150.06      |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201712 | 16-18APPS1718           | 16AP-435                 |         | 7               | 0            | 3403.57     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201801 | 16-18APPS1718           | 16AP-435                 |         | 7               | 0            | 2979.60     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201802 | 16-18APPS1718           | 16AP-435                 |         | 7               | 0            | 1038.83     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201803 | 16-18APPS1718           | 16AP-435                 |         | 7               | 0            | 758.55      |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201804 | 16-18APPS1718           | 16AP-435                 |         | 7               | 0            | 1578.95     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201805 | 16-18APPS1718           | 16AP-435                 |         | 7               | 0            | 2413.41     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201806 | 16-18APPS1718           | 16AP-435                 |         | 7               | 0            | 1019.94     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201807 | 16-18APPS1718           | 16AP-435                 |         | 7               | 0            | 3379.96     |
    #
	| ILR1718        | R01                  | ORG0017435     | CM             | 201708 | 16-18APPS1718           | 16AP-435                 |         | 8               | 0            | 0.00        |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201709 | 16-18APPS1718           | 16AP-435                 |         | 8               | 0            | 2309.19     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201710 | 16-18APPS1718           | 16AP-435                 |         | 8               | 0            | 221.64      |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201711 | 16-18APPS1718           | 16AP-435                 |         | 8               | 0            | 3070.28     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201712 | 16-18APPS1718           | 16AP-435                 |         | 8               | 0            | 238.25      |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201801 | 16-18APPS1718           | 16AP-435                 |         | 8               | 0            | 1727.14     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201802 | 16-18APPS1718           | 16AP-435                 |         | 8               | 0            | 1678.90     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201803 | 16-18APPS1718           | 16AP-435                 |         | 8               | 0            | 427.73      |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201804 | 16-18APPS1718           | 16AP-435                 |         | 8               | 0            | 390.72      |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201805 | 16-18APPS1718           | 16AP-435                 |         | 8               | 0            | 1307.60     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201806 | 16-18APPS1718           | 16AP-435                 |         | 8               | 0            | 236.27      |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201807 | 16-18APPS1718           | 16AP-435                 |         | 8               | 0            | 3371.72     |
    #
	| ILR1718        | R01                  | ORG0017435     | CM             | 201708 | 16-18APPS1718           | 16AP-435                 |         | 9               | 0            | 3472.90     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201709 | 16-18APPS1718           | 16AP-435                 |         | 9               | 0            | 2031.23     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201710 | 16-18APPS1718           | 16AP-435                 |         | 9               | 0            | 67.52       |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201711 | 16-18APPS1718           | 16AP-435                 |         | 9               | 0            | 2184.15     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201712 | 16-18APPS1718           | 16AP-435                 |         | 9               | 0            | 2629.61     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201801 | 16-18APPS1718           | 16AP-435                 |         | 9               | 0            | 1391.57     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201802 | 16-18APPS1718           | 16AP-435                 |         | 9               | 0            | 2007.55     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201803 | 16-18APPS1718           | 16AP-435                 |         | 9               | 0            | 613.41      |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201804 | 16-18APPS1718           | 16AP-435                 |         | 9               | 0            | 2356.35     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201805 | 16-18APPS1718           | 16AP-435                 |         | 9               | 0            | 780.30      |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201806 | 16-18APPS1718           | 16AP-435                 |         | 9               | 0            | 2096.98     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201807 | 16-18APPS1718           | 16AP-435                 |         | 9               | 0            | 2990.74     |
    #
	| ILR1718        | R01                  | ORG0017435     | CM             | 201708 | 16-18APPS1718           | 16AP-435                 |         | 10              | 0            | 1950.03     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201709 | 16-18APPS1718           | 16AP-435                 |         | 10              | 0            | 3384.85     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201710 | 16-18APPS1718           | 16AP-435                 |         | 10              | 0            | 1339.19     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201711 | 16-18APPS1718           | 16AP-435                 |         | 10              | 0            | 2209.13     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201712 | 16-18APPS1718           | 16AP-435                 |         | 10              | 0            | 522.23      |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201801 | 16-18APPS1718           | 16AP-435                 |         | 10              | 0            | 2598.51     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201802 | 16-18APPS1718           | 16AP-435                 |         | 10              | 0            | 2519.83     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201803 | 16-18APPS1718           | 16AP-435                 |         | 10              | 0            | 3064.79     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201804 | 16-18APPS1718           | 16AP-435                 |         | 10              | 0            | 2875.05     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201805 | 16-18APPS1718           | 16AP-435                 |         | 10              | 0            | 2343.20     |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201806 | 16-18APPS1718           | 16AP-435                 |         | 10              | 0            | 988.84      |
    | ILR1718        | R01                  | ORG0017435     | CM             | 201807 | 16-18APPS1718           | 16AP-435                 |         | 10              | 0            | 1610.97     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualValue |
    | 16AP-435         | 1             | 2               | 201708 | 2              | 0             | 1617.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 2               | 201709 | 2              | 0             | 1282.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 2               | 201710 | 2              | 0             | 567.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 2               | 201711 | 2              | 0             | 2480.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 2               | 201712 | 2              | 0             | 3255.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 2               | 201801 | 2              | 0             | 1879.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 2               | 201802 | 2              | 0             | 359.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 2               | 201803 | 2              | 0             | 2664.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 2               | 201804 | 2              | 0             | 1436.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 2               | 201805 | 2              | 0             | 1643.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 2               | 201806 | 2              | 0             | 1748.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 2               | 201807 | 2              | 0             | 766.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #
    | 16AP-435         | 1             | 6               | 201708 | 2              | 0             | 0.00         | 0.00                 | 1350.34             | 0.00                   | -12757.09                   | -11406.75        | -12757.09   |
    | 16AP-435         | 1             | 6               | 201709 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 6               | 201710 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 6               | 201711 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 6               | 201712 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 6               | 201801 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 6               | 201802 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 6               | 201803 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 6               | 201804 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 6               | 201805 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 6               | 201806 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 6               | 201807 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #
    | 16AP-435         | 1             | 7               | 201708 | 2              | 0             | 0.00         | 0.00                 | -2445.85            | 0.00                   | 23106.69                    | 20660.84         | 23106.69    |
    | 16AP-435         | 1             | 7               | 201709 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 7               | 201710 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 7               | 201711 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 7               | 201712 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 7               | 201801 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 7               | 201802 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 7               | 201803 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 7               | 201804 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 7               | 201805 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 7               | 201806 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 7               | 201807 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #
    | 16AP-435         | 1             | 8               | 201708 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0.00        |
    | 16AP-435         | 1             | 8               | 201709 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 8               | 201710 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 8               | 201711 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 8               | 201712 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 8               | 201801 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 8               | 201802 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 8               | 201803 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 8               | 201804 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 8               | 201805 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 8               | 201806 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 8               | 201807 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #
    | 16AP-435         | 1             | 9               | 201708 | 2              | 0             | 0.00         | 0.00                 | -367.61             | 0.00                   | 3472.90                     | 3105.29          | 3472.90     |
    | 16AP-435         | 1             | 9               | 201709 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 9               | 201710 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 9               | 201711 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 9               | 201712 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 9               | 201801 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 9               | 201802 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 9               | 201803 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 9               | 201804 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 9               | 201805 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 9               | 201806 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 9               | 201807 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #
    | 16AP-435         | 1             | 10              | 201708 | 2              | 0             | 0.00         | 0.00                 | -206.41             | 0.00                   | 1950.03                     | 1743.62          | 1950.03     |
    | 16AP-435         | 1             | 10              | 201709 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 10              | 201710 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 10              | 201711 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 10              | 201712 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 10              | 201801 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 10              | 201802 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 10              | 201803 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 10              | 201804 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 10              | 201805 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 10              | 201806 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-435         | 1             | 10              | 201807 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |

    # Check the ACTUALS in CRM
    And   the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-435       | 16AP-435        | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 6               | -12757.09| -12757.09| ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 7               | 23106.69 | 23106.69 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 8               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 9               | 3472.90  | 3472.90  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 10              | 1950.03  | 1950.03  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-435       | 16AP-435        | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 6               | 1350.34  | 1350.34  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 7               | -2445.85 | -2445.85 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 8               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 9               | -367.61  | -367.61  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 10              | -206.41  | -206.41  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-435       | 16AP-435        | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 6               | -12757.09| -12757.09| ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 7               | 23106.69 | 23106.69 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 8               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 9               | 3472.90  | 3472.90  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 10              | 1950.03  | 1950.03  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-435       | 16AP-435        | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 6               | -11406.75| -11406.75| ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 7               | 20660.84 | 20660.84 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 8               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 9               | 3105.29  | 3105.29  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-435       | 16AP-435        | 10              | 1743.62  | 1743.62  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-435       | 16AP-435        | 2               | 19696.00 | 1617.00  | 1282.00  | 567.00   | 2480.00  | 3255.00  | 1879.00  | 359.00   | 2664.00  | 1436.00  | 1643.00  | 1748.00  | 766.00   | 
    | MAIN-435       | 16AP-435        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-435       | 16AP-435        | 7               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-435       | 16AP-435        | 8               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-435       | 16AP-435        | 9               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-435       | 16AP-435        | 10              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017435 | ORG0017435 | 16AP-435          | 2240100         | 16-18APPS1718              | 201708               | RECONCILIATION  | CM             | False       | 15772.53        |
    | 10017435 | ORG0017435 | 16AP-435          | 2240100         | 16-18APPS1718              | 201708               | CAPPING         | CM             | False       | -1669.53        |

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts in CRM are as follows
    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Aug-17   |
    | MAIN-435       | 16AP-435        | 2240100                  | 15772.53 | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | CappingSubnominal        | Aug-17   |
    | MAIN-435       | 16AP-435        | 2240100                  | -1669.53 | 


    # Tidy up
    And   the override date is reset

