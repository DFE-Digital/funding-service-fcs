Feature: PYE_AGE

@IntegrationTestInProgress
Scenario: Post-year-end - AGE Calcs on receipt of actuals after the end of the allocation. 
Given there is no payment schedule data for contract 'EMPAGE-1234' version '1'
And the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 12345678 | EMPAGE-1234    | AGE-1234      | AGE               | AGE1516                 | FY                      | 01/04/2015          | 31/03/2016        | 
And the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 0                     | 100.00 | 101.00 | 102.00 | 103.00 | 104.00 | 105.00 | 106.00 | 107.00 | 108.00 | 109.00 | 110.00 | 111.00 |
 | EMPAGE-1234    | AGE-1234      | 2               | 0                     | 50.00  | 51.00  | 52.00  | 53.00  | 54.00  | 55.00  | 56.00  | 57.00  | 58.00  | 59.00  | 60.00  | 61.00  | 
And the override date is '16/03/2016'
When The following Summarised Actuals for period 'G11' for collection type 'AGE' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 50.00  | 51.00  | 52.00  | 53.00  | 54.00  | 55.00  | 56.00  | 57.00  | 58.00  | 59.00  | 60.00  | ?      |
 | EMPAGE-1234    | AGE-1234      | 2               | 25.00  | 26.00  | 27.00  | 28.00  | 29.00  | 30.00  | 31.00  | 32.00  | 33.00  | 34.00  | 35.00  | ?      | 
Then the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | ?      |
 | EMPAGE-1234    | AGE-1234      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | ?      | 
And the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      |
 | EMPAGE-1234    | AGE-1234      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | 
And the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | ?      |
 | EMPAGE-1234    | AGE-1234      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | ?      | 
And the override date is '18/04/2016'
When The following Summarised Actuals for period 'G12' for collection type 'AGE' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 50.00  | 52.00  | 54.00  | 56.00  | 58.00  | 60.00  | 62.00  | 64.00  | 66.00  | 68.00  | 70.00  | 72.00  |
 | EMPAGE-1234    | AGE-1234      | 2               | 25.00  | 24.00  | 23.00  | 22.00  | 21.00  | 20.00  | 19.00  | 18.00  | 17.00  | 16.00  | 15.00  | 14.00  | 
Then the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 127.00 |
 | EMPAGE-1234    | AGE-1234      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | -96.00 | 
And the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
 | EMPAGE-1234    | AGE-1234      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 
And the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 127.00 |
 | EMPAGE-1234    | AGE-1234      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | -96.00 | 
And the override date is '18/05/2016'
When The following Summarised Actuals for period 'G13' for collection type 'AGE' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 50.00  | 53.00  | 56.00  | 59.00  | 62.00  | 65.00  | 68.00  | 71.00  | 74.00  | 77.00  | 80.00  | 83.00  |
 | EMPAGE-1234    | AGE-1234      | 2               | 25.00  | 24.50  | 24.00  | 23.50  | 23.00  | 22.50  | 22.00  | 21.50  | 21.00  | 20.50  | 20.00  | 19.50  | 
Then the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 127.00 | 66.00  |
 | EMPAGE-1234    | AGE-1234      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | -96.00 | 33.00  | 
And the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
 | EMPAGE-1234    | AGE-1234      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 
And the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 |
 | EMPAGE-1234    | AGE-1234      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 127.00 | 66.00  |
 | EMPAGE-1234    | AGE-1234      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | -96.00 | 33.00  | 
And the override date is reset


@IntegrationTestInProgress
Scenario: Post-year-end AGE - Calcs on receipt of actuals and amendments after allocation end date.
Given there is no payment schedule data for contract 'EMPAGE-1235' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 12345679 | EMPAGE-1235    | AGE-1235      | AGE               | AGE1516                 | FY                      | 01/04/2015          | 31/03/2016        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 0                     | 100.00 | 101.00 | 102.00 | 103.00 | 104.00 | 105.00 | 106.00 | 107.00 | 108.00 | 109.00 | 110.00 | 111.00 |
 | EMPAGE-1235    | AGE-1235      | 2               | 0                     | 50.00  | 51.00  | 52.00  | 53.00  | 54.00  | 55.00  | 56.00  | 57.00  | 58.00  | 59.00  | 60.00  | 61.00  | 
