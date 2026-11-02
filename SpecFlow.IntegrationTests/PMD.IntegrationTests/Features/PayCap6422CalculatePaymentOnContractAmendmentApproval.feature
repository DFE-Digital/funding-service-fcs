Feature: Capping6422 Calculate payments on approval of a contract amendment where a contract allocation is PoA or externally paid 

@DoNotRun_7Mar2024
Scenario: D401a A contract containing a PoA contract allocation is approved on time. It has one capping period, and actuals have been received in R01 and cap is breached. V2 of the contract is varied to increase funding and it is approved in R02 (just before the census date and actual returns date). The cap is then re-calculated and released  
Given there is no payment schedule data for contract 'EMPAGE-1235' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 12345678 | EMPAGE-1235    | AGE-1235      | AGE               | AGE1516                 | FY                      | 01/04/2015          | 31/03/2016        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Apr-15   | May-15  | Jun-15  | Jul-15  | Aug-15  | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16  | Feb-16  | Mar-16  |
 | EMPAGE-1235    | AGE-1235      | 1               | 0                     | 1000.00  | 1100.00 | 1200.00 | 1300.00 | 1400.00 | 1500.00 | 1600.00 | 1700.00 | 1800.00 | 1900.00 | 2000.00 | 2100.00 |
 | EMPAGE-1235    | AGE-1235      | 2               | 0                     | 10000.00 | 9876.00 | 8765.00 | 7654.00 | 6543.00 | 5432.00 | 4321.00 | 3210.00 | 2099.00 | 988.00  | 988.00  | 2099.00 | 
And   the override date is '07/05/2015'
When   The following Summarised Actuals for period 'G01' for collection type 'AGE' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 23456.78 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1235    | AGE-1235      | 2               | 61974.99 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 23456.78 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1235    | AGE-1235      | 2               | 61974.99 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | -4856.78 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00     | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 18600.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1235    | AGE-1235      | 2               | 61974.99 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the override date is '08/05/2015'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Apr-15   | May-15  | Jun-15  | Jul-15  | Aug-15  | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16  | Feb-16  | Mar-16  |
 | EMPAGE-1235    | AGE-1235      | 1               | 0                     | 4757.00  | 1200.00 | 1300.00 | 1400.00 | 1500.00 | 1600.00 | 1700.00 | 1800.00 | 1900.00 | 2000.00 | 2100.00 | 2200.00 |
 | EMPAGE-1235    | AGE-1235      | 2               | 0                     | 10000.00 | 9876.00 | 8765.00 | 7654.00 | 6543.00 | 5432.00 | 4321.00 | 3210.00 | 2099.00 | 988.00  | 988.00  | 2099.00 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 23456.78 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1235    | AGE-1235      | 2               | 61974.99 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 23456.78 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1235    | AGE-1235      | 2               | 61974.99 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
And   the override date is '04/06/2015'
When   The following Summarised Actuals for period 'G02' for collection type 'AGE' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 23456.78 | 1.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1235    | AGE-1235      | 2               | 61974.99 | 2.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 23456.78 | 1.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1235    | AGE-1235      | 2               | 61974.99 | 2.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | -0.78  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | -1.99  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 23456.78 | 0.22   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1235    | AGE-1235      | 2               | 61974.99 | 0.01   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
And   the override date is reset

@DoNotRun_7Mar2024
Scenario: D403a A contract containing a PoA contract allocation is approved on time. It has two capping periods, and current period is in capping period 1. Actuals have been received and cap was not breached. V2 of the contract is varied to reduce funding and it is approved (just after the census date). The cap is then re-calculated and breached
Given there is no payment schedule data for contract 'MAIN-127' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 12345682 | MAIN-127       | ALLB-127      | 24+ ALLB          | 24+ALLB1516             | AY                      | 01/08/2015          | 31/07/2016        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15  | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16  | Feb-16  | Mar-16  | Apr-16  | May-16   | Jun-16   | Jul-16   |
 | MAIN-127       | ALLB-127      | 1               | 0                     | 1234.00 | 2234.00 | 3234.00 | 4234.00 | 5234.00 | 6234.00 | 7234.00 | 8234.00 | 9234.00 | 10234.00 | 11234.00 | 12234.00 | 
 | MAIN-127       | ALLB-127      | 2               | 0                     | ?       | ?       | ?       | ?       | ?       | ?       | ?       | ?       | ?       | ?        | ?        | ?        | 
 | MAIN-127       | ALLB-127      | 3               | 0                     | ?       | ?       | ?       | ?       | ?       | ?       | ?       | ?       | ?       | ?        | ?        | ?        | 
 | MAIN-127       | ALLB-127      | 4               | 0                     | ?       | ?       | ?       | ?       | ?       | ?       | ?       | ?       | ?       | ?        | ?        | ?        | 
