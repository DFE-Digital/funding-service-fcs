Feature: PayOnActualsAllf


@IntegrationTest
Scenario: PoA 22 ALLB2223
	Given there is no payment schedule data for contract 'EDSK-1022' version '1'
	And the approved contract allocations details for the latest version of the contract are as follows
		| UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
		| 10221022 | EDSK-1022      | ALLB-1022     | ALLB              | ALLB2223                | AY                      | 01/08/2022          | 31/07/2023        |
	And the contract deliverables details for the latest version of the contract are as follows
		| ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-22 | Sep-22 | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 1               | 0                     | 140.00 | 140.00 | 140.00 | 140.00 | 140.00 | 140.00 | 140.00 | 142.00 | 203.00 | 203.00 | 203.00 | 203.00 |
		| EDSK-1022      | ALLB-1022     | 2               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
		| EDSK-1022      | ALLB-1022     | 3               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
		| EDSK-1022      | ALLB-1022     | 4               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
	And the override date is '06/09/2022'
	When The following Summarised Actuals for period 'R01' for collection type 'ILR2223' are processed
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22 | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 2000.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	Then the Reconciliation Data is calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22 | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 2000.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	And the Capping Amounts are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22 | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | -878.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	And the Net Payments are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22 | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 1122.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	And the override date is '23/09/2022'
	When the contract is amended as follows
		| ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-22 | Sep-22 | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 1               | 0                     | 500.00 | 500.00 | 500.00 | 500.00 | 500.00 | 500.00 | 500.00 | 500.00 | 400.00 | 400.00 | 400.00 | 400.00 |
		| EDSK-1022      | ALLB-1022     | 2               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
		| EDSK-1022      | ALLB-1022     | 3               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
		| EDSK-1022      | ALLB-1022     | 4               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
	Then the Reconciliation Data is calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22 | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 2000.00 | 878.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	And the Capping Amounts are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22 | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | -878.00 | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	And the Net Payments are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22 | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 1122.00 | 878.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	And the override date is '06/10/2022'
	When The following Summarised Actuals for period 'R02' for collection type 'ILR2223' are processed
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22  | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 2000.00 | 1000.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 100.00  | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 50.00   | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	Then the Reconciliation Data is calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22  | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 2000.00 | 1878.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 100.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 50.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	And the Capping Amounts are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22 | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | -878.00 | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	And the Net Payments are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22  | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 1122.00 | 1878.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 100.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 50.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	And the override date is '04/11/2022'
	When The following Summarised Actuals for period 'R03' for collection type 'ILR2223' are processed
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22  | Oct-22  | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 1000.00 | 1100.00 | 1050.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 300.00  | 290.00  | 310.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 150.00  | 140.00  | 160.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	Then the Reconciliation Data is calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22  | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 2000.00 | 1878.00 | 150.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 100.00  | 800.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 50.00   | 400.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	And the Capping Amounts are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22 | Oct-22  | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | -878.00 | 0.00   | -350.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 0.00   | -100.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 0.00   | -50.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	And the Net Payments are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22  | Oct-22  | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 1122.00 | 1878.00 | -200.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 100.00  | 700.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 50.00   | 350.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	And the override date is '20/11/2022'
	When the contract is amended as follows
		| ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-22 | Sep-22 | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 1               | 0                     | 750.00 | 500.00 | 500.00 | 500.00 | 500.00 | 500.00 | 500.00 | 500.00 | 400.00 | 400.00 | 400.00 | 400.00 |
		| EDSK-1022      | ALLB-1022     | 2               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
		| EDSK-1022      | ALLB-1022     | 3               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
		| EDSK-1022      | ALLB-1022     | 4               | 1                     | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
	Then the Reconciliation Data is calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22  | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 2000.00 | 1878.00 | 150.00 | 350.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 100.00  | 800.00 | 100.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 50.00   | 400.00 | 50.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	And the Capping Amounts are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22 | Oct-22  | Nov-22  | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | -878.00 | 0.00   | -350.00 | -175.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 0.00   | -100.00 | -50.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 0.00   | -50.00  | -25.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	And the Net Payments are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22  | Oct-22  | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 1122.00 | 1878.00 | -200.00 | 175.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 100.00  | 700.00  | 50.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 50.00   | 350.00  | 25.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	And the override date is '05/05/2023'
	When The following Summarised Actuals for period 'R09' for collection type 'ILR2223' are processed
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22 | Sep-22 | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 787.00 | 788.00 | 787.50 | 787.50 | 787.50 | 787.50 | 787.50 | 787.50 | 500.00 | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 225.00 | 230.00 | 220.00 | 225.00 | 225.00 | 225.00 | 225.00 | 225.00 | 100.00 | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 100.00 | 125.00 | 112.50 | 112.50 | 112.50 | 112.50 | 112.50 | 112.50 | 50.00  | ?      | ?      | ?      |
	Then the Reconciliation Data is calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22  | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23  | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 2000.00 | 1878.00 | 150.00 | 350.00 | 0.00   | 0.00   | 0.00   | 0.00   | 3825.00 | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 100.00  | 800.00 | 100.00 | 0.00   | 0.00   | 0.00   | 0.00   | 1050.00 | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 50.00   | 400.00 | 50.00  | 0.00   | 0.00   | 0.00   | 0.00   | 525.00  | ?      | ?      | ?      |
	And the Capping Amounts are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22 | Oct-22  | Nov-22  | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23   | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | -878.00 | 0.00   | -350.00 | -175.00 | 0.00   | 0.00   | 0.00   | 0.00   | -3325.00 | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 0.00   | -100.00 | -50.00  | 0.00   | 0.00   | 0.00   | 0.00   | -950.00  | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 0.00   | -50.00  | -25.00  | 0.00   | 0.00   | 0.00   | 0.00   | -475.00  | ?      | ?      | ?      |
	And the Net Payments are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22  | Oct-22  | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 1122.00 | 1878.00 | -200.00 | 175.00 | 0.00   | 0.00   | 0.00   | 0.00   | 500.00 | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 100.00  | 700.00  | 50.00  | 0.00   | 0.00   | 0.00   | 0.00   | 100.00 | ?      | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 50.00   | 350.00  | 25.00  | 0.00   | 0.00   | 0.00   | 0.00   | 50.00  | ?      | ?      | ?      |
	And the override date is '06/06/2023'
	When The following Summarised Actuals for period 'R10' for collection type 'ILR2223' are processed
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22 | Sep-22 | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23  | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 787.00 | 788.00 | 787.50 | 787.50 | 787.50 | 787.50 | 787.50 | 427.50  | 500.00 | 900.00 | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 225.00 | 230.00 | 220.00 | 225.00 | 225.00 | 225.00 | 225.00 | 405.00  | 100.00 | 300.00 | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 100.00 | 125.00 | 112.50 | 112.50 | 112.50 | 112.50 | 112.50 | 1192.50 | 50.00  | 150.00 | ?      | ?      |
	Then the Reconciliation Data is calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22  | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23  | May-23  | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 2000.00 | 1878.00 | 150.00 | 350.00 | 0.00   | 0.00   | 0.00   | 0.00   | 3825.00 | 3865.00 | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 100.00  | 800.00 | 100.00 | 0.00   | 0.00   | 0.00   | 0.00   | 1050.00 | 1430.00 | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 50.00   | 400.00 | 50.00  | 0.00   | 0.00   | 0.00   | 0.00   | 525.00  | 1705.00 | ?      | ?      |
	And the Capping Amounts are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22 | Oct-22  | Nov-22  | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23   | May-23   | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | -878.00 | 0.00   | -350.00 | -175.00 | 0.00   | 0.00   | 0.00   | 0.00   | -3325.00 | -3670.00 | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 0.00   | -100.00 | -50.00  | 0.00   | 0.00   | 0.00   | 0.00   | -950.00  | -1210.00 | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 0.00   | -50.00  | -25.00  | 0.00   | 0.00   | 0.00   | 0.00   | -475.00  | -1170.00 | ?      | ?      |
	And the Net Payments are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22  | Oct-22  | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 1122.00 | 1878.00 | -200.00 | 175.00 | 0.00   | 0.00   | 0.00   | 0.00   | 500.00 | 195.00 | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 100.00  | 700.00  | 50.00  | 0.00   | 0.00   | 0.00   | 0.00   | 100.00 | 220.00 | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 50.00   | 350.00  | 25.00  | 0.00   | 0.00   | 0.00   | 0.00   | 50.00  | 535.00 | ?      | ?      |
	And the override date is '07/06/2023'
	When the contract is amended as follows
		| ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-22  | Sep-22  | Oct-22  | Nov-22  | Dec-22  | Jan-23  | Feb-23  | Mar-23  | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 1               | 0                     | 1237.50 | 1237.50 | 1237.50 | 1237.50 | 1237.50 | 1237.50 | 1237.50 | 1237.50 | 400.00 | 400.00 | 600.00 | 400.00 |
		| EDSK-1022      | ALLB-1022     | 2               | 1                     | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   |
		| EDSK-1022      | ALLB-1022     | 3               | 1                     | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   |
		| EDSK-1022      | ALLB-1022     | 4               | 1                     | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00    | 0.00   | 0.00   | 0.00   | 0.00   |
	Then the Reconciliation Data is calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22  | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23  | May-23  | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 2000.00 | 1878.00 | 150.00 | 350.00 | 0.00   | 0.00   | 0.00   | 0.00   | 3825.00 | 3865.00 | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 100.00  | 800.00 | 100.00 | 0.00   | 0.00   | 0.00   | 0.00   | 1050.00 | 1430.00 | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 50.00   | 400.00 | 50.00  | 0.00   | 0.00   | 0.00   | 0.00   | 525.00  | 1705.00 | ?      | ?      |
	And the Capping Amounts are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22 | Oct-22  | Nov-22  | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23   | May-23  | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | -878.00 | 0.00   | -350.00 | -175.00 | 0.00   | 0.00   | 0.00   | 0.00   | -3325.00 | -140.00 | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 0.00   | -100.00 | -50.00  | 0.00   | 0.00   | 0.00   | 0.00   | -950.00  | -40.00  | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 0.00   | -50.00  | -25.00  | 0.00   | 0.00   | 0.00   | 0.00   | -475.00  | -20.00  | ?      | ?      |
	And the Net Payments are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22  | Oct-22  | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23  | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 1122.00 | 1878.00 | -200.00 | 175.00 | 0.00   | 0.00   | 0.00   | 0.00   | 500.00 | 3725.00 | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 100.00  | 700.00  | 50.00  | 0.00   | 0.00   | 0.00   | 0.00   | 100.00 | 1390.00 | ?      | ?      |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 50.00   | 350.00  | 25.00  | 0.00   | 0.00   | 0.00   | 0.00   | 50.00  | 1685.00 | ?      | ?      |
	And the override date is '19/10/2023'
	When The following Summarised Actuals for period 'R14' for collection type 'ILR2223' are processed
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22 | Sep-22 | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23  | Apr-23 | May-23 | Jun-23 | Jul-23 |
		| EDSK-1022      | ALLB-1022     | 2               | 700.00 | 700.00 | 700.00 | 700.00 | 700.00 | 700.00 | 700.00 | 700.00  | 250.00 | 250.00 | 250.00 | 250.00 |
		| EDSK-1022      | ALLB-1022     | 3               | 225.00 | 230.00 | 220.00 | 225.00 | 225.00 | 225.00 | 225.00 | 405.00  | 100.00 | 100.00 | 100.00 | 100.00 |
		| EDSK-1022      | ALLB-1022     | 4               | 100.00 | 125.00 | 112.50 | 112.50 | 112.50 | 112.50 | 112.50 | 1192.50 | 50.00  | 50.00  | 50.00  | 50.00  |
	Then the Reconciliation Data is calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22  | Oct-22 | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23  | May-23  | Jun-23 | Jul-23 | Oct-23  |
		| EDSK-1022      | ALLB-1022     | 2               | 2000.00 | 1878.00 | 150.00 | 350.00 | 0.00   | 0.00   | 0.00   | 0.00   | 3825.00 | 3865.00 | 0.00   | 0.00   | -600.00 |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 100.00  | 800.00 | 100.00 | 0.00   | 0.00   | 0.00   | 0.00   | 1050.00 | 1430.00 | 0.00   | 0.00   | 40.00   |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 50.00   | 400.00 | 50.00  | 0.00   | 0.00   | 0.00   | 0.00   | 525.00  | 1705.00 | 0.00   | 0.00   | 20.00   |
	And the Capping Amounts are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22 | Oct-22  | Nov-22  | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23   | May-23  | Jun-23 | Jul-23 | Oct-23 |
		| EDSK-1022      | ALLB-1022     | 2               | -878.00 | 0.00   | -350.00 | -175.00 | 0.00   | 0.00   | 0.00   | 0.00   | -3325.00 | -140.00 | 0.00   | 0.00   | 0.00   |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 0.00   | -100.00 | -50.00  | 0.00   | 0.00   | 0.00   | 0.00   | -950.00  | -40.00  | 0.00   | 0.00   | 0.00   |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 0.00   | -50.00  | -25.00  | 0.00   | 0.00   | 0.00   | 0.00   | -475.00  | -20.00  | 0.00   | 0.00   | 0.00   |
	And the Net Payments are calculated as follows
		| ContractNumber | AllocationRef | DeliverableCode | Aug-22  | Sep-22  | Oct-22  | Nov-22 | Dec-22 | Jan-23 | Feb-23 | Mar-23 | Apr-23 | May-23  | Jun-23 | Jul-23 | Oct-23  |
		| EDSK-1022      | ALLB-1022     | 2               | 1122.00 | 1878.00 | -200.00 | 175.00 | 0.00   | 0.00   | 0.00   | 0.00   | 500.00 | 3725.00 | 0.00   | 0.00   | -600.00 |
		| EDSK-1022      | ALLB-1022     | 3               | 0.00    | 100.00  | 700.00  | 50.00  | 0.00   | 0.00   | 0.00   | 0.00   | 100.00 | 1390.00 | 0.00   | 0.00   | 40.00   |
		| EDSK-1022      | ALLB-1022     | 4               | 0.00    | 50.00   | 350.00  | 25.00  | 0.00   | 0.00   | 0.00   | 0.00   | 50.00  | 1685.00 | 0.00   | 0.00   | 20.00   |
	And the override date is reset
