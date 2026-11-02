Feature: AEB-19TRN2021 - PoA

@DoNotRun_7Mar2024
Scenario: D097 PoA 10 AEB-19TRN2021
Given there is no payment schedule data for contract 'AEBP-2639' version '1'
And the approved contract allocations details for the latest version of the contract are as follows
| UKPRN | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
| 10101010 | AEBP-2639 | AEBR-1326 | AEB-19TRN | AEB-19TRN2021 | AY | 01/08/2020 | 31/07/2021 |
And the contract deliverables details for the latest version of the contract are as follows
| ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 1 | 0 | 3354.00 | 3866.00 | 3993.00 | 3613.00 | 2821.00 | 3583.00 | 3545.00 | 3587.00 | 3519.00 | 3160.00 | 3651.00 | 3608.00 |
| AEBP-2639 | AEBR-1326 | 2 | 1 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |
| AEBP-2639 | AEBR-1326 | 3 | 1 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |
And the override date is '04/09/2020'
When The following Summarised Actuals for period 'R01' for collection type 'ILR2021' are processed
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
Then the Reconciliation Data is calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the Capping Amounts are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the Net Payments are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the override date is '24/09/2020'
When the contract is amended as follows
| ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 1 | 0 | 3354.00 | 3866.00 | 3993.00 | 3613.00 | 2821.00 | 3583.00 | 3545.00 | 3587.00 | 3519.00 | 3160.00 | 3651.00 | 3608.00 |
| AEBP-2639 | AEBR-1326 | 2 | 1 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |
| AEBP-2639 | AEBR-1326 | 3 | 1 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |
Then the Reconciliation Data is calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the Capping Amounts are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the Net Payments are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the override date is '06/10/2020'
When The following Summarised Actuals for period 'R02' for collection type 'ILR2021' are processed
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
Then the Reconciliation Data is calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the Capping Amounts are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the Net Payments are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the override date is '05/11/2020'
When The following Summarised Actuals for period 'R03' for collection type 'ILR2021' are processed
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? |
Then the Reconciliation Data is calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the Capping Amounts are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the Net Payments are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the override date is '13/11/2020'
When the contract is amended as follows
| ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 1 | 0 | 5745.00 | 6621.00 | 6838.00 | 6186.00 | 4832.00 | 6136.00 | 6071.00 | 6143.00 | 4729.00 | 4246.00 | 4905.00 | 4848.00 |
| AEBP-2639 | AEBR-1326 | 2 | 1 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |
| AEBP-2639 | AEBR-1326 | 3 | 1 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |
Then the Reconciliation Data is calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? |
And the Capping Amounts are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? |
And the Net Payments are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? |
And the override date is '04/12/2020'
When The following Summarised Actuals for period 'R04' for collection type 'ILR2021' are processed
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 1419.71 | 27157.73 | 23791.84 | 18365.55 | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? |
Then the Reconciliation Data is calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | 0.00 | 70734.83 | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? |
And the Capping Amounts are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | 0.00 | -17305.63 | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? |
And the Net Payments are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | 0.00 | 53429.20 | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? |
And the override date is '14/12/2020'
When the contract is amended as follows
| ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 1 | 0 | 5745.00 | 6621.00 | 6838.00 | 6186.00 | 4832.00 | 6136.00 | 6071.00 | 6143.00 | 4729.00 | 4246.00 | 4905.00 | 4848.00 |
| AEBP-2639 | AEBR-1326 | 2 | 1 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |
| AEBP-2639 | AEBR-1326 | 3 | 1 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |
Then the Reconciliation Data is calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | 0.00 | 70734.83 | 17305.63 | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? |
And the Capping Amounts are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | 0.00 | -17305.63 | -17305.63 | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? |
And the Net Payments are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | 0.00 | 53429.20 | 0.00 | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? |
And the override date is '07/01/2021'
When The following Summarised Actuals for period 'R05' for collection type 'ILR2021' are processed
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 1419.71 | 27419.53 | 25312.69 | 20258.01 | 12332.22 | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? |
Then the Reconciliation Data is calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | 0.00 | 70734.83 | 33312.96 | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? |
And the Capping Amounts are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | 0.00 | -17305.63 | -33312.96 | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? |
And the Net Payments are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2639 | AEBR-1326 | 2 | 0.00 | 0.00 | 0.00 | 53429.20 | 0.00 | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2639 | AEBR-1326 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? |
And the override date is reset