And   the override date is '04/09/2015'
When   The following Summarised Actuals for period 'R01' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15   | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
 | MAIN-127       | ALLB-127      | 2               | 15111.11 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-127       | ALLB-127      | 3               | 11.11    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-127       | ALLB-127      | 4               | 22.22    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15   | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
 | MAIN-127       | ALLB-127      | 2               | 15111.11 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-127       | ALLB-127      | 3               | 11.11    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-127       | ALLB-127      | 4               | 22.22    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
 | MAIN-127       | ALLB-127      | 2               | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-127       | ALLB-127      | 3               | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-127       | ALLB-127      | 4               | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15   | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
 | MAIN-127       | ALLB-127      | 2               | 15111.11 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-127       | ALLB-127      | 3               | 11.11    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-127       | ALLB-127      | 4               | 22.22    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
And   the override date is '08/09/2015'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16  | Feb-16  | Mar-16  | Apr-16  | May-16  | Jun-16  | Jul-16  |
 | MAIN-127       | ALLB-127      | 1               | 0                     | 999.99 | 1998.98 | 1997.97 | 1996.96 | 1995.95 | 1994.94 | 1993.93 | 1992.92 | 1991.91 | 1990.90 | 1989.89 | 1988.88 |
 | MAIN-127       | ALLB-127      | 2               | 1                     | 0.00   | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    |
 | MAIN-127       | ALLB-127      | 3               | 1                     | 0.00   | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    |
 | MAIN-127       | ALLB-127      | 4               | 1                     | 0.00   | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    |

Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15   | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
 | MAIN-127       | ALLB-127      | 2               | 15111.11 | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-127       | ALLB-127      | 3               | 11.11    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-127       | ALLB-127      | 4               | 22.22    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15 | Sep-15  | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
 | MAIN-127       | ALLB-127      | 2               | 0.00   | -172.42 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-127       | ALLB-127      | 3               | 0.00   | -0.13   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-127       | ALLB-127      | 4               | 0.00   | -0.25   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15   | Sep-15  | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
 | MAIN-127       | ALLB-127      | 2               | 15111.11 | -172.42 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-127       | ALLB-127      | 3               | 11.11    | -0.13   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-127       | ALLB-127      | 4               | 22.22    | -0.25   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the override date is reset


@IntegrationTest
Scenario: D401b A contract containing a PoA contract allocation is approved on time. It has four capping periods, three are submitted and caps are breached and not breached. The contract is amended and Caps are released when the fourth set of actuals are submitted.
Given there is no payment schedule data for contract 'EMPAGE-1234' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 98765432 | EMPAGE-1234    | AGE-1234      | AGE               | AGE1516                 | FY                      | 01/04/2015          | 31/03/2016        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Apr-15               | May-15               | Jun-15               | Jul-15               | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | 
 | EMPAGE-1234    | AGE-1234      | 1               | 0                     | 10.00                | 20.00                | 30.00                | 40.00                | 50.00                | 60.00                | 70.00                | 80.00                | 90.00                | 100.00               | 110.00               | 120.00               | 
 | EMPAGE-1234    | AGE-1234      | 2               | 0                     | 100.00               | 110.00               | 120.00               | 130.00               | 140.00               | 150.00               | 160.00               | 170.00               | 180.00               | 190.00               | 200.00               | 210.00               | 
And   the override date is '07/05/2015'
When   The following Summarised Actuals for period 'G01' for collection type 'AGE' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15               | May-15               | Jun-15               | Jul-15               | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | 
 | EMPAGE-1234    | AGE-1234      | 1               | 880.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EMPAGE-1234    | AGE-1234      | 2               | 860.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15               | May-15               | Jun-15               | Jul-15               | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | 
 | EMPAGE-1234    | AGE-1234      | 1               | 880.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EMPAGE-1234    | AGE-1234      | 2               | 860.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15               | May-15               | Jun-15               | Jul-15               | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | 
 | EMPAGE-1234    | AGE-1234      | 1               | -100.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EMPAGE-1234    | AGE-1234      | 2               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15               | May-15               | Jun-15               | Jul-15               | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | 
 | EMPAGE-1234    | AGE-1234      | 1               | 780.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EMPAGE-1234    | AGE-1234      | 2               | 860.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '04/06/2015'
