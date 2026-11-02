Feature: NLAP_LevyCareLeavers 23043

@IntegrationTest
Scenario: D060 Procured 16-18 NLA (16-18NLAP2018)
    Given there is no payment schedule data for contract 'NLAP-6060' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 60123456 | NLAP-6060      | YNLP-6060     | 16-18NLAP         | 16-18NLAP2018           | NONLEVY                 | 01/01/2018          | 31/03/2019        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 1               | 0                     | 100.00     | 101.00     | 102.00     | 500.00     | 501.00     | 502.00     | 503.00     | 1000.00    | 1001.00    | 1002.00    | 1003.00    | 1004.00    | 1005.00    | 1006.00    | 1007.00    | 
    | NLAP-6060      | YNLP-6060     | 2               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-6060      | YNLP-6060     | 3               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-6060      | YNLP-6060     | 4               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-6060      | YNLP-6060     | 5               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |
       
    # Change the date
    And   the override date is '06/02/2018'

    When  The following Summarised Actuals for period 'APPS09' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '04/05/2018'

    When  The following Summarised Actuals for period 'APPS12' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 100.00     | 101.00     | 102.00     | 11000.00   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 0.00       | 0.00       | 0.00       | 1.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 1.01       | 2.02       | 3.03       | 7.77       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | 0.00       | 0.00       | 11078.11   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | 0.00       | 0.00       | -27.11     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | 0.00       | 0.00       | -980.74    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | 0.00       | 0.00       | -0.09      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | 0.00       | 0.00       | 10097.37   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | 0.00       | 0.00       | -27.20     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '06/05/2018'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 1               | 0                     | 106.06     | 101.00     | 102.00     | 500.00     | 501.00     | 502.00     | 503.00     | 1000.00    | 1001.00    | 1002.00    | 1003.00    | 1004.00    | 1005.00    | 1006.00    | 1007.00    | 
    | NLAP-6060      | YNLP-6060     | 2               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 3               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 4               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 5               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | 0.00       | 0.00       | 11078.11   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | 0.00       | 0.00       | -27.11     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | 0.00       | 0.00       | -974.68    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | 0.00       | 0.00       | -0.09      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | 0.00       | 0.00       | 10103.43   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | 0.00       | 0.00       | -27.20     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '06/09/2018'

    When  The following Summarised Actuals for period 'APPS16' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 90.00      | 91.00      | 92.00      | 167.00     | 167.00     | 167.00     | 167.00     | 8000.01    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 0.00       | 0.00       | 0.00       | 167.00     | 167.00     | 166.00     | 167.00     | 11.11      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 1.01       | 2.02       | 3.03       | 167.00     | 167.00     | 167.00     | 167.00     | 1.23       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | 0.00       | 0.00       | 11078.11   | 0.00       | 0.00       | 0.00       | -1387.31   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | 0.00       | 0.00       | -27.11     | 0.00       | 0.00       | 0.00       | 677.20     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | 0.00       | 0.00       | -974.68    | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | 0.00       | 0.00       | -0.09      | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | 0.00       | 0.00       | 10103.43   | 0.00       | 0.00       | 0.00       | -1387.31   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | 0.00       | 0.00       | -27.20     | 0.00       | 0.00       | 0.00       | 677.20     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '07/09/2018'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 1               | 0                     | 106.06     | 101.00     | 102.00     | 500.00     | 0.00       | 502.00     | 503.00     | 1000.00    | 1001.00    | 1002.00    | 1003.00    | 1004.00    | 1005.00    | 1006.00    | 1474.00    | 
    | NLAP-6060      | YNLP-6060     | 2               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 3               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 4               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 5               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | 0.00       | 0.00       | 11078.11   | 0.00       | 0.00       | 0.00       | -1387.31   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | 0.00       | 0.00       | -27.11     | 0.00       | 0.00       | 0.00       | 677.20     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | 0.00       | 0.00       | -974.68    | 0.00       | 0.00       | 0.00       | -14.24     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | 0.00       | 0.00       | -0.09      | 0.00       | 0.00       | 0.00       | -1.11      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | 0.00       | 0.00       | 10103.43   | 0.00       | 0.00       | 0.00       | -1401.55   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | 0.00       | 0.00       | -27.20     | 0.00       | 0.00       | 0.00       | 676.09     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '04/04/2019'

    When  The following Summarised Actuals for period 'APPS23' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 45.40      | 46.40      | 47.40      | 146.30     | 147.40     | 148.50     | 149.60     | 698.70     | 703.80     | 708.90     | 714.00     | 719.10     | 724.20     | 729.30     | 734.40     | 
    | NLAP-6060      | YNLP-6060     | 3               | 45.50      | 46.50      | 47.50      | 147.40     | 148.50     | 149.60     | 150.70     | 703.80     | 708.90     | 714.00     | 719.10     | 724.20     | 729.30     | 734.40     | 739.50     | 
    | NLAP-6060      | YNLP-6060     | 4               | 45.60      | 46.60      | 47.60      | 148.50     | 149.60     | 150.70     | 151.80     | 708.90     | 714.00     | 719.10     | 724.20     | 729.30     | 734.40     | 739.50     | 744.60     | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | 0.00       | 0.00       | 11078.11   | 0.00       | 0.00       | 0.00       | -1387.31   | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -2463.37   | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | 0.00       | 0.00       | -27.11     | 0.00       | 0.00       | 0.00       | 677.20     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5831.90    | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5879.11    | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | 0.00       | 0.00       | -974.68    | 0.00       | 0.00       | 0.00       | -14.24     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -4592.54   | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | 0.00       | 0.00       | -0.09      | 0.00       | 0.00       | 0.00       | -1.11      | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -4625.10   | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | 0.00       | 0.00       | 10103.43   | 0.00       | 0.00       | 0.00       | -1401.55   | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -7055.91   | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | 0.00       | 0.00       | -27.20     | 0.00       | 0.00       | 0.00       | 676.09     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 1206.80    | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5879.11    | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 




    # Change the date
    And   the override date is '05/04/2019'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 1               | 0                     | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 0.00       | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 10000.00   | 
    | NLAP-6060      | YNLP-6060     | 2               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 3               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 4               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 5               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | 0.00       | 0.00       | 11078.11   | 0.00       | 0.00       | 0.00       | -1387.31   | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -2463.37   | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | 0.00       | 0.00       | -27.11     | 0.00       | 0.00       | 0.00       | 677.20     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5831.90    | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5879.11    | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | 0.00       | 0.00       | -974.68    | 0.00       | 0.00       | 0.00       | -14.24     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | 0.00       | 0.00       | -0.09      | 0.00       | 0.00       | 0.00       | -1.11      | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | 0.00       | 0.00       | 10103.43   | 0.00       | 0.00       | 0.00       | -1401.55   | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -2463.37   | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | 0.00       | 0.00       | -27.20     | 0.00       | 0.00       | 0.00       | 676.09     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5831.90    | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5879.11    | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 




    # Change the date
    And   the override date is '07/05/2019'

    When  The following Summarised Actuals for period 'APPS24' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 45.40      | 46.40      | 47.40      | 7146.30    | 147.40     | 148.50     | 149.60     | 698.70     | 703.80     | 708.90     | 714.00     | 719.10     | 724.20     | 729.30     | 734.40     | 
    | NLAP-6060      | YNLP-6060     | 3               | 45.50      | 46.50      | 47.50      | 147.40     | 148.50     | 149.60     | 150.70     | 703.80     | 708.90     | 714.00     | 719.10     | 724.20     | 729.30     | 734.40     | 739.50     | 
    | NLAP-6060      | YNLP-6060     | 4               | 45.60      | 46.60      | 47.60      | 148.50     | 149.60     | 150.70     | 151.80     | 708.90     | 714.00     | 719.10     | 724.20     | 729.30     | 734.40     | 739.50     | 744.60     | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | 0.00       | 0.00       | 11078.11   | 0.00       | 0.00       | 0.00       | -1387.31   | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -2463.37   | 7000.00    | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | 0.00       | 0.00       | -27.11     | 0.00       | 0.00       | 0.00       | 677.20     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5831.90    | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5879.11    | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | 0.00       | 0.00       | -974.68    | 0.00       | 0.00       | 0.00       | -14.24     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -749.78    | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | 0.00       | 0.00       | -0.09      | 0.00       | 0.00       | 0.00       | -1.11      | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -358.42    | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | 0.00       | 0.00       | 10103.43   | 0.00       | 0.00       | 0.00       | -1401.55   | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -2463.37   | 6250.22    | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | 0.00       | 0.00       | -27.20     | 0.00       | 0.00       | 0.00       | 676.09     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5831.90    | -358.42    | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5879.11    | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 




    # Change the date
    And   the override date is '08/05/2019'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 1               | 0                     | 100.00     | 100.00     | 100.00     | 2000.00    | 1500.00    | 1500.00    | 4000.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 10000.00   | 
    | NLAP-6060      | YNLP-6060     | 2               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 3               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 4               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 5               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | 0.00       | 0.00       | 11078.11   | 0.00       | 0.00       | 0.00       | -1387.31   | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -2463.37   | 7000.00    | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | 0.00       | 0.00       | -27.11     | 0.00       | 0.00       | 0.00       | 677.20     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5831.90    | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5879.11    | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | 0.00       | 0.00       | -974.68    | 0.00       | 0.00       | 0.00       | -14.24     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -59.19     | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | 0.00       | 0.00       | -0.09      | 0.00       | 0.00       | 0.00       | -1.11      | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -59.31     | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | 0.00       | 0.00       | 10103.43   | 0.00       | 0.00       | 0.00       | -1401.55   | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -2463.37   | 6940.81    | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | 0.00       | 0.00       | -27.20     | 0.00       | 0.00       | 0.00       | 676.09     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5831.90    | -59.31     | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5879.11    | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the override date is reset

 @IntegrationTest
