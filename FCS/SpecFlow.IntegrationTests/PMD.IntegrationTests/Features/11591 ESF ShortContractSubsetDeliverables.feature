Feature: 11591 ESF ShortContractSubsetDeliverables

@DoNotRun_7Mar2024
Scenario: D235 ESF - Subset of deliverables and short contract
Given there is no payment schedule data for contract 'ESIF-1235' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | EsfRegionType  | EsfInvestmentPriority |
 | 12345678 | ESIF-1235      | ESF-1235      | ESF 201420        | ESF1420                 | ESF                     | 01/03/2017          | 30/04/2017        | Less Developed | 1.10                  |
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Mar-17               | Apr-17               | 
 | ESIF-1235      | ESF-1235      | 2               | 0                     | 1000.00              | 1100.00              | 
 | ESIF-1235      | ESF-1235      | 4               | 0                     | 10000.00             | 20000.00             | 
And   the override date is '06/04/2017'
#When   The following Summarised Actuals for period 'F12' for collection type 'ESF' are processed
When   The following Summarised Actuals for period 'F12' for collection type 'ESF' are processed without aggregations
 | ContractNumber | AllocationRef | DeliverableCode | Mar-17               | Apr-17               | 
 | ESIF-1235      | ESF-1235      | 2               | 1500.00              | ?                    | 
 | ESIF-1235      | ESF-1235      | 4               | 31000.00             | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Mar-17               | Apr-17               | 
 | ESIF-1235      | ESF-1235      | 2               | 1500.00              | ?                    | 
 | ESIF-1235      | ESF-1235      | 4               | 31000.00             | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Mar-17               | Apr-17               | 
 | ESIF-1235      | ESF-1235      | 2               | 0.00                 | ?                    | 
 | ESIF-1235      | ESF-1235      | 4               | -1000.00             | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Mar-17               | Apr-17               | 
 | ESIF-1235      | ESF-1235      | 2               | 1500.00              | ?                    | 
 | ESIF-1235      | ESF-1235      | 4               | 30000.00             | ?                    | 
And   the override date is '30/04/2017'
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Mar-17               | Apr-17               | 
 | ESIF-1235      | ESF-1235      | 2               | 0                     | 1000.00              | 400.00               | 
 | ESIF-1235      | ESF-1235      | 3               | 0                     | 0.00                 | 6000.00              | 
 | ESIF-1235      | ESF-1235      | 4               | 0                     | 20000.00             | 20000.00             | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Mar-17               | Apr-17               | 
 | ESIF-1235      | ESF-1235      | 2               | 1500.00              | 0.00                 | 
 | ESIF-1235      | ESF-1235      | 3               | 0.00                 | 0.00                 | 
 | ESIF-1235      | ESF-1235      | 4               | 31000.00             | 1000.00              | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Mar-17               | Apr-17               | 
 | ESIF-1235      | ESF-1235      | 2               | 0.00                 | -100.00              | 
 | ESIF-1235      | ESF-1235      | 3               | 0.00                 | 0.00                 | 
 | ESIF-1235      | ESF-1235      | 4               | -1000.00             | 0.00                 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Mar-17               | Apr-17               | 
 | ESIF-1235      | ESF-1235      | 2               | 1500.00              | -100.00              | 
 | ESIF-1235      | ESF-1235      | 3               | 0.00                 | 0.00                 | 
 | ESIF-1235      | ESF-1235      | 4               | 30000.00             | 1000.00              | 
And   the override date is '05/05/2017'
#When   The following Summarised Actuals for period 'F13' for collection type 'ESF' are processed
When   The following Summarised Actuals for period 'F13' for collection type 'ESF' are processed without aggregations
 | ContractNumber | AllocationRef | DeliverableCode | Mar-17               | Apr-17               | 
 | ESIF-1235      | ESF-1235      | 2               | 1500.00              | 100.00               | 
 | ESIF-1235      | ESF-1235      | 3               | 0.00                 | 5000.00              | 
 | ESIF-1235      | ESF-1235      | 4               | 14000.00             | 200.50               | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Mar-17               | Apr-17               | 
 | ESIF-1235      | ESF-1235      | 2               | 1500.00              | 100.00               | 
 | ESIF-1235      | ESF-1235      | 3               | 0.00                 | 5000.00              | 
 | ESIF-1235      | ESF-1235      | 4               | 31000.00             | -15799.50            | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Mar-17               | Apr-17               | 
 | ESIF-1235      | ESF-1235      | 2               | 0.00                 | -200.00              | 
 | ESIF-1235      | ESF-1235      | 3               | 0.00                 | 0.00                 | 
 | ESIF-1235      | ESF-1235      | 4               | -1000.00             | 0.00                 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Mar-17               | Apr-17               | 
 | ESIF-1235      | ESF-1235      | 2               | 1500.00              | -100.00              | 
 | ESIF-1235      | ESF-1235      | 3               | 0.00                 | 5000.00              | 
 | ESIF-1235      | ESF-1235      | 4               | 30000.00             | -15799.50            | 
And   the override date is reset

