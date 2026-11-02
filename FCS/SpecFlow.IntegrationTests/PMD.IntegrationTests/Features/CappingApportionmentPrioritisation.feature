Feature: Capping Apportionment Prioritisation

@Complete @DoNotRun_7Mar2024 @CappingApportionmentOrder
Scenario: D051 16-18 Non-Levy Apps (16-18NLA1718)
Given there is no payment schedule data for contract 'MAIN-5151' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 51123456 | MAIN-5151      | 16NL-5151     | 16-18NLA          | 16-18NLA1718            | AY                      | 01/08/2017          | 31/07/2018        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 1               | 0                     | 100.00               | 110.00               | 120.00               | 130.00               | 140.00               | 150.00               | 160.00               | 740.00               | 210.00               | 220.00               | 230.00               | 240.00               | 
 | MAIN-5151      | 16NL-5151     | 2               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    |
 | MAIN-5151      | 16NL-5151     | 3               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    |
 | MAIN-5151      | 16NL-5151     | 4               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    |
And   the override date is '06/09/2017'
When   The following Summarised Actuals for period 'APPS04' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '05/10/2017'
When   The following Summarised Actuals for period 'APPS05' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | 151.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | 199.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | 151.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | 199.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 0.00                 | -311.11              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 0.00                 | -38.89               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | -311.11              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | 112.11               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | 199.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '01/11/2017'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 1               | 0                     | 451.00               | 110.00               | 120.00               | 130.00               | 140.00               | 150.00               | 160.00               | 740.00               | 210.00               | 220.00               | 230.00               | 240.00               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
 | MAIN-5151      | 16NL-5151     | 3               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
 | MAIN-5151      | 16NL-5151     | 4               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | 0.00                 | 311.11               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | 151.00               | 38.89                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | 199.00               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 0.00                 | -311.11              | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 0.00                 | -38.89               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | -311.11              | 311.11               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | 112.11               | 38.89                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | 199.00               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '06/04/2018'
When   The following Summarised Actuals for period 'APPS11' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | 0.00                 | 46.00                | 47.00                | 48.00                | 49.00                | 50.00                | 210.00               | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | 151.00               | 21.00                | 22.00                | 23.00                | 24.00                | 25.00                | 110.00               | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | 199.00               | 29.00                | 28.00                | 27.00                | 26.00                | 25.00                | 90.00                | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | 0.00                 | 311.11               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 450.00               | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | 151.00               | 38.89                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | 199.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 0.00                 | -311.11              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -744.63              | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 0.00                 | -38.89               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -154.37              | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | -311.11              | 311.11               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -294.63              | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | 112.11               | 38.89                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 70.63                | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | 199.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '04/05/2018'
When   The following Summarised Actuals for period 'APPS12' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | 0.00                 | 46.00                | 47.00                | 48.00                | 49.00                | 50.00                | 212.00               | 800.00               | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | 151.00               | 21.00                | 22.00                | 23.00                | 24.00                | 25.00                | 110.00               | 98.00                | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | 199.00               | 29.00                | 28.00                | 27.00                | 26.00                | 25.00                | 90.00                | 1.00                 | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | 0.00                 | 311.11               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 450.00               | 1546.63              | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | 151.00               | 38.89                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 252.37               | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | 199.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 1.00                 | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 0.00                 | -311.11              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -744.63              | -746.41              | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 0.00                 | -38.89               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -154.37              | -154.59              | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | -311.11              | 311.11               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -294.63              | 800.22               | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | 112.11               | 38.89                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 70.63                | 97.78                | ?                    | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | 199.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 1.00                 | ?                    | ?                    | ?                    | 
And   the override date is '01/06/2018'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 1               | 0                     | 451.00               | 110.00               | 120.00               | 130.00               | 140.00               | 150.00               | 160.00               | 1642.00              | 210.00               | 220.00               | 230.00               | 238.00               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
 | MAIN-5151      | 16NL-5151     | 3               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
 | MAIN-5151      | 16NL-5151     | 4               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | 0.00                 | 311.11               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 450.00               | 1546.63              | 746.41               | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | 151.00               | 38.89                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 252.37               | 154.59               | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | 199.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 1.00                 | 0.00                 | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 0.00                 | -311.11              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -744.63              | -746.41              | -0.89                | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 0.00                 | -38.89               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -154.37              | -154.59              | -0.11                | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | -311.11              | 311.11               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -294.63              | 800.22               | 745.52               | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | 112.11               | 38.89                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 70.63                | 97.78                | 154.48               | ?                    | ?                    | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | 199.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 1.00                 | 0.00                 | ?                    | ?                    | 