When   The following Summarised Actuals for period 'G02' for collection type 'AGE' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15               | May-15               | Jun-15               | Jul-15               | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | 
 | EMPAGE-1234    | AGE-1234      | 1               | 880.00               | 88.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EMPAGE-1234    | AGE-1234      | 2               | 860.00               | 100.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15               | May-15               | Jun-15               | Jul-15               | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | 
 | EMPAGE-1234    | AGE-1234      | 1               | 880.00               | 188.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EMPAGE-1234    | AGE-1234      | 2               | 860.00               | 100.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15               | May-15               | Jun-15               | Jul-15               | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | 
 | EMPAGE-1234    | AGE-1234      | 1               | -100.00              | -188.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EMPAGE-1234    | AGE-1234      | 2               | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15               | May-15               | Jun-15               | Jul-15               | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | 
 | EMPAGE-1234    | AGE-1234      | 1               | 780.00               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EMPAGE-1234    | AGE-1234      | 2               | 860.00               | 100.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '06/07/2015'
When   The following Summarised Actuals for period 'G03' for collection type 'AGE' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15               | May-15               | Jun-15               | Jul-15               | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | 
 | EMPAGE-1234    | AGE-1234      | 1               | 0.00                 | 88.00                | 100.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EMPAGE-1234    | AGE-1234      | 2               | 860.00               | 1500.00              | 150.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15  | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 880.00 | 188.00 | -592.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1234    | AGE-1234      | 2               | 860.00 | 100.00 | 1550.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15  | May-15  | Jun-15  | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | -100.00 | -188.00 | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1234    | AGE-1234      | 2               | 0.00    | 0.00    | -650.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15  | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 780.00 | 0.00   | -592.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1234    | AGE-1234      | 2               | 860.00 | 100.00 | 900.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the override date is '31/07/2015'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 0                     | 110.00 | 120.00 | 130.00 | 140.00 | 150.00 | 160.00 | 170.00 | 180.00 | 190.00 | 200.00 | 210.00 | 220.00 |
 | EMPAGE-1234    | AGE-1234      | 2               | 0                     | 200.00 | 210.00 | 220.00 | 230.00 | 240.00 | 250.00 | 260.00 | 270.00 | 280.00 | 290.00 | 300.00 | 310.00 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15  | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 880.00 | 188.00 | -592.00 | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1234    | AGE-1234      | 2               | 860.00 | 100.00 | 1550.00 | 650.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15  | May-15  | Jun-15  | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | -100.00 | -188.00 | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1234    | AGE-1234      | 2               | 0.00    | 0.00    | -650.00 | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15  | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 780.00 | 0.00   | -592.00 | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | EMPAGE-1234    | AGE-1234      | 2               | 860.00 | 100.00 | 900.00  | 650.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the override date is '06/08/2015'
When   The following Summarised Actuals for period 'G04' for collection type 'AGE' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15               | May-15               | Jun-15               | Jul-15               | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | 
 | EMPAGE-1234    | AGE-1234      | 1               | 0.00                 | 88.00                | 100.00               | 90.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EMPAGE-1234    | AGE-1234      | 2               | 860.00               | 1500.00              | 150.00               | 110.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15               | May-15               | Jun-15               | Jul-15               | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | 
 | EMPAGE-1234    | AGE-1234      | 1               | 880.00               | 188.00               | -592.00              | 90.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EMPAGE-1234    | AGE-1234      | 2               | 860.00               | 100.00               | 1550.00              | 760.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15               | May-15               | Jun-15               | Jul-15               | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | 
 | EMPAGE-1234    | AGE-1234      | 1               | -100.00              | -188.00              | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EMPAGE-1234    | AGE-1234      | 2               | 0.00                 | 0.00                 | -650.00              | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15               | May-15               | Jun-15               | Jul-15               | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | 
 | EMPAGE-1234    | AGE-1234      | 1               | 780.00               | 0.00                 | -592.00              | 90.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EMPAGE-1234    | AGE-1234      | 2               | 860.00               | 100.00               | 900.00               | 760.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is reset

