Feature: Rollover1819_OPAtests 22878 

@IntegrationTest
Scenario: D069 16-18TRN1819 - FY and Alloc-level
    Given there is no payment schedule data for contract 'MAIN-6969' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 69123456 | MAIN-6969      | 16TR-6969     | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2018          | 31/07/2019        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-6969      | 16TR-6969     | 1               | 0                     | 300.00   | 300.00   | 300.00   | 300.00   | 300.00   | 300.00   | 300.00   | 300.00   | 150.00   | 150.00   | 150.00   | 150.00   |
    | MAIN-6969      | 16TR-6969     | 2               | 1                     | 100.00   | 100.00   | 100.00   | 100.00   | 100.00   | 100.00   | 100.00   | 100.00   | 50.00    | 50.00    | 50.00    | 50.00    |
    | MAIN-6969      | 16TR-6969     | 3               | 1                     | 200.00   | 200.00   | 200.00   | 200.00   | 200.00   | 200.00   | 200.00   | 200.00   | 100.00   | 100.00   | 100.00   | 100.00   |


    # Change the date
    And   the override date is '06/09/2018'

    When  The following Summarised Actuals for period 'R01' for collection type 'ILR1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-6969      | 16TR-6969     | 2               | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-6969      | 16TR-6969     | 3               | 1800.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-6969      | 16TR-6969     | 2               | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-6969      | 16TR-6969     | 3               | 1800.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-6969      | 16TR-6969     | 2               | -28.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-6969      | 16TR-6969     | 3               | -72.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-6969      | 16TR-6969     | 2               | 672.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-6969      | 16TR-6969     | 3               | 1728.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |


    # Change the date
    And   the override date is '07/05/2019'

    When  The following Summarised Actuals for period 'R09' for collection type 'ILR1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-6969      | 16TR-6969     | 2               | 110.00   | 110.00   | 110.00   | 110.00   | 110.00   | 110.00   | 110.00   | 110.00   | 400.00   | ?        | ?        | ?        |
    | MAIN-6969      | 16TR-6969     | 3               | 180.00   | 180.00   | 180.00   | 180.00   | 180.00   | 180.00   | 180.00   | 180.00   | 300.00   | ?        | ?        | ?        |

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-6969      | 16TR-6969     | 2               | 700.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 608.00   | ?        | ?        | ?        |
    | MAIN-6969      | 16TR-6969     | 3               | 1800.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12.00    | ?        | ?        | ?        |

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-6969      | 16TR-6969     | 2               | -28.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -57.14   | ?        | ?        | ?        |
    | MAIN-6969      | 16TR-6969     | 3               | -72.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -42.86   | ?        | ?        | ?        |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-6969      | 16TR-6969     | 2               | 672.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 550.86   | ?        | ?        | ?        |
    | MAIN-6969      | 16TR-6969     | 3               | 1728.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -30.86   | ?        | ?        | ?        |

    And   the override date is reset

@DoNotRun_7Mar2024
Scenario: D070 AEB-TOL1819 - FY and Alloc-level
    Given there is no payment schedule data for contract 'AEBP-7070' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 70123456 | AEBP-7070      | AEBT-7070     | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-7070      | AEBT-7070     | 1               | 0                     | 1000.00  | 1000.00  | 1000.00  | 1000.00  | 1000.00  | 1000.00  | 1000.00  | 1000.00  | 500.00   | 500.00   | 500.00   | 500.00   |
    | AEBP-7070      | AEBT-7070     | 2               | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 3               | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 4               | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 5               | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 6               | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    # Change the date
    And   the override date is '06/09/2018'

    When  The following Summarised Actuals for period 'R01' for collection type 'ILR1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-7070      | AEBT-7070     | 2               | 8100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 6               | 100.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-7070      | AEBT-7070     | 2               | 8100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 6               | 100.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-7070      | AEBT-7070     | 2               | -197.56  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 6               | -2.44    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-7070      | AEBT-7070     | 2               | 7902.44  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 6               | 97.56    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |


    # Change the date
    And   the override date is '07/05/2019'

    When  The following Summarised Actuals for period 'R09' for collection type 'ILR1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-7070      | AEBT-7070     | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1600.00  | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 3               | 0.00     | 380.00   | 380.00   | 380.00   | 380.00   | 380.00   | 380.00   | 380.00   | 100.00   | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 4               | 0.00     | 380.00   | 380.00   | 380.00   | 380.00   | 380.00   | 380.00   | 380.00   | 100.00   | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 5               | 0.00     | 380.00   | 380.00   | 380.00   | 380.00   | 380.00   | 380.00   | 380.00   | 100.00   | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 600.00   | ?        | ?        | ?        |

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-7070      | AEBT-7070     | 2               | 8100.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6302.44 | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2760.00  | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2760.00  | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2760.00  | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 6               | 100.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 502.44   | ?        | ?        | ?        |

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-7070      | AEBT-7070     | 2               | -197.56  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -320.00  | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -20.00   | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -20.00   | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -20.00   | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 6               | -2.44    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -120.00  | ?        | ?        | ?        |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-7070      | AEBT-7070     | 2               | 7902.44  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6622.44 | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2740.00  | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2740.00  | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2740.00  | ?        | ?        | ?        |
    | AEBP-7070      | AEBT-7070     | 6               | 97.56    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 382.44   | ?        | ?        | ?        |

    And   the override date is reset