And   the override date is '06/08/2018'
When   The following Summarised Actuals for period 'APPS15' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 376.00               | 21.00                | 136.00               | 136.00               | 136.00               | 136.00               | 36.00                | 148.00               | 800.00               | 100.00               | 50.00                | 50.00                | 
 | MAIN-5151      | 16NL-5151     | 3               | 8.00                 | 38.00                | 68.00                | 68.00                | 68.00                | 68.00                | 18.00                | 39.00                | 8.00                 | 52.00                | 50.00                | 40.00                | 
 | MAIN-5151      | 16NL-5151     | 4               | 182.00               | 182.00               | 182.00               | 182.00               | 182.00               | 182.00               | 82.00                | 326.00               | 1.00                 | 49.00                | 100.00               | 100.00               | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | 0.00                 | 311.11               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 450.00               | 1546.63              | 746.41               | 0.00                 | -726.11              | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | 151.00               | 38.89                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 252.37               | 154.59               | 0.00                 | 2.11                 | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | 199.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 1.00                 | 0.00                 | 0.00                 | 1324.00              | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 0.00                 | -311.11              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -744.63              | -746.41              | -0.89                | 0.00                 | -509.27              | 
 | MAIN-5151      | 16NL-5151     | 3               | 0.00                 | -38.89               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -154.37              | -154.59              | -0.11                | 0.00                 | -89.73               | 
 | MAIN-5151      | 16NL-5151     | 4               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5151      | 16NL-5151     | 2               | 1600.00              | -311.11              | 311.11               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -294.63              | 800.22               | 745.52               | 0.00                 | -1235.38             | 
 | MAIN-5151      | 16NL-5151     | 3               | 49.00                | 112.11               | 38.89                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 70.63                | 97.78                | 154.48               | 0.00                 | -87.62               | 
 | MAIN-5151      | 16NL-5151     | 4               | 1.00                 | 199.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 1.00                 | 0.00                 | 0.00                 | 1324.00              | 
And   the override date is reset

@Complete @DoNotRun_7Mar2024 @CappingApportionmentOrder
Scenario: D052 Adult Non-Levy Apps (ANLA1718)
Given there is no payment schedule data for contract 'MAIN-5252' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 52123456 | MAIN-5252      | ANL-5252      | ANLA              | ANLA1718                | AY                      | 01/08/2017          | 31/07/2018        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 1               | 0                     | 100.00               | 110.00               | 120.00               | 130.00               | 140.00               | 150.00               | 160.00               | 740.00               | 210.00               | 220.00               | 230.00               | 240.00               | 
 | MAIN-5252      | ANL-5252      | 2               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    |
 | MAIN-5252      | ANL-5252      | 3               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    |
 | MAIN-5252      | ANL-5252      | 4               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    |
And   the override date is '06/09/2017'
When   The following Summarised Actuals for period 'APPS04' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '05/10/2017'
When   The following Summarised Actuals for period 'APPS05' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | 151.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | 199.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | 151.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | 199.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 0.00                 | -311.11              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 0.00                 | -38.89               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | -311.11              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | 112.11               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | 199.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '01/11/2017'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 1               | 0                     | 451.00               | 110.00               | 120.00               | 130.00               | 140.00               | 150.00               | 160.00               | 740.00               | 210.00               | 220.00               | 230.00               | 240.00               | 
 | MAIN-5252      | ANL-5252      | 2               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
 | MAIN-5252      | ANL-5252      | 3               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
 | MAIN-5252      | ANL-5252      | 4               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | 0.00                 | 311.11               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | 151.00               | 38.89                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | 199.00               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 0.00                 | -311.11              | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 0.00                 | -38.89               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | -311.11              | 311.11               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | 112.11               | 38.89                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | 199.00               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '06/04/2018'
When   The following Summarised Actuals for period 'APPS11' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | 0.00                 | 46.00                | 47.00                | 48.00                | 49.00                | 50.00                | 210.00               | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | 151.00               | 21.00                | 22.00                | 23.00                | 24.00                | 25.00                | 110.00               | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | 199.00               | 29.00                | 28.00                | 27.00                | 26.00                | 25.00                | 90.00                | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | 0.00                 | 311.11               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 450.00               | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | 151.00               | 38.89                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | 199.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 0.00                 | -311.11              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -744.63              | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 0.00                 | -38.89               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -154.37              | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | -311.11              | 311.11               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -294.63              | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | 112.11               | 38.89                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 70.63                | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | 199.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '04/05/2018'
When   The following Summarised Actuals for period 'APPS12' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | 0.00                 | 46.00                | 47.00                | 48.00                | 49.00                | 50.00                | 212.00               | 800.00               | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | 151.00               | 21.00                | 22.00                | 23.00                | 24.00                | 25.00                | 110.00               | 98.00                | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | 199.00               | 29.00                | 28.00                | 27.00                | 26.00                | 25.00                | 90.00                | 1.00                 | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | 0.00                 | 311.11               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 450.00               | 1546.63              | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | 151.00               | 38.89                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 252.37               | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | 199.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 1.00                 | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 0.00                 | -311.11              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -744.63              | -746.41              | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 0.00                 | -38.89               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -154.37              | -154.59              | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | -311.11              | 311.11               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -294.63              | 800.22               | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | 112.11               | 38.89                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 70.63                | 97.78                | ?                    | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | 199.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 1.00                 | ?                    | ?                    | ?                    | 
And   the override date is '01/06/2018'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 1               | 0                     | 451.00               | 110.00               | 120.00               | 130.00               | 140.00               | 150.00               | 160.00               | 1642.00              | 210.00               | 220.00               | 230.00               | 238.00               | 
 | MAIN-5252      | ANL-5252      | 2               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
 | MAIN-5252      | ANL-5252      | 3               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
 | MAIN-5252      | ANL-5252      | 4               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | 0.00                 | 311.11               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 450.00               | 1546.63              | 746.41               | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | 151.00               | 38.89                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 252.37               | 154.59               | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | 199.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 1.00                 | 0.00                 | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 0.00                 | -311.11              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -744.63              | -746.41              | -0.89                | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 0.00                 | -38.89               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -154.37              | -154.59              | -0.11                | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | -311.11              | 311.11               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -294.63              | 800.22               | 745.52               | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | 112.11               | 38.89                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 70.63                | 97.78                | 154.48               | ?                    | ?                    | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | 199.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 1.00                 | 0.00                 | ?                    | ?                    | 
