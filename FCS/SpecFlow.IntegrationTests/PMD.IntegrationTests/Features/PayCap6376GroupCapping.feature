Feature: PayCap6376GroupCapping
	PAY CAP: Pt1 Calculate payments on receipt of actuals where contract alloc is PoA with capping apportionment, multiple capping periods and no flexibility (6376)
#
#@IntegrationTest
#Scenario: A301 A contract containing a 24+ALLB  contract allocation is approved on time. It has two capping periods and the current period is within the first capping period. Actuals are submitted for all deliverables during the first capping period and a cap is breached in the first capping period 
## A302 A contract containing a 24+ALLB contract allocation is approved on time. It has two capping periods and the current period is within the first capping period.  Actuals are submitted against all the payable deliverables which equal exactly to the cap limit and no cap is breached in the first capping period.
## A303 A contract containing a 24+ALLB contract allocation is approved late (after period 8/Aug). It has two capping periods and the current period is within the first capping period.  Actuals are submitted only against one payable deliverable and a cap is breached in the first capping period.
## A304 A contract containing a 24+ALLB contract allocation is approved on time. It has two capping periods and the current period is within the first capping period.  Actuals are submitted only against two payable deliverables and a cap is breached in the first capping period.
#
#   Given there is no payment schedule data for contract 'MAIN-301' version '1'
#And   the approved contract allocations details for the latest version of the contract are as follows
# | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
# | 12345678 | MAIN-301       | ALLB-301      | 24+ ALLB          | 24+ALLB1516             | AY                      | 01/08/2015          | 31/07/2016        | 
#And   the contract deliverables details for the latest version of the contract are as follows
# | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
# | MAIN-301       | ALLB-301      | 1               | 0                     | 100.00 | 101.00 | 102.00 | 103.00 | 104.00 | 105.00 | 106.00 | 107.00 | 108.00 | 109.00 | 110.00 | 111.00 |
#And   the override date is '04/09/2015'
#When   The following Summarised Actuals for period 'R01' for collection type 'ILR1516' are processed
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15  | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 |
# | MAIN-301       | ALLB-301      | 2               | 1000.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
# | MAIN-301       | ALLB-301      | 3               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
# | MAIN-301       | ALLB-301      | 4               | 250.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
#Then   the Reconciliation Data is calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 1000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
#And   the Capping Amounts are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | -337.60              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | -84.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
#And   the Net Payments are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 662.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 165.60               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
#And   the override date is '06/10/2015'
#When   The following Summarised Actuals for period 'R02' for collection type 'ILR1516' are processed
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 400.00               | 100.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 20.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 250.00               | 30.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
#Then   the Reconciliation Data is calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 1000.00              | -162.40              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 20.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 250.00               | 114.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
#And   the Capping Amounts are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | -337.60              | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | -84.40               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
#And   the Net Payments are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 662.40               | -162.40              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 20.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 165.60               | 114.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
#And   the override date is '05/11/2015'
#When   The following Summarised Actuals for period 'R03' for collection type 'ILR1516' are processed
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 400.00               | 100.00               | 400.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
#Then   the Reconciliation Data is calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 1000.00              | -162.40              | 400.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 20.00                | -20.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 250.00               | 114.40               | -280.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
#And   the Capping Amounts are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | -337.60              | 0.00                 | -72.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | -84.40               | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
#And   the Net Payments are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 662.40               | -162.40              | 328.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 20.00                | -20.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 165.60               | 114.40               | -280.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
#And   the override date is '04/12/2015'
#When   The following Summarised Actuals for period 'R04' for collection type 'ILR1516' are processed
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 400.00               | 100.00               | 400.00               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 0.00                 | 0.00                 | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 0.00                 | 0.00                 | 0.00                 | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
#Then   the Reconciliation Data is calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 1000.00              | -162.40              | 400.00               | 72.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 20.00                | -20.00               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 250.00               | 114.40               | -280.00              | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
#And   the Capping Amounts are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | -337.60              | 0.00                 | -72.00               | -367.71              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 0.00                 | 0.00                 | -102.14              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | -84.40               | 0.00                 | 0.00                 | -102.14              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
#And   the Net Payments are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 662.40               | -162.40              | 328.00               | -295.71              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 20.00                | -20.00               | 147.86               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 165.60               | 114.40               | -280.00              | 147.86               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
#And   the override date is '06/05/2016'
#When   The following Summarised Actuals for period 'R09' for collection type 'ILR1516' are processed
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 400.00               | 100.00               | 50.00                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 40.00                | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 0.00                 | 0.00                 | 60.00                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 41.00                | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 0.00                 | 0.00                 | 0.00                 | 70.00                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 42.00                | ?                    | ?                    | ?                    | 
#Then   the Reconciliation Data is calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 1000.00              | -162.40              | 400.00               | 72.00                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 57.71                | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 20.00                | -20.00               | 250.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -46.86               | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 250.00               | 114.40               | -280.00              | 250.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -35.86               | ?                    | ?                    | ?                    | 
#And   the Capping Amounts are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | -337.60              | 0.00                 | -72.00               | -367.71              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 0.00                 | 0.00                 | -102.14              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | -84.40               | 0.00                 | 0.00                 | -102.14              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | 
#And   the Net Payments are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 662.40               | -162.40              | 328.00               | -295.71              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 57.71                | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 20.00                | -20.00               | 147.86               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -46.86               | ?                    | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 165.60               | 114.40               | -280.00              | 147.86               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -35.86               | ?                    | ?                    | ?                    | 
#And   the override date is '06/06/2016'
#When   The following Summarised Actuals for period 'R10' for collection type 'ILR1516' are processed
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 400.00               | 100.00               | 50.00                | 0.00                 | 11.00                | 21.00                | 31.00                | 41.00                | 40.00                | 1001.00              | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 0.00                 | 0.00                 | 60.00                | 12.00                | 22.00                | 32.00                | 42.00                | 41.00                | 1002.00              | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 0.00                 | 0.00                 | 0.00                 | 70.00                | 13.00                | 23.00                | 33.00                | 43.00                | 42.00                | 1003.00              | ?                    | ?                    | 
#Then   the Reconciliation Data is calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 1000.00              | -162.40              | 400.00               | 72.00                | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 57.71                | 1105.00              | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 20.00                | -20.00               | 250.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -46.86               | 1110.00              | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 250.00               | 114.40               | -280.00              | 250.00               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -35.86               | 1115.00              | ?                    | ?                    | 
#And   the Capping Amounts are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | -337.60              | 0.00                 | -72.00               | -367.71              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -1009.93             | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 0.00                 | 0.00                 | -102.14              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -926.45              | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | -84.40               | 0.00                 | 0.00                 | -102.14              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -930.62              | ?                    | ?                    | 
#And   the Net Payments are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
# | MAIN-301       | ALLB-301      | 2               | 662.40               | -162.40              | 328.00               | -295.71              | 0.00                 | 0.00                 | 0.00                 | 0.00                 | 57.71                | 95.07                | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 3               | 0.00                 | 20.00                | -20.00               | 147.86               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -46.86               | 183.55               | ?                    | ?                    | 
# | MAIN-301       | ALLB-301      | 4               | 165.60               | 114.40               | -280.00              | 147.86               | 0.00                 | 0.00                 | 0.00                 | 0.00                 | -35.86               | 184.38               | ?                    | ?                    | 
#And   the override date is reset
#
#
#@IntegrationTest
#Scenario: A302 A contract containing a 24+ALLB contract allocation is approved on time. It has two capping periods and the current period is within the first capping period and no cap is breached in the first capping period on receipt of actuals
#    Given there is no payment schedule data for contract 'MAIN-302' version '1'
#And   the approved contract allocations details for the latest version of the contract are as follows
# | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
# | 12345679 | MAIN-302       | ALLB-302      | 24+ ALLB          | 24+ALLB1516             | AY                      | 01/03/2016          | 31/05/2016        | 
#And   the contract deliverables details for the latest version of the contract are as follows
# | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-302       | ALLB-302      | 1               | 0                     | 107.00               | 108.00               | 109.00               | 
#And   the override date is '06/04/2016'
#When   The following Summarised Actuals for period 'R08' for collection type 'ILR1516' are processed
# | ContractNumber | AllocationRef | DeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-302       | ALLB-302      | 2               | 50.00                | ?                    | ?                    | 
# | MAIN-302       | ALLB-302      | 3               | 100.00               | ?                    | ?                    | 
# | MAIN-302       | ALLB-302      | 4               | 200.00               | ?                    | ?                    | 
#Then   the Reconciliation Data is calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-302       | ALLB-302      | 2               | 50.00                | ?                    | ?                    | 
# | MAIN-302       | ALLB-302      | 3               | 100.00               | ?                    | ?                    | 
# | MAIN-302       | ALLB-302      | 4               | 200.00               | ?                    | ?                    | 
#And   the Capping Amounts are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-302       | ALLB-302      | 2               | -34.71               | ?                    | ?                    | 
# | MAIN-302       | ALLB-302      | 3               | -69.43               | ?                    | ?                    | 
# | MAIN-302       | ALLB-302      | 4               | -138.86              | ?                    | ?                    | 
#And   the Net Payments are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-302       | ALLB-302      | 2               | 15.29                | ?                    | ?                    | 
# | MAIN-302       | ALLB-302      | 3               | 30.57                | ?                    | ?                    | 
# | MAIN-302       | ALLB-302      | 4               | 61.14                | ?                    | ?                    | 
#And   the override date is '06/05/2016'
#When   The following Summarised Actuals for period 'R09' for collection type 'ILR1516' are processed
# | ContractNumber | AllocationRef | DeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-302       | ALLB-302      | 2               | 50.00                | 300.00               | ?                    | 
# | MAIN-302       | ALLB-302      | 3               | 100.00               | 400.00               | ?                    | 
# | MAIN-302       | ALLB-302      | 4               | 200.00               | 500.00               | ?                    | 
#Then   the Reconciliation Data is calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-302       | ALLB-302      | 2               | 50.00                | 334.71               | ?                    | 
# | MAIN-302       | ALLB-302      | 3               | 100.00               | 469.43               | ?                    | 
# | MAIN-302       | ALLB-302      | 4               | 200.00               | 638.86               | ?                    | 
#And   the Capping Amounts are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-302       | ALLB-302      | 2               | -34.71               | -280.46              | ?                    | 
# | MAIN-302       | ALLB-302      | 3               | -69.43               | -397.10              | ?                    | 
# | MAIN-302       | ALLB-302      | 4               | -138.86              | -548.44              | ?                    | 
#And   the Net Payments are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-302       | ALLB-302      | 2               | 15.29                | 54.25                | ?                    | 
# | MAIN-302       | ALLB-302      | 3               | 30.57                | 72.33                | ?                    | 
# | MAIN-302       | ALLB-302      | 4               | 61.14                | 90.42                | ?                    | 
#And   the override date is '06/06/2016'
#When   The following Summarised Actuals for period 'R10' for collection type 'ILR1516' are processed
# | ContractNumber | AllocationRef | DeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-302       | ALLB-302      | 2               | 1.00                 | 0.00                 | 0.00                 | 
# | MAIN-302       | ALLB-302      | 3               | 2.00                 | 100.00               | 0.00                 | 
# | MAIN-302       | ALLB-302      | 4               | 3.00                 | 100.00               | 18.00                | 
#Then   the Reconciliation Data is calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-302       | ALLB-302      | 2               | 50.00                | 334.71               | -68.54               | 
# | MAIN-302       | ALLB-302      | 3               | 100.00               | 469.43               | -0.90                | 
# | MAIN-302       | ALLB-302      | 4               | 200.00               | 638.86               | -30.56               | 
#And   the Capping Amounts are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-302       | ALLB-302      | 2               | -34.71               | -280.46              | 0.00                 | 
# | MAIN-302       | ALLB-302      | 3               | -69.43               | -397.10              | -0.46                | 
# | MAIN-302       | ALLB-302      | 4               | -138.86              | -548.44              | -0.54                | 
#And   the Net Payments are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-302       | ALLB-302      | 2               | 15.29                | 54.25                | -68.54               | 
# | MAIN-302       | ALLB-302      | 3               | 30.57                | 72.33                | -1.36                | 
# | MAIN-302       | ALLB-302      | 4               | 61.14                | 90.42                | -31.10               | 
#And   the override date is reset
#
#
#@IntegrationTest
#Scenario: A305 A contract containing a 24+ALLB  contract allocation is approved on time. It has two capping periods and the current period is within the second capping period. Actuals were previously submitted for capping period 1 and had breached the cap. Actuals were also previously submitted for capping period 2 and had breached the cap. However, year to date actuals submitted in capping period 2 (including re-submission of capping period 1 and 2 actuals) now don’t breach the cap for capping period 1 but still breaches the cap for capping period 2 
#   Given there is no payment schedule data for contract 'MAIN-305' version '1'
#And   the approved contract allocations details for the latest version of the contract are as follows
# | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
# | 12345670 | MAIN-305       | ALLB-305      | 24+ ALLB          | 24+ALLB1516             | AY                      | 01/03/2016          | 31/05/2016        | 
#And   the contract deliverables details for the latest version of the contract are as follows
# | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-305       | ALLB-305      | 1               | 0                     | 10000.00             | 11000.00             | 9000.00              | 
#And   the override date is '06/05/2016'
#When   The following Summarised Actuals for period 'R09' for collection type 'ILR1516' are processed
# | ContractNumber | AllocationRef | DeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-305       | ALLB-305      | 2               | 0.00                 | 50.00                | ?                    | 
# | MAIN-305       | ALLB-305      | 3               | 0.00                 | 67.00                | ?                    | 
# | MAIN-305       | ALLB-305      | 4               | 12000.00             | 837.00               | ?                    | 
#Then   the Reconciliation Data is calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-305       | ALLB-305      | 2               | 0.00                 | 50.00                | ?                    | 
# | MAIN-305       | ALLB-305      | 3               | 0.00                 | 67.00                | ?                    | 
# | MAIN-305       | ALLB-305      | 4               | 0.00                 | 12837.00             | ?                    | 
#And   the Capping Amounts are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-305       | ALLB-305      | 2               | 0.00                 | 0.00                 | ?                    | 
# | MAIN-305       | ALLB-305      | 3               | 0.00                 | 0.00                 | ?                    | 
# | MAIN-305       | ALLB-305      | 4               | 0.00                 | -2000.00             | ?                    | 
#And   the Net Payments are calculated as follows
# | ContractNumber | AllocationRef | DeliverableCode | Mar-16               | Apr-16               | May-16               | 
# | MAIN-305       | ALLB-305      | 2               | 0.00                 | 50.00                | ?                    | 
# | MAIN-305       | ALLB-305      | 3               | 0.00                 | 67.00                | ?                    | 
# | MAIN-305       | ALLB-305      | 4               | 0.00                 | 10837.00             | ?                    | 
#And   the override date is 
#
#