##@Inprogress
@DoNotRun_7Mar2024
Scenario: D403b A contract containing a PoA contract allocation is approved on time. It has six capping periods. Actuals have been received and cap was breached. V2 of the contract is varied to reduce funding and it is approved (just after the census date). The cap is then re-calculated and re-breached
Given there is no payment schedule data for contract 'MAIN-126' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 12345678 | MAIN-126       | ALLB-126      | 24+ ALLB          | 24+ALLB1516             | AY                      | 01/08/2015          | 31/07/2016        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 1               | 0                     | 100.00               | 101.00               | 102.00               | 103.00               | 104.00               | 105.00               | 106.00               | 107.00               | 108.00               | 109.00               | 110.00               | 111.00               | 
 | MAIN-126       | ALLB-126      | 2               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '04/09/2015'
When   The following Summarised Actuals for period 'R01' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 1000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 1000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | -337.60              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | -84.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 662.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 165.60               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '06/10/2015'
When   The following Summarised Actuals for period 'R02' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 400.00               | 100.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 250.00               | 30.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 1000.00              | -162.40              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 250.00               | 114.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | -337.60              | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | -84.40               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 662.40               | -162.40              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 165.60               | 114.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '05/11/2015'
When   The following Summarised Actuals for period 'R03' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 400.00               | 100.00               | 400.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 1000.00              | -162.40              | 400.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | -20.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 250.00               | 114.40               | -280.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | -337.60              | 0.00                 | -72.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | -84.40               | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 662.40               | -162.40              | 328.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | -20.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 165.60               | 114.40               | -280.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '04/12/2015'
When   The following Summarised Actuals for period 'R04' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 400.00               | 100.00               | 400.00               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 0.00                 | 0.00                 | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 0.00                 | 0.00                 | 0.00                 | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 1000.00              | -162.40              | 400.00               | 72.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | -20.00               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 250.00               | 114.40               | -280.00              | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | -337.60              | 0.00                 | -72.00               | -367.71              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 0.00                 | 0.00                 | -102.14              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | -84.40               | 0.00                 | 0.00                 | -102.14              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 662.40               | -162.40              | 328.00               | -295.71              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | -20.00               | 147.86               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 165.60               | 114.40               | -280.00              | 147.86               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '06/05/2016'
When   The following Summarised Actuals for period 'R09' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 400.00               | 100.00               | 50.00                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 40.00                | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 0.00                 | 0.00                 | 60.00                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 41.00                | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 0.00                 | 0.00                 | 0.00                 | 70.00                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 42.00                | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 1000.00              | -162.40              | 400.00               | 72.00                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 57.71                | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | -20.00               | 250.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -46.86               | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 250.00               | 114.40               | -280.00              | 250.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -35.86               | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | -337.60              | 0.00                 | -72.00               | -367.71              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 0.00                 | 0.00                 | -102.14              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | -84.40               | 0.00                 | 0.00                 | -102.14              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 662.40               | -162.40              | 328.00               | -295.71              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 57.71                | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | -20.00               | 147.86               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -46.86               | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 165.60               | 114.40               | -280.00              | 147.86               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -35.86               | ?                    | ?                    | ?                    | 
And   the override date is '06/06/2016'
When   The following Summarised Actuals for period 'R10' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 400.00               | 100.00               | 50.00                | 0.00                 | 11.00                | 21.00                | 31.00                | 41.00                | 40.00                | 1001.00              | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 0.00                 | 0.00                 | 60.00                | 12.00                | 22.00                | 32.00                | 42.00                | 41.00                | 1002.00              | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 0.00                 | 0.00                 | 0.00                 | 70.00                | 13.00                | 23.00                | 33.00                | 43.00                | 42.00                | 1003.00              | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 1000.00              | -162.40              | 400.00               | 72.00                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 57.71                | 1105.00              | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | -20.00               | 250.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -46.86               | 1110.00              | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 250.00               | 114.40               | -280.00              | 250.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -35.86               | 1115.00              | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | -337.60              | 0.00                 | -72.00               | -367.71              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -1009.93             | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 0.00                 | 0.00                 | -102.14              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -926.45              | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | -84.40               | 0.00                 | 0.00                 | -102.14              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -930.62              | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 662.40               | -162.40              | 328.00               | -295.71              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 57.71                | 95.07                | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | -20.00               | 147.86               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -46.86               | 183.55               | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 165.60               | 114.40               | -280.00              | 147.86               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -35.86               | 184.38               | ?                    | ?                    | 
And   the override date is '07/06/2016'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 1               | 0                     | 10.00                | 11.00                | 12.00                | 13.00                | 14.00                | 15.00                | 16.00                | 17.00                | 18.00                | 19.00                | 20.00                | 21.00                | 
 | MAIN-126       | ALLB-126      | 2               | 1                     | 0.00   | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    |
 | MAIN-126       | ALLB-126      | 3               | 1                     | 0.00   | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    |
 | MAIN-126       | ALLB-126      | 4               | 1                     | 0.00   | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    |

Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 1000.00              | -162.40              | 400.00               | 72.00                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 57.71                | 1105.00              | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | -20.00               | 250.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -46.86               | 1110.00              | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 250.00               | 114.40               | -280.00              | 250.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -35.86               | 1115.00              | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15  | Sep-15 | Oct-15 | Nov-15  | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16   | Jun-16 | Jul-16 |
 | MAIN-126       | ALLB-126      | 2               | -337.60 | 0.00   | -72.00 | -367.71 | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -1598.70 | ?      | ?      |
 | MAIN-126       | ALLB-126      | 3               | 0.00    | 0.00   | 0.00   | -102.14 | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -1166.93 | ?      | ?      |
 | MAIN-126       | ALLB-126      | 4               | -84.40  | 0.00   | 0.00   | -102.14 | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -1181.37 | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15 | Sep-15  | Oct-15  | Nov-15  | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16  | Jun-16 | Jul-16 |
 | MAIN-126       | ALLB-126      | 2               | 662.40 | -162.40 | 328.00  | -295.71 | 0.00   | 0.00   | 0.00   | 0.00   | 57.71  | -493.70 | ?      | ?      |
 | MAIN-126       | ALLB-126      | 3               | 0.00   | 20.00   | -20.00  | 147.86  | 0.00   | 0.00   | 0.00   | 0.00   | -46.86 | -56.93  | ?      | ?      |
 | MAIN-126       | ALLB-126      | 4               | 165.60 | 114.40  | -280.00 | 147.86  | 0.00   | 0.00   | 0.00   | 0.00   | -35.86 | -66.37  | ?      | ?      |