And   the override date is '06/08/2018'
When   The following Summarised Actuals for period 'APPS15' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 376.00               | 21.00                | 136.00               | 136.00               | 136.00               | 136.00               | 36.00                | 148.00               | 800.00               | 100.00               | 50.00                | 50.00                | 
 | MAIN-5252      | ANL-5252      | 3               | 8.00                 | 38.00                | 68.00                | 68.00                | 68.00                | 68.00                | 18.00                | 39.00                | 8.00                 | 52.00                | 50.00                | 40.00                | 
 | MAIN-5252      | ANL-5252      | 4               | 182.00               | 182.00               | 182.00               | 182.00               | 182.00               | 182.00               | 82.00                | 326.00               | 1.00                 | 49.00                | 100.00               | 100.00               | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | 0.00                 | 311.11               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 450.00               | 1546.63              | 746.41               | 0.00                 | -726.11              | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | 151.00               | 38.89                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 252.37               | 154.59               | 0.00                 | 2.11                 | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | 199.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 1.00                 | 0.00                 | 0.00                 | 1324.00              | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 0.00                 | -311.11              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -744.63              | -746.41              | -0.89                | 0.00                 | -509.27              | 
 | MAIN-5252      | ANL-5252      | 3               | 0.00                 | -38.89               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -154.37              | -154.59              | -0.11                | 0.00                 | -89.73               | 
 | MAIN-5252      | ANL-5252      | 4               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5252      | ANL-5252      | 2               | 1600.00              | -311.11              | 311.11               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -294.63              | 800.22               | 745.52               | 0.00                 | -1235.38             | 
 | MAIN-5252      | ANL-5252      | 3               | 49.00                | 112.11               | 38.89                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 70.63                | 97.78                | 154.48               | 0.00                 | -87.62               | 
 | MAIN-5252      | ANL-5252      | 4               | 1.00                 | 199.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 225.00               | 1.00                 | 0.00                 | 0.00                 | 1324.00              | 
And   the override date is reset

@Complete @IntegrationTest @CappingApportionmentOrder
Scenario: D053 Non-Levy Apps Meeting Example - Implication
Given there is no payment schedule data for contract 'MAIN-5353' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 53123456 | MAIN-5353      | 16NL-5353     | 16-18NLA          | 16-18NLA1718            | AY                      | 01/08/2017          | 31/07/2018        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5353      | 16NL-5353     | 1               | 0                     | 900.00               | 900.00               | 900.00               | 900.00               | 900.00               | 900.00               | 900.00               | 3700.00              | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 
 | MAIN-5353      | 16NL-5353     | 2               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    |
 | MAIN-5353      | 16NL-5353     | 3               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    |
 | MAIN-5353      | 16NL-5353     | 4               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    |
And   the override date is '06/09/2017'
When   The following Summarised Actuals for period 'APPS04' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5353      | 16NL-5353     | 2               | 9000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 3               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 4               | 500.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5353      | 16NL-5353     | 2               | 9000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 3               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 4               | 500.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5353      | 16NL-5353     | 2               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 4               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5353      | 16NL-5353     | 2               | 9000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 3               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 4               | 500.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '05/10/2017'
When   The following Summarised Actuals for period 'APPS05' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5353      | 16NL-5353     | 2               | 9000.00              | 1250.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 3               | 250.00               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 4               | 500.00               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5353      | 16NL-5353     | 2               | 9000.00              | 1250.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 3               | 250.00               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 4               | 500.00               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5353      | 16NL-5353     | 2               | 0.00                 | -976.19              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 3               | 0.00                 | -23.81               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 4               | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5353      | 16NL-5353     | 2               | 9000.00              | 273.81               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 3               | 250.00               | -23.81               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 4               | 500.00               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '06/11/2017'
When   The following Summarised Actuals for period 'APPS06' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5353      | 16NL-5353     | 2               | 9000.00              | 1250.00              | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 3               | 250.00               | 0.00                 | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 4               | 500.00               | 0.00                 | 2500.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5353      | 16NL-5353     | 2               | 9000.00              | 1250.00              | 1226.19              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 3               | 250.00               | 0.00                 | 273.81               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 4               | 500.00               | 0.00                 | 2500.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5353      | 16NL-5353     | 2               | 0.00                 | -976.19              | -3818.18             | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 3               | 0.00                 | -23.81               | -181.82              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 4               | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5353      | 16NL-5353     | 2               | 9000.00              | 273.81               | -2591.99             | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 3               | 250.00               | -23.81               | 91.99                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5353      | 16NL-5353     | 4               | 500.00               | 0.00                 | 2500.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is reset