Scenario: D060b Procured 16-18 NLA (16-18NLAP2018) (no del 5)
    Given there is no payment schedule data for contract 'NLAP-6060' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 60123456 | NLAP-6060      | YNLP-6060     | 16-18NLAP         | 16-18NLAP2018           | NONLEVY                 | 01/01/2018          | 31/03/2019        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 1               | 0                     | 100.00     | 101.00     | 102.00     | 500.00     | 501.00     | 502.00     | 503.00     | 1000.00    | 1001.00    | 1002.00    | 1003.00    | 1004.00    | 1005.00    | 1006.00    | 1007.00    | 
    | NLAP-6060      | YNLP-6060     | 2               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-6060      | YNLP-6060     | 3               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-6060      | YNLP-6060     | 4               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |

    # Change the date
    And   the override date is '06/02/2018'

    When  The following Summarised Actuals for period 'APPS09' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '04/05/2018'

    When  The following Summarised Actuals for period 'APPS12' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 100.00     | 101.00     | 102.00     | 11000.00   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 0.00       | 0.00       | 0.00       | 1.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 1.01       | 2.02       | 3.03       | 7.77       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | 0.00       | 0.00       | 11078.11   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | 0.00       | 0.00       | -27.11     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | 0.00       | 0.00       | -980.74    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | 0.00       | 0.00       | -0.09      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | 0.00       | 0.00       | 10097.37   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | 0.00       | 0.00       | -27.20     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '06/05/2018'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 1               | 0                     | 106.06     | 101.00     | 102.00     | 500.00     | 501.00     | 502.00     | 503.00     | 1000.00    | 1001.00    | 1002.00    | 1003.00    | 1004.00    | 1005.00    | 1006.00    | 1007.00    | 
    | NLAP-6060      | YNLP-6060     | 2               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 3               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 4               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | 0.00       | 0.00       | 11078.11   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | 0.00       | 0.00       | -27.11     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | 0.00       | 0.00       | -974.68    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | 0.00       | 0.00       | -0.09      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | 0.00       | 0.00       | 10103.43   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | 0.00       | 0.00       | -27.20     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '06/09/2018'

    When  The following Summarised Actuals for period 'APPS16' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 90.00      | 91.00      | 92.00      | 167.00     | 167.00     | 167.00     | 167.00     | 8000.01    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 0.00       | 0.00       | 0.00       | 167.00     | 167.00     | 166.00     | 167.00     | 11.11      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 1.01       | 2.02       | 3.03       | 167.00     | 167.00     | 167.00     | 167.00     | 1.23       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | 0.00       | 0.00       | 11078.11   | 0.00       | 0.00       | 0.00       | -1387.31   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | 0.00       | 0.00       | -27.11     | 0.00       | 0.00       | 0.00       | 677.20     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | 0.00       | 0.00       | -974.68    | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | 0.00       | 0.00       | -0.09      | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | 0.00       | 0.00       | 10103.43   | 0.00       | 0.00       | 0.00       | -1387.31   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | 0.00       | 0.00       | -27.20     | 0.00       | 0.00       | 0.00       | 677.20     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '07/09/2018'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 1               | 0                     | 106.06     | 101.00     | 102.00     | 500.00     | 0.00       | 502.00     | 503.00     | 1000.00    | 1001.00    | 1002.00    | 1003.00    | 1004.00    | 1005.00    | 1006.00    | 1474.00    | 
    | NLAP-6060      | YNLP-6060     | 2               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 3               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 4               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | 0.00       | 0.00       | 11078.11   | 0.00       | 0.00       | 0.00       | -1387.31   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | 0.00       | 0.00       | -27.11     | 0.00       | 0.00       | 0.00       | 677.20     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | 0.00       | 0.00       | -974.68    | 0.00       | 0.00       | 0.00       | -14.24     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | 0.00       | 0.00       | -0.09      | 0.00       | 0.00       | 0.00       | -1.11      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | 0.00       | 0.00       | 10103.43   | 0.00       | 0.00       | 0.00       | -1401.55   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | 0.00       | 0.00       | -27.20     | 0.00       | 0.00       | 0.00       | 676.09     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '04/04/2019'

    When  The following Summarised Actuals for period 'APPS23' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 45.40      | 46.40      | 47.40      | 146.30     | 147.40     | 148.50     | 149.60     | 698.70     | 703.80     | 708.90     | 714.00     | 719.10     | 724.20     | 729.30     | 734.40     | 
    | NLAP-6060      | YNLP-6060     | 3               | 45.50      | 46.50      | 47.50      | 147.40     | 148.50     | 149.60     | 150.70     | 703.80     | 708.90     | 714.00     | 719.10     | 724.20     | 729.30     | 734.40     | 739.50     | 
    | NLAP-6060      | YNLP-6060     | 4               | 45.60      | 46.60      | 47.60      | 148.50     | 149.60     | 150.70     | 151.80     | 708.90     | 714.00     | 719.10     | 724.20     | 729.30     | 734.40     | 739.50     | 744.60     | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | 0.00       | 0.00       | 11078.11   | 0.00       | 0.00       | 0.00       | -1387.31   | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -2463.37   | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | 0.00       | 0.00       | -27.11     | 0.00       | 0.00       | 0.00       | 677.20     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5831.90    | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5879.11    | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | 0.00       | 0.00       | -974.68    | 0.00       | 0.00       | 0.00       | -14.24     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -4592.54   | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | 0.00       | 0.00       | -0.09      | 0.00       | 0.00       | 0.00       | -1.11      | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -4625.10   | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | 0.00       | 0.00       | 10103.43   | 0.00       | 0.00       | 0.00       | -1401.55   | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -7055.91   | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | 0.00       | 0.00       | -27.20     | 0.00       | 0.00       | 0.00       | 676.09     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 1206.80    | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5879.11    | 




    # Change the date
    And   the override date is '05/04/2019'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 1               | 0                     | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 0.00       | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 10000.00   | 
    | NLAP-6060      | YNLP-6060     | 2               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 3               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 4               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | 0.00       | 0.00       | 11078.11   | 0.00       | 0.00       | 0.00       | -1387.31   | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -2463.37   | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | 0.00       | 0.00       | -27.11     | 0.00       | 0.00       | 0.00       | 677.20     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5831.90    | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5879.11    | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | 0.00       | 0.00       | -974.68    | 0.00       | 0.00       | 0.00       | -14.24     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | 0.00       | 0.00       | -0.09      | 0.00       | 0.00       | 0.00       | -1.11      | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | 0.00       | 0.00       | 10103.43   | 0.00       | 0.00       | 0.00       | -1401.55   | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -2463.37   | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | 0.00       | 0.00       | -27.20     | 0.00       | 0.00       | 0.00       | 676.09     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5831.90    | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5879.11    | 




    # Change the date
    And   the override date is '07/05/2019'

    When  The following Summarised Actuals for period 'APPS24' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 45.40      | 46.40      | 47.40      | 7146.30    | 147.40     | 148.50     | 149.60     | 698.70     | 703.80     | 708.90     | 714.00     | 719.10     | 724.20     | 729.30     | 734.40     | 
    | NLAP-6060      | YNLP-6060     | 3               | 45.50      | 46.50      | 47.50      | 147.40     | 148.50     | 149.60     | 150.70     | 703.80     | 708.90     | 714.00     | 719.10     | 724.20     | 729.30     | 734.40     | 739.50     | 
    | NLAP-6060      | YNLP-6060     | 4               | 45.60      | 46.60      | 47.60      | 148.50     | 149.60     | 150.70     | 151.80     | 708.90     | 714.00     | 719.10     | 724.20     | 729.30     | 734.40     | 739.50     | 744.60     | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | 0.00       | 0.00       | 11078.11   | 0.00       | 0.00       | 0.00       | -1387.31   | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -2463.37   | 7000.00    | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | 0.00       | 0.00       | -27.11     | 0.00       | 0.00       | 0.00       | 677.20     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5831.90    | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5879.11    | 0.00       | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | 0.00       | 0.00       | -974.68    | 0.00       | 0.00       | 0.00       | -14.24     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -749.78    | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | 0.00       | 0.00       | -0.09      | 0.00       | 0.00       | 0.00       | -1.11      | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -358.42    | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | 0.00       | 0.00       | 10103.43   | 0.00       | 0.00       | 0.00       | -1401.55   | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -2463.37   | 6250.22    | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | 0.00       | 0.00       | -27.20     | 0.00       | 0.00       | 0.00       | 676.09     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5831.90    | -358.42    | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5879.11    | 0.00       | 




    # Change the date
    And   the override date is '08/05/2019'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6060      | YNLP-6060     | 1               | 0                     | 100.00     | 100.00     | 100.00     | 2000.00    | 1500.00    | 1500.00    | 4000.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 1500.00    | 10000.00   | 
    | NLAP-6060      | YNLP-6060     | 2               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 3               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 4               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 400.00     | 0.00       | 0.00       | 11078.11   | 0.00       | 0.00       | 0.00       | -1387.31   | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -2463.37   | 7000.00    | 
    | NLAP-6060      | YNLP-6060     | 3               | 50.00      | 0.00       | 0.00       | -27.11     | 0.00       | 0.00       | 0.00       | 677.20     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5831.90    | 0.00       | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5879.11    | 0.00       | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | -175.11    | 0.00       | 0.00       | -974.68    | 0.00       | 0.00       | 0.00       | -14.24     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -59.19     | 
    | NLAP-6060      | YNLP-6060     | 3               | -21.89     | 0.00       | 0.00       | -0.09      | 0.00       | 0.00       | 0.00       | -1.11      | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -59.31     | 
    | NLAP-6060      | YNLP-6060     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | 
    | NLAP-6060      | YNLP-6060     | 2               | 224.89     | 0.00       | 0.00       | 10103.43   | 0.00       | 0.00       | 0.00       | -1401.55   | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -2463.37   | 6940.81    | 
    | NLAP-6060      | YNLP-6060     | 3               | 28.11      | 0.00       | 0.00       | -27.20     | 0.00       | 0.00       | 0.00       | 676.09     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5831.90    | -59.31     | 
    | NLAP-6060      | YNLP-6060     | 4               | 50.00      | 0.00       | 0.00       | -36.17     | 0.00       | 0.00       | 0.00       | 661.46     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 5879.11    | 0.00       | 

    And   the override date is reset

