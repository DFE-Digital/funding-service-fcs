Feature: InitiationWithAmendment 23814

@AcceptanceTest @Withdrawn20201209
@HighValue
Scenario: A497 Create and approve a 15mth NLAP2018 contract. Consume actuals. Initiate termination (with amendment) and approve initiation. Truncate payments. Check docs, Tasks, Workflow History. Publish and approve. Check CRM, PaaS and Feed (inc capping)
    Given there are no allocations marked as Under Termination for UKPRN '10017497' 
    And   there are no terminated or closed allocations for UKPRN '10017497' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017497' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
	And   there are no files prefixed '10017497_NLAP' in the Sharepoint 'NLA-2018-Input-Appendices' folder

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017497'

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ANLP-497      |
    | YNLP-497      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017497' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017497 Co Ltd' with UKPRN '10017497' and OrgId 'ORG0017497' and has 'FCS1 Test' as a manager 
    And   UPIN '117497' is associated with UKPRN '10017497' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017497 | 117497 | 10017497 Co Ltd | 0              | Active | Yes           | AA017497      | ?             | 

    # Change the date
    And   the override date is '01/12/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017497 | 10017497 Co Ltd      | ESFA-497             | NLAP-497       | 1                     | 01/01/2018        | 31/03/2019      | 55650.00      |                                | Contract for Services | 2018   | New          | ORG0017497 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017497 | NLAP-497       | ANLP-497      | ANLAP             | ANLAP2018               | NONLEVY                 | 01/01/2018          | 31/03/2019        | 24234.00        |                                         |            |                                                             | New          |             |
    | 10017497 | NLAP-497       | YNLP-497      | 16-18NLAP         | 16-18NLAP2018           | NONLEVY                 | 01/01/2018          | 31/03/2019        | 31416.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017497 | NLAP-497       | ANLP-497      | 1               | 0                     | 24234.00  | 2299.00  | 1642.00  | 2630.00  | 3366.00  | 2141.00  | 2116.00  | 1207.00  | 234.00   | 2171.00  | 61.00    | 955.00   | 1973.00  | 654.00   | 1894.00  | 891.00   | Total Adult Non-Levy Apprenticeships Funding                    | New          |             |
    | 10017497 | NLAP-497       | YNLP-497      | 1               | 0                     | 31416.00  | 2401.00  | 543.00   | 3399.00  | 3216.00  | 2781.00  | 385.00   | 172.00   | 1793.00  | 3350.00  | 1398.00  | 1817.00  | 1541.00  | 2371.00  | 2598.00  | 3651.00  | Total 16-18 Non-Levy Apprenticeships Funding                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/12/2017'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NLAP-497' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/12/2017'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-497' and actual ContractNumber 'NLAP-497'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-497' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017497 | NLAP-497           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017497 | ESFA-497           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '150' deliverable period rows in CRM linked to the latest version of contract 'NLAP-497'




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/02/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017497'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Jan 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201808 | 16-18NLAP2018           | YNLP-497                 | ?          | 2               | 0            | 248.83      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201808 | 16-18NLAP2018           | YNLP-497                 | ?          | 3               | 0            | 340.92      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201808 | 16-18NLAP2018           | YNLP-497                 | ?          | 4               | 0            | 471.98      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201808 | 16-18NLAP2018           | YNLP-497                 | ?          | 5               | 0            | 169.28      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201809 | 16-18NLAP2018           | YNLP-497                 | ?          | 2               | 0            | 1068.40     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201809 | 16-18NLAP2018           | YNLP-497                 | ?          | 3               | 0            | 410.47      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201809 | 16-18NLAP2018           | YNLP-497                 | ?          | 4               | 0            | 1428.51     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201809 | 16-18NLAP2018           | YNLP-497                 | ?          | 5               | 0            | 1154.18     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201810 | 16-18NLAP2018           | YNLP-497                 | ?          | 2               | 0            | 900.40      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201810 | 16-18NLAP2018           | YNLP-497                 | ?          | 3               | 0            | 1304.48     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201810 | 16-18NLAP2018           | YNLP-497                 | ?          | 4               | 0            | 726.54      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201810 | 16-18NLAP2018           | YNLP-497                 | ?          | 5               | 0            | 469.97      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201811 | 16-18NLAP2018           | YNLP-497                 | ?          | 2               | 0            | 473.28      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201811 | 16-18NLAP2018           | YNLP-497                 | ?          | 3               | 0            | 575.05      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201811 | 16-18NLAP2018           | YNLP-497                 | ?          | 4               | 0            | 897.19      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201811 | 16-18NLAP2018           | YNLP-497                 | ?          | 5               | 0            | 760.90      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201812 | 16-18NLAP2018           | YNLP-497                 | ?          | 2               | 0            | 341.86      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201812 | 16-18NLAP2018           | YNLP-497                 | ?          | 3               | 0            | 495.23      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201812 | 16-18NLAP2018           | YNLP-497                 | ?          | 4               | 0            | 108.85      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201812 | 16-18NLAP2018           | YNLP-497                 | ?          | 5               | 0            | 959.27      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201901 | 16-18NLAP2018           | YNLP-497                 | ?          | 2               | 0            | 996.71      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201901 | 16-18NLAP2018           | YNLP-497                 | ?          | 3               | 0            | 730.84      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201901 | 16-18NLAP2018           | YNLP-497                 | ?          | 4               | 0            | 151.59      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201901 | 16-18NLAP2018           | YNLP-497                 | ?          | 5               | 0            | 332.35      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201902 | 16-18NLAP2018           | YNLP-497                 | ?          | 2               | 0            | 523.50      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201902 | 16-18NLAP2018           | YNLP-497                 | ?          | 3               | 0            | 1162.32     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201902 | 16-18NLAP2018           | YNLP-497                 | ?          | 4               | 0            | 771.56      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201902 | 16-18NLAP2018           | YNLP-497                 | ?          | 5               | 0            | 1479.26     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201903 | 16-18NLAP2018           | YNLP-497                 | ?          | 2               | 0            | 1012.42     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201903 | 16-18NLAP2018           | YNLP-497                 | ?          | 3               | 0            | 856.66      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201903 | 16-18NLAP2018           | YNLP-497                 | ?          | 4               | 0            | 1355.30     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201903 | 16-18NLAP2018           | YNLP-497                 | ?          | 5               | 0            | 1077.81     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201904 | 16-18NLAP2018           | YNLP-497                 | ?          | 2               | 0            | 1317.50     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201904 | 16-18NLAP2018           | YNLP-497                 | ?          | 3               | 0            | 189.23      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201904 | 16-18NLAP2018           | YNLP-497                 | ?          | 4               | 0            | 164.16      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201904 | 16-18NLAP2018           | YNLP-497                 | ?          | 5               | 0            | 581.41      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201905 | 16-18NLAP2018           | YNLP-497                 | ?          | 2               | 0            | 1366.02     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201905 | 16-18NLAP2018           | YNLP-497                 | ?          | 3               | 0            | 515.69      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201905 | 16-18NLAP2018           | YNLP-497                 | ?          | 4               | 0            | 918.73      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201905 | 16-18NLAP2018           | YNLP-497                 | ?          | 5               | 0            | 465.93      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201906 | 16-18NLAP2018           | YNLP-497                 | ?          | 2               | 0            | 1217.88     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201906 | 16-18NLAP2018           | YNLP-497                 | ?          | 3               | 0            | 1393.84     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201906 | 16-18NLAP2018           | YNLP-497                 | ?          | 4               | 0            | 133.06      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201906 | 16-18NLAP2018           | YNLP-497                 | ?          | 5               | 0            | 426.57      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201907 | 16-18NLAP2018           | YNLP-497                 | ?          | 2               | 0            | 474.98      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201907 | 16-18NLAP2018           | YNLP-497                 | ?          | 3               | 0            | 955.49      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201907 | 16-18NLAP2018           | YNLP-497                 | ?          | 4               | 0            | 1399.22     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201907 | 16-18NLAP2018           | YNLP-497                 | ?          | 5               | 0            | 1324.74     |
    #
    | ILR1819        | R06                  | ORG0017497     | CM             | 201808 | ANLAP2018               | ANLP-497                 | ?          | 2               | 0            | 840.58      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201808 | ANLAP2018               | ANLP-497                 | ?          | 3               | 0            | 828.38      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201808 | ANLAP2018               | ANLP-497                 | ?          | 4               | 0            | 621.52      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201808 | ANLAP2018               | ANLP-497                 | ?          | 5               | 0            | 484.94      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201809 | ANLAP2018               | ANLP-497                 | ?          | 2               | 0            | 628.67      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201809 | ANLAP2018               | ANLP-497                 | ?          | 3               | 0            | 207.99      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201809 | ANLAP2018               | ANLP-497                 | ?          | 4               | 0            | 1000.98     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201809 | ANLAP2018               | ANLP-497                 | ?          | 5               | 0            | 1341.64     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201810 | ANLAP2018               | ANLP-497                 | ?          | 2               | 0            | 823.38      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201810 | ANLAP2018               | ANLP-497                 | ?          | 3               | 0            | 1479.49     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201810 | ANLAP2018               | ANLP-497                 | ?          | 4               | 0            | 369.66      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201810 | ANLAP2018               | ANLP-497                 | ?          | 5               | 0            | 1036.12     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201811 | ANLAP2018               | ANLP-497                 | ?          | 2               | 0            | 288.31      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201811 | ANLAP2018               | ANLP-497                 | ?          | 3               | 0            | 789.52      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201811 | ANLAP2018               | ANLP-497                 | ?          | 4               | 0            | 1275.07     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201811 | ANLAP2018               | ANLP-497                 | ?          | 5               | 0            | 763.40      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201812 | ANLAP2018               | ANLP-497                 | ?          | 2               | 0            | 1125.95     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201812 | ANLAP2018               | ANLP-497                 | ?          | 3               | 0            | 1368.16     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201812 | ANLAP2018               | ANLP-497                 | ?          | 4               | 0            | 414.50      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201812 | ANLAP2018               | ANLP-497                 | ?          | 5               | 0            | 1069.08     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201901 | ANLAP2018               | ANLP-497                 | ?          | 2               | 0            | 387.01      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201901 | ANLAP2018               | ANLP-497                 | ?          | 3               | 0            | 600.73      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201901 | ANLAP2018               | ANLP-497                 | ?          | 4               | 0            | 819.45      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201901 | ANLAP2018               | ANLP-497                 | ?          | 5               | 0            | 296.19      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201902 | ANLAP2018               | ANLP-497                 | ?          | 2               | 0            | 329.84      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201902 | ANLAP2018               | ANLP-497                 | ?          | 3               | 0            | 1249.75     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201902 | ANLAP2018               | ANLP-497                 | ?          | 4               | 0            | 589.93      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201902 | ANLAP2018               | ANLP-497                 | ?          | 5               | 0            | 382.13      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201903 | ANLAP2018               | ANLP-497                 | ?          | 2               | 0            | 829.76      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201903 | ANLAP2018               | ANLP-497                 | ?          | 3               | 0            | 626.71      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201903 | ANLAP2018               | ANLP-497                 | ?          | 4               | 0            | 178.93      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201903 | ANLAP2018               | ANLP-497                 | ?          | 5               | 0            | 405.52      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201904 | ANLAP2018               | ANLP-497                 | ?          | 2               | 0            | 538.46      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201904 | ANLAP2018               | ANLP-497                 | ?          | 3               | 0            | 1114.02     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201904 | ANLAP2018               | ANLP-497                 | ?          | 4               | 0            | 226.71      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201904 | ANLAP2018               | ANLP-497                 | ?          | 5               | 0            | 283.02      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201905 | ANLAP2018               | ANLP-497                 | ?          | 2               | 0            | 1193.40     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201905 | ANLAP2018               | ANLP-497                 | ?          | 3               | 0            | 1436.87     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201905 | ANLAP2018               | ANLP-497                 | ?          | 4               | 0            | 1145.23     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201905 | ANLAP2018               | ANLP-497                 | ?          | 5               | 0            | 616.30      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201906 | ANLAP2018               | ANLP-497                 | ?          | 2               | 0            | 1077.11     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201906 | ANLAP2018               | ANLP-497                 | ?          | 3               | 0            | 885.09      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201906 | ANLAP2018               | ANLP-497                 | ?          | 4               | 0            | 252.48      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201906 | ANLAP2018               | ANLP-497                 | ?          | 5               | 0            | 1488.84     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201907 | ANLAP2018               | ANLP-497                 | ?          | 2               | 0            | 1426.66     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201907 | ANLAP2018               | ANLP-497                 | ?          | 3               | 0            | 1085.03     |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201907 | ANLAP2018               | ANLP-497                 | ?          | 4               | 0            | 456.90      |
    | ILR1819        | R06                  | ORG0017497     | CM             | 201907 | ANLAP2018               | ANLP-497                 | ?          | 5               | 0            | 212.81      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service




	# Check Financials

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-497       | ANLP-497        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-497       | ANLP-497        | 2               | 4093.90  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 840.58   | 628.67   | 823.38   | 288.31   | 1125.95  | 387.01   | ?        | ?        | 
    | NLAP-497       | ANLP-497        | 3               | 5274.27  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 828.38   | 207.99   | 1479.49  | 789.52   | 1368.16  | 600.73   | ?        | ?        | 
    | NLAP-497       | ANLP-497        | 4               | 4501.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 621.52   | 1000.98  | 369.66   | 1275.07  | 414.50   | 819.45   | ?        | ?        | 
    | NLAP-497       | ANLP-497        | 5               | 4991.37  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 484.94   | 1341.64  | 1036.12  | 763.40   | 1069.08  | 296.19   | ?        | ?        | 
    #
    | NLAP-497       | YNLP-497        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-497       | YNLP-497        | 2               | 4029.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 248.83   | 1068.40  | 900.40   | 473.28   | 341.86   | 996.71   | ?        | ?        | 
    | NLAP-497       | YNLP-497        | 3               | 3856.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 340.92   | 410.47   | 1304.48  | 575.05   | 495.23   | 730.84   | ?        | ?        | 
    | NLAP-497       | YNLP-497        | 4               | 3784.66  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 471.98   | 1428.51  | 726.54   | 897.19   | 108.85   | 151.59   | ?        | ?        | 
    | NLAP-497       | YNLP-497        | 5               | 3845.95  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 169.28   | 1154.18  | 469.97   | 760.90   | 959.27   | 332.35   | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-497       | ANLP-497        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-497       | ANLP-497        | 2               | 4093.90  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4093.90  | ?        | ?        | 
    | NLAP-497       | ANLP-497        | 3               | 5274.27  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5274.27  | ?        | ?        | 
    | NLAP-497       | ANLP-497        | 4               | 4501.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4501.18  | ?        | ?        | 
    | NLAP-497       | ANLP-497        | 5               | 4991.37  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4991.37  | ?        | ?        | 
    #
    | NLAP-497       | YNLP-497        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-497       | YNLP-497        | 2               | 4029.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4029.48  | ?        | ?        | 
    | NLAP-497       | YNLP-497        | 3               | 3856.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3856.99  | ?        | ?        | 
    | NLAP-497       | YNLP-497        | 4               | 3784.66  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3784.66  | ?        | ?        | 
    | NLAP-497       | YNLP-497        | 5               | 3845.95  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3845.95  | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-497       | ANLP-497        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-497       | ANLP-497        | 2               | -523.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -523.40  | ?        | ?        | 
    | NLAP-497       | ANLP-497        | 3               | -674.32  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -674.32  | ?        | ?        | 
    | NLAP-497       | ANLP-497        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-497       | ANLP-497        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    #
    | NLAP-497       | YNLP-497        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-497       | YNLP-497        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-497       | YNLP-497        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-497       | YNLP-497        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-497       | YNLP-497        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-497       | ANLP-497        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-497       | ANLP-497        | 2               | 3570.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3570.50  | ?        | ?        | 
    | NLAP-497       | ANLP-497        | 3               | 4599.95  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4599.95  | ?        | ?        | 
    | NLAP-497       | ANLP-497        | 4               | 4501.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4501.18  | ?        | ?        | 
    | NLAP-497       | ANLP-497        | 5               | 4991.37  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4991.37  | ?        | ?        | 
    #
    | NLAP-497       | YNLP-497        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-497       | YNLP-497        | 2               | 4029.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4029.48  | ?        | ?        | 
    | NLAP-497       | YNLP-497        | 3               | 3856.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3856.99  | ?        | ?        | 
    | NLAP-497       | YNLP-497        | 4               | 3784.66  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3784.66  | ?        | ?        | 
    | NLAP-497       | YNLP-497        | 5               | 3845.95  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3845.95  | ?        | ?        | 




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '08/02/2019'

    # Request termination of the contract via the CRM UI
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'NLAP-497' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 22/10/2018               | 22/10/2018              | Yes                         | Provider in Liquidation | ?                       |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ANLP-497         | 22/10/2018                  | 22/10/2018                |
    | YNLP-497         | 22/10/2018                  | 22/10/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'NLAP-497' for UKPRN '10017497'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017497 - 10017497 Co Ltd     | NLAP-497       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017497 | NLAP-497            | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017497 | ESFA-497            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | NLAP-497       | 1                     | 0                        | 22/10/2018              | ?                       |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | ANLP-497         | 1                     | 0                        | 22/10/2018        | 22/10/2018                |
    | YNLP-497         | 1                     | 0                        | 22/10/2018        | 22/10/2018                |

