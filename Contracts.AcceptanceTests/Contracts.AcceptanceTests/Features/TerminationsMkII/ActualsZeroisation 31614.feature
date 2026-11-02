Feature: ActualsZeroisation 31614

@AcceptanceTest @Withdrawn20240313
Scenario: A267 Create and approve an NCS-C20201 contract. Consume actuals. Initiate backdated termination then approve initiation. Check actuals after the termination date are zeroised. Check ADP feed for actuals updated event
    Given there are no allocations marked as Under Termination for UKPRN '10017267' 
    And   there are no terminated or closed allocations for UKPRN '10017267' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017267' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017267' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NCSC-267      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | NCSC-267      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | NCS-C2021         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | NCS-267        | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017267'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017267' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017267 Co Ltd' with UKPRN '10017267' and OrgId 'ORG0017267' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017267' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017267 | 117267 | 10017267 Co Ltd | 0              | Active                | Yes           | AA017267      | ?             | 116a High Street       | ?                      | ?                      | ?                      | Hoddesdon              | Hertfordshire          | EN11 8HD  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017267 |




    # Change the date
    Given the override date is '01/03/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017267 | 10017267 Co Ltd      | ESFA-267             | NCS-267        | 1                     | 01/04/2020        | 30/03/2021      | 77741.00      | North East and Cumbria                | Contract for Services                      | 2021   | New          | ORG0017267 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017267 | NCS-267        | NCSC-267      | NCS-C             | NCS-C2021               | FY                      | 01/04/2020          | 30/03/2021        | 77741.00        | North East and Cumbria                  | 0000000106 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017267 | NCS-267        | NCSC-267      | 1               | 0                     | 77741.00  | 3320.00  | 6314.00  | 6468.00  | 5258.00  | 6923.00  | 6380.00  | 6275.00  | 6586.00  | 8603.00  | 8973.00  | 6878.00  | 5763.00  | Total In The Community Funding                                  | New          |             | 
    | 10017267 | NCS-267        | NCSC-267      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             | 
    | 10017267 | NCS-267        | NCSC-267      | 2               | 1                     | 25184.00  | 951.00   | 2191.00  | 1188.00  | 1480.00  | 3323.00  | 2478.00  | 2295.00  | 1860.00  | 3165.00  | 2952.00  | 872.00   | 2429.00  | Customer Satisfaction                                           | New          |             | 
    | 10017267 | NCS-267        | NCSC-267      | 3               | 1                     | 52557.00  | 2369.00  | 4123.00  | 5280.00  | 3778.00  | 3600.00  | 3902.00  | 3980.00  | 4726.00  | 5438.00  | 6021.00  | 6006.00  | 3334.00  | Career Management and Jobs and Learning                         | New          |             | 
    | 10017267 | NCS-267        | NCSC-267      | 4               | 3                     | 29225.00  | 2041.00  | 2461.00  | 2185.00  | 3015.00  | 3242.00  | 594.00   | 2120.00  | 2224.00  | 2896.00  | 3598.00  | 3227.00  | 1622.00  | Career Management                                               | New          |             | 
    | 10017267 | NCS-267        | NCSC-267      | 5               | 3                     | 23332.00  | 328.00   | 1662.00  | 3095.00  | 763.00   | 358.00   | 3308.00  | 1860.00  | 2502.00  | 2542.00  | 2423.00  | 2779.00  | 1712.00  | Jobs and Learning                                               | New          |             | 

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | 
    | 10017267 | NCS-267        | NCSC-267      | 6               | 0        | 593     | 48       | 31       | 15       | 39       | 57       | 27       | 26       | 95       | 71       | 28       | 67       | 89       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NCS-267' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NCS-267'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-267' and actual ContractNumber 'NCS-267'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-267' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017267 | NCS-267            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2020        | 30/03/2021      | ?             |
    | 10017267 | ESFA-267           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2020        | 30/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'NCS-267'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | NCSC-267        | 2305310          | Mar-21 | Reconciliation |




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/10/2020'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017267'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202004 | NCS-C2021               | NCSC-267                 | 0000000106 | 2               | 0            | 6833.63     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202004 | NCS-C2021               | NCSC-267                 | 0000000106 | 4               | 0            | 1188.68     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202004 | NCS-C2021               | NCSC-267                 | 0000000106 | 5               | 0            | 539.25      |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202005 | NCS-C2021               | NCSC-267                 | 0000000106 | 2               | 0            | 2046.60     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202005 | NCS-C2021               | NCSC-267                 | 0000000106 | 4               | 0            | 2728.63     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202005 | NCS-C2021               | NCSC-267                 | 0000000106 | 5               | 0            | 1026.61     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202006 | NCS-C2021               | NCSC-267                 | 0000000106 | 2               | 0            | 4931.67     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202006 | NCS-C2021               | NCSC-267                 | 0000000106 | 4               | 0            | 7725.66     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202006 | NCS-C2021               | NCSC-267                 | 0000000106 | 5               | 0            | 6697.46     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202007 | NCS-C2021               | NCSC-267                 | 0000000106 | 2               | 0            | 8477.00     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202007 | NCS-C2021               | NCSC-267                 | 0000000106 | 4               | 0            | 6184.77     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202007 | NCS-C2021               | NCSC-267                 | 0000000106 | 5               | 0            | 1328.54     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202008 | NCS-C2021               | NCSC-267                 | 0000000106 | 2               | 0            | 2377.28     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202008 | NCS-C2021               | NCSC-267                 | 0000000106 | 4               | 0            | 6547.22     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202008 | NCS-C2021               | NCSC-267                 | 0000000106 | 5               | 0            | 2120.21     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202009 | NCS-C2021               | NCSC-267                 | 0000000106 | 2               | 0            | 2559.05     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202009 | NCS-C2021               | NCSC-267                 | 0000000106 | 4               | 0            | 5950.39     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202009 | NCS-C2021               | NCSC-267                 | 0000000106 | 5               | 0            | 1908.98     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202010 | NCS-C2021               | NCSC-267                 | 0000000106 | 2               | 0            | 7866.55     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202010 | NCS-C2021               | NCSC-267                 | 0000000106 | 4               | 0            | 1400.16     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202010 | NCS-C2021               | NCSC-267                 | 0000000106 | 5               | 0            | 1561.58     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202011 | NCS-C2021               | NCSC-267                 | 0000000106 | 2               | 0            | 2346.80     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202011 | NCS-C2021               | NCSC-267                 | 0000000106 | 4               | 0            | 1214.01     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202011 | NCS-C2021               | NCSC-267                 | 0000000106 | 5               | 0            | 1950.05     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202012 | NCS-C2021               | NCSC-267                 | 0000000106 | 2               | 0            | 2410.16     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202012 | NCS-C2021               | NCSC-267                 | 0000000106 | 4               | 0            | 2081.42     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202012 | NCS-C2021               | NCSC-267                 | 0000000106 | 5               | 0            | 2644.10     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202101 | NCS-C2021               | NCSC-267                 | 0000000106 | 2               | 0            | 932.89      |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202101 | NCS-C2021               | NCSC-267                 | 0000000106 | 4               | 0            | 817.23      |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202101 | NCS-C2021               | NCSC-267                 | 0000000106 | 5               | 0            | 668.26      |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202102 | NCS-C2021               | NCSC-267                 | 0000000106 | 2               | 0            | 734.32      |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202102 | NCS-C2021               | NCSC-267                 | 0000000106 | 4               | 0            | 2684.95     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202102 | NCS-C2021               | NCSC-267                 | 0000000106 | 5               | 0            | 1167.89     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202103 | NCS-C2021               | NCSC-267                 | 0000000106 | 2               | 0            | 1770.84     |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202103 | NCS-C2021               | NCSC-267                 | 0000000106 | 4               | 0            | 737.87      |
    | NCS2021        | N02                  | ORG0017267     | CM             | 202103 | NCS-C2021               | NCSC-267                 | 0000000106 | 5               | 0            | 2515.37     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-267        | NCSC-267           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-267        | NCSC-267           | 2               | 27225.23  | 6833.63  | 2046.60  | 4931.67  | 8477.00  | 2377.28  | 2559.05  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-267        | NCSC-267           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-267        | NCSC-267           | 4               | 30325.35  | 1188.68  | 2728.63  | 7725.66  | 6184.77  | 6547.22  | 5950.39  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-267        | NCSC-267           | 5               | 13621.05  | 539.25   | 1026.61  | 6697.46  | 1328.54  | 2120.21  | 1908.98  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-267        | NCSC-267           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-267        | NCSC-267           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 2               | 27225.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 27225.23 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 4               | 30325.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 30325.35 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 5               | 13621.05  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13621.05 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-267        | NCSC-267           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 2               | -2041.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2041.23 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-267        | NCSC-267           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 2               | 25184.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 25184.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 4               | 30325.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 30325.35 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 5               | 13621.05  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13621.05 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Apr-20    | May-20    | Jun-20    | Jul-20    | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    |
    | 10017267 | NCS-267        | NCSC-267           | 2305310                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 71171.63  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Apr-20    | May-20    | Jun-20    | Jul-20    | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    |
    | 10017267 | NCS-267        | NCSC-267           | 2305310                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | -2041.23  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 



    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '05/10/2020'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | NCS-267       | 1               | 0                  | 20/08/2020              | Removed from RoATP          | Company struck off                  |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | NCSC-267           | 31/07/2020                   | 06/08/2020                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017267 | NCS-267        | 1                     | 0                        | 20/08/2020                 | Removed from RoATP           | ?                              | 20/08/2020              | Removed from RoATP          | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017267 | NCS-267       | NCSC-267         | 1                     | 0                        | 31/07/2020                   | 31/07/2020        | 06/08/2020                      | 06/08/2020           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract 'NCS-267' for provider '10017267'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017267 - 10017267 Co Ltd     | NCS-267        | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'NCS-267' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                             | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus        |
    | 10017267 | ESFA-267           | NCS-267        | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval | FCS2 TEST             | Document Management Team  | Approved       | Approved                 |
    | 10017267 | ESFA-267           | NCS-267        | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                 | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider    |

    # Check the Workflow History comments 
    And   the workflow history on contract 'NCS-267' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Initiate Contract Termination                  | FCS8 TEST                     | Company struck off               |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017267 | NCS-267            | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 01/04/2020        | 30/03/2021      | ?             |
    | 10017267 | ESFA-267           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 30/03/2021      | ?             |




    # Approve Termination Initiation (30635)

    # Change the date - CRM ignores this
    Given the override date is '06/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task
    When the following open Task currently linked to version '1' of contract 'NCS-267' for provider '10017267' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Termination Initiation Approval  | FCS1 TEST                 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017267 | NCS-267            | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 01/04/2020        | 30/03/2021      | ?             |
    | 10017267 | ESFA-267           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 30/03/2021      | ?             |

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract 'NCS-267' for provider '10017267'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017267 - 10017267 Co Ltd     | NCS-267        | FCS1 TEST               | Contract Managers Team   | Completed       | Completed        |

    # Check the Termination details on the contract in CRM (These should not have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017267 | NCS-267        | 1                     | 0                        | 20/08/2020                 | Removed from RoATP           | ?                              | 20/08/2020              | Removed from RoATP          | ?                             |

    # Check the Termination details on the allocations in CRM (These should not have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017267 | NCS-267       | NCSC-267         | 1                     | 0                        | 31/07/2020                   | 31/07/2020        | 06/08/2020                      | 06/08/2020           |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'NCS-267' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                  | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017267 | ESFA-267           | NCS-267        | 1                     | Termination Initiation Successful           | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Initiation Approval in Progress  |
    | 10017267 | ESFA-267           | NCS-267        | 1                     | Approve Termination Initiation              | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Initiation Approval in Progress   | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Termination Initiation Approval     |
    | 10017267 | ESFA-267           | NCS-267        | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval      | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017267 | ESFA-267           | NCS-267        | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                      | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'NCS-267' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Termination Initiation Successful              | CRM Integration               | ?                                |
    | Approve Termination Initiation                 | FCS5 TEST                     | ?                                |
    | Initiate Contract Termination                  | FCS8 TEST                     | Company struck off               |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CM feed for the presence of a Contract Termination Initiation row (ItemType 4)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number 'NCS-267'
    And   the ItemType '4' event for version '1' of actual contract number 'NCS-267' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017267 | NCS-267        | 1               | 0                  | 20/08/2020              | Removed from RoATP              | NCSC-267        | 31/07/2020            | 06/08/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017267 | NCS-267        | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract NCS-267:1.0 was placed under termination      |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017267 | NCS-267        | 1               | 0                  | 20/08/2020              | Removed from RoATP              | NCSC-267        | 31/07/2020            | 06/08/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017267 | NCS-267        | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract NCS-267:1.0 was placed under termination      |




    # Termination date is in Aug-20 so the Sep-20 Actuals are zeroised and financials recalculated
    
    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-267        | NCSC-267           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-267        | NCSC-267           | 2               | 24666.18  | 6833.63  | 2046.60  | 4931.67  | 8477.00  | 2377.28  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-267        | NCSC-267           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-267        | NCSC-267           | 4               | 24374.96  | 1188.68  | 2728.63  | 7725.66  | 6184.77  | 6547.22  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-267        | NCSC-267           | 5               | 11712.07  | 539.25   | 1026.61  | 6697.46  | 1328.54  | 2120.21  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-267        | NCSC-267           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-267        | NCSC-267           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 2               | 24666.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 24666.18 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 4               | 24374.96  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 24374.96 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 5               | 11712.07  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 11712.07 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-267        | NCSC-267           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-267        | NCSC-267           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 2               | 24666.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 24666.18 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 4               | 24374.96  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 24374.96 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 5               | 11712.07  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 11712.07 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-267        | NCSC-267           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Apr-20    | May-20    | Jun-20    | Jul-20    | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    |
    | 10017267 | NCS-267        | NCSC-267           | 2305310                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 60753.21  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Apr-20    | May-20    | Jun-20    | Jul-20    | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    |
    | 10017267 | NCS-267        | NCSC-267           | 2305310                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 




    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check the ADP feed for category 4 (ActualsUpdated) events
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | AllocationNumber | ContractVersionNumber |
    | ContractAllocationActualsUpdated  | 4      | NCS-267        | NCSC-267         | 1                     |

    # Check the ADP feed event header information
    And   the Allocation Delivery feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                     | CategoryLabel                        | Title                                                                               |
    | 10017267 | NCS-267        | 1               | 0                  | ContractAllocationActualsUpdated | Contract Allocation Actuals Updated  | Actuals for Allocation NCSC-267 of Contract NCS-267: 1.0 have been updated          |

    # Check AllocationDelivery.AllocationDeliveryEntry (ADP) feed for ContractAllocationActualsUpdated information (type4 event)
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
    | AllocationDeliveryEntryCategory   | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 1               | 202004 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 1               | 202005 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 1               | 202006 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 1               | 202007 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 1               | 202008 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 1               | 202009 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 1               | 202010 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 1               | 202011 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 1               | 202012 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 1               | 202101 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 1               | 202102 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 1               | 202103 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 2               | 202004 | 6833.63     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 2               | 202005 | 2046.60     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 2               | 202006 | 4931.67     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 2               | 202007 | 8477.00     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 2               | 202008 | 2377.28     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 2               | 202009 | ?           | 0.00           | 0.00             | 24666.18              | 0.00           | 24666.18   |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 2               | 202010 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 2               | 202011 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 2               | 202012 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 2               | 202101 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 2               | 202102 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 2               | 202103 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 3               | 202004 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 3               | 202005 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 3               | 202006 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 3               | 202007 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 3               | 202008 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 3               | 202009 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 3               | 202010 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 3               | 202011 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 3               | 202012 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 3               | 202101 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 3               | 202102 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 3               | 202103 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 4               | 202004 | 1188.68     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 4               | 202005 | 2728.63     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 4               | 202006 | 7725.66     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 4               | 202007 | 6184.77     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 4               | 202008 | 6547.22     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 4               | 202009 | ?           | 0.00           | 0.00             | 24374.96              | 0.00           | 24374.96   |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 4               | 202010 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 4               | 202011 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 4               | 202012 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 4               | 202101 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 4               | 202102 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 4               | 202103 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 5               | 202004 | 539.25      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 5               | 202005 | 1026.61     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 5               | 202006 | 6697.46     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 5               | 202007 | 1328.54     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 5               | 202008 | 2120.21     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 5               | 202009 | ?           | 0.00           | 0.00             | 11712.07              | 0.00           | 11712.07   |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 5               | 202010 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 5               | 202011 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 5               | 202012 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 5               | 202101 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 5               | 202102 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 5               | 202103 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 6               | 202004 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 6               | 202005 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 6               | 202006 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 6               | 202007 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 6               | 202008 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 6               | 202009 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 6               | 202010 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 6               | 202011 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 6               | 202012 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 6               | 202101 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 6               | 202102 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-267        | 1             | NCSC-267         | 6               | 202103 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |


    # Tidy Up
    And   the override date is reset
   
