Feature: 16-18TRN-ME2122
@DoNotRun_7Mar2024
Scenario: D108 PoA 21 16-18TRN-ME2122
Given there is no payment schedule data for contract 'EDSK-1021' version '1'

And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 10211021 | EDSK-1021      | 16TM-1021     | 16-18TRN-ME       | 16-18TRN-ME2122         | AY                      | 01/12/2021          | 31/07/2022        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 1               | 0                     | 5000.00              | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 
 | EDSK-1021      | 16TM-1021     | 2               | 1                     | 3750.00              | 750.00               | 750.00               | 750.00               | 750.00               | 750.00               | 750.00               | 750.00               | 
 | EDSK-1021      | 16TM-1021     | 3               | 1                     | 1250.00              | 250.00               | 250.00               | 250.00               | 250.00               | 250.00               | 250.00               | 250.00               | 

And   the override date is '07/01/2022'

When   The following Summarised Actuals for period 'R05' for collection type 'ILR2122' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EDSK-1021      | 16TM-1021     | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 

And   the override date is '04/02/2022'

When   The following Summarised Actuals for period 'R06' for collection type 'ILR2122' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 2000.00              | 7000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EDSK-1021      | 16TM-1021     | 3               | 300.00               | 700.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | 7500.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | 750.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 0.00                 | -1080.00             | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EDSK-1021      | 16TM-1021     | 3               | 0.00                 | -120.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | 6420.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | 630.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 

And   the override date is '06/05/2022'

When   The following Summarised Actuals for period 'R09' for collection type 'ILR2122' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 5400.00              | 1080.00              | 1080.00              | 1530.00              | 4320.00              | ?                    | ?                    | ?                    | 
 | EDSK-1021      | 16TM-1021     | 3               | 650.00               | 120.00               | 120.00               | 120.00               | 1080.00              | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | 7500.00              | 0.00                 | 0.00                 | 5490.00              | ?                    | ?                    | ?                    | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | 750.00               | 0.00                 | 0.00                 | 1210.00              | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 0.00                 | -1080.00             | 0.00                 | 0.00                 | -1970.00             | ?                    | ?                    | ?                    | 
 | EDSK-1021      | 16TM-1021     | 3               | 0.00                 | -120.00              | 0.00                 | 0.00                 | -330.00              | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | 6420.00              | 0.00                 | 0.00                 | 3520.00              | ?                    | ?                    | ?                    | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | 630.00               | 0.00                 | 0.00                 | 880.00               | ?                    | ?                    | ?                    | 

And   the override date is '10/05/2022'

When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 1               | 0                     | 5500.00              | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 
 | EDSK-1021      | 16TM-1021     | 2               | 1                     | 4125.00              | 750.00               | 750.00               | 750.00               | 750.00               | 750.00               | 750.00               | 750.00               | 
 | EDSK-1021      | 16TM-1021     | 3               | 1                     | 1375.00              | 250.00               | 250.00               | 250.00               | 250.00               | 250.00               | 250.00               | 250.00               | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | 7500.00              | 0.00                 | 0.00                 | 5490.00              | ?                    | ?                    | ?                    | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | 750.00               | 0.00                 | 0.00                 | 1210.00              | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 0.00                 | -1080.00             | 0.00                 | 0.00                 | -1475.00             | ?                    | ?                    | ?                    | 
 | EDSK-1021      | 16TM-1021     | 3               | 0.00                 | -120.00              | 0.00                 | 0.00                 | -275.00              | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | 6420.00              | 0.00                 | 0.00                 | 4015.00              | ?                    | ?                    | ?                    | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | 630.00               | 0.00                 | 0.00                 | 935.00               | ?                    | ?                    | ?                    | 

And   the override date is '13/09/2022'