@Complete @IntegrationTest @CappingApportionmentOrder
Scenario: D054 Non-Levy Apps Meeting Example - Extreme
Given there is no payment schedule data for contract 'MAIN-5454' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 54123456 | MAIN-5454      | ANL-5454      | ANLA              | ANLA1718                | AY                      | 01/08/2017          | 31/07/2018        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5454      | ANL-5454      | 1               | 0                     | 900.00               | 900.00               | 900.00               | 900.00               | 900.00               | 900.00               | 900.00               | 3700.00              | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 
 | MAIN-5454      | ANL-5454      | 2               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5454      | ANL-5454      | 3               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    |
 | MAIN-5454      | ANL-5454      | 4               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    |
And   the override date is '06/09/2017'
When   The following Summarised Actuals for period 'APPS04' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5454      | ANL-5454      | 2               | 500.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5454      | ANL-5454      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5454      | ANL-5454      | 4               | 11000.00             | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5454      | ANL-5454      | 2               | 500.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5454      | ANL-5454      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5454      | ANL-5454      | 4               | 11000.00             | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5454      | ANL-5454      | 2               | -500.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5454      | ANL-5454      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5454      | ANL-5454      | 4               | -1000.00             | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5454      | ANL-5454      | 2               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5454      | ANL-5454      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5454      | ANL-5454      | 4               | 10000.00             | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is reset

@Complete @IntegrationTest @CappingApportionmentOrder
Scenario: D055 Non-Levy Apps Meeting Example - FY
Given there is no payment schedule data for contract 'MAIN-5555' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 55123456 | MAIN-5555      | ANL-5555      | ANLA              | ANLA1718                | AY                      | 01/08/2017          | 31/07/2018        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 1               | 0                     | 900.00               | 900.00               | 900.00               | 900.00               | 900.00               | 900.00               | 900.00               | 3700.00              | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 
 | MAIN-5555      | ANL-5555      | 2               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    |
 | MAIN-5555      | ANL-5555      | 3               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    |
 | MAIN-5555      | ANL-5555      | 4               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    |

And   the override date is '06/09/2017'
When   The following Summarised Actuals for period 'APPS04' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 2               | 7000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 4               | 500.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 2               | 7000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 4               | 500.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 2               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 4               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 2               | 7000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 4               | 500.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '06/04/2018'
When   The following Summarised Actuals for period 'APPS11' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 2               | 7000.00              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 1000.00              | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 3               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 2000.00              | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 4               | 500.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 1500.00              | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 2               | 7000.00              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 1000.00              | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 3               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 2000.00              | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 4               | 500.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 1500.00              | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 2               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -1600.00             | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 3               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -400.00              | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 4               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 2               | 7000.00              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -600.00              | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 3               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 1600.00              | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 4               | 500.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 1500.00              | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '04/05/2018'
When   The following Summarised Actuals for period 'APPS12' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 2               | 7000.00              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 1000.00              | 2000.00              | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 3               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 2000.00              | 250.00               | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 4               | 500.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 1500.00              | 500.00               | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 2               | 7000.00              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 1000.00              | 3600.00              | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 3               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 2000.00              | 650.00               | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 4               | 500.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 1500.00              | 500.00               | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 2               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -1600.00             | -1600.00             | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 3               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -400.00              | -400.00              | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 4               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 2               | 7000.00              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -600.00              | 2000.00              | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 3               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 1600.00              | 250.00               | ?                    | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 4               | 500.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 1500.00              | 500.00               | ?                    | ?                    | ?                    | 
And   the override date is '06/06/2018'
When   The following Summarised Actuals for period 'APPS13' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 2               | 7000.00              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 2000.00              | 1000.00              | 2000.00              | 1000.00              | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 3               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 2000.00              | 250.00               | 750.00               | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 4               | 500.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 500.00               | 1500.00              | 500.00               | 500.00               | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 2               | 7000.00              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 1000.00              | 3600.00              | 4600.00              | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 3               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 2000.00              | 650.00               | 1150.00              | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 4               | 500.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 1500.00              | 500.00               | 1000.00              | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 2               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -1600.00             | -1600.00             | -4500.00             | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 3               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -400.00              | -400.00              | -1000.00             | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 4               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-17               | Sep-17               | Oct-17               | Nov-17               | Dec-17               | Jan-18               | Feb-18               | Mar-18               | Apr-18               | May-18               | Jun-18               | Jul-18               | 
 | MAIN-5555      | ANL-5555      | 2               | 7000.00              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -600.00              | 2000.00              | 100.00               | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 3               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 1600.00              | 250.00               | 150.00               | ?                    | ?                    | 
 | MAIN-5555      | ANL-5555      | 4               | 500.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 1500.00              | 500.00               | 1000.00              | ?                    | ?                    | 
And   the override date is reset

@Complete @DoNotRun_7Mar2024 @CappingApportionmentOrder
Scenario: D056 16-18 Non-Levy Apps (16-18NLA1617) #1
Given there is no payment schedule data for contract 'MAIN-5656' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 56123456 | MAIN-5656      | 16NL-5656     | 16-18NLA          | 16-18NLA1617            | AY                      | 01/05/2017          | 31/07/2017        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 1               | 0                     | 1000.00              | 1500.00              | 2000.00              | 
 | MAIN-5656      | 16NL-5656     | 2               | 0                     | ?                    | ?                    | ?                    |
 | MAIN-5656      | 16NL-5656     | 3               | 0                     | ?                    | ?                    | ?                    |
 | MAIN-5656      | 16NL-5656     | 4               | 0                     | ?                    | ?                    | ?                    |

