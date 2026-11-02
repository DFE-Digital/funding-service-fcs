Feature: AEBTO-TOL1617 - FY and Alloc-Level

@DoNotRun_7Mar2024
Scenario: D047 AEBTO-TOL1617 - FY and Alloc-Level
Given there is no payment schedule data for contract 'MAIN-4747' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 47123456 | MAIN-4747      | AEO-4747      | AEBTO-TOL         | AEBTO-TOL1617           | AY                      | 01/08/2016          | 31/07/2017        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 1               | 0                     | 102.50 | 102.60 | 102.70 | 102.80 | 102.90 | 103.00 | 103.10 | 103.20 | 103.30 | 103.40 | 103.50 | 103.60 |
 | MAIN-4747      | AEO-4747      | 2               | 0                     | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 3               | 0                     | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 4               | 0                     | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 5               | 0                     | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 6               | 0                     | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the override date is '06/09/2016'
When   The following Summarised Actuals for period 'R01' for collection type 'ILR1617' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16  | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | 1000.01 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 3               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 4               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 5               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 6               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16  | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | 1000.01 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 3               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 4               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 5               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 6               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16  | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | -177.21 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 3               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 4               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 5               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 6               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | 822.80 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 3               | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 4               | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 5               | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 6               | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the override date is '15/09/2016'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 1               | 0                     | 302.50 | 102.60 | 102.70 | 102.80 | 102.90 | 103.00 | 103.10 | 103.20 | 103.30 | 103.40 | 103.50 | 103.60 |
 | MAIN-4747      | AEO-4747      | 2               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
 | MAIN-4747      | AEO-4747      | 3               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
 | MAIN-4747      | AEO-4747      | 4               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
 | MAIN-4747      | AEO-4747      | 5               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
 | MAIN-4747      | AEO-4747      | 6               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16  | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | 1000.01 | 177.21 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 3               | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 4               | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 5               | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 6               | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16  | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | -177.21 | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 3               | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 4               | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 5               | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 6               | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | 822.80 | 177.21 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 3               | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 4               | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 5               | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 6               | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the override date is '06/04/2017'
When   The following Summarised Actuals for period 'R08' for collection type 'ILR1617' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | 302.75 | 102.86 | 102.97 | 103.08 | 103.19 | 103.30 | 103.41 | 103.52 | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 3               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 4               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 5               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 6               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16  | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | 1000.01 | 177.21 | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 25.07  | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 3               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 4               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 5               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 6               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16  | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | -177.21 | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -2.28  | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 3               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 4               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 5               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 6               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | 822.80 | 177.21 | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 22.79  | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 3               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 4               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 5               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 6               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      |
And   the override date is '05/05/2017'
When   The following Summarised Actuals for period 'R09' for collection type 'ILR1617' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | 59.51  | 19.52  | 19.53  | 19.54  | 19.55  | 19.56  | 19.57  | 19.58  | 85.00  | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 3               | 59.50  | 19.51  | 19.52  | 19.53  | 19.54  | 19.55  | 19.56  | 19.57  | 86.00  | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 4               | 59.49  | 19.50  | 19.51  | 19.52  | 19.53  | 19.54  | 19.55  | 19.56  | 87.00  | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 5               | 59.48  | 19.49  | 19.50  | 19.51  | 19.52  | 19.53  | 19.54  | 19.55  | 88.00  | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 6               | 59.47  | 19.48  | 19.49  | 19.50  | 19.51  | 19.52  | 19.53  | 19.54  | 90.00  | ?      | ?      | ?      |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16  | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17  | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | 1000.01 | 177.21 | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 25.07  | -741.44 | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 3               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 282.28  | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 4               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 283.20  | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 5               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 284.12  | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 6               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 286.04  | ?      | ?      | ?      |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16  | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | -177.21 | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -2.28  | -4.33  | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 3               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -4.38  | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 4               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -4.43  | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 5               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -4.48  | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 6               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -4.58  | ?      | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17  | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | 822.80 | 177.21 | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 22.79  | -745.77 | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 3               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 277.90  | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 4               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 278.77  | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 5               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 279.64  | ?      | ?      | ?      |
 | MAIN-4747      | AEO-4747      | 6               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 281.46  | ?      | ?      | ?      |
And   the override date is '04/08/2017'
When   The following Summarised Actuals for period 'R12' for collection type 'ILR1617' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | 61.60  | 21.63  | 21.66  | 21.69  | 21.72  | 21.75  | 21.78  | 21.81  | 21.84  | 21.87  | 21.90  | 21.93  |
 | MAIN-4747      | AEO-4747      | 3               | 61.61  | 21.64  | 21.67  | 21.70  | 21.73  | 21.76  | 21.79  | 21.82  | 21.85  | 21.88  | 21.91  | 21.94  |
 | MAIN-4747      | AEO-4747      | 4               | 61.62  | 21.65  | 21.68  | 21.71  | 21.74  | 21.77  | 21.80  | 21.83  | 21.86  | 21.89  | 21.92  | 21.95  |
 | MAIN-4747      | AEO-4747      | 5               | 61.63  | 21.66  | 21.69  | 21.72  | 21.75  | 21.78  | 21.81  | 21.84  | 21.87  | 21.90  | 21.93  | 21.96  |
 | MAIN-4747      | AEO-4747      | 6               | 61.64  | 21.67  | 21.70  | 21.73  | 21.76  | 21.79  | 21.82  | 21.85  | 21.88  | 21.91  | 21.94  | 21.97  |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16  | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17  | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | 1000.01 | 177.21 | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 25.07  | -741.44 | 0.00   | 0.00   | 24.15  |
 | MAIN-4747      | AEO-4747      | 3               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 282.28  | 0.00   | 0.00   | 23.40  |
 | MAIN-4747      | AEO-4747      | 4               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 283.20  | 0.00   | 0.00   | 22.65  |
 | MAIN-4747      | AEO-4747      | 5               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 284.12  | 0.00   | 0.00   | 21.90  |
 | MAIN-4747      | AEO-4747      | 6               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 286.04  | 0.00   | 0.00   | 20.20  |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16  | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | -177.21 | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -2.28  | -4.33  | 0.00   | 0.00   | -14.09 |
 | MAIN-4747      | AEO-4747      | 3               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -4.38  | 0.00   | 0.00   | -14.10 |
 | MAIN-4747      | AEO-4747      | 4               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -4.43  | 0.00   | 0.00   | -14.10 |
 | MAIN-4747      | AEO-4747      | 5               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -4.48  | 0.00   | 0.00   | -14.10 |
 | MAIN-4747      | AEO-4747      | 6               | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -4.58  | 0.00   | 0.00   | -14.11 |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17  | May-17 | Jun-17 | Jul-17 |
 | MAIN-4747      | AEO-4747      | 2               | 822.80 | 177.21 | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 22.79  | -745.77 | 0.00   | 0.00   | 10.06  |
 | MAIN-4747      | AEO-4747      | 3               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 277.90  | 0.00   | 0.00   | 9.30   |
 | MAIN-4747      | AEO-4747      | 4               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 278.77  | 0.00   | 0.00   | 8.55   |
 | MAIN-4747      | AEO-4747      | 5               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 279.64  | 0.00   | 0.00   | 7.80   |
 | MAIN-4747      | AEO-4747      | 6               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 281.46  | 0.00   | 0.00   | 6.09   |
And   the override date is reset

