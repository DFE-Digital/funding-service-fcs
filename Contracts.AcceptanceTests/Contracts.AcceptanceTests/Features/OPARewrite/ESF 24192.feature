Feature: ESF 24192

@AcceptanceTest @Withdrawn20211216
Scenario: A250 OPA Rewrite. Create and approve an ESF contract. Consume actuals twice. Bulk amend and approve. Consume actuals again. Check CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017250' 
    And   there are no terminated or closed allocations for UKPRN '10017250' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017250' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017250' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ESF-250       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | ESF1420        |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017250' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017250 Co Ltd' with UKPRN '10017250' and OrgId 'ORG0017250' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017250' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017250 | 117250 | 10017250 Co Ltd | 0              | Active | Yes           | AA017250      | ?             | 

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017250 |




    # Change the date
    Given the override date is '03/01/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017250 | 10017250 Co Ltd      | ESFA-250             | ESIF-250       | 1                     | 01/01/2019        | 31/12/2019      | 171049.00     | ESF Contract                   | Contract for Services | 1420   | New          | ORG0017250 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                                    | AgreementNumber | ActivityDescription       | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017250 | ESIF-250       | ESF-250       | ESF 201420        | ESF1420                 | ESF                     | 01/01/2019          | 31/12/2019        | 171049.00       |                                         |            | ESF Allocation                                              | New          | Worcestershire LEP                          | E37038       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017250    | 1.1 Access to employment for jobseekers/ the inactive | 111\SD\7250     | Literacy in the workplace | NEET                  | Transition     | 1.05                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017250 | ESIF-250       | ESF-250       | 1               | 0                     | 77348.00  | 9638.00  | 6954.00  | 4026.00  | 9760.00  | 3416.00  | 6100.00  | 9150.00  | 5246.00  | 9028.00  | 5978.00  | 6832.00  | 1220.00  | ST01 Learner Assessment and Plan                                | New          |             |
    | 10017250 | ESIF-250       | ESF-250       | 2               | 0                     | 19061.00  | 2065.00  | 1946.00  | 2302.00  | 252.00   | 736.00   | 1249.00  | 3409.00  | 632.00   | 577.00   | 1724.00  | 1986.00  | 2183.00  | RQ01 Regulated Learning                                         | New          |             |
    | 10017250 | ESIF-250       | ESF-250       | 3               | 0                     | 24450.00  | 3205.00  | 1283.00  | 2365.00  | 1836.00  | 705.00   | 3116.00  | 3284.00  | 1045.00  | 3076.00  | 3402.00  | 690.00   | 443.00   | NR01 Non Regulated Activity                                     | New          |             |
    | 10017250 | ESIF-250       | ESF-250       | 4               | 0                     | 50190.00  | 6090.00  | 5390.00  | 1260.00  | 910.00   | 3640.00  | 6370.00  | 3010.00  | 3710.00  | 3220.00  | 4690.00  | 5040.00  | 6860.00  | FS01 Additional Programme Cost                                  | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | 
    | 10017250 | ESIF-250       | 1               | ESF-250       | 122      | 634     | 79       | 57       | 33       | 80       | 28       | 50       | 75       | 43       | 74       | 49       | 56       | 10       |
    | 10017250 | ESIF-250       | 2               | ESF-250       | 0        | 0       | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        |
    | 10017250 | ESIF-250       | 3               | ESF-250       | 0        | 0       | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        |
    | 10017250 | ESIF-250       | 4               | ESF-250       | 70       | 717     | 87       | 77       | 18       | 13       | 52       | 91       | 43       | 53       | 46       | 67       | 72       | 98       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'ESIF-250' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-250' and actual ContractNumber 'ESIF-250'

    # Check that the contract is now approved
    Then  the latest version of contract 'ESIF-250' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017250 | ESIF-250           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2019        | 31/12/2019      | ?             |
    | 10017250 | ESFA-250           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2019        | 31/12/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables (Was 48 + 4, now just 48)
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'ESIF-250'

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250         | 1               | 77348.00 | 9638.00  | 6954.00  | 4026.00  | 9760.00  | 3416.00  | 6100.00  | 9150.00  | 5246.00  | 9028.00  | 5978.00  | 6832.00  | 1220.00  | 
    | ESIF-250       | ESF-250         | 2               | 19061.00 | 2065.00  | 1946.00  | 2302.00  | 252.00   | 736.00   | 1249.00  | 3409.00  | 632.00   | 577.00   | 1724.00  | 1986.00  | 2183.00  | 
    | ESIF-250       | ESF-250         | 3               | 24450.00 | 3205.00  | 1283.00  | 2365.00  | 1836.00  | 705.00   | 3116.00  | 3284.00  | 1045.00  | 3076.00  | 3402.00  | 690.00   | 443.00   | 
    | ESIF-250       | ESF-250         | 4               | 50190.00 | 6090.00  | 5390.00  | 1260.00  | 910.00   | 3640.00  | 6370.00  | 3010.00  | 3710.00  | 3220.00  | 4690.00  | 5040.00  | 6860.00  | 

    # Check the PLANNED VOLUMES in CRM
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250         | 1               | 634      | 79       | 57       | 33       | 80       | 28       | 50       | 75       | 43       | 74       | 49       | 56       | 10       | 
    | ESIF-250       | ESF-250         | 2               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | ESIF-250       | ESF-250         | 3               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | ESIF-250       | ESF-250         | 4               | 717      | 87       | 77       | 18       | 13       | 52       | 91       | 43       | 53       | 46       | 67       | 72       | 98       | 

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | ESF-250       | 2671211          | Dec-19 | Reconciliation |




    # Consume actuals for the first time. No capping occurs
	
    # Change the date
    Given the override date is '04/02/2019'

	# Clear out any stub actuals
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jan 2019
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | ESF            | ESF09                | ORG0017250     | CM             | 201901 | ESF1420                 | ESF-250                  |         | 1               | 229          | 1682.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201902 | ESF1420                 | ESF-250                  |         | 1               | 5            | 290.00      | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201903 | ESF1420                 | ESF-250                  |         | 1               | 30           | 1740.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201904 | ESF1420                 | ESF-250                  |         | 1               | 38           | 2204.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201905 | ESF1420                 | ESF-250                  |         | 1               | 30           | 1740.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201906 | ESF1420                 | ESF-250                  |         | 1               | 94           | 5452.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201907 | ESF1420                 | ESF-250                  |         | 1               | 31           | 8092.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201908 | ESF1420                 | ESF-250                  |         | 1               | 5            | 290.00      | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201909 | ESF1420                 | ESF-250                  |         | 1               | 30           | 1740.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201910 | ESF1420                 | ESF-250                  |         | 1               | 38           | 2204.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201911 | ESF1420                 | ESF-250                  |         | 1               | 30           | 1740.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201912 | ESF1420                 | ESF-250                  |         | 1               | 94           | 5452.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201901 | ESF1420                 | ESF-250                  |         | 2               | 0            | 4214.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201902 | ESF1420                 | ESF-250                  |         | 2               | 0            | 1720.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201903 | ESF1420                 | ESF-250                  |         | 2               | 0            | 1204.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201904 | ESF1420                 | ESF-250                  |         | 2               | 0            | 688.00      | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201905 | ESF1420                 | ESF-250                  |         | 2               | 0            | 731.00      | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201906 | ESF1420                 | ESF-250                  |         | 2               | 0            | 2795.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201907 | ESF1420                 | ESF-250                  |         | 2               | 0            | 4214.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201908 | ESF1420                 | ESF-250                  |         | 2               | 0            | 1720.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201909 | ESF1420                 | ESF-250                  |         | 2               | 0            | 1204.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201910 | ESF1420                 | ESF-250                  |         | 2               | 0            | 688.00      | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201911 | ESF1420                 | ESF-250                  |         | 2               | 0            | 731.00      | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201912 | ESF1420                 | ESF-250                  |         | 2               | 0            | 2795.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201901 | ESF1420                 | ESF-250                  |         | 3               | 0            | 4763.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201902 | ESF1420                 | ESF-250                  |         | 3               | 0            | 1763.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201903 | ESF1420                 | ESF-250                  |         | 3               | 0            | 3053.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201904 | ESF1420                 | ESF-250                  |         | 3               | 0            | 1419.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201905 | ESF1420                 | ESF-250                  |         | 3               | 0            | 2709.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201906 | ESF1420                 | ESF-250                  |         | 3               | 0            | 903.00      | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201907 | ESF1420                 | ESF-250                  |         | 3               | 0            | 1763.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201908 | ESF1420                 | ESF-250                  |         | 3               | 0            | 1763.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201909 | ESF1420                 | ESF-250                  |         | 3               | 0            | 3053.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201910 | ESF1420                 | ESF-250                  |         | 3               | 0            | 1419.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201911 | ESF1420                 | ESF-250                  |         | 3               | 0            | 2709.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201912 | ESF1420                 | ESF-250                  |         | 3               | 0            | 903.00      | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201901 | ESF1420                 | ESF-250                  |         | 4               | 19           | 703.00      | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201902 | ESF1420                 | ESF-250                  |         | 4               | 58           | 2146.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201903 | ESF1420                 | ESF-250                  |         | 4               | 8            | 296.00      | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201904 | ESF1420                 | ESF-250                  |         | 4               | 46           | 1702.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201905 | ESF1420                 | ESF-250                  |         | 4               | 90           | 3330.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201906 | ESF1420                 | ESF-250                  |         | 4               | 26           | 962.00      | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201907 | ESF1420                 | ESF-250                  |         | 4               | 19           | 703.00      | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201908 | ESF1420                 | ESF-250                  |         | 4               | 58           | 2146.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201909 | ESF1420                 | ESF-250                  |         | 4               | 8            | 296.00      | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201910 | ESF1420                 | ESF-250                  |         | 4               | 46           | 1702.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201911 | ESF1420                 | ESF-250                  |         | 4               | 90           | 3330.00     | 
    | ESF            | ESF09                | ORG0017250     | CM             | 201912 | ESF1420                 | ESF-250                  |         | 4               | 26           | 962.00      | 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

   # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250         | 1               | 1682.00  | 1682.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 2               | 4214.00  | 4214.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 3               | 4763.00  | 4763.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 4               | 703.00   | 703.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250         | 1               | 1682.00  | 1682.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 2               | 4214.00  | 4214.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 3               | 4763.00  | 4763.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 4               | 703.00   | 703.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250         | 1               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 3               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 4               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250         | 1               | 1682.00  | 1682.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 2               | 4214.00  | 4214.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 3               | 4763.00  | 4763.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 4               | 703.00   | 703.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Jan-19    | Feb-19    | Mar-19    | Apr-19    | May-19    | Jun-19    | Jul-19    | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    |
    | 10017250 | ESIF-250       | ESF-250            | 2671211                  | 11362.00  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Jan-19    | Feb-19    | Mar-19    | Apr-19    | May-19    | Jun-19    | Jul-19    | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    |
    | 10017250 | ESIF-250       | ESF-250            | 2671211                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 




    # Consume actuals in month two. Capping occurs
    
    # Change the date
    Given the override date is '04/03/2019'

	# Clear out any stub actuals
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Feb 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ESF            | ESF10                | ORG0017250     | CM             | 201901 | ESF1420                 | ESF-250                  | ?          | 1               | 21           | 403.26      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201901 | ESF1420                 | ESF-250                  | ?          | 2               | 48           | 471.81      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201901 | ESF1420                 | ESF-250                  | ?          | 3               | 53           | 421.38      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201901 | ESF1420                 | ESF-250                  | ?          | 4               | 22           | 1424.52     |
    | ESF            | ESF10                | ORG0017250     | CM             | 201902 | ESF1420                 | ESF-250                  | ?          | 1               | 34           | 1161.61     |
    | ESF            | ESF10                | ORG0017250     | CM             | 201902 | ESF1420                 | ESF-250                  | ?          | 2               | 53           | 21265.72    |
    | ESF            | ESF10                | ORG0017250     | CM             | 201902 | ESF1420                 | ESF-250                  | ?          | 3               | 33           | 22135.31    |
    | ESF            | ESF10                | ORG0017250     | CM             | 201902 | ESF1420                 | ESF-250                  | ?          | 4               | 25           | 51129.29    |
    | ESF            | ESF10                | ORG0017250     | CM             | 201903 | ESF1420                 | ESF-250                  | ?          | 1               | 32           | 928.60      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201903 | ESF1420                 | ESF-250                  | ?          | 2               | 18           | 247.26      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201903 | ESF1420                 | ESF-250                  | ?          | 3               | 36           | 552.42      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201903 | ESF1420                 | ESF-250                  | ?          | 4               | 48           | 466.43      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201904 | ESF1420                 | ESF-250                  | ?          | 1               | 36           | 489.33      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201904 | ESF1420                 | ESF-250                  | ?          | 2               | 48           | 552.78      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201904 | ESF1420                 | ESF-250                  | ?          | 3               | 29           | 609.02      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201904 | ESF1420                 | ESF-250                  | ?          | 4               | 34           | 558.59      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201905 | ESF1420                 | ESF-250                  | ?          | 1               | 51           | 677.83      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201905 | ESF1420                 | ESF-250                  | ?          | 2               | 50           | 352.07      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201905 | ESF1420                 | ESF-250                  | ?          | 3               | 12           | 1274.94     |
    | ESF            | ESF10                | ORG0017250     | CM             | 201905 | ESF1420                 | ESF-250                  | ?          | 4               | 55           | 1065.02     |
    | ESF            | ESF10                | ORG0017250     | CM             | 201906 | ESF1420                 | ESF-250                  | ?          | 1               | 55           | 184.55      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201906 | ESF1420                 | ESF-250                  | ?          | 2               | 43           | 418.59      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201906 | ESF1420                 | ESF-250                  | ?          | 3               | 26           | 273.79      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201906 | ESF1420                 | ESF-250                  | ?          | 4               | 29           | 534.24      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201907 | ESF1420                 | ESF-250                  | ?          | 1               | 53           | 700.13      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201907 | ESF1420                 | ESF-250                  | ?          | 2               | 20           | 729.97      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201907 | ESF1420                 | ESF-250                  | ?          | 3               | 35           | 269.19      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201907 | ESF1420                 | ESF-250                  | ?          | 4               | 50           | 1156.50     |
    | ESF            | ESF10                | ORG0017250     | CM             | 201908 | ESF1420                 | ESF-250                  | ?          | 1               | 51           | 1383.46     |
    | ESF            | ESF10                | ORG0017250     | CM             | 201908 | ESF1420                 | ESF-250                  | ?          | 2               | 40           | 1404.15     |
    | ESF            | ESF10                | ORG0017250     | CM             | 201908 | ESF1420                 | ESF-250                  | ?          | 3               | 36           | 202.62      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201908 | ESF1420                 | ESF-250                  | ?          | 4               | 44           | 1125.49     |
    | ESF            | ESF10                | ORG0017250     | CM             | 201909 | ESF1420                 | ESF-250                  | ?          | 1               | 13           | 308.04      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201909 | ESF1420                 | ESF-250                  | ?          | 2               | 23           | 648.75      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201909 | ESF1420                 | ESF-250                  | ?          | 3               | 54           | 1407.03     |
    | ESF            | ESF10                | ORG0017250     | CM             | 201909 | ESF1420                 | ESF-250                  | ?          | 4               | 37           | 1249.92     |
    | ESF            | ESF10                | ORG0017250     | CM             | 201910 | ESF1420                 | ESF-250                  | ?          | 1               | 33           | 205.10      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201910 | ESF1420                 | ESF-250                  | ?          | 2               | 21           | 548.97      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201910 | ESF1420                 | ESF-250                  | ?          | 3               | 51           | 1365.16     |
    | ESF            | ESF10                | ORG0017250     | CM             | 201910 | ESF1420                 | ESF-250                  | ?          | 4               | 53           | 457.26      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201911 | ESF1420                 | ESF-250                  | ?          | 1               | 32           | 696.38      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201911 | ESF1420                 | ESF-250                  | ?          | 2               | 43           | 823.74      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201911 | ESF1420                 | ESF-250                  | ?          | 3               | 18           | 812.02      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201911 | ESF1420                 | ESF-250                  | ?          | 4               | 31           | 530.98      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201912 | ESF1420                 | ESF-250                  | ?          | 1               | 19           | 371.74      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201912 | ESF1420                 | ESF-250                  | ?          | 2               | 38           | 579.38      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201912 | ESF1420                 | ESF-250                  | ?          | 3               | 19           | 842.98      |
    | ESF            | ESF10                | ORG0017250     | CM             | 201912 | ESF1420                 | ESF-250                  | ?          | 4               | 22           | 1121.73     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

   # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250         | 1               | 1564.87  | 403.26   | 1161.61  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 2               | 21737.53 | 471.81   | 21265.72 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 3               | 22556.69 | 421.38   | 22135.31 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 4               | 52553.81 | 1424.52  | 51129.29 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250            | 1               | 1564.87   | 1682.00  | -117.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 2               | 21737.53  | 4214.00  | 17523.53 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 3               | 22556.69  | 4763.00  | 17793.69 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 4               | 52553.81  | 703.00   | 51850.81 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 2               | -2676.53  | 0.00     | -2676.53 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 4               | -2363.81  | 0.00     | -2363.81 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250            | 1               | 1564.87   | 1682.00  | -117.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 2               | 19061.00  | 4214.00  | 14847.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 3               | 22556.69  | 4763.00  | 17793.69 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 4               | 50190.00  | 703.00   | 49487.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VOLUMES in CRM
    And   the Actuals Volume Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250         | 1               | 55       | 21       | 34       | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 2               | 101      | 48       | 53       | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 3               | 86       | 53       | 33       | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 4               | 47       | 22       | 25       | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Jan-19    | Feb-19    | Mar-19    | Apr-19    | May-19    | Jun-19    | Jul-19    | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    |
    | 10017250 | ESIF-250       | ESF-250            | 2671211                  | 11362.00  | 87050.90  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Jan-19    | Feb-19    | Mar-19    | Apr-19    | May-19    | Jun-19    | Jul-19    | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    |
    | 10017250 | ESIF-250       | ESF-250            | 2671211                  | 0.00      | -5040.34  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 




	# Amend the contract to increase the allocation values and reduce the capping values 

    # Change the date
    Given the override date is '20/03/2019'

    # Bulk import to AMEND the contract
    And   there are no files prefixed '10017250' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 10092018082950 v2_A250_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 10092018082950 v2_A250_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 10092018082950 v2_A250_1.xlsx' exists in the Datafiles folder and UKPRN '10017250' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'ESIF-250' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-250' and actual ContractNumber 'ESIF-250'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017250 | ESIF-250           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2019        | 31/12/2019      | Variation     |
    | 10017250 | ESIF-250           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/01/2019        | 31/12/2019      | ?             |
    | 10017250 | ESFA-250           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2019        | 31/12/2019      | ?             |

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250         | 1               | 47168.00 | 2640.00  | 4928.00  | 3696.00  | 2024.00  | 6688.00  | 1848.00  | 7568.00  | 4048.00  | 2200.00  | 3432.00  | 6600.00  | 1496.00  | 
    | ESIF-250       | ESF-250         | 2               | 22065.00 | 1241.00  | 1445.00  | 1153.00  | 2125.00  | 2006.00  | 3700.00  | 2051.00  | 2448.00  | 1020.00  | 2091.00  | 1748.00  | 1037.00  | 
    | ESIF-250       | ESF-250         | 3               | 21101.00 | 1581.00  | 2295.00  | 2799.00  | 2767.00  | 1343.00  | 1819.00  | 1564.00  | 1459.00  | 1224.00  | 2142.00  | 578.00   | 1530.00  | 
    | ESIF-250       | ESF-250         | 4               | 52182.00 | 2808.00  | 5850.00  | 6084.00  | 5499.00  | 2457.00  | 2106.00  | 5616.00  | 2223.00  | 5265.00  | 3276.00  | 6552.00  | 4446.00  | 

    # Check the PLANNED VOLUMES in CRM
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250         | 1               | 536      | 30       | 56       | 42       | 23       | 76       | 21       | 86       | 46       | 25       | 39       | 75       | 17       | 
    | ESIF-250       | ESF-250         | 2               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | ESIF-250       | ESF-250         | 3               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | ESIF-250       | ESF-250         | 4               | 446      | 24       | 50       | 52       | 47       | 21       | 18       | 48       | 19       | 45       | 28       | 56       | 38       | 

    # Check the ACTUAL VALUES in CRM
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250         | 1               | 1564.87  | 403.26   | 1161.61  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 2               | 21737.53 | 471.81   | 21265.72 | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 3               | 22556.69 | 421.38   | 22135.31 | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250         | 4               | 52553.81 | 1424.52  | 51129.29 | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250            | 1               | 1564.87   | 1682.00  | -117.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 2               | 24414.06  | 4214.00  | 17523.53 | 2676.53  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 3               | 22556.69  | 4763.00  | 17793.69 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 4               | 54917.62  | 703.00   | 51850.81 | 2363.81  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 2               | -2676.53  | 0.00     | -2676.53 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 3               | -1455.69  | 0.00     | 0.00     | -1455.69 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 4               | -2735.62  | 0.00     | -2363.81 | -371.81  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250            | 1               | 1564.87   | 1682.00  | -117.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 2               | 21737.53  | 4214.00  | 14847.00 | 2676.53  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 3               | 21101.00  | 4763.00  | 17793.69 | -1455.69 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 4               | 52182.00  | 703.00   | 49487.00 | 1992.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VOLUMES in CRM on the latest approved contract
    And   the Actuals Volume Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250            | 1               | 55        | 21       | 34       | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250            | 2               | 101       | 48       | 53       | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250            | 3               | 86        | 53       | 33       | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250            | 4               | 47        | 22       | 25       | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Jan-19    | Feb-19    | Mar-19    | Apr-19    | May-19    | Jun-19    | Jul-19    | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    |
    | 10017250 | ESIF-250       | ESF-250            | 2671211                  | 11362.00  | 87050.90  | 5040.34   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Jan-19    | Feb-19    | Mar-19    | Apr-19    | May-19    | Jun-19    | Jul-19    | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    |
    | 10017250 | ESIF-250       | ESF-250            | 2671211                  | 0.00      | -5040.34  | -1827.50  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 




    # Consume actuals in month three such that capping occurs again

    # Change the date
    Given the override date is '04/04/2019'

	# Clear out any stub actuals
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Mar 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ESF            | ESF11                | ORG0017250     | CM             | 201901 | ESF1420                 | ESF-250                  | ?          | 1               | 31           | 495.22      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201901 | ESF1420                 | ESF-250                  | ?          | 2               | 22           | 10315.45    |
    | ESF            | ESF11                | ORG0017250     | CM             | 201901 | ESF1420                 | ESF-250                  | ?          | 3               | 50           | 15088.21    |
    | ESF            | ESF11                | ORG0017250     | CM             | 201901 | ESF1420                 | ESF-250                  | ?          | 4               | 49           | 21109.22    |
    | ESF            | ESF11                | ORG0017250     | CM             | 201902 | ESF1420                 | ESF-250                  | ?          | 1               | 52           | 20454.01    |
    | ESF            | ESF11                | ORG0017250     | CM             | 201902 | ESF1420                 | ESF-250                  | ?          | 2               | 50           | 11227.76    |
    | ESF            | ESF11                | ORG0017250     | CM             | 201902 | ESF1420                 | ESF-250                  | ?          | 3               | 30           | 5497.36     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201902 | ESF1420                 | ESF-250                  | ?          | 4               | 42           | 20125.72    |
    | ESF            | ESF11                | ORG0017250     | CM             | 201903 | ESF1420                 | ESF-250                  | ?          | 1               | 14           | 26622.13    |
    | ESF            | ESF11                | ORG0017250     | CM             | 201903 | ESF1420                 | ESF-250                  | ?          | 2               | 39           | 2998.26     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201903 | ESF1420                 | ESF-250                  | ?          | 3               | 21           | 1440.72     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201903 | ESF1420                 | ESF-250                  | ?          | 4               | 56           | 7038.99     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201904 | ESF1420                 | ESF-250                  | ?          | 1               | 17           | 277.99      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201904 | ESF1420                 | ESF-250                  | ?          | 2               | 46           | 1383.75     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201904 | ESF1420                 | ESF-250                  | ?          | 3               | 50           | 1433.85     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201904 | ESF1420                 | ESF-250                  | ?          | 4               | 53           | 507.64      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201905 | ESF1420                 | ESF-250                  | ?          | 1               | 19           | 141.20      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201905 | ESF1420                 | ESF-250                  | ?          | 2               | 12           | 863.92      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201905 | ESF1420                 | ESF-250                  | ?          | 3               | 54           | 1083.71     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201905 | ESF1420                 | ESF-250                  | ?          | 4               | 34           | 1353.31     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201906 | ESF1420                 | ESF-250                  | ?          | 1               | 40           | 727.16      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201906 | ESF1420                 | ESF-250                  | ?          | 2               | 38           | 398.40      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201906 | ESF1420                 | ESF-250                  | ?          | 3               | 50           | 452.55      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201906 | ESF1420                 | ESF-250                  | ?          | 4               | 28           | 1243.38     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201907 | ESF1420                 | ESF-250                  | ?          | 1               | 41           | 584.37      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201907 | ESF1420                 | ESF-250                  | ?          | 2               | 19           | 1439.12     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201907 | ESF1420                 | ESF-250                  | ?          | 3               | 20           | 665.35      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201907 | ESF1420                 | ESF-250                  | ?          | 4               | 38           | 1028.43     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201908 | ESF1420                 | ESF-250                  | ?          | 1               | 17           | 1115.11     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201908 | ESF1420                 | ESF-250                  | ?          | 2               | 52           | 1135.79     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201908 | ESF1420                 | ESF-250                  | ?          | 3               | 23           | 452.35      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201908 | ESF1420                 | ESF-250                  | ?          | 4               | 39           | 1202.52     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201909 | ESF1420                 | ESF-250                  | ?          | 1               | 20           | 1422.39     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201909 | ESF1420                 | ESF-250                  | ?          | 2               | 39           | 190.40      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201909 | ESF1420                 | ESF-250                  | ?          | 3               | 38           | 1261.66     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201909 | ESF1420                 | ESF-250                  | ?          | 4               | 33           | 273.49      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201910 | ESF1420                 | ESF-250                  | ?          | 1               | 46           | 1032.79     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201910 | ESF1420                 | ESF-250                  | ?          | 2               | 21           | 1051.37     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201910 | ESF1420                 | ESF-250                  | ?          | 3               | 17           | 1170.63     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201910 | ESF1420                 | ESF-250                  | ?          | 4               | 14           | 1311.20     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201911 | ESF1420                 | ESF-250                  | ?          | 1               | 54           | 1265.24     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201911 | ESF1420                 | ESF-250                  | ?          | 2               | 29           | 1219.91     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201911 | ESF1420                 | ESF-250                  | ?          | 3               | 18           | 1240.59     |
    | ESF            | ESF11                | ORG0017250     | CM             | 201911 | ESF1420                 | ESF-250                  | ?          | 4               | 34           | 569.45      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201912 | ESF1420                 | ESF-250                  | ?          | 1               | 46           | 148.10      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201912 | ESF1420                 | ESF-250                  | ?          | 2               | 13           | 138.33      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201912 | ESF1420                 | ESF-250                  | ?          | 3               | 54           | 434.34      |
    | ESF            | ESF11                | ORG0017250     | CM             | 201912 | ESF1420                 | ESF-250                  | ?          | 4               | 51           | 495.68      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250            | 1               | 47571.36  | 495.22   | 20454.01 | 26622.13 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250            | 2               | 24541.47  | 10315.45 | 11227.76 | 2998.26  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250            | 3               | 22026.29  | 15088.21 | 5497.36  | 1440.72  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250            | 4               | 48273.93  | 21109.22 | 20125.72 | 7038.99  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250            | 1               | 47571.36  | 1682.00  | -117.13  | 46006.49 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 2               | 27218.00  | 4214.00  | 17523.53 | 5480.47  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 3               | 22026.29  | 4763.00  | 17793.69 | -530.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 4               | 50637.74  | 703.00   | 51850.81 | -1916.07 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250            | 1               | -403.36   | 0.00     | 0.00     | -403.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 2               | -5153.00  | 0.00     | -2676.53 | -2476.47 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 3               | -925.29   | 0.00     | 0.00     | -925.29  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 4               | -2363.81  | 0.00     | -2363.81 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250            | 1               | 47168.00  | 1682.00  | -117.13  | 45603.13 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 2               | 22065.00  | 4214.00  | 14847.00 | 3004.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 3               | 21101.00  | 4763.00  | 17793.69 | -1455.69 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | ESIF-250       | ESF-250            | 4               | 48273.93  | 703.00   | 49487.00 | -1916.07 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VOLUMES in CRM on the latest approved contract
    And   the Actuals Volume Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-250       | ESF-250            | 1               | 97        | 31       | 52       | 14       | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250            | 2               | 111       | 22       | 50       | 39       | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250            | 3               | 101       | 50       | 30       | 21       | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-250       | ESF-250            | 4               | 147       | 49       | 42       | 56       | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Jan-19    | Feb-19    | Mar-19    | Apr-19    | May-19    | Jun-19    | Jul-19    | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    |
    | 10017250 | ESIF-250       | ESF-250            | 2671211                  | 11362.00  | 87050.90  | 49040.49  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Jan-19    | Feb-19    | Mar-19    | Apr-19    | May-19    | Jun-19    | Jul-19    | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    |
    | 10017250 | ESIF-250       | ESF-250            | 2671211                  | 0.00      | -5040.34  | -3805.12  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 



    # Tidy up
	And   the override date is reset

	 