And   the override date is '06/06/2017'
When   The following Summarised Actuals for period 'APPS01' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 2               | 2000.00              | ?                    | ?                    | 
 | MAIN-5656      | 16NL-5656     | 3               | 1000.00              | ?                    | ?                    | 
 | MAIN-5656      | 16NL-5656     | 4               | 1500.00              | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 2               | 2000.00              | ?                    | ?                    | 
 | MAIN-5656      | 16NL-5656     | 3               | 1000.00              | ?                    | ?                    | 
 | MAIN-5656      | 16NL-5656     | 4               | 1500.00              | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 2               | 0.00                 | ?                    | ?                    | 
 | MAIN-5656      | 16NL-5656     | 3               | 0.00                 | ?                    | ?                    | 
 | MAIN-5656      | 16NL-5656     | 4               | 0.00                 | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 2               | 2000.00              | ?                    | ?                    | 
 | MAIN-5656      | 16NL-5656     | 3               | 1000.00              | ?                    | ?                    | 
 | MAIN-5656      | 16NL-5656     | 4               | 1500.00              | ?                    | ?                    | 
And   the override date is '06/07/2017'
When   The following Summarised Actuals for period 'APPS02' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 2               | 1000.00              | 1000.00              | ?                    | 
 | MAIN-5656      | 16NL-5656     | 3               | 2000.00              | 1500.00              | ?                    | 
 | MAIN-5656      | 16NL-5656     | 4               | 1000.00              | 2000.00              | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 2               | 2000.00              | 0.00                 | ?                    | 
 | MAIN-5656      | 16NL-5656     | 3               | 1000.00              | 2500.00              | ?                    | 
 | MAIN-5656      | 16NL-5656     | 4               | 1500.00              | 1500.00              | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 2               | 0.00                 | -1454.55             | ?                    | 
 | MAIN-5656      | 16NL-5656     | 3               | 0.00                 | -2545.45             | ?                    | 
 | MAIN-5656      | 16NL-5656     | 4               | 0.00                 | 0.00                 | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 2               | 2000.00              | -1454.55             | ?                    | 
 | MAIN-5656      | 16NL-5656     | 3               | 1000.00              | -45.45               | ?                    | 
 | MAIN-5656      | 16NL-5656     | 4               | 1500.00              | 1500.00              | ?                    | 
And   the override date is '04/08/2017'
When   The following Summarised Actuals for period 'APPS03' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 2               | 2000.00              | 1000.00              | 2000.00              | 
 | MAIN-5656      | 16NL-5656     | 3               | 1000.00              | 1500.00              | 1000.00              | 
 | MAIN-5656      | 16NL-5656     | 4               | 1500.00              | 2000.00              | 1500.00              | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 2               | 2000.00              | 0.00                 | 4454.55              | 
 | MAIN-5656      | 16NL-5656     | 3               | 1000.00              | 2500.00              | 2545.45              | 
 | MAIN-5656      | 16NL-5656     | 4               | 1500.00              | 1500.00              | 2000.00              | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 2               | 0.00                 | -1454.55             | -5000.00             | 
 | MAIN-5656      | 16NL-5656     | 3               | 0.00                 | -2545.45             | -3500.00             | 
 | MAIN-5656      | 16NL-5656     | 4               | 0.00                 | 0.00                 | -500.00              | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 2               | 2000.00              | -1454.55             | -545.45              | 
 | MAIN-5656      | 16NL-5656     | 3               | 1000.00              | -45.45               | -954.55              | 
 | MAIN-5656      | 16NL-5656     | 4               | 1500.00              | 1500.00              | 1500.00              | 
And   the override date is '05/08/2017'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 1               | 0                     | 2000.00              | 2000.00              | 2000.00              | 
 | MAIN-5656      | 16NL-5656     | 2               | 1                     | 0.00                 | 0.00                 | 0.00                 | 
 | MAIN-5656      | 16NL-5656     | 3               | 1                     | 0.00                 | 0.00                 | 0.00                 | 
 | MAIN-5656      | 16NL-5656     | 4               | 1                     | 0.00                 | 0.00                 | 0.00                 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 2               | 2000.00              | 0.00                 | 4454.55              | 
 | MAIN-5656      | 16NL-5656     | 3               | 1000.00              | 2500.00              | 2545.45              | 
 | MAIN-5656      | 16NL-5656     | 4               | 1500.00              | 1500.00              | 2000.00              | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 2               | 0.00                 | -1454.55             | -4411.76             | 
 | MAIN-5656      | 16NL-5656     | 3               | 0.00                 | -2545.45             | -3088.24             | 
 | MAIN-5656      | 16NL-5656     | 4               | 0.00                 | 0.00                 | 0.00                 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5656      | 16NL-5656     | 2               | 2000.00              | -1454.55             | 42.79                | 
 | MAIN-5656      | 16NL-5656     | 3               | 1000.00              | -45.45               | -542.79              | 
 | MAIN-5656      | 16NL-5656     | 4               | 1500.00              | 1500.00              | 2000.00              | 
