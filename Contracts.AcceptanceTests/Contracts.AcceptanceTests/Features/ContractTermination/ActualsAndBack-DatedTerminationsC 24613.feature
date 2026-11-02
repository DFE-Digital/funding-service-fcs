Feature: ActualsAndBack-DatedTerminationsC 24613

@AcceptanceTest @Withdrawn20230123
Scenario: A858 Mo Scenario1. Create and approve an NLAP2018 contract. Consume actuals. Initiate termination and approve initiation. Amend termination date Oct>Nov>Dec and check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017858' 
    And   there are no terminated or closed allocations for UKPRN '10017858' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017858' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ANLP-858      |
    | YNLP-858      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017858' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017858 Co Ltd' with UKPRN '10017858' and OrgId 'ORG0017858' and has 'FCS1 Test' as a manager 
    And   UPIN '117858' is associated with UKPRN '10017858' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017858 | 117858 | 10017858 Co Ltd | 0              | Active | Yes           | AA017858      | ?             | 

    # Change the date
    And   the override date is '01/12/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017858 | 10017858 Co Ltd      | ESFA-858             | NLAP-858       | 1                     | 01/01/2018        | 31/03/2019      | 58251.00      |                                | Contract for Services | 2018   | New          | ORG0017858 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017858 | NLAP-858       | ANLP-858      | ANLAP             | ANLAP2018               | NONLEVY                 | 01/01/2018          | 31/03/2019        | 28204.00        |                                         |            |                                                             | New          |             |
    | 10017858 | NLAP-858       | YNLP-858      | 16-18NLAP         | 16-18NLAP2018           | NONLEVY                 | 01/01/2018          | 31/03/2019        | 30047.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017858 | NLAP-858       | ANLP-858      | 1               | 0                     | 28204.00  | 657.00   | 1393.00  | 167.00   | 143.00   | 2934.00  | 1961.00  | 197.00   | 1788.00  | 2682.00  | 3700.00  | 2381.00  | 3621.00  | 2618.00  | 2910.00  | 1052.00  | Total Adult Non-Levy Apprenticeships Funding                    | New          |             |
    | 10017858 | NLAP-858       | YNLP-858      | 1               | 0                     | 30047.00  | 586.00   | 403.00   | 3669.00  | 1273.00  | 1060.00  | 2681.00  | 537.00   | 2286.00  | 2706.00  | 2429.00  | 3259.00  | 3487.00  | 838.00   | 2365.00  | 2468.00  | Total 16-18 Non-Levy Apprenticeships Funding                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NLAP-858' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-858' and actual ContractNumber 'NLAP-858'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-858' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017858 | NLAP-858           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017858 | ESFA-858           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '150' deliverable period rows in CRM linked to the latest version of contract 'NLAP-858'




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/01/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017858'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Dec 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201808 | 16-18NLAP2018           | YNLP-858                 | ?          | 2               | 0            | 1337.16     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201808 | 16-18NLAP2018           | YNLP-858                 | ?          | 3               | 0            | 111.26      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201808 | 16-18NLAP2018           | YNLP-858                 | ?          | 4               | 0            | 629.96      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201808 | 16-18NLAP2018           | YNLP-858                 | ?          | 5               | 0            | 763.30      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201809 | 16-18NLAP2018           | YNLP-858                 | ?          | 2               | 0            | 457.54      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201809 | 16-18NLAP2018           | YNLP-858                 | ?          | 3               | 0            | 1004.56     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201809 | 16-18NLAP2018           | YNLP-858                 | ?          | 4               | 0            | 736.76      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201809 | 16-18NLAP2018           | YNLP-858                 | ?          | 5               | 0            | 832.88      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201810 | 16-18NLAP2018           | YNLP-858                 | ?          | 2               | 0            | 828.82      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201810 | 16-18NLAP2018           | YNLP-858                 | ?          | 3               | 0            | 1300.63     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201810 | 16-18NLAP2018           | YNLP-858                 | ?          | 4               | 0            | 168.82      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201810 | 16-18NLAP2018           | YNLP-858                 | ?          | 5               | 0            | 525.91      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201811 | 16-18NLAP2018           | YNLP-858                 | ?          | 2               | 0            | 1132.09     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201811 | 16-18NLAP2018           | YNLP-858                 | ?          | 3               | 0            | 1193.70     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201811 | 16-18NLAP2018           | YNLP-858                 | ?          | 4               | 0            | 1230.96     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201811 | 16-18NLAP2018           | YNLP-858                 | ?          | 5               | 0            | 1065.44     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201812 | 16-18NLAP2018           | YNLP-858                 | ?          | 2               | 0            | 1285.75     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201812 | 16-18NLAP2018           | YNLP-858                 | ?          | 3               | 0            | 1366.10     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201812 | 16-18NLAP2018           | YNLP-858                 | ?          | 4               | 0            | 563.73      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201812 | 16-18NLAP2018           | YNLP-858                 | ?          | 5               | 0            | 1067.25     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201901 | 16-18NLAP2018           | YNLP-858                 | ?          | 2               | 0            | 629.86      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201901 | 16-18NLAP2018           | YNLP-858                 | ?          | 3               | 0            | 1435.08     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201901 | 16-18NLAP2018           | YNLP-858                 | ?          | 4               | 0            | 802.83      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201901 | 16-18NLAP2018           | YNLP-858                 | ?          | 5               | 0            | 761.82      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201902 | 16-18NLAP2018           | YNLP-858                 | ?          | 2               | 0            | 660.56      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201902 | 16-18NLAP2018           | YNLP-858                 | ?          | 3               | 0            | 149.75      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201902 | 16-18NLAP2018           | YNLP-858                 | ?          | 4               | 0            | 188.42      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201902 | 16-18NLAP2018           | YNLP-858                 | ?          | 5               | 0            | 966.12      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201903 | 16-18NLAP2018           | YNLP-858                 | ?          | 2               | 0            | 1114.41     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201903 | 16-18NLAP2018           | YNLP-858                 | ?          | 3               | 0            | 137.95      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201903 | 16-18NLAP2018           | YNLP-858                 | ?          | 4               | 0            | 724.56      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201903 | 16-18NLAP2018           | YNLP-858                 | ?          | 5               | 0            | 1005.53     |
    #
    | ILR1819        | R05                  | ORG0017858     | CM             | 201808 | ANLAP2018               | ANLP-858                 | ?          | 2               | 0            | 602.78      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201808 | ANLAP2018               | ANLP-858                 | ?          | 3               | 0            | 403.08      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201808 | ANLAP2018               | ANLP-858                 | ?          | 4               | 0            | 1288.51     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201808 | ANLAP2018               | ANLP-858                 | ?          | 5               | 0            | 1185.70     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201809 | ANLAP2018               | ANLP-858                 | ?          | 2               | 0            | 396.20      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201809 | ANLAP2018               | ANLP-858                 | ?          | 3               | 0            | 370.99      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201809 | ANLAP2018               | ANLP-858                 | ?          | 4               | 0            | 890.18      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201809 | ANLAP2018               | ANLP-858                 | ?          | 5               | 0            | 1414.43     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201810 | ANLAP2018               | ANLP-858                 | ?          | 2               | 0            | 158.78      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201810 | ANLAP2018               | ANLP-858                 | ?          | 3               | 0            | 1486.91     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201810 | ANLAP2018               | ANLP-858                 | ?          | 4               | 0            | 881.46      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201810 | ANLAP2018               | ANLP-858                 | ?          | 5               | 0            | 173.54      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201811 | ANLAP2018               | ANLP-858                 | ?          | 2               | 0            | 1032.56     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201811 | ANLAP2018               | ANLP-858                 | ?          | 3               | 0            | 762.23      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201811 | ANLAP2018               | ANLP-858                 | ?          | 4               | 0            | 515.61      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201811 | ANLAP2018               | ANLP-858                 | ?          | 5               | 0            | 840.77      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201812 | ANLAP2018               | ANLP-858                 | ?          | 2               | 0            | 671.85      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201812 | ANLAP2018               | ANLP-858                 | ?          | 3               | 0            | 1471.46     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201812 | ANLAP2018               | ANLP-858                 | ?          | 4               | 0            | 1256.64     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201812 | ANLAP2018               | ANLP-858                 | ?          | 5               | 0            | 161.60      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201901 | ANLAP2018               | ANLP-858                 | ?          | 2               | 0            | 1227.68     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201901 | ANLAP2018               | ANLP-858                 | ?          | 3               | 0            | 399.04      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201901 | ANLAP2018               | ANLP-858                 | ?          | 4               | 0            | 238.64      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201901 | ANLAP2018               | ANLP-858                 | ?          | 5               | 0            | 871.18      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201902 | ANLAP2018               | ANLP-858                 | ?          | 2               | 0            | 882.10      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201902 | ANLAP2018               | ANLP-858                 | ?          | 3               | 0            | 636.30      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201902 | ANLAP2018               | ANLP-858                 | ?          | 4               | 0            | 875.26      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201902 | ANLAP2018               | ANLP-858                 | ?          | 5               | 0            | 866.17      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201903 | ANLAP2018               | ANLP-858                 | ?          | 2               | 0            | 1132.63     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201903 | ANLAP2018               | ANLP-858                 | ?          | 3               | 0            | 928.24      |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201903 | ANLAP2018               | ANLP-858                 | ?          | 4               | 0            | 1418.96     |
    | ILR1819        | R05                  | ORG0017858     | CM             | 201903 | ANLAP2018               | ANLP-858                 | ?          | 5               | 0            | 926.64      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service 




	# Check CRM

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-858       | ANLP-858        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 2               | 2862.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 602.78   | 396.20   | 158.78   | 1032.56  | 671.85   | ?        | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 3               | 4494.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 403.08   | 370.99   | 1486.91  | 762.23   | 1471.46  | ?        | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 4               | 4832.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1288.51  | 890.18   | 881.46   | 515.61   | 1256.64  | ?        | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 5               | 3776.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1185.70  | 1414.43  | 173.54   | 840.77   | 161.60   | ?        | ?        | ?        | 
    #
    | NLAP-858       | YNLP-858        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 2               | 5041.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1337.16  | 457.54   | 828.82   | 1132.09  | 1285.75  | ?        | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 3               | 4976.25  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 111.26   | 1004.56  | 1300.63  | 1193.70  | 1366.10  | ?        | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 4               | 3330.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 629.96   | 736.76   | 168.82   | 1230.96  | 563.73   | ?        | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 5               | 4254.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 763.30   | 832.88   | 525.91   | 1065.44  | 1067.25  | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-858       | ANLP-858        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 2               | 2862.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2862.17  | ?        | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 3               | 4494.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4494.67  | ?        | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 4               | 4832.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4832.40  | ?        | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 5               | 3776.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3776.04  | ?        | ?        | ?        | 
    #
    | NLAP-858       | YNLP-858        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 2               | 5041.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5041.36  | ?        | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 3               | 4976.25  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4976.25  | ?        | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 4               | 3330.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3330.23  | ?        | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 5               | 4254.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4254.78  | ?        | ?        | ?        | 




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '12/01/2019'

    # Request termination of the contract
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'NLAP-858' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 14/10/2018               | 14/10/2018              | No                          | Notice from Provider    | Company sold            |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ANLP-858         | 14/10/2018                  | 14/10/2018                |
    | YNLP-858         | 14/10/2018                  | 14/10/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task
    Given the following Tasks are created against version '1' of contract 'NLAP-858' for UKPRN '10017858'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017858 - 10017858 Co Ltd     | NLAP-858       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017858 | NLAP-858            | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017858 | ESFA-858            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '13/01/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'NLAP-858' for provider '10017858' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'NLAP-858' for provider '10017858'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017858 - 10017858 Co Ltd      | NLAP-858       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'NLAP-858' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Company sold                     |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017858 | NLAP-858            | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017858 | ESFA-858            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Check CRM
	
    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-858       | ANLP-858        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 2               | 1157.76  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 602.78   | 396.20   | 158.78   | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 3               | 2260.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 403.08   | 370.99   | 1486.91  | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 4               | 3060.15  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1288.51  | 890.18   | 881.46   | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 5               | 2773.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1185.70  | 1414.43  | 173.54   | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    #
    | NLAP-858       | YNLP-858        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 2               | 2623.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1337.16  | 457.54   | 828.82   | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 3               | 2416.45  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 111.26   | 1004.56  | 1300.63  | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 4               | 1535.54  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 629.96   | 736.76   | 168.82   | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 5               | 2122.09  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 763.30   | 832.88   | 525.91   | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-858       | ANLP-858        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 2               | 1157.76  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2862.17  | -1704.41 | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 3               | 2260.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4494.67  | -2233.69 | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 4               | 3060.15  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4832.40  | -1772.25 | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 5               | 2773.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3776.04  | -1002.37 | ?        | ?        | 
    #
    | NLAP-858       | YNLP-858        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 2               | 2623.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5041.36  | -2417.84 | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 3               | 2416.45  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4976.25  | -2559.80 | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 4               | 1535.54  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3330.23  | -1794.69 | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 5               | 2122.09  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4254.78  | -2132.69 | ?        | ?        | 




    # Initiate UPDATE TERMINATION DETAILS (Oct to Nov)

    # Change the date
    Given the override date is '14/01/2019'

    # Issue an 'Update termination details' request (23812)
    When  CRM user 'FCS8 Test' updates contract termination details for Contract 'NLAP-858' Version '1' SubVersion '0' with the following options
    | ContractTerminationDate | TerminationReason        | TerminationComments     |
    | 16/11/2018              | Notice from Provider     | Company sold            |

    And   with the following updated allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ANLP-858         | 16/11/2018                  | 16/11/2018                |
    | YNLP-858         | 16/11/2018                  | 16/11/2018                |

    # Use either the CRM UI (slow) or the SDK (fast) to amend the termination details
