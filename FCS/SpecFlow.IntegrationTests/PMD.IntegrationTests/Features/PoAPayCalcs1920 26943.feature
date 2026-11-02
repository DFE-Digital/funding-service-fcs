Feature: PoAPayCalcs1920 26943

@DoNotRun_7Mar2024
Scenario: D080 ALLB1920 - FY and Alloc-level
    Given there is no payment schedule data for contract 'EDSK-8080' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 80123456 | EDSK-8080      | ALLB-8080     | ALLB              | ALLB1920                | AY                      | 01/08/2019          | 31/07/2020        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-19     | Sep-19     | Oct-19     | Nov-19     | Dec-19     | Jan-20     | Feb-20     | Mar-20     | Apr-20     | May-20     | Jun-20     | Jul-20     | 
    | EDSK-8080      | ALLB-8080     | 1               | 0                     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 50.00      | 50.00      | 50.00      | 0.00       |  
    | EDSK-8080      | ALLB-8080     | 2               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | EDSK-8080      | ALLB-8080     | 3               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | EDSK-8080      | ALLB-8080     | 4               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 



    # Change the date
    And   the override date is '05/09/2019'
When   The following Summarised Actuals for period 'R01' for collection type 'ILR1920' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-19               | Sep-19               | Oct-19               | Nov-19               | Dec-19               | Jan-20               | Feb-20               | Mar-20               | Apr-20               | May-20               | Jun-20               | Jul-20               | 
 | EDSK-8080      | ALLB-8080     | 2               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EDSK-8080      | ALLB-8080     | 3               | 900.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EDSK-8080      | ALLB-8080     | 4               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-19               | Sep-19               | Oct-19               | Nov-19               | Dec-19               | Jan-20               | Feb-20               | Mar-20               | Apr-20               | May-20               | Jun-20               | Jul-20               | 
 | EDSK-8080      | ALLB-8080     | 2               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EDSK-8080      | ALLB-8080     | 3               | 900.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EDSK-8080      | ALLB-8080     | 4               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-19               | Sep-19               | Oct-19               | Nov-19               | Dec-19               | Jan-20               | Feb-20               | Mar-20               | Apr-20               | May-20               | Jun-20               | Jul-20               | 
 | EDSK-8080      | ALLB-8080     | 2               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EDSK-8080      | ALLB-8080     | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EDSK-8080      | ALLB-8080     | 4               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-19               | Sep-19               | Oct-19               | Nov-19               | Dec-19               | Jan-20               | Feb-20               | Mar-20               | Apr-20               | May-20               | Jun-20               | Jul-20               | 
 | EDSK-8080      | ALLB-8080     | 2               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EDSK-8080      | ALLB-8080     | 3               | 900.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EDSK-8080      | ALLB-8080     | 4               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '06/05/2020'
When   The following Summarised Actuals for period 'R09' for collection type 'ILR1920' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-19               | Sep-19               | Oct-19               | Nov-19               | Dec-19               | Jan-20               | Feb-20               | Mar-20               | Apr-20               | May-20               | Jun-20               | Jul-20               | 
 | EDSK-8080      | ALLB-8080     | 2               | 60.00                | 30.00                | 30.00                | 30.00                | 30.00                | 30.00                | 30.00                | 30.00                | 130.00               | ?                    | ?                    | ?                    | 
 | EDSK-8080      | ALLB-8080     | 3               | 30.00                | 30.00                | 30.00                | 30.00                | 30.00                | 30.00                | 30.00                | 30.00                | 10.00                | ?                    | ?                    | ?                    | 
 | EDSK-8080      | ALLB-8080     | 4               | 30.00                | 30.00                | 30.00                | 30.00                | 30.00                | 30.00                | 30.00                | 30.00                | 110.00               | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-19               | Sep-19               | Oct-19               | Nov-19               | Dec-19               | Jan-20               | Feb-20               | Mar-20               | Apr-20               | May-20               | Jun-20               | Jul-20               | 
 | EDSK-8080      | ALLB-8080     | 2               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 400.00               | ?                    | ?                    | ?                    | 
 | EDSK-8080      | ALLB-8080     | 3               | 900.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -650.00              | ?                    | ?                    | ?                    | 
 | EDSK-8080      | ALLB-8080     | 4               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 350.00               | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-19               | Sep-19               | Oct-19               | Nov-19               | Dec-19               | Jan-20               | Feb-20               | Mar-20               | Apr-20               | May-20               | Jun-20               | Jul-20               | 
 | EDSK-8080      | ALLB-8080     | 2               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -20.00               | ?                    | ?                    | ?                    | 
 | EDSK-8080      | ALLB-8080     | 3               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -12.50               | ?                    | ?                    | ?                    | 
 | EDSK-8080      | ALLB-8080     | 4               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -17.50               | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-19               | Sep-19               | Oct-19               | Nov-19               | Dec-19               | Jan-20               | Feb-20               | Mar-20               | Apr-20               | May-20               | Jun-20               | Jul-20               | 
 | EDSK-8080      | ALLB-8080     | 2               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 380.00               | ?                    | ?                    | ?                    | 
 | EDSK-8080      | ALLB-8080     | 3               | 900.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -662.50              | ?                    | ?                    | ?                    | 
 | EDSK-8080      | ALLB-8080     | 4               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 332.50               | ?                    | ?                    | ?                    | 