And   the override date is reset

@Complete @DoNotRun_7Mar2024 @CappingApportionmentOrder
Scenario: D057 16-18 Non-Levy Apps (16-18NLA1617) #2
Given there is no payment schedule data for contract 'MAIN-5757' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 57123456 | MAIN-5757      | 16NL-5757     | 16-18NLA          | 16-18NLA1617            | AY                      | 01/05/2017          | 31/07/2017        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5757      | 16NL-5757     | 1               | 0                     | 2000.00              | 2000.00              | 2000.00              | 
 | MAIN-5757      | 16NL-5757     | 2               | 0                     | ?                    | ?                    | ?                    |
 | MAIN-5757      | 16NL-5757     | 3               | 0                     | ?                    | ?                    | ?                    |
 | MAIN-5757      | 16NL-5757     | 4               | 0                     | ?                    | ?                    | ?                    |

And   the override date is '06/06/2017'
When   The following Summarised Actuals for period 'APPS01' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5757      | 16NL-5757     | 2               | 5000.00              | ?                    | ?                    | 
 | MAIN-5757      | 16NL-5757     | 3               | 3500.00              | ?                    | ?                    | 
 | MAIN-5757      | 16NL-5757     | 4               | 5000.00              | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5757      | 16NL-5757     | 2               | 5000.00              | ?                    | ?                    | 
 | MAIN-5757      | 16NL-5757     | 3               | 3500.00              | ?                    | ?                    | 
 | MAIN-5757      | 16NL-5757     | 4               | 5000.00              | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5757      | 16NL-5757     | 2               | -4411.76             | ?                    | ?                    | 
 | MAIN-5757      | 16NL-5757     | 3               | -3088.24             | ?                    | ?                    | 
 | MAIN-5757      | 16NL-5757     | 4               | 0.00                 | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5757      | 16NL-5757     | 2               | 588.24               | ?                    | ?                    | 
 | MAIN-5757      | 16NL-5757     | 3               | 411.76               | ?                    | ?                    | 
 | MAIN-5757      | 16NL-5757     | 4               | 5000.00              | ?                    | ?                    | 
And   the override date is '06/07/2017'
When   The following Summarised Actuals for period 'APPS02' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5757      | 16NL-5757     | 2               | 0.00                 | 2000.00              | ?                    | 
 | MAIN-5757      | 16NL-5757     | 3               | 0.00                 | 1000.00              | ?                    | 
 | MAIN-5757      | 16NL-5757     | 4               | 0.00                 | 1500.00              | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5757      | 16NL-5757     | 2               | 5000.00              | 1411.76              | ?                    | 
 | MAIN-5757      | 16NL-5757     | 3               | 3500.00              | 588.24               | ?                    | 
 | MAIN-5757      | 16NL-5757     | 4               | 5000.00              | -3500.00             | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5757      | 16NL-5757     | 2               | -4411.76             | 0.00                 | ?                    | 
 | MAIN-5757      | 16NL-5757     | 3               | -3088.24             | 0.00                 | ?                    | 
 | MAIN-5757      | 16NL-5757     | 4               | 0.00                 | 0.00                 | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5757      | 16NL-5757     | 2               | 588.24               | 1411.76              | ?                    | 
 | MAIN-5757      | 16NL-5757     | 3               | 411.76               | 588.24               | ?                    | 
 | MAIN-5757      | 16NL-5757     | 4               | 5000.00              | -3500.00             | ?                    | 
And   the override date is '04/08/2017'
When   The following Summarised Actuals for period 'APPS03' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5757      | 16NL-5757     | 2               | 2000.00              | 1000.00              | 2000.00              | 
 | MAIN-5757      | 16NL-5757     | 3               | 1000.00              | 1500.00              | 1000.00              | 
 | MAIN-5757      | 16NL-5757     | 4               | 500.00               | 500.00               | 500.00               | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5757      | 16NL-5757     | 2               | 5000.00              | 1411.76              | 3000.00              | 
 | MAIN-5757      | 16NL-5757     | 3               | 3500.00              | 588.24               | 2500.00              | 
 | MAIN-5757      | 16NL-5757     | 4               | 5000.00              | -3500.00             | 0.00                 | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5757      | 16NL-5757     | 2               | -4411.76             | 0.00                 | -2352.94             | 
 | MAIN-5757      | 16NL-5757     | 3               | -3088.24             | 0.00                 | -1647.06             | 
 | MAIN-5757      | 16NL-5757     | 4               | 0.00                 | 0.00                 | 0.00                 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5757      | 16NL-5757     | 2               | 588.24               | 1411.76              | 647.06               | 
 | MAIN-5757      | 16NL-5757     | 3               | 411.76               | 588.24               | 852.94               | 
 | MAIN-5757      | 16NL-5757     | 4               | 5000.00              | -3500.00             | 0.00                 | 
And   the override date is reset