@IntegrationTest
Scenario: D061 Procured Adult NLA (ANLAP2018)
    Given there is no payment schedule data for contract 'NLAP-6161' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 61123456 | NLAP-6161      | ANLP-6161     | ANLAP             | ANLAP2018               | NONLEVY                 | 01/01/2018          | 31/03/2019        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 1               | 0                     | 1000.00    | 1000.00    | 1000.00    | 10000.00   | 10000.00   | 10000.00   | 10000.00   | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 
    | NLAP-6161      | ANLP-6161     | 2               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 3               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-6161      | ANLP-6161     | 4               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-6161      | ANLP-6161     | 5               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |

    # Change the date
    And   the override date is '06/02/2018'

    When  The following Summarised Actuals for period 'APPS09' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 2               | 3000.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 3               | 600.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 4               | 300.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 5               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 2               | 3000.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 3               | 600.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 4               | 300.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 5               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 2               | -750.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 3               | -150.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 4               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 5               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 2               | 2250.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 3               | 450.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 4               | 300.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 5               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '04/04/2019'

    When  The following Summarised Actuals for period 'APPS23' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 2               | 1200.00    | 1200.00    | 0.00       | 700.00     | 700.00     | 700.00     | 700.00     | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 
    | NLAP-6161      | ANLP-6161     | 3               | ?          | ?          | ?          | 200.00     | 200.00     | 200.00     | 200.00     | 20000.00   | 20000.00   | 20000.00   | 20000.00   | 20000.00   | 20000.00   | 20000.00   | 20000.00   | 
    | NLAP-6161      | ANLP-6161     | 4               | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 10000.00   | 10000.00   | 10000.00   | 10000.00   | 10000.00   | 10000.00   | 10000.00   | 10000.00   | 
    | NLAP-6161      | ANLP-6161     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 2               | 3000.00    | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 802950.00  | 
    | NLAP-6161      | ANLP-6161     | 3               | 600.00     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 160350.00  | 
    | NLAP-6161      | ANLP-6161     | 4               | 300.00     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 80400.00   | 
    | NLAP-6161      | ANLP-6161     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 2               | -750.00    | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -169957.66 | 
    | NLAP-6161      | ANLP-6161     | 3               | -150.00    | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -34042.34  | 
    | NLAP-6161      | ANLP-6161     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6161      | ANLP-6161     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 2               | 2250.00    | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 632992.34  | 
    | NLAP-6161      | ANLP-6161     | 3               | 450.00     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 126307.66  | 
    | NLAP-6161      | ANLP-6161     | 4               | 300.00     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 80400.00   | 
    | NLAP-6161      | ANLP-6161     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the override date is reset

