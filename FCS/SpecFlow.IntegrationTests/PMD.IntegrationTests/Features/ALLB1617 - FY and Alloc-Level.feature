Feature: ALLB1617 - FY and Alloc-Level

@DoNotRun_7Mar2024
Scenario: D046 ALLB1617 - FY and Alloc-Level
Given there is no payment schedule data for contract 'MAIN-4646' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 46123456 | MAIN-4646      | ALLB-4646     | 24+ ALLB          | ALLB1617                | AY                      | 01/08/2016          | 31/07/2017        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 5               | 0                     | 108.00 | 109.00 | 110.00 | 111.00 | 112.00 | 101.00 | 102.00 | 103.00 | 104.00 | 105.00 | 106.00 | 107.00 |
 | MAIN-4646      | ALLB-4646     | 6               | 0                     | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 0                     | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 0                     | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the override date is '06/09/2016'
When   The following Summarised Actuals for period 'R01' for collection type 'ILR1617' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the override date is '06/10/2016'
When   The following Summarised Actuals for period 'R02' for collection type 'ILR1617' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the override date is '04/11/2016'
When   The following Summarised Actuals for period 'R03' for collection type 'ILR1617' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the override date is '06/12/2016'
When   The following Summarised Actuals for period 'R04' for collection type 'ILR1617' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the override date is '06/01/2017'
When   The following Summarised Actuals for period 'R05' for collection type 'ILR1617' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | ?      | ?      | ?      | ?      | ?      | ?      | ?      |  
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
And   the override date is '06/02/2017'
When   The following Summarised Actuals for period 'R06' for collection type 'ILR1617' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | ?      | ?      | ?      | ?      | ?      | ?      |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | ?      | ?      | ?      | ?      | ?      | ?      |  
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | ?      | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | ?      | ?      | ?      | ?      | ?      | ?      |
And   the override date is '06/03/2017'
When   The following Summarised Actuals for period 'R07' for collection type 'ILR1617' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | 138.00 | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | 38.00  | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | 38.00  | ?      | ?      | ?      | ?      | ?      |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | 138.00 | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | 38.00  | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | 38.00  | ?      | ?      | ?      | ?      | ?      |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -8.60  | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -6.20  | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -6.20  | ?      | ?      | ?      | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | 129.40 | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | 31.80  | ?      | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | 31.80  | ?      | ?      | ?      | ?      | ?      |
And   the override date is '06/04/2017'
When   The following Summarised Actuals for period 'R08' for collection type 'ILR1617' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 33.67  | 34.00  | 34.33  | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 33.67  | 34.00  | 34.34  | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 33.66  | 34.00  | 34.33  | ?      | ?      | ?      | ?      |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | 138.00 | -65.06 | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | 38.00  | 32.54  | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | 38.00  | 32.52  | ?      | ?      | ?      | ?      |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -8.60  | 0.00   | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -6.20  | 0.00   | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -6.20  | 0.00   | ?      | ?      | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | 129.40 | -65.06 | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | 31.80  | 32.54  | ?      | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | 31.80  | 32.52  | ?      | ?      | ?      | ?      |
And   the override date is '05/05/2017'
When   The following Summarised Actuals for period 'R09' for collection type 'ILR1617' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 33.67  | 34.00  | 34.00  | 0.00   | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 33.67  | 34.00  | 34.34  | 0.00   | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 33.66  | 34.00  | 34.33  | 423.99 | ?      | ?      | ?      |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | 138.00 | -65.06 | -0.33  | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | 38.00  | 32.54  | 0.00   | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | 38.00  | 32.52  | 423.99 | ?      | ?      | ?      |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -8.60  | 0.00   | 0.00   | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -6.20  | 0.00   | 0.00   | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -6.20  | 0.00   | -1.99  | ?      | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | 129.40 | -65.06 | -0.33  | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | 31.80  | 32.54  | 0.00   | ?      | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | 31.80  | 32.52  | 422.00 | ?      | ?      | ?      |
And   the override date is '15/05/2017'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 5               | 0                     | 108.00 | 109.00 | 110.00 | 111.00 | 112.00 | 101.00 | 102.00 | 103.00 | 204.00 | 105.00 | 106.00 | 107.00 |
 | MAIN-4646      | ALLB-4646     | 6               | 5                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
 | MAIN-4646      | ALLB-4646     | 7               | 5                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
 | MAIN-4646      | ALLB-4646     | 8               | 5                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | 138.00 | -65.06 | -0.33  | 0.00   | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | 38.00  | 32.54  | 0.00   | 0.00   | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | 38.00  | 32.52  | 423.99 | 1.99   | ?      | ?      |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -8.60  | 0.00   | 0.00   | 0.00   | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -6.20  | 0.00   | 0.00   | 0.00   | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -6.20  | 0.00   | -1.99  | 0.00   | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | 129.40 | -65.06 | -0.33  | 0.00   | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | 31.80  | 32.54  | 0.00   | 0.00   | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | 31.80  | 32.52  | 422.00 | 1.99   | ?      | ?      |
