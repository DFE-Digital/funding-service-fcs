Feature: ZeroPaddingForAGE 15660

@AcceptanceTest @Withdrawn20200420
@PaymentScheduleTests
Scenario: A116 Create and approve a 1617 AGE (PoA) contract. Consume DCFS-format actuals and zeroise any/all null values
    Given there is no Contract, Task or Workflow data for contract 'EMPAGE-116' and master contract 'SFA-116'
	And   there are no entries in the DCFS stub table

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AGE-116       |
 
   #And   there is no Organisation data for UKPRN '10017116'
    And   the override date is '04/03/2016' 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'My Dinga Ling Inc' with UKPRN '10017116' and OrgId 'ORG0017116' and has 'FCS1 Test' as a manager
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                | Period | CRMIntent    | OrgId      |
    | 10017116 | My Dinga Ling Inc    | SFA-116              | EMPAGE-116     | 1                     |  01/04/2016       |  31/03/2017     | 13864.00      | Contract for Services (HAF) | 1617   | New          | ORG0017116 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent |
    | 10017116 | EMPAGE-116     | AGE-116       | AGE               | AGE1617                 | FY                      |  01/04/2016         |  31/03/2017       | 13864.00        |                     |         |                        | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Apr-16   | May-16   | Jun-16   | Jul-16   | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | DeliverableDescription                            | CRMIntent    |
    | EMPAGE-116     | AGE-116       | 1               | 0                     | 7818.00  | 409.00   | 839.00   | 823.00   | 618.00   | 272.00   | 761.00   | 791.00   | 853.00   | 610.00   | 581.00   | 436.00   | 825.00   | 16-18 Apprenticeship Grant for Employers          | New          |
    | EMPAGE-116     | AGE-116       | 2               | 0                     | 6046.00  | 427.00   | 880.00   | 468.00   | 371.00   | 451.00   | 629.00   | 273.00   | 462.00   | 274.00   | 632.00   | 404.00   | 775.00   | 19-24 Apprenticeship Grant for Employers          | New          |

    And   the contract exists in CRM
    And   the latest version of contract 'EMPAGE-116' is in a state of 'Published to Provider'
    And   approval is initiated for contract with master contract number 'SFA-116' and contract number 'EMPAGE-116' and version number '1'
    And   the status and sub-status of the latest version of contract 'EMPAGE-116' are changed to 'Approved'
    And   the latest version of contract 'EMPAGE-116' is marked as the last approved version




    # Change the date
	Given the override date is '06/10/2016'

	# DCFS Summarised Actuals for September   
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue | 
    | AGE            | G09                  | ORG0017116     | CM             | 201604 | AGE1617                 | AGE-116                  |         | 1               | 0            | 1729.00     | 
    | AGE            | G09                  | ORG0017116     | CM             | 201605 | AGE1617                 | AGE-116                  |         | 1               | 0            | ?           | 
    | AGE            | G09                  | ORG0017116     | CM             | 201606 | AGE1617                 | AGE-116                  |         | 1               | 0            | 403.00      | 
    | AGE            | G09                  | ORG0017116     | CM             | 201607 | AGE1617                 | AGE-116                  |         | 1               | 0            | ?           | 
    | AGE            | G09                  | ORG0017116     | CM             | 201608 | AGE1617                 | AGE-116                  |         | 1               | 0            | 1534.00     | 
    | AGE            | G09                  | ORG0017116     | CM             | 201609 | AGE1617                 | AGE-116                  |         | 1               | 0            | 1638.00     | 
    | AGE            | G09                  | ORG0017116     | CM             | 201610 | AGE1617                 | AGE-116                  |         | 1               | 0            | 1495.00     | 
    | AGE            | G09                  | ORG0017116     | CM             | 201611 | AGE1617                 | AGE-116                  |         | 1               | 0            | 338.00      | 
    | AGE            | G09                  | ORG0017116     | CM             | 201612 | AGE1617                 | AGE-116                  |         | 1               | 0            | ?           | 
    | AGE            | G09                  | ORG0017116     | CM             | 201701 | AGE1617                 | AGE-116                  |         | 1               | 0            | ?           | 
    | AGE            | G09                  | ORG0017116     | CM             | 201702 | AGE1617                 | AGE-116                  |         | 1               | 0            | ?           | 
    | AGE            | G09                  | ORG0017116     | CM             | 201703 | AGE1617                 | AGE-116                  |         | 1               | 0            | 1144.00     | 
    | AGE            | G09                  | ORG0017116     | CM             | 201604 | AGE1617                 | AGE-116                  |         | 2               | 0            | ?           | 
    | AGE            | G09                  | ORG0017116     | CM             | 201605 | AGE1617                 | AGE-116                  |         | 2               | 0            | 169.00      | 
    | AGE            | G09                  | ORG0017116     | CM             | 201606 | AGE1617                 | AGE-116                  |         | 2               | 0            | 1794.00     | 
    | AGE            | G09                  | ORG0017116     | CM             | 201607 | AGE1617                 | AGE-116                  |         | 2               | 0            | ?           | 
    | AGE            | G09                  | ORG0017116     | CM             | 201608 | AGE1617                 | AGE-116                  |         | 2               | 0            | 936.00      | 
    | AGE            | G09                  | ORG0017116     | CM             | 201609 | AGE1617                 | AGE-116                  |         | 2               | 0            | 1638.00     | 
    | AGE            | G09                  | ORG0017116     | CM             | 201610 | AGE1617                 | AGE-116                  |         | 2               | 0            | 442.00      | 
    | AGE            | G09                  | ORG0017116     | CM             | 201611 | AGE1617                 | AGE-116                  |         | 2               | 0            | 1167.00     | 
    | AGE            | G09                  | ORG0017116     | CM             | 201612 | AGE1617                 | AGE-116                  |         | 2               | 0            | 832.00      | 
    | AGE            | G09                  | ORG0017116     | CM             | 201701 | AGE1617                 | AGE-116                  |         | 2               | 0            | ?           | 
    | AGE            | G09                  | ORG0017116     | CM             | 201702 | AGE1617                 | AGE-116                  |         | 2               | 0            | 1612.00     | 
    | AGE            | G09                  | ORG0017116     | CM             | 201703 | AGE1617                 | AGE-116                  |         | 2               | 0            | 364.00      | 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-16   | May-16   | Jun-16   | Jul-16   | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   |
    | EMPAGE-116     | AGE-116            | 1               | 5304.00   | 1729.00  | 0.00     | 403.00   | 0.00     | 1534.00  | 1638.00  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EMPAGE-116     | AGE-116            | 2               | 4537.00   | 0.00     | 169.00   | 1794.00  | 0.00     | 936.00   | 1638.00  | ?        | ?        | ?        | ?        | ?        | ?        | 

	# Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-16   | May-16   | Jun-16   | Jul-16   | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17    |
    | EMPAGE-116     | AGE-116       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5304.00  | ?        | ?        | ?        | ?        | ?        | ?         |
    | EMPAGE-116     | AGE-116       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4537.00  | ?        | ?        | ?        | ?        | ?        | ?         |

	# Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-16   | May-16   | Jun-16   | Jul-16   | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17    |
    | EMPAGE-116     | AGE-116       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5304.00  | ?        | ?        | ?        | ?        | ?        | ?         |
    | EMPAGE-116     | AGE-116       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4537.00  | ?        | ?        | ?        | ?        | ?        | ?         |

	# Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Apr-16   | May-16   | Jun-16   | Jul-16   | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17    |
    | EMPAGE-116     | AGE-116       | 2260010                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5304.00  | ?        | ?        | ?        | ?        | ?        | ?         |
    | EMPAGE-116     | AGE-116       | 2360010                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4537.00  | ?        | ?        | ?        | ?        | ?        | ?         |
	

	# Tidy Up
 #   And   the override date is reset
