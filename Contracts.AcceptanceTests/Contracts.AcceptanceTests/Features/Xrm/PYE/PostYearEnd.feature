Feature: PostYearEnd

@AcceptanceTest @Withdrawn20200420
@PostYearEnd @PaymentScheduleTests
Scenario: A872 Confirm calculations are correct for Post Year End on PoA for AGE1617. Check CRM and PaaS SubnomAgg data.
    Given there is no Contract, Task or Workflow data for contract 'EMPAGE-872' and master contract 'ESFA-872'

    # Clear down subnominal data from CRM and PaaS
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AGE-872       |

   # Set organisation and advisors
 #  And   there is no Organisation data for UKPRN '10017872'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017872 Co Ltd' with UKPRN '10017872' and OrgId 'ORG0017872' and has 'FCS1 Test' as a manager

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017872 | 117872 | 10017872 Co Ltd | 0              | Active |



	# Change the date
	Given the override date is '31/03/2016'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName       | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 10017872 | 10017872 Co Ltd | ESFA-872             | EMPAGE-872     | 1                     | 01/04/2016        | 31/03/2017      | 1212.00       | Contract for Services | 1617   | New       | ORG0017872 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent |
    | 10017872 | EMPAGE-872     | AGE-872       | AGE               | FY                      | 01/04/2016          | 31/03/2017        | 1212.00         |         |         |                       | New       |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | DeliverableName                          | CRMIntent |
    | EMPAGE-872     | AGE-872       | 1               | 0                     | 100.00 | 101.00 | 102.00 | 103.00 | 104.00 | 105.00 | 106.00 | 107.00 | 108.00 | 109.00 | 110.00 | 111.00 | 16-17 Apprenticeship Grant for Employers | New       |
    | EMPAGE-872     | AGE-872       | 2               | 0                     | 50.00  | 51.00  | 52.00  | 53.00  | 54.00  | 55.00  | 56.00  | 57.00  | 58.00  | 59.00  | 60.00  | 61.00  | 19-24 Apprenticeship Grant for Employers | New       |

    And   the contract exists in CRM
    And   the latest version of contract 'EMPAGE-872' is in a state of 'Published to Provider'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-872' and actual ContractNumber 'EMPAGE-872'

    # Check that the contract is now approved
    Then  the latest version of contract 'EMPAGE-872' is in status 'Approved'

    And   the Profile Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-16   | May-16   | Jun-16   | Jul-16   | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | DeliverableName                                     |
    | EMPAGE-872     | AGE-872       | 1               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 16-17 Apprenticeship Grant for Employers            |
    | EMPAGE-872     | AGE-872       | 2               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 19-24 Apprenticeship Grant for Employers            |

    And   the Balancing Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-16   | May-16   | Jun-16   | Jul-16   | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   |
    | EMPAGE-872     | AGE-872       | 1               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | EMPAGE-872     | AGE-872       | 2               | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 |
    | EMPAGE-872     | AGE-872       | 1               | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |
    | EMPAGE-872     | AGE-872       | 2               | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      | ?      |

