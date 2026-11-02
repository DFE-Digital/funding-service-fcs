@Feature8652  
Feature: Capping 8652 Calculate capping payments on reciept of actuals

@DoNotRun
Scenario: D103 contract containing an AGE contract allocation is approved on time. Actuals are submitted at R01 and don't breach cap. Actuals are then submitted after R01 and still don't breach cap
    Given there is no payment schedule data for contract 'PAYCAP-103' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
    | 10017103 | PAYCAP-103     | AGE-103       | AGE               | AGE1516				  | FY                      |  01/04/2015         | 31/03/2016        |

	And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total   | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-103     | AGE-103       | 1               | 0                     | 780.00  | 10.00  | 20.00  | 30.00  | 40.00  | 50.00  | 60.00  | 70.00  | 80.00  | 90.00  | 100.00 | 110.00 | 120.00 |
    | PAYCAP-103     | AGE-103       | 2               | 0                     | 1860.00 | 100.00 | 110.00 | 120.00 | 130.00 | 140.00 | 150.00 | 160.00 | 170.00 | 180.00 | 190.00 | 200.00 | 210.00 |

    #
    # Actuals for April 2015
    #
    And   the override date is '06/05/2015'
    When   The following Summarised Actuals for period 'G01' for collection type 'AGE' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | PAYCAP-103     | AGE-103       | 1               | 750.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | PAYCAP-103     | AGE-103       | 2               | 880.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |

    Then   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | PAYCAP-103     | AGE-103       | 1               | 750.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | PAYCAP-103     | AGE-103       | 2               | 880.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
	
	And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | PAYCAP-103     | AGE-103       | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | PAYCAP-103     | AGE-103       | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | PAYCAP-103     | AGE-103       | 1               | 750.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | PAYCAP-103     | AGE-103       | 2               | 880.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | PAYCAP-103     | AGE-103       | 2260010                  | 750.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | PAYCAP-103     | AGE-103       | 2360010                  | 880.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |

    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | CappingSubnominal | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | PAYCAP-103     | AGE-103       | 2260010           | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | PAYCAP-103     | AGE-103       | 2360010           | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |

    #
    # Actuals for May 2015
    #
    And   the override date is '06/06/2015'
    When   The following Summarised Actuals for period 'G02' for collection type 'AGE' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | PAYCAP-103     | AGE-103       | 1               | 750.00   | 25.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | PAYCAP-103     | AGE-103       | 2               | 880.00   | 25.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |

    Then   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | PAYCAP-103     | AGE-103       | 1               | 750.00   | 25.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | PAYCAP-103     | AGE-103       | 2               | 880.00   | 25.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
	
	And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | PAYCAP-103     | AGE-103       | 1               | 0.00     | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | PAYCAP-103     | AGE-103       | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | PAYCAP-103     | AGE-103       | 1               | 750.00   | 25.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | PAYCAP-103     | AGE-103       | 2               | 880.00   | 25.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
   
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | PAYCAP-103     | AGE-103       | 2260010                  | 750.00   | 25.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | PAYCAP-103     | AGE-103       | 2360010                  | 880.00   | 25.00    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |

    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | CappingSubnominal | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    |
    | PAYCAP-103     | AGE-103       | 2260010           | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |
    | PAYCAP-103     | AGE-103       | 2360010           | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?         |

    And   the override date is reset

