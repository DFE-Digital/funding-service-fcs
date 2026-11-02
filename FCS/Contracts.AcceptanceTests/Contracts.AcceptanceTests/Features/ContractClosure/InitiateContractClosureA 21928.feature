Feature: InitiateContractClosureA 21928

@AcceptanceTest @Withdrawn20201209
@ContractClosure @ContractClosure
Scenario: A820 Create and approve a 1-allocation 1718 Mainstream contract. Successfully request contract closure. Consume actuals and create payment file. Check CRM, Paas and ADP feed.
    Given there is no Contract, Task or Workflow data for UKPRN '10017820' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there are no entries in the DCFS stub table 
	    
	# Cleardown and reset PaymentGeneration.PaymentTimetable 
    # This is needed for CM.ApprovedContract and CM.ApprovedContractAllocation checks to work
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 16-18APPS1718              | 201807               |                      | A              | NotStarted |

    And   there is no data in the PerformanceManagement.ContractAllocation or ContractAllocationDeliverable tables for the following providers 
    | UKPRN    | 
    | 10017820 | 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16AP-820      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017820' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017820 Co Ltd' with UKPRN '10017820' and OrgId 'ORG0017820' and has 'FCS1 Test' as a manager 
    And   UPIN '117820' is associated with UKPRN '10017820' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017820 | 117820 | 10017820 Co Ltd | 0              | Active | Yes           | AA017820      | ?             | 

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017820 | 10017820 Co Ltd      | ESFA-820             | MAIN-820       | 1                     | 01/08/2017        | 31/07/2018      | 18482.00      |                     | Contract for Services | 1718   | New          | ORG0017820 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent    |
    | 10017820 | MAIN-820       | 16AP-820      | 16-18 APPS        | 16-18APPS1718           | AY                      | 01/08/2017          | 31/07/2018        | 18482.00        |         |         |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                | CRMIntent    |
    | 10017820 | MAIN-820       | 16AP-820      | 2               | 0                     | 18482.00  | 1747.00  | 2705.00  | 2931.00  | 1370.00  | 724.00   | 1175.00  | 1476.00  | 576.00   | 2189.00  | 393.00   | 757.00   | 2439.00  | 16-18 Apprenticeships Total Funding   | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract 'MAIN-820' is in a state of 'Published to Provider'

    # Check the deliverable count in CRM 
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MAIN-820'

    # Change the date
    And   the override date is '15/07/2017'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-820' and actual ContractNumber 'MAIN-820'
 
    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017820 | MAIN-820           | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017820 | ESFA-820           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017820 | MAIN-820           | 1                     | 16AP-820      | 01/08/2017          | 31/07/2018        |

    # Change the date
    And   the override date is '01/08/2018'

	# Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'MAIN-820' for provider '10017820'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017820 | MAIN-820           | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017820 | ESFA-820           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017820 | MAIN-820           | 1                     | 16AP-820      | 01/08/2017          | 31/07/2018        |
 
    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'MAIN-820' for provider '10017820'
    | Task                     | Description                | Regarding |  Owner     | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017820 - 10017820 Co Ltd | MAIN-820  | FCS1 Test | Contract Managers Team | Open  | Not Started |
    
    # Check that the workflow history includes two new entries
    And   the workflow history on contract 'MAIN-820' version '1' includes the following
    | Action                        | CompletedBy      | Comment                       | 
    | Closure Initiation Successful | CRM Integration  | ?                             | 
    | Initiate Contract Closure     | FCS2 Test       | ?                             | 

    # Change the date
    And   the override date is '04/08/2018'

    # DCFS Summarised Actuals for July 2018
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201708 | 16-18APPS1718           | 16AP-820                 |         | 6               | 0            | 1385.00     |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201709 | 16-18APPS1718           | 16AP-820                 |         | 6               | 0            | 107.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201710 | 16-18APPS1718           | 16AP-820                 |         | 6               | 0            | 189.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201711 | 16-18APPS1718           | 16AP-820                 |         | 6               | 0            | 42.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201712 | 16-18APPS1718           | 16AP-820                 |         | 6               | 0            | 65.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201801 | 16-18APPS1718           | 16AP-820                 |         | 6               | 0            | 73.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201802 | 16-18APPS1718           | 16AP-820                 |         | 6               | 0            | 24.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201803 | 16-18APPS1718           | 16AP-820                 |         | 6               | 0            | 67.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201804 | 16-18APPS1718           | 16AP-820                 |         | 6               | 0            | 122.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201805 | 16-18APPS1718           | 16AP-820                 |         | 6               | 0            | 4.00        |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201806 | 16-18APPS1718           | 16AP-820                 |         | 6               | 0            | 197.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201807 | 16-18APPS1718           | 16AP-820                 |         | 6               | 0            | 144.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201708 | 16-18APPS1718           | 16AP-820                 |         | 7               | 0            | 1953.00     |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201709 | 16-18APPS1718           | 16AP-820                 |         | 7               | 0            | 154.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201710 | 16-18APPS1718           | 16AP-820                 |         | 7               | 0            | 57.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201711 | 16-18APPS1718           | 16AP-820                 |         | 7               | 0            | 89.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201712 | 16-18APPS1718           | 16AP-820                 |         | 7               | 0            | 146.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201801 | 16-18APPS1718           | 16AP-820                 |         | 7               | 0            | 61.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201802 | 16-18APPS1718           | 16AP-820                 |         | 7               | 0            | 212.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201803 | 16-18APPS1718           | 16AP-820                 |         | 7               | 0            | 51.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201804 | 16-18APPS1718           | 16AP-820                 |         | 7               | 0            | 144.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201805 | 16-18APPS1718           | 16AP-820                 |         | 7               | 0            | 27.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201806 | 16-18APPS1718           | 16AP-820                 |         | 7               | 0            | 43.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201807 | 16-18APPS1718           | 16AP-820                 |         | 7               | 0            | 101.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201708 | 16-18APPS1718           | 16AP-820                 |         | 8               | 0            | 713.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201709 | 16-18APPS1718           | 16AP-820                 |         | 8               | 0            | 98.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201710 | 16-18APPS1718           | 16AP-820                 |         | 8               | 0            | 134.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201711 | 16-18APPS1718           | 16AP-820                 |         | 8               | 0            | 91.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201712 | 16-18APPS1718           | 16AP-820                 |         | 8               | 0            | 12.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201801 | 16-18APPS1718           | 16AP-820                 |         | 8               | 0            | 36.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201802 | 16-18APPS1718           | 16AP-820                 |         | 8               | 0            | 36.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201803 | 16-18APPS1718           | 16AP-820                 |         | 8               | 0            | 193.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201804 | 16-18APPS1718           | 16AP-820                 |         | 8               | 0            | 120.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201805 | 16-18APPS1718           | 16AP-820                 |         | 8               | 0            | 71.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201806 | 16-18APPS1718           | 16AP-820                 |         | 8               | 0            | 10.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201807 | 16-18APPS1718           | 16AP-820                 |         | 8               | 0            | 82.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201708 | 16-18APPS1718           | 16AP-820                 |         | 9               | 0            | 634.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201709 | 16-18APPS1718           | 16AP-820                 |         | 9               | 0            | 190.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201710 | 16-18APPS1718           | 16AP-820                 |         | 9               | 0            | 37.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201711 | 16-18APPS1718           | 16AP-820                 |         | 9               | 0            | 78.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201712 | 16-18APPS1718           | 16AP-820                 |         | 9               | 0            | 38.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201801 | 16-18APPS1718           | 16AP-820                 |         | 9               | 0            | 115.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201802 | 16-18APPS1718           | 16AP-820                 |         | 9               | 0            | 51.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201803 | 16-18APPS1718           | 16AP-820                 |         | 9               | 0            | 64.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201804 | 16-18APPS1718           | 16AP-820                 |         | 9               | 0            | 51.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201805 | 16-18APPS1718           | 16AP-820                 |         | 9               | 0            | 218.00      |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201806 | 16-18APPS1718           | 16AP-820                 |         | 9               | 0            | 38.00       |
    | ILR1718        | R12                  | ORG0017820     | CM             | 201807 | 16-18APPS1718           | 16AP-820                 |         | 9               | 0            | 152.00      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUALS in CRM
    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-820       | 16AP-820        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-820       | 16AP-820        | 6               | 2419.00  | 1385.00  | 107.00   | 189.00   | 42.00    | 65.00    | 73.00    | 24.00    | 67.00    | 122.00   | 4.00     | 197.00   | 144.00   | 
    | MAIN-820       | 16AP-820        | 7               | 3038.00  | 1953.00  | 154.00   | 57.00    | 89.00    | 146.00   | 61.00    | 212.00   | 51.00    | 144.00   | 27.00    | 43.00    | 101.00   | 
    | MAIN-820       | 16AP-820        | 8               | 1596.00  | 713.00   | 98.00    | 134.00   | 91.00    | 12.00    | 36.00    | 36.00    | 193.00   | 120.00   | 71.00    | 10.00    | 82.00    | 
    | MAIN-820       | 16AP-820        | 9               | 1666.00  | 634.00   | 190.00   | 37.00    | 78.00    | 38.00    | 115.00   | 51.00    | 64.00    | 51.00    | 218.00   | 38.00    | 152.00   | 
    | MAIN-820       | 16AP-820        | 10              | 0.00     | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
 
    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-820       | 16AP-820        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-820       | 16AP-820        | 6               | 2419.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2419.00  | 
    | MAIN-820       | 16AP-820        | 7               | 3038.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3038.00  | 
    | MAIN-820       | 16AP-820        | 8               | 1596.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1596.00  | 
    | MAIN-820       | 16AP-820        | 9               | 1666.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1666.00  | 
    | MAIN-820       | 16AP-820        | 10              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-820       | 16AP-820        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-820       | 16AP-820        | 6               | 2419.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2419.00  | 
    | MAIN-820       | 16AP-820        | 7               | 3038.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3038.00  | 
    | MAIN-820       | 16AP-820        | 8               | 1596.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1596.00  | 
    | MAIN-820       | 16AP-820        | 9               | 1666.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1666.00  | 
    | MAIN-820       | 16AP-820        | 10              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017820 | ORG0017820 | 16AP-820          | 2240100         | 16-18APPS1718              | 201708               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017820 | ORG0017820 | 16AP-820          | 2240100         | 16-18APPS1718              | 201709               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017820 | ORG0017820 | 16AP-820          | 2240100         | 16-18APPS1718              | 201710               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017820 | ORG0017820 | 16AP-820          | 2240100         | 16-18APPS1718              | 201711               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017820 | ORG0017820 | 16AP-820          | 2240100         | 16-18APPS1718              | 201712               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017820 | ORG0017820 | 16AP-820          | 2240100         | 16-18APPS1718              | 201801               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017820 | ORG0017820 | 16AP-820          | 2240100         | 16-18APPS1718              | 201802               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017820 | ORG0017820 | 16AP-820          | 2240100         | 16-18APPS1718              | 201803               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017820 | ORG0017820 | 16AP-820          | 2240100         | 16-18APPS1718              | 201804               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017820 | ORG0017820 | 16AP-820          | 2240100         | 16-18APPS1718              | 201805               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017820 | ORG0017820 | 16AP-820          | 2240100         | 16-18APPS1718              | 201806               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017820 | ORG0017820 | 16AP-820          | 2240100         | 16-18APPS1718              | 201807               | RECONCILIATION  | CM             | False       | 8719.00         |

    # Create payment file
    Given the override date is '08/08/2018 22:05'

	# PaymentGeneration.PaymentBatchFeedItem
	And   there is no data in the Payment feed for FundingStreamPeriod '16-18APPS1718' PaymentPeriod '201804' CensusEndDate '07/08/2018' and LinkCodeSuffix 'A'

    # PaymentGeneration.PaymentTimetable
    And   the below configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 16-18APPS1718              | 201807               |                      | A              | NotStarted |