And   the override date is reset

@IntegrationTest
Scenario: D081 16-18TRN1920 - FY and Alloc-level
    Given there is no payment schedule data for contract 'EDSK-8181' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 81123456 | EDSK-8181      | 16TR-8181     | 16-18TRN          | 16-18TRN1920            | AY                      | 01/08/2019          | 31/07/2020        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-19     | Sep-19     | Oct-19     | Nov-19     | Dec-19     | Jan-20     | Feb-20     | Mar-20     | Apr-20     | May-20     | Jun-20     | Jul-20     | 
    | EDSK-8181      | 16TR-8181     | 1               | 0                     | 300.00     | 300.00     | 300.00     | 300.00     | 300.00     | 300.00     | 300.00     | 300.00     | 150.00     | 150.00     | 150.00     | 150.00     | 
    | EDSK-8181      | 16TR-8181     | 2               | 1                     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 50.00      | 50.00      | 50.00      | 50.00      | 
    | EDSK-8181      | 16TR-8181     | 3               | 1                     | 200.00     | 200.00     | 200.00     | 200.00     | 200.00     | 200.00     | 200.00     | 200.00     | 100.00     | 100.00     | 100.00     | 100.00     | 




    # Change the date
    And   the override date is '05/09/2019'

    When  The following Summarised Actuals for period 'R01' for collection type 'ILR1920' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-19     | Sep-19     | Oct-19     | Nov-19     | Dec-19     | Jan-20     | Feb-20     | Mar-20     | Apr-20     | May-20     | Jun-20     | Jul-20     | 
    | EDSK-8181      | 16TR-8181     | 2               | 700.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | EDSK-8181      | 16TR-8181     | 3               | 1800.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-19     | Sep-19     | Oct-19     | Nov-19     | Dec-19     | Jan-20     | Feb-20     | Mar-20     | Apr-20     | May-20     | Jun-20     | Jul-20     | 
    | EDSK-8181      | 16TR-8181     | 2               | 700.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | EDSK-8181      | 16TR-8181     | 3               | 1800.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-19     | Sep-19     | Oct-19     | Nov-19     | Dec-19     | Jan-20     | Feb-20     | Mar-20     | Apr-20     | May-20     | Jun-20     | Jul-20     | 
    | EDSK-8181      | 16TR-8181     | 2               | -28.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | EDSK-8181      | 16TR-8181     | 3               | -72.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-19     | Sep-19     | Oct-19     | Nov-19     | Dec-19     | Jan-20     | Feb-20     | Mar-20     | Apr-20     | May-20     | Jun-20     | Jul-20     | 
    | EDSK-8181      | 16TR-8181     | 2               | 672.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | EDSK-8181      | 16TR-8181     | 3               | 1728.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '06/05/2020'

    When  The following Summarised Actuals for period 'R09' for collection type 'ILR1920' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-19     | Sep-19     | Oct-19     | Nov-19     | Dec-19     | Jan-20     | Feb-20     | Mar-20     | Apr-20     | May-20     | Jun-20     | Jul-20     | 
    | EDSK-8181      | 16TR-8181     | 2               | 110.00     | 110.00     | 110.00     | 110.00     | 110.00     | 110.00     | 110.00     | 110.00     | 400.00     | ?          | ?          | ?          | 
    | EDSK-8181      | 16TR-8181     | 3               | 180.00     | 180.00     | 180.00     | 180.00     | 180.00     | 180.00     | 180.00     | 180.00     | 300.00     | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-19     | Sep-19     | Oct-19     | Nov-19     | Dec-19     | Jan-20     | Feb-20     | Mar-20     | Apr-20     | May-20     | Jun-20     | Jul-20     | 
    | EDSK-8181      | 16TR-8181     | 2               | 700.00     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 608.00     | ?          | ?          | ?          | 
    | EDSK-8181      | 16TR-8181     | 3               | 1800.00    | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 12.00      | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-19     | Sep-19     | Oct-19     | Nov-19     | Dec-19     | Jan-20     | Feb-20     | Mar-20     | Apr-20     | May-20     | Jun-20     | Jul-20     | 
    | EDSK-8181      | 16TR-8181     | 2               | -28.00     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -57.14     | ?          | ?          | ?          | 
    | EDSK-8181      | 16TR-8181     | 3               | -72.00     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -42.86     | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-19     | Sep-19     | Oct-19     | Nov-19     | Dec-19     | Jan-20     | Feb-20     | Mar-20     | Apr-20     | May-20     | Jun-20     | Jul-20     | 
    | EDSK-8181      | 16TR-8181     | 2               | 672.00     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 550.86     | ?          | ?          | ?          | 
    | EDSK-8181      | 16TR-8181     | 3               | 1728.00    | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -30.86     | ?          | ?          | ?          | 

    And   the override date is reset

