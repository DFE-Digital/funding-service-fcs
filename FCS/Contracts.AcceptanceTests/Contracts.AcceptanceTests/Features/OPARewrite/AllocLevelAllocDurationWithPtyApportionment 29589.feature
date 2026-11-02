Feature: AllocLevelAllocDurationWithPtyApportionment 29589

@AcceptanceTest @Withdrawn20211216
@Story29589
Scenario: A822 OPA Rewrite. Create and approve an EDSK contract with an APPS1920 allocation. Consume actuals and Cap Group1 only. Bulk amend and approve. Release some Cap. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017822' 
    And   there are no terminated or closed allocations for UKPRN '10017822' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017822' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017822' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | APPS-822      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | APPS-822      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | APPS1920          |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017822' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017822 Co Ltd' with UKPRN '10017822' and OrgId 'ORG0017822' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017822' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017822 | 117822 | 10017822 Co Ltd | 0              | Active                | Yes           | AA017822      | ?             | 1 Church Mews          | ?                      | ?                      | ?                      | Clophill               | Bedfordshire           | MK45 4BQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017822 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017822 | 10017822 Co Ltd      | ESFA-822             | EDSK-822       | 1                     | 01/08/2019        | 31/07/2020      | 20668.00      |                                       | Conditions of Funding (Grant) (SPI)        | 1920   | New          | ORG0017822 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName            | UoPCode  | AllocationDescription      | CRMIntent    | DeliveryOrg |
    | 10017822 | EDSK-822       | APPS-822      | APPS              | APPS1920                | AY                      | 01/08/2019          | 31/07/2020        | 20668.00        |                    |          |                            | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                  | CRMIntent    | DeliveryOrg |
    | 10017822 | EDSK-822       | APPS-822      | 1               | 0                     | 20668.00  | 3012.00  | 500.00   | 1221.00  | 1711.00  | 3605.00  | 777.00   | 1804.00  | 3741.00  | 875.00   | 1022.00  | 1413.00  | 987.00   | Apprenticeships Carry-In Total Funding  | New          |             | 


    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-822' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-822'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-822' and actual ContractNumber 'EDSK-822'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-822' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017822 | EDSK-822           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017822 | ESFA-822           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '288' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract 'EDSK-822'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | APPS-822      | 2240100          | Jul-20 | Reconciliation |




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/02/2020'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017822'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jan 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS33               | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 8               | 0            | 294.88      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 9               | 0            | 617.62      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 10              | 0            | 211.83      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 22              | 0            | 414.48      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 23              | 0            | 1169.21     |
    | APPS           | APPS33               | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 24              | 0            | 261.41      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 8               | 0            | 728.19      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 9               | 0            | 660.09      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 10              | 0            | 280.19      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 22              | 0            | 1335.04     |
    | APPS           | APPS33               | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 23              | 0            | 1137.56     |
    | APPS           | APPS33               | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 24              | 0            | 1122.97     |
    | APPS           | APPS33               | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 8               | 0            | 358.50      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 9               | 0            | 734.03      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 10              | 0            | 130.77      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 22              | 0            | 143.09      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 23              | 0            | 336.94      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 24              | 0            | 747.49      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 8               | 0            | 252.05      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 9               | 0            | 92.29       |
    | APPS           | APPS33               | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 10              | 0            | 422.33      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 22              | 0            | 942.45      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 23              | 0            | 463.79      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 24              | 0            | 317.15      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 8               | 0            | 517.39      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 9               | 0            | 198.24      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 10              | 0            | 223.51      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 22              | 0            | 406.71      |
    | APPS           | APPS33               | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 23              | 0            | 1092.61     |
    | APPS           | APPS33               | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 24              | 0            | 490.88      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 8               | 0            | 640.65      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 9               | 0            | 1220.08     |
    | APPS           | APPS33               | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 10              | 0            | 1008.15     |
    | APPS           | APPS33               | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 22              | 0            | 1227.45     |
    | APPS           | APPS33               | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 23              | 0            | 1131.53     |
    | APPS           | APPS33               | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 24              | 0            | 395.85      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 8               | 0            | 685.65      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 9               | 0            | 930.41      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 10              | 0            | 966.13      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 22              | 0            | 211.51      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 23              | 0            | 830.21      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 24              | 0            | 672.09      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 8               | 0            | 165.06      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 9               | 0            | 692.79      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 10              | 0            | 1302.15     |
    | APPS           | APPS33               | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 22              | 0            | 858.97      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 23              | 0            | 746.38      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 24              | 0            | 1473.03     |
    | APPS           | APPS33               | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 8               | 0            | 138.95      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 9               | 0            | 1166.08     |
    | APPS           | APPS33               | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 10              | 0            | 1322.47     |
    | APPS           | APPS33               | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 22              | 0            | 1202.53     |
    | APPS           | APPS33               | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 23              | 0            | 1127.14     |
    | APPS           | APPS33               | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 24              | 0            | 821.38      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 8               | 0            | 446.92      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 9               | 0            | 108.01      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 10              | 0            | 524.12      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 22              | 0            | 640.16      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 23              | 0            | 311.44      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 24              | 0            | 101.90      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 8               | 0            | 730.07      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 9               | 0            | 1209.36     |
    | APPS           | APPS33               | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 10              | 0            | 992.67      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 22              | 0            | 1041.78     |
    | APPS           | APPS33               | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 23              | 0            | 509.83      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 24              | 0            | 1421.99     |
    | APPS           | APPS33               | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 8               | 0            | 649.08      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 9               | 0            | 139.66      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 10              | 0            | 964.76      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 22              | 0            | 161.46      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 23              | 0            | 267.88      |
    | APPS           | APPS33               | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 24              | 0            | 121.48      |
    #
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 2               | 0            | 654.59      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 3               | 0            | 536.05      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 4               | 0            | 361.85      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 5               | 0            | 936.40      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 6               | 0            | 869.37      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 7               | 0            | 1150.16     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 11              | 0            | 816.24      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 12              | 0            | 216.18      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 13              | 0            | 1451.27     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 14              | 0            | 403.75      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 15              | 0            | 1085.60     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 16              | 0            | 1084.60     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 17              | 0            | 166.47      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 18              | 0            | 246.75      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 19              | 0            | 740.74      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 20              | 0            | 716.79      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201908 | APPS1920                | APPS-822                 | ?          | 21              | 0            | 1227.10     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 2               | 0            | 743.35      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 3               | 0            | 365.53      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 4               | 0            | 248.61      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 5               | 0            | 763.00      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 6               | 0            | 1091.45     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 7               | 0            | 1048.00     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 11              | 0            | 1036.09     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 12              | 0            | 1043.71     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 13              | 0            | 1069.99     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 14              | 0            | 756.24      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 15              | 0            | 1264.68     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 16              | 0            | 250.25      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 17              | 0            | 1323.34     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 18              | 0            | 819.18      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 19              | 0            | 1308.76     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 20              | 0            | 1197.09     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201909 | APPS1920                | APPS-822                 | ?          | 21              | 0            | 1195.67     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 2               | 0            | 721.69      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 3               | 0            | 1040.90     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 4               | 0            | 1203.93     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 5               | 0            | 1115.34     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 6               | 0            | 1492.10     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 7               | 0            | 291.32      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 11              | 0            | 517.62      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 12              | 0            | 1129.28     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 13              | 0            | 935.21      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 14              | 0            | 1057.25     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 15              | 0            | 1284.08     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 16              | 0            | 1187.31     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 17              | 0            | 1039.01     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 18              | 0            | 262.23      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 19              | 0            | 1270.06     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 20              | 0            | 376.57      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201910 | APPS1920                | APPS-822                 | ?          | 21              | 0            | 779.54      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 2               | 0            | 1065.59     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 3               | 0            | 535.13      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 4               | 0            | 705.92      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 5               | 0            | 167.82      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 6               | 0            | 721.75      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 7               | 0            | 1453.50     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 11              | 0            | 1440.21     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 12              | 0            | 446.74      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 13              | 0            | 1189.65     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 14              | 0            | 685.90      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 15              | 0            | 784.76      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 16              | 0            | 437.85      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 17              | 0            | 492.06      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 18              | 0            | 1101.46     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 19              | 0            | 719.68      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 20              | 0            | 238.30      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201911 | APPS1920                | APPS-822                 | ?          | 21              | 0            | 1225.04     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 2               | 0            | 249.56      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 3               | 0            | 984.28      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 4               | 0            | 1067.72     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 5               | 0            | 1217.21     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 6               | 0            | 181.79      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 7               | 0            | 411.38      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 11              | 0            | 1265.05     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 12              | 0            | 1339.23     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 13              | 0            | 823.70      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 14              | 0            | 1411.80     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 15              | 0            | 1035.46     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 16              | 0            | 1063.10     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 17              | 0            | 696.76      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 18              | 0            | 808.58      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 19              | 0            | 547.20      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 20              | 0            | 1371.58     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 201912 | APPS1920                | APPS-822                 | ?          | 21              | 0            | 790.22      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 2               | 0            | 621.51      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 3               | 0            | 1178.49     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 4               | 0            | 1017.53     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 5               | 0            | 382.97      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 6               | 0            | 1001.40     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 7               | 0            | 101.34      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 11              | 0            | 133.31      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 12              | 0            | 215.44      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 13              | 0            | 514.49      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 14              | 0            | 693.56      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 15              | 0            | 1390.17     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 16              | 0            | 411.43      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 17              | 0            | 976.86      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 18              | 0            | 705.45      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 19              | 0            | 307.55      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 20              | 0            | 150.04      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202001 | APPS1920                | APPS-822                 | ?          | 21              | 0            | 1438.55     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 2               | 0            | 636.84      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 3               | 0            | 1112.57     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 4               | 0            | 487.51      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 5               | 0            | 918.84      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 6               | 0            | 1068.86     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 7               | 0            | 749.27      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 11              | 0            | 529.09      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 12              | 0            | 1488.97     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 13              | 0            | 423.86      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 14              | 0            | 1238.13     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 15              | 0            | 950.95      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 16              | 0            | 508.11      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 17              | 0            | 1462.29     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 18              | 0            | 1385.33     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 19              | 0            | 872.02      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 20              | 0            | 1406.97     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202002 | APPS1920                | APPS-822                 | ?          | 21              | 0            | 1329.52     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 2               | 0            | 1442.16     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 3               | 0            | 675.87      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 4               | 0            | 1022.30     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 5               | 0            | 152.80      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 6               | 0            | 1114.44     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 7               | 0            | 982.63      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 11              | 0            | 1081.30     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 12              | 0            | 188.08      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 13              | 0            | 721.82      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 14              | 0            | 570.78      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 15              | 0            | 435.93      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 16              | 0            | 1116.90     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 17              | 0            | 1307.22     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 18              | 0            | 249.10      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 19              | 0            | 247.38      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 20              | 0            | 1293.23     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202003 | APPS1920                | APPS-822                 | ?          | 21              | 0            | 896.16      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 2               | 0            | 1478.54     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 3               | 0            | 1120.39     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 4               | 0            | 740.40      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 5               | 0            | 906.15      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 6               | 0            | 1144.01     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 7               | 0            | 587.57      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 11              | 0            | 297.95      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 12              | 0            | 306.08      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 13              | 0            | 676.38      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 14              | 0            | 743.92      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 15              | 0            | 1118.52     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 16              | 0            | 1325.59     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 17              | 0            | 124.27      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 18              | 0            | 831.06      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 19              | 0            | 314.68      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 20              | 0            | 114.39      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202004 | APPS1920                | APPS-822                 | ?          | 21              | 0            | 975.95      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 2               | 0            | 1371.68     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 3               | 0            | 955.86      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 4               | 0            | 151.75      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 5               | 0            | 931.21      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 6               | 0            | 253.90      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 7               | 0            | 1415.19     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 11              | 0            | 805.77      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 12              | 0            | 223.23      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 13              | 0            | 365.66      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 14              | 0            | 466.37      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 15              | 0            | 242.77      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 16              | 0            | 1290.50     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 17              | 0            | 779.07      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 18              | 0            | 1330.61     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 19              | 0            | 1486.74     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 20              | 0            | 398.60      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202005 | APPS1920                | APPS-822                 | ?          | 21              | 0            | 884.77      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 2               | 0            | 673.41      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 3               | 0            | 628.60      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 4               | 0            | 612.20      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 5               | 0            | 676.37      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 6               | 0            | 351.49      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 7               | 0            | 585.71      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 11              | 0            | 1316.81     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 12              | 0            | 1384.76     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 13              | 0            | 1309.68     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 14              | 0            | 1411.12     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 15              | 0            | 690.74      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 16              | 0            | 862.51      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 17              | 0            | 627.73      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 18              | 0            | 753.00      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 19              | 0            | 1326.96     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 20              | 0            | 518.26      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202006 | APPS1920                | APPS-822                 | ?          | 21              | 0            | 117.26      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 2               | 0            | 264.03      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 3               | 0            | 804.94      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 4               | 0            | 1401.08     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 5               | 0            | 1268.60     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 6               | 0            | 1160.76     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 7               | 0            | 812.56      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 11              | 0            | 634.80      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 12              | 0            | 547.64      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 13              | 0            | 132.96      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 14              | 0            | 1217.98     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 15              | 0            | 802.49      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 16              | 0            | 442.75      |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 17              | 0            | 1003.04     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 18              | 0            | 1491.49     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 19              | 0            | 1480.75     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 20              | 0            | 1261.65     |
    | ILR1920        | R06                  | ORG0017822     | CM             | 202007 | APPS1920                | APPS-822                 | ?          | 21              | 0            | 135.38      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check MonitoringDeliverables.HeldReportedActualGroup (Only used for APPS contracts) Is the data showing as unprocessed ?
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS1920' OrgId 'ORG0017822' and Collection 'R06' marked as unprocessed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS1920' OrgId 'ORG0017822' and Collection 'APPS33' marked as unprocessed

    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered



    # Check CRM

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-822       | APPS-822           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 2               | 4056.29   | 654.59   | 743.35   | 721.69   | 1065.59  | 249.56   | 621.51   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 3               | 4640.38   | 536.05   | 365.53   | 1040.90  | 535.13   | 984.28   | 1178.49  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 4               | 4605.56   | 361.85   | 248.61   | 1203.93  | 705.92   | 1067.72  | 1017.53  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 5               | 4582.74   | 936.40   | 763.00   | 1115.34  | 167.82   | 1217.21  | 382.97   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 6               | 5357.86   | 869.37   | 1091.45  | 1492.10  | 721.75   | 181.79   | 1001.40  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 7               | 4455.70   | 1150.16  | 1048.00  | 291.32   | 1453.50  | 411.38   | 101.34   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 8               | 2791.66   | 294.88   | 728.19   | 358.50   | 252.05   | 517.39   | 640.65   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 9               | 3522.35   | 617.62   | 660.09   | 734.03   | 92.29    | 198.24   | 1220.08  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 10              | 2276.78   | 211.83   | 280.19   | 130.77   | 422.33   | 223.51   | 1008.15  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 11              | 5208.52   | 816.24   | 1036.09  | 517.62   | 1440.21  | 1265.05  | 133.31   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 12              | 4390.58   | 216.18   | 1043.71  | 1129.28  | 446.74   | 1339.23  | 215.44   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 13              | 5984.31   | 1451.27  | 1069.99  | 935.21   | 1189.65  | 823.70   | 514.49   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 14              | 5008.50   | 403.75   | 756.24   | 1057.25  | 685.90   | 1411.80  | 693.56   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 15              | 6844.75   | 1085.60  | 1264.68  | 1284.08  | 784.76   | 1035.46  | 1390.17  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 16              | 4434.54   | 1084.60  | 250.25   | 1187.31  | 437.85   | 1063.10  | 411.43   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 17              | 4694.50   | 166.47   | 1323.34  | 1039.01  | 492.06   | 696.76   | 976.86   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 18              | 3943.65   | 246.75   | 819.18   | 262.23   | 1101.46  | 808.58   | 705.45   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 19              | 4893.99   | 740.74   | 1308.76  | 1270.06  | 719.68   | 547.20   | 307.55   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 20              | 4050.37   | 716.79   | 1197.09  | 376.57   | 238.30   | 1371.58  | 150.04   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 21              | 6656.12   | 1227.10  | 1195.67  | 779.54   | 1225.04  | 790.22   | 1438.55  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 22              | 4469.22   | 414.48   | 1335.04  | 143.09   | 942.45   | 406.71   | 1227.45  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 23              | 5331.64   | 1169.21  | 1137.56  | 336.94   | 463.79   | 1092.61  | 1131.53  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-822       | APPS-822           | 24              | 3335.75   | 261.41   | 1122.97  | 747.49   | 317.15   | 490.88   | 395.85   | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-822       | APPS-822           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 2               | 4056.29   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4056.29  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 3               | 4640.38   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4640.38  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 4               | 4605.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4605.56  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 5               | 4582.74   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4582.74  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 6               | 5357.86   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5357.86  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 7               | 4455.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4455.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 8               | 2791.66   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2791.66  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 9               | 3522.35   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3522.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 10              | 2276.78   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2276.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 11              | 5208.52   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5208.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 12              | 4390.58   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4390.58  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 13              | 5984.31   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5984.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 14              | 5008.50   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5008.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 15              | 6844.75   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6844.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 16              | 4434.54   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4434.54  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 17              | 4694.50   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4694.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 18              | 3943.65   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3943.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 19              | 4893.99   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4893.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 20              | 4050.37   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4050.37  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 21              | 6656.12   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6656.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 22              | 4469.22   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4469.22  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 23              | 5331.64   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5331.64  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 24              | 3335.75   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3335.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-822       | APPS-822           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 2               | -4056.29  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4056.29 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 3               | -4640.38  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4640.38 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 4               | -4605.56  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4605.56 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 5               | -4582.74  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4582.74 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 6               | -5357.86  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -5357.86 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 8               | -2791.66  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2791.66 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 9               | -3522.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -3522.35 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 11              | -5208.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -5208.52 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 12              | -4390.58  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4390.58 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 13              | -5984.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -5984.31 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 14              | -5008.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -5008.50 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 15              | -6844.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6844.75 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 16              | -4434.54  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4434.54 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 17              | -4694.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4694.50 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 19              | -4893.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4893.99 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 20              | -4050.37  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4050.37 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 22              | -4469.22  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4469.22 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 23              | -5331.64  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -5331.64 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 24              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-822       | APPS-822           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 7               | 4455.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4455.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 10              | 2276.78   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2276.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 14              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 18              | 3943.65   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3943.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 20              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 21              | 6656.12   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6656.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 22              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 23              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 24              | 3335.75   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3335.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




    # Bulk amendment file to add £1000 to the Profile

    # Change the date
    Given the override date is '01/03/2020'

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | 
    | EDSK-822       | 2                     | 0                        | 

    # Bulk file
    And   there are no files prefixed '10017822' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 16042020110547 v3_A822' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 1920 16042020110547 v3_A822' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 16042020110547 v3_A822' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 16042020110547 v3_A822' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 16042020110547 v3_A822.xlsx' exists in the Datafiles folder and UKPRN '10017822' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Change the date
    Given the override date is '02/03/2020'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-822'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-822' and actual ContractNumber 'EDSK-822'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-822' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017822 | EDSK-822           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017822 | EDSK-822           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017822 | ESFA-822           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '288' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract 'EDSK-822'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | APPS-822      | 2240100          | Jul-20 | Reconciliation |




    # Check CRM

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-822       | APPS-822           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 2               | 8112.58   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4056.29  | 4056.29  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 3               | 9280.76   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4640.38  | 4640.38  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 4               | 9211.12   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4605.56  | 4605.56  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 5               | 9165.48   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4582.74  | 4582.74  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 6               | 10715.72  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5357.86  | 5357.86  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 7               | 4455.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4455.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 8               | 5583.32   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2791.66  | 2791.66  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 9               | 7044.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3522.35  | 3522.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 10              | 2276.78   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2276.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 11              | 10417.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5208.52  | 5208.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 12              | 8781.16   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4390.58  | 4390.58  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 13              | 11968.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5984.31  | 5984.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 14              | 10017.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5008.50  | 5008.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 15              | 13689.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6844.75  | 6844.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 16              | 8869.08   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4434.54  | 4434.54  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 17              | 9389.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4694.50  | 4694.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 18              | 3943.65   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3943.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 19              | 9787.98   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4893.99  | 4893.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 20              | 8100.74   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4050.37  | 4050.37  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 21              | 6656.12   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6656.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 22              | 8938.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4469.22  | 4469.22  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 23              | 10663.28  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5331.64  | 5331.64  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 24              | 3335.75   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3335.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-822       | APPS-822           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 2               | -8064.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4056.29 | -4008.49 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 3               | -9226.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4640.38 | -4585.70 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 4               | -9156.85  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4605.56 | -4551.29 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 5               | -9111.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4582.74 | -4528.74 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 6               | -10652.59 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -5357.86 | -5294.73 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 8               | -5550.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2791.66 | -2758.77 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 9               | -7003.20  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -3522.35 | -3480.85 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 11              | -10355.67 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -5208.52 | -5147.15 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 12              | -8729.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4390.58 | -4338.85 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 13              | -11898.11 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -5984.31 | -5913.80 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 14              | -9957.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -5008.50 | -4949.48 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 15              | -13608.85 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6844.75 | -6764.10 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 16              | -8816.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4434.54 | -4382.29 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 17              | -9333.68  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4694.50 | -4639.18 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 19              | -9730.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4893.99 | -4836.32 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 20              | -8053.01  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4050.37 | -4002.64 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 22              | -8885.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4469.22 | -4416.56 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 23              | -10600.46 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -5331.64 | -5268.82 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 24              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-822       | APPS-822           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 2               | 47.80     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 47.80    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 3               | 54.68     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 54.68    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 4               | 54.27     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 54.27    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 5               | 54.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 54.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 6               | 63.13     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 63.13    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 7               | 4455.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4455.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 8               | 32.89     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 32.89    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 9               | 41.50     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 41.50    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 10              | 2276.78   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2276.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 11              | 61.37     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 61.37    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 12              | 51.73     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 51.73    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 13              | 70.51     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 70.51    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 14              | 59.02     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 59.02    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 15              | 80.65     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 80.65    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 16              | 52.25     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 52.25    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 17              | 55.32     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 55.32    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 18              | 3943.65   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3943.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 19              | 57.67     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 57.67    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 20              | 47.73     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 47.73    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 21              | 6656.12   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6656.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 22              | 52.66     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 52.66    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 23              | 62.82     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 62.82    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-822       | APPS-822           | 24              | 3335.75   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3335.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Tidy Up
    And   the override date is reset
     
      