#    # Coda.AccountCode
#    And   the following configuration exists in the Account Codes table
#    | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#    | 10017820 | 16-18APPS1718              | CODA820   | 8113000      | 01/04/1990           | 31/03/2019         |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 16-18APPS1718              | 201807               | Completed |

#    # File created in Maytech FTP folder
#    And   Payment file 'AP1620180407A.pay' is created in the FTP Folder
#
#    And   the following data exists in the payment file
#    #                                                                 Control     Provider
#    # LineType   LinkCode      CompanyCode    OUCode      Plus        Account     Account     Payment    Description                            ExtRef6
#    #                                                                 Code        Code        Amount
#    | LineType | LinkCode    | Company Code | Element 1 | Element 2 | Element 3 | Element 4 | Amount   | Subnominal Short Description         | Element 25 |
#    | 157      | AP16180407A | SFA          | AAA40     | +         | 8113000   | CODA820   | 8719.00  | 16-18 Apps Rec Aug18                 | 2240100    |
#    | 158      | AP16180407A | SFA          | AAA40     | +         | 2240100   | 5000      | 8719.00  | 16-18 Apps Rec Aug18                 | CODA820    |

    # Check contents of the AllocationDelivery.AllocationDeliveryEntry (ADP) feed
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events
    | ContractNumber | AllocationNumber | ContractVersionNumber | AllocationDeliveryEntryCategory    | ADCode |
    | MAIN-820       | 16AP-820         | 1                     | NewContractAllocationApproved      | 0      |
    | MAIN-820       | 16AP-820         | 1                     | ContractAllocationActualsReceived  | 2      |

    # Tidy up
    And   the override date is reset
	