@IntegrationTest
Scenario: D061b Procured Adult NLA (ANLAP2018) (no del 5)
    Given there is no payment schedule data for contract 'NLAP-6161' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 61123456 | NLAP-6161      | ANLP-6161     | ANLAP             | ANLAP2018               | NONLEVY                 | 01/01/2018          | 31/03/2019        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 1               | 0                     | 1000.00    | 1000.00    | 1000.00    | 10000.00   | 10000.00   | 10000.00   | 10000.00   | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 
    | NLAP-6161      | ANLP-6161     | 2               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-6161      | ANLP-6161     | 3               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-6161      | ANLP-6161     | 4               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |

    # Change the date
    And   the override date is '06/02/2018'

    When  The following Summarised Actuals for period 'APPS09' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 2               | 3000.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 3               | 600.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 4               | 300.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 2               | 3000.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 3               | 600.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 4               | 300.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 2               | -750.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 3               | -150.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 4               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 2               | 2250.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 3               | 450.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6161      | ANLP-6161     | 4               | 300.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '04/04/2019'

    When  The following Summarised Actuals for period 'APPS23' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 2               | 1200.00    | 1200.00    | 0.00       | 700.00     | 700.00     | 700.00     | 700.00     | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 100000.00  | 
    | NLAP-6161      | ANLP-6161     | 3               | ?          | ?          | ?          | 200.00     | 200.00     | 200.00     | 200.00     | 20000.00   | 20000.00   | 20000.00   | 20000.00   | 20000.00   | 20000.00   | 20000.00   | 20000.00   | 
    | NLAP-6161      | ANLP-6161     | 4               | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 10000.00   | 10000.00   | 10000.00   | 10000.00   | 10000.00   | 10000.00   | 10000.00   | 10000.00   | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 2               | 3000.00    | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 802950.00  | 
    | NLAP-6161      | ANLP-6161     | 3               | 600.00     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 160350.00  | 
    | NLAP-6161      | ANLP-6161     | 4               | 300.00     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 80400.00   | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 2               | -750.00    | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -169957.66 | 
    | NLAP-6161      | ANLP-6161     | 3               | -150.00    | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -34042.34  | 
    | NLAP-6161      | ANLP-6161     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-6161      | ANLP-6161     | 2               | 2250.00    | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 632992.34  | 
    | NLAP-6161      | ANLP-6161     | 3               | 450.00     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 126307.66  | 
    | NLAP-6161      | ANLP-6161     | 4               | 300.00     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 80400.00   | 

    And   the override date is reset

