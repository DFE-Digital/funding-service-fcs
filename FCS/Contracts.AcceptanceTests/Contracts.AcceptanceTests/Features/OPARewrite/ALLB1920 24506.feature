Feature: ALLB1920 24506

@AcceptanceTest @Withdrawn20211216
@Long2Run @Long2Run123
Scenario: A397 OPA Rewrite. Create and approve an ALLB1920 Loans contract. Consume actuals 2x. Bulk amend and approve. Consume actuals 1x. Check CRM along the way
    And   there are no terminated or closed allocations for UKPRN '10017397' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017397' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017397' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLB-397      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLB-397      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLB1920          |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017397' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017397 Co Ltd' with UKPRN '10017397' and OrgId 'ORG0017397' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017397' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017397 | 117397 | 10017397 Co Ltd | 0              | Active                | Yes           | AA017397      | ?             | 59 The High Street     | Maidstone              | Kent                   | ?                      | ?                      | ?                      | ME14 1SR  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017397 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017397 | 10017397 Co Ltd      | ESFA-397             | EDSK-397       | 1                     | 01/08/2019        | 31/07/2020      | 27935.00      |                                       | Conditions of Funding (Grant) (LA)         | 1920   | New          | ORG0017397 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017397 | EDSK-397       | ALLB-397      | ALLB              | ALLB1920                | AY                      | 01/08/2019          | 31/07/2020        | 27935.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg | 3%       | 10%      | 
    | 10017397 | EDSK-397       | ALLB-397      | 1               | 0                     | 27935.00  | 20131.00  | 7804.00   | 2683.00  | 3671.00  | 706.00   | 3181.00  | 3157.00  | 2248.00  | 1274.00  | 3211.00  | 1101.00  | 1995.00  | 3014.00  | 1694.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             | n/a      | n/a      |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-397' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-397'




    # Change the date
    Given the override date is '17/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-397' and actual ContractNumber 'EDSK-397'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-397' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017397 | EDSK-397           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017397 | ESFA-397           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'EDSK-397'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | ALLB-397      | 2303800          | Jul-20 | Reconciliation |

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 27935.00  | 2683.00  | 3671.00  | 706.00   | 3181.00  | 3157.00  | 2248.00  | 1274.00  | 3211.00  | 1101.00  | 1995.00  | 3014.00  | 1694.00  | 
    | EDSK-397       | ALLB-397           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




    # Consume actuals. No capping occurs

    # Change the date
    Given the override date is '04/10/2019'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R02                  | ORG0017397     | CM             | 201908 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 6567.26     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 201908 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 1041.34     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 201908 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 3308.61     |
    # Sep
    | ILR1920        | R02                  | ORG0017397     | CM             | 201909 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 888.28      |
    | ILR1920        | R02                  | ORG0017397     | CM             | 201909 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 4754.77     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 201909 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 3488.76     |
    #
    | ILR1920        | R02                  | ORG0017397     | CM             | 201910 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 2236.46     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 201910 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 94.39       |
    | ILR1920        | R02                  | ORG0017397     | CM             | 201910 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 267.52      |
    | ILR1920        | R02                  | ORG0017397     | CM             | 201911 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 2157.34     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 201911 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 2310.23     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 201911 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 1634.60     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 201912 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 562.31      |
    | ILR1920        | R02                  | ORG0017397     | CM             | 201912 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 326.69      |
    | ILR1920        | R02                  | ORG0017397     | CM             | 201912 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 1641.00     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202001 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 1125.68     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202001 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 638.87      |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202001 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 247.58      |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202002 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 2026.58     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202002 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 124.21      |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202002 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 1377.45     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202003 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 629.32      |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202003 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 888.99      |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202003 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 1714.14     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202004 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 276.22      |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202004 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 727.33      |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202004 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 1211.96     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202005 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 1894.24     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202005 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 1688.87     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202005 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 830.61      |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202006 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 5478.46     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202006 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 1165.63     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202006 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 8262.00     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202007 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 949.29      |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202007 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 1808.18     |
    | ILR1920        | R02                  | ORG0017397     | CM             | 202007 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 2319.28     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service




    # Check CRM and PaaS. There should be no capping

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-397       | ALLB-397           | 2               | 7455.54   | 6567.26  | 888.28   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-397       | ALLB-397           | 3               | 5796.11   | 1041.34  | 4754.77  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-397       | ALLB-397           | 4               | 6797.37   | 3308.61  | 3488.76  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 2               | 7455.54   | 0.00     | 7455.54  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 3               | 5796.11   | 0.00     | 5796.11  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 4               | 6797.37   | 0.00     | 6797.37  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 2               | 7455.54   | 0.00     | 7455.54  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 3               | 5796.11   | 0.00     | 5796.11  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 4               | 6797.37   | 0.00     | 6797.37  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




	# Consume actuals a second time. Capping occurs

    # Change the date
    Given the override date is '04/11/2019'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Oct 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R03                  | ORG0017397     | CM             | 201908 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 6567.26     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 201908 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 1041.34     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 201908 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 3308.61     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 201909 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 888.28      |
    | ILR1920        | R03                  | ORG0017397     | CM             | 201909 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 4754.77     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 201909 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 3488.76     |
    # Oct
    | ILR1920        | R03                  | ORG0017397     | CM             | 201910 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 2236.46     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 201910 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 7594.39     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 201910 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 267.52      |
    #
    | ILR1920        | R03                  | ORG0017397     | CM             | 201911 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 2157.34     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 201911 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 2310.23     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 201911 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 1634.60     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 201912 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 562.31      |
    | ILR1920        | R03                  | ORG0017397     | CM             | 201912 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 326.69      |
    | ILR1920        | R03                  | ORG0017397     | CM             | 201912 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 1641.00     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202001 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 1125.68     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202001 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 638.87      |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202001 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 247.58      |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202002 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 2026.58     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202002 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 124.21      |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202002 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 1377.45     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202003 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 629.32      |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202003 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 888.99      |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202003 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 1714.14     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202004 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 276.22      |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202004 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 727.33      |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202004 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 1211.96     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202005 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 1894.24     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202005 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 1688.87     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202005 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 830.61      |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202006 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 5478.46     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202006 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 1165.63     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202006 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 8262.00     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202007 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 949.29      |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202007 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 1808.18     |
    | ILR1920        | R03                  | ORG0017397     | CM             | 202007 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 2319.28     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


	# Check CRM. Capping occurs (27935 - 30147.39 = -2212.39)

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-397       | ALLB-397           | 2               | 9692.00   | 6567.26  | 888.28   | 2236.46  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-397       | ALLB-397           | 3               | 13390.50  | 1041.34  | 4754.77  | 7594.39  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-397       | ALLB-397           | 4               | 7064.89   | 3308.61  | 3488.76  | 267.52   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 2               | 9692.00   | 0.00     | 7455.54  | 2236.46  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 3               | 13390.50  | 0.00     | 5796.11  | 7594.39  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 4               | 7064.89   | 0.00     | 6797.37  | 267.52   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 2               | -711.26   | 0.00     | 0.00     | -711.26  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 3               | -982.67   | 0.00     | 0.00     | -982.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 4               | -518.46   | 0.00     | 0.00     | -518.46  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 2               | 8980.74   | 0.00     | 7455.54  | 1525.20  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 3               | 12407.83  | 0.00     | 5796.11  | 6611.72  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 4               | 6546.43   | 0.00     | 6797.37  | -250.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




	# Amend the contract increasing the profile values from £27935 to £36593 . Recalc occurs, releasing cap

    # Change the date
    Given the override date is '20/11/2019'

    # Bulk amendment
    And   there are no files prefixed '10017397' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 18022020103039 v3_A397' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 1920 18022020103039 v3_A397' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 18022020103039 v3_A397' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 18022020103039 v3_A397' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 18022020103039 v3_A397.xlsx' exists in the Datafiles folder and UKPRN '10017397' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
	   	 
   #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-397' is in a state of 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-397'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-397' and actual ContractNumber 'EDSK-397'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-397' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017397 | EDSK-397           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017397 | EDSK-397           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017397 | ESFA-397           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'EDSK-397'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | ALLB-397      | 2303800          | Jul-20 | Reconciliation |


	# Check CRM 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-397       | ALLB-397           | 2               | 9692.00   | 6567.26  | 888.28   | 2236.46  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-397       | ALLB-397           | 3               | 13390.50  | 1041.34  | 4754.77  | 7594.39  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-397       | ALLB-397           | 4               | 7064.89   | 3308.61  | 3488.76  | 267.52   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 2               | 10403.26  | 0.00     | 7455.54  | 2236.46  | 711.26   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 3               | 14373.17  | 0.00     | 5796.11  | 7594.39  | 982.67   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 4               | 7583.35   | 0.00     | 6797.37  | 267.52   | 518.46   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 2               | -711.26   | 0.00     | 0.00     | -711.26  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 3               | -982.67   | 0.00     | 0.00     | -982.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 4               | -518.46   | 0.00     | 0.00     | -518.46  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 2               | 9692.00   | 0.00     | 7455.54  | 1525.20  | 711.26   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 3               | 13390.50  | 0.00     | 5796.11  | 6611.72  | 982.67   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 4               | 7064.89   | 0.00     | 6797.37  | -250.94  | 518.46   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




	# Consume actuals. Cap re-applied as actuals are now greater than profile

    # Change the date
    Given the override date is '04/05/2020'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Apr 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R09                  | ORG0017397     | CM             | 201908 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 6567.26     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 201908 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 1041.34     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 201908 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 3308.61     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 201909 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 888.28      |
    | ILR1920        | R09                  | ORG0017397     | CM             | 201909 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 4754.77     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 201909 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 3488.76     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 201910 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 2236.46     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 201910 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 7594.39     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 201910 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 267.52      |
    | ILR1920        | R09                  | ORG0017397     | CM             | 201911 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 2157.34     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 201911 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 2310.23     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 201911 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 1634.60     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 201912 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 562.31      |
    | ILR1920        | R09                  | ORG0017397     | CM             | 201912 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 326.69      |
    | ILR1920        | R09                  | ORG0017397     | CM             | 201912 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 1641.00     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202001 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 1125.68     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202001 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 638.87      |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202001 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 247.58      |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202002 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 2026.58     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202002 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 124.21      |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202002 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 1377.45     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202003 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 629.32      |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202003 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 888.99      |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202003 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 1714.14     |
    # Apr
	| ILR1920        | R09                  | ORG0017397     | CM             | 202004 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 4276.22     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202004 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 2727.33     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202004 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 1211.96     |
    # 
	| ILR1920        | R09                  | ORG0017397     | CM             | 202005 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 1894.24     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202005 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 1688.87     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202005 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 830.61      |
	| ILR1920        | R09                  | ORG0017397     | CM             | 202006 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 5478.46     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202006 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 1165.63     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202006 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 8262.00     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202007 | ALLB1920                | ALLB-397                 | ?          | 2               | 0            | 949.29      |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202007 | ALLB1920                | ALLB-397                 | ?          | 3               | 0            | 1808.18     |
    | ILR1920        | R09                  | ORG0017397     | CM             | 202007 | ALLB1920                | ALLB-397                 | ?          | 4               | 0            | 2319.28     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


	# Check CRM 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-397       | ALLB-397           | 2               | 20469.45  | 6567.26  | 888.28   | 2236.46  | 2157.34  | 562.31   | 1125.68  | 2026.58  | 629.32   | 4276.22  | ?        | ?        | ?        | 
    | EDSK-397       | ALLB-397           | 3               | 20406.82  | 1041.34  | 4754.77  | 7594.39  | 2310.23  | 326.69   | 638.87   | 124.21   | 888.99   | 2727.33  | ?        | ?        | ?        | 
    | EDSK-397       | ALLB-397           | 4               | 14891.62  | 3308.61  | 3488.76  | 267.52   | 1634.60  | 1641.00  | 247.58   | 1377.45  | 1714.14  | 1211.96  | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 2               | 21180.71  | 0.00     | 7455.54  | 2236.46  | 711.26   | 0.00     | 0.00     | 0.00     | 0.00     | 10777.45 | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 3               | 21389.49  | 0.00     | 5796.11  | 7594.39  | 982.67   | 0.00     | 0.00     | 0.00     | 0.00     | 7016.32  | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 4               | 15410.08  | 0.00     | 6797.37  | 267.52   | 518.46   | 0.00     | 0.00     | 0.00     | 0.00     | 7826.73  | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 2               | -7749.35  | 0.00     | 0.00     | -711.26  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7038.09 | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 3               | -7999.23  | 0.00     | 0.00     | -982.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7016.56 | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 4               | -5638.70  | 0.00     | 0.00     | -518.46  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -5120.24 | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-397       | ALLB-397           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 2               | 13431.36  | 0.00     | 7455.54  | 1525.20  | 711.26   | 0.00     | 0.00     | 0.00     | 0.00     | 3739.36  | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 3               | 13390.26  | 0.00     | 5796.11  | 6611.72  | 982.67   | 0.00     | 0.00     | 0.00     | 0.00     | -0.24    | 0.00     | 0.00     | 0.00     | 
    | EDSK-397       | ALLB-397           | 4               | 9771.38   | 0.00     | 6797.37  | -250.94  | 518.46   | 0.00     | 0.00     | 0.00     | 0.00     | 2706.49  | 0.00     | 0.00     | 0.00     | 


    # Tidy up
    Then  the override date is reset

	 