@AcceptanceTest @Withdrawn20260521 
@ContractClosure
Scenario: A830 Create a 1-allocation 1718 Mainstream contract then attempt a contract amendment. Fail UDC019 and UDC020
    Given there is no Contract, Task or Workflow data for UKPRN '10017830' 
        
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16AP-830      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017830' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017830 Co Ltd' with UKPRN '10017830' and OrgId 'ORG0017830' and has 'FCS1 Test' as a manager 
    And   UPIN '117830' is associated with UKPRN '10017830' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017830 | 117830 | 10017830 Co Ltd | 0              | Active | Yes           | AA017830      | ?             | 

    # Change the date 
    And   the override date is '07/07/2017' 

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017830 | 10017830 Co Ltd      | ESFA-830             | MAIN-830       | 1                     | 01/08/2017        | 31/07/2018      | 18482.00      |                     | Contract for Services | 1718   | New          | ORG0017830 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent    |
    | 10017830 | MAIN-830       | 16AP-830      | 16-18 APPS        | 16-18APPS1718           | AY                      | 01/08/2017          | 31/07/2018        | 18482.00        |         |         |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                | CRMIntent    |
    | 10017830 | MAIN-830       | 16AP-830      | 2               | 0                     | 18482.00  | 1747.00  | 2705.00  | 2931.00  | 1370.00  | 724.00   | 1175.00  | 1476.00  | 576.00   | 2189.00  | 393.00   | 757.00   | 2439.00  | 16-18 Apprenticeships Total Funding   | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

	# Change the date 
    And   the override date is '12/07/2017' 

    # Publish the contract
    And   the latest version of contract 'MAIN-830' is in a state of 'Published to Provider'

	# Change the date 
    And   the override date is '25/07/2017' 
	
	# Bulk file to attempt to amend the contract. This should fail UDC020 because the contract is not approved
    Given there are no files prefixed '10017830_MAIN-830' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1718 23012018165319 v2_A830' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 23012018165319 v2_A830' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 23012018165319 v2_A830' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 1718 23012018165319 v2_A830.xlsx' exists in the Datafiles folder and UKPRN '10017830' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder	  
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report file

	# UDC020 error message
    And   '[Contract] Cannot create a draft Contract Amendment if there is no existing Approved Contract, or if the Contract is awaiting approval of either termination initiation, modification or closure' is displayed in field 'J2' on the 'Contract' tab of the result report file 
    
	# UDC019 error message
	And   '[Contract] Cannot create a draft Contract Amendment if there is no existing Approved Contract' is displayed in field 'J2' on the 'Contract' tab of the result report file

    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20240103 
