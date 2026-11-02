Feature: 19TRN2020

@DoNotRun_7Mar2024
Scenario: PoA 8 19TRN2020-2021
Given there is no payment schedule data for contract '19TR20-1008' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 10081008 | 19TR20-1008    | 19TR-1008     | 19TRN2020         | 19TRN2020-2021          | AY                      | 01/02/2021          | 31/07/2021        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 1               | 0                     | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
 | 19TR20-1008    | 19TR-1008     | 3               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
And   the override date is '04/03/2021'
When   The following Summarised Actuals for period 'R07' for collection type 'ILR2021' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '08/04/2021'
When   The following Summarised Actuals for period 'R08' for collection type 'ILR2021' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1550.00              | 900.00               | ?                    | ?                    | ?                    | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 250.00               | 100.00               | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1450.00              | ?                    | ?                    | ?                    | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 250.00               | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 0.00                 | -175.00              | ?                    | ?                    | ?                    | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 0.00                 | -25.00               | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1275.00              | ?                    | ?                    | ?                    | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 225.00               | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '07/05/2021'
When   The following Summarised Actuals for period 'R09' for collection type 'ILR2021' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1452.00              | 1100.00              | 400.00               | ?                    | ?                    | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 248.00               | 100.00               | 50.00                | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1450.00              | 677.00               | ?                    | ?                    | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 250.00               | 73.00                | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 0.00                 | -175.00              | -264.00              | ?                    | ?                    | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 0.00                 | -25.00               | -36.00               | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1275.00              | 413.00               | ?                    | ?                    | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 225.00               | 37.00                | ?                    | ?                    | ?                    | 
And   the override date is '04/06/2021'
When   The following Summarised Actuals for period 'R10' for collection type 'ILR2021' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1452.00              | 1100.00              | 2000.00              | 2000.00              | ?                    | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 248.00               | 100.00               | 100.00               | 100.00               | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1450.00              | 677.00               | 3864.00              | ?                    | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 250.00               | 73.00                | 186.00               | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 0.00                 | -175.00              | -264.00              | -264.00              | ?                    | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 0.00                 | -25.00               | -36.00               | -36.00               | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1275.00              | 413.00               | 3600.00              | ?                    | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 225.00               | 37.00                | 150.00               | ?                    | ?                    | 
And   the override date is '06/07/2021'
When   The following Summarised Actuals for period 'R11' for collection type 'ILR2021' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1452.00              | 1100.00              | 2736.00              | 2000.00              | 600.00               | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 248.00               | 100.00               | 164.00               | 100.00               | 200.00               | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1450.00              | 677.00               | 3864.00              | 1600.00              | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 250.00               | 73.00                | 186.00               | 300.00               | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 0.00                 | -175.00              | -264.00              | -264.00              | -816.00              | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 0.00                 | -25.00               | -36.00               | -36.00               | -84.00               | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1275.00              | 413.00               | 3600.00              | 784.00               | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 225.00               | 37.00                | 150.00               | 216.00               | ?                    | 
And   the override date is '07/07/2021'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 1               | 0                     | 1175.00              | 1175.00              | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
 | 19TR20-1008    | 19TR-1008     | 3               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1450.00              | 677.00               | 3864.00              | 1600.00              | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 250.00               | 73.00                | 186.00               | 300.00               | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 0.00                 | -175.00              | -264.00              | -264.00              | -552.00              | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 0.00                 | -25.00               | -36.00               | -36.00               | -48.00               | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1275.00              | 413.00               | 3600.00              | 1048.00              | ?                    | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 225.00               | 37.00                | 150.00               | 252.00               | ?                    | 
