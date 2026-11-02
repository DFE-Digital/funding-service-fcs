Feature: AEBP1920Capping

@AcceptanceTest @Withdrawn20211216
@Long2Run @Long2Run890
Scenario: A074 Create and approve a procured 1920 AEBP contract. Consume actuals 3x inc 10%. Amend and approve contract. Consume actuals 1x. Check financials and capping rules along the way
    Given there is no Contract, Task or Workflow data for UKPRN '10017074' 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017074' 

    # Clear down all subnominal data from CRM and PaaS
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-074      |
    | AEBR-074      |

    # Clear down PaymentSchedule.DeliverablePayment data for an allocation
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-074      |
    | AEBR-074      |

	# Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017074' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017074 Co Ltd' with UKPRN '10017074' and OrgId 'ORG0017074' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017074' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017074 | 117074 | 10017074 Co Ltd | 0              | Active                | Yes           | AA017074      | ?             | 39 Halstead Road       | Earls Colne            | ?                      | ?                      | Colchester             | Essex                  | CO6 2NL   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017074 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017074 | 10017074 Co Ltd      | ESFA-074             | AEBP-074       | 1                     | 01/08/2019        | 31/07/2020      | 50848.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017074 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017074 | AEBP-074       | AEBA-074      | AEB-AS            | AEB-AS1920              | AY                      | 01/08/2019          | 31/07/2020        | 26135.00        |                                         |            |                                                             | New          |             |
    | 10017074 | AEBP-074       | AEBR-074      | AEB-19TRN         | AEB-19TRN1920           | AY                      | 01/08/2019          | 31/07/2020        | 24713.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |  
    | 10017074 | AEBP-074       | AEBA-074      | 1               | 0                     | 26135.00  | 17181.00  | 8954.00   | 3500.00  | 535.00   | 3010.00  | 2986.00  | 2077.00  | 1103.00  | 3040.00  | 930.00   | 1824.00  | 2843.00  | 1523.00  | 2764.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017074 | AEBP-074       | AEBR-074      | 1               | 0                     | 24713.00  | 15906.00  | 8807.00   | 2222.00  | 2513.00  | 655.00   | 3511.00  | 3329.00  | 2894.00  | 497.00   | 285.00   | 1905.00  | 3462.00  | 1510.00  | 1930.00  | 19-24 Traineeships Total Funding                                | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-074' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-074'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-074' and actual ContractNumber 'AEBP-074'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-074' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017074 | AEBP-074           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017074 | ESFA-074           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'AEBP-074'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations 
    | AllocationRef | Subnominal Code | Period | Payment Type   |
    | AEBA-074      | 2372010         | Jul-20 | Reconciliation |
    | AEBA-074      | 2372016         | Jul-20 | Capping        |
    | AEBR-074      | 2355800         | Jul-20 | Reconciliation |
    | AEBR-074      | 2355816         | Jul-20 | Capping        |

    # Check deliverable data in the ContractManagement Legal feed
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                             | DeliverableDescription                                      | 
    | 10017074 | AEBP-074       | 1               | AEBA-074      | 1               | 0                     | 26135        | 0             | 0        | Adult Skills Total Funding                                  | ?                                                           |
    | 10017074 | AEBP-074       | 1               | AEBR-074      | 1               | 0                     | 24713        | 0             | 0        | 19-24 Traineeships Total Funding                            | ?                                                           |




    # Add actuals to the contract for Feb 20. No capping

    # Change the date
    Given the override date is '04/03/2020'

    # Clear down the stub
    And there are no entries in the DCFS stub table

	# Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Feb 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201908 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 971.90      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201908 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 878.83      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201909 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 971.58      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201909 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 1096.54     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201910 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 780.83      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201910 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 2244.19     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201911 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 2324.19     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201911 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 617.74      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201912 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1605.12     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201912 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 932.56      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202001 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1200.27     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202001 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 790.78      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202002 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 707.11      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202002 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 1088.23     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202003 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 473.34      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202003 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 2176.36     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202004 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1560.96     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202004 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 819.96      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202005 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1223.28     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202005 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 616.12      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202006 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 497.95      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202006 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 765.18      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202007 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1144.10     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202007 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 2109.25     |
    #
    | ILR1920        | R07                  | ORG0017074     | CM             | 201908 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 176.79      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201908 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 578.96      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201909 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 876.80      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201909 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1014.00     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201910 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 278.98      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201910 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 248.13      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201911 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2467.18     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201911 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 774.27      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201912 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 429.03      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 201912 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1330.31     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202001 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2048.58     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202001 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1571.19     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202002 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2039.89     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202002 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1817.99     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202003 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 1949.83     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202003 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 2499.62     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202004 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2083.15     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202004 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 2127.59     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202005 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2327.92     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202005 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 2169.77     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202006 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 1184.44     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202006 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 513.48      |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202007 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 1725.90     |
    | ILR1920        | R07                  | ORG0017074     | CM             | 202007 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1933.75     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check CRM

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 26135.00  | 17181.00 | 8954.00  | 3500.00  | 535.00   | 3010.00  | 2986.00  | 2077.00  | 1103.00  | 3040.00  | 930.00   | 1824.00  | 2843.00  | 1523.00  | 2764.00  | 
    | AEBP-074       | AEBA-074           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
	| AEBP-074       | AEBR-074           | 1               | 24713.00  | 15906.00 | 8807.00  | 2222.00  | 2513.00  | 655.00   | 3511.00  | 3329.00  | 2894.00  | 497.00   | 285.00   | 1905.00  | 3462.00  | 1510.00  | 1930.00  | 
    | AEBP-074       | AEBR-074           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-074       | AEBA-074           | 2               | 8561.00   | 971.90   | 971.58   | 780.83   | 2324.19  | 1605.12  | 1200.27  | 707.11   | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-074       | AEBA-074           | 3               | 7648.87   | 878.83   | 1096.54  | 2244.19  | 617.74   | 932.56   | 790.78   | 1088.23  | ?        | ?        | ?        | ?        | ?        | 
    #
	| AEBP-074       | AEBR-074           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-074       | AEBR-074           | 2               | 8317.25   | 176.79   | 876.80   | 278.98   | 2467.18  | 429.03   | 2048.58  | 2039.89  | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-074       | AEBR-074           | 3               | 7334.85   | 578.96   | 1014.00  | 248.13   | 774.27   | 1330.31  | 1571.19  | 1817.99  | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 2               | 8561.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8561.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 7648.87   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7648.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
	| AEBP-074       | AEBR-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 2               | 8317.25   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8317.25  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | 7334.85   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7334.85  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
	| AEBP-074       | AEBR-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 2               | 8561.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8561.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 7648.87   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7648.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
	| AEBP-074       | AEBR-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 2               | 8317.25   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8317.25  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | 7334.85   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7334.85  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 





    # Add actuals to the contract for Mar 20. Capping occurs

    # Change the date
    Given the override date is '04/04/2020'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Mar 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201908 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 971.90      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201908 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 878.83      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201909 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 971.58      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201909 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 1096.54     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201910 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 780.83      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201910 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 2244.19     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201911 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 2324.19     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201911 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 617.74      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201912 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1605.12     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201912 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 932.56      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202001 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1200.27     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202001 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 790.78      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202002 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 707.11      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202002 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 1088.23     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202003 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 473.34      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202003 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 876.36      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202004 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1560.96     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202004 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 819.96      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202005 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1223.28     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202005 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 616.12      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202006 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 497.95      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202006 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 765.18      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202007 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1144.10     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202007 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 2109.25     |
    #
    | ILR1920        | R08                  | ORG0017074     | CM             | 201908 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 176.79      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201908 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 578.96      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201909 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 876.80      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201909 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1014.00     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201910 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 278.98      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201910 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 248.13      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201911 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2467.18     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201911 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 774.27      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201912 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 429.03      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 201912 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1330.31     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202001 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2048.58     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202001 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1571.19     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202002 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2039.89     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202002 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1817.99     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202003 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 949.83      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202003 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1499.62     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202004 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2083.15     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202004 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 2127.59     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202005 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2327.92     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202005 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 2169.77     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202006 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 1184.44     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202006 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 513.48      |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202007 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 1725.90     |
    | ILR1920        | R08                  | ORG0017074     | CM             | 202007 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1933.75     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check CRM

    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 26135.00  | 17181.00 | 8954.00  | 3500.00  | 535.00   | 3010.00  | 2986.00  | 2077.00  | 1103.00  | 3040.00  | 930.00   | 1824.00  | 2843.00  | 1523.00  | 2764.00  | 
    | AEBP-074       | AEBA-074           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
	| AEBP-074       | AEBR-074           | 1               | 24713.00  | 15906.00 | 8807.00  | 2222.00  | 2513.00  | 655.00   | 3511.00  | 3329.00  | 2894.00  | 497.00   | 285.00   | 1905.00  | 3462.00  | 1510.00  | 1930.00  | 
    | AEBP-074       | AEBR-074           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-074       | AEBA-074           | 2               | 9034.34   | 971.90   | 971.58   | 780.83   | 2324.19  | 1605.12  | 1200.27  | 707.11   | 473.34   | ?        | ?        | ?        | ?        | 
    | AEBP-074       | AEBA-074           | 3               | 8525.23   | 878.83   | 1096.54  | 2244.19  | 617.74   | 932.56   | 790.78   | 1088.23  | 876.36   | ?        | ?        | ?        | ?        | 
    #
    | AEBP-074       | AEBR-074           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-074       | AEBR-074           | 2               | 9267.08   | 176.79   | 876.80   | 278.98   | 2467.18  | 429.03   | 2048.58  | 2039.89  | 949.83   | ?        | ?        | ?        | ?        | 
    | AEBP-074       | AEBR-074           | 3               | 8834.47   | 578.96   | 1014.00  | 248.13   | 774.27   | 1330.31  | 1571.19  | 1817.99  | 1499.62  | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 2               | 9034.34   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8561.00  | 473.34   | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 8525.23   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7648.87  | 876.36   | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-074       | AEBR-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 2               | 9267.08   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8317.25  | 949.83   | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | 8834.47   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7334.85  | 1499.62  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-074       | AEBR-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 2               | -309.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -309.70  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | -295.25   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -295.25  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 2               | 9034.34   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8561.00  | 473.34   | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 8525.23   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7648.87  | 876.36   | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-074       | AEBR-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 2               | 8957.38   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8317.25  | 640.13   | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | 8539.22   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7334.85  | 1204.37  | 0.00     | 0.00     | 0.00     | 0.00     | 




    # Add actuals to the contract for Apr 20. The 10% tolerance now applies from R09 (29738)

    # Change the date
    Given the override date is '04/05/2020'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Apr 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201908 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 971.90      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201908 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 878.83      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201909 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 971.58      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201909 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 1096.54     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201910 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 780.83      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201910 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 2244.19     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201911 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 2324.19     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201911 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 617.74      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201912 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1605.12     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201912 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 932.56      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202001 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1200.27     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202001 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 790.78      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202002 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 707.11      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202002 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 1088.23     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202003 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 473.34      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202003 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 876.36      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202004 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 3560.96     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202004 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 3819.96     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202005 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1223.28     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202005 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 616.12      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202006 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 497.95      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202006 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 765.18      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202007 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1144.10     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202007 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 2109.25     |
    #
    | ILR1920        | R09                  | ORG0017074     | CM             | 201908 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 176.79      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201908 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 578.96      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201909 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 876.80      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201909 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1014.00     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201910 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 278.98      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201910 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 248.13      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201911 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2467.18     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201911 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 774.27      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201912 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 429.03      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 201912 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1330.31     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202001 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2048.58     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202001 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1571.19     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202002 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2039.89     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202002 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1817.99     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202003 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 949.83      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202003 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1499.62     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202004 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 3083.15     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202004 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 3127.59     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202005 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2327.92     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202005 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 2169.77     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202006 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 1184.44     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202006 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 513.48      |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202007 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 1725.90     |
    | ILR1920        | R09                  | ORG0017074     | CM             | 202007 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1933.75     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


    # Check CRM
	
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 26135.00  | 17181.00 | 8954.00  | 3500.00  | 535.00   | 3010.00  | 2986.00  | 2077.00  | 1103.00  | 3040.00  | 930.00   | 1824.00  | 2843.00  | 1523.00  | 2764.00  | 
    | AEBP-074       | AEBA-074           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
	| AEBP-074       | AEBR-074           | 1               | 24713.00  | 15906.00 | 8807.00  | 2222.00  | 2513.00  | 655.00   | 3511.00  | 3329.00  | 2894.00  | 497.00   | 285.00   | 1905.00  | 3462.00  | 1510.00  | 1930.00  | 
    | AEBP-074       | AEBR-074           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-074       | AEBA-074           | 2               | 12595.30  | 971.90   | 971.58   | 780.83   | 2324.19  | 1605.12  | 1200.27  | 707.11   | 473.34   | 3560.96  | ?        | ?        | ?        | 
    | AEBP-074       | AEBA-074           | 3               | 12345.19  | 878.83   | 1096.54  | 2244.19  | 617.74   | 932.56   | 790.78   | 1088.23  | 876.36   | 3819.96  | ?        | ?        | ?        | 
    #
    | AEBP-074       | AEBR-074           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-074       | AEBR-074           | 2               | 12350.23  | 176.79   | 876.80   | 278.98   | 2467.18  | 429.03   | 2048.58  | 2039.89  | 949.83   | 3083.15  | ?        | ?        | ?        | 
    | AEBP-074       | AEBR-074           | 3               | 11962.06  | 578.96   | 1014.00  | 248.13   | 774.27   | 1330.31  | 1571.19  | 1817.99  | 1499.62  | 3127.59  | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 2               | 12595.30  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8561.00  | 473.34   | 3560.96  | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 12345.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7648.87  | 876.36   | 3819.96  | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-074       | AEBR-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 2               | 12659.93  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8317.25  | 949.83   | 3392.85  | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | 12257.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7334.85  | 1499.62  | 3422.84  | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-074       | AEBR-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 2               | -309.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -309.70  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | -295.25   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -295.25  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 2               | 12595.30  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8561.00  | 473.34   | 3560.96  | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 12345.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7648.87  | 876.36   | 3819.96  | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-074       | AEBR-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 2               | 12350.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8317.25  | 640.13   | 3392.85  | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | 11962.06  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7334.85  | 1204.37  | 3422.84  | 0.00     | 0.00     | 0.00     | 




    # Bulk amend the contract to increase profile values and so remove the Cap
    #   AEBR-074 from £24713 (£15906 and £8807) to £30000 (£18433 and £11567)
    #   AEBA-074 from £26135 (£17181 and £8954) to £31000 (£18573 and £12427)

    # Change the date
    Given the override date is '12/05/2020'

    # Bulk file
    And   there are no files prefixed '10017074' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1920 11032020173430 v3_A074' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 1920 11032020173430 v3_A074' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1920 11032020173430 v3_A074' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1920 11032020173430 v3_A074' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1920 11032020173430 v3_A074.xlsx' exists in the Datafiles folder and UKPRN '10017074' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Change the date
    Given the override date is '13/05/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-074'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-074' and actual ContractNumber 'AEBP-074'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-074' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017074 | AEBP-074           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017074 | AEBP-074           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017074 | ESFA-074           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'AEBP-074'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | AEBA-074      | 2372010          | Jul-20 | Reconciliation |
    | AEBR-074      | 2355800          | Jul-20 | Reconciliation |


    # Check CRM for v2

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 31000.00  | 18573.00 | 12427.00 | 3375.00  | 2349.00  | 2581.00  | 1724.00  | 1208.00  | 2836.00  | 2959.00  | 1541.00  | 3908.00  | 3855.00  | 1902.00  | 2762.00  | 
    | AEBP-074       | AEBA-074           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-074       | AEBR-074           | 1               | 30000.00  | 18433.00 | 11567.00 | 3347.00  | 6765.00  | 735.00   | 2923.00  | 89.00    | 2753.00  | 597.00   | 1224.00  | 3183.00  | 3368.00  | 2975.00  | 2041.00  | 
    | AEBP-074       | AEBR-074           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-074       | AEBA-074           | 2               | 12595.30  | 971.90   | 971.58   | 780.83   | 2324.19  | 1605.12  | 1200.27  | 707.11   | 473.34   | 3560.96  | ?        | ?        | ?        | 
    | AEBP-074       | AEBA-074           | 3               | 12345.19  | 878.83   | 1096.54  | 2244.19  | 617.74   | 932.56   | 790.78   | 1088.23  | 876.36   | 3819.96  | ?        | ?        | ?        | 
    #
    | AEBP-074       | AEBR-074           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-074       | AEBR-074           | 2               | 12350.23  | 176.79   | 876.80   | 278.98   | 2467.18  | 429.03   | 2048.58  | 2039.89  | 949.83   | 3083.15  | ?        | ?        | ?        | 
    | AEBP-074       | AEBR-074           | 3               | 11962.06  | 578.96   | 1014.00  | 248.13   | 774.27   | 1330.31  | 1571.19  | 1817.99  | 1499.62  | 3127.59  | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 2               | 12595.30  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8561.00  | 473.34   | 3560.96  | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 12345.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7648.87  | 876.36   | 3819.96  | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-074       | AEBR-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 2               | 12659.93  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8317.25  | 949.83   | 3392.85  | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | 12257.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7334.85  | 1499.62  | 3422.84  | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-074       | AEBR-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 2               | -309.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -309.70  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | -295.25   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -295.25  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 2               | 12595.30  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8561.00  | 473.34   | 3560.96  | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 12345.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7648.87  | 876.36   | 3819.96  | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-074       | AEBR-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 2               | 12350.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8317.25  | 640.13   | 3392.85  | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | 11962.06  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7334.85  | 1204.37  | 3422.84  | 0.00     | 0.00     | 0.00     | 




    # Add actuals to the contract for Jun 20. Capping applied where actuals exceed 110% of Planned value

    # Change the date
    Given the override date is '04/07/2020'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Jun 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201908 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 971.90      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201908 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 878.83      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201909 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 971.58      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201909 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 1096.54     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201910 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 780.83      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201910 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 2244.19     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201911 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 2324.19     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201911 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 617.74      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201912 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1605.12     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201912 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 932.56      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202001 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1200.27     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202001 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 790.78      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202002 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 707.11      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202002 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 1088.23     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202003 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 3473.34     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202003 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 3876.36     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202004 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 3560.96     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202004 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 3819.96     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202005 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1223.28     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202005 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 616.12      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202006 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 497.95      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202006 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 765.18      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202007 | AEB-AS1920              | AEBA-074                 | ?          | 2               | 0            | 1144.10     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202007 | AEB-AS1920              | AEBA-074                 | ?          | 3               | 0            | 2109.25     |
    #
    | ILR1920        | R11                  | ORG0017074     | CM             | 201908 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 176.79      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201908 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 578.96      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201909 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 876.80      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201909 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1014.00     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201910 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 278.98      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201910 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 248.13      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201911 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2467.18     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201911 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 774.27      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201912 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 429.03      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 201912 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1330.31     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202001 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2048.58     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202001 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1571.19     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202002 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2039.89     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202002 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1817.99     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202003 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 949.83      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202003 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1499.62     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202004 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 4083.15     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202004 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 5127.59     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202005 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 2327.92     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202005 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 2169.77     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202006 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 1184.44     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202006 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 513.48      |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202007 | AEB-19TRN1920           | AEBR-074                 | ?          | 2               | 0            | 1725.90     |
    | ILR1920        | R11                  | ORG0017074     | CM             | 202007 | AEB-19TRN1920           | AEBR-074                 | ?          | 3               | 0            | 1933.75     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


    # Check CRM

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 31000.00  | 18573.00 | 12427.00 | 3375.00  | 2349.00  | 2581.00  | 1724.00  | 1208.00  | 2836.00  | 2959.00  | 1541.00  | 3908.00  | 3855.00  | 1902.00  | 2762.00  | 
    | AEBP-074       | AEBA-074           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-074       | AEBR-074           | 1               | 30000.00  | 18433.00 | 11567.00 | 3347.00  | 6765.00  | 735.00   | 2923.00  | 89.00    | 2753.00  | 597.00   | 1224.00  | 3183.00  | 3368.00  | 2975.00  | 2041.00  | 
    | AEBP-074       | AEBR-074           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-074       | AEBA-074           | 2               | 17316.53  | 971.90   | 971.58   | 780.83   | 2324.19  | 1605.12  | 1200.27  | 707.11   | 3473.34  | 3560.96  | 1223.28  | 497.95   | ?        | 
    | AEBP-074       | AEBA-074           | 3               | 16726.49  | 878.83   | 1096.54  | 2244.19  | 617.74   | 932.56   | 790.78   | 1088.23  | 3876.36  | 3819.96  | 616.12   | 765.18   | ?        | 
    #
    | AEBP-074       | AEBR-074           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-074       | AEBR-074           | 2               | 16862.59  | 176.79   | 876.80   | 278.98   | 2467.18  | 429.03   | 2048.58  | 2039.89  | 949.83   | 4083.15  | 2327.92  | 1184.44  | ?        | 
    | AEBP-074       | AEBR-074           | 3               | 16645.31  | 578.96   | 1014.00  | 248.13   | 774.27   | 1330.31  | 1571.19  | 1817.99  | 1499.62  | 5127.59  | 2169.77  | 513.48   | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 2               | 17316.53  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8561.00  | 473.34   | 3560.96  | 0.00     | 4721.23  | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 16726.49  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7648.87  | 876.36   | 3819.96  | 0.00     | 4381.30  | 0.00     | 
    #
    | AEBP-074       | AEBR-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 2               | 17172.29  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8317.25  | 949.83   | 3392.85  | 0.00     | 4512.36  | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | 16940.56  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7334.85  | 1499.62  | 3422.84  | 0.00     | 4683.25  | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 2               | -1074.82  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1074.82 | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | -1038.20  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1038.20 | 0.00     | 
    #
    | AEBP-074       | AEBR-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 2               | -565.30   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -309.70  | 0.00     | 0.00     | -255.60  | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | -547.55   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -295.25  | 0.00     | 0.00     | -252.30  | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-074       | AEBA-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBA-074           | 2               | 16241.71  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8561.00  | 473.34   | 3560.96  | 0.00     | 3646.41  | 0.00     | 
    | AEBP-074       | AEBA-074           | 3               | 15688.29  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7648.87  | 876.36   | 3819.96  | 0.00     | 3343.10  | 0.00     | 
    #
    | AEBP-074       | AEBR-074           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-074       | AEBR-074           | 2               | 16606.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8317.25  | 640.13   | 3392.85  | 0.00     | 4256.76  | 0.00     | 
    | AEBP-074       | AEBR-074           | 3               | 16393.01  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7334.85  | 1204.37  | 3422.84  | 0.00     | 4430.95  | 0.00     | 


	# Tidy Up
	And   the override date is reset