#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'NLAP-497' for provider '10017497'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017497 - 10017497 Co Ltd     | NLAP-497       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'NLAP-497' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | ?                                |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '12/02/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'NLAP-497' for provider '10017497' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'NLAP-497' for provider '10017497'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017497 - 10017497 Co Ltd      | NLAP-497       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'NLAP-497' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | ?                                |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017497 | NLAP-497            | 2                     | 0                        | Draft          | Awaiting Documentation                   | True          | False               | 01/01/2018        | 31/03/2019      | Notification  |
    | 10017497 | NLAP-497            | 1                     | 0                        | Approved       | Under Termination                        | False         | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017497 | ESFA-497            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

   # Check the deliverable count in CRM on v2 contains just the legal deliverables (2 allocs * 1 deliverable * 15 months)
   And   there are '30' deliverable period rows in CRM linked to the latest version of contract 'NLAP-497'

	


    # Check contracts docs in Sharepoint

    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017497' for FundingType 'NLA' and period '2018' and Delivery Organisation '11749701'
    Then  I retrieve the latest contract details from CRM for provider '10017497' for FundingType 'NLA' and period '2018'
    
    # Check that document appendices exist in Sharepoint
    And   a file for this contract exists in sharepoint location 'NLA-2018-Input-Appendices'

	# Check the contents of Appendix 1 (Summary of Funding)
    And   the pdf file contains the following page lines in order
	"""
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017497 Co Ltd UKPRN: 10017497
    Master Contract Number: ESFA-497
    Allocation
    Contract Ref Jan 18 – Mar 18 Apr 18 – Mar 19 Apr 19 – Mar 20 Total
    16-18 Non-Levy Apprenticeships YNLP-497 £6,343 £25,073 £0 £31,416
    Adult Non-Levy Apprenticeships ANLP-497 £6,571 £17,663 £0 £24,234
    Total Funding for this contract: £55,650 

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017497 Co Ltd UKPRN: 10017497
    Master Contract Ref: ESFA-497 Start Date: 01/01/2018 End Date: 31/03/2019
    Contract Ref: YNLP-497
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    16-18 Non-Levy Apprenticeships £31,416 £2,401 £543 £3,399
    Total Funding £31,416 £2,401 £543 £3,399
    Ref (for internal use only):  NLAP-497 v2
    Page 1 of 2 of this Funding Agreement

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017497 Co Ltd UKPRN: 10017497
    Master Contract Ref: ESFA-497 Start Date: 01/01/2018 End Date: 31/03/2019
    Contract Ref: YNLP-497
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    16-18 Non-Levy Apprenticeships £3,216 £2,781 £385 £172 £1,793 £3,350 £1,398 £1,817 £1,541 £2,371 £2,598 £3,651
    Total Funding £3,216 £2,781 £385 £172 £1,793 £3,350 £1,398 £1,817 £1,541 £2,371 £2,598 £3,651
    Ref (for internal use only):  NLAP-497 v2
    Page 2 of 2 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017497 Co Ltd UKPRN: 10017497
    Master Contract Ref: ESFA-497 Start Date: 01/01/2018 End Date: 31/03/2019
    Contract Ref: ANLP-497
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    Adult Non-Levy Apprenticeships £24,234 £2,299 £1,642 £2,630
    Total Funding £24,234 £2,299 £1,642 £2,630
    Ref (for internal use only):  NLAP-497 v2
    Page 1 of 2 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017497 Co Ltd UKPRN: 10017497
    Master Contract Ref: ESFA-497 Start Date: 01/01/2018 End Date: 31/03/2019
    Contract Ref: ANLP-497
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    Adult Non-Levy Apprenticeships £3,366 £2,141 £2,116 £1,207 £234 £2,171 £61 £955 £1,973 £654 £1,894 £891
    Total Funding £3,366 £2,141 £2,116 £1,207 £234 £2,171 £61 £955 £1,973 £654 £1,894 £891
    Ref (for internal use only):  NLAP-497 v2
    Page 2 of 2 of this Funding Agreement
    """




	# Check Workflow History

    # Check the WORKFLOW HISTORY for v2
    Then  the workflow history on contract 'NLAP-497' version '2' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Non-Financial Amendment Created                | CRM Integration     | ?                                |

    # Check the WORKFLOW HISTORY for v1
    Then  the workflow history on contract 'NLAP-497' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Initiate Non-Financial Amendment (Notify)      | CRM Integration     | ?                                |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | ?                                |
	
	
	
	
	# Check for an open Task
	
	# Is there an open Task for the Document Management Team ?
    Then  the following Tasks are present against version '2' of contract 'NLAP-497' for provider '10017497'
    | Task                                       | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge                    | 10017497 - 10017497 Co Ltd Awaiting documentation           | NLAP-497       | Document Management Team  | ?                        | Open            | Not Started      |




	# Publish and approve v2 of the Contract
	
	# Change the date
    Given the override date is '03/03/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NLAP-497' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '04/03/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-497' and actual ContractNumber 'NLAP-497'

    # Check contract sub-status
    Then  the latest version of contract 'NLAP-497' is showing as 'Under Termination'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017497 | NLAP-497           | 2                     | 0                        | Approved         | Under Termination         | True          | True                | 01/01/2018        | 31/03/2019      | Notification  |
    | 10017497 | NLAP-497           | 1                     | 0                        | Replaced         | Under Termination         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |
    | 10017497 | ESFA-497           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '150' deliverable period rows in CRM linked to the latest version of contract 'NLAP-497'




    # Have the financials been brought forward to v2 of the contract ?

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-497       | ANLP-497        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | ANLP-497        | 2               | 2292.63  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 840.58   | 628.67   | 823.38   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | ANLP-497        | 3               | 2515.86  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 828.38   | 207.99   | 1479.49  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | ANLP-497        | 4               | 1992.16  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 621.52   | 1000.98  | 369.66   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | ANLP-497        | 5               | 2862.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 484.94   | 1341.64  | 1036.12  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    #
    | NLAP-497       | YNLP-497        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | YNLP-497        | 2               | 2217.63  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 248.83   | 1068.40  | 900.40   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | YNLP-497        | 3               | 2055.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 340.92   | 410.47   | 1304.48  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | YNLP-497        | 4               | 2627.03  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 471.98   | 1428.51  | 726.54   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | YNLP-497        | 5               | 1793.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 169.28   | 1154.18  | 469.97   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
	
    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-497       | ANLP-497        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | ANLP-497        | 2               | 2816.03  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4093.90  | -1277.87 | ?        | 
    | NLAP-497       | ANLP-497        | 3               | 3190.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5274.27  | -2084.09 | ?        | 
    | NLAP-497       | ANLP-497        | 4               | 1992.16  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4501.18  | -2509.02 | ?        | 
    | NLAP-497       | ANLP-497        | 5               | 2862.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4991.37  | -2128.67 | ?        | 
    #
    | NLAP-497       | YNLP-497        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | YNLP-497        | 2               | 2217.63  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4029.48  | -1811.85 | ?        | 
    | NLAP-497       | YNLP-497        | 3               | 2055.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3856.99  | -1801.12 | ?        | 
    | NLAP-497       | YNLP-497        | 4               | 2627.03  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3784.66  | -1157.63 | ?        | 
    | NLAP-497       | YNLP-497        | 5               | 1793.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3845.95  | -2052.52 | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-497       | ANLP-497        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | ANLP-497        | 2               | -523.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -523.40  | 0.00     | ?        | 
    | NLAP-497       | ANLP-497        | 3               | -674.32  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -674.32  | 0.00     | ?        | 
    | NLAP-497       | ANLP-497        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | ANLP-497        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    #
    | NLAP-497       | YNLP-497        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | YNLP-497        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | YNLP-497        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | YNLP-497        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | YNLP-497        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-497       | ANLP-497        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | ANLP-497        | 2               | 2292.63  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3570.50  | -1277.87 | ?        | 
    | NLAP-497       | ANLP-497        | 3               | 2515.86  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4599.95  | -2084.09 | ?        | 
    | NLAP-497       | ANLP-497        | 4               | 1992.16  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4501.18  | -2509.02 | ?        | 
    | NLAP-497       | ANLP-497        | 5               | 2862.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4991.37  | -2128.67 | ?        | 
    #
    | NLAP-497       | YNLP-497        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NLAP-497       | YNLP-497        | 2               | 2217.63  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4029.48  | -1811.85 | ?        | 
    | NLAP-497       | YNLP-497        | 3               | 2055.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3856.99  | -1801.12 | ?        | 
    | NLAP-497       | YNLP-497        | 4               | 2627.03  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3784.66  | -1157.63 | ?        | 
    | NLAP-497       | YNLP-497        | 5               | 1793.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3845.95  | -2052.52 | ?        | 


    # Tidy up
	And   the override date is reset
    