@DoNotRun
Scenario: D104 contract containing an AGE contract allocation is approved on time. Actuals are submitted up to R06 (or any point after R01) and don't breach cap. Actuals are then submitted in R07 (or any point after R06) including re-submission of past actuals which does breach cap after R01.
# includes A contract containing an AGE contract allocation is approved on time. Actuals are submitted up to R07 and breach cap. Actuals are then submitted at R08, including a re-submission of past actuals and the cap is no longer breached
    Given there is no payment schedule data for contract 'PAYCAP-104' version '1'

    And   the approved contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
    | 10017104 | PAYCAP-104     | AGE-104       | AGE               | AGE1516				  | FY                      |  01/04/2015         | 31/03/2016        |

	And   the contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   |
    | PAYCAP-104     | AGE-104       | 1               | 0                     | 10.00    | 20.00    | 30.00    | 40.00    | 50.00    | 60.00    | 70.00    | 80.00    | 90.00    | 100.00   | 110.00   | 120.00   |
    | PAYCAP-104     | AGE-104       | 2               | 0                     | 100.00   | 110.00   | 120.00   | 130.00   | 140.00   | 150.00   | 160.00   | 170.00   | 180.00   | 190.00   | 200.00   | 210.00   |

	#
    # Actuals for May 2015
    #

    And   the override date is '20/05/2015'
    When   The following Summarised Actuals for period 'G11' for collection type 'AGE' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 1               | 880.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | PAYCAP-104     | AGE-104       | 2               | 860.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    Then   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 1               | 880.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | PAYCAP-104     | AGE-104       | 2               | 860.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	
	And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15  | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 1               | -100.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | PAYCAP-104     | AGE-104       | 2               | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 1               | 780.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | PAYCAP-104     | AGE-104       | 2               | 860.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 2260010                  | 880.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | PAYCAP-104     | AGE-104       | 2360010                  | 860.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    And   the Capping Subnominal Amounts are calculated as follows
   | ContractNumber | AllocationRef | CappingSubnominal | Apr-15  | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
   | PAYCAP-104     | AGE-104       | 2260010           | -100.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
   | PAYCAP-104     | AGE-104       | 2360010           | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |


	#
    # Actuals for May 2015
    #

    And   the override date is '17/06/2015'
    When   The following Summarised Actuals for period 'G11' for collection type 'AGE' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 1               | 880.00 | 88.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | PAYCAP-104     | AGE-104       | 2               | 860.00 | 100.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    Then   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 1               | 880.00 | 188.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | PAYCAP-104     | AGE-104       | 2               | 860.00 | 100.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	
	And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15  | May-15  | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 1               | -100.00 | -188.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | PAYCAP-104     | AGE-104       | 2               | 0.00    | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 1               | 780.00      | 0.00   | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | PAYCAP-104     | AGE-104       | 2               | 860.00      | 100.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Apr-15 | May-15 | Jun-15  | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 2260010                  | 880.00 | 188.00 | ? | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | PAYCAP-104     | AGE-104       | 2360010                  | 860.00 | 100.00 | ? | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | CappingSubnominal | Apr-15  | May-15  | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 2260010           | -100.00 | -188.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ? |
    | PAYCAP-104     | AGE-104       | 2360010           | 0.00    | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ? |


    #
    # Actuals for June 2015
    #
    And   the override date is '17/07/2015'
    When   The following Summarised Actuals for period 'G11' for collection type 'AGE' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15  | Jun-15 | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 1               | 0.00   | 88.00   | 100.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | PAYCAP-104     | AGE-104       | 2               | 860.00 | 1500.00 | 150.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    Then   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15  | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 1               | 880.00 | 188.00 | -592.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | PAYCAP-104     | AGE-104       | 2               | 860.00 | 100.00 | 1550.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
	
	And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15  | May-15  | Jun-15  | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 1               | -100.00 | -188.00 | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?	   |
    | PAYCAP-104     | AGE-104       | 2               | 0.00    | 0.00    | -650.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?	   |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-15 | May-15 | Jun-15  | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 1               | 780.00 | 0.00   | -592.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | PAYCAP-104     | AGE-104       | 2               | 860.00 | 100.00 | 900.00  | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Apr-15 | May-15 | Jun-15  | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 2260010                  | 880.00 | 188.00 | -592.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | PAYCAP-104     | AGE-104       | 2360010                  | 860.00 | 100.00 | 1550.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | CappingSubnominal | Apr-15  | May-15  | Jun-15  | Jul-15 | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 |
    | PAYCAP-104     | AGE-104       | 2260010           | -100.00 | -188.00 | 0.00    | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?		 |
    | PAYCAP-104     | AGE-104       | 2360010           | 0.00    | 0.00    | -650.00 | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?		 |

    And   the override date is reset

	 