@DoNotRun_7Mar2024
Scenario: D301 A contract containing a 24+ALLB  contract allocation is approved on time. It has two capping periods and the current period is within the first capping period. Actuals are submitted for all deliverables during the first capping period and a cap is breached in the first capping period 
Given there is no payment schedule data for contract 'MAIN-123' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 12345678 | MAIN-123       | ALLB-123      | 24+ ALLB          | 24+ALLB1516             | AY                      | 01/08/2015          | 31/07/2016        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 1               | 0                     | 100.00               | 101.00               | 102.00               | 103.00               | 104.00               | 105.00               | 106.00               | 107.00               | 108.00               | 109.00               | 110.00               | 111.00               | 
 | MAIN-123       | ALLB-123      | 2               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | 0                     | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '04/09/2015'
When   The following Summarised Actuals for period 'R01' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 2               | 1000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 2               | 1000.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 2               | -337.60              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | -84.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 2               | 662.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | 165.60               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '06/10/2015'
When   The following Summarised Actuals for period 'R02' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 2               | 400.00               | 100.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0.00                 | 20.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | 250.00               | 30.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 2               | 1000.00              | -162.40              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0.00                 | 20.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | 250.00               | 114.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 2               | -337.60              | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | -84.40               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 2               | 662.40               | -162.40              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0.00                 | 20.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | 165.60               | 114.40               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '05/11/2015'
When   The following Summarised Actuals for period 'R03' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 2               | 400.00               | 100.00               | 400.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 2               | 1000.00              | -162.40              | 400.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0.00                 | 20.00                | -20.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | 250.00               | 114.40               | -280.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 2               | -337.60              | 0.00                 | -72.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0.00                 | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | -84.40               | 0.00                 | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 2               | 662.40               | -162.40              | 328.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0.00                 | 20.00                | -20.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | 165.60               | 114.40               | -280.00              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '04/12/2015'
When   The following Summarised Actuals for period 'R04' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 2               | 400.00               | 100.00               | 400.00               | 0.00                 | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0.00                 | 0.00                 | 0.00                 | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | 0.00                 | 0.00                 | 0.00                 | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 2               | 1000.00              | -162.40              | 400.00               | 72.00                | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0.00                 | 20.00                | -20.00               | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | 250.00               | 114.40               | -280.00              | 250.00               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 2               | -337.60              | 0.00                 | -72.00               | -367.71              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0.00                 | 0.00                 | 0.00                 | -102.14              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | -84.40               | 0.00                 | 0.00                 | -102.14              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Aug-15               | Sep-15               | Oct-15               | Nov-15               | Dec-15               | Jan-16               | Feb-16               | Mar-16               | Apr-16               | May-16               | Jun-16               | Jul-16               | 
 | MAIN-123       | ALLB-123      | 2               | 662.40               | -162.40              | 328.00               | -295.71              | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 3               | 0.00                 | 20.00                | -20.00               | 147.86               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-123       | ALLB-123      | 4               | 165.60               | 114.40               | -280.00              | 147.86               | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | ?                    | 