@AcceptanceTest @Withdrawn20201209
Scenario: A498 Create and approve an 1819 procured AEB contract. Initiate termination (with amendment) and approve initiation. Delete amendment. Confirm termination. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017498' 
    And   there are no terminated or closed allocations for UKPRN '10017498' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017498' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBC-498      |
    | AEBT-498      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017498' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017498 Co Ltd' with UKPRN '10017498' and OrgId 'ORG0017498' and has 'FCS1 Test' as a manager 
    And   UPIN '117498' is associated with UKPRN '10017498' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017498 | 117498 | 10017498 Co Ltd | 0              | Active | Yes           | AA017498      | ?             | 

    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017498 | 10017498 Co Ltd      | ESFA-498             | AEBP-498       | 1                     | 01/08/2018        | 31/07/2019      | 40467.00      |                                | Contract for Services | 1819   | New          | ORG0017498 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017498 | AEBP-498       | AEBC-498      | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 22174.00        |                                         |            |                                                             | New          |             |
    | 10017498 | AEBP-498       | AEBT-498      | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 18293.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017498 | AEBP-498       | AEBC-498      | 1               | 0                     | 22174.00  | 2414.00  | 1757.00  | 2745.00  | 3481.00  | 2256.00  | 2231.00  | 1322.00  | 349.00   | 2286.00  | 175.00   | 1070.00  | 2088.00  | Adult Education Budget - Community Learning                     | New          |             |
    | 10017498 | AEBP-498       | AEBT-498      | 1               | 0                     | 18293.00  | 2844.00  | 384.00   | 3081.00  | 3373.00  | 1515.00  | 670.00   | 487.00   | 52.00    | 1357.00  | 1144.00  | 2765.00  | 621.00   | Adult Education - Traineeships and Other Learning Total Funding | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-498' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-498' and actual ContractNumber 'AEBP-498'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-498' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017498 | AEBP-498           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017498 | ESFA-498           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '84' deliverable period rows in CRM linked to the latest version of contract 'AEBP-498'




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '23/03/2019'

    # Request termination of the contract via the CRM UI
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'AEBP-498' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 25/08/2018               | 10/09/2018              | Yes                         | Notice from Provider    | ?                       |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | AEBC-498         | 03/08/2018                  | 18/08/2018                |
    | AEBT-498         | 24/08/2018                  | 28/08/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'AEBP-498' for UKPRN '10017498'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017498 - 10017498 Co Ltd     | AEBP-498       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017498 | AEBP-498            | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017498 | ESFA-498            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | AEBP-498       | 1                     | 0                        | 10/09/2018              | ?                       |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | AEBC-498         | 1                     | 0                        | 03/08/2018        | 18/08/2018                |
    | AEBT-498         | 1                     | 0                        | 24/08/2018        | 28/08/2018                |

    
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'AEBP-498' for provider '10017498'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017498 - 10017498 Co Ltd     | AEBP-498       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'AEBP-498' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | ?                                |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '26/03/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'AEBP-498' for provider '10017498' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'AEBP-498' for provider '10017498'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017498 - 10017498 Co Ltd      | AEBP-498       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'AEBP-498' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | ?                                |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017498 | AEBP-498            | 2                     | 0                        | Draft          | Awaiting Documentation                   | True          | False               | 01/08/2018        | 31/07/2019      | Notification  |
    | 10017498 | AEBP-498            | 1                     | 0                        | Approved       | Under Termination                        | False         | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017498 | ESFA-498            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

	# Check that the contract docs have been deleted from Sharepoint
    And   there is '1' file prefixed '10017498_AEBP-498_v2' in the Sharepoint 'AEB-1819-Input-Appendices' folder




    # Delete v2

    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
   #When  a request is initiated in CRM to delete the following contracts
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017498 | AEBP-498       | 2                     | 0                  |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017498 | AEBP-498       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017498 | ESFA-498       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
	
	# Check that the contract docs have been deleted from Sharepoint
    And   there are '0' files prefixed '10017498_AEBP-498_v2' in the Sharepoint 'AEB-1819-Input-Appendices' folder




    # Complete the Termination

    # Change the date (This is ignored by CRM)
    Given the override date is '22/06/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination (23893)
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'AEBP-498' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract 'AEBP-498' Version '1' SubVersion '0' via SDK

    # Has a 'Terminate Contract' Workflow History entry been created ?
    Then  the workflow history on contract 'AEBP-498' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Terminate Contract                             | FCS8 Test           | ?                                |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | ?                                |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017498 | AEBP-498       | 1                     | 0                        | Closed         | Terminated                               | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017498 | ESFA-498       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |


    # Tidy up
    And   the override date is reset 