And   the override date is reset


@DoNotRun_7Mar2024
Scenario: D403c Single capping period
Given there is no payment schedule data for contract 'MAIN-126' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 12345678 | MAIN-126       | ALLB-126      | 24+ ALLB          | 24+ALLB1516             | AY                      | 01/08/2015          | 31/07/2016        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 1               | 0                     | 100.00               | 101.00               | 102.00               | 103.00               | 104.00               | 105.00               | 106.00               | 107.00               | 108.00               | 109.00               | 110.00               | 111.00               | 
 | MAIN-126       | ALLB-126      | 2               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '04/09/2015'
When   The following Summarised Actuals for period 'R01' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 1000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 1000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | -337.60              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | -84.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 662.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 165.60               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '06/10/2015'
When   The following Summarised Actuals for period 'R02' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 400.00               | 100.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 250.00               | 30.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 1000.00              | -162.40              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 250.00               | 114.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | -337.60              | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | -84.40               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 662.40               | -162.40              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 165.60               | 114.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '07/10/2015'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
 | MAIN-126       | ALLB-126      | 1               | 0                     | 10.00  | 11.00  | 12.00  | 13.00  | 14.00  | 15.00  | 16.00  | 17.00  | 18.00  | 19.00  | 20.00  | 21.00  |
 | MAIN-126       | ALLB-126      | 2               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
 | MAIN-126       | ALLB-126      | 3               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
 | MAIN-126       | ALLB-126      | 4               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |

Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 1000.00              | -162.40              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 250.00               | 114.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | -337.60              | -432.50              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | -17.30               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | -84.40               | -242.20              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 662.40               | -594.90              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 2.70                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 165.60               | -127.80              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '05/11/2015'
When   The following Summarised Actuals for period 'R03' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 400.00               | 100.00               | 400.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 1000.00              | -162.40              | 832.50               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | -2.70                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 250.00               | 114.40               | -37.80               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | -337.60              | -432.50              | -792.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | -17.30               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | -84.40               | -242.20              | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 662.40               | -594.90              | 40.50                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 2.70                 | -2.70                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 165.60               | -127.80              | -37.80               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '04/12/2015'
When   The following Summarised Actuals for period 'R04' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 400.00               | 100.00               | 400.00               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 0.00                 | 0.00                 | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 0.00                 | 0.00                 | 0.00                 | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 1000.00              | -162.40              | 832.50               | 792.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 20.00                | -2.70                | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 250.00               | 114.40               | -37.80               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | -337.60              | -432.50              | -792.00              | -830.57              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | -17.30               | 0.00                 | -230.71              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | -84.40               | -242.20              | 0.00                 | -230.71              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-126       | ALLB-126      | 2               | 662.40               | -594.90              | 40.50                | -38.57               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 3               | 0.00                 | 2.70                 | -2.70                | 19.29                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-126       | ALLB-126      | 4               | 165.60               | -127.80              | -37.80               | 19.29                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is reset