And   the override date is '05/08/2021'
When   The following Summarised Actuals for period 'R12' for collection type 'ILR2021' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1300.00              | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 100.00               | 50.00                | 50.00                | 50.00                | 50.00                | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1450.00              | 677.00               | 3864.00              | 1600.00              | -1036.00             | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 250.00               | 73.00                | 186.00               | 300.00               | -364.00              | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 0.00                 | -175.00              | -264.00              | -264.00              | -552.00              | 0.00                 | 
 | 19TR20-1008    | 19TR-1008     | 3               | 0.00                 | -25.00               | -36.00               | -36.00               | -48.00               | 0.00                 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1275.00              | 413.00               | 3600.00              | 1048.00              | -1036.00             | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 225.00               | 37.00                | 150.00               | 252.00               | -364.00              | 
And   the override date is '06/08/2021'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 1               | 0                     | 1150.00              | 1150.00              | 1000.00              | 1000.00              | 1000.00              | 1300.00              | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
 | 19TR20-1008    | 19TR-1008     | 3               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1450.00              | 677.00               | 3864.00              | 1600.00              | -1036.00             | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 250.00               | 73.00                | 186.00               | 300.00               | -364.00              | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 0.00                 | -175.00              | -264.00              | -264.00              | -552.00              | 0.00                 | 
 | 19TR20-1008    | 19TR-1008     | 3               | 0.00                 | -25.00               | -36.00               | -36.00               | -48.00               | 0.00                 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1275.00              | 413.00               | 3600.00              | 1048.00              | -1036.00             | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 225.00               | 37.00                | 150.00               | 252.00               | -364.00              | 
And   the override date is '07/08/2021'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 1               | 0                     | 1400.00              | 1150.00              | 1000.00              | 1000.00              | 1000.00              | 1300.00              | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
 | 19TR20-1008    | 19TR-1008     | 3               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1450.00              | 677.00               | 3864.00              | 1600.00              | -1036.00             | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 250.00               | 73.00                | 186.00               | 300.00               | -364.00              | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 0.00                 | -175.00              | -264.00              | -264.00              | -552.00              | 0.00                 | 
 | 19TR20-1008    | 19TR-1008     | 3               | 0.00                 | -25.00               | -36.00               | -36.00               | -48.00               | 0.00                 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1275.00              | 413.00               | 3600.00              | 1048.00              | -1036.00             | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 225.00               | 37.00                | 150.00               | 252.00               | -364.00              | 
And   the override date is '14/09/2021'
When   The following Summarised Actuals for period 'R13' for collection type 'ILR2021' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1300.00              | 1625.60              | 1000.00              | 1000.00              | 1800.00              | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 100.00               | 284.40               | 50.00                | 50.00                | 50.00                | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | Sep-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1450.00              | 677.00               | 3864.00              | 1600.00              | -1036.00             | 1425.60              | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 250.00               | 73.00                | 186.00               | 300.00               | -364.00              | 234.40               | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | Sep-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 0.00                 | -175.00              | -264.00              | -264.00              | -552.00              | 0.00                 | -249.98              | 
 | 19TR20-1008    | 19TR-1008     | 3               | 0.00                 | -25.00               | -36.00               | -36.00               | -48.00               | 0.00                 | -20.02               | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | Sep-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1275.00              | 413.00               | 3600.00              | 1048.00              | -1036.00             | 1175.62              | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 225.00               | 37.00                | 150.00               | 252.00               | -364.00              | 214.38               | 
And   the override date is '15/09/2021'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 1               | 0                     | 1400.00              | 1150.00              | 1200.00              | 1200.00              | 1200.00              | 1200.00              | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
 | 19TR20-1008    | 19TR-1008     | 3               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | Sep-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1450.00              | 677.00               | 3864.00              | 1600.00              | -1036.00             | 1425.60              | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 250.00               | 73.00                | 186.00               | 300.00               | -364.00              | 234.40               | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | Sep-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 0.00                 | -175.00              | -264.00              | -264.00              | -552.00              | 0.00                 | 0.00                 | 
 | 19TR20-1008    | 19TR-1008     | 3               | 0.00                 | -25.00               | -36.00               | -36.00               | -48.00               | 0.00                 | 0.00                 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | Sep-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1275.00              | 413.00               | 3600.00              | 1048.00              | -1036.00             | 1425.60              | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 225.00               | 37.00                | 150.00               | 252.00               | -364.00              | 234.40               | 
