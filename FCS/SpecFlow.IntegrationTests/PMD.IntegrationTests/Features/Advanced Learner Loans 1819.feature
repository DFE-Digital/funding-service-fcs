Feature: Advanced Learner Loans 1819

@DoNotRun_7Mar2024
Scenario: D068 CLP1819
    Given there is no payment schedule data for contract 'LOANS-6868' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate |
    | 68123456 | LOANS-6868     | CLP-6868      | CLP               | CLP1819                 | AY                      | 01/08/2018          | 31/07/2019        |

    And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 0                     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 100.00     | 




    # Change the date
    And   the override date is '06/09/2018'

    When  The following Summarised Actuals for period 'R01' for collection type 'ILR1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 799.99     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 799.99     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 0.00       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 799.99     | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '04/10/2018'

    When  The following Summarised Actuals for period 'R02' for collection type 'ILR1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 799.99     | 0.02       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 799.99     | 0.02       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 0.00       | -0.01      | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 799.99     | 0.01       | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '07/05/2019'

    When  The following Summarised Actuals for period 'R09' for collection type 'ILR1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 99.00      | 99.00      | 99.00      | 99.00      | 99.00      | 99.00      | 99.00      | 99.00      | 400.01     | ?          | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 799.99     | 0.02       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 392.01     | ?          | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 0.00       | -0.01      | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -0.01      | ?          | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 799.99     | 0.01       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 392.00     | ?          | ?          | ?          | 




    # Change the date
    And   the override date is '15/05/2019'

    When the contract is amended as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 0                     | 98.00      | 98.00      | 98.00      | 98.00      | 98.00      | 98.00      | 98.00      | 98.00      | 100.00     | 100.00     | 100.00     | 100.00     | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 799.99     | 0.02       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 392.01     | 0.01       | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 0.00       | -0.01      | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -0.01      | -8.01      | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 799.99     | 0.01       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 392.00     | -8.00      | ?          | ?          | 




    # Change the date
    And   the override date is '06/06/2019'

    When  The following Summarised Actuals for period 'R10' for collection type 'ILR1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 99.00      | 99.00      | 99.00      | 99.00      | 99.00      | 99.00      | 99.00      | 99.00      | 399.99     | 0.01       | ?          | ?          | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 799.99     | 0.02       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 392.01     | 0.00       | ?          | ?          | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 0.00       | -0.01      | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -0.01      | -8.00      | ?          | ?          | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 799.99     | 0.01       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 392.00     | -8.00      | ?          | ?          | 




    # Change the date
    And   the override date is '06/08/2019'

    When  The following Summarised Actuals for period 'R12' for collection type 'ILR1819' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 97.00      | 97.00      | 97.00      | 97.00      | 97.00      | 97.00      | 97.00      | 97.00      | 97.00      | 97.00      | 97.00      | 97.00      | 

    Then  the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 799.99     | 0.02       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 392.01     | 0.00       | 0.00       | -20.00     | 

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 0.00       | -0.01      | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | -0.01      | -8.00      | 0.00       | 0.00       | 

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-18     | Sep-18     | Oct-18     | Nov-18     | Dec-18     | Jan-19     | Feb-19     | Mar-19     | Apr-19     | May-19     | Jun-19     | Jul-19     | 
    | LOANS-6868     | CLP-6868      | 1               | 799.99     | 0.01       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 0.00       | 392.00     | -8.00      | 0.00       | -20.00     | 

    And   the override date is reset