@DoNotRun_7Mar2024
Scenario: D407 A contract containing a 24+ALLF contract allocation is approved on time. Actuals have been received and pay calc taken place.. V2 of the contract is varied to increase funding and it is approved. Pay calc is then re-triggered
Given there is no payment schedule data for contract '24LOANS-572' version '1'
And the override date it empty for 'ALLF-572'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 10017572 | 24LOANS-572    | ALLF-572      | 24+ ALLF          | 24+ALLF1516             | AY                      | 01/08/2015          | 31/07/2016        | 


And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | 24LOANS-572    | ALLF-572      | 1               | 0                     | 3165.00              | 870.00               | 1318.00              | 3039.00              | 1434.00              | 1319.00              | 3208.00              | 661.00               | 3689.00              | 2201.00              | 2625.00              | 1221.00              | 
 | 24LOANS-572    | ALLF-572      | 2               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | 24LOANS-572    | ALLF-572      | 3               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | 24LOANS-572    | ALLF-572      | 4               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 

And   the override date is '06/09/2015'
When  The following Summarised Actuals for period 'A01' for collection type 'ALLF' are processed without aggregations
    | ContractNumber | AllocationRef | DeliverableCode | Aug-15  | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
    | 24LOANS-572    | ALLF-572      | 2               | 2035.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 3               | 91.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 4               | 1710.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    Then   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-15  | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
    | 24LOANS-572    | ALLF-572      | 4               | 1710.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 3               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 2               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-15  | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
    | 24LOANS-572    | ALLF-572      | 4               | 1710.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 3               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 2               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |


And   the override date is '06/10/2015'
    When  The following Summarised Actuals for period 'A02' for collection type 'ALLF' are processed without aggregations
    | ContractNumber | AllocationRef | DeliverableCode | Aug-15  | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
    | 24LOANS-572    | ALLF-572      | 2               | 556.00  | 254.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 3               | 1699.00 | 83.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 4               | 313.00  | 17.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    Then   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
    | 24LOANS-572    | ALLF-572      | 4               | 313.00 | 17.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 3               | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 2               | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
    | 24LOANS-572    | ALLF-572      | 4               | 313.00 | 17.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 3               | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 2               | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |


And   the override date is '07/10/2015'

When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
 | 24LOANS-572 -  | ALLF-572      | 1               | 0                     | 10.00  | 11.00  | 12.00  | 13.00  | 14.00  | 15.00  | 16.00  | 17.00  | 18.00  | 19.00  | 20.00  | 21.00  |
 | 24LOANS-572    | ALLF-572      | 4               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
 | 24LOANS-572    | ALLF-572      | 3               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
 | 24LOANS-572    | ALLF-572      | 2               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |

Then   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
    | 24LOANS-572    | ALLF-572      | 4               | 313.00 | 17.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 3               | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 2               | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
    | 24LOANS-572    | ALLF-572      | 4               | 313.00 | 17.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 3               | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 2               | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |



 And   the override date is '05/11/2015'
    When  The following Summarised Actuals for period 'A03' for collection type 'ALLF' are processed without aggregations
	| ContractNumber | AllocationRef | DeliverableCode | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16    |
    | 24LOANS-572    | ALLF-572      | 2               | 1225.00  | 180.00   | 73.00    | 1387.00  | 43.00    | 441.00   | 142.00   | 352.00   | 2282.00  | 863.00   | 861.00   | 937.00    |
    | 24LOANS-572    | ALLF-572      | 3               | 978.00   | 192.00   | 965.00   | 372.00   | 14.00    | 113.00   | 1181.00  | 235.00   | 1828.00  | 739.00   | 1781.00  | 400.00    |
    | 24LOANS-572    | ALLF-572      | 4               | 1781.00  | 47.00    | 572.00   | 156.00   | 24.00    | 586.00   | 721.00   | 26.00    | 941.00   | 327.00   | 683.00   | 953.00    |

    Then   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-15  | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
    | 24LOANS-572    | ALLF-572      | 4               | 1781.00 | 47.00  | 572.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 3               | 0.00    | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 2               | 0.00    | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-15  | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
    | 24LOANS-572    | ALLF-572      | 4               | 1781.00 | 47.00  | 572.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 3               | 0.00    | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | 24LOANS-572    | ALLF-572      | 2               | 0.00    | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the override date is reset

