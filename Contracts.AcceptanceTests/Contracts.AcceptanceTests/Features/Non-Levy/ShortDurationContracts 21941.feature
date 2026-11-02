Feature: ShortDurationContracts 21941

@AcceptanceTest @Withdrawn20231002
Scenario: A400 Create and approve a short duration 1718 Non-Levy contract. Consume actuals and check that pay schedule is created in CRM. Live bug. Story 21941
    Given there is no Contract, Task or Workflow data for UKPRN '10017400' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there are no entries in the DCFS stub table 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017400' 
    And   the override date is reset 
 
    And   there is no data in the PerformanceManagement.ContractAllocation or ContractAllocationDeliverable tables for the following providers 
    | UKPRN    | 
    | 10017400 | 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16NL-400      |
    | ANL-400       |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017400' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017400 Co Ltd' with UKPRN '10017400' and OrgId 'ORG0017400' and has 'FCS1 Test' as a manager 
    And   UPIN '117400' is associated with UKPRN '10017400' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017400 | 117400 | 10017400 Co Ltd | 0              | Active | Yes           | AA017400      | ?             | 

    # Change the date
    And   the override date is '07/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017400 | 10017400 Co Ltd      | ESFA-400             | MAIN-400       | 1                     | 01/08/2017        | 31/12/2017      | 16022.00      |                                | Contract for Services | 1718   | New          | ORG0017400 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode    | AllocationDescription | CRMIntent    |
    | 10017400 | MAIN-400       | 16NL-400      | 16-18NLA          | 16-18NLA1718            | AY                      | 01/08/2017          | 31/12/2017        | 13568.00        |         |            |                       | New          |
    | 10017400 | MAIN-400       | ANL-400       | ANLA              | ANLA1718                | AY                      | 01/08/2017          | 31/12/2017        | 2454.00         |         |            |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | DeliverableDescription                                          | CRMIntent    |
    | 10017400 | MAIN-400       | 16NL-400      | 1               | 0                     | 13568.00  | 3026.00  | 2777.00  | 1339.00  | 3369.00  | 3057.00  | Total 16-18 Non-Levy Apprenticeships Funding                    | New          |
    | 10017400 | MAIN-400       | ANL-400       | 1               | 0                     | 2454.00   | 305.00   | 413.00   | 1194.00  | 492.00   | 50.00    | Total Adult Non-Levy Apprenticeships Funding                    | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    And   the override date is '11/07/2017'

    # Publish the contract
    And   the latest version of contract 'MAIN-400' is in a state of 'Published to Provider'

    # Check the deliverable count in CRM 
    And   there are '10' deliverable period rows in CRM linked to the latest version of contract 'MAIN-400'

    # Change the date
    And   the override date is '15/07/2017'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-400' and actual ContractNumber 'MAIN-400'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-400' is in status 'Approved'

    # Check the deliverable count in CRM has increased to reflect the addition of monitoring deliverables 
    And   there are '40' deliverable period rows in CRM linked to the latest version of contract 'MAIN-400'

    # Consume DCFS format actuals
    Given there are no entries in the DCFS stub table
    And   the override date is '07/09/2017'

    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | ILR1718        | R04                  | ORG0017400     | CM             | 201708 | 16-18NLA1718            | 16NL-400                 |         | 2               | 0            | 4000.00     |
    | ILR1718        | R04                  | ORG0017400     | CM             | 201708 | 16-18NLA1718            | 16NL-400                 |         | 3               | 0            | 5000.00     |
    | ILR1718        | R04                  | ORG0017400     | CM             | 201708 | 16-18NLA1718            | 16NL-400                 |         | 4               | 0            | 6000.00     |
    | ILR1718        | R04                  | ORG0017400     | CM             | 201708 | ANLA1718                | ANL-400                  |         | 2               | 0            | 1000.00     |
    | ILR1718        | R04                  | ORG0017400     | CM             | 201708 | ANLA1718                | ANL-400                  |         | 3               | 0            | 2000.00     |
    | ILR1718        | R04                  | ORG0017400     | CM             | 201708 | ANLA1718                | ANL-400                  |         | 4               | 0            | 3000.00     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the PLANNED VALUES in CRM
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   |
    | MAIN-400       | 16NL-400        | 1               | 13568.00 | 3026.00  | 2777.00  | 1339.00  | 3369.00  | 3057.00  | 
    | MAIN-400       | 16NL-400        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-400       | 16NL-400        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-400       | 16NL-400        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-400       | ANL-400         | 1               | 2454.00  | 305.00   | 413.00   | 1194.00  | 492.00   | 50.00    | 
    | MAIN-400       | ANL-400         | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-400       | ANL-400         | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-400       | ANL-400         | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUALS in CRM
    And   the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   |
    | MAIN-400       | 16NL-400        | 1               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | MAIN-400       | 16NL-400        | 2               | 4000.00  | 4000.00  | ?        | ?        | ?        | ?        | 
    | MAIN-400       | 16NL-400        | 3               | 5000.00  | 5000.00  | ?        | ?        | ?        | ?        | 
    | MAIN-400       | 16NL-400        | 4               | 6000.00  | 6000.00  | ?        | ?        | ?        | ?        | 
    | MAIN-400       | ANL-400         | 1               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | MAIN-400       | ANL-400         | 2               | 1000.00  | 1000.00  | ?        | ?        | ?        | ?        | 
    | MAIN-400       | ANL-400         | 3               | 2000.00  | 2000.00  | ?        | ?        | ?        | ?        | 
    | MAIN-400       | ANL-400         | 4               | 3000.00  | 3000.00  | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   |
    | MAIN-400       | 16NL-400        | 1               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | MAIN-400       | 16NL-400        | 2               | 4000.00  | 4000.00  | ?        | ?        | ?        | ?        | 
    | MAIN-400       | 16NL-400        | 3               | 5000.00  | 5000.00  | ?        | ?        | ?        | ?        | 
    | MAIN-400       | 16NL-400        | 4               | 6000.00  | 6000.00  | ?        | ?        | ?        | ?        | 
    | MAIN-400       | ANL-400         | 1               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | MAIN-400       | ANL-400         | 2               | 1000.00  | 1000.00  | ?        | ?        | ?        | ?        | 
    | MAIN-400       | ANL-400         | 3               | 2000.00  | 2000.00  | ?        | ?        | ?        | ?        | 
    | MAIN-400       | ANL-400         | 4               | 3000.00  | 3000.00  | ?        | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   |
    | MAIN-400       | 16NL-400        | 1               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | MAIN-400       | 16NL-400        | 2               | -636.44  | -636.44  | ?        | ?        | ?        | ?        | 
    | MAIN-400       | 16NL-400        | 3               | -795.56  | -795.56  | ?        | ?        | ?        | ?        | 
    | MAIN-400       | 16NL-400        | 4               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | MAIN-400       | ANL-400         | 1               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | MAIN-400       | ANL-400         | 2               | -1000.00 | -1000.00 | ?        | ?        | ?        | ?        | 
    | MAIN-400       | ANL-400         | 3               | -2000.00 | -2000.00 | ?        | ?        | ?        | ?        | 
    | MAIN-400       | ANL-400         | 4               | -546.00  | -546.00  | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   |
    | MAIN-400       | 16NL-400        | 1               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | MAIN-400       | 16NL-400        | 2               | 3363.56  | 3363.56  | ?        | ?        | ?        | ?        | 
    | MAIN-400       | 16NL-400        | 3               | 4204.44  | 4204.44  | ?        | ?        | ?        | ?        | 
    | MAIN-400       | 16NL-400        | 4               | 6000.00  | 6000.00  | ?        | ?        | ?        | ?        | 
    | MAIN-400       | ANL-400         | 1               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | MAIN-400       | ANL-400         | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | MAIN-400       | ANL-400         | 3               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | MAIN-400       | ANL-400         | 4               | 2454.00  | 2454.00  | ?        | ?        | ?        | ?        | 

    # Tidy up
    And   the override date is reset