#   And   the user completes the termination amendment request via UI
    And   the user completes the termination amendment request via SDK

    # Has a 'Termination Details Update Successful' Workflow History entry been created ?
    Then  the workflow history on contract 'NLAP-858' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Details Update Successful          | CRM Integration     | ?                                |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017858 | NLAP-858            | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017858 | ESFA-858            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Check CRM
	
    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-858       | ANLP-858        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 2               | 2190.32  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 602.78   | 396.20   | 158.78   | 1032.56  | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 3               | 3023.21  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 403.08   | 370.99   | 1486.91  | 762.23   | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 4               | 3575.76  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1288.51  | 890.18   | 881.46   | 515.61   | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 5               | 3614.44  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1185.70  | 1414.43  | 173.54   | 840.77   | 0.00     | 0.00     | ?        | ?        | 
    #
    | NLAP-858       | YNLP-858        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 2               | 3755.61  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1337.16  | 457.54   | 828.82   | 1132.09  | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 3               | 3610.15  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 111.26   | 1004.56  | 1300.63  | 1193.70  | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 4               | 2766.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 629.96   | 736.76   | 168.82   | 1230.96  | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 5               | 3187.53  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 763.30   | 832.88   | 525.91   | 1065.44  | 0.00     | 0.00     | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-858       | ANLP-858        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 2               | 2190.32  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2862.17  | -671.85  | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 3               | 3023.21  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4494.67  | -1471.46 | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 4               | 3575.76  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4832.40  | -1256.64 | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 5               | 3614.44  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3776.04  | -161.60  | ?        | ?        | 
    #
    | NLAP-858       | YNLP-858        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 2               | 3755.61  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5041.36  | -1285.75 | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 3               | 3610.15  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4976.25  | -1366.10 | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 4               | 2766.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3330.23  | -563.73  | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 5               | 3187.53  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4254.78  | -1067.25 | ?        | ?        | 




    # Initiate UPDATE TERMINATION DETAILS (Nov to Dec)

    # Change the date
    Given the override date is '15/01/2019'

    # Issue an 'Update termination details' request (23812)
    When  CRM user 'FCS8 Test' updates contract termination details for Contract 'NLAP-858' Version '1' SubVersion '0' with the following options
    | ContractTerminationDate | TerminationReason        | TerminationComments     |
    | 18/12/2018              | Notice from Provider     | Company sold            |

    And   with the following updated allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ANLP-858         | 18/12/2018                  | 18/12/2018                |
    | YNLP-858         | 18/12/2018                  | 18/12/2018                |

    # Use either the CRM UI (slow) or the SDK (fast) to amend the termination details