And   the override date is '21/10/2021'
When   The following Summarised Actuals for period 'R14' for collection type 'ILR2021' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1200.00              | 1200.00              | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 
 | 19TR20-1008    | 19TR-1008     | 3               | 600.00               | 600.00               | 500.00               | 500.00               | 500.00               | 500.00               | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | Sep-21               | Oct-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1450.00              | 677.00               | 3864.00              | 1600.00              | -1036.00             | 1425.60              | -1325.60             | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 250.00               | 73.00                | 186.00               | 300.00               | -364.00              | 234.40               | 2565.60              | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | Sep-21               | Oct-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 0.00                 | -175.00              | -264.00              | -264.00              | -552.00              | 0.00                 | 0.00                 | -30.00               | 
 | 19TR20-1008    | 19TR-1008     | 3               | 0.00                 | -25.00               | -36.00               | -36.00               | -48.00               | 0.00                 | 0.00                 | -15.00               | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | Sep-21               | Oct-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1275.00              | 413.00               | 3600.00              | 1048.00              | -1036.00             | 1425.60              | -1355.60             | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 225.00               | 37.00                | 150.00               | 252.00               | -364.00              | 234.40               | 2550.60              | 
And   the override date is '22/10/2021'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 1               | 0                     | 500.00               | 500.00               | 1650.00              | 1650.00              | 1650.00              | 1650.00              | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
 | 19TR20-1008    | 19TR-1008     | 3               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | Sep-21               | Oct-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1450.00              | 677.00               | 3864.00              | 1600.00              | -1036.00             | 1425.60              | -1325.60             | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 250.00               | 73.00                | 186.00               | 300.00               | -364.00              | 234.40               | 2565.60              | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | Sep-21               | Oct-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 0.00                 | -175.00              | -264.00              | -264.00              | -552.00              | 0.00                 | 0.00                 | 0.00                 | 
 | 19TR20-1008    | 19TR-1008     | 3               | 0.00                 | -25.00               | -36.00               | -36.00               | -48.00               | 0.00                 | 0.00                 | 0.00                 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | Sep-21               | Oct-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1275.00              | 413.00               | 3600.00              | 1048.00              | -1036.00             | 1425.60              | -1325.60             | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 225.00               | 37.00                | 150.00               | 252.00               | -364.00              | 234.40               | 2565.60              | 
And   the override date is '23/10/2021'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | 
 | 19TR20-1008    | 19TR-1008     | 1               | 0                     | 2700.00              | 2700.00              | 1300.00              | 1000.00              | 1000.00              | 1000.00              | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
 | 19TR20-1008    | 19TR-1008     | 3               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | Sep-21               | Oct-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1450.00              | 677.00               | 3864.00              | 1600.00              | -1036.00             | 1425.60              | -1325.60             | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 250.00               | 73.00                | 186.00               | 300.00               | -364.00              | 234.40               | 2565.60              | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | Sep-21               | Oct-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 0.00                 | -175.00              | -264.00              | -264.00              | -552.00              | 0.00                 | 0.00                 | 0.00                 | 
 | 19TR20-1008    | 19TR-1008     | 3               | 0.00                 | -25.00               | -36.00               | -36.00               | -48.00               | 0.00                 | 0.00                 | 0.00                 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-21               | Mar-21               | Apr-21               | May-21               | Jun-21               | Jul-21               | Sep-21               | Oct-21               | 
 | 19TR20-1008    | 19TR-1008     | 2               | 1000.00              | 1275.00              | 413.00               | 3600.00              | 1048.00              | -1036.00             | 1425.60              | -1325.60             | 
 | 19TR20-1008    | 19TR-1008     | 3               | 100.00               | 225.00               | 37.00                | 150.00               | 252.00               | -364.00              | 234.40               | 2565.60              | 
And   the override date is reset