@AcceptanceTest @Withdrawn20211216
Scenario: A075 Create and approve a procured 1920 AEBP contract. Consume actuals 4x. Cap with 3% and 10% tolerance. Check financials and capping rules along the way
    Given there is no Contract, Task or Workflow data for UKPRN '10017075' 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017075' 

    # Clear down all subnominal data from CRM and PaaS
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-075      |
    | AEBR-075      |

    # Clear down PaymentSchedule.DeliverablePayment data for an allocation
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-075      |
    | AEBR-075      |

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017075' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017075 Co Ltd' with UKPRN '10017075' and OrgId 'ORG0017075' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017075' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017075 | 117075 | 10017075 Co Ltd | 0              | Active                | Yes           | AA017075      | ?             | 39 Halstead Road       | Earls Colne            | ?                      | ?                      | Colchester             | Essex                  | CO6 2NL   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017075 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017075 | 10017075 Co Ltd      | ESFA-075             | AEBP-075       | 1                     | 01/08/2019        | 31/07/2020      | 50848.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017075 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017075 | AEBP-075       | AEBA-075      | AEB-AS            | AEB-AS1920              | AY                      | 01/08/2019          | 31/07/2020        | 26135.00        |                                         |            |                                                             | New          |             |
    | 10017075 | AEBP-075       | AEBR-075      | AEB-19TRN         | AEB-19TRN1920           | AY                      | 01/08/2019          | 31/07/2020        | 24713.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |  
    | 10017075 | AEBP-075       | AEBA-075      | 1               | 0                     | 26135.00  | 17181.00  | 8954.00   | 3500.00  | 535.00   | 3010.00  | 2986.00  | 2077.00  | 1103.00  | 3040.00  | 930.00   | 1824.00  | 2843.00  | 1523.00  | 2764.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017075 | AEBP-075       | AEBR-075      | 1               | 0                     | 24713.00  | 15906.00  | 8807.00   | 2222.00  | 2513.00  | 655.00   | 3511.00  | 3329.00  | 2894.00  | 497.00   | 285.00   | 1905.00  | 3462.00  | 1510.00  | 1930.00  | 19-24 Traineeships Total Funding                                | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-075' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-075'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-075' and actual ContractNumber 'AEBP-075'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-075' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017075 | AEBP-075           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017075 | ESFA-075           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'AEBP-075'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations 
    | AllocationRef | Subnominal Code | Period | Payment Type   |
    | AEBA-075      | 2372010         | Jul-20 | Reconciliation |
    | AEBA-075      | 2372060         | Jul-20 | Reconciliation |
    | AEBA-075      | 2372016         | Jul-20 | Capping        |
    | AEBR-075      | 2355800         | Jul-20 | Reconciliation |
    | AEBR-075      | 2355860         | Jul-20 | Reconciliation |
    | AEBR-075      | 2355816         | Jul-20 | Capping        |




    # Add actuals to the contract for Jan 20. No Cap

    # Change the date
    Given the override date is '04/02/2020'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jan 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201908 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1066.79     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201908 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 558.73      |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201909 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1519.53     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201909 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1845.96     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201910 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1083.94     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201910 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 2486.98     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201911 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 820.64      |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201911 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 910.03      |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201912 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 914.49      |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201912 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1051.99     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202001 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1880.63     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202001 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1990.07     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202002 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 2219.44     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202002 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1827.03     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202003 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1410.91     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202003 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1758.01     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202004 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 2364.16     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202004 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 2072.18     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202005 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 2362.50     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202005 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 2067.17     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202006 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 570.00      |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202006 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1579.67     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202007 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 989.95      |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202007 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 560.00      |
    #
    | ILR1920        | R06                  | ORG0017075     | CM             | 201908 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 1490.83     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201908 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 744.15      |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201909 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2640.57     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201909 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 800.96      |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201910 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 414.59      |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201910 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 558.04      |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201911 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 1168.35     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201911 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1334.23     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201912 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 489.88      |
    | ILR1920        | R06                  | ORG0017075     | CM             | 201912 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1831.82     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202001 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 1773.11     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202001 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1466.66     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202002 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 1077.48     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202002 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1839.35     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202003 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2164.52     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202003 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1975.47     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202004 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 1326.97     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202004 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1688.17     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202005 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2451.19     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202005 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1841.10     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202006 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2178.25     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202006 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1314.84     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202007 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 1754.68     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202007 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1505.04     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check CRM

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 26135.00  | 17181.00 | 8954.00  | 3500.00  | 535.00   | 3010.00  | 2986.00  | 2077.00  | 1103.00  | 3040.00  | 930.00   | 1824.00  | 2843.00  | 1523.00  | 2764.00  | 
    | AEBP-075       | AEBA-075           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-075       | AEBR-075           | 1               | 24713.00  | 15906.00 | 8807.00  | 2222.00  | 2513.00  | 655.00   | 3511.00  | 3329.00  | 2894.00  | 497.00   | 285.00   | 1905.00  | 3462.00  | 1510.00  | 1930.00  | 
    | AEBP-075       | AEBR-075           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-075       | AEBA-075           | 2               | 7286.02   | 1066.79  | 1519.53  | 1083.94  | 820.64   | 914.49   | 1880.63  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-075       | AEBA-075           | 3               | 8843.76   | 558.73   | 1845.96  | 2486.98  | 910.03   | 1051.99  | 1990.07  | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | AEBP-075       | AEBR-075           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-075       | AEBR-075           | 2               | 7977.33   | 1490.83  | 2640.57  | 414.59   | 1168.35  | 489.88   | 1773.11  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-075       | AEBR-075           | 3               | 6735.86   | 744.15   | 800.96   | 558.04   | 1334.23  | 1831.82  | 1466.66  | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 2               | 7286.02   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7286.02  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 3               | 8843.76   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8843.76  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-075       | AEBR-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 2               | 7977.33   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7977.33  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 3               | 6735.86   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6735.86  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-075       | AEBR-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 2               | 7286.02   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7286.02  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 3               | 8843.76   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8843.76  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-075       | AEBR-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 2               | 7977.33   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7977.33  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 3               | 6735.86   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6735.86  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




    # Add actuals to the contract for Feb 20. Capping occurs

    # Change the date
    Given the override date is '04/03/2020'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Feb 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201908 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1066.79     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201908 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 558.73      |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201909 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1519.53     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201909 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1845.96     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201910 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1083.94     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201910 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 2486.98     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201911 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 820.64      |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201911 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 910.03      |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201912 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 914.49      |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201912 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1051.99     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202001 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1880.63     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202001 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1990.07     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202002 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 2219.44     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202002 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1827.03     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202003 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1410.91     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202003 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1758.01     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202004 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 2364.16     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202004 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 2072.18     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202005 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 2362.50     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202005 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 2067.17     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202006 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 570.00      |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202006 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1579.67     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202007 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 989.95      |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202007 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 560.00      |
    #
    | ILR1920        | R07                  | ORG0017075     | CM             | 201908 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 1490.83     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201908 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 744.15      |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201909 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2640.57     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201909 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 800.96      |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201910 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 414.59      |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201910 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 558.04      |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201911 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 1168.35     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201911 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1334.23     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201912 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 489.88      |
    | ILR1920        | R07                  | ORG0017075     | CM             | 201912 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1831.82     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202001 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 1773.11     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202001 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1466.66     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202002 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 1077.48     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202002 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1839.35     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202003 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2164.52     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202003 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1975.47     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202004 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 1326.97     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202004 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1688.17     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202005 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2451.19     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202005 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1841.10     |
    | ILR1920        | R07                  | ORG0017075     | CM             | 202006 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2178.25     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202006 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1314.84     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202007 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 1754.68     |
    | ILR1920        | R06                  | ORG0017075     | CM             | 202007 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1505.04     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check CRM

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 26135.00  | 17181.00 | 8954.00  | 3500.00  | 535.00   | 3010.00  | 2986.00  | 2077.00  | 1103.00  | 3040.00  | 930.00   | 1824.00  | 2843.00  | 1523.00  | 2764.00  | 
    | AEBP-075       | AEBA-075           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-075       | AEBR-075           | 1               | 24713.00  | 15906.00 | 8807.00  | 2222.00  | 2513.00  | 655.00   | 3511.00  | 3329.00  | 2894.00  | 497.00   | 285.00   | 1905.00  | 3462.00  | 1510.00  | 1930.00  | 
    | AEBP-075       | AEBR-075           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-075       | AEBA-075           | 2               | 9505.46   | 1066.79  | 1519.53  | 1083.94  | 820.64   | 914.49   | 1880.63  | 2219.44  | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-075       | AEBA-075           | 3               | 10670.79  | 558.73   | 1845.96  | 2486.98  | 910.03   | 1051.99  | 1990.07  | 1827.03  | ?        | ?        | ?        | ?        | ?        | 
    #
    | AEBP-075       | AEBR-075           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-075       | AEBR-075           | 2               | 9054.81   | 1490.83  | 2640.57  | 414.59   | 1168.35  | 489.88   | 1773.11  | 1077.48  | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-075       | AEBR-075           | 3               | 8575.21   | 744.15   | 800.96   | 558.04   | 1334.23  | 1831.82  | 1466.66  | 1839.35  | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 2               | 9505.46   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7286.02  | 2219.44  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 3               | 10670.79  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8843.76  | 1827.03  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-075       | AEBR-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 2               | 9054.81   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7977.33  | 1077.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 3               | 8575.21   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6735.86  | 1839.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 2               | -1411.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1411.13 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 3               | -1584.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1584.12 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-075       | AEBR-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 2               | -885.46   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -885.46  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 3               | -838.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -838.56  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 2               | 8094.33   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7286.02  | 808.31   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 3               | 9086.67   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8843.76  | 242.91   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-075       | AEBR-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 2               | 8169.35   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7977.33  | 192.02   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 3               | 7736.65   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6735.86  | 1000.79  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




    # Add actuals to the contract for Mar 20. Capping occurs and the 3%/10% tolerance kicks in.

    # Change the date
    Given the override date is '04/04/2020'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Mar 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201908 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 971.90      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201908 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 878.83      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201909 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 971.58      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201909 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1096.54     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201910 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 780.83      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201910 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 2244.19     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201911 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 2324.19     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201911 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 617.74      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201912 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1605.12     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201912 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 932.56      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202001 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1200.27     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202001 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 790.78      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202002 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 707.11      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202002 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1088.23     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202003 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 473.34      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202003 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 876.36      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202004 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1560.96     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202004 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 819.96      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202005 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1223.28     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202005 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 616.12      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202006 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 497.95      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202006 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 765.18      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202007 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1144.10     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202007 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 2109.25     |
    #
    | ILR1920        | R08                  | ORG0017075     | CM             | 201908 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 176.79      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201908 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 578.96      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201909 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 876.80      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201909 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1014.00     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201910 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 278.98      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201910 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 248.13      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201911 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2467.18     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201911 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 774.27      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201912 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 429.03      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 201912 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1330.31     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202001 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2048.58     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202001 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1571.19     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202002 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2039.89     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202002 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1817.99     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202003 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 949.83      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202003 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1499.62     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202004 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2083.15     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202004 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 2127.59     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202005 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2327.92     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202005 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 2169.77     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202006 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 1184.44     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202006 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 513.48      |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202007 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 1725.90     |
    | ILR1920        | R08                  | ORG0017075     | CM             | 202007 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1933.75     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check CRM

    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 26135.00  | 17181.00 | 8954.00  | 3500.00  | 535.00   | 3010.00  | 2986.00  | 2077.00  | 1103.00  | 3040.00  | 930.00   | 1824.00  | 2843.00  | 1523.00  | 2764.00  | 
    | AEBP-075       | AEBA-075           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-075       | AEBR-075           | 1               | 24713.00  | 15906.00 | 8807.00  | 2222.00  | 2513.00  | 655.00   | 3511.00  | 3329.00  | 2894.00  | 497.00   | 285.00   | 1905.00  | 3462.00  | 1510.00  | 1930.00  | 
    | AEBP-075       | AEBR-075           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-075       | AEBA-075           | 2               | 9034.34   | 971.90   | 971.58   | 780.83   | 2324.19  | 1605.12  | 1200.27  | 707.11   | 473.34   | ?        | ?        | ?        | ?        | 
    | AEBP-075       | AEBA-075           | 3               | 8525.23   | 878.83   | 1096.54  | 2244.19  | 617.74   | 932.56   | 790.78   | 1088.23  | 876.36   | ?        | ?        | ?        | ?        | 
    #
    | AEBP-075       | AEBR-075           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-075       | AEBR-075           | 2               | 9267.08   | 176.79   | 876.80   | 278.98   | 2467.18  | 429.03   | 2048.58  | 2039.89  | 949.83   | ?        | ?        | ?        | ?        | 
    | AEBP-075       | AEBR-075           | 3               | 8834.47   | 578.96   | 1014.00  | 248.13   | 774.27   | 1330.31  | 1571.19  | 1817.99  | 1499.62  | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 2               | 10445.47  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7286.02  | 2219.44  | 940.01   | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 3               | 10109.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8843.76  | 1827.03  | -561.44  | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-075       | AEBR-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 2               | 10152.54  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7977.33  | 1077.48  | 1097.73  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 3               | 9673.03   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6735.86  | 1839.35  | 1097.82  | 0.00     | 0.00     | 0.00     | 0.00     | 

