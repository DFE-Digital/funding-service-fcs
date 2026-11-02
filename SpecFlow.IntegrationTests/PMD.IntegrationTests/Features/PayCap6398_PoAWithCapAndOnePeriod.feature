@Feature6398  
Feature: Capping8729 Calculate capping payments with one capping period

@DoNotRun
Scenario: D101 A contract containing an AGE contract allocation is approved on time. Actuals are submitted at R01 and immediately breach cap. The cap is carried forward to R02, R03, etc so that net payments calculated after R01 = 0
    Given there is no payment schedule data for contract 'EMPAGE-102' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
    | 10017101 | EMPAGE-102       | AGE-102      | AGE              | AGE1516				  | FY                      |  02/04/2015         | 01/03/2016         |

	And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   |
    | EMPAGE-102     | AGE-102       | 1               | 0                     | 10.00	  | 20.00    | 30.00    | 40.00    | 50.00    | 60.00    | 70.00    | 80.00    | 90.00    | 100.00   | 110.00   | 120.00   |
    | EMPAGE-102     | AGE-102       | 2               | 0                     | 110.00	  | 20.00    | 30.00    | 40.00    | 50.00    | 60.00    | 70.00    | 80.00    | 90.00    | 100.00   | 110.00   | 120.00   |

    #
    # Actuals for April 2015
    #
    And   the override date is '20/05/2015'
    When   The following Summarised Actuals for period 'G04' for collection type 'AGE' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | EMPAGE-102     | AGE-102       | 1               | 880.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | EMPAGE-102     | AGE-102       | 2               | 980.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    Then   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | EMPAGE-102     | AGE-102       | 1               | 880.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | EMPAGE-102     | AGE-102       | 2               | 980.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	
	And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | EMPAGE-102     | AGE-102       | 1               | -100.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | EMPAGE-102     | AGE-102       | 2               | -100.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
   
    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | EMPAGE-102     | AGE-102       | 1               | 780.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |    
    | EMPAGE-102     | AGE-102       | 2               | 880.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |    
    
	And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | EMPAGE-102     | AGE-102       | 2260010                  | 880.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | EMPAGE-102     | AGE-102       | 2360010                  | 980.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    
	And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | CappingSubnominal | Apr-15  | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | EMPAGE-102     | AGE-102       | 2260010           | -100.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | EMPAGE-102     | AGE-102       | 2360010           | -100.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
   
    #
    # Actuals for May 2015
    #
    And   the override date is '17/06/2015'
    When   The following Summarised Actuals for period 'G04' for collection type 'AGE' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | EMPAGE-102     | AGE-102       | 1               | 880.00 | 88.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | EMPAGE-102     | AGE-102       | 2               | 980.00 | 188.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    Then   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | EMPAGE-102     | AGE-102       | 1               | 880.00 | 188.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | EMPAGE-102     | AGE-102       | 2               | 980.00 | 288.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	
	And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15  | May-15  | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | EMPAGE-102     | AGE-102       | 1               | -100.00 | -188.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | EMPAGE-102     | AGE-102       | 2               | -100.00 | -288.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
   
    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | EMPAGE-102     | AGE-102       | 1               | 780.00 | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |    
    | EMPAGE-102     | AGE-102       | 2               | 880.00 | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |    
    
	And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | EMPAGE-102     | AGE-102       | 2260010                  | 880.00 | 188.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | EMPAGE-102     | AGE-102       | 2360010                  | 980.00 | 288.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    
	And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | CappingSubnominal | Apr-15  | May-15  | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | EMPAGE-102     | AGE-102       | 2260010           | -100.00 | -188.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | EMPAGE-102     | AGE-102       | 2360010           | -100.00 | -288.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |


    And   the override date is reset

@DoNotRun
Scenario: D102 Scenario 2. AGE contract allocation is approved on time. Actuals are submitted and don't breach cap   
    Given there is no payment schedule data for contract 'EMPAGE-808' version '1'
    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
    | 10017808 | EMPAGE-808     | AGE-808       | AGE               | AGE1516				  | FY                      |  01/04/2015         | 31/03/2016        |

	And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   |
    | EMPAGE-808     | AGE-808       | 1               | 0                     | 4000.00  | 27.00    | 29.00    | 15.00    | 16.00    | 39.00    | 1.00     | 39.00    | 41.00    | 36.00    | 3.00     | 1000.00  |
    | EMPAGE-808     | AGE-808       | 2               | 0                     | 1000.00  | 40.00    | 19.00    | 49.00    | 44.00    | 3.00     | 48.00    | 19.00    | 27.00    | 1039.00  | 1003.00  | 1030.00  |

    #
    # Actuals for September 2015
    #
    And   the override date is '19/10/2015'
    When   The following Summarised Actuals for period 'G02' for collection type 'AGE' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | EMPAGE-808     | AGE-808       | 1               | 1790.00  | 1753.00  | 41.00    | 161.00   | 996.00   | 174.00   | ?        | ?        | ?        | ?        | ?        | ?         |
    | EMPAGE-808     | AGE-808       | 2               | 757.00   | 288.00   | 1789.00  | 1021.00  | 182.00   | 38.00    | ?        | ?        | ?        | ?        | ?        | ?         |

    Then   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | EMPAGE-808     | AGE-808       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4915.00  | ?        | ?        | ?        | ?        | ?        | ?         |
    | EMPAGE-808     | AGE-808       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4075.00  | ?        | ?        | ?        | ?        | ?        | ?         |
	
	And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | EMPAGE-808     | AGE-808       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?         |
    | EMPAGE-808     | AGE-808       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?         |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | EMPAGE-808     | AGE-808       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4915.00  | ?        | ?        | ?        | ?        | ?        | ?         |
    | EMPAGE-808     | AGE-808       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4075.00  | ?        | ?        | ?        | ?        | ?        | ?         |
    
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | EMPAGE-808     | AGE-808       | 2260010                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4915.00  | ?        | ?        | ?        | ?        | ?        | ?         |
    | EMPAGE-808     | AGE-808       | 2360010                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4075.00  | ?        | ?        | ?        | ?        | ?        | ?         |

    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | CappingSubnominal | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | EMPAGE-808     | AGE-808       | 2260010           | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?         |
    | EMPAGE-808     | AGE-808       | 2360010           | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?         |

    And   the override date is reset
