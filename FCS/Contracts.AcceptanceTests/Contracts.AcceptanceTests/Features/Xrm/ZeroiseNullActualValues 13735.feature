Feature: ZeroiseNullActualValues 13735

@AcceptanceTest @Withdrawn20230123
Scenario: A930 Actuals zeroisation for ALLF1617
    Given there is no Contract, Task or Workflow data for UKPRN '10017930'
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-930      |
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS
    And   there is no Organisation data for UKPRN '10017930'
    And   the override date is reset 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'VQ SOLUTIONS LTD' with UKPRN '10017930' and OrgId 'ORG0001930' and has 'FCS1 Test' as a manager
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                           | Period | CRMIntent | OrgId      |
    | 10017930 | VQ SOLUTIONS LTD     | SFA-930              | 24Loans-930    | 1                     |  01/08/2016       |  31/10/2016     | 960.00        | Conditions of Funding (Grant) Employer | 1617   | New       | ORG0001930 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription      | CRMIntent | LEPName             | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference        | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType     |
    | 10017930 | 24Loans-930    | ALLF-930      | 24+ ALLF          | AY                      | 01/08/2016          | 31/10/2016        | 330.00          |         |         |                            | New       |                     |         |                              |              |                             |                      |                 |                     |                    |                |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Aug-16   | Sep-16   | Oct-16  | DeliverableDescription                       | CRMIntent |
    | 24Loans-930    | ALLF-930      | 5               | 0                     |          | 100.00   | 110.00   | 120.00  | Total Advanced Learner Loans Bursary Funding | New       |

    And   the contract exists in CRM
    And   the latest version of contract '24Loans-930' is in a state of 'Published to Provider'
    And   the override date is '20/07/2016'
    When  the latest version of contract '24Loans-930' is approved
    Then  the status and sub-status of the latest version of contract '24Loans-930' are changed to 'Approved'
    And   the latest version of contract '24Loans-930' is marked as the last approved version

    #
    # DCFS Summarised Actuals for August 2016
    #
    And   the override date is '06/09/2016'
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
#   | ALLF           | A13                  | ORG0001930     | CM             | 201608 | ALLF1617                | ALLF-930                 |         | 2               | 0            | 9999        | 
    | ALLF           | A13                  | ORG0001930     | CM             | 201609 | ALLF1617                | ALLF-930                 |         | 2               | 0            | 21          | 
    | ALLF           | A13                  | ORG0001930     | CM             | 201610 | ALLF1617                | ALLF-930                 |         | 2               | 0            | 30          | 
    | ALLF           | A13                  | ORG0001930     | CM             | 201608 | ALLF1617                | ALLF-930                 |         | 3               | 0            | 12          | 
    | ALLF           | A13                  | ORG0001930     | CM             | 201609 | ALLF1617                | ALLF-930                 |         | 3               | 0            | 9           | 
#   | ALLF           | A13                  | ORG0001930     | CM             | 201610 | ALLF1617                | ALLF-930                 |         | 3               | 0            | 9999        | 
    | ALLF           | A13                  | ORG0001930     | CM             | 201608 | ALLF1617                | ALLF-930                 |         | 4               | 0            | 90          | 
    | ALLF           | A13                  | ORG0001930     | CM             | 201609 | ALLF1617                | ALLF-930                 |         | 4               | 0            | 91          | 
    | ALLF           | A13                  | ORG0001930     | CM             | 201610 | ALLF1617                | ALLF-930                 |         | 4               | 0            | 92          |