@IntegrationTest
Scenario: D063 Procured Adult NLA (ANLAP2018) - short allocation
    Given there is no payment schedule data for contract 'NLAP-6363' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 63123456 | NLAP-6363      | ANLP-6363     | ANLAP             | ANLAP2018               | NONLEVY                 | 01/03/2018          | 01/08/2018        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 1               | 0                     | 10000.00   | 20000.00   | 20000.00   | 20000.00   | 20000.00   | 20000.00   | 
    | NLAP-6363      | ANLP-6363     | 2               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-6363      | ANLP-6363     | 3               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-6363      | ANLP-6363     | 4               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-6363      | ANLP-6363     | 5               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          |

    # Change the date
    And   the override date is '06/04/2018'

    When  The following Summarised Actuals for period 'APPS11' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 6300.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 2100.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 6300.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 2100.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | -750.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | -250.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 0.00       | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 5550.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 1850.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '04/05/2018'

    When  The following Summarised Actuals for period 'APPS12' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 6300.00    | 78000.00   | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 2100.00    | 26000.00   | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 600.00     | 6000.00    | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 6300.00    | 78750.00   | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 2100.00    | 26250.00   | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | -750.00    | -7500.00   | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | -250.00    | -2500.00   | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 0.00       | 0.00       | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 5550.00    | 71250.00   | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 1850.00    | 23750.00   | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '20/05/2018'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 1               | 0                     | 11000.00   | 22000.00   | 22000.00   | 22000.00   | 22000.00   | 22000.00   | 
    | NLAP-6363      | ANLP-6363     | 2               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 3               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 4               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 5               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 6300.00    | 78750.00   | 7500.00    | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 2100.00    | 26250.00   | 2500.00    | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | 0.00       | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | -750.00    | -7500.00   | 0.00       | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | -250.00    | -2500.00   | 0.00       | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 5550.00    | 71250.00   | 7500.00    | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 1850.00    | 23750.00   | 2500.00    | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | 0.00       | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '06/06/2018'

    When  The following Summarised Actuals for period 'APPS13' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 2100.00    | 78000.00   | 23000.00   | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 6300.00    | 0.00       | 0.00       | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 3600.00    | 6000.00    | 5000.00    | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 6300.00    | 78750.00   | 26300.00   | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 2100.00    | 26250.00   | -19300.00  | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | 8000.00    | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | -750.00    | -7500.00   | -2250.00   | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | -250.00    | -2500.00   | -750.00    | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 5550.00    | 71250.00   | 24050.00   | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 1850.00    | 23750.00   | -20050.00  | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | 8000.00    | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '04/10/2018'

    When  The following Summarised Actuals for period 'APPS17' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 10000.00   | 7401.50    | 7041.50    | 7042.50    | 7043.50    | 7044.50    | 
    | NLAP-6363      | ANLP-6363     | 3               | 0.00       | 7040.60    | 7041.60    | 7042.60    | 7043.60    | 7044.60    | 
    | NLAP-6363      | ANLP-6363     | 4               | 2000.00    | 7040.70    | 7041.70    | 7042.70    | 7043.70    | 7044.70    | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 6300.00    | 78750.00   | 26300.00   | 0.00       | 0.00       | 0.00       | -55276.50  | 
    | NLAP-6363      | ANLP-6363     | 3               | 2100.00    | 26250.00   | -19300.00  | 0.00       | 0.00       | 0.00       | 29663.00   | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | 8000.00    | 0.00       | 0.00       | 0.00       | 22613.50   | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | -750.00    | -7500.00   | -2250.00   | 0.00       | 0.00       | 0.00       | -1000.00   | 
    | NLAP-6363      | ANLP-6363     | 3               | -250.00    | -2500.00   | -750.00    | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 5550.00    | 71250.00   | 24050.00   | 0.00       | 0.00       | 0.00       | -56276.50  | 
    | NLAP-6363      | ANLP-6363     | 3               | 1850.00    | 23750.00   | -20050.00  | 0.00       | 0.00       | 0.00       | 29663.00   | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | 8000.00    | 0.00       | 0.00       | 0.00       | 22613.50   | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 




    # Change the date
    And   the override date is '01/11/2018'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 1               | 0                     | 11000.00   | 17000.00   | 22000.00   | 22000.00   | 22000.00   | 22000.00   | 
    | NLAP-6363      | ANLP-6363     | 2               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 3               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 4               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 5               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 6300.00    | 78750.00   | 26300.00   | 0.00       | 0.00       | 0.00       | -55276.50  | 1000.00    | 
    | NLAP-6363      | ANLP-6363     | 3               | 2100.00    | 26250.00   | -19300.00  | 0.00       | 0.00       | 0.00       | 29663.00   | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | 8000.00    | 0.00       | 0.00       | 0.00       | 22613.50   | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | -750.00    | -7500.00   | -2250.00   | 0.00       | 0.00       | 0.00       | -1000.00   | -1502.55   | 
    | NLAP-6363      | ANLP-6363     | 3               | -250.00    | -2500.00   | -750.00    | 0.00       | 0.00       | 0.00       | 0.00       | -497.45    | 
    | NLAP-6363      | ANLP-6363     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 5550.00    | 71250.00   | 24050.00   | 0.00       | 0.00       | 0.00       | -56276.50  | -502.55    | 
    | NLAP-6363      | ANLP-6363     | 3               | 1850.00    | 23750.00   | -20050.00  | 0.00       | 0.00       | 0.00       | 29663.00   | -497.45    | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | 8000.00    | 0.00       | 0.00       | 0.00       | 22613.50   | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 5               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the override date is reset

@IntegrationTest
Scenario: D063b Procured Adult NLA (ANLAP2018) - short allocation (no del 5)
    Given there is no payment schedule data for contract 'NLAP-6363' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 63123456 | NLAP-6363      | ANLP-6363     | ANLAP             | ANLAP2018               | NONLEVY                 | 01/03/2018          | 01/08/2018        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 1               | 0                     | 10000.00   | 20000.00   | 20000.00   | 20000.00   | 20000.00   | 20000.00   | 
    | NLAP-6363      | ANLP-6363     | 2               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-6363      | ANLP-6363     | 3               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-6363      | ANLP-6363     | 4               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          |

    # Change the date
    And   the override date is '06/04/2018'

    When  The following Summarised Actuals for period 'APPS11' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 6300.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 2100.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 6300.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 2100.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | -750.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | -250.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 0.00       | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 5550.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 1850.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '04/05/2018'

    When  The following Summarised Actuals for period 'APPS12' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 6300.00    | 78000.00   | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 2100.00    | 26000.00   | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 600.00     | 6000.00    | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 6300.00    | 78750.00   | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 2100.00    | 26250.00   | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | -750.00    | -7500.00   | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | -250.00    | -2500.00   | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 0.00       | 0.00       | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 5550.00    | 71250.00   | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 1850.00    | 23750.00   | ?          | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '20/05/2018'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 1               | 0                     | 11000.00   | 22000.00   | 22000.00   | 22000.00   | 22000.00   | 22000.00   | 
    | NLAP-6363      | ANLP-6363     | 2               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 3               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 4               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 6300.00    | 78750.00   | 7500.00    | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 2100.00    | 26250.00   | 2500.00    | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | 0.00       | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | -750.00    | -7500.00   | 0.00       | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | -250.00    | -2500.00   | 0.00       | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 5550.00    | 71250.00   | 7500.00    | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 1850.00    | 23750.00   | 2500.00    | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | 0.00       | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '06/06/2018'

    When  The following Summarised Actuals for period 'APPS13' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 2100.00    | 78000.00   | 23000.00   | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 6300.00    | 0.00       | 0.00       | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 3600.00    | 6000.00    | 5000.00    | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 6300.00    | 78750.00   | 26300.00   | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 2100.00    | 26250.00   | -19300.00  | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | 8000.00    | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | -750.00    | -7500.00   | -2250.00   | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | -250.00    | -2500.00   | -750.00    | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 5550.00    | 71250.00   | 24050.00   | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 3               | 1850.00    | 23750.00   | -20050.00  | ?          | ?          | ?          | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | 8000.00    | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '04/10/2018'

    When  The following Summarised Actuals for period 'APPS17' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 10000.00   | 7401.50    | 7041.50    | 7042.50    | 7043.50    | 7044.50    | 
    | NLAP-6363      | ANLP-6363     | 3               | 0.00       | 7040.60    | 7041.60    | 7042.60    | 7043.60    | 7044.60    | 
    | NLAP-6363      | ANLP-6363     | 4               | 2000.00    | 7040.70    | 7041.70    | 7042.70    | 7043.70    | 7044.70    | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 6300.00    | 78750.00   | 26300.00   | 0.00       | 0.00       | 0.00       | -55276.50  | 
    | NLAP-6363      | ANLP-6363     | 3               | 2100.00    | 26250.00   | -19300.00  | 0.00       | 0.00       | 0.00       | 29663.00   | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | 8000.00    | 0.00       | 0.00       | 0.00       | 22613.50   | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | -750.00    | -7500.00   | -2250.00   | 0.00       | 0.00       | 0.00       | -1000.00   | 
    | NLAP-6363      | ANLP-6363     | 3               | -250.00    | -2500.00   | -750.00    | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 5550.00    | 71250.00   | 24050.00   | 0.00       | 0.00       | 0.00       | -56276.50  | 
    | NLAP-6363      | ANLP-6363     | 3               | 1850.00    | 23750.00   | -20050.00  | 0.00       | 0.00       | 0.00       | 29663.00   | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | 8000.00    | 0.00       | 0.00       | 0.00       | 22613.50   | 




    # Change the date
    And   the override date is '01/11/2018'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | 
    | NLAP-6363      | ANLP-6363     | 1               | 0                     | 11000.00   | 17000.00   | 22000.00   | 22000.00   | 22000.00   | 22000.00   | 
    | NLAP-6363      | ANLP-6363     | 2               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 3               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 4               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 6300.00    | 78750.00   | 26300.00   | 0.00       | 0.00       | 0.00       | -55276.50  | 1000.00    | 
    | NLAP-6363      | ANLP-6363     | 3               | 2100.00    | 26250.00   | -19300.00  | 0.00       | 0.00       | 0.00       | 29663.00   | 0.00       | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | 8000.00    | 0.00       | 0.00       | 0.00       | 22613.50   | 0.00       | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | -750.00    | -7500.00   | -2250.00   | 0.00       | 0.00       | 0.00       | -1000.00   | -1502.55   | 
    | NLAP-6363      | ANLP-6363     | 3               | -250.00    | -2500.00   | -750.00    | 0.00       | 0.00       | 0.00       | 0.00       | -497.45    | 
    | NLAP-6363      | ANLP-6363     | 4               | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | 
    | NLAP-6363      | ANLP-6363     | 2               | 5550.00    | 71250.00   | 24050.00   | 0.00       | 0.00       | 0.00       | -56276.50  | -502.55    | 
    | NLAP-6363      | ANLP-6363     | 3               | 1850.00    | 23750.00   | -20050.00  | 0.00       | 0.00       | 0.00       | 29663.00   | -497.45    | 
    | NLAP-6363      | ANLP-6363     | 4               | 2600.00    | 4000.00    | 8000.00    | 0.00       | 0.00       | 0.00       | 22613.50   | 0.00       | 

    And   the override date is reset

