Feature: NCS_1819

@DoNotRun_7Mar2024
@Story23961
Scenario: D075 NCS-C1819 #1
    Given there is no payment schedule data for contract 'NCS-7575' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 75123456 | NCS-7575       | NCSC-7575     | NCS-C             | NCS-C1819               | NCS                     | 01/10/2018          | 31/03/2019        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 1               | 0                     | 383333.00  | 383333.00  | 383333.00  | 383333.00  | 383333.00  | 583335.00  | 
    | NCS-7575       | NCSC-7575     | 2               | 1                     | 183333.00  | 183333.00  | 183333.00  | 183333.00  | 183333.00  | 183335.00  | 
    | NCS-7575       | NCSC-7575     | 3               | 1                     | 200000.00  | 200000.00  | 200000.00  | 200000.00  | 200000.00  | 400000.00  | 
    | NCS-7575       | NCSC-7575     | 4               | 3                     | 50000.00   | 50000.00   | 50000.00   | 50000.00   | 50000.00   | 100000.00  | 
    | NCS-7575       | NCSC-7575     | 5               | 3                     | 150000.00  | 150000.00  | 150000.00  | 150000.00  | 150000.00  | 300000.00  | 
    | NCS-7575       | NCSC-7575     | 6               | 0                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 


    # Change the date
    And   the override date is '12/11/2018'

    When  The following Summarised Actuals for period 'N07' for collection type 'NCS1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | ?          | ?          | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | ?          | ?          | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | ?          | ?          | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | ?          | ?          | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 0.00       | ?          | ?          | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 0.00       | ?          | ?          | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 0.00       | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | ?          | ?          | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | ?          | ?          | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | ?          | ?          | ?          | ?          | ?          | 


    # Change the date
    And   the override date is '12/12/2018'

    When  The following Summarised Actuals for period 'N08' for collection type 'NCS1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 600000.00  | ?          | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | ?          | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 600000.00  | ?          | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | ?          | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 0.00       | -100000.00 | ?          | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 0.00       | 0.00       | ?          | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 0.00       | 0.00       | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 500000.00  | ?          | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | ?          | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | ?          | ?          | ?          | ?          | 


    # Change the date
    And   the override date is '11/01/2019'

    When  The following Summarised Actuals for period 'N09' for collection type 'NCS1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 200000.00  | 250000.00  | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | 550000.00  | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | 0.00       | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 600000.00  | -50000.00  | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | 550000.00  | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | 0.00       | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 0.00       | -100000.00 | 0.00       | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 0.00       | 0.00       | -74193.55  | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 0.00       | 0.00       | -25806.45  | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 500000.00  | -50000.00  | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | 475806.45  | ?          | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | -25806.45  | ?          | ?          | ?          | 


    # Change the date
    And   the override date is '12/02/2019'

    When  The following Summarised Actuals for period 'N10' for collection type 'NCS1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 200000.00  | 250000.00  | 0.00       | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | 440000.00  | 0.00       | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | 0.00       | 0.00       | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 600000.00  | -50000.00  | 0.00       | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | 550000.00  | -35806.45  | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | 0.00       | 25806.45   | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 0.00       | -100000.00 | 0.00       | 0.00       | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 0.00       | 0.00       | -74193.55  | 0.00       | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 0.00       | 0.00       | -25806.45  | 0.00       | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 500000.00  | -50000.00  | 0.00       | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | 475806.45  | -35806.45  | ?          | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | -25806.45  | 25806.45   | ?          | ?          | 


    # Change the date
    And   the override date is '12/03/2019'

    When  The following Summarised Actuals for period 'N11' for collection type 'NCS1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 200000.00  | 250000.00  | 0.00       | 50000.01   | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | 440000.00  | 0.00       | 5000.00    | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | 0.00       | 0.00       | 5000.00    | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 600000.00  | -50000.00  | 0.00       | 50000.01   | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | 550000.00  | -35806.45  | 5000.00    | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | 0.00       | 25806.45   | 5000.00    | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 0.00       | -100000.00 | 0.00       | 0.00       | -0.01      | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 0.00       | 0.00       | -74193.55  | 0.00       | -36034.48  | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 0.00       | 0.00       | -25806.45  | 0.00       | -13965.52  | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 500000.00  | -50000.00  | 0.00       | 50000.00   | ?          | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | 475806.45  | -35806.45  | -31034.48  | ?          | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | -25806.45  | 25806.45   | -8965.52   | ?          | 


    # Change the date
    And   the override date is '01/04/2019'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 1               | 0                     | 560000.00  | 560000.00  | 560000.00  | 560000.00  | 560000.00  | 560000.00  | 
    | NCS-7575       | NCSC-7575     | 2               | 1                     | 160000.00  | 160000.00  | 160000.00  | 160000.00  | 160000.00  | 160000.00  | 
    | NCS-7575       | NCSC-7575     | 3               | 1                     | 400000.00  | 400000.00  | 400000.00  | 400000.00  | 400000.00  | 400000.00  | 
    | NCS-7575       | NCSC-7575     | 4               | 3                     | 300000.00  | 300000.00  | 300000.00  | 300000.00  | 300000.00  | 300000.00  | 
    | NCS-7575       | NCSC-7575     | 5               | 3                     | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 
    | NCS-7575       | NCSC-7575     | 6               | 0                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 600000.00  | -50000.00  | 0.00       | 50000.01   | 0.01       | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | 550000.00  | -35806.45  | 5000.00    | 36034.48   | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | 0.00       | 25806.45   | 5000.00    | 13965.52   | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 0.00       | -100000.00 | 0.00       | 0.00       | -0.01      | -140000.01 | 
    | NCS-7575       | NCSC-7575     | 4               | 0.00       | 0.00       | -74193.55  | 0.00       | -36034.48  | 0.00       | 
    | NCS-7575       | NCSC-7575     | 5               | 0.00       | 0.00       | -25806.45  | 0.00       | -13965.52  | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 500000.00  | -50000.00  | 0.00       | 50000.00   | -140000.00 | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | 475806.45  | -35806.45  | -31034.48  | 36034.48   | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | -25806.45  | 25806.45   | -8965.52   | 13965.52   | 


    # Change the date
    And   the override date is '02/04/2019'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 1               | 0                     | 421666.00  | 421666.00  | 421666.00  | 421666.00  | 421666.00  | 421666.00  | 
    | NCS-7575       | NCSC-7575     | 2               | 1                     | 186666.00  | 186666.00  | 186666.00  | 186666.00  | 186666.00  | 186666.00  | 
    | NCS-7575       | NCSC-7575     | 3               | 1                     | 235000.00  | 235000.00  | 235000.00  | 235000.00  | 235000.00  | 235000.00  | 
    | NCS-7575       | NCSC-7575     | 4               | 3                     | 166666.00  | 166666.00  | 166666.00  | 166666.00  | 166666.00  | 166666.00  | 
    | NCS-7575       | NCSC-7575     | 5               | 3                     | 68334.00   | 68334.00   | 68334.00   | 68334.00   | 68334.00   | 68334.00   | 
    | NCS-7575       | NCSC-7575     | 6               | 0                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 600000.00  | -50000.00  | 0.00       | 50000.01   | 0.01       | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | 550000.00  | -35806.45  | 5000.00    | 36034.48   | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | 0.00       | 25806.45   | 5000.00    | 13965.52   | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 0.00       | -100000.00 | 0.00       | 0.00       | -0.01      | 0.00       | 
    | NCS-7575       | NCSC-7575     | 4               | 0.00       | 0.00       | -74193.55  | 0.00       | -36034.48  | -14416.68  | 
    | NCS-7575       | NCSC-7575     | 5               | 0.00       | 0.00       | -25806.45  | 0.00       | -13965.52  | -5587.33   | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 500000.00  | -50000.00  | 0.00       | 50000.00   | 0.01       | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | 475806.45  | -35806.45  | -31034.48  | 21617.80   | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | -25806.45  | 25806.45   | -8965.52   | 8378.19    | 


    # Change the date
    And   the override date is '10/04/2019'

    When  The following Summarised Actuals for period 'N12' for collection type 'NCS1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 93334.01   | 93334.01   | 93334.01   | 93334.01   | 93334.01   | 93334.01   | 
    | NCS-7575       | NCSC-7575     | 4               | 83334.01   | 83334.01   | 83334.01   | 83334.01   | 83334.01   | 83334.01   | 
    | NCS-7575       | NCSC-7575     | 5               | 34168.01   | 34168.01   | 34168.01   | 34168.01   | 34168.01   | 34168.01   | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 600000.00  | -50000.00  | 0.00       | 50000.01   | -539995.94 | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | 550000.00  | -35806.45  | 5000.00    | -508961.46 | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | 0.00       | 25806.45   | 5000.00    | -186026.42 | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 0.00       | -100000.00 | 0.00       | 0.00       | -0.01      | 0.00       | 
    | NCS-7575       | NCSC-7575     | 4               | 0.00       | 0.00       | -74193.55  | 0.00       | -36034.48  | 0.00       | 
    | NCS-7575       | NCSC-7575     | 5               | 0.00       | 0.00       | -25806.45  | 0.00       | -13965.52  | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7575       | NCSC-7575     | 2               | 600000.00  | 500000.00  | -50000.00  | 0.00       | 50000.00   | -539995.94 | 
    | NCS-7575       | NCSC-7575     | 4               | 100000.00  | 500000.00  | 475806.45  | -35806.45  | -31034.48  | -508961.46 | 
    | NCS-7575       | NCSC-7575     | 5               | 200000.00  | 200000.00  | -25806.45  | 25806.45   | -8965.52   | -186026.42 | 

    And   the override date is reset