@IntegrationTest
Scenario: D071 ALLB1819 - FY and Alloc-level
    Given there is no payment schedule data for contract 'LOANS-7171' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 71123456 | LOANS-7171     | ALLB-7171     | ALLB              | ALLB1819                | AY                      | 01/08/2018          | 31/07/2019        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-7171     | ALLB-7171     | 1               | 0                     | 100.00   | 100.00   | 100.00   | 100.00   | 100.00   | 100.00   | 100.00   | 100.00   | 50.00    | 50.00    | 50.00    | 50.00    |
    | LOANS-7171     | ALLB-7171     | 2               | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 3               | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 4               | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    # Change the date
    And   the override date is '06/09/2018'

    When  The following Summarised Actuals for period 'R01' for collection type 'ILR1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-7171     | ALLB-7171     | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 3               | 900.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-7171     | ALLB-7171     | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 3               | 900.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-7171     | ALLB-7171     | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 3               | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-7171     | ALLB-7171     | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 3               | 800.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |


    # Change the date
    And   the override date is '07/05/2019'

    When  The following Summarised Actuals for period 'R09' for collection type 'ILR1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-7171     | ALLB-7171     | 2               | 30.00    | 30.00    | 30.00    | 30.00    | 30.00    | 30.00    | 30.00    | 30.00    | 150.00   | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 3               | 30.00    | 30.00    | 30.00    | 30.00    | 30.00    | 30.00    | 30.00    | 30.00    | 0.00     | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 4               | 30.00    | 30.00    | 30.00    | 30.00    | 30.00    | 30.00    | 30.00    | 30.00    | 100.00   | ?        | ?        | ?        |

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-7171     | ALLB-7171     | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 390.00   | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 3               | 900.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -560.00  | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 340.00   | ?        | ?        | ?        |

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-7171     | ALLB-7171     | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -30.00   | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 3               | -100.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -20.00   | ?        | ?        | ?        |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-7171     | ALLB-7171     | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 360.00   | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 3               | 800.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -560.00  | ?        | ?        | ?        |
    | LOANS-7171     | ALLB-7171     | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 320.00   | ?        | ?        | ?        |

    And   the override date is reset