@IntegrationTest
    Scenario: D073 16-18NLAP2018 - 3 capping priority groups
    Given there is no payment schedule data for contract 'NLAP-7373' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 73123456 | NLAP-7373      | YNLP-7373     | 16-18NLAP         | 16-18NLAP2018           | NONLEVY                 | 01/01/2018          | 31/03/2019        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 1               | 0                     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 
    | NLAP-7373      | YNLP-7373     | 2               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-7373      | YNLP-7373     | 3               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-7373      | YNLP-7373     | 4               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-7373      | YNLP-7373     | 5               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |

    # Change the date
    And   the override date is '06/02/2018'

    When  The following Summarised Actuals for period 'APPS09' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '06/03/2018'

    When  The following Summarised Actuals for period 'APPS10' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 200.00     | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 50.00      | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 275.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 75.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 0.00       | -150.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 0.00       | -50.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 125.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '06/04/2018'

    When  The following Summarised Actuals for period 'APPS11' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 200.00     | 100.00     | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 50.00      | 50.00      | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | 200.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 275.00     | 150.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 75.00      | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | 200.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 0.00       | -150.00    | -300.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 0.00       | -50.00     | -100.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 0.00       | 0.00       | -100.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 125.00     | -150.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 25.00      | -50.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '07/04/2018'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 1               | 0                     | 40.00      | 40.00      | 40.00      | 70.00      | 30.00      | 30.00      | 30.00      | 30.00      | 30.00      | 30.00      | 30.00      | 30.00      | 30.00      | 30.00      | 30.00      | 
    | NLAP-7373      | YNLP-7373     | 2               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-7373      | YNLP-7373     | 3               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-7373      | YNLP-7373     | 4               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-7373      | YNLP-7373     | 5               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 275.00     | 150.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 75.00      | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | 200.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 0.00       | -150.00    | -300.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 0.00       | -50.00     | -100.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 0.00       | 0.00       | -250.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 0.00       | 0.00       | -30.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 125.00     | -150.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 25.00      | -50.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | -50.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 70.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '04/05/2018'

    When  The following Summarised Actuals for period 'APPS12' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 200.00     | 100.00     | 0.00       | 300.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 50.00      | 50.00      | 0.00       | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | 200.00     | 150.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 100.00     | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 275.00     | 150.00     | 600.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 75.00      | 50.00      | 200.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | 200.00     | 400.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 100.00     | 80.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 0.00       | -150.00    | -300.00    | -450.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 0.00       | -50.00     | -100.00    | -150.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 0.00       | 0.00       | -250.00    | -250.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 0.00       | 0.00       | -30.00     | -30.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 125.00     | -150.00    | 150.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 25.00      | -50.00     | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | -50.00     | 150.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 70.00      | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '06/06/2018'

    When  The following Summarised Actuals for period 'APPS13' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 200.00     | 100.00     | 0.00       | 300.00     | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 50.00      | 50.00      | 0.00       | 100.00     | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | 200.00     | 150.00     | 200.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 50.00      | 50.00      | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 275.00     | 150.00     | 600.00     | 500.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 75.00      | 50.00      | 200.00     | 200.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | 200.00     | 400.00     | 450.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 100.00     | 80.00      | 30.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 0.00       | -150.00    | -300.00    | -450.00    | -650.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 0.00       | -50.00     | -100.00    | -150.00    | -250.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 0.00       | 0.00       | -250.00    | -250.00    | -280.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 0.00       | 0.00       | -30.00     | -30.00     | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 125.00     | -150.00    | 150.00     | -150.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 25.00      | -50.00     | 50.00      | -50.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | -50.00     | 150.00     | 170.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 70.00      | 50.00      | 30.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '05/07/2018'

    When  The following Summarised Actuals for period 'APPS14' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 200.00     | 100.00     | 0.00       | 300.00     | 50.00      | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 50.00      | 50.00      | 0.00       | 100.00     | 50.00      | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 0.00       | 0.00       | 10.00      | 150.00     | 200.00     | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 50.00      | 200.00     | 200.00     | 900.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 275.00     | 150.00     | 600.00     | 500.00     | 650.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 75.00      | 50.00      | 200.00     | 200.00     | 250.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | 200.00     | 400.00     | 450.00     | 40.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 100.00     | 80.00      | 30.00      | 1200.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 0.00       | -150.00    | -300.00    | -450.00    | -650.00    | -642.50    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 0.00       | -50.00     | -100.00    | -150.00    | -250.00    | -247.50    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 0.00       | 0.00       | -250.00    | -250.00    | -280.00    | -350.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 0.00       | 0.00       | -30.00     | -30.00     | 0.00       | -900.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 125.00     | -150.00    | 150.00     | -150.00    | 7.50       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 25.00      | -50.00     | 50.00      | -50.00     | 2.50       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | -50.00     | 150.00     | 170.00     | -310.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 70.00      | 50.00      | 30.00      | 300.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '06/07/2018'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 1               | 0                     | 200.00     | 200.00     | 200.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 
    | NLAP-7373      | YNLP-7373     | 2               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-7373      | YNLP-7373     | 3               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-7373      | YNLP-7373     | 4               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-7373      | YNLP-7373     | 5               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 275.00     | 150.00     | 600.00     | 500.00     | 650.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 75.00      | 50.00      | 200.00     | 200.00     | 250.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | 200.00     | 400.00     | 450.00     | 40.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 100.00     | 80.00      | 30.00      | 1200.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 0.00       | -150.00    | -300.00    | -450.00    | -650.00    | -350.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 0.00       | -50.00     | -100.00    | -150.00    | -250.00    | -150.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 0.00       | 0.00       | -250.00    | -250.00    | -280.00    | -350.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 0.00       | 0.00       | -30.00     | -30.00     | 0.00       | -100.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 125.00     | -150.00    | 150.00     | -150.00    | 300.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 25.00      | -50.00     | 50.00      | -50.00     | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | -50.00     | 150.00     | 170.00     | -310.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 70.00      | 50.00      | 30.00      | 1100.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '06/08/2018'

    When  The following Summarised Actuals for period 'APPS15' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 200.00     | 100.00     | 0.00       | 20.00      | 20.00      | 20.00      | 20.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 50.00      | 50.00      | 0.00       | 20.00      | 20.00      | 20.00      | 20.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 0.00       | 0.00       | 10.00      | 20.00      | 20.00      | 20.00      | 20.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 50.00      | 20.00      | 20.00      | 20.00      | 20.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 275.00     | 150.00     | 600.00     | 500.00     | 650.00     | 80.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 75.00      | 50.00      | 200.00     | 200.00     | 250.00     | 80.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | 200.00     | 400.00     | 450.00     | 40.00      | 80.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 100.00     | 80.00      | 30.00      | 1200.00    | -1120.00   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 0.00       | -150.00    | -300.00    | -450.00    | -650.00    | -350.00    | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 0.00       | -50.00     | -100.00    | -150.00    | -250.00    | -150.00    | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 0.00       | 0.00       | -250.00    | -250.00    | -280.00    | -350.00    | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 0.00       | 0.00       | -30.00     | -30.00     | 0.00       | -100.00    | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 125.00     | -150.00    | 150.00     | -150.00    | 300.00     | 80.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 25.00      | -50.00     | 50.00      | -50.00     | 100.00     | 80.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | -50.00     | 150.00     | 170.00     | -310.00    | 80.00      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 70.00      | 50.00      | 30.00      | 1100.00    | -1120.00   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '06/09/2018'

    When  The following Summarised Actuals for period 'APPS16' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 200.00     | 100.00     | 0.00       | 20.00      | 20.00      | 20.00      | 20.00      | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 50.00      | 50.00      | 0.00       | 20.00      | 20.00      | 20.00      | 20.00      | 300.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 0.00       | 0.00       | 10.00      | 20.00      | 20.00      | 20.00      | 20.00      | 400.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 50.00      | 20.00      | 20.00      | 20.00      | 20.00      | 300.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 275.00     | 150.00     | 600.00     | 500.00     | 650.00     | 80.00      | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 75.00      | 50.00      | 200.00     | 200.00     | 250.00     | 80.00      | 300.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | 200.00     | 400.00     | 450.00     | 40.00      | 80.00      | 400.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 100.00     | 80.00      | 30.00      | 1200.00    | -1120.00   | 300.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 0.00       | -150.00    | -300.00    | -450.00    | -650.00    | -350.00    | 0.00       | -70.71     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 0.00       | -50.00     | -100.00    | -150.00    | -250.00    | -150.00    | 0.00       | -149.29    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 0.00       | 0.00       | -250.00    | -250.00    | -280.00    | -350.00    | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 0.00       | 0.00       | -30.00     | -30.00     | 0.00       | -100.00    | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 125.00     | -150.00    | 150.00     | -150.00    | 300.00     | 80.00      | 29.29      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 25.00      | -50.00     | 50.00      | -50.00     | 100.00     | 80.00      | 150.71     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | -50.00     | 150.00     | 170.00     | -310.00    | 80.00      | 400.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 70.00      | 50.00      | 30.00      | 1100.00    | -1120.00   | 300.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '04/10/2018'

    When  The following Summarised Actuals for period 'APPS17' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 200.00     | 100.00     | 50.00      | 20.00      | 20.00      | 20.00      | 20.00      | 100.00     | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 50.00      | 50.00      | 50.00      | 20.00      | 20.00      | 20.00      | 20.00      | 300.00     | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 0.00       | 0.00       | 10.00      | 50.00      | 50.00      | 50.00      | 50.00      | 400.00     | 50.00      | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 50.00      | 60.00      | 60.00      | 60.00      | 60.00      | 300.00     | 600.00     | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 275.00     | 150.00     | 600.00     | 500.00     | 650.00     | 80.00      | 100.00     | 170.71     | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 75.00      | 50.00      | 200.00     | 200.00     | 250.00     | 80.00      | 300.00     | 249.29     | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | 200.00     | 400.00     | 450.00     | 40.00      | 80.00      | 400.00     | 170.00     | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 100.00     | 80.00      | 30.00      | 1200.00    | -1120.00   | 300.00     | 760.00     | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 0.00       | -150.00    | -300.00    | -450.00    | -650.00    | -350.00    | 0.00       | -70.71     | -237.00    | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 0.00       | -50.00     | -100.00    | -150.00    | -250.00    | -150.00    | 0.00       | -149.29    | -433.00    | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 0.00       | 0.00       | -250.00    | -250.00    | -280.00    | -350.00    | 0.00       | 0.00       | -590.00    | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 0.00       | 0.00       | -30.00     | -30.00     | 0.00       | -100.00    | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 125.00     | -150.00    | 150.00     | -150.00    | 300.00     | 80.00      | 29.29      | -66.29     | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 25.00      | -50.00     | 50.00      | -50.00     | 100.00     | 80.00      | 150.71     | -183.71    | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | -50.00     | 150.00     | 170.00     | -310.00    | 80.00      | 400.00     | -420.00    | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 70.00      | 50.00      | 30.00      | 1100.00    | -1120.00   | 300.00     | 760.00     | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '15/10/2018'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 1               | 0                     | 20.00      | 20.00      | 65.00      | 110.00     | 110.00     | 110.00     | 110.00     | 300.00     | 300.00     | 300.00     | 300.00     | 300.00     | 300.00     | 300.00     | 300.00     | 
    | NLAP-7373      | YNLP-7373     | 2               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-7373      | YNLP-7373     | 3               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-7373      | YNLP-7373     | 4               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 
    | NLAP-7373      | YNLP-7373     | 5               | 1                     | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 275.00     | 150.00     | 600.00     | 500.00     | 650.00     | 80.00      | 100.00     | 170.71     | 237.00     | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 75.00      | 50.00      | 200.00     | 200.00     | 250.00     | 80.00      | 300.00     | 249.29     | 433.00     | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | 200.00     | 400.00     | 450.00     | 40.00      | 80.00      | 400.00     | 170.00     | 590.00     | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 100.00     | 80.00      | 30.00      | 1200.00    | -1120.00   | 300.00     | 760.00     | 0.00       | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 0.00       | -150.00    | -300.00    | -450.00    | -650.00    | -350.00    | 0.00       | -70.71     | -237.00    | -350.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 0.00       | -50.00     | -100.00    | -150.00    | -250.00    | -150.00    | 0.00       | -149.29    | -433.00    | -150.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 0.00       | 0.00       | -250.00    | -250.00    | -280.00    | -350.00    | 0.00       | 0.00       | -590.00    | -5.00      | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 0.00       | 0.00       | -30.00     | -30.00     | 0.00       | -100.00    | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7373      | YNLP-7373     | 2               | 25.00      | 125.00     | -150.00    | 150.00     | -150.00    | 300.00     | 80.00      | 29.29      | -66.29     | -113.00    | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 3               | 25.00      | 25.00      | -50.00     | 50.00      | -50.00     | 100.00     | 80.00      | 150.71     | -183.71    | 283.00     | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 4               | 25.00      | 25.00      | -50.00     | 150.00     | 170.00     | -310.00    | 80.00      | 400.00     | -420.00    | 585.00     | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7373      | YNLP-7373     | 5               | 25.00      | 25.00      | 70.00      | 50.00      | 30.00      | 1100.00    | -1120.00   | 300.00     | 760.00     | 0.00       | ?          | ?          | ?          | ?          | ?          | 

    And   the override date is reset