#   And   the user completes the termination amendment request via UI
    And   the user completes the termination amendment request via SDK

    # Has a 'Termination Details Update Successful' Workflow History entry been created ?
    Then  the workflow history on contract 'NLAP-858' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Details Update Successful          | CRM Integration     | ?                                |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017858 | NLAP-858            | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017858 | ESFA-858            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Check CRM

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-858       | ANLP-858        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 2               | 2862.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 602.78   | 396.20   | 158.78   | 1032.56  | 671.85   | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 3               | 4494.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 403.08   | 370.99   | 1486.91  | 762.23   | 1471.46  | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 4               | 4832.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1288.51  | 890.18   | 881.46   | 515.61   | 1256.64  | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 5               | 3776.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1185.70  | 1414.43  | 173.54   | 840.77   | 161.60   | 0.00     | ?        | ?        | 
    #
    | NLAP-858       | YNLP-858        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 2               | 5041.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1337.16  | 457.54   | 828.82   | 1132.09  | 1285.75  | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 3               | 4976.25  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 111.26   | 1004.56  | 1300.63  | 1193.70  | 1366.10  | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 4               | 3330.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 629.96   | 736.76   | 168.82   | 1230.96  | 563.73   | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 5               | 4254.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 763.30   | 832.88   | 525.91   | 1065.44  | 1067.25  | 0.00     | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-858       | ANLP-858        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 2               | 2862.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2862.17  | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 3               | 4494.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4494.67  | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 4               | 4832.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4832.40  | 0.00     | ?        | ?        | 
    | NLAP-858       | ANLP-858        | 5               | 3776.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3776.04  | 0.00     | ?        | ?        | 
    #
    | NLAP-858       | YNLP-858        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 2               | 5041.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5041.36  | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 3               | 4976.25  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4976.25  | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 4               | 3330.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3330.23  | 0.00     | ?        | ?        | 
    | NLAP-858       | YNLP-858        | 5               | 4254.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4254.78  | 0.00     | ?        | ?        | 


	# Tidy up
	And  the override date is reset

