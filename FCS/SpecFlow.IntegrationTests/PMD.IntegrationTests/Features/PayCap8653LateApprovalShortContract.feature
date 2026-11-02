@Feature8653    
Feature: Capping8653 Calculate capping payments where contract is approved or allocation is shorter than FSP

@DoNotRun
Scenario: D106 contract containing an AGE contract allocation is approved late.  Actuals are submitted and breach cap 

    Given there is no payment schedule data for contract 'EMPAGE-106' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
    | 10017802 | EMPAGE-106       | AGE-106      | AGE              | AGE1516				  | FY                      |  01/04/2015         | 31/03/2016         |

	And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   |
    | EMPAGE-106     | AGE-106       | 1               | 0                     | 10.00	  | 20.00    | 30.00    | 40.00    | 50.00    | 60.00    | 70.00    | 80.00    | 90.00    | 100.00   | 110.00   | 120.00   |
    | EMPAGE-106     | AGE-106       | 2               | 0                     | 100.00   | 110.00   | 120.00   | 130.00   | 140.00   | 150.00   | 160.00   | 170.00   | 180.00   | 190.00   | 200.00   | 210.00    |

    #
    # Actuals for November 2015
    #
    And   the override date is '17/12/2015'
    When   The following Summarised Actuals for period 'G04' for collection type 'AGE' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | EMPAGE-106     | AGE-106       | 1               | 30.00    | 60.00    | 90.00    | 120.00   | 150.00   | 180.00   | 210.00   | 240.00   | ?        | ?        | ?        | ?         |
    | EMPAGE-106     | AGE-106       | 2               | 101.00   | 111.00   | 121.00   | 131.00   | 141.00   | 151.00   | 161.00   | 171.00   | ?        | ?        | ?        | ?         |

    Then   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | EMPAGE-106     | AGE-106       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1080.00  | ?        | ?        | ?        | ?         |
    | EMPAGE-106     | AGE-106       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1088.00  | ?        | ?        | ?        | ?         |
	
	And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | EMPAGE-106     | AGE-106       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -300.00  | ?        | ?        | ?        | ?         |
    | EMPAGE-106     | AGE-106       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?         |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | EMPAGE-106     | AGE-106       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 780.00   | ?        | ?        | ?        | ?         |
    | EMPAGE-106     | AGE-106       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1088.00  | ?        | ?        | ?        | ?         |
    
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | EMPAGE-106     | AGE-106       | 2260010                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1080.00  | ?        | ?        | ?        | ?         |
    | EMPAGE-106     | AGE-106       | 2360010                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1088.00  | ?        | ?        | ?        | ?         |

    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | CappingSubnominal | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | EMPAGE-106     | AGE-106       | 2260010           | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -300     | ?        | ?        | ?        | ?         |
    | EMPAGE-106     | AGE-106       | 2360010           | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?         |

    And   the override date is reset