@ContractClosure
Scenario: A658 Create an ESF1420 contract but leave it at published to provider. Fail to close contract 3x: v1 is in draft. Check CRM, Tasks and Notifications
    Given there is no Contract, Task or Workflow data for UKPRN '10017658' 
   #And   there are no notifications of type 'Contract Closure Initiation Failed'
	And   there are no notifications in CRM of type 'Contract Closure Initiation Failed' for UKPRN '10017658'
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    And   there is no data in the PerformanceManagement.ContractAllocation or ContractAllocationDeliverable tables for the following providers 
    | UKPRN    | 
    | 10017658 | 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ESF-658       |

    # Change the date 
    And   the override date is '14/07/2017' 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017658' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017658 Co Ltd' with UKPRN '10017658' and OrgId 'ORG0017658' and has 'FCS1 Test' as a manager 
    And   UPIN '117658' is associated with UKPRN '10017658' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017658 | 117658 | 10017658 Co Ltd | 0              | Active | Yes           | AA017658      | ?             | 

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017658 | 10017658 Co Ltd      | ESFA-658             | ESIF-658       | 1                     | 01/08/2017        | 31/07/2018      | 58053.00      | Contract for Services | 1420   | New          | ORG0017658 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName  | UoPCode  | AllocationDescription | CRMIntent  | LEPName                           | LEPCode | LotReference | TenderSpecificationReference | TenderAwardReference          | InvestmentPriority    | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017658 | ESIF-658       | ESF-658       | ESF 201420        | ESF                     | 01/08/2017          | 31/07/2018        | 58053.00        |          |          |                       | New        | Leicester and Leicestershire LEP  | E37021  | 00-1         | TSS_20125                    | 20125/23-415-00-1/10017658    | 1.4 Active Inclusion  | 777\SD\7658     | Job Seekers Fund    | SSR                | Transition     | 1.07                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription       | CRMIntent    | DeliveryOrg |
    | 10017658 | ESIF-658       | ESF-658       | 2               | 0                     |          | 29175.00  | 5000.00  | 132.00   | 1278.00  | 462.00   | 650.00   | 3046.00  | 2355.00  | 662.00   | 4709.00  | 2769.00  | 4527.00  | 3585.00  | RQ01 Regulated Learning      | New          |             |
    | 10017658 | ESIF-658       | ESF-658       | 3               | 0                     |          | 28878.00  | 509.00   | 1167.00  | 4080.00  | 2736.00  | 2155.00  | 2003.00  | 787.00   | 21.00    | 3230.00  | 3949.00  | 3273.00  | 4968.00  | NR01 Non Regulated Activity  | New          |             |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 

    # Check that the deliverables have all been created in CRM
    Then   there are '24' deliverable periods in CRM linked to the latest version of contract 'ESIF-658' and allocation 'ESF-658'

    # Change the date 
    And   the override date is '23/07/2017' 
 
    # Publish the contract 
    And   the latest version of contract 'ESIF-658' is in a state of 'Published to Provider' 

    # Change the date 
    And   the override date is '12/08/2018' 

    # Request closure of the contract. This should fail
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'ESIF-658' for provider '10017658'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus     | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017658 | ESIF-658           | 1                     | 0                        | Draft            | Published to Provider | True          | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017658 | ESFA-658           | 1                     | 0                        | Draft            | ?                     | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Try again. This should fail too
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'ESIF-658' for provider '10017658'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus     | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017658 | ESIF-658           | 1                     | 0                        | Draft            | Published to Provider | True          | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017658 | ESFA-658           | 1                     | 0                        | Draft            | ?                     | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Try a third time. Yet another fail
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'ESIF-658' for provider '10017658'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus     | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017658 | ESIF-658           | 1                     | 0                        | Draft            | Published to Provider | True          | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017658 | ESFA-658           | 1                     | 0                        | Draft            | ?                     | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM have not changed
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017658 | ESIF-658           | 1                     | ESF-658       | 01/08/2017          | 31/07/2018        |

    # Check that three NOTIFICATIONs have been created and sent to the Advisor explaining why the closure failed
   #And   there are notifications of type 'Contract Closure Initiation Failed' owned by the 'Lead Manager Team' as follows
   #And   there are notifications of type 'Contract Closure Initiation Failed' owned by the user 'FCS2 Test' as follows
    And   there are '3' notifications of type 'Contract Closure Initiation Failed' owned by user 'FCS2 Test' which match the following
    | Status | NotificationName                              | NotificationText                                                                                                        |
    | New    | Contract Closure Initiation Failed - ESIF-658 | Contract ESIF-658 v1 for provider 10017658 (10017658 Co Ltd) cannot be closed - it must be either Approved or Modified  |