@AcceptanceTest @Withdrawn20230123
Scenario: A859 Mo Scenario2. Create and approve an NLAP2018 contract. Consume actuals. Initiate termination and approve initiation. Amend termination date Sep>Dec>Oct and check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017859' 
    And   there are no terminated or closed allocations for UKPRN '10017859' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017859' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ANLP-859      |
    | YNLP-859      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017859' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017859 Co Ltd' with UKPRN '10017859' and OrgId 'ORG0017859' and has 'FCS1 Test' as a manager 
    And   UPIN '117859' is associated with UKPRN '10017859' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017859 | 117859 | 10017859 Co Ltd | 0              | Active | Yes           | AA017859      | ?             | 

    # Change the date
    And   the override date is '01/12/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017859 | 10017859 Co Ltd      | ESFA-859             | NLAP-859       | 1                     | 01/01/2018        | 31/03/2019      | 58251.00      |                                | Contract for Services | 2018   | New          | ORG0017859 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017859 | NLAP-859       | ANLP-859      | ANLAP             | ANLAP2018               | NONLEVY                 | 01/01/2018          | 31/03/2019        | 28204.00        |                                         |            |                                                             | New          |             |
    | 10017859 | NLAP-859       | YNLP-859      | 16-18NLAP         | 16-18NLAP2018           | NONLEVY                 | 01/01/2018          | 31/03/2019        | 30047.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017859 | NLAP-859       | ANLP-859      | 1               | 0                     | 28204.00  | 657.00   | 1393.00  | 167.00   | 143.00   | 2934.00  | 1961.00  | 197.00   | 1788.00  | 2682.00  | 3700.00  | 2381.00  | 3621.00  | 2618.00  | 2910.00  | 1052.00  | Total Adult Non-Levy Apprenticeships Funding                    | New          |             |
    | 10017859 | NLAP-859       | YNLP-859      | 1               | 0                     | 30047.00  | 586.00   | 403.00   | 3669.00  | 1273.00  | 1060.00  | 2681.00  | 537.00   | 2286.00  | 2706.00  | 2429.00  | 3259.00  | 3487.00  | 838.00   | 2365.00  | 2468.00  | Total 16-18 Non-Levy Apprenticeships Funding                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NLAP-859' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-859' and actual ContractNumber 'NLAP-859'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-859' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017859 | NLAP-859           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017859 | ESFA-859           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '150' deliverable period rows in CRM linked to the latest version of contract 'NLAP-859'




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/01/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017859'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Dec 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201808 | 16-18NLAP2018           | YNLP-859                 | ?          | 2               | 0            | 1337.16     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201808 | 16-18NLAP2018           | YNLP-859                 | ?          | 3               | 0            | 111.26      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201808 | 16-18NLAP2018           | YNLP-859                 | ?          | 4               | 0            | 629.96      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201808 | 16-18NLAP2018           | YNLP-859                 | ?          | 5               | 0            | 763.30      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201809 | 16-18NLAP2018           | YNLP-859                 | ?          | 2               | 0            | 457.54      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201809 | 16-18NLAP2018           | YNLP-859                 | ?          | 3               | 0            | 1004.56     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201809 | 16-18NLAP2018           | YNLP-859                 | ?          | 4               | 0            | 736.76      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201809 | 16-18NLAP2018           | YNLP-859                 | ?          | 5               | 0            | 832.88      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201810 | 16-18NLAP2018           | YNLP-859                 | ?          | 2               | 0            | 828.82      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201810 | 16-18NLAP2018           | YNLP-859                 | ?          | 3               | 0            | 1300.63     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201810 | 16-18NLAP2018           | YNLP-859                 | ?          | 4               | 0            | 168.82      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201810 | 16-18NLAP2018           | YNLP-859                 | ?          | 5               | 0            | 525.91      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201811 | 16-18NLAP2018           | YNLP-859                 | ?          | 2               | 0            | 1132.09     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201811 | 16-18NLAP2018           | YNLP-859                 | ?          | 3               | 0            | 1193.70     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201811 | 16-18NLAP2018           | YNLP-859                 | ?          | 4               | 0            | 1230.96     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201811 | 16-18NLAP2018           | YNLP-859                 | ?          | 5               | 0            | 1065.44     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201812 | 16-18NLAP2018           | YNLP-859                 | ?          | 2               | 0            | 1285.75     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201812 | 16-18NLAP2018           | YNLP-859                 | ?          | 3               | 0            | 1366.10     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201812 | 16-18NLAP2018           | YNLP-859                 | ?          | 4               | 0            | 563.73      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201812 | 16-18NLAP2018           | YNLP-859                 | ?          | 5               | 0            | 1067.25     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201901 | 16-18NLAP2018           | YNLP-859                 | ?          | 2               | 0            | 629.86      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201901 | 16-18NLAP2018           | YNLP-859                 | ?          | 3               | 0            | 1435.08     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201901 | 16-18NLAP2018           | YNLP-859                 | ?          | 4               | 0            | 802.83      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201901 | 16-18NLAP2018           | YNLP-859                 | ?          | 5               | 0            | 761.82      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201902 | 16-18NLAP2018           | YNLP-859                 | ?          | 2               | 0            | 660.56      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201902 | 16-18NLAP2018           | YNLP-859                 | ?          | 3               | 0            | 149.75      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201902 | 16-18NLAP2018           | YNLP-859                 | ?          | 4               | 0            | 188.42      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201902 | 16-18NLAP2018           | YNLP-859                 | ?          | 5               | 0            | 966.12      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201903 | 16-18NLAP2018           | YNLP-859                 | ?          | 2               | 0            | 1114.41     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201903 | 16-18NLAP2018           | YNLP-859                 | ?          | 3               | 0            | 137.95      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201903 | 16-18NLAP2018           | YNLP-859                 | ?          | 4               | 0            | 724.56      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201903 | 16-18NLAP2018           | YNLP-859                 | ?          | 5               | 0            | 1005.53     |
    #
    | ILR1819        | R05                  | ORG0017859     | CM             | 201808 | ANLAP2018               | ANLP-859                 | ?          | 2               | 0            | 602.78      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201808 | ANLAP2018               | ANLP-859                 | ?          | 3               | 0            | 403.08      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201808 | ANLAP2018               | ANLP-859                 | ?          | 4               | 0            | 1288.51     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201808 | ANLAP2018               | ANLP-859                 | ?          | 5               | 0            | 1185.70     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201809 | ANLAP2018               | ANLP-859                 | ?          | 2               | 0            | 396.20      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201809 | ANLAP2018               | ANLP-859                 | ?          | 3               | 0            | 370.99      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201809 | ANLAP2018               | ANLP-859                 | ?          | 4               | 0            | 890.18      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201809 | ANLAP2018               | ANLP-859                 | ?          | 5               | 0            | 1414.43     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201810 | ANLAP2018               | ANLP-859                 | ?          | 2               | 0            | 158.78      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201810 | ANLAP2018               | ANLP-859                 | ?          | 3               | 0            | 1486.91     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201810 | ANLAP2018               | ANLP-859                 | ?          | 4               | 0            | 881.46      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201810 | ANLAP2018               | ANLP-859                 | ?          | 5               | 0            | 173.54      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201811 | ANLAP2018               | ANLP-859                 | ?          | 2               | 0            | 1032.56     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201811 | ANLAP2018               | ANLP-859                 | ?          | 3               | 0            | 762.23      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201811 | ANLAP2018               | ANLP-859                 | ?          | 4               | 0            | 515.61      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201811 | ANLAP2018               | ANLP-859                 | ?          | 5               | 0            | 840.77      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201812 | ANLAP2018               | ANLP-859                 | ?          | 2               | 0            | 671.85      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201812 | ANLAP2018               | ANLP-859                 | ?          | 3               | 0            | 1471.46     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201812 | ANLAP2018               | ANLP-859                 | ?          | 4               | 0            | 1256.64     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201812 | ANLAP2018               | ANLP-859                 | ?          | 5               | 0            | 161.60      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201901 | ANLAP2018               | ANLP-859                 | ?          | 2               | 0            | 1227.68     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201901 | ANLAP2018               | ANLP-859                 | ?          | 3               | 0            | 399.04      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201901 | ANLAP2018               | ANLP-859                 | ?          | 4               | 0            | 238.64      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201901 | ANLAP2018               | ANLP-859                 | ?          | 5               | 0            | 871.18      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201902 | ANLAP2018               | ANLP-859                 | ?          | 2               | 0            | 882.10      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201902 | ANLAP2018               | ANLP-859                 | ?          | 3               | 0            | 636.30      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201902 | ANLAP2018               | ANLP-859                 | ?          | 4               | 0            | 875.26      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201902 | ANLAP2018               | ANLP-859                 | ?          | 5               | 0            | 866.17      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201903 | ANLAP2018               | ANLP-859                 | ?          | 2               | 0            | 1132.63     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201903 | ANLAP2018               | ANLP-859                 | ?          | 3               | 0            | 928.24      |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201903 | ANLAP2018               | ANLP-859                 | ?          | 4               | 0            | 1418.96     |
    | ILR1819        | R05                  | ORG0017859     | CM             | 201903 | ANLAP2018               | ANLP-859                 | ?          | 5               | 0            | 926.64      |

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service




    # Check CRM

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-859       | ANLP-859        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 2               | 2862.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 602.78   | 396.20   | 158.78   | 1032.56  | 671.85   | ?        | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 3               | 4494.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 403.08   | 370.99   | 1486.91  | 762.23   | 1471.46  | ?        | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 4               | 4832.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1288.51  | 890.18   | 881.46   | 515.61   | 1256.64  | ?        | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 5               | 3776.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1185.70  | 1414.43  | 173.54   | 840.77   | 161.60   | ?        | ?        | ?        | 
    #
    | NLAP-859       | YNLP-859        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 2               | 5041.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1337.16  | 457.54   | 828.82   | 1132.09  | 1285.75  | ?        | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 3               | 4976.25  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 111.26   | 1004.56  | 1300.63  | 1193.70  | 1366.10  | ?        | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 4               | 3330.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 629.96   | 736.76   | 168.82   | 1230.96  | 563.73   | ?        | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 5               | 4254.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 763.30   | 832.88   | 525.91   | 1065.44  | 1067.25  | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-859       | ANLP-859        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 2               | 2862.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2862.17  | ?        | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 3               | 4494.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4494.67  | ?        | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 4               | 4832.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4832.40  | ?        | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 5               | 3776.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3776.04  | ?        | ?        | ?        | 
    #
    | NLAP-859       | YNLP-859        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 2               | 5041.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5041.36  | ?        | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 3               | 4976.25  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4976.25  | ?        | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 4               | 3330.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3330.23  | ?        | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 5               | 4254.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4254.78  | ?        | ?        | ?        | 




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '12/01/2019'

    # Request termination of the contract 
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'NLAP-859' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 14/09/2018               | 14/09/2018              | No                          | Notice from Provider    | Company sold            |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ANLP-859         | 14/09/2018                  | 14/09/2018                |
    | YNLP-859         | 14/09/2018                  | 14/09/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task
    Given the following Tasks are created against version '1' of contract 'NLAP-859' for UKPRN '10017859'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017859 - 10017859 Co Ltd     | NLAP-859       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017859 | NLAP-859            | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017859 | ESFA-859            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '13/01/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'NLAP-859' for provider '10017859' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'NLAP-859' for provider '10017859'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017859 - 10017859 Co Ltd      | NLAP-859       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'NLAP-859' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Company sold                     |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017859 | NLAP-859            | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017859 | ESFA-859            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Check CRM
	
    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-859       | ANLP-859        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 2               | 998.98   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 602.78   | 396.20   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 3               | 774.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 403.08   | 370.99   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 4               | 2178.69  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1288.51  | 890.18   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 5               | 2600.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1185.70  | 1414.43  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    #
    | NLAP-859       | YNLP-859        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 2               | 1794.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1337.16  | 457.54   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 3               | 1115.82  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 111.26   | 1004.56  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 4               | 1366.72  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 629.96   | 736.76   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 5               | 1596.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 763.30   | 832.88   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-859       | ANLP-859        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 2               | 998.98   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2862.17  | -1863.19 | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 3               | 774.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4494.67  | -3720.60 | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 4               | 2178.69  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4832.40  | -2653.71 | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 5               | 2600.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3776.04  | -1175.91 | ?        | ?        | 
    #
    | NLAP-859       | YNLP-859        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 2               | 1794.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5041.36  | -3246.66 | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 3               | 1115.82  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4976.25  | -3860.43 | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 4               | 1366.72  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3330.23  | -1963.51 | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 5               | 1596.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4254.78  | -2658.60 | ?        | ?        | 




    # Initiate UPDATE TERMINATION DETAILS (Sep to Dec)

    # Change the date
    Given the override date is '14/01/2019'

    # Issue an 'Update termination details' request (23812)
    When  CRM user 'FCS8 Test' updates contract termination details for Contract 'NLAP-859' Version '1' SubVersion '0' with the following options
    | ContractTerminationDate | TerminationReason        | TerminationComments     |
    | 16/12/2018              | Notice from Provider     | Company sold            |

    And   with the following updated allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ANLP-859         | 16/12/2018                  | 16/12/2018                |
    | YNLP-859         | 16/12/2018                  | 16/12/2018                |

    # Use either the CRM UI (slow) or the SDK (fast) to amend the termination details