When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 1               | 0                     | 11300.00             | 1000.00              | 1000.00              | 10000.00             | 1000.00              | 1000.00              | 1000.00              | 1000.00              | 
 | EDSK-1021      | 16TM-1021     | 2               | 1                     | 8475.00              | 750.00               | 750.00               | 7500.00              | 750.00               | 750.00               | 750.00               | 750.00               | 
 | EDSK-1021      | 16TM-1021     | 3               | 1                     | 2825.00              | 250.00               | 250.00               | 2500.00              | 250.00               | 250.00               | 250.00               | 250.00               | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | Sep-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | 7500.00              | 0.00                 | 0.00                 | 5490.00              | 0.00                 | 0.00                 | 0.00                 | 1475.00              | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | 750.00               | 0.00                 | 0.00                 | 1210.00              | 0.00                 | 0.00                 | 0.00                 | 275.00               | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | Sep-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 0.00                 | -1080.00             | 0.00                 | 0.00                 | -1475.00             | 0.00                 | 0.00                 | 0.00                 | -800.00              | 
 | EDSK-1021      | 16TM-1021     | 3               | 0.00                 | -120.00              | 0.00                 | 0.00                 | -275.00              | 0.00                 | 0.00                 | 0.00                 | -200.00              | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | Sep-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | 6420.00              | 0.00                 | 0.00                 | 4015.00              | 0.00                 | 0.00                 | 0.00                 | 675.00               | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | 630.00               | 0.00                 | 0.00                 | 935.00               | 0.00                 | 0.00                 | 0.00                 | 75.00                | 

And   the override date is '14/09/2022'

When   The following Summarised Actuals for period 'R13' for collection type 'ILR2122' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 13315.00             | 2663.00              | 2663.00              | 2663.00              | 2430.00              | 2430.00              | 2430.00              | 2430.00              | 
 | EDSK-1021      | 16TM-1021     | 3               | 3331.00              | 665.00               | 665.00               | 665.00               | 270.00               | 270.00               | 270.00               | 270.00               | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | Sep-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | 7500.00              | 0.00                 | 0.00                 | 5490.00              | 0.00                 | 0.00                 | 0.00                 | 19089.00             | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | 750.00               | 0.00                 | 0.00                 | 1210.00              | 0.00                 | 0.00                 | 0.00                 | 4591.00              | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | Sep-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 0.00                 | -1080.00             | 0.00                 | 0.00                 | -1475.00             | 0.00                 | 0.00                 | 0.00                 | -6560.00             | 
 | EDSK-1021      | 16TM-1021     | 3               | 0.00                 | -120.00              | 0.00                 | 0.00                 | -275.00              | 0.00                 | 0.00                 | 0.00                 | -840.00              | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | Sep-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | 6420.00              | 0.00                 | 0.00                 | 4015.00              | 0.00                 | 0.00                 | 0.00                 | 12529.00             | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | 630.00               | 0.00                 | 0.00                 | 935.00               | 0.00                 | 0.00                 | 0.00                 | 3751.00              | 

And   the override date is '15/09/2022'

When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 1               | 0                     | 11800.00             | 1000.00              | 1000.00              | 10000.00             | 2500.00              | 2500.00              | 2500.00              | 2500.00              | 
 | EDSK-1021      | 16TM-1021     | 2               | 1                     | 8850.00              | 750.00               | 750.00               | 7500.00              | 1875.00              | 1875.00              | 1875.00              | 1875.00              | 
 | EDSK-1021      | 16TM-1021     | 3               | 1                     | 2950.00              | 250.00               | 250.00               | 2500.00              | 625.00               | 625.00               | 625.00               | 625.00               | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | Sep-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | 7500.00              | 0.00                 | 0.00                 | 5490.00              | 0.00                 | 0.00                 | 0.00                 | 19089.00             | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | 750.00               | 0.00                 | 0.00                 | 1210.00              | 0.00                 | 0.00                 | 0.00                 | 4591.00              | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | Sep-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 0.00                 | -1080.00             | 0.00                 | 0.00                 | -1475.00             | 0.00                 | 0.00                 | 0.00                 | -360.00              | 
 | EDSK-1021      | 16TM-1021     | 3               | 0.00                 | -120.00              | 0.00                 | 0.00                 | -275.00              | 0.00                 | 0.00                 | 0.00                 | -90.00               | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | Sep-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | 6420.00              | 0.00                 | 0.00                 | 4015.00              | 0.00                 | 0.00                 | 0.00                 | 18729.00             | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | 630.00               | 0.00                 | 0.00                 | 935.00               | 0.00                 | 0.00                 | 0.00                 | 4501.00              | 

