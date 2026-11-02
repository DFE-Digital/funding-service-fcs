Feature: NCS-C2021Capping 24495

@AcceptanceTest @Withdrawn20211216
@Long2Run @Long2Run45
Scenario: A525 OPA Rewrite. Create and approve an NCS-C2021 contract\allocation. Consume actuals 2x. Amend and approve. Consume actuals 2x. Check CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017525' 
    And   there are no terminated or closed allocations for UKPRN '10017525' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017525' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017525' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NCSC-525      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | NCSC-525      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | NCS-C2021         |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017525' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017525 Co Ltd' with UKPRN '10017525' and OrgId 'ORG0017525' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017525' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017525 | 117525 | 10017525 Co Ltd | 0              | Active                | Yes           | AA017525      | ?             | 39a Victoria Road      | Surbiton               | Surrey                 | ?                      | ?                      | ?                      | KT6 4JL   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017525 |




    # Change the date
    Given the override date is '01/03/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017525 | 10017525 Co Ltd      | ESFA-525             | NCS-525        | 1                     | 01/04/2020        | 31/03/2021      | 60949.00      | North West                            | Contract for Services                      | 2021   | New          | ORG0017525 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017525 | NCS-525        | NCSC-525      | NCS-C             | NCS-C2021               | FY                      | 01/04/2020          | 31/03/2021        | 60949.00        | North West                              | 0000000105 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017525 | NCS-525        | NCSC-525      | 1               | 0                     | 60949.00  | 7907.00  | 4359.00  | 6851.00  | 4815.00  | 4271.00  | 4167.00  | 4478.00  | 2793.00  | 3164.00  | 4770.00  | 7354.00  | 6020.00  | Total In The Community Funding                                  | New          |             | 
    | 10017525 | NCS-525        | NCSC-525      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             | 
    | 10017525 | NCS-525        | NCSC-525      | 2               | 1                     | 20272.00  | 3672.00  | 2669.00  | 2961.00  | 1103.00  | 257.00   | 75.00    | 3341.00  | 944.00   | 732.00   | 2353.00  | 208.00   | 1957.00  | Customer Satisfaction                                           | New          |             | 
    | 10017525 | NCS-525        | NCSC-525      | 3               | 1                     | 40677.00  | 4235.00  | 1690.00  | 3890.00  | 3712.00  | 4014.00  | 4092.00  | 1137.00  | 1849.00  | 2432.00  | 2417.00  | 7146.00  | 4063.00  | Career Management and Jobs and Learning                         | New          |             | 
    | 10017525 | NCS-525        | NCSC-525      | 4               | 3                     | 16346.00  | 713.00   | 436.00   | 1267.00  | 1494.00  | 2547.00  | 372.00   | 476.00   | 1148.00  | 1850.00  | 1479.00  | 3574.00  | 990.00   | Career Management                                               | New          |             | 
    | 10017525 | NCS-525        | NCSC-525      | 5               | 3                     | 24331.00  | 3522.00  | 1254.00  | 2623.00  | 2218.00  | 1467.00  | 3720.00  | 661.00   | 701.00   | 582.00   | 938.00   | 3572.00  | 3073.00  | Jobs and Learning                                               | New          |             | 

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | 
    | 10017525 | NCS-525        | NCSC-525      | 6               | 0        | 567     | 38       | 22       | 47       | 65       | 35       | 34       | 12       | 79       | 35       | 74       | 96       | 30       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/03/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NCS-525' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NCS-525'

    # Change the date
    Given the override date is '11/03/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-525' and actual ContractNumber 'NCS-525'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-525' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017525 | NCS-525            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017525 | ESFA-525           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'NCS-525'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | NCSC-525      | 2305310          | Mar-21 | Reconciliation |




    # Add actuals to the contract
	
	# Change the date
    Given the override date is '04/06/2020'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for May 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202004 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2655.77     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202004 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 1924.76     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202004 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2092.23     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202005 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1197.73     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202005 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 1463.73     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202005 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2599.50     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202006 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2447.19     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202006 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 470.33      |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202006 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 908.49      |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202007 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1552.48     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202007 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 501.41      |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202007 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 1443.17     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202008 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1658.43     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202008 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2672.39     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202008 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 1407.60     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202009 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2601.95     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202009 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 925.14      |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202009 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 1818.12     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202010 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2207.77     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202010 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 1464.31     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202010 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 1124.44     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202011 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2236.00     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202011 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 781.75      |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202011 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2234.53     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202012 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 712.29      |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202012 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 651.91      |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202012 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 770.60      |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202101 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1033.18     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202101 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 1695.72     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202101 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 1538.54     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202102 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 975.05      |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202102 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 1601.83     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202102 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 1618.75     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202103 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2057.52     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202103 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 1428.94     |
    | NCS2021        | N10                  | ORG0017525     | CM             | 202103 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 1682.74     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


    # Check CRM 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-525        | NCSC-525           | 2               | 3853.50   | 2655.77  | 1197.73  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-525        | NCSC-525           | 4               | 3388.49   | 1924.76  | 1463.73  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-525        | NCSC-525           | 5               | 4691.73   | 2092.23  | 2599.50  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 2               | 3853.50   | 0.00     | 3853.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 4               | 3388.49   | 0.00     | 3388.49  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 5               | 4691.73   | 0.00     | 4691.73  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 2               | 3853.50   | 0.00     | 3853.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 4               | 3388.49   | 0.00     | 3388.49  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 5               | 4691.73   | 0.00     | 4691.73  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/09/2020'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Aug 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202004 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 482.64      |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202004 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 658.32      |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202004 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 7786.44     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202005 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2317.87     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202005 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 1032.52     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202005 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 9293.05     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202006 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2704.24     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202006 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 1973.66     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202006 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 8512.68     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202007 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1684.98     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202007 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 7506.23     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202007 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 9509.22     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202008 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1756.26     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202008 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 9578.43     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202008 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 8628.29     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202009 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2210.81     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202009 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2723.27     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202009 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 1737.15     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202010 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1747.93     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202010 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 639.55      |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202010 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2449.01     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202011 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1998.98     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202011 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 920.33      |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202011 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 1523.71     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202012 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 567.49      |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202012 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 1305.59     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202012 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 1889.22     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202101 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2525.81     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202101 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2509.93     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202101 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 1907.17     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202102 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2072.87     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202102 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 1184.80     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202102 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2578.12     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202103 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2642.04     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202103 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2224.97     |
    | NCS2021        | N01                  | ORG0017525     | CM             | 202103 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 1133.35     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check CRM

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-525        | NCSC-525           | 2               | 8945.99   | 482.64   | 2317.87  | 2704.24  | 1684.98  | 1756.26  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-525        | NCSC-525           | 4               | 20749.16  | 658.32   | 1032.52  | 1973.66  | 7506.23  | 9578.43  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-525        | NCSC-525           | 5               | 43729.68  | 7786.44  | 9293.05  | 8512.68  | 9509.22  | 8628.29  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 2               | 8945.99   | 0.00     | 3853.50  | 0.00     | 0.00     | 5092.49  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 4               | 20749.16  | 0.00     | 3388.49  | 0.00     | 0.00     | 17360.67 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 5               | 43729.68  | 0.00     | 4691.73  | 0.00     | 0.00     | 39037.95 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 4               | -4014.70  | 0.00     | 0.00     | 0.00     | 0.00     | -4014.70 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 5               | -8461.13  | 0.00     | 0.00     | 0.00     | 0.00     | -8461.13 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 2               | 8945.99   | 0.00     | 3853.50  | 0.00     | 0.00     | 5092.49  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 4               | 16734.46  | 0.00     | 3388.49  | 0.00     | 0.00     | 13345.97 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 5               | 35268.55  | 0.00     | 4691.73  | 0.00     | 0.00     | 30576.82 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




    # Amend the contract to change the Profile

    # Change the date
    Given the override date is '12/10/2020'

    # Bulk file
    And   there are no files prefixed '10017525' in the Sharepoint 'NCS-2021-Input-Appendices' folder
    And   there are no files prefixed 'NCS FY 2021 14042020081835 v3_A525' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NCS FY 2021 14042020081835 v3_A525' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NCS FY 2021 14042020081835 v3_A525' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NCS FY 2021 14042020081835 v3_A525' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NCS FY 2021 14042020081835 v3_A525.xlsx' exists in the Datafiles folder and UKPRN '10017525' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NCS-525'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-525' and actual ContractNumber 'NCS-525'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-525' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017525 | NCS-525            | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2020        | 31/03/2021      | Variation     |
    | 10017525 | NCS-525            | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2020        | 31/03/2021      | ?             |
    | 10017525 | ESFA-525           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'NCS-525'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | NCSC-525      | 2305310          | Mar-21 | Reconciliation |




	# Check CRM

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 2               | 8945.99   | 482.64   | 2317.87  | 2704.24  | 1684.98  | 1756.26  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 4               | 20749.16  | 658.32   | 1032.52  | 1973.66  | 7506.23  | 9578.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 5               | 43729.68  | 7786.44  | 9293.05  | 8512.68  | 9509.22  | 8628.29  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 2               | 8945.99   | 0.00     | 3853.50  | 0.00     | 0.00     | 5092.49  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 4               | 24763.86  | 0.00     | 3388.49  | 0.00     | 0.00     | 17360.67 | 0.00     | 4014.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 5               | 52190.81  | 0.00     | 4691.73  | 0.00     | 0.00     | 39037.95 | 0.00     | 8461.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 4               | -4014.70  | 0.00     | 0.00     | 0.00     | 0.00     | -4014.70 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 5               | -8461.13  | 0.00     | 0.00     | 0.00     | 0.00     | -8461.13 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 2               | 8945.99   | 0.00     | 3853.50  | 0.00     | 0.00     | 5092.49  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 4               | 20749.16  | 0.00     | 3388.49  | 0.00     | 0.00     | 13345.97 | 0.00     | 4014.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 5               | 43729.68  | 0.00     | 4691.73  | 0.00     | 0.00     | 30576.82 | 0.00     | 8461.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/01/2021'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Dec 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202004 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 8512.84     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202004 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 5180.26     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202004 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2383.14     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202005 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 6840.29     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202005 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 1027.75     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202005 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2019.87     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202006 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2086.28     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202006 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 1240.03     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202006 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 976.07      |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202007 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 4407.31     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202007 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2201.76     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202007 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2035.16     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202008 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2640.94     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202008 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 936.89      |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202008 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2115.42     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202009 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 8461.93     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202009 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 1932.36     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202009 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 5522.36     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202010 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1954.78     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202010 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2731.51     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202010 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 1635.64     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202011 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 9851.58     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202011 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2225.03     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202011 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 1922.12     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202012 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2534.79     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202012 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2016.20     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202012 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 619.89      |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202101 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1446.27     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202101 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2011.02     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202101 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 816.40      |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202102 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1607.64     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202102 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2292.97     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202102 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2416.12     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202103 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 540.53      |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202103 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2491.98     |
    | NCS2021        | N05                  | ORG0017525     | CM             | 202103 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2344.84     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


	# Check CRM

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | NCS-525        | NCSC-525           | 2               | 47290.74  | 8512.84  | 6840.29  | 2086.28  | 4407.31  | 2640.94  | 8461.93  | 1954.78  | 9851.58  | 2534.79  | ?        | ?        | ?        | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | NCS-525        | NCSC-525           | 4               | 19491.79  | 5180.26  | 1027.75  | 1240.03  | 2201.76  | 936.89   | 1932.36  | 2731.51  | 2225.03  | 2016.20  | ?        | ?        | ?        | 
    | NCS-525        | NCSC-525           | 5               | 19229.67  | 2383.14  | 2019.87  | 976.07   | 2035.16  | 2115.42  | 5522.36  | 1635.64  | 1922.12  | 619.89   | ?        | ?        | ?        | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20    | Jan-21   | Feb-21   | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 2               | 47290.74  | 0.00     | 3853.50  | 0.00     | 0.00     | 5092.49  | 0.00     | 0.00     | 0.00     | 38344.75  | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 4               | 23506.49  | 0.00     | 3388.49  | 0.00     | 0.00     | 17360.67 | 0.00     | 4014.70  | 0.00     | -1257.37  | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 5               | 27690.80  | 0.00     | 4691.73  | 0.00     | 0.00     | 39037.95 | 0.00     | 8461.13  | 0.00     | -24500.01 | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20    | Jan-21   | Feb-21   | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 2               | -11023.74 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -11023.74 | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 4               | -4014.70  | 0.00     | 0.00     | 0.00     | 0.00     | -4014.70 | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 5               | -8461.13  | 0.00     | 0.00     | 0.00     | 0.00     | -8461.13 | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20    | Jan-21   | Feb-21   | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 2               | 36267.00  | 0.00     | 3853.50  | 0.00     | 0.00     | 5092.49  | 0.00     | 0.00     | 0.00     | 27321.01  | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 4               | 19491.79  | 0.00     | 3388.49  | 0.00     | 0.00     | 13345.97 | 0.00     | 4014.70  | 0.00     | -1257.37  | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 5               | 19229.67  | 0.00     | 4691.73  | 0.00     | 0.00     | 30576.82 | 0.00     | 8461.13  | 0.00     | -24500.01 | 0.00     | 0.00     | 0.00     | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 0.00     | 
 



    # Add actuals to the contract

    # Change the date
    Given the override date is '04/03/2021'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Feb 2021
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202004 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1512.84     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202004 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 5180.26     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202004 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2383.14     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202005 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1840.29     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202005 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 1027.75     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202005 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2019.87     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202006 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2086.28     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202006 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 1240.03     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202006 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 976.07      |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202007 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1407.31     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202007 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2201.76     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202007 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2035.16     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202008 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2640.94     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202008 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 936.89      |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202008 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2115.42     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202009 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1461.93     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202009 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 1932.36     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202009 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 5522.36     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202010 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1954.78     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202010 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2731.51     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202010 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 1635.64     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202011 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1851.58     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202011 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2225.03     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202011 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 1922.12     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202012 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 2534.79     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202012 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2016.20     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202012 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 619.89      |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202101 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1446.27     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202101 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2011.02     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202101 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 816.40      |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202102 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 1607.64     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202102 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2292.97     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202102 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2416.12     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202103 | NCS-C2021               | NCSC-525                 | 0000000105 | 2               | 0            | 540.53      |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202103 | NCS-C2021               | NCSC-525                 | 0000000105 | 4               | 0            | 2491.98     |
    | NCS2021        | N07                  | ORG0017525     | CM             | 202103 | NCS-C2021               | NCSC-525                 | 0000000105 | 5               | 0            | 2344.84     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


	# Check CRM

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20    | Jan-21   | Feb-21    | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00      | ?        | 
    | NCS-525        | NCSC-525           | 2               | 20344.65  | 1512.84  | 1840.29  | 2086.28  | 1407.31  | 2640.94  | 1461.93  | 1954.78  | 1851.58  | 2534.79   | 1446.27  | 1607.64   | ?        | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00      | ?        | 
    | NCS-525        | NCSC-525           | 4               | 23795.78  | 5180.26  | 1027.75  | 1240.03  | 2201.76  | 936.89   | 1932.36  | 2731.51  | 2225.03  | 2016.20   | 2011.02  | 2292.97   | ?        | 
    | NCS-525        | NCSC-525           | 5               | 22462.19  | 2383.14  | 2019.87  | 976.07   | 2035.16  | 2115.42  | 5522.36  | 1635.64  | 1922.12  | 619.89    | 816.40   | 2416.12   | ?        | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00      | ?        | 
																																											 					  
    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract																								 					  
    And   the Reconciliation Data is calculated as follows 																													 					  
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20    | Jan-21   | Feb-21    | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00      | 0.00     | 
    | NCS-525        | NCSC-525           | 2               | 31368.39  | 0.00     | 3853.50  | 0.00     | 0.00     | 5092.49  | 0.00     | 0.00     | 0.00     | 38344.75  | 0.00     | -15922.35 | 0.00     | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00      | 0.00     | 
    | NCS-525        | NCSC-525           | 4               | 27810.48  | 0.00     | 3388.49  | 0.00     | 0.00     | 17360.67 | 0.00     | 4014.70  | 0.00     | -1257.37  | 0.00     | 4303.99   | 0.00     | 
    | NCS-525        | NCSC-525           | 5               | 30923.32  | 0.00     | 4691.73  | 0.00     | 0.00     | 39037.95 | 0.00     | 8461.13  | 0.00     | -24500.01 | 0.00     | 3232.52   | 0.00     | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00      | 0.00     | 
																																											 					  
    # Check the CAPPING AMOUNTS in CRM on the latest approved contract																										 					  
    And   the Capping Amounts are calculated as follows 																													 					  
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20    | Jan-21   | Feb-21    | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00      | 0.00     | 
    | NCS-525        | NCSC-525           | 2               | -11023.74 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -11023.74 | 0.00     | 0.00      | 0.00     | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00      | 0.00     | 
    | NCS-525        | NCSC-525           | 4               | -4014.70  | 0.00     | 0.00     | 0.00     | 0.00     | -4014.70 | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00      | 0.00     | 
    | NCS-525        | NCSC-525           | 5               | -8461.13  | 0.00     | 0.00     | 0.00     | 0.00     | -8461.13 | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00      | 0.00     | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00      | 0.00     | 
																																											 					  
    # Check the NET AMOUNTS in CRM on the latest approved contract																											 					  
    And   the Net Payments are calculated as follows 																														 					  
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20    | Jan-21   | Feb-21    | Mar-21   |
    | NCS-525        | NCSC-525           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00      | 0.00     | 
    | NCS-525        | NCSC-525           | 2               | 20344.65  | 0.00     | 3853.50  | 0.00     | 0.00     | 5092.49  | 0.00     | 0.00     | 0.00     | 27321.01  | 0.00     | -15922.35 | 0.00     | 
    | NCS-525        | NCSC-525           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00      | 0.00     | 
    | NCS-525        | NCSC-525           | 4               | 23795.78  | 0.00     | 3388.49  | 0.00     | 0.00     | 13345.97 | 0.00     | 4014.70  | 0.00     | -1257.37  | 0.00     | 4303.99   | 0.00     | 
    | NCS-525        | NCSC-525           | 5               | 22462.19  | 0.00     | 4691.73  | 0.00     | 0.00     | 30576.82 | 0.00     | 8461.13  | 0.00     | -24500.01 | 0.00     | 3232.52   | 0.00     | 
    | NCS-525        | NCSC-525           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00      | 0.00     | 


	# Tidy Up
	And   the override date is reset
	 
	  