#   And   the user completes the termination amendment request via UI
    And   the user completes the termination amendment request via SDK

    # Has a 'Termination Details Update Successful' Workflow History entry been created ?
    Then  the workflow history on contract 'NLAP-859' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Details Update Successful          | CRM Integration     | ?                                |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017859 | NLAP-859            | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017859 | ESFA-859            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Check CRM
	
    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-859       | ANLP-859        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 2               | 2862.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 602.78   | 396.20   | 158.78   | 1032.56  | 671.85   | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 3               | 4494.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 403.08   | 370.99   | 1486.91  | 762.23   | 1471.46  | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 4               | 4832.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1288.51  | 890.18   | 881.46   | 515.61   | 1256.64  | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 5               | 3776.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1185.70  | 1414.43  | 173.54   | 840.77   | 161.60   | 0.00     | ?        | ?        | 
    #
    | NLAP-859       | YNLP-859        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 2               | 5041.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1337.16  | 457.54   | 828.82   | 1132.09  | 1285.75  | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 3               | 4976.25  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 111.26   | 1004.56  | 1300.63  | 1193.70  | 1366.10  | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 4               | 3330.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 629.96   | 736.76   | 168.82   | 1230.96  | 563.73   | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 5               | 4254.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 763.30   | 832.88   | 525.91   | 1065.44  | 1067.25  | 0.00     | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-859       | ANLP-859        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 2               | 2862.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2862.17  | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 3               | 4494.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4494.67  | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 4               | 4832.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4832.40  | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 5               | 3776.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3776.04  | 0.00     | ?        | ?        | 
    #
    | NLAP-859       | YNLP-859        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 2               | 5041.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5041.36  | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 3               | 4976.25  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4976.25  | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 4               | 3330.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3330.23  | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 5               | 4254.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4254.78  | 0.00     | ?        | ?        | 




    # Initiate UPDATE TERMINATION DETAILS (Dec to Oct)

    # Change the date
    Given the override date is '15/01/2019'

    # Issue an 'Update termination details' request (23812)
    When  CRM user 'FCS8 Test' updates contract termination details for Contract 'NLAP-859' Version '1' SubVersion '0' with the following options
    | ContractTerminationDate | TerminationReason        | TerminationComments     |
    | 18/10/2018              | Notice from Provider     | Company sold            |

    And   with the following updated allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ANLP-859         | 18/10/2018                  | 18/10/2018                |
    | YNLP-859         | 18/10/2018                  | 18/10/2018                |

    # Use either the CRM UI (slow) or the SDK (fast) to amend the termination details