@Complete @DoNotRun_7Mar2024 @CappingApportionmentOrder
Scenario: D058 Adult Non-Levy Apps (ANLA1617) #1
Given there is no payment schedule data for contract 'MAIN-5858' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 58123456 | MAIN-5858      | ANL-5858      | ANLA              | ANLA1617                | AY                      | 01/05/2017          | 31/07/2017        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 1               | 0                     | 2500.00              | 5000.00              | 2500.00              | 
 | MAIN-5858      | ANL-5858      | 2               | 0                     | ?                    | ?                    | ?                    |
 | MAIN-5858      | ANL-5858      | 3               | 0                     | ?                    | ?                    | ?                    |
 | MAIN-5858      | ANL-5858      | 4               | 0                     | ?                    | ?                    | ?                    |
And   the override date is '06/06/2017'
When   The following Summarised Actuals for period 'APPS01' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 2               | 15000.00             | ?                    | ?                    | 
 | MAIN-5858      | ANL-5858      | 3               | 11000.00             | ?                    | ?                    | 
 | MAIN-5858      | ANL-5858      | 4               | 10000.00             | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 2               | 15000.00             | ?                    | ?                    | 
 | MAIN-5858      | ANL-5858      | 3               | 11000.00             | ?                    | ?                    | 
 | MAIN-5858      | ANL-5858      | 4               | 10000.00             | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 2               | -15000.00            | ?                    | ?                    | 
 | MAIN-5858      | ANL-5858      | 3               | -11000.00            | ?                    | ?                    | 
 | MAIN-5858      | ANL-5858      | 4               | 0.00                 | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 2               | 0.00                 | ?                    | ?                    | 
 | MAIN-5858      | ANL-5858      | 3               | 0.00                 | ?                    | ?                    | 
 | MAIN-5858      | ANL-5858      | 4               | 10000.00             | ?                    | ?                    | 
And   the override date is '06/07/2017'
When   The following Summarised Actuals for period 'APPS02' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 2               | 10000.00             | 10000.00             | ?                    | 
 | MAIN-5858      | ANL-5858      | 3               | 9000.00              | 11000.00             | ?                    | 
 | MAIN-5858      | ANL-5858      | 4               | 9000.00              | 2000.00              | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 2               | 15000.00             | 20000.00             | ?                    | 
 | MAIN-5858      | ANL-5858      | 3               | 11000.00             | 20000.00             | ?                    | 
 | MAIN-5858      | ANL-5858      | 4               | 10000.00             | 1000.00              | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 2               | -15000.00            | -20000.00            | ?                    | 
 | MAIN-5858      | ANL-5858      | 3               | -11000.00            | -20000.00            | ?                    | 
 | MAIN-5858      | ANL-5858      | 4               | 0.00                 | -1000.00             | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 2               | 0.00                 | 0.00                 | ?                    | 
 | MAIN-5858      | ANL-5858      | 3               | 0.00                 | 0.00                 | ?                    | 
 | MAIN-5858      | ANL-5858      | 4               | 10000.00             | 0.00                 | ?                    | 
And   the override date is '01/08/2017'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 1               | 0                     | 17000.00             | 17000.00             | 17000.00             | 
 | MAIN-5858      | ANL-5858      | 2               | 1                     | 0.00                 | 0.00                 | 0.00                 | 
 | MAIN-5858      | ANL-5858      | 3               | 1                     | 0.00                 | 0.00                 | 0.00                 | 
 | MAIN-5858      | ANL-5858      | 4               | 1                     | 0.00                 | 0.00                 | 0.00                 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 2               | 15000.00             | 20000.00             | 20000.00             | 
 | MAIN-5858      | ANL-5858      | 3               | 11000.00             | 20000.00             | 20000.00             | 
 | MAIN-5858      | ANL-5858      | 4               | 10000.00             | 1000.00              | 1000.00              | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 2               | -15000.00            | -20000.00            | 0.00                 | 
 | MAIN-5858      | ANL-5858      | 3               | -11000.00            | -20000.00            | 0.00                 | 
 | MAIN-5858      | ANL-5858      | 4               | 0.00                 | -1000.00             | 0.00                 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 2               | 0.00                 | 0.00                 | 20000.00             | 
 | MAIN-5858      | ANL-5858      | 3               | 0.00                 | 0.00                 | 20000.00             | 
 | MAIN-5858      | ANL-5858      | 4               | 10000.00             | 0.00                 | 1000.00              | 
And   the override date is '04/08/2017'
When   The following Summarised Actuals for period 'APPS03' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 2               | 10000.00             | 5000.00              | 5000.00              | 
 | MAIN-5858      | ANL-5858      | 3               | 5000.00              | 6000.00              | 7000.00              | 
 | MAIN-5858      | ANL-5858      | 4               | 500.00               | 600.00               | 700.00               | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 2               | 15000.00             | 20000.00             | 20000.00             | 
 | MAIN-5858      | ANL-5858      | 3               | 11000.00             | 20000.00             | 18000.00             | 
 | MAIN-5858      | ANL-5858      | 4               | 10000.00             | 1000.00              | -8200.00             | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 2               | -15000.00            | -20000.00            | 0.00                 | 
 | MAIN-5858      | ANL-5858      | 3               | -11000.00            | -20000.00            | 0.00                 | 
 | MAIN-5858      | ANL-5858      | 4               | 0.00                 | -1000.00             | 0.00                 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5858      | ANL-5858      | 2               | 0.00                 | 0.00                 | 20000.00             | 
 | MAIN-5858      | ANL-5858      | 3               | 0.00                 | 0.00                 | 18000.00             | 
 | MAIN-5858      | ANL-5858      | 4               | 10000.00             | 0.00                 | -8200.00             | 
