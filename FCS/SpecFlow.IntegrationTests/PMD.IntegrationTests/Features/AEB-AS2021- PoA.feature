Feature: AEB-AS2021- PoA

@DoNotRun_7Mar2024
Scenario: D098 PoA 11 AEB-AS2021
Given there is no payment schedule data for contract 'AEBP-2641' version '1'
And the approved contract allocations details for the latest version of the contract are as follows
| UKPRN | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
| 10111011 | AEBP-2641 | AEBA-1762 | AEB-AS | AEB-AS2021 | AY | 01/08/2020 | 31/07/2021 |
And the contract deliverables details for the latest version of the contract are as follows
| ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 1 | 0 | 11285.00 | 13007.00 | 13434.00 | 12153.00 | 9492.00 | 12053.00 | 11925.00 | 12068.00 | 11840.00 | 10630.00 | 12281.00 | 12139.00 |
| AEBP-2641 | AEBA-1762 | 2 | 1 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |
| AEBP-2641 | AEBA-1762 | 3 | 1 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |
And the override date is '04/09/2020'
When The following Summarised Actuals for period 'R01' for collection type 'ILR2021' are processed
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 26830.26 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
Then the Reconciliation Data is calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 26830.26 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the Capping Amounts are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the Net Payments are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 26830.26 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the override date is '24/09/2020'
When the contract is amended as follows
| ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 1 | 0 | 11285.00 | 13007.00 | 13434.00 | 12153.00 | 9492.00 | 12053.00 | 11925.00 | 12068.00 | 11840.00 | 10630.00 | 12281.00 | 12139.00 |
| AEBP-2641 | AEBA-1762 | 2 | 1 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |
| AEBP-2641 | AEBA-1762 | 3 | 1 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |
Then the Reconciliation Data is calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 26830.26 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the Capping Amounts are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the Net Payments are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 26830.26 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the override date is '06/10/2020'
When The following Summarised Actuals for period 'R02' for collection type 'ILR2021' are processed
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 42722.59 | 27008.97 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
Then the Reconciliation Data is calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 26830.26 | 42901.30 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the Capping Amounts are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the Net Payments are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 26830.26 | 42901.30 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the override date is '05/11/2020'
When The following Summarised Actuals for period 'R03' for collection type 'ILR2021' are processed
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 45060.51 | 37970.53 | 27690.50 | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? |
Then the Reconciliation Data is calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 26830.26 | 42901.30 | 40989.98 | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the Capping Amounts are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 0.00 | 0.00 | -12442.03 | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the Net Payments are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 26830.26 | 42901.30 | 28547.95 | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? | ? |
And the override date is '04/12/2020'
When The following Summarised Actuals for period 'R04' for collection type 'ILR2021' are processed
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 45060.51 | 37970.53 | 27690.50 | 12879.91 | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? |
Then the Reconciliation Data is calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 26830.26 | 42901.30 | 40989.98 | 25321.94 | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? |
And the Capping Amounts are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 0.00 | 0.00 | -12442.03 | -25321.94 | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? |
And the Net Payments are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 26830.26 | 42901.30 | 28547.95 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? | ? |
And the override date is '15/12/2020'
When the contract is amended as follows
| ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 1 | 0 | 11469.00 | 13220.00 | 13653.00 | 12352.00 | 9647.00 | 12251.00 | 12120.00 | 12265.00 | 11840.00 | 10630.00 | 12281.00 | 12139.00 |
| AEBP-2641 | AEBA-1762 | 2 | 1 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |
| AEBP-2641 | AEBA-1762 | 3 | 1 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |
Then the Reconciliation Data is calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 26830.26 | 42901.30 | 40989.98 | 25321.94 | 25321.94 | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? |
And the Capping Amounts are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 0.00 | 0.00 | -12442.03 | -25321.94 | -23715.14 | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? |
And the Net Payments are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 26830.26 | 42901.30 | 28547.95 | 0.00 | 1606.80 | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? |
And the override date is '07/01/2021'
When The following Summarised Actuals for period 'R05' for collection type 'ILR2021' are processed
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 45060.51 | 36936.53 | 27173.50 | 12879.91 | 89.80 | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? |
Then the Reconciliation Data is calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 26830.26 | 42901.30 | 40989.98 | 25321.94 | 23860.74 | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? |
And the Capping Amounts are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 0.00 | 0.00 | -12442.03 | -25321.94 | -22253.94 | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? |
And the Net Payments are calculated as follows
| ContractNumber | AllocationRef | DeliverableCode | Aug-20 | Sep-20 | Oct-20 | Nov-20 | Dec-20 | Jan-21 | Feb-21 | Mar-21 | Apr-21 | May-21 | Jun-21 | Jul-21 |
| AEBP-2641 | AEBA-1762 | 2 | 26830.26 | 42901.30 | 28547.95 | 0.00 | 1606.80 | ? | ? | ? | ? | ? | ? | ? |
| AEBP-2641 | AEBA-1762 | 3 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 | ? | ? | ? | ? | ? | ? | ? |
And the override date is reset