#   And   the user completes the termination amendment request via UI
    And   the user completes the termination amendment request via SDK

    # Has a 'Termination Details Update Successful' Workflow History entry been created ?
    Then  the workflow history on contract 'NLAP-859' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Details Update Successful          | CRM Integration     | ?                                |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017859 | NLAP-859            | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017859 | ESFA-859            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Check CRM

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-859       | ANLP-859        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 2               | 1157.76  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 602.78   | 396.20   | 158.78   | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 3               | 2260.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 403.08   | 370.99   | 1486.91  | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 4               | 3060.15  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1288.51  | 890.18   | 881.46   | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 5               | 2773.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1185.70  | 1414.43  | 173.54   | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    #
    | NLAP-859       | YNLP-859        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 2               | 2623.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1337.16  | 457.54   | 828.82   | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 3               | 2416.45  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 111.26   | 1004.56  | 1300.63  | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 4               | 1535.54  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 629.96   | 736.76   | 168.82   | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 5               | 2122.09  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 763.30   | 832.88   | 525.91   | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-859       | ANLP-859        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 2               | 1157.76  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2862.17  | -1704.41 | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 3               | 2260.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4494.67  | -2233.69 | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 4               | 3060.15  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4832.40  | -1772.25 | ?        | ?        | 
    | NLAP-859       | ANLP-859        | 5               | 2773.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3776.04  | -1002.37 | ?        | ?        | 
    #
    | NLAP-859       | YNLP-859        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 2               | 2623.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5041.36  | -2417.84 | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 3               | 2416.45  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4976.25  | -2559.80 | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 4               | 1535.54  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3330.23  | -1794.69 | ?        | ?        | 
    | NLAP-859       | YNLP-859        | 5               | 2122.09  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4254.78  | -2132.69 | ?        | ?        | 


	# Tidy up
	And  the override date is reset