# This next entry should be ignored as it's an invalid del code    
    | ALLF           | A13                  | ORG0001930     | CM             | 201608 | ALLF1617                | ALLF-930                 |         | 6               | 0            | 929         |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16   | Sep-16   | Oct-16   |
    | 24Loans-930    | ALLF-930      | 2               | 0.00     | 21.00    | 30.00    |
    | 24Loans-930    | ALLF-930      | 3               | 12.00    | 9.00     | 0.00     | 
    | 24Loans-930    | ALLF-930      | 4               | 90.00    | 91.00    | 92.00    | 

    And   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16               | Sep-16               | Oct-16               |
    | 24Loans-930    | ALLF-930      | 2               | 0.00                 | ?                    | ?                    |
    | 24Loans-930    | ALLF-930      | 3               | 0.00                 | ?                    | ?                    |
    | 24Loans-930    | ALLF-930      | 4               | 90.00                | ?                    | ?                    |

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16               | Sep-16               | Oct-16               |
    | 24Loans-930    | ALLF-930      | 2               | 0.00                 | ?                    | ?                    |
    | 24Loans-930    | ALLF-930      | 3               | 0.00                 | ?                    | ?                    |
    | 24Loans-930    | ALLF-930      | 4               | 0.00                 | ?                    | ?                    |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16               | Sep-16               | Oct-16               |
    | 24Loans-930    | ALLF-930      | 2               | 0.00                 | ?                    | ?                    |
    | 24Loans-930    | ALLF-930      | 3               | 0.00                 | ?                    | ?                    |
    | 24Loans-930    | ALLF-930      | 4               | 90.00                | ?                    | ?                    |

    #
    # DCFS Summarised Actuals for September 2016
    #
    And   the override date is '06/10/2016'
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | ALLF           | A14                  | ORG0001930     | CM             | 201608 | ALLF1617                | ALLF-930                 |         | 2               | 0            | 13          | 
#   | ALLF           | A14                  | ORG0001930     | CM             | 201609 | ALLF1617                | ALLF-930                 |         | 2               | 0            | 9999        | 
#   | ALLF           | A14                  | ORG0001930     | CM             | 201610 | ALLF1617                | ALLF-930                 |         | 2               | 0            | 9999        | 
#   | ALLF           | A14                  | ORG0001930     | CM             | 201608 | ALLF1617                | ALLF-930                 |         | 3               | 0            | 9999        | 
#   | ALLF           | A14                  | ORG0001930     | CM             | 201609 | ALLF1617                | ALLF-930                 |         | 3               | 0            | 9999        | 
#   | ALLF           | A14                  | ORG0001930     | CM             | 201610 | ALLF1617                | ALLF-930                 |         | 3               | 0            | 9999        | 
    | ALLF           | A14                  | ORG0001930     | CM             | 201608 | ALLF1617                | ALLF-930                 |         | 4               | 0            | 93          | 
#   | ALLF           | A14                  | ORG0001930     | CM             | 201609 | ALLF1617                | ALLF-930                 |         | 4               | 0            | 9999        | 
#   | ALLF           | A14                  | ORG0001930     | CM             | 201610 | ALLF1617                | ALLF-930                 |         | 4               | 0            | 9999        | 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16   | Sep-16   | Oct-16   |
    | 24Loans-930    | ALLF-930      | 2               | 13.00    | 0.00     | 0.00     |
    | 24Loans-930    | ALLF-930      | 3               | 0.00     | 0.00     | 0.00     | 
    | 24Loans-930    | ALLF-930      | 4               | 93.00    | 0.00     | 0.00     | 

    And   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16               | Sep-16               | Oct-16               |
    | 24Loans-930    | ALLF-930      | 2               | 0.00                 | 0.00                 | ?                    |
    | 24Loans-930    | ALLF-930      | 3               | 0.00                 | 0.00                 | ?                    |
    | 24Loans-930    | ALLF-930      | 4               | 93.00                | 0.00                 | ?                    |

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16               | Sep-16               | Oct-16               |
    | 24Loans-930    | ALLF-930      | 2               | 0.00                 | 0.00                 | ?                    |
    | 24Loans-930    | ALLF-930      | 3               | 0.00                 | 0.00                 | ?                    |
    | 24Loans-930    | ALLF-930      | 4               | 0.00                 | 0.00                 | ?                    |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16               | Sep-16               | Oct-16               |
    | 24Loans-930    | ALLF-930      | 2               | 0.00                 | 0.00                 | ?                    |
    | 24Loans-930    | ALLF-930      | 3               | 0.00                 | 0.00                 | ?                    |
    | 24Loans-930    | ALLF-930      | 4               | 93.00                | 0.00                 | ?                    |
    
    #
    # DCFS Summarised Actuals for October 2016
    #
    And   the override date is '04/11/2016'
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
#   | ALLF           | A15                  | ORG0001930     | CM             | 201608 | ALLF1617                | ALLF-930                 |         | 2               | 0            | 9999        | 
    | ALLF           | A15                  | ORG0001930     | CM             | 201609 | ALLF1617                | ALLF-930                 |         | 2               | 0            | 45          | 
    | ALLF           | A15                  | ORG0001930     | CM             | 201610 | ALLF1617                | ALLF-930                 |         | 2               | 0            | 67          | 
#   | ALLF           | A15                  | ORG0001930     | CM             | 201608 | ALLF1617                | ALLF-930                 |         | 3               | 0            | 9999        | 
    | ALLF           | A15                  | ORG0001930     | CM             | 201609 | ALLF1617                | ALLF-930                 |         | 3               | 0            | 56          | 
    | ALLF           | A15                  | ORG0001930     | CM             | 201610 | ALLF1617                | ALLF-930                 |         | 3               | 0            | 78          | 