And   the override date is '20/10/2022'

When   The following Summarised Actuals for period 'R14' for collection type 'ILR2122' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 13315.00             | 2663.00              | 2663.00              | 2663.00              | 2430.00              | 2430.00              | 2430.00              | 2430.00              | 
 | EDSK-1021      | 16TM-1021     | 3               | 3331.00              | 665.00               | 665.00               | 665.00               | 270.00               | 270.00               | 270.00               | 270.00               | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | Sep-22               | Oct-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | 7500.00              | 0.00                 | 0.00                 | 5490.00              | 0.00                 | 0.00                 | 0.00                 | 19089.00             | 360.00               | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | 750.00               | 0.00                 | 0.00                 | 1210.00              | 0.00                 | 0.00                 | 0.00                 | 4591.00              | 90.00                | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | Sep-22               | Oct-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 0.00                 | -1080.00             | 0.00                 | 0.00                 | -1475.00             | 0.00                 | 0.00                 | 0.00                 | -360.00              | -207.21              | 
 | EDSK-1021      | 16TM-1021     | 3               | 0.00                 | -120.00              | 0.00                 | 0.00                 | -275.00              | 0.00                 | 0.00                 | 0.00                 | -90.00               | -42.79               | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | Sep-22               | Oct-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | 6420.00              | 0.00                 | 0.00                 | 4015.00              | 0.00                 | 0.00                 | 0.00                 | 18729.00             | 152.79               | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | 630.00               | 0.00                 | 0.00                 | 935.00               | 0.00                 | 0.00                 | 0.00                 | 4501.00              | 47.21                | 

And   the override date is '10/11/2022'

When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | 
 | EDSK-1021      | 16TM-1021     | 1               | 0                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 36000.00             | 
 | EDSK-1021      | 16TM-1021     | 2               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 27000.00             | 
 | EDSK-1021      | 16TM-1021     | 3               | 1                     | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 9000.00              | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | Sep-22               | Oct-22               | Nov-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | 7500.00              | 0.00                 | 0.00                 | 5490.00              | 0.00                 | 0.00                 | 0.00                 | 19089.00             | 360.00               | 207.21               | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | 750.00               | 0.00                 | 0.00                 | 1210.00              | 0.00                 | 0.00                 | 0.00                 | 4591.00              | 90.00                | 42.79                | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | Sep-22               | Oct-22               | Nov-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 0.00                 | -1080.00             | 0.00                 | 0.00                 | -1475.00             | 0.00                 | 0.00                 | 0.00                 | -360.00              | -207.21              | 0.00                 | 
 | EDSK-1021      | 16TM-1021     | 3               | 0.00                 | -120.00              | 0.00                 | 0.00                 | -275.00              | 0.00                 | 0.00                 | 0.00                 | -90.00               | -42.79               | 0.00                 | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Dec-21               | Jan-22               | Feb-22               | Mar-22               | Apr-22               | May-22               | Jun-22               | Jul-22               | Sep-22               | Oct-22               | Nov-22               | 
 | EDSK-1021      | 16TM-1021     | 2               | 1500.00              | 6420.00              | 0.00                 | 0.00                 | 4015.00              | 0.00                 | 0.00                 | 0.00                 | 18729.00             | 152.79               | 207.21               | 
 | EDSK-1021      | 16TM-1021     | 3               | 250.00               | 630.00               | 0.00                 | 0.00                 | 935.00               | 0.00                 | 0.00                 | 0.00                 | 4501.00              | 47.21                | 42.79                | 

And   the override date is reset

