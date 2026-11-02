Feature: AppsActuals 23924

@AcceptanceTest @Withdrawn20231002
@HighValue 
@Long2Run @Long2Run890
Scenario: A048SLD Create and approve 1819APPS and 1920APPS contracts. Consume actuals for R13, R14, R02, R03, APPS29 and APPS30. Check actuals pairing in PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017048' 
    And   there are no terminated or closed allocations for UKPRN '10017048' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017048' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Cleardown actuals audit data
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017048'

    # Delete any MonitoringDeliverables.HeldReportedActualGroup data for this ORG
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017048'

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | APPS-6048     |
    | APPS-7048     |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | APPS1819       |
    | APPS1920       |

	# Clear down PaymentSchedule.DeliverablePayment data for an allocation
   	And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | APPS-6048     |
    | APPS-7048     |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017048' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017048 Co Ltd' with UKPRN '10017048' and OrgId 'ORG0017048' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017048' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017048 | 117048 | 10017048 Co Ltd | 0              | Provider Under Change | Yes           | AA017048      | ?             | 43 Townhead Street     | Sheffield              | South Yorkshire        | ?                      | ?                      | ?                      | S1 2EB    |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017048 |




    # Change the date
    Given the override date is '01/07/2018'

    # Create 1819APPS contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017048 | 10017048 Co Ltd      | ESFA-6048            | MAIN-6048      | 1                     | 01/08/2018        | 31/07/2019      | 23255.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017048 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017048 | MAIN-6048      | APPS-6048     | APPS              | APPS1819                | AY                      | 01/08/2018          | 31/07/2019        | 23255.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017048 | MAIN-6048      | APPS-6048     | 1               | 0                     | 23255.00  | 2504.00  | 1847.00  | 2835.00  | 3571.00  | 2346.00  | 2321.00  | 1412.00  | 439.00   | 2376.00  | 266.00   | 1160.00  | 2178.00  | Apprenticeships Carry-In Total Funding                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-6048' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-6048' and actual ContractNumber 'MAIN-6048'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-6048' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017048 | MAIN-6048          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017048 | ESFA-6048          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '288' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 1920 APPS contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017048 | 10017048 Co Ltd      | ESFA-7048            | MAIN-7048      | 1                     | 01/08/2019        | 31/07/2020      | 21277.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017048 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017048 | MAIN-7048      | APPS-7048     | APPS              | APPS1920                | AY                      | 01/08/2019          | 31/07/2020        | 21277.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017048 | MAIN-7048      | APPS-7048     | 1               | 0                     | 21277.00  | 593.00   | 64.00    | 2633.00  | 1344.00  | 1512.00  | 2974.00  | 1304.00  | 1630.00  | 2618.00  | 3355.00  | 1146.00  | 2104.00  | Apprenticeships Carry-In Total Funding                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-7048' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-7048' and actual ContractNumber 'MAIN-7048'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-7048' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017048 | MAIN-7048          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017048 | ESFA-7048          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '288' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract 'MAIN-6048'
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract 'MAIN-7048'

    # Add actuals to the contract

    # Change the date
    Given the override date is '17/09/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017048'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Clear down PaaS summarised actuals before the first pull of actuals
    And   there are no entries in the summarised actuals PaaS table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull Jun-19 and Jul-19 actuals from DC for APPS1819 for ILR Collection R13 
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    # APPS1819 ILR actuals
    | ILR1819        | R13                  | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 2               | 0            | 316.02      |
    | ILR1819        | R13                  | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 3               | 0            | 555.03      |
    | ILR1819        | R13                  | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 4               | 0            | 408.04      |
    | ILR1819        | R13                  | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 5               | 0            | 241.05      |
    | ILR1819        | R13                  | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 6               | 0            | 776.06      |
    | ILR1819        | R13                  | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 7               | 0            | 781.07      |
    #
    | ILR1819        | R13                  | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 2               | 0            | 419.02      |
    | ILR1819        | R13                  | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 3               | 0            | 853.03      |
    | ILR1819        | R13                  | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 4               | 0            | 500.04      |
    | ILR1819        | R13                  | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 5               | 0            | 205.05      |
    | ILR1819        | R13                  | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 6               | 0            | 673.06      |
    | ILR1819        | R13                  | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 7               | 0            | 612.07      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    And   MonthEnd processing has completed and the processing of held data is triggered

    # Check MonitoringDeliverables.HeldReportedActualGroup (Only used for APPS contracts) Is the data showing as unprocessed ?
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017048' and Collection 'R13' marked as unprocessed




    # Add actuals to the contract for the first period

    # Change the date
    Given the override date is '08/10/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
   #And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017048'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull Jun-19 and Jul-19 actuals from DC for APPS1819 for APPS in Collection APPS29
    #  and Aug-19 and Sep-19 actuals from DC for APPS1920 for APPS in Collection APPS29
    #  and Aug-19 and Sep-19 actuals from DC for APPS1920 for ILR in Collection R02 
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    #
    # APPS1819 APPS actuals
    #
    | APPS           | APPS29               | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 8               | 0            | 342.08      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 9               | 0            | 216.09      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 10              | 0            | 154.10      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 22              | 0            | 288.22      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 23              | 0            | 151.23      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 24              | 0            | 167.24      |
    #
    | APPS           | APPS29               | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 8               | 0            | 185.08      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 9               | 0            | 222.09      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 10              | 0            | 202.10      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 22              | 0            | 218.22      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 23              | 0            | 193.23      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 24              | 0            | 122.24      |
    #
    # APPS1920 APPS actuals
    #
    | APPS           | APPS29               | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 8               | 0            | 552.08      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 9               | 0            | 156.09      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 10              | 0            | 115.10      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 22              | 0            | 321.22      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 23              | 0            | 413.23      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 24              | 0            | 221.24      |
    #
    | APPS           | APPS29               | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 8               | 0            | 512.08      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 9               | 0            | 325.09      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 10              | 0            | 185.10      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 22              | 0            | 249.22      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 23              | 0            | 200.23      |
    | APPS           | APPS29               | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 24              | 0            | 273.24      |
    #
    # APPS1920 ILR actuals
    #
    | ILR1920        | R02                  | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 2               | 0            | 465.08      |
    | ILR1920        | R02                  | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 3               | 0            | 224.09      |
    | ILR1920        | R02                  | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 4               | 0            | 546.10      |
    | ILR1920        | R02                  | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 5               | 0            | 111.22      |
    | ILR1920        | R02                  | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 6               | 0            | 241.23      |
    | ILR1920        | R02                  | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 7               | 0            | 640.24      |
    #
    | ILR1920        | R02                  | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 2               | 0            | 217.08      |
    | ILR1920        | R02                  | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 3               | 0            | 340.09      |
    | ILR1920        | R02                  | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 4               | 0            | 115.10      |
    | ILR1920        | R02                  | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 5               | 0            | 351.22      |
    | ILR1920        | R02                  | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 6               | 0            | 301.23      |
    | ILR1920        | R02                  | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 7               | 0            | 209.24      |

    # Pull actuals from new Submit Learner Data (SLD) interface (24329)
    When  the FCT system polls the SLD service

    And   wait '15' seconds

    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered


    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Jun-19   | Jul-19   | Sep-19   |
    | MAIN-6048      | APPS-6048       | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 2               | 735.04    | 316.02   | 419.02   | 0.00     | 
    | MAIN-6048      | APPS-6048       | 3               | 1408.06   | 555.03   | 853.03   | 0.00     | 
    | MAIN-6048      | APPS-6048       | 4               | 908.08    | 408.04   | 500.04   | 0.00     | 
    | MAIN-6048      | APPS-6048       | 5               | 446.10    | 241.05   | 205.05   | 0.00     | 
    | MAIN-6048      | APPS-6048       | 6               | 1449.12   | 776.06   | 673.06   | 0.00     | 
    | MAIN-6048      | APPS-6048       | 7               | 1393.14   | 781.07   | 612.07   | 0.00     | 
    | MAIN-6048      | APPS-6048       | 8               | 527.16    | 342.08   | 185.08   | 0.00     | 
    | MAIN-6048      | APPS-6048       | 9               | 438.18    | 216.09   | 222.09   | 0.00     | 
    | MAIN-6048      | APPS-6048       | 10              | 356.20    | 154.10   | 202.10   | 0.00     | 
    | MAIN-6048      | APPS-6048       | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 14              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 20              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 22              | 506.44    | 288.22   | 218.22   | 0.00     | 
    | MAIN-6048      | APPS-6048       | 23              | 344.46    | 151.23   | 193.23   | 0.00     | 
    | MAIN-6048      | APPS-6048       | 24              | 289.48    | 167.24   | 122.24   | 0.00     | 

    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   |
    | MAIN-7048      | APPS-7048       | 1               | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 2               | 682.16    | 465.08   | 217.08   | 
    | MAIN-7048      | APPS-7048       | 3               | 564.18    | 224.09   | 340.09   | 
    | MAIN-7048      | APPS-7048       | 4               | 661.20    | 546.10   | 115.10   | 
    | MAIN-7048      | APPS-7048       | 5               | 462.44    | 111.22   | 351.22   | 
    | MAIN-7048      | APPS-7048       | 6               | 542.46    | 241.23   | 301.23   | 
    | MAIN-7048      | APPS-7048       | 7               | 849.48    | 640.24   | 209.24   | 
    | MAIN-7048      | APPS-7048       | 8               | 1064.16   | 552.08   | 512.08   | 
    | MAIN-7048      | APPS-7048       | 9               | 481.18    | 156.09   | 325.09   | 
    | MAIN-7048      | APPS-7048       | 10              | 300.20    | 115.10   | 185.10   | 
    | MAIN-7048      | APPS-7048       | 11              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 12              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 13              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 14              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 15              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 16              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 17              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 18              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 19              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 20              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 21              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 22              | 570.44    | 321.22   | 249.22   | 
    | MAIN-7048      | APPS-7048       | 23              | 613.46    | 413.23   | 200.23   | 
    | MAIN-7048      | APPS-7048       | 24              | 494.48    | 221.24   | 273.24   | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Jun-19   | Jul-19   | Sep-19   |
    | MAIN-6048      | APPS-6048       | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 2               | 735.04    | 0.00     | 0.00     | 735.04   | 
    | MAIN-6048      | APPS-6048       | 3               | 1408.06   | 0.00     | 0.00     | 1408.06  | 
    | MAIN-6048      | APPS-6048       | 4               | 908.08    | 0.00     | 0.00     | 908.08   | 
    | MAIN-6048      | APPS-6048       | 5               | 446.10    | 0.00     | 0.00     | 446.10   | 
    | MAIN-6048      | APPS-6048       | 6               | 1449.12   | 0.00     | 0.00     | 1449.12  | 
    | MAIN-6048      | APPS-6048       | 7               | 1393.14   | 0.00     | 0.00     | 1393.14  | 
    | MAIN-6048      | APPS-6048       | 8               | 527.16    | 0.00     | 0.00     | 527.16   | 
    | MAIN-6048      | APPS-6048       | 9               | 438.18    | 0.00     | 0.00     | 438.18   | 
    | MAIN-6048      | APPS-6048       | 10              | 356.20    | 0.00     | 0.00     | 356.20   | 
    | MAIN-6048      | APPS-6048       | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 14              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 20              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 22              | 506.44    | 0.00     | 0.00     | 506.44   | 
    | MAIN-6048      | APPS-6048       | 23              | 344.46    | 0.00     | 0.00     | 344.46   | 
    | MAIN-6048      | APPS-6048       | 24              | 289.48    | 0.00     | 0.00     | 289.48   | 

    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   |
    | MAIN-7048      | APPS-7048       | 1               | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 2               | 682.16    | 0.00     | 682.16   | 
    | MAIN-7048      | APPS-7048       | 3               | 564.18    | 0.00     | 564.18   | 
    | MAIN-7048      | APPS-7048       | 4               | 661.20    | 0.00     | 661.20   | 
    | MAIN-7048      | APPS-7048       | 5               | 462.44    | 0.00     | 462.44   | 
    | MAIN-7048      | APPS-7048       | 6               | 542.46    | 0.00     | 542.46   | 
    | MAIN-7048      | APPS-7048       | 7               | 849.48    | 0.00     | 849.48   | 
    | MAIN-7048      | APPS-7048       | 8               | 1064.16   | 0.00     | 1064.16  | 
    | MAIN-7048      | APPS-7048       | 9               | 481.18    | 0.00     | 481.18   | 
    | MAIN-7048      | APPS-7048       | 10              | 300.20    | 0.00     | 300.20   | 
    | MAIN-7048      | APPS-7048       | 11              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 12              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 13              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 14              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 15              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 16              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 17              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 18              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 19              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 20              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 21              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 22              | 570.44    | 0.00     | 570.44   | 
    | MAIN-7048      | APPS-7048       | 23              | 613.46    | 0.00     | 613.46   | 
    | MAIN-7048      | APPS-7048       | 24              | 494.48    | 0.00     | 494.48   | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Jun-19   | Jul-19   | Sep-19   |
    | MAIN-6048      | APPS-6048       | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 2               | -306.67   | 0.00     | 0.00     | -306.67  | 
    | MAIN-6048      | APPS-6048       | 3               | -587.46   | 0.00     | 0.00     | -587.46  | 
    | MAIN-6048      | APPS-6048       | 4               | -378.86   | 0.00     | 0.00     | -378.86  | 
    | MAIN-6048      | APPS-6048       | 5               | -186.12   | 0.00     | 0.00     | -186.12  | 
    | MAIN-6048      | APPS-6048       | 6               | -604.59   | 0.00     | 0.00     | -604.59  | 
    | MAIN-6048      | APPS-6048       | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 8               | -219.94   | 0.00     | 0.00     | -219.94  | 
    | MAIN-6048      | APPS-6048       | 9               | -182.81   | 0.00     | 0.00     | -182.81  | 
    | MAIN-6048      | APPS-6048       | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 14              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 20              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 22              | -211.29   | 0.00     | 0.00     | -211.29  | 
    | MAIN-6048      | APPS-6048       | 23              | -143.71   | 0.00     | 0.00     | -143.71  | 
    | MAIN-6048      | APPS-6048       | 24              | 0.00      | 0.00     | 0.00     | 0.00     | 

    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   |
    | MAIN-7048      | APPS-7048       | 1               | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 2               | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 3               | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 4               | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 5               | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 6               | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 7               | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 8               | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 9               | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 10              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 11              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 12              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 13              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 14              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 15              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 16              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 17              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 18              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 19              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 20              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 21              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 22              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 23              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 24              | 0.00      | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Jun-19   | Jul-19   | Sep-19   |
    | MAIN-6048      | APPS-6048       | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 2               | 428.37    | 0.00     | 0.00     | 428.37   | 
    | MAIN-6048      | APPS-6048       | 3               | 820.60    | 0.00     | 0.00     | 820.60   | 
    | MAIN-6048      | APPS-6048       | 4               | 529.22    | 0.00     | 0.00     | 529.22   | 
    | MAIN-6048      | APPS-6048       | 5               | 259.98    | 0.00     | 0.00     | 259.98   | 
    | MAIN-6048      | APPS-6048       | 6               | 844.53    | 0.00     | 0.00     | 844.53   | 
    | MAIN-6048      | APPS-6048       | 7               | 1393.14   | 0.00     | 0.00     | 1393.14  | 
    | MAIN-6048      | APPS-6048       | 8               | 307.22    | 0.00     | 0.00     | 307.22   | 
    | MAIN-6048      | APPS-6048       | 9               | 255.37    | 0.00     | 0.00     | 255.37   | 
    | MAIN-6048      | APPS-6048       | 10              | 356.20    | 0.00     | 0.00     | 356.20   | 
    | MAIN-6048      | APPS-6048       | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 14              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 20              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 22              | 295.15    | 0.00     | 0.00     | 295.15   | 
    | MAIN-6048      | APPS-6048       | 23              | 200.75    | 0.00     | 0.00     | 200.75   | 
    | MAIN-6048      | APPS-6048       | 24              | 289.48    | 0.00     | 0.00     | 289.48   | 

    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   |
    | MAIN-7048      | APPS-7048       | 1               | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 2               | 682.16    | 0.00     | 682.16   | 
    | MAIN-7048      | APPS-7048       | 3               | 564.18    | 0.00     | 564.18   | 
    | MAIN-7048      | APPS-7048       | 4               | 661.20    | 0.00     | 661.20   | 
    | MAIN-7048      | APPS-7048       | 5               | 462.44    | 0.00     | 462.44   | 
    | MAIN-7048      | APPS-7048       | 6               | 542.46    | 0.00     | 542.46   | 
    | MAIN-7048      | APPS-7048       | 7               | 849.48    | 0.00     | 849.48   | 
    | MAIN-7048      | APPS-7048       | 8               | 1064.16   | 0.00     | 1064.16  | 
    | MAIN-7048      | APPS-7048       | 9               | 481.18    | 0.00     | 481.18   | 
    | MAIN-7048      | APPS-7048       | 10              | 300.20    | 0.00     | 300.20   | 
    | MAIN-7048      | APPS-7048       | 11              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 12              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 13              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 14              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 15              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 16              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 17              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 18              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 19              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 20              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 21              | 0.00      | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 22              | 570.44    | 0.00     | 570.44   | 
    | MAIN-7048      | APPS-7048       | 23              | 613.46    | 0.00     | 613.46   | 
    | MAIN-7048      | APPS-7048       | 24              | 494.48    | 0.00     | 494.48   | 


    # Check MonitoringDeliverables.HeldReportedActualGroup. All data should show as processed
    Then  there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017048' and Collection 'R13' marked as unprocessed
    And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017048' and Collection 'APPS29' marked as unprocessed
	And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1920' OrgId 'ORG0017048' and Collection 'R02' marked as unprocessed
    And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1920' OrgId 'ORG0017048' and Collection 'APPS29' marked as unprocessed





	
	# Add actuals to the contract for the second period

    # Change the date
    Given the override date is '21/10/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017048'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull Jun-19 and Jul-19 actuals from DC for APPS1819 for ILR Collection R14 
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    #
    # APPS1819 ILR actuals
    #
    | ILR1819        | R14                  | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 2               | 0            | 286.02      |
    | ILR1819        | R14                  | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 3               | 0            | 435.03      |
    | ILR1819        | R14                  | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 4               | 0            | 411.04      |
    | ILR1819        | R14                  | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 5               | 0            | 234.05      |
    | ILR1819        | R14                  | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 6               | 0            | 782.06      |
    | ILR1819        | R14                  | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 7               | 0            | 719.07      |
    #
    | ILR1819        | R14                  | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 2               | 0            | 500.02      |
    | ILR1819        | R14                  | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 3               | 0            | 714.03      |
    | ILR1819        | R14                  | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 4               | 0            | 496.04      |
    | ILR1819        | R14                  | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 5               | 0            | 213.05      |
    | ILR1819        | R14                  | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 6               | 0            | 680.06      |
    | ILR1819        | R14                  | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 7               | 0            | 599.07      |

    # Pull actuals from new Submit Learner Data (SLD) interface (24329)
    When  the FCT system polls the SLD service

    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    And   MonthEnd processing has completed and the processing of held data is triggered

    # Check MonitoringDeliverables.HeldReportedActualGroup (Only used for APPS contracts) Is the data showing as unprocessed ?
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017048' and Collection 'R14' marked as unprocessed




    # Add actuals to the contract

    # Change the date
    Given the override date is '08/11/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
   #And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017048'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull Jun-19 and Jul-19 actuals from DC for APPS1819 for APPS in Collection APPS30
    #  and Aug-19, Sep-19 and Oct-19 actuals from DC for APPS1920 for APPS in Collection APPS30
    #  and Aug-19, Sep-19 and Oct-19 actuals from DC for APPS1920 for ILR in Collection R03 
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    #
    # APPS1819 APPS actuals
    #
    | APPS           | APPS30               | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 8               | 0            | 312.08      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 9               | 0            | 223.09      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 10              | 0            | 190.10      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 22              | 0            | 261.22      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 23              | 0            | 203.23      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201906 | APPS1819                | APPS-6048                | ?          | 24              | 0            | 115.24      |
    #
    | APPS           | APPS30               | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 8               | 0            | 199.08      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 9               | 0            | 210.09      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 10              | 0            | 237.10      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 22              | 0            | 201.22      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 23              | 0            | 228.23      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201907 | APPS1819                | APPS-6048                | ?          | 24              | 0            | 189.24      |
    #
    # APPS1920 APPS actuals
    #
    | APPS           | APPS30               | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 8               | 0            | 545.08      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 9               | 0            | 128.09      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 10              | 0            | 143.10      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 22              | 0            | 393.22      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 23              | 0            | 466.23      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 24              | 0            | 234.24      |
    #
    | APPS           | APPS30               | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 8               | 0            | 508.08      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 9               | 0            | 310.09      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 10              | 0            | 134.10      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 22              | 0            | 257.22      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 23              | 0            | 203.23      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 24              | 0            | 265.24      |
    #
    | APPS           | APPS30               | ORG0017048     | CM             | 201910 | APPS1920                | APPS-7048                | ?          | 8               | 0            | 213.08      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201910 | APPS1920                | APPS-7048                | ?          | 9               | 0            | 501.09      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201910 | APPS1920                | APPS-7048                | ?          | 10              | 0            | 245.10      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201910 | APPS1920                | APPS-7048                | ?          | 22              | 0            | 110.22      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201910 | APPS1920                | APPS-7048                | ?          | 23              | 0            | 313.23      |
    | APPS           | APPS30               | ORG0017048     | CM             | 201910 | APPS1920                | APPS-7048                | ?          | 24              | 0            | 195.24      |
    #
    # APPS1920 ILR actuals
    #
    | ILR1920        | R03                  | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 2               | 0            | 422.02      |
    | ILR1920        | R03                  | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 3               | 0            | 231.03      |
    | ILR1920        | R03                  | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 4               | 0            | 570.04      |
    | ILR1920        | R03                  | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 5               | 0            | 122.05      |
    | ILR1920        | R03                  | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 6               | 0            | 256.06      |
    | ILR1920        | R03                  | ORG0017048     | CM             | 201908 | APPS1920                | APPS-7048                | ?          | 7               | 0            | 638.07      |
    #
    | ILR1920        | R03                  | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 2               | 0            | 317.02      |
    | ILR1920        | R03                  | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 3               | 0            | 341.03      |
    | ILR1920        | R03                  | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 4               | 0            | 107.04      |
    | ILR1920        | R03                  | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 5               | 0            | 150.05      |
    | ILR1920        | R03                  | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 6               | 0            | 132.06      |
    | ILR1920        | R03                  | ORG0017048     | CM             | 201909 | APPS1920                | APPS-7048                | ?          | 7               | 0            | 550.07      |
    #
    | ILR1920        | R03                  | ORG0017048     | CM             | 201910 | APPS1920                | APPS-7048                | ?          | 2               | 0            | 209.02      |
    | ILR1920        | R03                  | ORG0017048     | CM             | 201910 | APPS1920                | APPS-7048                | ?          | 3               | 0            | 321.03      |
    | ILR1920        | R03                  | ORG0017048     | CM             | 201910 | APPS1920                | APPS-7048                | ?          | 4               | 0            | 134.04      |
    | ILR1920        | R03                  | ORG0017048     | CM             | 201910 | APPS1920                | APPS-7048                | ?          | 5               | 0            | 367.05      |
    | ILR1920        | R03                  | ORG0017048     | CM             | 201910 | APPS1920                | APPS-7048                | ?          | 6               | 0            | 322.06      |
    | ILR1920        | R03                  | ORG0017048     | CM             | 201910 | APPS1920                | APPS-7048                | ?          | 7               | 0            | 238.07      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    And   wait '15' seconds

    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Jun-19   | Jul-19   | Sep-19   | Oct-19   |
    | MAIN-6048      | APPS-6048       | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 2               | 786.04    | 286.02   | 500.02   | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 3               | 1149.06   | 435.03   | 714.03   | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 4               | 907.08    | 411.04   | 496.04   | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 5               | 447.10    | 234.05   | 213.05   | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 6               | 1462.12   | 782.06   | 680.06   | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 7               | 1318.14   | 719.07   | 599.07   | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 8               | 511.16    | 312.08   | 199.08   | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 9               | 433.18    | 223.09   | 210.09   | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 10              | 427.20    | 190.10   | 237.10   | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 14              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 20              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 22              | 462.44    | 261.22   | 201.22   | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 23              | 431.46    | 203.23   | 228.23   | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 24              | 304.48    | 115.24   | 189.24   | 0.00     | 0.00     | 

    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | 
    | MAIN-7048      | APPS-7048       | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 2               | 948.06    | 422.02   | 317.02   | 209.02   | 
    | MAIN-7048      | APPS-7048       | 3               | 893.09    | 231.03   | 341.03   | 321.03   | 
    | MAIN-7048      | APPS-7048       | 4               | 811.12    | 570.04   | 107.04   | 134.04   | 
    | MAIN-7048      | APPS-7048       | 5               | 639.15    | 122.05   | 150.05   | 367.05   | 
    | MAIN-7048      | APPS-7048       | 6               | 710.18    | 256.06   | 132.06   | 322.06   | 
    | MAIN-7048      | APPS-7048       | 7               | 1426.21   | 638.07   | 550.07   | 238.07   | 
    | MAIN-7048      | APPS-7048       | 8               | 1266.24   | 545.08   | 508.08   | 213.08   | 
    | MAIN-7048      | APPS-7048       | 9               | 939.27    | 128.09   | 310.09   | 501.09   | 
    | MAIN-7048      | APPS-7048       | 10              | 522.30    | 143.10   | 134.10   | 245.10   | 
    | MAIN-7048      | APPS-7048       | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 14              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 20              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 22              | 760.66    | 393.22   | 257.22   | 110.22   | 
    | MAIN-7048      | APPS-7048       | 23              | 982.69    | 466.23   | 203.23   | 313.23   | 
    | MAIN-7048      | APPS-7048       | 24              | 694.72    | 234.24   | 265.24   | 195.24   | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Sep-19   | Oct-19   |
    | MAIN-6048      | APPS-6048       | 1               | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 2               | 1092.71   | 735.04   | 357.67   | 
    | MAIN-6048      | APPS-6048       | 3               | 1736.52   | 1408.06  | 328.46   | 
    | MAIN-6048      | APPS-6048       | 4               | 1285.94   | 908.08   | 377.86   | 
    | MAIN-6048      | APPS-6048       | 5               | 633.22    | 446.10   | 187.12   | 
    | MAIN-6048      | APPS-6048       | 6               | 2066.71   | 1449.12  | 617.59   | 
    | MAIN-6048      | APPS-6048       | 7               | 1318.14   | 1393.14  | -75.00   | 
    | MAIN-6048      | APPS-6048       | 8               | 731.10    | 527.16   | 203.94   | 
    | MAIN-6048      | APPS-6048       | 9               | 615.99    | 438.18   | 177.81   | 
    | MAIN-6048      | APPS-6048       | 10              | 427.20    | 356.20   | 71.00    | 
    | MAIN-6048      | APPS-6048       | 11              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 12              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 13              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 14              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 15              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 16              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 17              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 18              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 19              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 20              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 21              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 22              | 673.73    | 506.44   | 167.29   | 
    | MAIN-6048      | APPS-6048       | 23              | 575.17    | 344.46   | 230.71   | 
    | MAIN-6048      | APPS-6048       | 24              | 304.48    | 289.48   | 15.00    | 

    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   |
    | MAIN-7048      | APPS-7048       | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 2               | 948.06    | 0.00     | 682.16   | 265.90   | 
    | MAIN-7048      | APPS-7048       | 3               | 893.09    | 0.00     | 564.18   | 328.91   | 
    | MAIN-7048      | APPS-7048       | 4               | 811.12    | 0.00     | 661.20   | 149.92   | 
    | MAIN-7048      | APPS-7048       | 5               | 639.15    | 0.00     | 462.44   | 176.71   | 
    | MAIN-7048      | APPS-7048       | 6               | 710.18    | 0.00     | 542.46   | 167.72   | 
    | MAIN-7048      | APPS-7048       | 7               | 1426.21   | 0.00     | 849.48   | 576.73   | 
    | MAIN-7048      | APPS-7048       | 8               | 1266.24   | 0.00     | 1064.16  | 202.08   | 
    | MAIN-7048      | APPS-7048       | 9               | 939.27    | 0.00     | 481.18   | 458.09   | 
    | MAIN-7048      | APPS-7048       | 10              | 522.30    | 0.00     | 300.20   | 222.10   | 
    | MAIN-7048      | APPS-7048       | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 14              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 20              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 22              | 760.66    | 0.00     | 570.44   | 190.22   | 
    | MAIN-7048      | APPS-7048       | 23              | 982.69    | 0.00     | 613.46   | 369.23   | 
    | MAIN-7048      | APPS-7048       | 24              | 694.72    | 0.00     | 494.48   | 200.24   | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Sep-19   | Oct-19   |
    | MAIN-6048      | APPS-6048       | 1               | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 2               | -623.90   | -306.67  | -317.23  | 
    | MAIN-6048      | APPS-6048       | 3               | -1051.20  | -587.46  | -463.74  | 
    | MAIN-6048      | APPS-6048       | 4               | -744.94   | -378.86  | -366.08  | 
    | MAIN-6048      | APPS-6048       | 5               | -366.56   | -186.12  | -180.44  | 
    | MAIN-6048      | APPS-6048       | 6               | -1194.68  | -604.59  | -590.09  | 
    | MAIN-6048      | APPS-6048       | 7               | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 8               | -426.23   | -219.94  | -206.29  | 
    | MAIN-6048      | APPS-6048       | 9               | -357.63   | -182.81  | -174.82  | 
    | MAIN-6048      | APPS-6048       | 10              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 11              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 12              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 13              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 14              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 15              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 16              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 17              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 18              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 19              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 20              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 21              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 22              | -397.92   | -211.29  | -186.63  | 
    | MAIN-6048      | APPS-6048       | 23              | -317.84   | -143.71  | -174.13  | 
    | MAIN-6048      | APPS-6048       | 24              | 0.00      | 0.00     | 0.00     | 

    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | 
    | MAIN-7048      | APPS-7048       | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 14              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 20              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 22              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 23              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 24              | 0.00      | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Sep-19   | Oct-19   |
    | MAIN-6048      | APPS-6048       | 1               | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 2               | 468.81    | 428.37   | 40.44    | 
    | MAIN-6048      | APPS-6048       | 3               | 685.32    | 820.60   | -135.28  | 
    | MAIN-6048      | APPS-6048       | 4               | 541.00    | 529.22   | 11.78    | 
    | MAIN-6048      | APPS-6048       | 5               | 266.66    | 259.98   | 6.68     | 
    | MAIN-6048      | APPS-6048       | 6               | 872.03    | 844.53   | 27.50    | 
    | MAIN-6048      | APPS-6048       | 7               | 1318.14   | 1393.14  | -75.00   | 
    | MAIN-6048      | APPS-6048       | 8               | 304.87    | 307.22   | -2.35    | 
    | MAIN-6048      | APPS-6048       | 9               | 258.36    | 255.37   | 2.99     | 
    | MAIN-6048      | APPS-6048       | 10              | 427.20    | 356.20   | 71.00    | 
    | MAIN-6048      | APPS-6048       | 11              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 12              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 13              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 14              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 15              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 16              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 17              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 18              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 19              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 20              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 21              | 0.00      | 0.00     | 0.00     | 
    | MAIN-6048      | APPS-6048       | 22              | 275.81    | 295.15   | -19.34   | 
    | MAIN-6048      | APPS-6048       | 23              | 257.33    | 200.75   | 56.58    | 
    | MAIN-6048      | APPS-6048       | 24              | 304.48    | 289.48   | 15.00    | 

    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | 
    | MAIN-7048      | APPS-7048       | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 2               | 948.06    | 0.00     | 682.16   | 265.90   | 
    | MAIN-7048      | APPS-7048       | 3               | 893.09    | 0.00     | 564.18   | 328.91   | 
    | MAIN-7048      | APPS-7048       | 4               | 811.12    | 0.00     | 661.20   | 149.92   | 
    | MAIN-7048      | APPS-7048       | 5               | 639.15    | 0.00     | 462.44   | 176.71   | 
    | MAIN-7048      | APPS-7048       | 6               | 710.18    | 0.00     | 542.46   | 167.72   | 
    | MAIN-7048      | APPS-7048       | 7               | 1426.21   | 0.00     | 849.48   | 576.73   | 
    | MAIN-7048      | APPS-7048       | 8               | 1266.24   | 0.00     | 1064.16  | 202.08   | 
    | MAIN-7048      | APPS-7048       | 9               | 939.27    | 0.00     | 481.18   | 458.09   | 
    | MAIN-7048      | APPS-7048       | 10              | 522.30    | 0.00     | 300.20   | 222.10   | 
    | MAIN-7048      | APPS-7048       | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 14              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 20              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | MAIN-7048      | APPS-7048       | 22              | 760.66    | 0.00     | 570.44   | 190.22   | 
    | MAIN-7048      | APPS-7048       | 23              | 982.69    | 0.00     | 613.46   | 369.23   | 
    | MAIN-7048      | APPS-7048       | 24              | 694.72    | 0.00     | 494.48   | 200.24   | 


    # Check MonitoringDeliverables.HeldReportedActualGroup. All data should show as processed
    Then  there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017048' and Collection 'R14' marked as unprocessed
    And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017048' and Collection 'APPS30' marked as unprocessed
	And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1920' OrgId 'ORG0017048' and Collection 'R03' marked as unprocessed
    And   there are '0' rows on table HeldReportedActualGroup for FSP 'APPS1920' OrgId 'ORG0017048' and Collection 'APPS30' marked as unprocessed


	# Tidy Up
	And   the override date is reset 
	 
	  