@AcceptanceTest @Withdrawn20201209
Scenario: A501 Create and approve an 1819 Loans contract. Initiate termination (with amendment) and approve initiation. Publish and withdraw amendment. Confirm termination. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017501' 
    And   there are no terminated or closed allocations for UKPRN '10017501' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017501' 
	And   there are no notifications of type 'Contract Withdrawn'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-501      |
    | CLP-501       |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017501' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017501 Co Ltd' with UKPRN '10017501' and OrgId 'ORG0017501' and has 'FCS1 Test' as a manager 
    And   UPIN '117501' is associated with UKPRN '10017501' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017501 | 117501 | 10017501 Co Ltd | 0              | Active | Yes           | AA017501      | ?             | 

    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017501 | 10017501 Co Ltd      | ESFA-501             | LOANS-501      | 1                     | 01/08/2018        | 31/07/2019      | 52199.00      |                                | Contract for Services | 1819   | New          | ORG0017501 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017501 | LOANS-501      | ALLF-501      | ALLF              | ALLF1819                | AY                      | 01/08/2018          | 31/07/2019        | 26607.00        |                                         |            |                                                             | New          |             |
    | 10017501 | LOANS-501      | CLP-501       | CLP               | CLP1819                 | AY                      | 01/08/2018          | 31/07/2019        | 25592.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017501 | LOANS-501      | ALLF-501      | 5               | 0                     | 26607.00  | 3092.00  | 2435.00  | 3423.00  | 458.00   | 2934.00  | 2909.00  | 2000.00  | 1026.00  | 2963.00  | 853.00   | 1748.00  | 2766.00  | Advanced Learner Loans Facility                                 | New          |             |
    | 10017501 | LOANS-501      | CLP-501       | 1               | 0                     | 25592.00  | 985.00   | 2225.00  | 1222.00  | 1514.00  | 3357.00  | 2512.00  | 2329.00  | 1894.00  | 3199.00  | 2986.00  | 906.00   | 2463.00  | Career Learning Pilots                                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'LOANS-501' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-501' and actual ContractNumber 'LOANS-501'

    # Check that the contract is now approved
    Then  the latest version of contract 'LOANS-501' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017501 | LOANS-501          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017501 | ESFA-501           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '60' deliverable period rows in CRM linked to the latest version of contract 'LOANS-501'




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '07/03/2019'

    # Request termination of the contract via the CRM UI
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'LOANS-501' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 09/09/2018               | 24/09/2018              | Yes                         | Contract Novation       | ?                       |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ALLF-501         | 05/09/2018                  | 20/09/2018                |
    | CLP-501          | 06/09/2018                  | 21/09/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'LOANS-501' for UKPRN '10017501'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017501 - 10017501 Co Ltd     | LOANS-501      | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017501 | LOANS-501           | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017501 | ESFA-501            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | LOANS-501      | 1                     | 0                        | 24/09/2018              | ?                       |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | ALLF-501         | 1                     | 0                        | 05/09/2018        | 20/09/2018                |
    | CLP-501          | 1                     | 0                        | 06/09/2018        | 21/09/2018                |

    
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'LOANS-501' for provider '10017501'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017501 - 10017501 Co Ltd     | LOANS-501      | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'LOANS-501' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | ?                                |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '10/03/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'LOANS-501' for provider '10017501' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'LOANS-501' for provider '10017501'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017501 - 10017501 Co Ltd      | LOANS-501      | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'LOANS-501' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | ?                                |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017501 | LOANS-501           | 2                     | 0                        | Draft          | Awaiting Documentation                   | True          | False               | 01/08/2018        | 31/07/2019      | Notification  |
    | 10017501 | LOANS-501           | 1                     | 0                        | Approved       | Under Termination                        | False         | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017501 | ESFA-501            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

	# Check that the contract docs have been deleted from Sharepoint
    And   there is '1' file prefixed '10017501_LOANS-501_v2' in the Sharepoint 'LOANS-1819-Input-Appendices' folder




    # Publish then withdraw v2
    
    # Change the date
    Given the override date is '21/03/2019'

	# Publish v2
	And   the latest version of contract 'LOANS-501' is in a state of 'Published to Provider'

    # Withdraw v2
    When  the next action performed on the latest version of contract 'LOANS-501' is 'Withdraw On Behalf Of Provider' with reason 'Test A501' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017501 | LOANS-501          | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2018        | 31/07/2019      | Notification  |
    | 10017501 | LOANS-501          | 1                     | 0                        | Approved         | Under Termination         | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017501 | ESFA-501           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
	



    # Complete the Termination

    # Change the date (This is ignored by CRM)
    Given the override date is '06/05/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination (23893)
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'LOANS-501' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract 'LOANS-501' Version '1' SubVersion '0' via SDK 

    # Has a 'Terminate Contract' Workflow History entry been created ?
    Then  the workflow history on contract 'LOANS-501' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Terminate Contract                             | FCS8 Test           | ?                                |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | ?                                |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017501 | LOANS-501          | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2018        | 31/07/2019      | Notification  |
    | 10017501 | LOANS-501          | 1                     | 0                        | Closed           | Terminated                | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017501 | ESFA-501           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |



    # Tidy up
    And   the override date is reset 