#    # Check the CAPPING AMOUNTS in CRM on the latest approved contract - without tolerance
#    And   the Capping Amounts are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
#    | AEBP-075       | AEBA-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP-075       | AEBA-075           | 2               | -1605.90  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1411.13 | -194.77  | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP-075       | AEBA-075           | 3               | -1767.92  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1584.12 | -183.80  | 0.00     | 0.00     | 0.00     | 0.00     | 
#    #
#    | AEBP-075       | AEBR-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP-075       | AEBR-075           | 2               | -2009.47  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -885.46  | -1124.01 | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP-075       | AEBR-075           | 3               | -1910.10  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -838.56  | -1071.54 | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract - with tolerance (AEBA = 3%, AEBR = 10%)
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 2               | -1411.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1411.13 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 3               | -1584.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1584.12 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-075       | AEBR-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 2               | -1195.16  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -885.46  | -309.70  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 3               | -1133.81  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -838.56  | -295.25  | 0.00     | 0.00     | 0.00     | 0.00     | 

#    # Check the NET AMOUNTS in CRM on the latest approved contract - without tolerance
#    And   the Net Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
#    | AEBP-075       | AEBA-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP-075       | AEBA-075           | 2               | 8839.57   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7286.02  | 808.31   | 745.24   | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP-075       | AEBA-075           | 3               | 8341.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8843.76  | 242.91   | -745.24  | 0.00     | 0.00     | 0.00     | 0.00     | 
#    #
#    | AEBP-075       | AEBR-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP-075       | AEBR-075           | 2               | 8143.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7977.33  | 192.02   | -26.28   | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | AEBP-075       | AEBR-075           | 3               | 7762.93   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6735.86  | 1000.79  | 26.28    | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract - without tolerance
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 2               | 8839.57   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7286.02  | 808.31   | 940.01   | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 3               | 8341.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8843.76  | 242.91   | -561.44  | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-075       | AEBR-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 2               | 8143.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7977.33  | 192.02   | 788.03   | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 3               | 7762.93   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6735.86  | 1000.79  | 802.57   | 0.00     | 0.00     | 0.00     | 0.00     | 



    # Add actuals to the contract for Apr 20. The 10% tolerance applies from Apr-20 onwards (29738)

    # Change the date
    Given the override date is '04/05/2020'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Apr 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201908 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 971.90      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201908 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 878.83      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201909 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 971.58      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201909 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1096.54     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201910 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 780.83      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201910 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 2244.19     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201911 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 2324.19     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201911 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 617.74      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201912 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1605.12     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201912 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 932.56      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202001 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1200.27     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202001 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 790.78      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202002 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 707.11      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202002 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1088.23     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202003 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 473.34      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202003 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 876.36      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202004 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1560.96     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202004 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 1819.96     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202005 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1223.28     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202005 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 616.12      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202006 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 497.95      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202006 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 765.18      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202007 | AEB-AS1920              | AEBA-075                 | ?          | 2               | 0            | 1144.10     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202007 | AEB-AS1920              | AEBA-075                 | ?          | 3               | 0            | 2109.25     |
    #
    | ILR1920        | R09                  | ORG0017075     | CM             | 201908 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 176.79      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201908 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 578.96      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201909 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 876.80      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201909 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1014.00     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201910 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 278.98      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201910 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 248.13      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201911 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2467.18     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201911 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 774.27      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201912 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 429.03      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 201912 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1330.31     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202001 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2048.58     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202001 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1571.19     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202002 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2039.89     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202002 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1817.99     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202003 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 949.83      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202003 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1499.62     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202004 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2083.15     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202004 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 2127.59     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202005 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 2327.92     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202005 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 2169.77     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202006 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 1184.44     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202006 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 513.48      |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202007 | AEB-19TRN1920           | AEBR-075                 | ?          | 2               | 0            | 1725.90     |
    | ILR1920        | R09                  | ORG0017075     | CM             | 202007 | AEB-19TRN1920           | AEBR-075                 | ?          | 3               | 0            | 1933.75     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check CRM

    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 26135.00  | 17181.00 | 8954.00  | 3500.00  | 535.00   | 3010.00  | 2986.00  | 2077.00  | 1103.00  | 3040.00  | 930.00   | 1824.00  | 2843.00  | 1523.00  | 2764.00  | 
    | AEBP-075       | AEBA-075           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-075       | AEBR-075           | 1               | 24713.00  | 15906.00 | 8807.00  | 2222.00  | 2513.00  | 655.00   | 3511.00  | 3329.00  | 2894.00  | 497.00   | 285.00   | 1905.00  | 3462.00  | 1510.00  | 1930.00  | 
    | AEBP-075       | AEBR-075           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-075       | AEBA-075           | 2               | 10595.30  | 971.90   | 971.58   | 780.83   | 2324.19  | 1605.12  | 1200.27  | 707.11   | 473.34   | 1560.96  | ?        | ?        | ?        | 
    | AEBP-075       | AEBA-075           | 3               | 10345.19  | 878.83   | 1096.54  | 2244.19  | 617.74   | 932.56   | 790.78   | 1088.23  | 876.36   | 1819.96  | ?        | ?        | ?        | 
    #
    | AEBP-075       | AEBR-075           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-075       | AEBR-075           | 2               | 11350.23  | 176.79   | 876.80   | 278.98   | 2467.18  | 429.03   | 2048.58  | 2039.89  | 949.83   | 2083.15  | ?        | ?        | ?        | 
    | AEBP-075       | AEBR-075           | 3               | 10962.06  | 578.96   | 1014.00  | 248.13   | 774.27   | 1330.31  | 1571.19  | 1817.99  | 1499.62  | 2127.59  | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 2               | 12006.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7286.02  | 2219.44  | 940.01   | 1560.96  | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 3               | 11929.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8843.76  | 1827.03  | -561.44  | 1819.96  | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-075       | AEBR-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 2               | 12545.39  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7977.33  | 1077.48  | 1097.73  | 2392.85  | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 3               | 12095.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6735.86  | 1839.35  | 1097.82  | 2422.84  | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 2               | -1411.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1411.13 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 3               | -1584.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1584.12 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-075       | AEBR-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 2               | -1195.16  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -885.46  | -309.70  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 3               | -1133.81  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -838.56  | -295.25  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-075       | AEBA-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 2               | 10595.30  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7286.02  | 808.31   | 940.01   | 1560.96  | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBA-075           | 3               | 10345.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8843.76  | 242.91   | -561.44  | 1819.96  | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-075       | AEBR-075           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 2               | 11350.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7977.33  | 192.02   | 788.03   | 2392.85  | 0.00     | 0.00     | 0.00     | 
    | AEBP-075       | AEBR-075           | 3               | 10962.06  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6735.86  | 1000.79  | 802.57   | 2422.84  | 0.00     | 0.00     | 0.00     | 


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20211216
Scenario: A076 Create and approve a procured 1920 AEBP contract. Consume actuals 2x. Cap with 10% tolerance inc R14. Check financials and capping rules along the way
    Given there are no allocations marked as Under Termination for UKPRN '10017076' 
    And   there are no terminated or closed allocations for UKPRN '10017076' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017076' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017076' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-076      |
    | AEBR-076      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-076      |
    | AEBR-076      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-AS1920        |
    | AEB-19TRN1920     |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017076' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017076 Co Ltd' with UKPRN '10017076' and OrgId 'ORG0017076' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017076' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017076 | 117076 | 10017076 Co Ltd | 0              | Locked Restructure    | Yes           | AA017076      | ?             | 27 Sandyford Place     | Glasgow                | ?                      | ?                      | ?                      | ?                      | G3 7NG    |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017076 |




    # Change the date
    Given the override date is '31/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017076 | 10017076 Co Ltd      | ESFA-076             | AEBP-076       | 1                     | 01/08/2019        | 31/07/2020      | 23161.00      |                                       | Contract for Services                      | 1920   | New          | ORG0017076 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017076 | AEBP-076       | AEBA-076      | AEB-AS            | AEB-AS1920              | AY                      | 01/08/2019          | 31/07/2020        | 10408.00        |                                         |            |                                                             | New          |             |
    | 10017076 | AEBP-076       | AEBR-076      | AEB-19TRN         | AEB-19TRN1920           | AY                      | 01/08/2019          | 31/07/2020        | 12753.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription              | CRMIntent    | DeliveryOrg |
    | 10017076 | AEBP-076       | AEBA-076      | 1               | 0                     | 10408.00  | 0.00      | 10408.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1816.00  | 3121.00  | 1925.00  | 3546.00  | Adult Skills Total Funding          | New          |             | 
    | 10017076 | AEBP-076       | AEBR-076      | 1               | 0                     | 12753.00  | 0.00      | 12753.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2473.00  | 3239.00  | 3659.00  | 3382.00  | 19-24 Traineeships Total Funding    | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-076' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-076'   	   

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-076' and actual ContractNumber 'AEBP-076'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-076' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017076 | AEBP-076           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017076 | ESFA-076           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'AEBP-076'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | AEBA-076      | 2372010          | Jul-20 | Reconciliation |
    | AEBR-076      | 2355800          | Jul-20 | Reconciliation |



    # Add actuals to the contract. Capping to be applied at 110% of Profile

    # Change the date
    Given the override date is '04/08/2020'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Jul 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R12                  | ORG0017076     | CM             | 202004 | AEB-AS1920              | AEBA-076                 | ?          | 2               | 0            | 2139.37     |
    | ILR1920        | R12                  | ORG0017076     | CM             | 202004 | AEB-AS1920              | AEBA-076                 | ?          | 3               | 0            | 1569.01     |
    | ILR1920        | R12                  | ORG0017076     | CM             | 202005 | AEB-AS1920              | AEBA-076                 | ?          | 2               | 0            | 1023.31     |
    | ILR1920        | R12                  | ORG0017076     | CM             | 202005 | AEB-AS1920              | AEBA-076                 | ?          | 3               | 0            | 2074.53     |
    | ILR1920        | R12                  | ORG0017076     | CM             | 202006 | AEB-AS1920              | AEBA-076                 | ?          | 2               | 0            | 2147.23     |
    | ILR1920        | R12                  | ORG0017076     | CM             | 202006 | AEB-AS1920              | AEBA-076                 | ?          | 3               | 0            | 1043.82     |
    | ILR1920        | R12                  | ORG0017076     | CM             | 202007 | AEB-AS1920              | AEBA-076                 | ?          | 2               | 0            | 1328.81     |
    | ILR1920        | R12                  | ORG0017076     | CM             | 202007 | AEB-AS1920              | AEBA-076                 | ?          | 3               | 0            | 1093.33     |
    #
    | ILR1920        | R12                  | ORG0017076     | CM             | 202004 | AEB-19TRN1920           | AEBR-076                 | ?          | 2               | 0            | 1810.00     |
    | ILR1920        | R12                  | ORG0017076     | CM             | 202004 | AEB-19TRN1920           | AEBR-076                 | ?          | 3               | 0            | 1423.00     |
    | ILR1920        | R12                  | ORG0017076     | CM             | 202005 | AEB-19TRN1920           | AEBR-076                 | ?          | 2               | 0            | 1713.73     |
    | ILR1920        | R12                  | ORG0017076     | CM             | 202005 | AEB-19TRN1920           | AEBR-076                 | ?          | 3               | 0            | 2496.09     |
    | ILR1920        | R12                  | ORG0017076     | CM             | 202006 | AEB-19TRN1920           | AEBR-076                 | ?          | 2               | 0            | 2354.10     |
    | ILR1920        | R12                  | ORG0017076     | CM             | 202006 | AEB-19TRN1920           | AEBR-076                 | ?          | 3               | 0            | 2258.63     |
    | ILR1920        | R12                  | ORG0017076     | CM             | 202007 | AEB-19TRN1920           | AEBR-076                 | ?          | 2               | 0            | 1228.18     |
    | ILR1920        | R12                  | ORG0017076     | CM             | 202007 | AEB-19TRN1920           | AEBR-076                 | ?          | 3               | 0            | 1213.82     |

	# Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

	# Check CRM

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-076       | AEBA-076           | 1               | 10408.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1816.00  | 3121.00  | 1925.00  | 3546.00  | 
    | AEBP-076       | AEBA-076           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-076       | AEBA-076           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-076       | AEBR-076           | 1               | 12753.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2473.00  | 3239.00  | 3659.00  | 3382.00  | 
    | AEBP-076       | AEBR-076           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-076       | AEBR-076           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-076       | AEBA-076           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-076       | AEBA-076           | 2               | 6638.72   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 2139.37  | 1023.31  | 2147.23  | 1328.81  | 
    | AEBP-076       | AEBA-076           | 3               | 5780.69   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1569.01  | 2074.53  | 1043.82  | 1093.33  | 
    #
    | AEBP-076       | AEBR-076           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-076       | AEBR-076           | 2               | 7106.01   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1810.00  | 1713.73  | 2354.10  | 1228.18  | 
    | AEBP-076       | AEBR-076           | 3               | 7391.54   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1423.00  | 2496.09  | 2258.63  | 1213.82  | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-076       | AEBA-076           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-076       | AEBA-076           | 2               | 6638.72   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6638.72  | 
    | AEBP-076       | AEBA-076           | 3               | 5780.69   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5780.69  | 
    #
    | AEBP-076       | AEBR-076           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-076       | AEBR-076           | 2               | 7106.01   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7106.01  | 
    | AEBP-076       | AEBR-076           | 3               | 7391.54   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7391.54  | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-076       | AEBA-076           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-076       | AEBA-076           | 2               | -908.28   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -908.28  | 
    | AEBP-076       | AEBA-076           | 3               | -790.89   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -790.89  | 
    #
    | AEBP-076       | AEBR-076           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-076       | AEBR-076           | 2               | -230.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -230.00  | 
    | AEBP-076       | AEBR-076           | 3               | -239.25   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -239.25  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-076       | AEBA-076           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-076       | AEBA-076           | 2               | 5730.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5730.44  | 
    | AEBP-076       | AEBA-076           | 3               | 4989.80   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4989.80  | 
    #
    | AEBP-076       | AEBR-076           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-076       | AEBR-076           | 2               | 6876.01   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6876.01  | 
    | AEBP-076       | AEBR-076           | 3               | 7152.29   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7152.29  | 




    # Post year-end 

    # Change the date
    Given the override date is '24/10/2020'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Oct 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R14                  | ORG0017076     | CM             | 202004 | AEB-AS1920              | AEBA-076                 | ?          | 2               | 0            | 1139.37     |
    | ILR1920        | R14                  | ORG0017076     | CM             | 202004 | AEB-AS1920              | AEBA-076                 | ?          | 3               | 0            | 1569.01     |
    | ILR1920        | R14                  | ORG0017076     | CM             | 202005 | AEB-AS1920              | AEBA-076                 | ?          | 2               | 0            | 1023.31     |
    | ILR1920        | R14                  | ORG0017076     | CM             | 202005 | AEB-AS1920              | AEBA-076                 | ?          | 3               | 0            | 2074.53     |
    | ILR1920        | R14                  | ORG0017076     | CM             | 202006 | AEB-AS1920              | AEBA-076                 | ?          | 2               | 0            | 2147.23     |
    | ILR1920        | R14                  | ORG0017076     | CM             | 202006 | AEB-AS1920              | AEBA-076                 | ?          | 3               | 0            | 1043.82     |
    | ILR1920        | R14                  | ORG0017076     | CM             | 202007 | AEB-AS1920              | AEBA-076                 | ?          | 2               | 0            | 1328.81     |
    | ILR1920        | R14                  | ORG0017076     | CM             | 202007 | AEB-AS1920              | AEBA-076                 | ?          | 3               | 0            | 1093.33     |
    #
    | ILR1920        | R14                  | ORG0017076     | CM             | 202004 | AEB-19TRN1920           | AEBR-076                 | ?          | 2               | 0            | 1810.00     |
    | ILR1920        | R14                  | ORG0017076     | CM             | 202004 | AEB-19TRN1920           | AEBR-076                 | ?          | 3               | 0            | 1423.00     |
    | ILR1920        | R14                  | ORG0017076     | CM             | 202005 | AEB-19TRN1920           | AEBR-076                 | ?          | 2               | 0            | 1713.73     |
    | ILR1920        | R14                  | ORG0017076     | CM             | 202005 | AEB-19TRN1920           | AEBR-076                 | ?          | 3               | 0            | 1496.09     |
    | ILR1920        | R14                  | ORG0017076     | CM             | 202006 | AEB-19TRN1920           | AEBR-076                 | ?          | 2               | 0            | 2354.10     |
    | ILR1920        | R14                  | ORG0017076     | CM             | 202006 | AEB-19TRN1920           | AEBR-076                 | ?          | 3               | 0            | 2258.63     |
    | ILR1920        | R14                  | ORG0017076     | CM             | 202007 | AEB-19TRN1920           | AEBR-076                 | ?          | 2               | 0            | 1228.18     |
    | ILR1920        | R14                  | ORG0017076     | CM             | 202007 | AEB-19TRN1920           | AEBR-076                 | ?          | 3               | 0            | 1213.82     |

	# Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

	# Check CRM

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | AEBP-076       | AEBA-076           | 1               | 10408.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1816.00  | 3121.00  | 1925.00  | 3546.00  | ?        | 
    | AEBP-076       | AEBA-076           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | AEBP-076       | AEBA-076           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    #
    | AEBP-076       | AEBR-076           | 1               | 12753.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2473.00  | 3239.00  | 3659.00  | 3382.00  | ?        | 
    | AEBP-076       | AEBR-076           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | AEBP-076       | AEBR-076           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | AEBP-076       | AEBA-076           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-076       | AEBA-076           | 2               | 5638.72   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1139.37  | 1023.31  | 2147.23  | 1328.81  | ?        | 
    | AEBP-076       | AEBA-076           | 3               | 5780.69   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1569.01  | 2074.53  | 1043.82  | 1093.33  | ?        | 
    #
    | AEBP-076       | AEBR-076           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-076       | AEBR-076           | 2               | 7106.01   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1810.00  | 1713.73  | 2354.10  | 1228.18  | ?        | 
    | AEBP-076       | AEBR-076           | 3               | 6391.54   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1423.00  | 1496.09  | 2258.63  | 1213.82  | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | AEBP-076       | AEBA-076           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-076       | AEBA-076           | 2               | 6547.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6638.72  | -91.72   | 
    | AEBP-076       | AEBA-076           | 3               | 6571.58   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5780.69  | 790.89   | 
    #
    | AEBP-076       | AEBR-076           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-076       | AEBR-076           | 2               | 7336.01   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7106.01  | 230.00   | 
    | AEBP-076       | AEBR-076           | 3               | 6630.79   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7391.54  | -760.75  | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | AEBP-076       | AEBA-076           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-076       | AEBA-076           | 2               | -1253.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -908.28  | -345.24  | 
    | AEBP-076       | AEBA-076           | 3               | -1144.82  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -790.89  | -353.93  | 
    #
    | AEBP-076       | AEBR-076           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-076       | AEBR-076           | 2               | -230.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -230.00  | 0.00     | 
    | AEBP-076       | AEBR-076           | 3               | -239.25   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -239.25  | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | AEBP-076       | AEBA-076           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-076       | AEBA-076           | 2               | 5293.48   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5730.44  | -436.96  | 
    | AEBP-076       | AEBA-076           | 3               | 5426.76   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4989.80  | 436.96   | 
    #
    | AEBP-076       | AEBR-076           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-076       | AEBR-076           | 2               | 7106.01   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6876.01  | 230.00   | 
    | AEBP-076       | AEBR-076           | 3               | 6391.54   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7152.29  | -760.75  | 


	# Tidy Up
	And   the override date is reset
	 
	 