And   the override date is '16/03/2016'
When   The following Summarised Actuals for period 'G11' for collection type 'AGE' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 50.00  | 51.00  | 52.00  | 53.00  | 54.00  | 55.00  | 56.00  | 57.00  | 58.00  | 59.00  | 60.00  | ?      |
 | EMPAGE-1235    | AGE-1235      | 2               | 25.00  | 26.00  | 27.00  | 28.00  | 29.00  | 30.00  | 31.00  | 32.00  | 33.00  | 34.00  | 35.00  | ?      | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | ?      |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | ?      | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | ?      |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | ?      | 
And   the override date is '18/04/2016'
When   The following Summarised Actuals for period 'G12' for collection type 'AGE' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16  |
 | EMPAGE-1235    | AGE-1235      | 1               | 50.00  | 51.00  | 52.00  | 53.00  | 54.00  | 55.00  | 56.00  | 57.00  | 58.00  | 59.00  | 60.00  | 1000.00 |
 | EMPAGE-1235    | AGE-1235      | 2               | 25.00  | 26.00  | 27.00  | 28.00  | 29.00  | 30.00  | 31.00  | 32.00  | 33.00  | 34.00  | 35.00  | 1500.00 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16  |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 1000.00 |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | 1500.00 | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16   |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -339.00  |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -1164.00 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 661.00 |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | 336.00 | 
And   the override date is '30/04/2016'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16  |
 | EMPAGE-1235    | AGE-1235      | 1               | 0                     | 100.00 | 101.00 | 102.00 | 103.00 | 104.00 | 105.00 | 106.00 | 107.00 | 108.00 | 109.00 | 110.00 | 1000.00 |
 | EMPAGE-1235    | AGE-1235      | 2               | 0                     | 50.00  | 51.00  | 52.00  | 53.00  | 54.00  | 55.00  | 56.00  | 57.00  | 58.00  | 59.00  | 60.00  | 1500.00 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16  | Apr-16  |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 1000.00 | 339.00  |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | 1500.00 | 1164.00 | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16   | Apr-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -339.00  | 0.00   |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -1164.00 | 0.00   | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16  |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 661.00 | 339.00  |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | 336.00 | 1164.00 | 
And   the override date is '18/05/2016'
When   The following Summarised Actuals for period 'G13' for collection type 'AGE' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16  |
 | EMPAGE-1235    | AGE-1235      | 1               | 50.00  | 51.00  | 52.00  | 53.00  | 54.00  | 55.00  | 56.00  | 57.00  | 58.00  | 59.00  | 60.00  | 2000.00 |
 | EMPAGE-1235    | AGE-1235      | 2               | 25.00  | 26.00  | 27.00  | 28.00  | 29.00  | 30.00  | 31.00  | 32.00  | 33.00  | 34.00  | 35.00  | 1500.00 | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16  | Apr-16  |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 1000.00 | 1339.00 |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | 1500.00 | 1164.00 | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16   | Apr-16  |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -339.00  | -450.00 |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -1164.00 | 0.00    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16  |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 661.00 | 889.00  |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | 336.00 | 1164.00 | 
And   the override date is '31/05/2016'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16  |
 | EMPAGE-1235    | AGE-1235      | 1               | 0                     | 100.00 | 101.00 | 102.00 | 103.00 | 104.00 | 105.00 | 106.00 | 107.00 | 108.00 | 109.00 | 110.00 | 2000.00 |
 | EMPAGE-1235    | AGE-1235      | 2               | 0                     | 50.00  | 51.00  | 52.00  | 53.00  | 54.00  | 55.00  | 56.00  | 57.00  | 58.00  | 59.00  | 60.00  | 500.00  | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16  | Apr-16  | May-16 |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 1000.00 | 1339.00 | 450.00 |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | 1500.00 | 1164.00 | 0.00   | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16   | Apr-16  | May-16  |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -339.00  | -450.00 | 0.00    |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | -1164.00 | 0.00    | -725.00 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16  | May-16  |
 | EMPAGE-1235    | AGE-1235      | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 661.00 | 889.00  | 450.00  |
 | EMPAGE-1235    | AGE-1235      | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | 336.00 | 1164.00 | -725.00 | 
And   the override date is reset