@DoNotRun_7Mar2024
@Story23961
Scenario: D076 NCS-C1819 #2
    Given there is no payment schedule data for contract 'NCS-7676' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 76123456 | NCS-7676       | NCSC-7676     | NCS-C             | NCS-C1819               | NCS                     | 01/10/2018          | 31/03/2019        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 1               | 0                     | 6000.00    | 6000.00    | 6000.00    | 6000.00    | 6000.00    | 6000.00    | 
    | NCS-7676       | NCSC-7676     | 2               | 1                     | 2000.00    | 2000.00    | 2000.00    | 2000.00    | 2000.00    | 2000.00    | 
    | NCS-7676       | NCSC-7676     | 3               | 1                     | 4000.00    | 4000.00    | 4000.00    | 4000.00    | 4000.00    | 4000.00    | 
    | NCS-7676       | NCSC-7676     | 4               | 3                     | 3000.00    | 3000.00    | 3000.00    | 3000.00    | 3000.00    | 3000.00    | 
    | NCS-7676       | NCSC-7676     | 5               | 3                     | 1000.00    | 1000.00    | 1000.00    | 1000.00    | 1000.00    | 1000.00    | 
    | NCS-7676       | NCSC-7676     | 6               | 0                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 


    # Change the date
    And   the override date is '12/11/2018'

    When  The following Summarised Actuals for period 'N07' for collection type 'NCS1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 9000.00    | ?          | ?          | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 13000.00   | ?          | ?          | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 4500.00    | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 9000.00    | ?          | ?          | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 13000.00   | ?          | ?          | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 4500.00    | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 0.00       | ?          | ?          | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 0.00       | ?          | ?          | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 0.00       | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 9000.00    | ?          | ?          | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 13000.00   | ?          | ?          | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 4500.00    | ?          | ?          | ?          | ?          | ?          | 


    # Change the date
    And   the override date is '12/12/2018'

    When  The following Summarised Actuals for period 'N08' for collection type 'NCS1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 9000.00    | 8000.00    | ?          | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 13000.00   | 6000.00    | ?          | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 4500.00    | 2000.00    | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 9000.00    | 8000.00    | ?          | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 13000.00   | 6000.00    | ?          | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 4500.00    | 2000.00    | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 0.00       | -5000.00   | ?          | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 0.00       | -1117.65   | ?          | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 0.00       | -382.35    | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 9000.00    | 3000.00    | ?          | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 13000.00   | 4882.35    | ?          | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 4500.00    | 1617.65    | ?          | ?          | ?          | ?          | 


    # Change the date
    And   the override date is '01/01/2019'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 1               | 0                     | 8500.00    | 6000.00    | 6000.00    | 6000.00    | 6000.00    | 6000.00    | 
    | NCS-7676       | NCSC-7676     | 2               | 1                     | 2000.00    | 2000.00    | 2000.00    | 2000.00    | 2000.00    | 2000.00    | 
    | NCS-7676       | NCSC-7676     | 3               | 1                     | 6500.00    | 4000.00    | 4000.00    | 4000.00    | 4000.00    | 4000.00    | 
    | NCS-7676       | NCSC-7676     | 4               | 3                     | 4500.00    | 3000.00    | 3000.00    | 3000.00    | 3000.00    | 3000.00    | 
    | NCS-7676       | NCSC-7676     | 5               | 3                     | 2000.00    | 1000.00    | 1000.00    | 1000.00    | 1000.00    | 1000.00    | 
    | NCS-7676       | NCSC-7676     | 6               | 0                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 9000.00    | 8000.00    | 5000.00    | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 13000.00   | 6000.00    | 1117.65    | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 4500.00    | 2000.00    | 382.35     | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 0.00       | -5000.00   | -5000.00   | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 0.00       | -1117.65   | 0.00       | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 0.00       | -382.35    | 0.00       | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 9000.00    | 3000.00    | 0.00       | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 13000.00   | 4882.35    | 1117.65    | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 4500.00    | 1617.65    | 382.35     | ?          | ?          | ?          | 


    # Change the date
    And   the override date is '02/01/2019'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 1               | 0                     | 13000.00   | 6000.00    | 6000.00    | 6000.00    | 6000.00    | 6000.00    | 
    | NCS-7676       | NCSC-7676     | 2               | 1                     | 9000.00    | 2000.00    | 2000.00    | 2000.00    | 2000.00    | 2000.00    | 
    | NCS-7676       | NCSC-7676     | 3               | 1                     | 4000.00    | 4000.00    | 4000.00    | 4000.00    | 4000.00    | 4000.00    | 
    | NCS-7676       | NCSC-7676     | 4               | 3                     | 3000.00    | 3000.00    | 3000.00    | 3000.00    | 3000.00    | 3000.00    | 
    | NCS-7676       | NCSC-7676     | 5               | 3                     | 1000.00    | 1000.00    | 1000.00    | 1000.00    | 1000.00    | 1000.00    | 
    | NCS-7676       | NCSC-7676     | 6               | 0                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 9000.00    | 8000.00    | 5000.00    | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 13000.00   | 6000.00    | 1117.65    | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 4500.00    | 2000.00    | 382.35     | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 0.00       | -5000.00   | 0.00       | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 0.00       | -1117.65   | 0.00       | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 0.00       | -382.35    | 0.00       | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 9000.00    | 3000.00    | 5000.00    | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 13000.00   | 4882.35    | 1117.65    | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 4500.00    | 1617.65    | 382.35     | ?          | ?          | ?          | 


    # Change the date
    And   the override date is '03/01/2019'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 1               | 0                     | 15500.00   | 6000.00    | 6000.00    | 6000.00    | 6000.00    | 6000.00    | 
    | NCS-7676       | NCSC-7676     | 2               | 1                     | 9000.00    | 2000.00    | 2000.00    | 2000.00    | 2000.00    | 2000.00    | 
    | NCS-7676       | NCSC-7676     | 3               | 1                     | 6500.00    | 4000.00    | 4000.00    | 4000.00    | 4000.00    | 4000.00    | 
    | NCS-7676       | NCSC-7676     | 4               | 3                     | 4500.00    | 3000.00    | 3000.00    | 3000.00    | 3000.00    | 3000.00    | 
    | NCS-7676       | NCSC-7676     | 5               | 3                     | 2000.00    | 1000.00    | 1000.00    | 1000.00    | 1000.00    | 1000.00    | 
    | NCS-7676       | NCSC-7676     | 6               | 0                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 9000.00    | 8000.00    | 5000.00    | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 13000.00   | 6000.00    | 1117.65    | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 4500.00    | 2000.00    | 382.35     | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 0.00       | -5000.00   | 0.00       | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 0.00       | -1117.65   | 0.00       | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 0.00       | -382.35    | 0.00       | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NCS-7676       | NCSC-7676     | 2               | 9000.00    | 3000.00    | 5000.00    | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 4               | 13000.00   | 4882.35    | 1117.65    | ?          | ?          | ?          | 
    | NCS-7676       | NCSC-7676     | 5               | 4500.00    | 1617.65    | 382.35     | ?          | ?          | ?          | 

    And   the override date is reset