@AcceptanceTest @Complete
Scenario: A268 Create and approve a Levy contract. Consume actuals. Initiate backdated termination then approve initiation. Check actuals after the termination date are not zeroised
    Given there are no allocations marked as Under Termination for UKPRN '10017268' 
    And   there are no terminated or closed allocations for UKPRN '10017268' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017268' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017268' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017268' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017268' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017268' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017268' 
 
    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS 
 
    # Clear down all subnominal data from PaaS for an FSP 
    And   there is no Subnominal data in PaaS for the following FSPs 
    | FSP            | 
    | LEVY1799       | 
    | NONLEVY2019    | 
 
 
 
 
    # Remove the provider from RoATP (ContractManagement.RoATPProvider) 
    And   there is no data on RoATP for the following providers 
    | Ukprn    | 
    | 10017268 | 
 
    # Add the provider to RoATP (ContractManagement.RoATPProvider) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017268 | 10017268 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 
 
 
 
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017268' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017268 Co Ltd' with UKPRN '10017268' and OrgId 'ORG0017268' and has 'FCS1 Test' as a manager 
 
    # Put data in the PaaS Organisation table (Organisation.Organisation) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017268 | 117268 | 10017268 Co Ltd | 0              | Active                | Yes           | AA017268      | ?             | 13 Coniston Road       | ?                      | ?                      | ?                      | Chippenham             | Wiltshire              | SN14 0PX  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017268 |

 
 
 
    # Change the date 
    Given the override date is '16/03/2020' 
 
    # Inject data into the stub to create a contract with two allocations 
   #And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation 
    And   the following Levy event data is available in the DAS agreement stub 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 62268 | INITIATED | 2019-12-15T18:03:12.2268 | 10017268   | 28268             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017268' 
    Then  there is only one Levy contract in CRM for UKPRN '10017268' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017268' for FundingType 'LEVY' and period '1799' 
 
 
 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017268 | 10017268 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017268 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017268 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017268 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017268 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017268 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017268 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017268 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    ## Check deliverable period count prior to approval 
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # Change the date 
    Given the override date is '09/04/2020' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 
 
    ## Check deliverable period count after approval 
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a Apr-20 deliverable period for each of deliverables 1 through 14 for each allocation 
    Then  the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Apr-20   | DeliverableDescription                               | 
    | 10017268 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017268 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017268 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017268 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017268 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017268 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017268 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017268 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017268 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017268 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017268 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017268 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017268 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017268 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
    # 
    | 10017268 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017268 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017268 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017268 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017268 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017268 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017268 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017268 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017268 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017268 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017268 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017268 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017268 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017268 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 
 
    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017268 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 09/04/2020        | ?               | ?             | 
    | 10017268 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
 
    # Check ALLOCATION dates in CRM 
    And   the following allocation values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | 
    | 10017268 | [ContractNo]       | 1                     | [AllocRef_LEVY]     | 09/04/2020          | ?                 | 
    | 10017268 | [ContractNo]       | 1                     | [AllocRef_NLA]      | 09/04/2020          | ?                 | 
 
 
 

    # Add PoI 'actuals' to the contract for Jun-20

    # Change the date
    Given the override date is '04/07/2020'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017268'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And  there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull DCFS PoI actuals from DC for Jun 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |            | 2               | 0            | 266.82      |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |            | 3               | 0            | 1035.56     |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |            | 4               | 0            | 1129.72     |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |            | 5               | 0            | 208.65      |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |            | 6               | 0            | 600.04      |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |            | 8               | 0            | 1203.84     |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |            | 9               | 0            | 271.11      |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |            | 10              | 0            | 1395.77     |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |            | 11              | 0            | 154.87      |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |            | 12              | 0            | 540.83      |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |            | 13              | 0            | 205.58      |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |            | 14              | 0            | 1105.98     |
    #
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |            | 2               | 0            | 1433.39     |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |            | 3               | 0            | 1427.93     |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |            | 4               | 0            | 526.48      |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |            | 5               | 0            | 1346.75     |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |            | 6               | 0            | 250.67      |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |            | 7               | 0            | 1107.24     |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |            | 9               | 0            | 844.93      |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |            | 10              | 0            | 1272.21     |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |            | 11              | 0            | 981.85      |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |            | 12              | 0            | 541.02      |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |            | 13              | 0            | 811.70      |
    | APPS           | APPS38               | ORG0017268     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |            | 14              | 0            | 1317.57     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check deliverable period count in CRM
    Then  there are '58' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 




    # Add PoI 'actuals' to the contract for Sep-20

    # Change the date
    Given the override date is '04/10/2020'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017268'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And  there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull DCFS PoI actuals from DC for Sep 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | LEVY1799                | [AllocRef_LEVY]          |            | 2               | 0            | 939.17      |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | LEVY1799                | [AllocRef_LEVY]          |            | 3               | 0            | 703.93      |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | LEVY1799                | [AllocRef_LEVY]          |            | 4               | 0            | 918.40      |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | LEVY1799                | [AllocRef_LEVY]          |            | 5               | 0            | 1311.23     |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | LEVY1799                | [AllocRef_LEVY]          |            | 6               | 0            | 1136.51     |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | LEVY1799                | [AllocRef_LEVY]          |            | 8               | 0            | 311.85      |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | LEVY1799                | [AllocRef_LEVY]          |            | 9               | 0            | 444.77      |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | LEVY1799                | [AllocRef_LEVY]          |            | 10              | 0            | 1031.66     |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | LEVY1799                | [AllocRef_LEVY]          |            | 11              | 0            | 426.54      |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | LEVY1799                | [AllocRef_LEVY]          |            | 12              | 0            | 437.81      |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | LEVY1799                | [AllocRef_LEVY]          |            | 13              | 0            | 828.75      |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | LEVY1799                | [AllocRef_LEVY]          |            | 14              | 0            | 744.15      |
    #
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | NONLEVY2019             | [AllocRef_NLA]           |            | 2               | 0            | 445.86      |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | NONLEVY2019             | [AllocRef_NLA]           |            | 3               | 0            | 459.49      |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | NONLEVY2019             | [AllocRef_NLA]           |            | 4               | 0            | 874.80      |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | NONLEVY2019             | [AllocRef_NLA]           |            | 5               | 0            | 622.76      |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | NONLEVY2019             | [AllocRef_NLA]           |            | 6               | 0            | 1109.79     |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | NONLEVY2019             | [AllocRef_NLA]           |            | 7               | 0            | 718.43      |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | NONLEVY2019             | [AllocRef_NLA]           |            | 9               | 0            | 695.79      |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | NONLEVY2019             | [AllocRef_NLA]           |            | 10              | 0            | 1116.35     |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | NONLEVY2019             | [AllocRef_NLA]           |            | 11              | 0            | 109.24      |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | NONLEVY2019             | [AllocRef_NLA]           |            | 12              | 0            | 1229.40     |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | NONLEVY2019             | [AllocRef_NLA]           |            | 13              | 0            | 1384.90     |
    | APPS           | APPS41               | ORG0017268     | CM             | 202009 | NONLEVY2019             | [AllocRef_NLA]           |            | 14              | 0            | 1132.97     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    ## Check deliverable period count in CRM
    #Then  there are '76' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | Jun-20   | Sep-20   |
    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 0.00      | ?        | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_NLA]     | 2               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 3               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 4               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 5               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 6               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 7               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 9               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 10              | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 11              | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 12              | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 13              | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 14              | 0.00      | ?        | 0.00     | 0.00     | 

     # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | Jun-20   | Sep-20   |
    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 1205.99   | ?        | 266.82   | 939.17   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 1739.49   | ?        | 1035.56  | 703.93   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 2048.12   | ?        | 1129.72  | 918.40   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 1519.88   | ?        | 208.65   | 1311.23  | 
    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 1736.55   | ?        | 600.04   | 1136.51  | 
    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 1515.69   | ?        | 1203.84  | 311.85   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 715.88    | ?        | 271.11   | 444.77   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 2427.43   | ?        | 1395.77  | 1031.66  | 
    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 581.41    | ?        | 154.87   | 426.54   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 978.64    | ?        | 540.83   | 437.81   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 1034.33   | ?        | 205.58   | 828.75   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 1850.13   | ?        | 1105.98  | 744.15   | 
    #
    | [ContractNo]   | [AllocRef_NLA]     | 2               | 1879.25   | ?        | 1433.39  | 445.86   | 
    | [ContractNo]   | [AllocRef_NLA]     | 3               | 1887.42   | ?        | 1427.93  | 459.49   | 
    | [ContractNo]   | [AllocRef_NLA]     | 4               | 1401.28   | ?        | 526.48   | 874.80   | 
    | [ContractNo]   | [AllocRef_NLA]     | 5               | 1969.51   | ?        | 1346.75  | 622.76   | 
    | [ContractNo]   | [AllocRef_NLA]     | 6               | 1360.46   | ?        | 250.67   | 1109.79  | 
    | [ContractNo]   | [AllocRef_NLA]     | 7               | 1825.67   | ?        | 1107.24  | 718.43   | 
    | [ContractNo]   | [AllocRef_NLA]     | 9               | 1540.72   | ?        | 844.93   | 695.79   | 
    | [ContractNo]   | [AllocRef_NLA]     | 10              | 2388.56   | ?        | 1272.21  | 1116.35  | 
    | [ContractNo]   | [AllocRef_NLA]     | 11              | 1091.09   | ?        | 981.85   | 109.24   | 
    | [ContractNo]   | [AllocRef_NLA]     | 12              | 1770.42   | ?        | 541.02   | 1229.40  | 
    | [ContractNo]   | [AllocRef_NLA]     | 13              | 2196.60   | ?        | 811.70   | 1384.90  | 
    | [ContractNo]   | [AllocRef_NLA]     | 14              | 2450.54   | ?        | 1317.57  | 1132.97  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | Jun-20   | Sep-20   |
    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 1205.99   | 0.00     | 266.82   | 939.17   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 1739.49   | 0.00     | 1035.56  | 703.93   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 2048.12   | 0.00     | 1129.72  | 918.40   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 1519.88   | 0.00     | 208.65   | 1311.23  | 
    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 1736.55   | 0.00     | 600.04   | 1136.51  | 
    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 1515.69   | 0.00     | 1203.84  | 311.85   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 715.88    | 0.00     | 271.11   | 444.77   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 2427.43   | 0.00     | 1395.77  | 1031.66  | 
    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 581.41    | 0.00     | 154.87   | 426.54   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 978.64    | 0.00     | 540.83   | 437.81   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 1034.33   | 0.00     | 205.58   | 828.75   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 1850.13   | 0.00     | 1105.98  | 744.15   | 
    #
    | [ContractNo]   | [AllocRef_NLA]     | 2               | 1879.25   | 0.00     | 1433.39  | 445.86   | 
    | [ContractNo]   | [AllocRef_NLA]     | 3               | 1887.42   | 0.00     | 1427.93  | 459.49   | 
    | [ContractNo]   | [AllocRef_NLA]     | 4               | 1401.28   | 0.00     | 526.48   | 874.80   | 
    | [ContractNo]   | [AllocRef_NLA]     | 5               | 1969.51   | 0.00     | 1346.75  | 622.76   | 
    | [ContractNo]   | [AllocRef_NLA]     | 6               | 1360.46   | 0.00     | 250.67   | 1109.79  | 
    | [ContractNo]   | [AllocRef_NLA]     | 7               | 1825.67   | 0.00     | 1107.24  | 718.43   | 
    | [ContractNo]   | [AllocRef_NLA]     | 9               | 1540.72   | 0.00     | 844.93   | 695.79   | 
    | [ContractNo]   | [AllocRef_NLA]     | 10              | 2388.56   | 0.00     | 1272.21  | 1116.35  | 
    | [ContractNo]   | [AllocRef_NLA]     | 11              | 1091.09   | 0.00     | 981.85   | 109.24   | 
    | [ContractNo]   | [AllocRef_NLA]     | 12              | 1770.42   | 0.00     | 541.02   | 1229.40  | 
    | [ContractNo]   | [AllocRef_NLA]     | 13              | 2196.60   | 0.00     | 811.70   | 1384.90  | 
    | [ContractNo]   | [AllocRef_NLA]     | 14              | 2450.54   | 0.00     | 1317.57  | 1132.97  | 




    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '04/10/2020'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | [ContractNo]  | 1               | 0                  | 28/08/2020              | Other                       | ?                                   |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | [AllocRef_LEVY]    | 07/08/2020                   | 14/08/2020                      |
    | [AllocRef_NLA]     | 08/08/2020                   | 15/08/2020                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017268 | [ContractNo]   | 1                     | 0                        | 28/08/2020                 | Other                        | ?                              | 28/08/2020              | Other                       | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017268 | [ContractNo]  | [AllocRef_LEVY]  | 1                     | 0                        | 07/08/2020                   | 07/08/2020        | 14/08/2020                      | 14/08/2020           |
    | 10017268 | [ContractNo]  | [AllocRef_NLA]   | 1                     | 0                        | 08/08/2020                   | 08/08/2020        | 15/08/2020                      | 15/08/2020           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017268'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017268 - 10017268 Co Ltd     | [ContractNo]   | Contract Managers Team  | ?                        | Open            | Not Started      |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017268 | [MasterContractNo] | [ContractNo]   | 1                     | Initiate Contract Termination               | FCS8 TEST                     | ?                | Contract Managers Team      | Approved          | Awaiting Termination Initiation Approval     | ?                     | CRM Integration           | Approved       | Approved                                     |
    | 10017268 | [MasterContractNo] | [ContractNo]   | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | ?                | CRM Integration             | Approved          | Approved                                     | ?                     | CRM Integration           | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Initiate Contract Termination                  | FCS8 TEST                     | ?                                |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017268 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017268 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |




    # Approve Termination Initiation (30635)

    # Change the date - CRM ignores this
    Given the override date is '05/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017268' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Termination Initiation Approval  | Contract Managers Team    |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017268 | [ContractNo]       | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017268 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017268'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017268 - 10017268 Co Ltd     | [ContractNo]   | Contract Managers Team  | ?                        | Completed       | Completed        |

    # Check the Termination details on the contract in CRM (These should not have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017268 | [ContractNo]   | 1                     | 0                        | 28/08/2020                 | Other                        | ?                              | 28/08/2020              | Other                       | ?                             |

    # Check the Termination details on the allocations in CRM (These should not have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017268 | [ContractNo]  | [AllocRef_LEVY]  | 1                     | 0                        | 07/08/2020                   | 07/08/2020        | 14/08/2020                      | 14/08/2020           |
    | 10017268 | [ContractNo]  | [AllocRef_NLA]   | 1                     | 0                        | 08/08/2020                   | 08/08/2020        | 15/08/2020                      | 15/08/2020           |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017268 | [MasterContractNo] | [ContractNo]   | 1                     | Termination Initiation Successful           | CRM Integration               | ?                | Contract Managers Team      | Approved          | Under Termination                            | ?                     | Contract Managers Team    | Approved       | Termination Initiation Approval in Progress  |
    | 10017268 | [MasterContractNo] | [ContractNo]   | 1                     | Approve Termination Initiation              | FCS5 TEST                     | ?                | Contract Managers Team      | Approved          | Termination Initiation Approval in Progress  | ?                     | Contract Managers Team    | Approved       | Awaiting Termination Initiation Approval     |
    | 10017268 | [MasterContractNo] | [ContractNo]   | 1                     | Initiate Contract Termination               | FCS8 TEST                     | ?                | Contract Managers Team      | Approved          | Awaiting Termination Initiation Approval     | ?                     | CRM Integration           | Approved       | Approved                                     |
    | 10017268 | [MasterContractNo] | [ContractNo]   | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | ?                | CRM Integration             | Approved          | Approved                                     | ?                     | CRM Integration           | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Termination Initiation Successful              | CRM Integration               | ?                                |
    | Approve Termination Initiation                 | FCS5 TEST                     | ?                                |
    | Initiate Contract Termination                  | FCS8 TEST                     | ?                                |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CM feed for the presence of a Contract Termination Initiation row (ItemType 4)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number '[ContractNo]'
    And   the ItemType '4' event for version '1' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017268 | [ContractNo]   | 1               | 0                  | 28/08/2020              | Other                           | [AllocRef_LEVY] | 07/08/2020            | 14/08/2020                |
    | 10017268 | [ContractNo]   | 1               | 0                  | 28/08/2020              | Other                           | [AllocRef_NLA]  | 08/08/2020            | 15/08/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017268 | [ContractNo]   | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract [ContractNo]:1.0 was placed under termination |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017268 | [ContractNo]   | 1               | 0                  | 28/08/2020              | Other                           | [AllocRef_LEVY] | 07/08/2020            | 14/08/2020                |
    | 10017268 | [ContractNo]   | 1               | 0                  | 28/08/2020              | Other                           | [AllocRef_NLA]  | 08/08/2020            | 15/08/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017268 | [ContractNo]   | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract [ContractNo]:1.0 was placed under termination |




    # Financials should NOT have changed, ie zeroisation has not occurred

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | Jun-20   | Sep-20   |
    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 0.00      | ?        | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_NLA]     | 2               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 3               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 4               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 5               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 6               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 7               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 9               | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 10              | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 11              | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 12              | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 13              | 0.00      | ?        | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 14              | 0.00      | ?        | 0.00     | 0.00     | 

     # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | Jun-20   | Sep-20   |
    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 1205.99   | ?        | 266.82   | 939.17   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 1739.49   | ?        | 1035.56  | 703.93   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 2048.12   | ?        | 1129.72  | 918.40   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 1519.88   | ?        | 208.65   | 1311.23  | 
    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 1736.55   | ?        | 600.04   | 1136.51  | 
    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 1515.69   | ?        | 1203.84  | 311.85   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 715.88    | ?        | 271.11   | 444.77   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 2427.43   | ?        | 1395.77  | 1031.66  | 
    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 581.41    | ?        | 154.87   | 426.54   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 978.64    | ?        | 540.83   | 437.81   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 1034.33   | ?        | 205.58   | 828.75   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 1850.13   | ?        | 1105.98  | 744.15   | 
    #
    | [ContractNo]   | [AllocRef_NLA]     | 2               | 1879.25   | ?        | 1433.39  | 445.86   | 
    | [ContractNo]   | [AllocRef_NLA]     | 3               | 1887.42   | ?        | 1427.93  | 459.49   | 
    | [ContractNo]   | [AllocRef_NLA]     | 4               | 1401.28   | ?        | 526.48   | 874.80   | 
    | [ContractNo]   | [AllocRef_NLA]     | 5               | 1969.51   | ?        | 1346.75  | 622.76   | 
    | [ContractNo]   | [AllocRef_NLA]     | 6               | 1360.46   | ?        | 250.67   | 1109.79  | 
    | [ContractNo]   | [AllocRef_NLA]     | 7               | 1825.67   | ?        | 1107.24  | 718.43   | 
    | [ContractNo]   | [AllocRef_NLA]     | 9               | 1540.72   | ?        | 844.93   | 695.79   | 
    | [ContractNo]   | [AllocRef_NLA]     | 10              | 2388.56   | ?        | 1272.21  | 1116.35  | 
    | [ContractNo]   | [AllocRef_NLA]     | 11              | 1091.09   | ?        | 981.85   | 109.24   | 
    | [ContractNo]   | [AllocRef_NLA]     | 12              | 1770.42   | ?        | 541.02   | 1229.40  | 
    | [ContractNo]   | [AllocRef_NLA]     | 13              | 2196.60   | ?        | 811.70   | 1384.90  | 
    | [ContractNo]   | [AllocRef_NLA]     | 14              | 2450.54   | ?        | 1317.57  | 1132.97  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | Jun-20   | Sep-20   |
    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 1205.99   | 0.00     | 266.82   | 939.17   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 1739.49   | 0.00     | 1035.56  | 703.93   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 2048.12   | 0.00     | 1129.72  | 918.40   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 1519.88   | 0.00     | 208.65   | 1311.23  | 
    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 1736.55   | 0.00     | 600.04   | 1136.51  | 
    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 1515.69   | 0.00     | 1203.84  | 311.85   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 715.88    | 0.00     | 271.11   | 444.77   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 2427.43   | 0.00     | 1395.77  | 1031.66  | 
    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 581.41    | 0.00     | 154.87   | 426.54   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 978.64    | 0.00     | 540.83   | 437.81   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 1034.33   | 0.00     | 205.58   | 828.75   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 1850.13   | 0.00     | 1105.98  | 744.15   | 
    #
    | [ContractNo]   | [AllocRef_NLA]     | 2               | 1879.25   | 0.00     | 1433.39  | 445.86   | 
    | [ContractNo]   | [AllocRef_NLA]     | 3               | 1887.42   | 0.00     | 1427.93  | 459.49   | 
    | [ContractNo]   | [AllocRef_NLA]     | 4               | 1401.28   | 0.00     | 526.48   | 874.80   | 
    | [ContractNo]   | [AllocRef_NLA]     | 5               | 1969.51   | 0.00     | 1346.75  | 622.76   | 
    | [ContractNo]   | [AllocRef_NLA]     | 6               | 1360.46   | 0.00     | 250.67   | 1109.79  | 
    | [ContractNo]   | [AllocRef_NLA]     | 7               | 1825.67   | 0.00     | 1107.24  | 718.43   | 
    | [ContractNo]   | [AllocRef_NLA]     | 9               | 1540.72   | 0.00     | 844.93   | 695.79   | 
    | [ContractNo]   | [AllocRef_NLA]     | 10              | 2388.56   | 0.00     | 1272.21  | 1116.35  | 
    | [ContractNo]   | [AllocRef_NLA]     | 11              | 1091.09   | 0.00     | 981.85   | 109.24   | 
    | [ContractNo]   | [AllocRef_NLA]     | 12              | 1770.42   | 0.00     | 541.02   | 1229.40  | 
    | [ContractNo]   | [AllocRef_NLA]     | 13              | 2196.60   | 0.00     | 811.70   | 1384.90  | 
    | [ContractNo]   | [AllocRef_NLA]     | 14              | 2450.54   | 0.00     | 1317.57  | 1132.97  | 


    # Tidy Up
    And   the override date is reset
 