#   | ALLF           | A15                  | ORG0001930     | CM             | 201608 | ALLF1617                | ALLF-930                 |         | 4               | 0            | 9999        | 
    | ALLF           | A15                  | ORG0001930     | CM             | 201609 | ALLF1617                | ALLF-930                 |         | 4               | 0            | 94          | 
    | ALLF           | A15                  | ORG0001930     | CM             | 201610 | ALLF1617                | ALLF-930                 |         | 4               | 0            | 95          | 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16   | Sep-16   | Oct-16   |
    | 24Loans-930    | ALLF-930      | 2               | 0.00     | 45.00    | 67.00    |
    | 24Loans-930    | ALLF-930      | 3               | 0.00     | 56.00    | 78.00    | 
    | 24Loans-930    | ALLF-930      | 4               | 0.00     | 94.00    | 95.00    | 

    And   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16               | Sep-16               | Oct-16               |
    | 24Loans-930    | ALLF-930      | 2               | 0.00                 | 0.00                 | 0.00                 |
    | 24Loans-930    | ALLF-930      | 3               | 0.00                 | 0.00                 | 0.00                 |
    | 24Loans-930    | ALLF-930      | 4               | 0.00                 | 94.00                | 95.00                |
    
    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16               | Sep-16               | Oct-16               |
    | 24Loans-930    | ALLF-930      | 2               | 0.00                 | 0.00                 | 0.00                 |
    | 24Loans-930    | ALLF-930      | 3               | 0.00                 | 0.00                 | 0.00                 |
    | 24Loans-930    | ALLF-930      | 4               | 0.00                 | 0.00                 | 0.00                 |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16               | Sep-16               | Oct-16               |
    | 24Loans-930    | ALLF-930      | 2               | 0.00                 | 0.00                 | 0.00                 |
    | 24Loans-930    | ALLF-930      | 3               | 0.00                 | 0.00                 | 0.00                 |
    | 24Loans-930    | ALLF-930      | 4               | 0.00                 | 94.00                | 95.00                |
    
    #
    # DCFS Summarised Actuals for November 2016
    #
    And   the override date is '06/12/2016'
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | ALLF           | A16                  | ORG0001930     | CM             | 201608 | ALLF1617                | ALLF-930                 |         | 2               | 0            | 89          | 
#   | ALLF           | A16                  | ORG0001930     | CM             | 201609 | ALLF1617                | ALLF-930                 |         | 2               | 0            | 9999        | 
    | ALLF           | A16                  | ORG0001930     | CM             | 201610 | ALLF1617                | ALLF-930                 |         | 2               | 0            | 103         | 
    | ALLF           | A16                  | ORG0001930     | CM             | 201608 | ALLF1617                | ALLF-930                 |         | 3               | 0            | 91          | 
#   | ALLF           | A16                  | ORG0001930     | CM             | 201609 | ALLF1617                | ALLF-930                 |         | 3               | 0            | 9999        | 
#   | ALLF           | A16                  | ORG0001930     | CM             | 201610 | ALLF1617                | ALLF-930                 |         | 3               | 0            | 9999        | 
    | ALLF           | A16                  | ORG0001930     | CM             | 201608 | ALLF1617                | ALLF-930                 |         | 4               | 0            | 96          | 
#   | ALLF           | A16                  | ORG0001930     | CM             | 201609 | ALLF1617                | ALLF-930                 |         | 4               | 0            | 9999        | 
    | ALLF           | A16                  | ORG0001930     | CM             | 201610 | ALLF1617                | ALLF-930                 |         | 4               | 0            | 97          | 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16   | Sep-16   | Oct-16   |
    | 24Loans-930    | ALLF-930      | 2               | 89.00    | 0.00     | 103.00   |
    | 24Loans-930    | ALLF-930      | 3               | 91.00    | 0.00     | 0.00     | 
    | 24Loans-930    | ALLF-930      | 4               | 96.00    | 0.00     | 97.00    | 

    And   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 |
    | 24Loans-930    | ALLF-930      | 2               | 0.00   | 0.00   | 0.00   |
    | 24Loans-930    | ALLF-930      | 3               | 0.00   | 0.00   | 0.00   |
    | 24Loans-930    | ALLF-930      | 4               | 96.00  | 0.00   | 97.00  |

    And   the Capping Amounts are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 |
    | 24Loans-930    | ALLF-930      | 2               | 0.00   | 0.00   | 0.00   |
    | 24Loans-930    | ALLF-930      | 3               | 0.00   | 0.00   | 0.00   |
    | 24Loans-930    | ALLF-930      | 4               | 0.00   | 0.00   | 0.00   |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-16 | Sep-16 | Oct-16 |
    | 24Loans-930    | ALLF-930      | 2               | 0.00   | 0.00   | 0.00   |
    | 24Loans-930    | ALLF-930      | 3               | 0.00   | 0.00   | 0.00   |
    | 24Loans-930    | ALLF-930      | 4               | 96.00  | 0.00   | 97.00  |

    And   the override date is reset