#    Workflow history is not created at all because the contract is not at Approved\Approved (see 29128 and A816 and A818)
#
#    # Check that the WORKFLOW HISTORY includes three closure initiations
#   #And   the workflow history on contract 'ESIF-658' version '1' includes the following
#    And   the workflow history on contract 'ESIF-658' version '1' includes '3' entries which match the following
#    | Action                        | CompletedBy      | Comment                      | 
#    | Initiate Contract Closure     | FCS2 Test        | ?                            | 
#
#    # Check that the WORKFLOW HISTORY includes three closure initiation failures
#   #And   the workflow history on contract 'ESIF-658' version '1' includes the following
#    And   the workflow history on contract 'ESIF-658' version '1' includes '3' entries which match the following
#    | Action                        | CompletedBy      | Comment                      | 
#    | Closure Initiation Failed     | CRM Integration  | ?                            | 

    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20260521 
@ContractClosure
Scenario: A659 Create and approve a 1718 Mainstream contract. Successfully request contract closure. Fail to approve closure 4x: month end is running. Check CRM, Tasks and Notifications
    Given there is no Contract, Task or Workflow data for UKPRN '10017659' 
   #And   there are no notifications of type 'Contract Closure Failed'
	And   there are no notifications in CRM of type 'Contract Closure Failed' for UKPRN '10017659'
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
	    
    And   there is no data in the PerformanceManagement.ContractAllocation or ContractAllocationDeliverable tables for the following providers 
    | UKPRN    | 
    | 10017659 | 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16AP-659      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017659' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017659 Co Ltd' with UKPRN '10017659' and OrgId 'ORG0017659' and has 'FCS1 Test' as a manager 
    And   UPIN '117659' is associated with UKPRN '10017659' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017659 | 117659 | 10017659 Co Ltd | 0              | Active | Yes           | AA017659      | ?             | 

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017659 | 10017659 Co Ltd      | ESFA-659             | MAIN-659       | 1                     | 01/08/2017        | 31/07/2018      | 18482.00      |                     | Contract for Services | 1718   | New          | ORG0017659 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent    |
    | 10017659 | MAIN-659       | 16AP-659      | 16-18 APPS        | 16-18APPS1718           | AY                      | 01/08/2017          | 31/07/2018        | 18482.00        |         |         |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                | CRMIntent    |
    | 10017659 | MAIN-659       | 16AP-659      | 2               | 0                     | 18482.00  | 1747.00  | 2705.00  | 2931.00  | 1370.00  | 724.00   | 1175.00  | 1476.00  | 576.00   | 2189.00  | 393.00   | 757.00   | 2439.00  | 16-18 Apprenticeships Total Funding   | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract 'MAIN-659' is in a state of 'Published to Provider'

    # Check the deliverable count in CRM 
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MAIN-659'

    # Change the date
    And   the override date is '15/07/2017'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-659' and actual ContractNumber 'MAIN-659'
 
    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017659 | MAIN-659           | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017659 | ESFA-659           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017659 | MAIN-659           | 1                     | 16AP-659      | 01/08/2017          | 31/07/2018        |

    # Change the date
    And   the override date is '01/08/2018'

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'MAIN-659' for provider '10017659'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017659 | MAIN-659           | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017659 | ESFA-659           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017659 | MAIN-659           | 1                     | 16AP-659      | 01/08/2017          | 31/07/2018        |
 
    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'MAIN-659' for provider '10017659'
    | Task                     | Description                | Regarding |  Owner     | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017659 - 10017659 Co Ltd | MAIN-659  | FCS1 Test | Contract Managers Team | Open  | Not Started |
    
    # Check that the workflow history includes two new entries
    And   the workflow history on contract 'MAIN-659' version '1' includes the following
    | Action                        | CompletedBy      | Comment                       | 
    | Closure Initiation Successful | CRM Integration  | ?                             | 
    | Initiate Contract Closure     | FCS2 Test       | ?                             | 

    # Change the date
    And   the override date is '04/08/2018'

    # Month end is running
    And   the PaaS MonthEndIsRunning indicator is set to 'True'

    # Approve closure of the contract. This should fail because month end processing is running 
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract 'MAIN-659' for provider '10017659'

    # Check that the CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017659 | MAIN-659           | 1                     | 0                        | Approved       | Awaiting Closure Approval | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017659 | ESFA-659           | 1                     | 0                        | Draft          | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

	And   there are '1' notifications of type 'Contract Closure Failed' owned by user 'FCS1 Test' which match the following
    | Status | NotificationName                    | NotificationText                                                                                                                             |
    | New    | Contract Closure Failed - MAIN-659  | Contract MAIN-659 v1 for provider 10017659 (10017659 Co Ltd) cannot be closed - month-end processing is in progress - please try again later |

    # Try and fail a second time
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract 'MAIN-659' for provider '10017659'

    # Check that the CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017659 | MAIN-659           | 1                     | 0                        | Approved       | Awaiting Closure Approval | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017659 | ESFA-659           | 1                     | 0                        | Draft          | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

	And   there are '2' notifications of type 'Contract Closure Failed' owned by user 'FCS1 Test' which match the following
    | Status | NotificationName                    | NotificationText                                                                                                                             |
    | New    | Contract Closure Failed - MAIN-659  | Contract MAIN-659 v1 for provider 10017659 (10017659 Co Ltd) cannot be closed - month-end processing is in progress - please try again later |

    # And a third attempt. This fails too
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract 'MAIN-659' for provider '10017659'

    # Check that the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017659 | MAIN-659           | 1                     | 0                        | Approved       | Awaiting Closure Approval | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017659 | ESFA-659           | 1                     | 0                        | Draft          | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

	And   there are '3' notifications of type 'Contract Closure Failed' owned by user 'FCS1 Test' which match the following
    | Status | NotificationName                    | NotificationText                                                                                                                             |
    | New    | Contract Closure Failed - MAIN-659  | Contract MAIN-659 v1 for provider 10017659 (10017659 Co Ltd) cannot be closed - month-end processing is in progress - please try again later |

    # And a fourth attempt. Yet another fail
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract 'MAIN-659' for provider '10017659'

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract 'MAIN-659' for provider '10017659'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State     | Status      |
    | Confirm Closure Approval | 10017659 - 10017659 Co Ltd | MAIN-659     | FCS1 Test | Contract Managers Team | Completed | Completed   |

    # Check that the CONTRACT version, status and dates in CRM have not changed
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017659 | MAIN-659           | 1                     | 0                        | Approved       | Awaiting Closure Approval | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017659 | ESFA-659           | 1                     | 0                        | Draft          | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

   # Check that the ALLOCATION dates in CRM have not changed
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017659 | MAIN-659           | 1                     | 16AP-659      | 01/08/2017          | 31/07/2018        |

    # Check that four NOTIFICATIONs have been created and sent to the Advisor explaining why the closure failed
   #And   there are notifications of type 'Contract Closure Failed' owned by the 'Lead Manager Team' as follows
   #And   there are notifications of type 'Contract Closure Failed' owned by the user 'FCS1 Test' as follows
    And   there are '4' notifications of type 'Contract Closure Failed' owned by user 'FCS1 Test' which match the following
    | Status | NotificationName                    | NotificationText                                                                                                                             |
    | New    | Contract Closure Failed - MAIN-659  | Contract MAIN-659 v1 for provider 10017659 (10017659 Co Ltd) cannot be closed - month-end processing is in progress - please try again later |

    # Check that the WORKFLOW HISTORY includes four closure approval attempts
   #And   the workflow history on contract 'MAIN-659' version '1' includes the following
    And   the workflow history on contract 'MAIN-659' version '1' includes '4' entries which match the following
    | Action                        | CompletedBy      | Comment                      | 
    | Approve Closure               | FCS1 Test       | ?                            | 

    # Check that the WORKFLOW HISTORY includes four closure approval failures
   #And   the workflow history on contract 'MAIN-659' version '1' includes the following
    And   the workflow history on contract 'MAIN-659' version '1' includes '4' entries which match the following
    | Action                        | CompletedBy      | Comment                      | 
    | Contract Closure Failed       | CRM Integration  | ?                            | 

    # Tidy up
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   the override date is reset
  
