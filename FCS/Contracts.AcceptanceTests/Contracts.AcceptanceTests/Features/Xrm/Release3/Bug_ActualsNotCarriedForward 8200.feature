Feature: Bug_ActualsNotCarriedForward 8200

@AcceptanceTest @Withdrawn20200604
@PaymentScheduleTests
Scenario: A761 Process an actuals file on v1 of a 16-18Apps (PoA) allocation then vary and approve v2
    Given there is no Contract, Task or Workflow data for contract 'MAIN-761' and master contract 'SFA-761'
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16AP-761      |
 
    And   there is no Organisation data for UKPRN '10017761'
    And   the override date is reset 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Quick Witted Co' with UKPRN '10017761' and OrgId 'ORG0017761' and has 'FCS1 Test' as a manager
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017761 | Quick Witted Co      | SFA-761              | MAIN-761       | 1                     |  01/08/2016       |  31/07/2017     | 72097.00      | Contract for Services | 1617   | New          | ORG0017761 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName             | UoPCode | AllocationDescription  | CRMIntent    |
    | 10017761 | MAIN-761       | 16AP-761      | 16-18 APPS        | AY                      |  01/08/2016         |  31/07/2017       | 72097.00        |                     |         |                        | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17   | DeliverableDescription                            | CRMIntent    |
    | MAIN-761       | 16AP-761      | 1               | 0                     | 72097.00 | 6914.00  | 2618.00  | 6648.00  | 6383.00  | 3954.00  | 8161.00  | 7031.00  | 5202.00  | 6593.00  | 5954.00  | 7523.00  | 5116.00  | Total 16-18 Funding                               | New          |
    | MAIN-761       | 16AP-761      | 2               | 1                     | 21618.00 | 3066.00  | 1471.00  | 2102.00  | 2423.00  | 1569.00  | 3554.00  | 82.00    | 801.00   | 2484.00  | 1666.00  | 177.00   | 2223.00  | 16-18 Apprenticeships Total Funding               | New          |
    | MAIN-761       | 16AP-761      | 3               | 1                     | 50479.00 | 3848.00  | 1147.00  | 4546.00  | 3960.00  | 2385.00  | 4607.00  | 6949.00  | 4401.00  | 4109.00  | 4288.00  | 7346.00  | 2893.00  | 16-18 Traineeships Total Funding                  | New          |
    | MAIN-761       | 16AP-761      | 4               | 3                     | 18717.00 | 2094.00  | 209.00   | 1430.00  | 813.00   | 278.00   | 794.00   | 3262.00  | 1557.00  | 327.00   | 2800.00  | 3785.00  | 1368.00  | 16-18 Traineeships Programme Funding              | New          |
    | MAIN-761       | 16AP-761      | 5               | 3                     | 31762.00 | 1754.00  | 938.00   | 3116.00  | 3147.00  | 2107.00  | 3813.00  | 3687.00  | 2844.00  | 3782.00  | 1488.00  | 3561.00  | 1525.00  | 16-18 Traineeships Bursary Funding                | New          |

    And   the contract exists in CRM
    And   the latest version of contract 'MAIN-761' is in a state of 'Published to Provider'
    And   the override date is '14/07/2016'
    When  the latest version of contract 'MAIN-761' is approved
    Then  the status and sub-status of the latest version of contract 'MAIN-761' are changed to 'Approved'
    And   the latest version of contract 'MAIN-761' is marked as the last approved version

    And   the Profile Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17   | DeliverableDescription                              |
    | MAIN-761       | 16AP-761      | 1               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | Total 16-18 Funding                                 |
    | MAIN-761       | 16AP-761      | 2               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Apprenticeships Total Funding                 |
    | MAIN-761       | 16AP-761      | 3               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Traineeships Total Funding                    |
    | MAIN-761       | 16AP-761      | 4               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Traineeships Programme Funding                |
    | MAIN-761       | 16AP-761      | 5               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Traineeships Bursary Funding                  |
    | MAIN-761       | 16AP-761      | 6               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Apprenticeships Programme Funding             |
    | MAIN-761       | 16AP-761      | 7               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Apprenticeships Learning Support              |
    | MAIN-761       | 16AP-761      | 8               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Apprenticeships Learner Support               |
    | MAIN-761       | 16AP-761      | 9               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Trailblazer Apprenticeships Programme Funding |
    | MAIN-761       | 16AP-761      | 10              | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Trailblazer Apprenticeships Learning Support  |

    And   the Balancing Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17   |
    | MAIN-761       | 16AP-761      | 1               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 2               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 3               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 4               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 5               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 6               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 7               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 8               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 9               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 10              | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17   |
    | MAIN-761       | 16AP-761      | 1               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 2               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 3               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 4               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 5               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 6               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 7               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 8               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 9               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 10              | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    #
    # Actuals for August 2015
    #
    And   the override date is '06/09/2016'
    And   I receive Summarised Actuals from DCFS for period 'R01' for collection type 'ILR1617' as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17    |
    | MAIN-761       | 16AP-761      | 4               | 2513.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 5               | 861.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 6               | 1568.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 7               | 1209.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 8               | 355.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 9               | 111.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 10              | 1193.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |

    And   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17    |
    | MAIN-761       | 16AP-761      | 4               | 2513.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 5               | 861.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 6               | 1568.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 7               | 1209.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 8               | 355.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 9               | 111.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 10              | 1193.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17    |
    | MAIN-761       | 16AP-761      | 4               | 2513.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 5               | 861.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 6               | 1568.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 7               | 1209.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 8               | 355.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 9               | 111.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 10              | 1193.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |

    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17    |
    | MAIN-761       | 16AP-761      | 2201000                  | 1568.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 2201060                  | 1209.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 2201065                  | 355.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 2201071                  | 111.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 2201072                  | 1193.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 2201300                  | 2513.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 2201350                  | 861.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |

    And   the override date is reset

    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017761 | Quick Witted Co      | SFA-761              | MAIN-761       | 2                     |  01/08/2016       |  31/07/2017     | 69306.00      | Contract for Services | 1617   | New          | ORG0017761 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName             | UoPCode | AllocationDescription  | CRMIntent    |
    | 10017761 | MAIN-761       | 16AP-761      | 16-18 APPS        | AY                      |  01/08/2016         |  31/07/2017       | 69306.00        |                     |         |                        | Amendment    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17   | DeliverableDescription                            | CRMIntent    |
    | MAIN-761       | 16AP-761      | 1               | 0                     | 69306.00 | 7530.00  | 2887.00  | 4486.00  | 5931.00  | 7119.00  | 6238.00  | 7083.00  | 7188.00  | 7212.00  | 1371.00  | 6447.00  | 5814.00  | Total 16-18 Funding                               | Amendment    |
    | MAIN-761       | 16AP-761      | 2               | 1                     | 28353.00 | 3143.00  | 743.00   | 777.00   | 3925.00  | 3484.00  | 1548.00  | 1887.00  | 3022.00  | 3914.00  | 97.00    | 3719.00  | 2094.00  | 16-18 Apprenticeships Total Funding               | Amendment    |
    | MAIN-761       | 16AP-761      | 3               | 1                     | 40953.00 | 4387.00  | 2144.00  | 3709.00  | 2006.00  | 3635.00  | 4690.00  | 5196.00  | 4166.00  | 3298.00  | 1274.00  | 2728.00  | 3720.00  | 16-18 Traineeships Total Funding                  | Amendment    |
    | MAIN-761       | 16AP-761      | 4               | 3                     | 20176.00 | 1995.00  | 960.00   | 810.00   | 777.00   | 1072.00  | 3352.00  | 3767.00  | 2507.00  | 1086.00  | 696.00   | 571.00   | 2583.00  | 16-18 Traineeships Programme Funding              | Amendment    |
    | MAIN-761       | 16AP-761      | 5               | 3                     | 20777.00 | 2392.00  | 1184.00  | 2899.00  | 1229.00  | 2563.00  | 1338.00  | 1429.00  | 1659.00  | 2212.00  | 578.00   | 2157.00  | 1137.00  | 16-18 Traineeships Bursary Funding                | Amendment    |

    And   the amended contract exists in CRM
    And   the latest version of contract 'MAIN-761' is in a state of 'Published to Provider'
    And   the override date is '30/09/2016'
    And   the latest version of contract 'MAIN-761' is set to approved
    And   the status and sub-status of the latest version of contract 'MAIN-761' are changed to 'Approved'
    And   the latest version of contract 'MAIN-761' is marked as the last approved version

    And   the Profile Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17   | DeliverableDescription                              |
    | MAIN-761       | 16AP-761      | 1               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | Total 16-18 Funding                                 |
    | MAIN-761       | 16AP-761      | 2               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Apprenticeships Total Funding                 |
    | MAIN-761       | 16AP-761      | 3               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Traineeships Total Funding                    |
    | MAIN-761       | 16AP-761      | 4               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Traineeships Programme Funding                |
    | MAIN-761       | 16AP-761      | 5               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Traineeships Bursary Funding                  |
    | MAIN-761       | 16AP-761      | 6               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Apprenticeships Programme Funding             |
    | MAIN-761       | 16AP-761      | 7               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Apprenticeships Learning Support              |
    | MAIN-761       | 16AP-761      | 8               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Apprenticeships Learner Support               |
    | MAIN-761       | 16AP-761      | 9               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Trailblazer Apprenticeships Programme Funding |
    | MAIN-761       | 16AP-761      | 10              | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-18 Trailblazer Apprenticeships Learning Support  |

    And   the Balancing Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17   |
    | MAIN-761       | 16AP-761      | 1               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 2               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 3               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 4               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 5               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 6               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 7               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 8               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 9               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 10              | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    # The Net Payments have been brought forward from v1

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17   |
    | MAIN-761       | 16AP-761      | 1               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 3               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 4               | 2513.00  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 5               | 861.00   | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 6               | 1568.00  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 7               | 1209.00  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 8               | 355.00   | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 9               | 111.00   | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-761       | 16AP-761      | 10              | 1193.00  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    # The Reconciliation Subnominal Amounts have been brought forward from v1

    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17    |
    | MAIN-761       | 16AP-761      | 2201000                  | 1568.00  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 2201060                  | 1209.00  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 2201065                  | 355.00   | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 2201071                  | 111.00   | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 2201072                  | 1193.00  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 2201300                  | 2513.00  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | MAIN-761       | 16AP-761      | 2201350                  | 861.00   | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |

    And   the override date is reset