#   # Check that the CRM subnominals have been created before moving on
#   And   CRM subnominals have been created for the following allocations
#	| AllocationRef | Subnominal Code  | Period | Payment Type   |
#	| AGE-872       | 2260010		   | Aug-17 | Reconciliation |




    # Actuals for March 2017
    Given the override date is '16/03/2017'

    Then  I receive Summarised Actuals from DCFS for period 'G11' for collection type 'AGE' as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 |
    | EMPAGE-872     | AGE-872       | 1               | 50.00  | 51.00  | 52.00  | 53.00  | 54.00  | 55.00  | 56.00  | 57.00  | 58.00  | 59.00  | 60.00  | ?      |
    | EMPAGE-872     | AGE-872       | 2               | 25.00  | 26.00  | 27.00  | 28.00  | 29.00  | 30.00  | 31.00  | 32.00  | 33.00  | 34.00  | 35.00  | ?      | 

    And   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 |
    | EMPAGE-872     | AGE-872       | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | ?      |
    | EMPAGE-872     | AGE-872       | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | ?      |

    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | CappingSubnominal | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 |
    | EMPAGE-872     | AGE-872       | 2260010           | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      |
    | EMPAGE-872     | AGE-872       | 2360010           | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | ?      |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 |
    | EMPAGE-872     | AGE-872       | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | ?      |
    | EMPAGE-872     | AGE-872       | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | ?      |

    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 |
    | EMPAGE-872     | AGE-872       | 2260010                  | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | ?      |
    | EMPAGE-872     | AGE-872       | 2360010                  | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | ?      |




    # Actuals for April 2017
    Given the override date is '18/04/2017'

    Then  I receive Summarised Actuals from DCFS for period 'G12' for collection type 'AGE' as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 |
    | EMPAGE-872     | AGE-872       | 1               | 50.00  | 52.00  | 54.00  | 56.00  | 58.00  | 60.00  | 62.00  | 64.00  | 66.00  | 68.00  | 70.00  | 72.00  |
    | EMPAGE-872     | AGE-872       | 2               | 25.00  | 24.00  | 23.00  | 22.00  | 21.00  | 20.00  | 19.00  | 18.00  | 17.00  | 16.00  | 15.00  | 14.00  |

    And   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 |
    | EMPAGE-872     | AGE-872       | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 127.00 |
    | EMPAGE-872     | AGE-872       | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | -96.00 |

    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | CappingSubnominal | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 |
    | EMPAGE-872     | AGE-872       | 2260010           | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
    | EMPAGE-872     | AGE-872       | 2360010           | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 |
    | EMPAGE-872     | AGE-872       | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 127.00 |
    | EMPAGE-872     | AGE-872       | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | -96.00 |

    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 |
    | EMPAGE-872     | AGE-872       | 2260010                  | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 127.00 |
    | EMPAGE-872     | AGE-872       | 2360010                  | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | -96.00 |




    # Actuals for May 2017
    Given the override date is '18/05/2017'

    Then  I receive Summarised Actuals from DCFS for period 'G13' for collection type 'AGE' as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 |
    | EMPAGE-872     | AGE-872       | 1               | 50.00  | 53.00  | 56.00  | 59.00  | 62.00  | 65.00  | 68.00  | 71.00  | 74.00  | 77.00  | 80.00  | 83.00  |
    | EMPAGE-872     | AGE-872       | 2               | 25.00  | 24.50  | 24.00  | 23.50  | 23.00  | 22.50  | 22.00  | 21.50  | 21.00  | 20.50  | 20.00  | 19.50  |

    And   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 |
    | EMPAGE-872     | AGE-872       | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 127.00 | 66.00  |
    | EMPAGE-872     | AGE-872       | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | -96.00 | 33.00  |

    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | CappingSubnominal | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 |
    | EMPAGE-872     | AGE-872       | 2260010           | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |
    | EMPAGE-872     | AGE-872       | 2360010           | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 |
    | EMPAGE-872     | AGE-872       | 1               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 127.00 | 66.00  |
    | EMPAGE-872     | AGE-872       | 2               | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | -96.00 | 33.00  |

    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Apr-16 | May-16 | Jun-16 | Jul-16 | Aug-16 | Sep-16 | Oct-16 | Nov-16 | Dec-16 | Jan-17 | Feb-17 | Mar-17 | Apr-17 |
    | EMPAGE-872     | AGE-872       | 2260010                  | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 605.00 | 127.00 | 66.00  |
    | EMPAGE-872     | AGE-872       | 2360010                  | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 0.00   | 330.00 | -96.00 | 33.00  |

	Then stop

    # Check for the presence of certain rows in the SubnominalAggregations table in CRM
    And   the SubnominalAggregations table contains the following data 
    | SubnominalAggregateKey   | Period | SubnominalCode | PaymentType    | FundingStreamPeriod | AggregateValue | Provider             |
    | 2260010_AGE-872_Apr-16   | Apr-16 | 2260010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Apr-16   | Apr-16 | 2260010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Apr-16   | Apr-16 | 2360010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Apr-16   | Apr-16 | 2360010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_May-16   | May-16 | 2260010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_May-16   | May-16 | 2260010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_May-16   | May-16 | 2360010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_May-16   | May-16 | 2360010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Jun-16   | Jun-16 | 2260010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Jun-16   | Jun-16 | 2260010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Jun-16   | Jun-16 | 2360010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Jun-16   | Jun-16 | 2360010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Jul-16   | Jul-16 | 2260010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Jul-16   | Jul-16 | 2260010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Jul-16   | Jul-16 | 2360010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Jul-16   | Jul-16 | 2360010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Aug-16   | Aug-16 | 2260010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Aug-16   | Aug-16 | 2260010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Aug-16   | Aug-16 | 2360010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Aug-16   | Aug-16 | 2360010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Sep-16   | Sep-16 | 2260010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Sep-16   | Sep-16 | 2260010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Sep-16   | Sep-16 | 2360010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Sep-16   | Sep-16 | 2360010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Oct-16   | Oct-16 | 2260010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Oct-16   | Oct-16 | 2260010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Oct-16   | Oct-16 | 2360010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Oct-16   | Oct-16 | 2360010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Nov-16   | Nov-16 | 2260010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Nov-16   | Nov-16 | 2260010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Nov-16   | Nov-16 | 2360010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Nov-16   | Nov-16 | 2360010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Dec-16   | Dec-16 | 2260010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Dec-16   | Dec-16 | 2260010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Dec-16   | Dec-16 | 2360010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Dec-16   | Dec-16 | 2360010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Jan-17   | Jan-17 | 2260010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Jan-17   | Jan-17 | 2260010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Jan-17   | Jan-17 | 2360010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Jan-17   | Jan-17 | 2360010        | Reconciliation | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Feb-17   | Feb-17 | 2260010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Feb-17   | Feb-17 | 2260010        | Reconciliation | AGE1617             | 605.00         | 10017872 Co Ltd      |
    | 2360010_AGE-872_Feb-17   | Feb-17 | 2360010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Feb-17   | Feb-17 | 2360010        | Reconciliation | AGE1617             | 330.00         | 10017872 Co Ltd      |
    | 2260010_AGE-872_Mar-17   | Mar-17 | 2260010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Mar-17   | Mar-17 | 2260010        | Reconciliation | AGE1617             | 127.00         | 10017872 Co Ltd      |
    | 2360010_AGE-872_Mar-17   | Mar-17 | 2360010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Mar-17   | Mar-17 | 2360010        | Reconciliation | AGE1617             | -96.00         | 10017872 Co Ltd      |
    | 2260010_AGE-872_Apr-17   | Apr-17 | 2260010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2260010_AGE-872_Apr-17   | Apr-17 | 2260010        | Reconciliation | AGE1617             | 66.00          | 10017872 Co Ltd      |
    | 2360010_AGE-872_Apr-17   | Apr-17 | 2360010        | Capping        | AGE1617             | 0.00           | 10017872 Co Ltd      |
    | 2360010_AGE-872_Apr-17   | Apr-17 | 2360010        | Reconciliation | AGE1617             | 33.00          | 10017872 Co Ltd      |

    # Check for the presence of certain rows in the PaymentGeneration.SubnominalAggregation table in PaaS
    And   the below Subnominal Aggregation exists in the PayGen data store
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue | Selected |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201604               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201604               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201604               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201604               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201605               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201605               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201605               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201605               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201606               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201606               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201606               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201606               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201607               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201607               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201607               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201607               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201608               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201608               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201608               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201608               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201609               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201609               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201609               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201609               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201610               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201610               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201610               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201610               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201611               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201611               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201611               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201611               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201612               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201612               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201612               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201612               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201701               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201701               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201701               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201701               | RECONCILIATION  | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201702               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201702               | RECONCILIATION  | CM             | False       | 605.00          | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201702               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201702               | RECONCILIATION  | CM             | False       | 330.00          | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201703               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201703               | RECONCILIATION  | CM             | False       | 127.00          | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201703               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201703               | RECONCILIATION  | CM             | False       | -96.00          | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201704               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2260010         | AGE1617                    | 201704               | RECONCILIATION  | CM             | False       | 66.00           | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201704               | CAPPING         | CM             | False       | 0.00            | False    |
    | 10017872 | ORG0017872 | AGE-872           | 2360010         | AGE1617                    | 201704               | RECONCILIATION  | CM             | False       | 33.00           | False    |


    # Tidy up
    And   the override date is reset
 