@AcceptanceTest @Withdrawn20231002
Scenario: A269 Create and approve a 2-alloc 2021 AEBP contract. Consume actuals. Initiate backdated termination with different dates for each alloc then approve initiation. Check actuals after the termination date have been zeroised. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017269' 
    And   there are no terminated or closed allocations for UKPRN '10017269' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017269' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017269' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-269      |
    | AEBR-269      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-269      |
    | AEBR-269      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-19TRN2021     |
    | AEB-AS2021        |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-269       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017269'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017269' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017269 Co Ltd' with UKPRN '10017269' and OrgId 'ORG0017269' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017269' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017269 | 117269 | 10017269 Co Ltd | 0              | Provider Under Change | Yes           | AA017269      | ?             | 49 Fife Road           | Kingston               | ?                      | ?                      | ?                      | Surrey                 | KT1 1SF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017269 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017269 | 10017269 Co Ltd      | ESFA-269             | AEBP-269       | 1                     | 01/08/2020        | 31/07/2021      | 45431.00      |                                       | Procured                                   | 2021   | New          | ORG0017269 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017269 | AEBP-269       | AEBA-269      | AEB-AS            | AEB-AS2021              | AY                      | 01/08/2020          | 31/07/2021        | 25652.00        |                                         |            |                                                             | New          |             |
    | 10017269 | AEBP-269       | AEBR-269      | AEB-19TRN         | AEB-19TRN2021           | AY                      | 01/08/2020          | 31/07/2021        | 19779.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017269 | AEBP-269       | AEBA-269      | 1               | 0                     | 25652.00  | 19062.00  | 6590.00   | 2702.00  | 3186.00  | 3699.00  | 2158.00  | 3082.00  | 3027.00  | 473.00   | 735.00   | 932.00   | 339.00   | 2118.00  | 3201.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017269 | AEBP-269       | AEBR-269      | 1               | 0                     | 19779.00  | 13990.00  | 5789.00   | 53.00    | 2622.00  | 1333.00  | 1500.00  | 2963.00  | 1293.00  | 1619.00  | 2607.00  | 2360.00  | 1135.00  | 2093.00  | 201.00   | 19-24 Traineeships Total Funding                                | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP-269       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-269' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-269'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-269' and actual ContractNumber 'AEBP-269'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-269' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017269 | AEBP-269           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017269 | ESFA-269           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'AEBP-269'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBR-269        | 2355800          | Jul-21 | Reconciliation |
    | AEBA-269        | 2372010          | Jul-21 | Reconciliation |




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/01/2021'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017269'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Dec 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202008 | AEB-19TRN2021           | AEBR-269                 | ?          | 2               | 0            | 2462.27     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202008 | AEB-19TRN2021           | AEBR-269                 | ?          | 3               | 0            | 1626.88     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202009 | AEB-19TRN2021           | AEBR-269                 | ?          | 2               | 0            | 1045.11     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202009 | AEB-19TRN2021           | AEBR-269                 | ?          | 3               | 0            | 1097.99     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202010 | AEB-19TRN2021           | AEBR-269                 | ?          | 2               | 0            | 485.33      |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202010 | AEB-19TRN2021           | AEBR-269                 | ?          | 3               | 0            | 2279.08     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202011 | AEB-19TRN2021           | AEBR-269                 | ?          | 2               | 0            | 2149.25     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202011 | AEB-19TRN2021           | AEBR-269                 | ?          | 3               | 0            | 828.27      |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202012 | AEB-19TRN2021           | AEBR-269                 | ?          | 2               | 0            | 1391.39     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202012 | AEB-19TRN2021           | AEBR-269                 | ?          | 3               | 0            | 1895.21     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202101 | AEB-19TRN2021           | AEBR-269                 | ?          | 2               | 0            | 1022.95     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202101 | AEB-19TRN2021           | AEBR-269                 | ?          | 3               | 0            | 1065.87     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202102 | AEB-19TRN2021           | AEBR-269                 | ?          | 2               | 0            | 2227.44     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202102 | AEB-19TRN2021           | AEBR-269                 | ?          | 3               | 0            | 1565.50     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202103 | AEB-19TRN2021           | AEBR-269                 | ?          | 2               | 0            | 2301.75     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202103 | AEB-19TRN2021           | AEBR-269                 | ?          | 3               | 0            | 1085.45     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202104 | AEB-19TRN2021           | AEBR-269                 | ?          | 2               | 0            | 1625.74     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202104 | AEB-19TRN2021           | AEBR-269                 | ?          | 3               | 0            | 1324.43     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202105 | AEB-19TRN2021           | AEBR-269                 | ?          | 2               | 0            | 1288.46     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202105 | AEB-19TRN2021           | AEBR-269                 | ?          | 3               | 0            | 1459.83     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202106 | AEB-19TRN2021           | AEBR-269                 | ?          | 2               | 0            | 624.11      |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202106 | AEB-19TRN2021           | AEBR-269                 | ?          | 3               | 0            | 2389.79     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202107 | AEB-19TRN2021           | AEBR-269                 | ?          | 2               | 0            | 2335.99     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202107 | AEB-19TRN2021           | AEBR-269                 | ?          | 3               | 0            | 811.52      |
    #
    | ILR2021        | R05                  | ORG0017269     | CM             | 202008 | AEB-AS2021              | AEBA-269                 | ?          | 2               | 0            | 1911.27     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202008 | AEB-AS2021              | AEBA-269                 | ?          | 3               | 0            | 1026.70     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202009 | AEB-AS2021              | AEBA-269                 | ?          | 2               | 0            | 1555.15     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202009 | AEB-AS2021              | AEBA-269                 | ?          | 3               | 0            | 1489.30     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202010 | AEB-AS2021              | AEBA-269                 | ?          | 2               | 0            | 1197.08     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202010 | AEB-AS2021              | AEBA-269                 | ?          | 3               | 0            | 1836.75     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202011 | AEB-AS2021              | AEBA-269                 | ?          | 2               | 0            | 1547.50     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202011 | AEB-AS2021              | AEBA-269                 | ?          | 3               | 0            | 1069.79     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202012 | AEB-AS2021              | AEBA-269                 | ?          | 2               | 0            | 2207.98     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202012 | AEB-AS2021              | AEBA-269                 | ?          | 3               | 0            | 2171.98     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202101 | AEB-AS2021              | AEBA-269                 | ?          | 2               | 0            | 1463.11     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202101 | AEB-AS2021              | AEBA-269                 | ?          | 3               | 0            | 1184.01     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202102 | AEB-AS2021              | AEBA-269                 | ?          | 2               | 0            | 707.14      |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202102 | AEB-AS2021              | AEBA-269                 | ?          | 3               | 0            | 2274.01     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202103 | AEB-AS2021              | AEBA-269                 | ?          | 2               | 0            | 2283.42     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202103 | AEB-AS2021              | AEBA-269                 | ?          | 3               | 0            | 2168.93     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202104 | AEB-AS2021              | AEBA-269                 | ?          | 2               | 0            | 539.93      |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202104 | AEB-AS2021              | AEBA-269                 | ?          | 3               | 0            | 1238.05     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202105 | AEB-AS2021              | AEBA-269                 | ?          | 2               | 0            | 2129.00     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202105 | AEB-AS2021              | AEBA-269                 | ?          | 3               | 0            | 2444.02     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202106 | AEB-AS2021              | AEBA-269                 | ?          | 2               | 0            | 804.14      |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202106 | AEB-AS2021              | AEBA-269                 | ?          | 3               | 0            | 1902.01     |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202107 | AEB-AS2021              | AEBA-269                 | ?          | 2               | 0            | 492.42      |
    | ILR2021        | R05                  | ORG0017269     | CM             | 202107 | AEB-AS2021              | AEBA-269                 | ?          | 3               | 0            | 512.85      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



    # Check CRM financials

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-269       | AEBA-269           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-269       | AEBA-269           | 2               | 8418.98   | 1911.27  | 1555.15  | 1197.08  | 1547.50  | 2207.98  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-269       | AEBA-269           | 3               | 7594.52   | 1026.70  | 1489.30  | 1836.75  | 1069.79  | 2171.98  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | AEBP-269       | AEBR-269           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-269       | AEBR-269           | 2               | 7533.35   | 2462.27  | 1045.11  | 485.33   | 2149.25  | 1391.39  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-269       | AEBR-269           | 3               | 7727.43   | 1626.88  | 1097.99  | 2279.08  | 828.27   | 1895.21  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 
    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-269       | AEBA-269           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-269       | AEBA-269           | 2               | 8418.98   | 0.00     | 0.00     | 0.00     | 0.00     | 8418.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-269       | AEBA-269           | 3               | 7594.52   | 0.00     | 0.00     | 0.00     | 0.00     | 7594.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-269       | AEBR-269           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-269       | AEBR-269           | 2               | 7533.35   | 0.00     | 0.00     | 0.00     | 0.00     | 7533.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-269       | AEBR-269           | 3               | 7727.43   | 0.00     | 0.00     | 0.00     | 0.00     | 7727.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-269       | AEBA-269           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-269       | AEBA-269           | 2               | 8418.98   | 0.00     | 0.00     | 0.00     | 0.00     | 8418.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-269       | AEBA-269           | 3               | 7594.52   | 0.00     | 0.00     | 0.00     | 0.00     | 7594.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-269       | AEBR-269           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-269       | AEBR-269           | 2               | 7533.35   | 0.00     | 0.00     | 0.00     | 0.00     | 7533.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-269       | AEBR-269           | 3               | 7727.43   | 0.00     | 0.00     | 0.00     | 0.00     | 7727.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '08/01/2021'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | AEBP-269      | 1               | 0                  | 08/10/2020              | Deactivated UKPRN           | Police involvement                  |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | AEBA-269           | 28/08/2020                   | 29/08/2020                      |
    | AEBR-269           | 29/09/2020                   | 30/09/2020                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017269 | AEBP-269       | 1                     | 0                        | 08/10/2020                 | Deactivated UKPRN            | ?                              | 08/10/2020              | Deactivated UKPRN           | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017269 | AEBP-269      | AEBA-269         | 1                     | 0                        | 28/08/2020                   | 28/08/2020        | 29/08/2020                      | 29/08/2020           |
    | 10017269 | AEBP-269      | AEBR-269         | 1                     | 0                        | 29/09/2020                   | 29/09/2020        | 30/09/2020                      | 30/09/2020           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract 'AEBP-269' for provider '10017269'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017269 - 10017269 Co Ltd     | AEBP-269       | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'AEBP-269' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                             | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus        |
    | 10017269 | ESFA-269           | AEBP-269       | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval | FCS2 TEST             | Document Management Team  | Approved       | Approved                 |
    | 10017269 | ESFA-269           | AEBP-269       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                 | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider    |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-269' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Initiate Contract Termination                  | FCS8 TEST                     | Police involvement               |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017269 | AEBP-269           | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017269 | ESFA-269           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |




    # Approve Termination Initiation (30635)

    # Change the date - CRM ignores this
    Given the override date is '09/01/2021'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task
    When the following open Task currently linked to version '1' of contract 'AEBP-269' for provider '10017269' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Termination Initiation Approval  | FCS1 TEST                 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017269 | AEBP-269           | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017269 | ESFA-269           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-269' for provider '10017269'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017269 - 10017269 Co Ltd     | AEBP-269       | FCS1 TEST               | Contract Managers Team   | Completed       | Completed        |

    # Check the Termination details on the contract in CRM (These should not have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017269 | AEBP-269       | 1                     | 0                        | 08/10/2020                 | Deactivated UKPRN            | ?                              | 08/10/2020              | Deactivated UKPRN           | ?                             |

    # Check the Termination details on the allocations in CRM (These should not have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017269 | AEBP-269      | AEBA-269         | 1                     | 0                        | 28/08/2020                   | 28/08/2020        | 29/08/2020                      | 29/08/2020           |
    | 10017269 | AEBP-269      | AEBR-269         | 1                     | 0                        | 29/09/2020                   | 29/09/2020        | 30/09/2020                      | 30/09/2020           |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'AEBP-269' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                  | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017269 | ESFA-269           | AEBP-269       | 1                     | Termination Initiation Successful           | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Initiation Approval in Progress  |
    | 10017269 | ESFA-269           | AEBP-269       | 1                     | Approve Termination Initiation              | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Initiation Approval in Progress   | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Termination Initiation Approval     |
    | 10017269 | ESFA-269           | AEBP-269       | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval      | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017269 | ESFA-269           | AEBP-269       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                      | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-269' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Termination Initiation Successful              | CRM Integration               | ?                                |
    | Approve Termination Initiation                 | FCS5 TEST                     | ?                                |
    | Initiate Contract Termination                  | FCS8 TEST                     | Police involvement               |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CM feed for the presence of a Contract Termination Initiation row (ItemType 4)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number 'AEBP-269'
    And   the ItemType '4' event for version '1' of actual contract number 'AEBP-269' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017269 | AEBP-269       | 1               | 0                  | 08/10/2020              | Deactivated UKPRN               | AEBA-269        | 28/08/2020            | 29/08/2020                |
    | 10017269 | AEBP-269       | 1               | 0                  | 08/10/2020              | Deactivated UKPRN               | AEBR-269        | 29/09/2020            | 30/09/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017269 | AEBP-269       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract AEBP-269:1.0 was placed under termination     |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017269 | AEBP-269       | 1               | 0                  | 08/10/2020              | Deactivated UKPRN               | AEBA-269        | 28/08/2020            | 29/08/2020                |
    | 10017269 | AEBP-269       | 1               | 0                  | 08/10/2020              | Deactivated UKPRN               | AEBR-269        | 29/09/2020            | 30/09/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017269 | AEBP-269       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract AEBP-269:1.0 was placed under termination     |




    # Check CRM financials

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-269       | AEBA-269           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-269       | AEBA-269           | 2               | 1911.27   | 1911.27  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-269       | AEBA-269           | 3               | 1026.70   | 1026.70  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | AEBP-269       | AEBR-269           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-269       | AEBR-269           | 2               | 3507.38   | 2462.27  | 1045.11  | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-269       | AEBR-269           | 3               | 2724.87   | 1626.88  | 1097.99  | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-269       | AEBA-269           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-269       | AEBA-269           | 2               | 1911.27   | 0.00     | 0.00     | 0.00     | 0.00     | 1911.27  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-269       | AEBA-269           | 3               | 1026.70   | 0.00     | 0.00     | 0.00     | 0.00     | 1026.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-269       | AEBR-269           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-269       | AEBR-269           | 2               | 3507.38   | 0.00     | 0.00     | 0.00     | 0.00     | 3507.38  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-269       | AEBR-269           | 3               | 2724.87   | 0.00     | 0.00     | 0.00     | 0.00     | 2724.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-269       | AEBA-269           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-269       | AEBA-269           | 2               | 1911.27   | 0.00     | 0.00     | 0.00     | 0.00     | 1911.27  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-269       | AEBA-269           | 3               | 1026.70   | 0.00     | 0.00     | 0.00     | 0.00     | 1026.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-269       | AEBR-269           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-269       | AEBR-269           | 2               | 3507.38   | 0.00     | 0.00     | 0.00     | 0.00     | 3507.38  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-269       | AEBR-269           | 3               | 2724.87   | 0.00     | 0.00     | 0.00     | 0.00     | 2724.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Tidy Up
    And   the override date is reset 
       