And   the override date is reset

@Complete @DoNotRun_7Mar2024 @CappingApportionmentOrder
Scenario: D059 Adult Non-Levy Apps (ANLA1617) #2
Given there is no payment schedule data for contract 'MAIN-5959' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 59123456 | MAIN-5959      | ANL-5959      | ANLA              | ANLA1617                | AY                      | 01/05/2017          | 31/07/2017        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5959      | ANL-5959      | 1               | 0                     | 17000.00             | 17000.00             | 17000.00             | 
 | MAIN-5959      | ANL-5959      | 2               | 0                     | ?                    | ?                    | ?                    |
 | MAIN-5959      | ANL-5959      | 3               | 0                     | ?                    | ?                    | ?                    |
 | MAIN-5959      | ANL-5959      | 4               | 0                     | ?                    | ?                    | ?                    |

And   the override date is '06/06/2017'
When   The following Summarised Actuals for period 'APPS01' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5959      | ANL-5959      | 2               | 20000.00             | ?                    | ?                    | 
 | MAIN-5959      | ANL-5959      | 3               | 18000.00             | ?                    | ?                    | 
 | MAIN-5959      | ANL-5959      | 4               | 1800.00              | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5959      | ANL-5959      | 2               | 20000.00             | ?                    | ?                    | 
 | MAIN-5959      | ANL-5959      | 3               | 18000.00             | ?                    | ?                    | 
 | MAIN-5959      | ANL-5959      | 4               | 1800.00              | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5959      | ANL-5959      | 2               | 0.00                 | ?                    | ?                    | 
 | MAIN-5959      | ANL-5959      | 3               | 0.00                 | ?                    | ?                    | 
 | MAIN-5959      | ANL-5959      | 4               | 0.00                 | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5959      | ANL-5959      | 2               | 20000.00             | ?                    | ?                    | 
 | MAIN-5959      | ANL-5959      | 3               | 18000.00             | ?                    | ?                    | 
 | MAIN-5959      | ANL-5959      | 4               | 1800.00              | ?                    | ?                    | 
And   the override date is '06/07/2017'
When   The following Summarised Actuals for period 'APPS02' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5959      | ANL-5959      | 2               | 0.00                 | 30000.00             | ?                    | 
 | MAIN-5959      | ANL-5959      | 3               | 15000.00             | 0.00                 | ?                    | 
 | MAIN-5959      | ANL-5959      | 4               | 12000.00             | 0.00                 | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5959      | ANL-5959      | 2               | 20000.00             | 10000.00             | ?                    | 
 | MAIN-5959      | ANL-5959      | 3               | 18000.00             | -3000.00             | ?                    | 
 | MAIN-5959      | ANL-5959      | 4               | 1800.00              | 10200.00             | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5959      | ANL-5959      | 2               | 0.00                 | -4000.00             | ?                    | 
 | MAIN-5959      | ANL-5959      | 3               | 0.00                 | -2000.00             | ?                    | 
 | MAIN-5959      | ANL-5959      | 4               | 0.00                 | 0.00                 | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5959      | ANL-5959      | 2               | 20000.00             | 6000.00              | ?                    | 
 | MAIN-5959      | ANL-5959      | 3               | 18000.00             | -5000.00             | ?                    | 
 | MAIN-5959      | ANL-5959      | 4               | 1800.00              | 10200.00             | ?                    | 
And   the override date is '04/08/2017'
When   The following Summarised Actuals for period 'APPS03' for collection type 'APPS' are processed
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5959      | ANL-5959      | 2               | 10000.00             | 5000.00              | 5000.00              | 
 | MAIN-5959      | ANL-5959      | 3               | 5000.00              | 6000.00              | 7000.00              | 
 | MAIN-5959      | ANL-5959      | 4               | 0.00                 | 0.00                 | 0.00                 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5959      | ANL-5959      | 2               | 20000.00             | 10000.00             | -6000.00             | 
 | MAIN-5959      | ANL-5959      | 3               | 18000.00             | -3000.00             | 5000.00              | 
 | MAIN-5959      | ANL-5959      | 4               | 1800.00              | 10200.00             | -12000.00            | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5959      | ANL-5959      | 2               | 0.00                 | -4000.00             | 0.00                 | 
 | MAIN-5959      | ANL-5959      | 3               | 0.00                 | -2000.00             | 0.00                 | 
 | MAIN-5959      | ANL-5959      | 4               | 0.00                 | 0.00                 | 0.00                 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | May-17               | Jun-17               | Jul-17               | 
 | MAIN-5959      | ANL-5959      | 2               | 20000.00             | 6000.00              | -6000.00             | 
 | MAIN-5959      | ANL-5959      | 3               | 18000.00             | -5000.00             | 5000.00              | 
 | MAIN-5959      | ANL-5959      | 4               | 1800.00              | 10200.00             | -12000.00            | 
And   the override date is reset