@IntegrationTest
Scenario: D074 ANLAP2018 - 3 capping priority groups
    Given there is no payment schedule data for contract 'NLAP-7474' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 74123456 | NLAP-7474      | ANLP-7474     | ANLAP             | ANLAP2018               | NONLEVY                 | 01/01/2018          | 31/03/2019        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7474      | ANLP-7474     | 1               | 0                     | 100.00     | 100.00     | 100.00     | 200.00     | 200.00     | 200.00     | 200.00     | 300.00     | 300.00     | 300.00     | 300.00     | 300.00     | 300.00     | 300.00     | 300.00     | 
    | NLAP-7474      | ANLP-7474     | 2               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-7474      | ANLP-7474     | 3               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-7474      | ANLP-7474     | 4               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |
    | NLAP-7474      | ANLP-7474     | 5               | 0                     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          |

    # Change the date
    And   the override date is '06/02/2018'

    When  The following Summarised Actuals for period 'APPS09' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7474      | ANLP-7474     | 2               | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 3               | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 4               | 300.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 5               | 200.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7474      | ANLP-7474     | 2               | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 3               | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 4               | 300.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 5               | 200.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7474      | ANLP-7474     | 2               | -100.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 3               | -100.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 4               | -200.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 5               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7474      | ANLP-7474     | 2               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 3               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 4               | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 5               | 200.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '04/05/2018'

    When  The following Summarised Actuals for period 'APPS12' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7474      | ANLP-7474     | 2               | 100.00     | 0.00       | 50.00      | 200.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 3               | 100.00     | 0.00       | 0.00       | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 4               | 50.00      | 0.00       | 50.00      | 200.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 5               | 100.00     | 50.00      | 160.00     | 700.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7474      | ANLP-7474     | 2               | 100.00     | 0.00       | 0.00       | 350.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 3               | 100.00     | 0.00       | 0.00       | 200.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 4               | 300.00     | 0.00       | 0.00       | 200.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 5               | 200.00     | 0.00       | 0.00       | 810.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7474      | ANLP-7474     | 2               | -100.00    | 0.00       | 0.00       | -150.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 3               | -100.00    | 0.00       | 0.00       | -100.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 4               | -200.00    | 0.00       | 0.00       | -100.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 5               | 0.00       | 0.00       | 0.00       | -10.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7474      | ANLP-7474     | 2               | 0.00       | 0.00       | 0.00       | 200.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 3               | 0.00       | 0.00       | 0.00       | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 4               | 100.00     | 0.00       | 0.00       | 100.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 5               | 200.00     | 0.00       | 0.00       | 800.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '06/09/2018'

    When  The following Summarised Actuals for period 'APPS16' for collection type 'APPS' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7474      | ANLP-7474     | 2               | 0.00       | 30.00      | 0.00       | 25.00      | 25.00      | 25.00      | 25.00      | 1000.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 3               | 0.00       | 10.00      | 0.00       | 75.00      | 75.00      | 75.00      | 75.00      | 500.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 4               | 50.00      | 0.00       | 50.00      | 90.00      | 90.00      | 90.00      | 90.00      | 1000.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 5               | 100.00     | 50.00      | 0.00       | 90.00      | 90.00      | 90.00      | 90.00      | 2000.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7474      | ANLP-7474     | 2               | 100.00     | 0.00       | 0.00       | 350.00     | 0.00       | 0.00       | 0.00       | 930.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 3               | 100.00     | 0.00       | 0.00       | 200.00     | 0.00       | 0.00       | 0.00       | 710.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 4               | 300.00     | 0.00       | 0.00       | 200.00     | 0.00       | 0.00       | 0.00       | 1260.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 5               | 200.00     | 0.00       | 0.00       | 810.00     | 0.00       | 0.00       | 0.00       | 1510.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7474      | ANLP-7474     | 2               | -100.00    | 0.00       | 0.00       | -150.00    | 0.00       | 0.00       | 0.00       | -1100.00   | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 3               | -100.00    | 0.00       | 0.00       | -100.00    | 0.00       | 0.00       | 0.00       | -800.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 4               | -200.00    | 0.00       | 0.00       | -100.00    | 0.00       | 0.00       | 0.00       | -520.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 5               | 0.00       | 0.00       | 0.00       | -10.00     | 0.00       | 0.00       | 0.00       | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Jan-18     | Feb-18     | Mar-18     | Apr-18     | May-18     | Jun-18     | Jul-18     | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | 
    | NLAP-7474      | ANLP-7474     | 2               | 0.00       | 0.00       | 0.00       | 200.00     | 0.00       | 0.00       | 0.00       | -170.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 3               | 0.00       | 0.00       | 0.00       | 100.00     | 0.00       | 0.00       | 0.00       | -90.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 4               | 100.00     | 0.00       | 0.00       | 100.00     | 0.00       | 0.00       | 0.00       | 740.00     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 
    | NLAP-7474      | ANLP-7474     | 5               | 200.00     | 0.00       | 0.00       | 800.00     | 0.00       | 0.00       | 0.00       | 1510.00    | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the override date is reset