And   the override date is '06/06/2017'
When   The following Summarised Actuals for period 'R10' for collection type 'ILR1617' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 136.00 | 36.33  | 36.66  | 37.00  | 37.33  | 33.67  | 34.00  | 34.00  | 0.00   | 1.00   | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 33.67  | 34.00  | 34.34  | 0.00   | 0.00   | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 33.66  | 34.00  | 34.33  | 423.99 | 0.00   | ?      | ?      |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | 138.00 | -65.06 | -0.33  | 101.00 | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | 38.00  | 32.54  | 0.00   | 0.00   | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | 38.00  | 32.52  | 423.99 | 1.99   | ?      | ?      |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -8.60  | 0.00   | 0.00   | -40.15 | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -6.20  | 0.00   | 0.00   | -29.76 | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -6.20  | 0.00   | -1.99  | -29.76 | ?      | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | 129.40 | -65.06 | -0.33  | 60.85  | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | 31.80  | 32.54  | 0.00   | -29.76 | ?      | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | 31.80  | 32.52  | 422.00 | -27.77 | ?      | ?      |
And   the override date is '06/07/2017'
When   The following Summarised Actuals for period 'R11' for collection type 'ILR1617' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 136.00 | 36.33  | 36.66  | 37.00  | 37.33  | 33.67  | 34.00  | 34.00  | 0.00   | 150.00 | 153.00 | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 33.67  | 34.00  | 34.34  | 0.00   | 151.00 | 152.00 | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 33.66  | 34.00  | 34.33  | 0.00   | 0.00   | 0.00   | ?      |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17  | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | 138.00 | -65.06 | -0.33  | 101.00 | 342.15  | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | 38.00  | 32.54  | 0.00   | 0.00   | 332.76  | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | 38.00  | 32.52  | 423.99 | 1.99   | -394.23 | ?      |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -8.60  | 0.00   | 0.00   | -40.15 | -82.15 | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -6.20  | 0.00   | 0.00   | -29.76 | -71.76 | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -6.20  | 0.00   | -1.99  | -29.76 | -29.76 | ?      |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17  | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | 129.40 | -65.06 | -0.33  | 60.85  | 260.00  | ?      |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | 31.80  | 32.54  | 0.00   | -29.76 | 261.00  | ?      |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | 31.80  | 32.52  | 422.00 | -27.77 | -423.99 | ?      |
And   the override date is '04/08/2017'
When   The following Summarised Actuals for period 'R12' for collection type 'ILR1617' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 136.00 | 36.33  | 36.66  | 37.00  | 37.33  | 33.67  | 34.00  | 0.00   | 0.00   | 150.00 | 0.00   | 11.00  |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 33.67  | 34.00  | 0.00   | 0.00   | 151.00 | 0.00   | 12.00  |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 33.66  | 34.00  | 0.00   | 0.00   | 0.00   | 0.00   | 13.11  |
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17  | Jul-17  |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | 138.00 | -65.06 | -0.33  | 101.00 | 342.15  | -93.85  |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | 38.00  | 32.54  | 0.00   | 0.00   | 332.76  | -102.58 |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | 38.00  | 32.52  | 423.99 | 1.99   | -394.23 | 8.54    |
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17 | Jul-17 |
 | MAIN-4646      | ALLB-4646     | 6               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -8.60  | 0.00   | 0.00   | -40.15 | -82.15 | 0.00   |
 | MAIN-4646      | ALLB-4646     | 7               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -6.20  | 0.00   | 0.00   | -29.76 | -71.76 | 0.00   |
 | MAIN-4646      | ALLB-4646     | 8               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -6.20  | 0.00   | -1.99  | -29.76 | -29.76 | 0.00   |
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 | May-17 | Jun-17  | Jul-17  |
 | MAIN-4646      | ALLB-4646     | 6               | 36.00  | 36.33  | 36.66  | 37.00  | 37.33  | 37.66  | 129.40 | -65.06 | -0.33  | 60.85  | 260.00  | -93.85  |
 | MAIN-4646      | ALLB-4646     | 7               | 36.00  | 36.33  | 36.67  | 37.00  | 37.33  | 37.67  | 31.80  | 32.54  | 0.00   | -29.76 | 261.00  | -102.58 |
 | MAIN-4646      | ALLB-4646     | 8               | 36.00  | 36.34  | 36.67  | 37.00  | 37.34  | 37.67  | 31.80  | 32.52  | 422.00 | -27.77 | -423.99 | 8.54    |
And   the override date is reset