And   the override date is reset

@DoNotRun_7Mar2024
Scenario: D305 A contract containing a 24+ALLB  contract allocation is approved on time. It has two capping periods and the current period is within the second capping period. Actuals were previously submitted for capping period 1 and had breached the cap. Actuals were also previously submitted for capping period 2 and had breached the cap. However, year to date actuals submitted in capping period 2 (including re-submission of capping period 1 and 2 actuals) now don’t breach the cap for capping period 1 but still breaches the cap for capping period 2 
Given there is no payment schedule data for contract 'MAIN-124' version '1'
And   the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 12345679 | MAIN-124       | ALLB-124      | 24+ ALLB          | 24+ALLB1516             | AY                      | 01/02/2016          | 31/05/2016        | 
And   the contract deliverables details for the latest version of the contract are as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Feb-16               | Mar-16               | Apr-16               | May-16               | 
 | MAIN-124       | ALLB-124      | 1               | 0                     | 107.00               | 108.00               | 109.00               | 110.00               | 
 | MAIN-124       | ALLB-124      | 2               | 0                     | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 3               | 0                     | ?                    | ?                    | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 4               | 0                     | ?                    | ?                    | ?                    | ?                    | 
And   the override date is '04/03/2016'
When   The following Summarised Actuals for period 'R07' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Feb-16               | Mar-16               | Apr-16               | May-16               | 
 | MAIN-124       | ALLB-124      | 2               | 50.00                | ?                    | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 3               | 100.00               | ?                    | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 4               | 200.00               | ?                    | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-16               | Mar-16               | Apr-16               | May-16               | 
 | MAIN-124       | ALLB-124      | 2               | 50.00                | ?                    | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 3               | 100.00               | ?                    | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 4               | 200.00               | ?                    | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-16               | Mar-16               | Apr-16               | May-16               | 
 | MAIN-124       | ALLB-124      | 2               | -19.29               | ?                    | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 3               | -38.57               | ?                    | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 4               | -77.14               | ?                    | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-16               | Mar-16               | Apr-16               | May-16               | 
 | MAIN-124       | ALLB-124      | 2               | 30.71                | ?                    | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 3               | 61.43                | ?                    | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 4               | 122.86               | ?                    | ?                    | ?                    | 