@DoNotRun_7Mar2024
Scenario: D072 APPS1819 - FY and Alloc-level with prioritisation
    Given there is no payment schedule data for contract 'MAIN-7272' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 72123456 | MAIN-7272      | APPS-7272     | APPS              | APPS1819                | AY                      | 01/08/2018          | 31/07/2019        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 1               | 0                     | 1000.00  | 1000.00  | 1000.00  | 1000.00  | 1000.00  | 1000.00  | 1000.00  | 1000.00  | 500.00   | 500.00   | 500.00   | 500.00   |
    | MAIN-7272      | APPS-7272     | 2               | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 0                     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
       
    # Change the date
    And   the override date is '06/09/2018'

    When  The following Summarised Actuals for period 'R01' for collection type 'ILR1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | -100.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 300.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |


    # Change the date
    And   the override date is '04/10/2018'

    When  The following Summarised Actuals for period 'R02' for collection type 'ILR1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 1000.00  | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 1000.00  | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 1000.00  | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 1000.00  | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 500.00   | 500.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 1000.00  | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 400.00   | 1600.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 400.00   | 1600.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 400.00   | 1600.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 400.00   | 1600.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 400.00   | 700.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 1000.00  | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 0.00     | -400.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 0.00     | -400.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 0.00     | -400.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 0.00     | -400.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | -100.00  | -1000.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 0.00     | -400.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 400.00   | 1200.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 400.00   | 1200.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 400.00   | 1200.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 400.00   | 1200.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 300.00   | -300.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 1000.00  | 600.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |


    # Change the date
    And   the override date is '10/10/2018'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 1               | 0                     | 1272.50  | 1272.50  | 1272.50  | 1272.50  | 1272.50  | 1272.50  | 1272.50  | 1272.50  | 500.00   | 500.00   | 500.00   | 500.00   |
    | MAIN-7272      | APPS-7272     | 2               | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 3               | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 4               | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 5               | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 6               | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 7               | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 8               | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 9               | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 10              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 11              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 12              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 13              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 14              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 15              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 16              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 17              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 18              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 19              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 20              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 21              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 22              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 23              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 24              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 400.00   | 1600.00  | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 400.00   | 1600.00  | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 400.00   | 1600.00  | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 400.00   | 1600.00  | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 400.00   | 700.00   | 1000.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 1000.00  | 1000.00  | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 0.00     | -400.00  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 0.00     | -400.00  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 0.00     | -400.00  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 0.00     | -400.00  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | -100.00  | -1000.00 | -990.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 0.00     | -400.00  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 400.00   | 1200.00  | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 400.00   | 1200.00  | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 400.00   | 1200.00  | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 400.00   | 1200.00  | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 300.00   | -300.00  | 10.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 1000.00  | 600.00   | 400.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |


    # Change the date
    And   the override date is '07/05/2019'

    When  The following Summarised Actuals for period 'R09' for collection type 'ILR1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 0.00     | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 100.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 70.00    | ?        | ?        | ?        |

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 390.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 400.00   | 1600.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 400.00   | 1600.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 400.00   | 1600.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 400.00   | 1600.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 1000.00  | 1000.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1530.00 | ?        | ?        | ?        |

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 0.00     | -400.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 0.00     | -400.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 0.00     | -400.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 0.00     | -400.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 0.00     | -400.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 390.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 400.00   | 1200.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 400.00   | 1200.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 400.00   | 1200.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 400.00   | 1200.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | ?        | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 1000.00  | 600.00   | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1530.00 | ?        | ?        | ?        |


    # Change the date
    And   the override date is '06/06/2019'

    When  The following Summarised Actuals for period 'R10' for collection type 'ILR1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 0.00     | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 50.00    | 0.00     | 0.00     | ?        | ?        |

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 390.00   | 100.00   | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | -90.00   | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 400.00   | 1600.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 400.00   | 1600.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 400.00   | 1600.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 400.00   | 1600.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | -40.00   | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | -40.00   | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 1000.00  | 1000.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1530.00 | -70.00   | ?        | ?        |

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 0.00     | -400.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 0.00     | -400.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 0.00     | -400.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 0.00     | -400.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 0.00     | -400.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 390.00   | 100.00   | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | -90.00   | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 400.00   | 1200.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 400.00   | 1200.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 400.00   | 1200.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 400.00   | 1200.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 0.00     | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | -40.00   | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | -40.00   | ?        | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 1000.00  | 600.00   | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1530.00 | -70.00   | ?        | ?        |


    # Change the date
    And   the override date is '10/06/2019'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 1               | 0                     | 100.00   | 100.00   | 100.00   | 100.00   | 100.00   | 100.00   | 100.00   | 100.00   | 50.00    | 50.00    | 50.00    | 50.00    |
    | MAIN-7272      | APPS-7272     | 2               | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 3               | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 4               | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 5               | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 6               | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 7               | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 8               | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 9               | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 10              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 11              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 12              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 13              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 14              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 15              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 16              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 17              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 18              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 19              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 20              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 21              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 22              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 23              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | MAIN-7272      | APPS-7272     | 24              | 1                     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 390.00   | 100.00   | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | -90.00   | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 400.00   | 1600.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 0.00     | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 400.00   | 1600.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 0.00     | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 400.00   | 1600.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 0.00     | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | 10.00    | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 400.00   | 1600.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 0.00     | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | -40.00   | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 400.00   | 700.00   | 1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 490.00   | -40.00   | 0.00     | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 1000.00  | 1000.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1530.00 | -70.00   | 0.00     | ?        |

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 3               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -400.00  | ?        |
    | MAIN-7272      | APPS-7272     | 4               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 5               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 6               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 0.00     | -400.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -290.00  | ?        |
    | MAIN-7272      | APPS-7272     | 8               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 9               | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 0.00     | -400.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -290.00  | ?        |
    | MAIN-7272      | APPS-7272     | 11              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 12              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 13              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 14              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 15              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 16              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 17              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 0.00     | -400.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -290.00  | ?        |
    | MAIN-7272      | APPS-7272     | 19              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 20              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 0.00     | -400.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -290.00  | ?        |
    | MAIN-7272      | APPS-7272     | 22              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -450.00  | ?        |
    | MAIN-7272      | APPS-7272     | 23              | -100.00  | -1000.00 | -990.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -10.00   | 0.00     | -450.00  | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 0.00     | -400.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -240.00  | ?        |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-7272      | APPS-7272     | 2               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 390.00   | 100.00   | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 3               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | -90.00   | -400.00  | ?        |
    | MAIN-7272      | APPS-7272     | 4               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 5               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 6               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 7               | 400.00   | 1200.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 0.00     | -290.00  | ?        |
    | MAIN-7272      | APPS-7272     | 8               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 9               | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 10              | 400.00   | 1200.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 0.00     | -290.00  | ?        |
    | MAIN-7272      | APPS-7272     | 11              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 12              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 13              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 14              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 15              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 16              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 17              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 18              | 400.00   | 1200.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 0.00     | -290.00  | ?        |
    | MAIN-7272      | APPS-7272     | 19              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 20              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | 10.00    | -500.00  | ?        |
    | MAIN-7272      | APPS-7272     | 21              | 400.00   | 1200.00  | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 0.00     | -290.00  | ?        |
    | MAIN-7272      | APPS-7272     | 22              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | -40.00   | -450.00  | ?        |
    | MAIN-7272      | APPS-7272     | 23              | 300.00   | -300.00  | 10.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 480.00   | -40.00   | -450.00  | ?        |
    | MAIN-7272      | APPS-7272     | 24              | 1000.00  | 600.00   | 400.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1530.00 | -70.00   | -240.00  | ?        |

    And   the override date is reset

