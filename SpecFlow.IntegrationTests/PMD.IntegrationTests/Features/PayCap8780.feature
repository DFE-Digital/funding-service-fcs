
@Feature6376
Feature:As a finance officer I want the PoA calculations for funding streams such as 24+ ALLB to be 
	   calculated correctly to make sure the providers are paid according to their contract

@AcceptanceTest  
@Inprogress
@PMDIntegration

Scenario:A803 A contract containing a 24+ALLB  contract allocation is approved on time. Cap was not breached in capping period 1. The current period is within the second capping period. 
		 Year to date actuals submitted do not breach capping period 1 or capping period 2’s cap 
	
	
	Given there is no payment schedule data for contract 'MAIN-304' version '1'
	
	And   the approved contract allocations details for the latest version of the contract are as follows
   
   	| UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
    | 10017304 | MAIN-304       | ALLB-304      | ALLB              | ALLB1516				  | AY                      |  01/08/2015         |  31/10/2016       |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   | 
    | MAIN-304       | ALLB-304      | 1               | 100.00   | 100.00   | 101.00   |  101.00  |  105.00  |  106.00  |  107.00  | 108.00   | 103.00   | 110.00   | 113.00   | 112.00   | 
    
    #
    # Actuals for March 2016
    #
  And   the override date is '06/04/2016'
	
  When The following Summarised Actuals for period 'R01' for collection type 'ALLB' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   |
    | MAIN-304       | ALLB-304      | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 50.00    | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 30.00    | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 20.00    | 0.00     | 0.00     | 0.00     | 0.00     |

 Then the Reconciliation Data is calculated as follows
    
	| ContractNumber | AllocationRef | DeliverableCode | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   |  
    | MAIN-304       | ALLB-304      | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 432.29   | 50.00    | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 147.86   | 30.00    | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 147.86   | 20.00    | 0.00     | 0.00     | 0.00     | 0.00     |
		
And the Capping Amounts is calculated as follows
    
	| ContractNumber | AllocationRef | DeliverableCode | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   |  
    | MAIN-304       | ALLB-304      | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
	
	 
  And the Net Payment for is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   |  
    | MAIN-304       | ALLB-304      | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 50.00    | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 30.00    | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 20.00    | 0.00     | 0.00     | 0.00     | 0.00     |
	
  And the Reconciliation Subnominal Amount is calculated as follows
    | ContractNumber | AllocationRef | ReconcilationSubnominal| Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16    | Apr-16   | May-16   | Jun-16   | Jul-16   |  
    | MAIN-304       | ALLB-304      | 2303800                | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 728.00   | 100.00    | 0.00     | 0.00     | 0.00     | 0.00     |
	
	 
   And the Capping Subnominal Amounts  is calculated as follows
    
	| ContractNumber | AllocationRef | CappingSubnominal| Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   |  
    | MAIN-304       | ALLB-304      | 2303800          | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
												   																						 
    And  the override date is reset
	   
    #
    # Actuals for April 2016
    #	
  And   the override date is '06/05/2016'
	
  When The following Summarised Actuals for period 'R02' for collection type 'ALLB' are processed
    | ContractNumber | AllocationRef | DeliverableCode | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   |
    | MAIN-304       | ALLB-304      | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 100.00   | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 107.86   | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 177.86   | 0.00     | 0.00     | 0.00     |

 Then the Reconciliation Data is calculated as follows
    
	| ContractNumber | AllocationRef | DeliverableCode | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   |  
    | MAIN-304       | ALLB-304      | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 432.29   | 50.00    | 100.00   | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 147.86   | 30.00    | 107.00   | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 147.86   | 20.00    | 177.00   | 0.00     | 0.00     | 0.00     |
		
	And the Capping Amounts is calculated as follows
    
	| ContractNumber | AllocationRef | DeliverableCode | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   |  
    | MAIN-304       | ALLB-304      | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
	
	 
  And the Net Payment for is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   |  
    | MAIN-304       | ALLB-304      | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 100.00   | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 107.00   | 0.00     | 0.00     | 0.00     |
	| MAIN-304       | ALLB-304      | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 177.00   | 0.00     | 0.00     | 0.00     |
	
  And the Reconciliation Subnominal Amount is calculated as follows
    | ContractNumber | AllocationRef | ReconcilationSubnominal| Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16    | May-16   | Jun-16   | Jul-16   |  
    | MAIN-304       | ALLB-304      | 2303800                | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 728.00   | 100.00   | 384.00    | 0.00     | 0.00     | 0.00     |
	
	 
   And the Capping Subnominal Amounts  is calculated as follows
    | ContractNumber | AllocationRef | CappingSubnominal| Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   |  
    | MAIN-304       | ALLB-304      | 2303800          | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
															   																						 
    And  the override date is reset

		