And   the override date is '06/04/2016'
When   The following Summarised Actuals for period 'R08' for collection type 'ILR1516' are processed
 | ContractNumber | AllocationRef | DeliverableCode | Feb-16               | Mar-16               | Apr-16               | May-16               | 
 | MAIN-124       | ALLB-124      | 2               | 50.00                | 300.00               | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 3               | 100.00               | 400.00               | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 4               | 200.00               | 500.00               | ?                    | ?                    | 
Then   the Reconciliation Data is calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-16               | Mar-16               | Apr-16               | May-16               | 
 | MAIN-124       | ALLB-124      | 2               | 50.00                | 319.29               | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 3               | 100.00               | 438.57               | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 4               | 200.00               | 577.14               | ?                    | ?                    | 
And   the Capping Amounts are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-16               | Mar-16               | Apr-16               | May-16               | 
 | MAIN-124       | ALLB-124      | 2               | -19.29               | -301.45              | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 3               | -38.57               | -430.65              | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 4               | -77.14               | -602.90              | ?                    | ?                    | 
And   the Net Payments are calculated as follows
 | ContractNumber | AllocationRef | DeliverableCode | Feb-16               | Mar-16               | Apr-16               | May-16               | 
 | MAIN-124       | ALLB-124      | 2               | 30.71                | 17.84                | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 3               | 61.43                | 7.92                 | ?                    | ?                    | 
 | MAIN-124       | ALLB-124      | 4               | 122.86               | -25.76               | ?                    | ?                    | 
And   the override date is reset


