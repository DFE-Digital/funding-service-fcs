Feature: ActualsA 23166

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run45
Scenario: A567 Create and approve a 4-allocation 1819 Mainstream contract with contracting org equal to delivery org plus two more delivery orgs. Consume actuals. Check CRM and PaaS. Bulk amend and approve. Check CRM and PaaS.
    Given there is no Contract, Task or Workflow data for UKPRN '10017567' 

    # Took 98 secs
    # Clear down subnominal data from CRM and PaaS
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16TR-5671     |
    | APPS-5672     |
    | 16TR-5673     |
    | APPS-5673     |
	
    # Clear down data from the CRM Organisation table
    And   there is no Organisation data for UKPRN '10017567' 
    And   there is no Organisation data for UKPRN '10217567' 
    And   there is no Organisation data for UKPRN '10317567' 

	# Ensure the Org Service has unique names for the relevant organisations 
	And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017567 | 117567 | 10017567 Co Ltd | 0              | Active |
    | 10217567 | 127767 | 10217567 Co Ltd | 0              | Active |
    | 10317567 | 137767 | 10317567 Co Ltd | 0              | Active |

    # Associate an Advisor with a provider and create an Org in CRM
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017567 Co Ltd' with UKPRN '10017567' and OrgId 'ORG0017567' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10217567 Co Ltd' with UKPRN '10217567' and OrgId 'ORG0217567' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10317567 Co Ltd' with UKPRN '10317567' and OrgId 'ORG0317567' and has 'FCS1 Test' as a manager 


    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017567 | 10017567 Co Ltd      | ESFA-567             | MAIN-567       | 1                     | 01/08/2018        | 31/07/2019      | 151894.00     |                                | Contract for Services | 1819   | New          | ORG0017567 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName   | UoPCode    | AllocationDescription   | CRMIntent    | DeliveryOrg |
    | 10017567 | MAIN-567       | 16TR-5671     | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2018          | 31/07/2019        | 51078.00        |           |            |                         | New          | 10017567    |
    | 10017567 | MAIN-567       | APPS-5672     | APPS              | APPS1819                | AY                      | 01/08/2018          | 31/07/2019        | 26181.00        |           |            |                         | New          | 10217567    |
    | 10017567 | MAIN-567       | 16TR-5673     | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2018          | 31/07/2019        | 51270.00        |           |            |                         | New          | 10317567    |
    | 10017567 | MAIN-567       | APPS-5673     | APPS              | APPS1819                | AY                      | 01/08/2018          | 31/07/2019        | 23365.00        |           |            |                         | New          | 10317567    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                   | CRMIntent    | DeliveryOrg |
    | 10017567 | MAIN-567       | 16TR-5671     | 1               | 0                     | 51078.00  | 6082.00  | 6161.00  | 1239.00  | 6635.00  | 3517.00  | 7203.00  | 830.00   | 5148.00  | 4279.00  | 3186.00  | 1778.00  | 5020.00  | 16-18 Traineeships Funding               | New          | 10017567    |
    | 10017567 | MAIN-567       | 16TR-5671     | 2               | 1                     | 28211.00  | 3252.00  | 2437.00  | 198.00   | 3212.00  | 2555.00  | 3543.00  | 579.00   | 3054.00  | 3030.00  | 2120.00  | 1147.00  | 3084.00  | 16-18 Traineeships Programme Funding     | New          | 10017567    |
    | 10017567 | MAIN-567       | 16TR-5671     | 3               | 1                     | 22867.00  | 2830.00  | 3724.00  | 1041.00  | 3423.00  | 962.00   | 3660.00  | 251.00   | 2094.00  | 1249.00  | 1066.00  | 631.00   | 1936.00  | 16-18 Traineeships Bursary Funding       | New          | 10017567    |
	#
    | 10017567 | MAIN-567       | APPS-5672     | 1               | 0                     | 26181.00  | 501.00   | 2597.00  | 3713.00  | 1346.00  | 2779.00  | 447.00   | 3743.00  | 2992.00  | 1544.00  | 2186.00  | 2226.00  | 2107.00  | Apprenticeships Carry-In Total Funding   | New          | 10217567    |
	#
    | 10017567 | MAIN-567       | 16TR-5673     | 1               | 0                     | 51270.00  | 3630.00  | 3709.00  | 6191.00  | 4184.00  | 4768.00  | 4752.00  | 5780.00  | 2697.00  | 5528.00  | 4436.00  | 3027.00  | 2568.00  | 16-18 Traineeships Funding               | New          | 10317567    |
    | 10017567 | MAIN-567       | 16TR-5673     | 2               | 1                     | 23739.00  | 2262.00  | 1447.00  | 2910.00  | 2223.00  | 1566.00  | 2554.00  | 3290.00  | 2065.00  | 2040.00  | 1131.00  | 157.00   | 2094.00  | 16-18 Traineeships Programme Funding     | New          | 10317567    |
    | 10017567 | MAIN-567       | 16TR-5673     | 3               | 1                     | 27531.00  | 1368.00  | 2262.00  | 3281.00  | 1961.00  | 3202.00  | 2198.00  | 2490.00  | 632.00   | 3488.00  | 3305.00  | 2870.00  | 474.00   | 16-18 Traineeships Bursary Funding       | New          | 10317567    |
    | 10017567 | MAIN-567       | APPS-5673     | 1               | 0                     | 23365.00  | 3512.00  | 1432.00  | 2988.00  | 1036.00  | 1456.00  | 1179.00  | 2010.00  | 2237.00  | 3290.00  | 1115.00  | 1219.00  | 1891.00  | Apprenticeships Carry-In Total Funding   | New          | 10317567    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '14/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-567' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '20/07/2018'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-567' and actual ContractNumber 'MAIN-567'

#    # Check that the contract is now approved
#    Then  the latest version of contract 'MAIN-567' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017567 | MAIN-567           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017567 | ESFA-567           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

	# Took 67 secs 
	# Check the deliverable count in CRM includes all the monitoring deliverables
	And   there are '648' deliverable period rows in CRM linked to the latest version of contract 'MAIN-567'
    #And   there are '36' deliverable periods in CRM linked to the latest version of contract 'MAIN-567' and allocation '16TR-5671'
    #And   there are '288' deliverable periods in CRM linked to the latest version of contract 'MAIN-567' and allocation 'APPS-5672'
    #And   there are '36' deliverable periods in CRM linked to the latest version of contract 'MAIN-567' and allocation '16TR-5673'
    #And   there are '288' deliverable periods in CRM linked to the latest version of contract 'MAIN-567' and allocation 'APPS-5673'

	# Took 187 secs
    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code | Period | Payment Type   |
	| 16TR-5671     | 2201350         | Jul-19 | Reconciliation |
	| APPS-5672     | 2340170         | Jul-19 | Reconciliation |
	| 16TR-5673     | 2201350         | Jul-19 | Reconciliation |
	| APPS-5673     | 2340170         | Jul-19 | Reconciliation |




    # Change the date
    Given the override date is '04/11/2018'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the three OrgIds 
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017567'
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0217567'
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0317567'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Oct 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201808 | 16-18TRN1819            | 16TR-5671                |            | 2               | 0            | 1793.32     |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201808 | 16-18TRN1819            | 16TR-5671                |            | 3               | 0            | 1380.22     |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201809 | 16-18TRN1819            | 16TR-5671                |            | 2               | 0            | 1490.85     |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201809 | 16-18TRN1819            | 16TR-5671                |            | 3               | 0            | 794.95      |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201810 | 16-18TRN1819            | 16TR-5671                |            | 2               | 0            | 824.67      |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201810 | 16-18TRN1819            | 16TR-5671                |            | 3               | 0            | 1959.38     |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201811 | 16-18TRN1819            | 16TR-5671                |            | 2               | 0            | 133.64      |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201811 | 16-18TRN1819            | 16TR-5671                |            | 3               | 0            | 1925.74     |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201812 | 16-18TRN1819            | 16TR-5671                |            | 2               | 0            | 2054.78     |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201812 | 16-18TRN1819            | 16TR-5671                |            | 3               | 0            | 1801.69     |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201901 | 16-18TRN1819            | 16TR-5671                |            | 2               | 0            | 208.84      |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201901 | 16-18TRN1819            | 16TR-5671                |            | 3               | 0            | 1093.68     |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201902 | 16-18TRN1819            | 16TR-5671                |            | 2               | 0            | 2170.29     |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201902 | 16-18TRN1819            | 16TR-5671                |            | 3               | 0            | 1997.15     |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201903 | 16-18TRN1819            | 16TR-5671                |            | 2               | 0            | 996.49      |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201903 | 16-18TRN1819            | 16TR-5671                |            | 3               | 0            | 2408.69     |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201904 | 16-18TRN1819            | 16TR-5671                |            | 2               | 0            | 2191.47     |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201904 | 16-18TRN1819            | 16TR-5671                |            | 3               | 0            | 234.96      |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201905 | 16-18TRN1819            | 16TR-5671                |            | 2               | 0            | 2378.94     |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201905 | 16-18TRN1819            | 16TR-5671                |            | 3               | 0            | 973.64      |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201906 | 16-18TRN1819            | 16TR-5671                |            | 2               | 0            | 1359.68     |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201906 | 16-18TRN1819            | 16TR-5671                |            | 3               | 0            | 1941.07     |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201907 | 16-18TRN1819            | 16TR-5671                |            | 2               | 0            | 228.41      |
    | ILR1819        | R03                  | ORG0017567     | CM             | 201907 | 16-18TRN1819            | 16TR-5671                |            | 3               | 0            | 1521.90     |
    #
    | APPS           | APPS18               | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 8               | 0            | 498.27      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 9               | 0            | 163.90      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 10              | 0            | 514.08      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 22              | 0            | 634.81      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 23              | 0            | 521.36      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 24              | 0            | 1428.00     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 8               | 0            | 1471.77     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 9               | 0            | 661.92      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 10              | 0            | 489.59      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 22              | 0            | 324.61      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 23              | 0            | 327.95      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 24              | 0            | 1005.22     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 8               | 0            | 674.10      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 9               | 0            | 677.87      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 10              | 0            | 1097.82     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 22              | 0            | 556.69      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 23              | 0            | 986.45      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 24              | 0            | 390.58      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 8               | 0            | 360.42      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 9               | 0            | 916.70      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 10              | 0            | 213.00      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 22              | 0            | 741.16      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 23              | 0            | 1368.03     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 24              | 0            | 465.91      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 8               | 0            | 1199.30     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 9               | 0            | 630.46      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 10              | 0            | 505.53      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 22              | 0            | 1387.13     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 23              | 0            | 984.44      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 24              | 0            | 978.70      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 8               | 0            | 699.84      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 9               | 0            | 237.16      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 10              | 0            | 885.46      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 22              | 0            | 1072.28     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 23              | 0            | 1379.21     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 24              | 0            | 1268.75     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 8               | 0            | 131.68      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 9               | 0            | 860.71      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 10              | 0            | 1382.63     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 22              | 0            | 702.36      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 23              | 0            | 1049.13     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 24              | 0            | 803.44      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 8               | 0            | 819.23      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 9               | 0            | 748.17      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 10              | 0            | 594.86      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 22              | 0            | 666.77      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 23              | 0            | 477.62      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 24              | 0            | 177.83      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 8               | 0            | 441.38      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 9               | 0            | 1470.71     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 10              | 0            | 185.28      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 22              | 0            | 646.41      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 23              | 0            | 610.99      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 24              | 0            | 785.85      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 8               | 0            | 317.92      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 9               | 0            | 764.24      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 10              | 0            | 460.17      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 22              | 0            | 980.25      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 23              | 0            | 858.90      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 24              | 0            | 318.82      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 8               | 0            | 1413.97     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 9               | 0            | 1016.30     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 10              | 0            | 808.52      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 22              | 0            | 646.66      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 23              | 0            | 250.32      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 24              | 0            | 1197.60     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 8               | 0            | 743.50      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 9               | 0            | 1155.17     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 10              | 0            | 934.53      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 22              | 0            | 1265.83     |
    | APPS           | APPS18               | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 23              | 0            | 126.26      |
    | APPS           | APPS18               | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 24              | 0            | 394.51      |
    #
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 2               | 0            | 203.53      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 3               | 0            | 247.63      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 4               | 0            | 564.37      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 5               | 0            | 279.55      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 6               | 0            | 100.33      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 7               | 0            | 851.51      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 11              | 0            | 1019.88     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 12              | 0            | 861.62      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 13              | 0            | 1258.38     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 14              | 0            | 214.65      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 15              | 0            | 368.69      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 16              | 0            | 1050.48     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 17              | 0            | 735.89      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 18              | 0            | 599.83      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 19              | 0            | 309.97      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 20              | 0            | 1086.16     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201808 | APPS1819                | APPS-5672                |            | 21              | 0            | 1400.30     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 2               | 0            | 842.30      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 3               | 0            | 225.49      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 4               | 0            | 1160.82     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 5               | 0            | 662.58      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 6               | 0            | 746.62      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 7               | 0            | 789.03      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 11              | 0            | 390.68      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 12              | 0            | 561.63      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 13              | 0            | 233.60      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 14              | 0            | 925.71      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 15              | 0            | 337.82      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 16              | 0            | 1398.67     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 17              | 0            | 237.10      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 18              | 0            | 721.41      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 19              | 0            | 482.12      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 20              | 0            | 1321.57     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201809 | APPS1819                | APPS-5672                |            | 21              | 0            | 1150.97     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 2               | 0            | 482.12      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 3               | 0            | 1043.11     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 4               | 0            | 459.28      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 5               | 0            | 225.85      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 6               | 0            | 143.33      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 7               | 0            | 551.80      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 11              | 0            | 1206.18     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 12              | 0            | 516.16      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 13              | 0            | 429.39      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 14              | 0            | 772.66      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 15              | 0            | 456.44      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 16              | 0            | 576.85      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 17              | 0            | 162.90      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 18              | 0            | 775.40      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 19              | 0            | 388.42      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 20              | 0            | 1310.35     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201810 | APPS1819                | APPS-5672                |            | 21              | 0            | 924.08      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 2               | 0            | 1156.87     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 3               | 0            | 1399.04     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 4               | 0            | 563.42      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 5               | 0            | 860.12      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 6               | 0            | 212.96      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 7               | 0            | 988.12      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 11              | 0            | 674.05      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 12              | 0            | 1444.60     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 13              | 0            | 260.47      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 14              | 0            | 1392.83     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 15              | 0            | 968.29      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 16              | 0            | 586.82      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 17              | 0            | 308.94      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 18              | 0            | 771.97      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 19              | 0            | 407.17      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 20              | 0            | 1491.23     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201811 | APPS1819                | APPS-5672                |            | 21              | 0            | 282.58      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 2               | 0            | 140.44      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 3               | 0            | 583.55      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 4               | 0            | 866.74      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 5               | 0            | 1392.14     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 6               | 0            | 853.55      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 7               | 0            | 668.99      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 11              | 0            | 1286.15     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 12              | 0            | 1256.72     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 13              | 0            | 1041.40     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 14              | 0            | 1110.66     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 15              | 0            | 1495.48     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 16              | 0            | 575.73      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 17              | 0            | 793.30      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 18              | 0            | 678.15      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 19              | 0            | 1073.40     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 20              | 0            | 350.72      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201812 | APPS1819                | APPS-5672                |            | 21              | 0            | 692.08      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 2               | 0            | 860.45      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 3               | 0            | 1240.53     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 4               | 0            | 857.28      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 5               | 0            | 698.55      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 6               | 0            | 812.70      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 7               | 0            | 418.89      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 11              | 0            | 966.86      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 12              | 0            | 785.76      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 13              | 0            | 1053.15     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 14              | 0            | 1341.24     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 15              | 0            | 618.72      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 16              | 0            | 523.49      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 17              | 0            | 510.01      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 18              | 0            | 310.43      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 19              | 0            | 841.75      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 20              | 0            | 412.56      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201901 | APPS1819                | APPS-5672                |            | 21              | 0            | 918.34      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 2               | 0            | 608.84      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 3               | 0            | 1326.37     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 4               | 0            | 769.22      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 5               | 0            | 366.88      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 6               | 0            | 1057.69     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 7               | 0            | 1146.38     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 11              | 0            | 959.51      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 12              | 0            | 1195.00     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 13              | 0            | 326.44      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 14              | 0            | 1230.89     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 15              | 0            | 383.66      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 16              | 0            | 1439.47     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 17              | 0            | 192.19      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 18              | 0            | 186.13      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 19              | 0            | 1210.48     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 20              | 0            | 631.45      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201902 | APPS1819                | APPS-5672                |            | 21              | 0            | 749.02      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 2               | 0            | 267.36      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 3               | 0            | 261.65      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 4               | 0            | 343.28      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 5               | 0            | 167.36      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 6               | 0            | 1100.75     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 7               | 0            | 846.23      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 11              | 0            | 885.41      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 12              | 0            | 403.42      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 13              | 0            | 755.21      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 14              | 0            | 1144.90     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 15              | 0            | 1153.24     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 16              | 0            | 658.50      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 17              | 0            | 1364.34     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 18              | 0            | 1144.41     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 19              | 0            | 223.98      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 20              | 0            | 988.40      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201903 | APPS1819                | APPS-5672                |            | 21              | 0            | 1098.24     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 2               | 0            | 121.95      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 3               | 0            | 703.60      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 4               | 0            | 662.77      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 5               | 0            | 485.41      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 6               | 0            | 1479.53     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 7               | 0            | 1223.63     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 11              | 0            | 1074.54     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 12              | 0            | 684.64      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 13              | 0            | 1128.29     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 14              | 0            | 488.03      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 15              | 0            | 599.22      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 16              | 0            | 706.84      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 17              | 0            | 1422.96     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 18              | 0            | 270.17      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 19              | 0            | 1004.33     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 20              | 0            | 586.96      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201904 | APPS1819                | APPS-5672                |            | 21              | 0            | 246.20      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 2               | 0            | 359.56      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 3               | 0            | 208.75      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 4               | 0            | 705.86      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 5               | 0            | 1442.98     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 6               | 0            | 858.84      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 7               | 0            | 792.13      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 11              | 0            | 1462.16     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 12              | 0            | 404.92      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 13              | 0            | 630.59      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 14              | 0            | 654.18      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 15              | 0            | 494.10      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 16              | 0            | 804.72      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 17              | 0            | 294.22      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 18              | 0            | 824.16      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 19              | 0            | 1451.51     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 20              | 0            | 880.50      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201905 | APPS1819                | APPS-5672                |            | 21              | 0            | 1372.89     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 2               | 0            | 1020.16     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 3               | 0            | 717.56      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 4               | 0            | 1070.19     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 5               | 0            | 190.28      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 6               | 0            | 1158.53     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 7               | 0            | 1080.72     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 11              | 0            | 795.90      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 12              | 0            | 317.61      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 13              | 0            | 413.23      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 14              | 0            | 556.60      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 15              | 0            | 1198.29     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 16              | 0            | 170.36      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 17              | 0            | 825.22      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 18              | 0            | 1159.84     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 19              | 0            | 1220.94     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 20              | 0            | 555.29      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201906 | APPS1819                | APPS-5672                |            | 21              | 0            | 1461.83     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 2               | 0            | 1225.98     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 3               | 0            | 1044.76     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 4               | 0            | 1367.19     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 5               | 0            | 1326.10     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 6               | 0            | 683.31      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 7               | 0            | 272.31      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 11              | 0            | 1435.83     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 12              | 0            | 1216.22     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 13              | 0            | 1074.80     |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 14              | 0            | 662.25      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 15              | 0            | 122.81      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 16              | 0            | 334.86      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 17              | 0            | 329.92      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 18              | 0            | 813.61      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 19              | 0            | 668.49      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 20              | 0            | 248.58      |
    | ILR1819        | R03                  | ORG0217567     | CM             | 201907 | APPS1819                | APPS-5672                |            | 21              | 0            | 486.57      |
    #
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | 16-18TRN1819            | 16TR-5673                |            | 2               | 0            | 1224.88     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | 16-18TRN1819            | 16TR-5673                |            | 3               | 0            | 815.60      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | 16-18TRN1819            | 16TR-5673                |            | 2               | 0            | 1594.47     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | 16-18TRN1819            | 16TR-5673                |            | 3               | 0            | 1654.77     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | 16-18TRN1819            | 16TR-5673                |            | 2               | 0            | 733.10      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | 16-18TRN1819            | 16TR-5673                |            | 3               | 0            | 770.42      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | 16-18TRN1819            | 16TR-5673                |            | 2               | 0            | 2091.53     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | 16-18TRN1819            | 16TR-5673                |            | 3               | 0            | 2079.05     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | 16-18TRN1819            | 16TR-5673                |            | 2               | 0            | 1513.99     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | 16-18TRN1819            | 16TR-5673                |            | 3               | 0            | 2466.63     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | 16-18TRN1819            | 16TR-5673                |            | 2               | 0            | 2286.32     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | 16-18TRN1819            | 16TR-5673                |            | 3               | 0            | 644.48      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | 16-18TRN1819            | 16TR-5673                |            | 2               | 0            | 1768.28     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | 16-18TRN1819            | 16TR-5673                |            | 3               | 0            | 2452.01     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | 16-18TRN1819            | 16TR-5673                |            | 2               | 0            | 685.43      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | 16-18TRN1819            | 16TR-5673                |            | 3               | 0            | 1381.30     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | 16-18TRN1819            | 16TR-5673                |            | 2               | 0            | 355.28      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | 16-18TRN1819            | 16TR-5673                |            | 3               | 0            | 2498.60     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | 16-18TRN1819            | 16TR-5673                |            | 2               | 0            | 1722.82     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | 16-18TRN1819            | 16TR-5673                |            | 3               | 0            | 137.68      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | 16-18TRN1819            | 16TR-5673                |            | 2               | 0            | 1480.44     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | 16-18TRN1819            | 16TR-5673                |            | 3               | 0            | 340.12      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | 16-18TRN1819            | 16TR-5673                |            | 2               | 0            | 347.25      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | 16-18TRN1819            | 16TR-5673                |            | 3               | 0            | 2017.33     |
    #
    | APPS           | APPS18               | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 8               | 0            | 1087.77     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 9               | 0            | 846.79      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 10              | 0            | 911.33      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 22              | 0            | 505.39      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 23              | 0            | 522.73      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 24              | 0            | 1184.64     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 8               | 0            | 119.62      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 9               | 0            | 1165.02     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 10              | 0            | 1240.29     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 22              | 0            | 1092.66     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 23              | 0            | 163.49      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 24              | 0            | 679.64      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 8               | 0            | 1307.67     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 9               | 0            | 1206.67     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 10              | 0            | 622.95      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 22              | 0            | 1446.74     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 23              | 0            | 1320.03     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 24              | 0            | 178.73      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 8               | 0            | 1429.38     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 9               | 0            | 609.62      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 10              | 0            | 834.82      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 22              | 0            | 1173.96     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 23              | 0            | 174.90      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 24              | 0            | 929.44      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 8               | 0            | 756.18      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 9               | 0            | 517.43      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 10              | 0            | 971.78      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 22              | 0            | 1006.95     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 23              | 0            | 469.31      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 24              | 0            | 491.08      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 8               | 0            | 1261.73     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 9               | 0            | 1254.45     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 10              | 0            | 924.83      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 22              | 0            | 1480.54     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 23              | 0            | 1375.35     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 24              | 0            | 417.61      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 8               | 0            | 1073.16     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 9               | 0            | 1472.01     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 10              | 0            | 441.50      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 22              | 0            | 847.42      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 23              | 0            | 248.91      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 24              | 0            | 1499.19     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 8               | 0            | 1046.65     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 9               | 0            | 121.98      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 10              | 0            | 905.26      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 22              | 0            | 240.07      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 23              | 0            | 244.23      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 24              | 0            | 1218.44     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 8               | 0            | 498.27      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 9               | 0            | 163.90      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 10              | 0            | 514.08      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 22              | 0            | 634.81      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 23              | 0            | 521.36      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 24              | 0            | 1428.00     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 8               | 0            | 1471.77     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 9               | 0            | 661.92      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 10              | 0            | 489.59      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 22              | 0            | 324.61      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 23              | 0            | 327.95      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 24              | 0            | 1005.22     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 8               | 0            | 674.10      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 9               | 0            | 677.87      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 10              | 0            | 1097.82     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 22              | 0            | 556.69      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 23              | 0            | 986.45      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 24              | 0            | 390.58      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 8               | 0            | 360.42      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 9               | 0            | 916.70      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 10              | 0            | 213.00      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 22              | 0            | 741.16      |
    | APPS           | APPS18               | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 23              | 0            | 1368.03     |
    | APPS           | APPS18               | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 24              | 0            | 465.91      |
    #
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 2               | 0            | 1199.30     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 3               | 0            | 630.46      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 4               | 0            | 505.53      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 5               | 0            | 1387.13     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 6               | 0            | 984.44      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 7               | 0            | 978.70      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 11              | 0            | 699.84      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 12              | 0            | 237.16      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 13              | 0            | 885.46      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 14              | 0            | 1072.28     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 15              | 0            | 1379.21     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 16              | 0            | 1268.75     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 17              | 0            | 131.68      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 18              | 0            | 860.71      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 19              | 0            | 1382.63     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 20              | 0            | 702.36      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201808 | APPS1819                | APPS-5673                |            | 21              | 0            | 1049.13     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 2               | 0            | 803.44      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 3               | 0            | 819.23      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 4               | 0            | 748.17      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 5               | 0            | 594.86      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 6               | 0            | 666.77      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 7               | 0            | 477.62      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 11              | 0            | 177.83      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 12              | 0            | 441.38      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 13              | 0            | 1470.71     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 14              | 0            | 185.28      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 15              | 0            | 646.41      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 16              | 0            | 610.99      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 17              | 0            | 785.85      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 18              | 0            | 317.92      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 19              | 0            | 764.24      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 20              | 0            | 460.17      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201809 | APPS1819                | APPS-5673                |            | 21              | 0            | 980.25      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 2               | 0            | 858.90      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 3               | 0            | 318.82      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 4               | 0            | 1413.97     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 5               | 0            | 1016.30     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 6               | 0            | 808.52      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 7               | 0            | 646.66      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 11              | 0            | 250.32      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 12              | 0            | 1197.60     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 13              | 0            | 743.50      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 14              | 0            | 1155.17     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 15              | 0            | 934.53      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 16              | 0            | 1265.83     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 17              | 0            | 126.26      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 18              | 0            | 394.51      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 19              | 0            | 203.53      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 20              | 0            | 247.63      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201810 | APPS1819                | APPS-5673                |            | 21              | 0            | 564.37      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 2               | 0            | 279.55      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 3               | 0            | 100.33      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 4               | 0            | 851.51      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 5               | 0            | 1019.88     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 6               | 0            | 861.62      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 7               | 0            | 1258.38     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 11              | 0            | 214.65      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 12              | 0            | 368.69      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 13              | 0            | 1050.48     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 14              | 0            | 735.89      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 15              | 0            | 599.83      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 16              | 0            | 309.97      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 17              | 0            | 1086.16     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 18              | 0            | 1400.30     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 19              | 0            | 842.30      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 20              | 0            | 225.49      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201811 | APPS1819                | APPS-5673                |            | 21              | 0            | 1160.82     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 2               | 0            | 662.58      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 3               | 0            | 746.62      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 4               | 0            | 789.03      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 5               | 0            | 390.68      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 6               | 0            | 561.63      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 7               | 0            | 233.60      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 11              | 0            | 925.71      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 12              | 0            | 337.82      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 13              | 0            | 1398.67     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 14              | 0            | 237.10      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 15              | 0            | 721.41      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 16              | 0            | 482.12      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 17              | 0            | 1321.57     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 18              | 0            | 1150.97     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 19              | 0            | 482.12      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 20              | 0            | 1043.11     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201812 | APPS1819                | APPS-5673                |            | 21              | 0            | 459.28      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 2               | 0            | 225.85      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 3               | 0            | 143.33      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 4               | 0            | 551.80      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 5               | 0            | 1206.18     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 6               | 0            | 516.16      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 7               | 0            | 429.39      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 11              | 0            | 772.66      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 12              | 0            | 456.44      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 13              | 0            | 576.85      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 14              | 0            | 162.90      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 15              | 0            | 775.40      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 16              | 0            | 388.42      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 17              | 0            | 1310.35     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 18              | 0            | 924.08      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 19              | 0            | 1156.87     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 20              | 0            | 1399.04     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201901 | APPS1819                | APPS-5673                |            | 21              | 0            | 563.42      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 2               | 0            | 860.12      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 3               | 0            | 212.96      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 4               | 0            | 988.12      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 5               | 0            | 674.05      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 6               | 0            | 1444.60     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 7               | 0            | 260.47      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 11              | 0            | 1392.83     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 12              | 0            | 968.29      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 13              | 0            | 586.82      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 14              | 0            | 308.94      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 15              | 0            | 771.97      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 16              | 0            | 407.17      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 17              | 0            | 1491.23     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 18              | 0            | 282.58      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 19              | 0            | 140.44      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 20              | 0            | 583.55      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201902 | APPS1819                | APPS-5673                |            | 21              | 0            | 866.74      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 2               | 0            | 1392.14     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 3               | 0            | 853.55      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 4               | 0            | 668.99      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 5               | 0            | 1286.15     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 6               | 0            | 1256.72     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 7               | 0            | 1041.40     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 11              | 0            | 1110.66     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 12              | 0            | 1495.48     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 13              | 0            | 575.73      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 14              | 0            | 793.30      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 15              | 0            | 678.15      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 16              | 0            | 1073.40     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 17              | 0            | 350.72      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 18              | 0            | 692.08      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 19              | 0            | 860.45      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 20              | 0            | 1240.53     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201903 | APPS1819                | APPS-5673                |            | 21              | 0            | 857.28      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 2               | 0            | 698.55      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 3               | 0            | 812.70      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 4               | 0            | 418.89      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 5               | 0            | 966.86      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 6               | 0            | 785.76      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 7               | 0            | 1053.15     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 11              | 0            | 1341.24     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 12              | 0            | 618.72      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 13              | 0            | 523.49      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 14              | 0            | 510.01      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 15              | 0            | 310.43      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 16              | 0            | 841.75      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 17              | 0            | 412.56      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 18              | 0            | 918.34      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 19              | 0            | 608.84      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 20              | 0            | 1326.37     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201904 | APPS1819                | APPS-5673                |            | 21              | 0            | 769.22      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 2               | 0            | 366.88      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 3               | 0            | 1057.69     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 4               | 0            | 1146.38     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 5               | 0            | 959.51      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 6               | 0            | 1195.00     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 7               | 0            | 326.44      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 11              | 0            | 1230.89     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 12              | 0            | 383.66      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 13              | 0            | 1439.47     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 14              | 0            | 192.19      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 15              | 0            | 186.13      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 16              | 0            | 1210.48     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 17              | 0            | 631.45      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 18              | 0            | 749.02      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 19              | 0            | 267.36      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 20              | 0            | 261.65      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201905 | APPS1819                | APPS-5673                |            | 21              | 0            | 343.28      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 2               | 0            | 167.36      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 3               | 0            | 1100.75     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 4               | 0            | 846.23      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 5               | 0            | 885.41      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 6               | 0            | 403.42      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 7               | 0            | 755.21      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 11              | 0            | 1144.90     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 12              | 0            | 1153.24     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 13              | 0            | 658.50      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 14              | 0            | 1364.34     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 15              | 0            | 1144.41     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 16              | 0            | 223.98      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 17              | 0            | 988.40      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 18              | 0            | 1098.24     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 19              | 0            | 121.95      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 20              | 0            | 703.60      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201906 | APPS1819                | APPS-5673                |            | 21              | 0            | 662.77      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 2               | 0            | 485.41      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 3               | 0            | 1479.53     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 4               | 0            | 1223.63     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 5               | 0            | 1074.54     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 6               | 0            | 684.64      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 7               | 0            | 1128.29     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 11              | 0            | 488.03      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 12              | 0            | 599.22      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 13              | 0            | 706.84      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 14              | 0            | 1422.96     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 15              | 0            | 270.17      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 16              | 0            | 1004.33     |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 17              | 0            | 586.96      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 18              | 0            | 246.20      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 19              | 0            | 359.56      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 20              | 0            | 208.75      |
    | ILR1819        | R03                  | ORG0317567     | CM             | 201907 | APPS1819                | APPS-5673                |            | 21              | 0            | 705.86      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

   # Check the ACTUAL VALUES in CRM (Make sure they have arrived before marking month-end as complete)
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | 
    | MAIN-567       | 16TR-5671       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | MAIN-567       | 16TR-5671       | 2               | 4108.84  | 1793.32  | 1490.85  | 824.67   | ?        | ?        | 
    | MAIN-567       | 16TR-5671       | 3               | 4134.55  | 1380.22  | 794.95   | 1959.38  | ?        | ?        | 

	# Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes any held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered

   # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | 
    | MAIN-567       | 16TR-5671       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | 16TR-5671       | 2               | 4108.84  | 1793.32  | 1490.85  | 824.67   | ?        | ?        |  
    | MAIN-567       | 16TR-5671       | 3               | 4134.55  | 1380.22  | 794.95   | 1959.38  | ?        | ?        |  
    #
    | MAIN-567       | APPS-5672       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 2               | 1527.95  | 203.53   | 842.30   | 482.12   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 3               | 1516.23  | 247.63   | 225.49   | 1043.11  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 4               | 2184.47  | 564.37   | 1160.82  | 459.28   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 5               | 1167.98  | 279.55   | 662.58   | 225.85   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 6               | 990.28   | 100.33   | 746.62   | 143.33   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 7               | 2192.34  | 851.51   | 789.03   | 551.80   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 8               | 2644.14  | 498.27   | 1471.77  | 674.10   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 9               | 1503.69  | 163.90   | 661.92   | 677.87   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 10              | 2101.49  | 514.08   | 489.59   | 1097.82  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 11              | 2616.74  | 1019.88  | 390.68   | 1206.18  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 12              | 1939.41  | 861.62   | 561.63   | 516.16   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 13              | 1921.37  | 1258.38  | 233.60   | 429.39   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 14              | 1913.02  | 214.65   | 925.71   | 772.66   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 15              | 1162.95  | 368.69   | 337.82   | 456.44   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 16              | 3026.00  | 1050.48  | 1398.67  | 576.85   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 17              | 1135.89  | 735.89   | 237.10   | 162.90   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 18              | 2096.64  | 599.83   | 721.41   | 775.40   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 19              | 1180.51  | 309.97   | 482.12   | 388.42   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 20              | 3718.08  | 1086.16  | 1321.57  | 1310.35  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 21              | 3475.35  | 1400.30  | 1150.97  | 924.08   | ?        | ?        | 
    | MAIN-567       | APPS-5672       | 22              | 1516.11  | 634.81   | 324.61   | 556.69   | ?        | ?        | 
    | MAIN-567       | APPS-5672       | 23              | 1835.76  | 521.36   | 327.95   | 986.45   | ?        | ?        | 
    | MAIN-567       | APPS-5672       | 24              | 2823.80  | 1428.00  | 1005.22  | 390.58   | ?        | ?        | 
    #
    | MAIN-567       | 16TR-5673       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | MAIN-567       | 16TR-5673       | 2               | 3552.45  | 1224.88  | 1594.47  | 733.10   | ?        | ?        | 
    | MAIN-567       | 16TR-5673       | 3               | 3240.79  | 815.60   | 1654.77  | 770.42   | ?        | ?        | 
    #
    | MAIN-567       | APPS-5673       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 2               | 2861.64  | 1199.30  | 803.44   | 858.90   | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 3               | 1768.51  | 630.46   | 819.23   | 318.82   | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 4               | 2667.67  | 505.53   | 748.17   | 1413.97  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 5               | 2998.29  | 1387.13  | 594.86   | 1016.30  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 6               | 2459.73  | 984.44   | 666.77   | 808.52   | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 7               | 2102.98  | 978.70   | 477.62   | 646.66   | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 8               | 2515.06  | 1087.77  | 119.62   | 1307.67  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 9               | 3218.48  | 846.79   | 1165.02  | 1206.67  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 10              | 2774.57  | 911.33   | 1240.29  | 622.95   | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 11              | 1127.99  | 699.84   | 177.83   | 250.32   | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 12              | 1876.14  | 237.16   | 441.38   | 1197.60  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 13              | 3099.67  | 885.46   | 1470.71  | 743.50   | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 14              | 2412.73  | 1072.28  | 185.28   | 1155.17  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 15              | 2960.15  | 1379.21  | 646.41   | 934.53   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 16              | 3145.57  | 1268.75  | 610.99   | 1265.83  | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 17              | 1043.79  | 131.68   | 785.85   | 126.26   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 18              | 1573.14  | 860.71   | 317.92   | 394.51   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 19              | 2350.40  | 1382.63  | 764.24   | 203.53   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 20              | 1410.16  | 702.36   | 460.17   | 247.63   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 21              | 2593.75  | 1049.13  | 980.25   | 564.37   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 22              | 3044.79  | 505.39   | 1092.66  | 1446.74  | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 23              | 2006.25  | 522.73   | 163.49   | 1320.03  | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 24              | 2043.01  | 1184.64  | 679.64   | 178.73   | ?        | ?        |  

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | 
    | MAIN-567       | 16TR-5671       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | 16TR-5671       | 2               | 4108.84  | 0.00     | 0.00     | 4108.84  | ?        | ?        |  
    | MAIN-567       | 16TR-5671       | 3               | 4134.55  | 0.00     | 0.00     | 4134.55  | ?        | ?        |  
    #
    | MAIN-567       | APPS-5672       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 2               | 1527.95  | 0.00     | 0.00     | 1527.95  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 3               | 1516.23  | 0.00     | 0.00     | 1516.23  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 4               | 2184.47  | 0.00     | 0.00     | 2184.47  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 5               | 1167.98  | 0.00     | 0.00     | 1167.98  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 6               | 990.28   | 0.00     | 0.00     | 990.28   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 7               | 2192.34  | 0.00     | 0.00     | 2192.34  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 8               | 2644.14  | 0.00     | 0.00     | 2644.14  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 9               | 1503.69  | 0.00     | 0.00     | 1503.69  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 10              | 2101.49  | 0.00     | 0.00     | 2101.49  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 11              | 2616.74  | 0.00     | 0.00     | 2616.74  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 12              | 1939.41  | 0.00     | 0.00     | 1939.41  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 13              | 1921.37  | 0.00     | 0.00     | 1921.37  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 14              | 1913.02  | 0.00     | 0.00     | 1913.02  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 15              | 1162.95  | 0.00     | 0.00     | 1162.95  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 16              | 3026.00  | 0.00     | 0.00     | 3026.00  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 17              | 1135.89  | 0.00     | 0.00     | 1135.89  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 18              | 2096.64  | 0.00     | 0.00     | 2096.64  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 19              | 1180.51  | 0.00     | 0.00     | 1180.51  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 20              | 3718.08  | 0.00     | 0.00     | 3718.08  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 21              | 3475.35  | 0.00     | 0.00     | 3475.35  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 22              | 1516.11  | 0.00     | 0.00     | 1516.11  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 23              | 1835.76  | 0.00     | 0.00     | 1835.76  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 24              | 2823.80  | 0.00     | 0.00     | 2823.80  | ?        | ?        |  
    #
    | MAIN-567       | 16TR-5673       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | 16TR-5673       | 2               | 3552.45  | 0.00     | 0.00     | 3552.45  | ?        | ?        |  
    | MAIN-567       | 16TR-5673       | 3               | 3240.79  | 0.00     | 0.00     | 3240.79  | ?        | ?        |  
    #
    | MAIN-567       | APPS-5673       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 2               | 2861.64  | 0.00     | 0.00     | 2861.64  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 3               | 1768.51  | 0.00     | 0.00     | 1768.51  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 4               | 2667.67  | 0.00     | 0.00     | 2667.67  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 5               | 2998.29  | 0.00     | 0.00     | 2998.29  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 6               | 2459.73  | 0.00     | 0.00     | 2459.73  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 7               | 2102.98  | 0.00     | 0.00     | 2102.98  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 8               | 2515.06  | 0.00     | 0.00     | 2515.06  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 9               | 3218.48  | 0.00     | 0.00     | 3218.48  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 10              | 2774.57  | 0.00     | 0.00     | 2774.57  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 11              | 1127.99  | 0.00     | 0.00     | 1127.99  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 12              | 1876.14  | 0.00     | 0.00     | 1876.14  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 13              | 3099.67  | 0.00     | 0.00     | 3099.67  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 14              | 2412.73  | 0.00     | 0.00     | 2412.73  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 15              | 2960.15  | 0.00     | 0.00     | 2960.15  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 16              | 3145.57  | 0.00     | 0.00     | 3145.57  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 17              | 1043.79  | 0.00     | 0.00     | 1043.79  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 18              | 1573.14  | 0.00     | 0.00     | 1573.14  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 19              | 2350.40  | 0.00     | 0.00     | 2350.40  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 20              | 1410.16  | 0.00     | 0.00     | 1410.16  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 21              | 2593.75  | 0.00     | 0.00     | 2593.75  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 22              | 3044.79  | 0.00     | 0.00     | 3044.79  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 23              | 2006.25  | 0.00     | 0.00     | 2006.25  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 24              | 2043.01  | 0.00     | 0.00     | 2043.01  | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | 
    | MAIN-567       | 16TR-5671       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | 16TR-5671       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | 16TR-5671       | 3               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    #
    | MAIN-567       | APPS-5672       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 2               | -1280.36 | 0.00     | 0.00     | -1280.36 | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 3               | -1270.54 | 0.00     | 0.00     | -1270.54 | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 4               | -1830.50 | 0.00     | 0.00     | -1830.50 | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 5               | -978.72  | 0.00     | 0.00     | -978.72  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 6               | -829.82  | 0.00     | 0.00     | -829.82  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 7               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 8               | -2215.69 | 0.00     | 0.00     | -2215.69 | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 9               | -1260.03 | 0.00     | 0.00     | -1260.03 | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 10              | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 11              | -2192.73 | 0.00     | 0.00     | -2192.73 | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 12              | -1625.15 | 0.00     | 0.00     | -1625.15 | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 13              | -1610.03 | 0.00     | 0.00     | -1610.03 | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 14              | -1603.04 | 0.00     | 0.00     | -1603.04 | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 15              | -974.51  | 0.00     | 0.00     | -974.51  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 16              | -2535.67 | 0.00     | 0.00     | -2535.67 | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 17              | -951.83  | 0.00     | 0.00     | -951.83  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 18              | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 19              | -989.22  | 0.00     | 0.00     | -989.22  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 20              | -3115.61 | 0.00     | 0.00     | -3115.61 | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 21              | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 22              | -1270.44 | 0.00     | 0.00     | -1270.44 | ?        | ?        | 
    | MAIN-567       | APPS-5672       | 23              | -1538.30 | 0.00     | 0.00     | -1538.30 | ?        | ?        | 
    | MAIN-567       | APPS-5672       | 24              | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    #
    | MAIN-567       | 16TR-5673       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | MAIN-567       | 16TR-5673       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | MAIN-567       | 16TR-5673       | 3               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    #
    | MAIN-567       | APPS-5673       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 2               | -2544.45 | 0.00     | 0.00     | -2544.45 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 3               | -1572.48 | 0.00     | 0.00     | -1572.48 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 4               | -2371.98 | 0.00     | 0.00     | -2371.98 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 5               | -2665.95 | 0.00     | 0.00     | -2665.95 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 6               | -2187.09 | 0.00     | 0.00     | -2187.09 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 7               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 8               | -2236.29 | 0.00     | 0.00     | -2236.29 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 9               | -2861.74 | 0.00     | 0.00     | -2861.74 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 10              | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 11              | -1002.96 | 0.00     | 0.00     | -1002.96 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 12              | -1668.18 | 0.00     | 0.00     | -1668.18 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 13              | -2756.10 | 0.00     | 0.00     | -2756.10 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 14              | -2145.30 | 0.00     | 0.00     | -2145.30 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 15              | -2632.04 | 0.00     | 0.00     | -2632.04 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 16              | -2796.91 | 0.00     | 0.00     | -2796.91 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 17              | -928.09  | 0.00     | 0.00     | -928.09  | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 18              | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 19              | -2089.88 | 0.00     | 0.00     | -2089.88 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 20              | -1253.86 | 0.00     | 0.00     | -1253.86 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 21              | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 22              | -2707.30 | 0.00     | 0.00     | -2707.30 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 23              | -1783.87 | 0.00     | 0.00     | -1783.87 | ?        | ?        | 
    | MAIN-567       | APPS-5673       | 24              | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | 
    | MAIN-567       | 16TR-5671       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | 16TR-5671       | 2               | 4108.84  | 0.00     | 0.00     | 4108.84  | ?        | ?        |  
    | MAIN-567       | 16TR-5671       | 3               | 4134.55  | 0.00     | 0.00     | 4134.55  | ?        | ?        |  
    #
    | MAIN-567       | APPS-5672       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 2               | 247.59   | 0.00     | 0.00     | 247.59   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 3               | 245.69   | 0.00     | 0.00     | 245.69   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 4               | 353.97   | 0.00     | 0.00     | 353.97   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 5               | 189.26   | 0.00     | 0.00     | 189.26   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 6               | 160.46   | 0.00     | 0.00     | 160.46   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 7               | 2192.34  | 0.00     | 0.00     | 2192.34  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 8               | 428.45   | 0.00     | 0.00     | 428.45   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 9               | 243.66   | 0.00     | 0.00     | 243.66   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 10              | 2101.49  | 0.00     | 0.00     | 2101.49  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 11              | 424.01   | 0.00     | 0.00     | 424.01   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 12              | 314.26   | 0.00     | 0.00     | 314.26   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 13              | 311.34   | 0.00     | 0.00     | 311.34   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 14              | 309.98   | 0.00     | 0.00     | 309.98   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 15              | 188.44   | 0.00     | 0.00     | 188.44   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 16              | 490.33   | 0.00     | 0.00     | 490.33   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 17              | 184.06   | 0.00     | 0.00     | 184.06   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 18              | 2096.64  | 0.00     | 0.00     | 2096.64  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 19              | 191.29   | 0.00     | 0.00     | 191.29   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 20              | 602.47   | 0.00     | 0.00     | 602.47   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 21              | 3475.35  | 0.00     | 0.00     | 3475.35  | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 22              | 245.67   | 0.00     | 0.00     | 245.67   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 23              | 297.46   | 0.00     | 0.00     | 297.46   | ?        | ?        |  
    | MAIN-567       | APPS-5672       | 24              | 2823.80  | 0.00     | 0.00     | 2823.80  | ?        | ?        |  
    #
    | MAIN-567       | 16TR-5673       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | 16TR-5673       | 2               | 3552.45  | 0.00     | 0.00     | 3552.45  | ?        | ?        |  
    | MAIN-567       | 16TR-5673       | 3               | 3240.79  | 0.00     | 0.00     | 3240.79  | ?        | ?        |  
    #
    | MAIN-567       | APPS-5673       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 2               | 317.19   | 0.00     | 0.00     | 317.19   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 3               | 196.03   | 0.00     | 0.00     | 196.03   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 4               | 295.69   | 0.00     | 0.00     | 295.69   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 5               | 332.34   | 0.00     | 0.00     | 332.34   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 6               | 272.64   | 0.00     | 0.00     | 272.64   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 7               | 2102.98  | 0.00     | 0.00     | 2102.98  | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 8               | 278.77   | 0.00     | 0.00     | 278.77   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 9               | 356.74   | 0.00     | 0.00     | 356.74   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 10              | 2774.57  | 0.00     | 0.00     | 2774.57  | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 11              | 125.03   | 0.00     | 0.00     | 125.03   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 12              | 207.96   | 0.00     | 0.00     | 207.96   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 13              | 343.57   | 0.00     | 0.00     | 343.57   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 14              | 267.43   | 0.00     | 0.00     | 267.43   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 15              | 328.11   | 0.00     | 0.00     | 328.11   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 16              | 348.66   | 0.00     | 0.00     | 348.66   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 17              | 115.70   | 0.00     | 0.00     | 115.70   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 18              | 1573.14  | 0.00     | 0.00     | 1573.14  | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 19              | 260.52   | 0.00     | 0.00     | 260.52   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 20              | 156.30   | 0.00     | 0.00     | 156.30   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 21              | 2593.75  | 0.00     | 0.00     | 2593.75  | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 22              | 337.49   | 0.00     | 0.00     | 337.49   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 23              | 222.38   | 0.00     | 0.00     | 222.38   | ?        | ?        |  
    | MAIN-567       | APPS-5673       | 24              | 2043.01  | 0.00     | 0.00     | 2043.01  | ?        | ?        |  

    # Check the RECONCILIATION subnominal aggregations in PaaS for Oct 2018
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017567 | ORG0017567 | 16TR-5671         | 2201300         | 16-18TRN1819               | 201810               | RECONCILIATION  | CM             | False       | 4108.84         |
    | 10017567 | ORG0017567 | 16TR-5671         | 2201350         | 16-18TRN1819               | 201810               | RECONCILIATION  | CM             | False       | 4134.55         |
    #
    | 10217567 | ORG0217567 | APPS-5672         | 2240100         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 7386.91         |
    | 10217567 | ORG0217567 | APPS-5672         | 2240150         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 4147.83         |
    | 10217567 | ORG0217567 | APPS-5672         | 2240160         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 2101.49         |
    | 10217567 | ORG0217567 | APPS-5672         | 2240170         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 2192.34         |
    | 10217567 | ORG0217567 | APPS-5672         | 2340100         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 18613.97        |
    | 10217567 | ORG0217567 | APPS-5672         | 2340150         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 3351.87         |
    | 10217567 | ORG0217567 | APPS-5672         | 2340160         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 2823.80         |
    | 10217567 | ORG0217567 | APPS-5672         | 2340170         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 5571.99         |
    #
    | 10317567 | ORG0317567 | 16TR-5673         | 2201300         | 16-18TRN1819               | 201810               | RECONCILIATION  | CM             | False       | 3552.45         |
    | 10317567 | ORG0317567 | 16TR-5673         | 2201350         | 16-18TRN1819               | 201810               | RECONCILIATION  | CM             | False       | 3240.79         |
    #
    | 10317567 | ORG0317567 | APPS-5673         | 2240100         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 12755.84        |
    | 10317567 | ORG0317567 | APPS-5673         | 2240150         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 5733.54         |
    | 10317567 | ORG0317567 | APPS-5673         | 2240160         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 2774.57         |
    | 10317567 | ORG0317567 | APPS-5673         | 2240170         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 2102.98         |
    | 10317567 | ORG0317567 | APPS-5673         | 2340100         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 19426.60        |
    | 10317567 | ORG0317567 | APPS-5673         | 2340150         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 5051.04         |
    | 10317567 | ORG0317567 | APPS-5673         | 2340160         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 2043.01         |
    | 10317567 | ORG0317567 | APPS-5673         | 2340170         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 4166.89         |

    # Check the CAPPING subnominal aggregations in PaaS for Oct 2018
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017567 | ORG0017567 | 16TR-5671         | 2201300         | 16-18TRN1819               | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10017567 | ORG0017567 | 16TR-5671         | 2201350         | 16-18TRN1819               | 201810               | CAPPING         | CM             | False       | 0.00            |
    #
    | 10217567 | ORG0217567 | APPS-5672         | 2240100         | APPS1819                   | 201810               | CAPPING         | CM             | False       | -6189.94        |
    | 10217567 | ORG0217567 | APPS-5672         | 2240150         | APPS1819                   | 201810               | CAPPING         | CM             | False       | -3475.72        |
    | 10217567 | ORG0217567 | APPS-5672         | 2240160         | APPS1819                   | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10217567 | ORG0217567 | APPS-5672         | 2240170         | APPS1819                   | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10217567 | ORG0217567 | APPS-5672         | 2340100         | APPS1819                   | 201810               | CAPPING         | CM             | False       | -15597.79       |
    | 10217567 | ORG0217567 | APPS-5672         | 2340150         | APPS1819                   | 201810               | CAPPING         | CM             | False       | -2808.74        |
    | 10217567 | ORG0217567 | APPS-5672         | 2340160         | APPS1819                   | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10217567 | ORG0217567 | APPS-5672         | 2340170         | APPS1819                   | 201810               | CAPPING         | CM             | False       | 0.00            |
    #
    | 10317567 | ORG0317567 | 16TR-5673         | 2201300         | 16-18TRN1819               | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | 16TR-5673         | 2201350         | 16-18TRN1819               | 201810               | CAPPING         | CM             | False       | 0.00            |
    #
    | 10317567 | ORG0317567 | APPS-5673         | 2240100         | APPS1819                   | 201810               | CAPPING         | CM             | False       | -11341.95       |
    | 10317567 | ORG0317567 | APPS-5673         | 2240150         | APPS1819                   | 201810               | CAPPING         | CM             | False       | -5098.03        |
    | 10317567 | ORG0317567 | APPS-5673         | 2240160         | APPS1819                   | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | APPS-5673         | 2240170         | APPS1819                   | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | APPS-5673         | 2340100         | APPS1819                   | 201810               | CAPPING         | CM             | False       | -17273.32       |
    | 10317567 | ORG0317567 | APPS-5673         | 2340150         | APPS1819                   | 201810               | CAPPING         | CM             | False       | -4491.17        |
    | 10317567 | ORG0317567 | APPS-5673         | 2340160         | APPS1819                   | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | APPS-5673         | 2340170         | APPS1819                   | 201810               | CAPPING         | CM             | False       | 0.00            |

#    # Check the RECONCILIATION subnominal aggregations in CRM fo Oct
#    And   the Reconciliation Subnominal Amounts are calculated as follows
#    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Oct-18    |
#    | MAIN-567       | 16TR-5671       | 2201300                  | 4108.84   | 
#    | MAIN-567       | 16TR-5671       | 2201350                  | 4134.55   | 
#    #
#    | MAIN-567       | APPS-5672       | 2240100                  | 7386.91   | 
#    | MAIN-567       | APPS-5672       | 2240150                  | 4147.83   | 
#    | MAIN-567       | APPS-5672       | 2240160                  | 2101.49   | 
#    | MAIN-567       | APPS-5672       | 2240170                  | 2192.34   | 
#    | MAIN-567       | APPS-5672       | 2340100                  | 18613.97  | 
#    | MAIN-567       | APPS-5672       | 2340150                  | 3351.87   | 
#    | MAIN-567       | APPS-5672       | 2340160                  | 2823.80   | 
#    | MAIN-567       | APPS-5672       | 2340170                  | 5571.99   |
#    # 
#    | MAIN-567       | 16TR-5673       | 2201300                  | 3552.45   | 
#    | MAIN-567       | 16TR-5673       | 2201350                  | 3240.79   |
#    # 
#    | MAIN-567       | APPS-5673       | 2240100                  | 12755.84  | 
#    | MAIN-567       | APPS-5673       | 2240150                  | 5733.54   | 
#    | MAIN-567       | APPS-5673       | 2240160                  | 2774.57   | 
#    | MAIN-567       | APPS-5673       | 2240170                  | 2102.98   | 
#    | MAIN-567       | APPS-5673       | 2340100                  | 19426.60  | 
#    | MAIN-567       | APPS-5673       | 2340150                  | 5051.04   | 
#    | MAIN-567       | APPS-5673       | 2340160                  | 2043.01   | 
#    | MAIN-567       | APPS-5673       | 2340170                  | 4166.89   | 
#
#    # Check the CAPPING subnominal aggregations in CRM for Oct
#    And   the Capping Subnominal Amounts are calculated as follows
#    | ContractNumber | AllocationRef   | CappingSubnominal        | Oct-18    |
#    | MAIN-567       | 16TR-5671       | 2201300                  | 0.00      | 
#    | MAIN-567       | 16TR-5671       | 2201350                  | 0.00      |
#    # 
#    | MAIN-567       | APPS-5672       | 2240100                  | -6189.94  | 
#    | MAIN-567       | APPS-5672       | 2240150                  | -3475.72  | 
#    | MAIN-567       | APPS-5672       | 2240160                  | 0.00      | 
#    | MAIN-567       | APPS-5672       | 2240170                  | 0.00      | 
#    | MAIN-567       | APPS-5672       | 2340100                  | -15597.79 | 
#    | MAIN-567       | APPS-5672       | 2340150                  | -2808.74  | 
#    | MAIN-567       | APPS-5672       | 2340160                  | 0.00      | 
#    | MAIN-567       | APPS-5672       | 2340170                  | 0.00      |
#    # 
#    | MAIN-567       | 16TR-5673       | 2201300                  | 0.00      | 
#    | MAIN-567       | 16TR-5673       | 2201350                  | 0.00      |
#    # 
#    | MAIN-567       | APPS-5673       | 2240100                  | -11341.95 | 
#    | MAIN-567       | APPS-5673       | 2240150                  | -5098.03  | 
#    | MAIN-567       | APPS-5673       | 2240160                  | 0.00      | 
#    | MAIN-567       | APPS-5673       | 2240170                  | 0.00      | 
#    | MAIN-567       | APPS-5673       | 2340100                  | -17273.32 | 
#    | MAIN-567       | APPS-5673       | 2340150                  | -4491.17  | 
#    | MAIN-567       | APPS-5673       | 2340160                  | 0.00      | 
#    | MAIN-567       | APPS-5673       | 2340170                  | 0.00      | 
	



    # Change the date
    Given the override date is '22/12/2018'

    # Amend the contract by bulk upload
    And   there are no files prefixed '10017567_MAIN-567' in the Sharepoint 'MAIN-1819-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1819 06082018132419 v3_A567' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1819 06082018132419 v3_A567' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 1819 06082018132419 v3_A567.xlsx' exists in the Datafiles folder and UKPRN '10017567' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Change the date
    Given the override date is '23/12/2018'

    # Publish the contract
    And   the latest version of contract 'MAIN-567' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-567' and actual ContractNumber 'MAIN-567'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017567 | MAIN-567           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017567 | MAIN-567           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017567 | ESFA-567           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | 
    | MAIN-567       | 16TR-5671       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | 16TR-5671       | 2               | 4108.84  | 0.00     | 0.00     | 4108.84  | 0.00     | 0.00     | 
    | MAIN-567       | 16TR-5671       | 3               | 4134.55  | 0.00     | 0.00     | 4134.55  | 0.00     | 0.00     | 
    #
    | MAIN-567       | APPS-5672       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5672       | 2               | 2808.31  | 0.00     | 0.00     | 1527.95  | 0.00     | 1280.36  | 
    | MAIN-567       | APPS-5672       | 3               | 2786.77  | 0.00     | 0.00     | 1516.23  | 0.00     | 1270.54  | 
    | MAIN-567       | APPS-5672       | 4               | 4014.97  | 0.00     | 0.00     | 2184.47  | 0.00     | 1830.50  | 
    | MAIN-567       | APPS-5672       | 5               | 2146.70  | 0.00     | 0.00     | 1167.98  | 0.00     | 978.72   | 
    | MAIN-567       | APPS-5672       | 6               | 1820.10  | 0.00     | 0.00     | 990.28   | 0.00     | 829.82   | 
    | MAIN-567       | APPS-5672       | 7               | 2192.34  | 0.00     | 0.00     | 2192.34  | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5672       | 8               | 4859.83  | 0.00     | 0.00     | 2644.14  | 0.00     | 2215.69  | 
    | MAIN-567       | APPS-5672       | 9               | 2763.72  | 0.00     | 0.00     | 1503.69  | 0.00     | 1260.03  | 
    | MAIN-567       | APPS-5672       | 10              | 2101.49  | 0.00     | 0.00     | 2101.49  | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5672       | 11              | 4809.47  | 0.00     | 0.00     | 2616.74  | 0.00     | 2192.73  | 
    | MAIN-567       | APPS-5672       | 12              | 3564.56  | 0.00     | 0.00     | 1939.41  | 0.00     | 1625.15  | 
    | MAIN-567       | APPS-5672       | 13              | 3531.40  | 0.00     | 0.00     | 1921.37  | 0.00     | 1610.03  | 
    | MAIN-567       | APPS-5672       | 14              | 3516.06  | 0.00     | 0.00     | 1913.02  | 0.00     | 1603.04  | 
    | MAIN-567       | APPS-5672       | 15              | 2137.46  | 0.00     | 0.00     | 1162.95  | 0.00     | 974.51   | 
    | MAIN-567       | APPS-5672       | 16              | 5561.67  | 0.00     | 0.00     | 3026.00  | 0.00     | 2535.67  | 
    | MAIN-567       | APPS-5672       | 17              | 2087.72  | 0.00     | 0.00     | 1135.89  | 0.00     | 951.83   | 
    | MAIN-567       | APPS-5672       | 18              | 2096.64  | 0.00     | 0.00     | 2096.64  | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5672       | 19              | 2169.73  | 0.00     | 0.00     | 1180.51  | 0.00     | 989.22   | 
    | MAIN-567       | APPS-5672       | 20              | 6833.69  | 0.00     | 0.00     | 3718.08  | 0.00     | 3115.61  | 
    | MAIN-567       | APPS-5672       | 21              | 3475.35  | 0.00     | 0.00     | 3475.35  | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5672       | 22              | 2786.55  | 0.00     | 0.00     | 1516.11  | 0.00     | 1270.44  | 
    | MAIN-567       | APPS-5672       | 23              | 3374.06  | 0.00     | 0.00     | 1835.76  | 0.00     | 1538.30  | 
    | MAIN-567       | APPS-5672       | 24              | 2823.80  | 0.00     | 0.00     | 2823.80  | 0.00     | 0.00     | 
    #
    | MAIN-567       | 16TR-5673       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | 16TR-5673       | 2               | 3552.45  | 0.00     | 0.00     | 3552.45  | 0.00     | 0.00     | 
    | MAIN-567       | 16TR-5673       | 3               | 3240.79  | 0.00     | 0.00     | 3240.79  | 0.00     | 0.00     | 
    #
    | MAIN-567       | APPS-5673       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5673       | 2               | 5406.09  | 0.00     | 0.00     | 2861.64  | 0.00     | 2544.45  | 
    | MAIN-567       | APPS-5673       | 3               | 3340.99  | 0.00     | 0.00     | 1768.51  | 0.00     | 1572.48  | 
    | MAIN-567       | APPS-5673       | 4               | 5039.65  | 0.00     | 0.00     | 2667.67  | 0.00     | 2371.98  | 
    | MAIN-567       | APPS-5673       | 5               | 5664.24  | 0.00     | 0.00     | 2998.29  | 0.00     | 2665.95  | 
    | MAIN-567       | APPS-5673       | 6               | 4646.82  | 0.00     | 0.00     | 2459.73  | 0.00     | 2187.09  | 
    | MAIN-567       | APPS-5673       | 7               | 2102.98  | 0.00     | 0.00     | 2102.98  | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5673       | 8               | 4751.35  | 0.00     | 0.00     | 2515.06  | 0.00     | 2236.29  | 
    | MAIN-567       | APPS-5673       | 9               | 6080.22  | 0.00     | 0.00     | 3218.48  | 0.00     | 2861.74  | 
    | MAIN-567       | APPS-5673       | 10              | 2774.57  | 0.00     | 0.00     | 2774.57  | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5673       | 11              | 2130.95  | 0.00     | 0.00     | 1127.99  | 0.00     | 1002.96  | 
    | MAIN-567       | APPS-5673       | 12              | 3544.32  | 0.00     | 0.00     | 1876.14  | 0.00     | 1668.18  | 
    | MAIN-567       | APPS-5673       | 13              | 5855.77  | 0.00     | 0.00     | 3099.67  | 0.00     | 2756.10  | 
    | MAIN-567       | APPS-5673       | 14              | 4558.03  | 0.00     | 0.00     | 2412.73  | 0.00     | 2145.30  | 
    | MAIN-567       | APPS-5673       | 15              | 5592.19  | 0.00     | 0.00     | 2960.15  | 0.00     | 2632.04  | 
    | MAIN-567       | APPS-5673       | 16              | 5942.48  | 0.00     | 0.00     | 3145.57  | 0.00     | 2796.91  | 
    | MAIN-567       | APPS-5673       | 17              | 1971.88  | 0.00     | 0.00     | 1043.79  | 0.00     | 928.09   | 
    | MAIN-567       | APPS-5673       | 18              | 1573.14  | 0.00     | 0.00     | 1573.14  | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5673       | 19              | 4440.28  | 0.00     | 0.00     | 2350.40  | 0.00     | 2089.88  | 
    | MAIN-567       | APPS-5673       | 20              | 2664.02  | 0.00     | 0.00     | 1410.16  | 0.00     | 1253.86  | 
    | MAIN-567       | APPS-5673       | 21              | 2593.75  | 0.00     | 0.00     | 2593.75  | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5673       | 22              | 5752.09  | 0.00     | 0.00     | 3044.79  | 0.00     | 2707.30  | 
    | MAIN-567       | APPS-5673       | 23              | 3790.12  | 0.00     | 0.00     | 2006.25  | 0.00     | 1783.87  | 
    | MAIN-567       | APPS-5673       | 24              | 2043.01  | 0.00     | 0.00     | 2043.01  | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | 
    | MAIN-567       | 16TR-5671       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | 16TR-5671       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | 16TR-5671       | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | MAIN-567       | APPS-5672       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5672       | 2               | -2808.31 | 0.00     | 0.00     | -1280.36 | 0.00     | -1527.95 | 
    | MAIN-567       | APPS-5672       | 3               | -2786.77 | 0.00     | 0.00     | -1270.54 | 0.00     | -1516.23 | 
    | MAIN-567       | APPS-5672       | 4               | -4014.97 | 0.00     | 0.00     | -1830.50 | 0.00     | -2184.47 | 
    | MAIN-567       | APPS-5672       | 5               | -2146.70 | 0.00     | 0.00     | -978.72  | 0.00     | -1167.98 | 
    | MAIN-567       | APPS-5672       | 6               | -1820.10 | 0.00     | 0.00     | -829.82  | 0.00     | -990.28  | 
    | MAIN-567       | APPS-5672       | 7               | -551.40  | 0.00     | 0.00     | 0.00     | 0.00     | -551.40  | 
    | MAIN-567       | APPS-5672       | 8               | -4859.83 | 0.00     | 0.00     | -2215.69 | 0.00     | -2644.14 | 
    | MAIN-567       | APPS-5672       | 9               | -2763.72 | 0.00     | 0.00     | -1260.03 | 0.00     | -1503.69 | 
    | MAIN-567       | APPS-5672       | 10              | -528.55  | 0.00     | 0.00     | 0.00     | 0.00     | -528.55  | 
    | MAIN-567       | APPS-5672       | 11              | -4809.47 | 0.00     | 0.00     | -2192.73 | 0.00     | -2616.74 | 
    | MAIN-567       | APPS-5672       | 12              | -3564.56 | 0.00     | 0.00     | -1625.15 | 0.00     | -1939.41 | 
    | MAIN-567       | APPS-5672       | 13              | -3531.40 | 0.00     | 0.00     | -1610.03 | 0.00     | -1921.37 | 
    | MAIN-567       | APPS-5672       | 14              | -3516.06 | 0.00     | 0.00     | -1603.04 | 0.00     | -1913.02 | 
    | MAIN-567       | APPS-5672       | 15              | -2137.46 | 0.00     | 0.00     | -974.51  | 0.00     | -1162.95 | 
    | MAIN-567       | APPS-5672       | 16              | -5561.67 | 0.00     | 0.00     | -2535.67 | 0.00     | -3026.00 | 
    | MAIN-567       | APPS-5672       | 17              | -2087.72 | 0.00     | 0.00     | -951.83  | 0.00     | -1135.89 | 
    | MAIN-567       | APPS-5672       | 18              | -527.33  | 0.00     | 0.00     | 0.00     | 0.00     | -527.33  | 
    | MAIN-567       | APPS-5672       | 19              | -2169.73 | 0.00     | 0.00     | -989.22  | 0.00     | -1180.51 | 
    | MAIN-567       | APPS-5672       | 20              | -6833.69 | 0.00     | 0.00     | -3115.61 | 0.00     | -3718.08 | 
    | MAIN-567       | APPS-5672       | 21              | -874.10  | 0.00     | 0.00     | 0.00     | 0.00     | -874.10  | 
    | MAIN-567       | APPS-5672       | 22              | -2786.55 | 0.00     | 0.00     | -1270.44 | 0.00     | -1516.11 | 
    | MAIN-567       | APPS-5672       | 23              | -3374.06 | 0.00     | 0.00     | -1538.30 | 0.00     | -1835.76 | 
    | MAIN-567       | APPS-5672       | 24              | -710.23  | 0.00     | 0.00     | 0.00     | 0.00     | -710.23  | 
    #
    | MAIN-567       | 16TR-5673       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | 16TR-5673       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | 16TR-5673       | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | MAIN-567       | APPS-5673       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5673       | 2               | -5384.94 | 0.00     | 0.00     | -2544.45 | 0.00     | -2840.49 | 
    | MAIN-567       | APPS-5673       | 3               | -3327.92 | 0.00     | 0.00     | -1572.48 | 0.00     | -1755.44 | 
    | MAIN-567       | APPS-5673       | 4               | -5019.93 | 0.00     | 0.00     | -2371.98 | 0.00     | -2647.95 | 
    | MAIN-567       | APPS-5673       | 5               | -5642.08 | 0.00     | 0.00     | -2665.95 | 0.00     | -2976.13 | 
    | MAIN-567       | APPS-5673       | 6               | -4628.64 | 0.00     | 0.00     | -2187.09 | 0.00     | -2441.55 | 
    | MAIN-567       | APPS-5673       | 7               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5673       | 8               | -4732.76 | 0.00     | 0.00     | -2236.29 | 0.00     | -2496.47 | 
    | MAIN-567       | APPS-5673       | 9               | -6056.43 | 0.00     | 0.00     | -2861.74 | 0.00     | -3194.69 | 
    | MAIN-567       | APPS-5673       | 10              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5673       | 11              | -2122.61 | 0.00     | 0.00     | -1002.96 | 0.00     | -1119.65 | 
    | MAIN-567       | APPS-5673       | 12              | -3530.45 | 0.00     | 0.00     | -1668.18 | 0.00     | -1862.27 | 
    | MAIN-567       | APPS-5673       | 13              | -5832.86 | 0.00     | 0.00     | -2756.10 | 0.00     | -3076.76 | 
    | MAIN-567       | APPS-5673       | 14              | -4540.20 | 0.00     | 0.00     | -2145.30 | 0.00     | -2394.90 | 
    | MAIN-567       | APPS-5673       | 15              | -5570.31 | 0.00     | 0.00     | -2632.04 | 0.00     | -2938.27 | 
    | MAIN-567       | APPS-5673       | 16              | -5919.23 | 0.00     | 0.00     | -2796.91 | 0.00     | -3122.32 | 
    | MAIN-567       | APPS-5673       | 17              | -1964.17 | 0.00     | 0.00     | -928.09  | 0.00     | -1036.08 | 
    | MAIN-567       | APPS-5673       | 18              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5673       | 19              | -4422.91 | 0.00     | 0.00     | -2089.88 | 0.00     | -2333.03 | 
    | MAIN-567       | APPS-5673       | 20              | -2653.60 | 0.00     | 0.00     | -1253.86 | 0.00     | -1399.74 | 
    | MAIN-567       | APPS-5673       | 21              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5673       | 22              | -5729.59 | 0.00     | 0.00     | -2707.30 | 0.00     | -3022.29 | 
    | MAIN-567       | APPS-5673       | 23              | -3775.29 | 0.00     | 0.00     | -1783.87 | 0.00     | -1991.42 | 
    | MAIN-567       | APPS-5673       | 24              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | 
    | MAIN-567       | 16TR-5671       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | 16TR-5671       | 2               | 4108.84  | 0.00     | 0.00     | 4108.84  | 0.00     | 0.00     | 
    | MAIN-567       | 16TR-5671       | 3               | 4134.55  | 0.00     | 0.00     | 4134.55  | 0.00     | 0.00     | 
    #
    | MAIN-567       | APPS-5672       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5672       | 2               | 0.00     | 0.00     | 0.00     | 247.59   | 0.00     | -247.59  | 
    | MAIN-567       | APPS-5672       | 3               | 0.00     | 0.00     | 0.00     | 245.69   | 0.00     | -245.69  | 
    | MAIN-567       | APPS-5672       | 4               | 0.00     | 0.00     | 0.00     | 353.97   | 0.00     | -353.97  | 
    | MAIN-567       | APPS-5672       | 5               | 0.00     | 0.00     | 0.00     | 189.26   | 0.00     | -189.26  | 
    | MAIN-567       | APPS-5672       | 6               | 0.00     | 0.00     | 0.00     | 160.46   | 0.00     | -160.46  | 
    | MAIN-567       | APPS-5672       | 7               | 1640.94  | 0.00     | 0.00     | 2192.34  | 0.00     | -551.40  | 
    | MAIN-567       | APPS-5672       | 8               | 0.00     | 0.00     | 0.00     | 428.45   | 0.00     | -428.45  | 
    | MAIN-567       | APPS-5672       | 9               | 0.00     | 0.00     | 0.00     | 243.66   | 0.00     | -243.66  | 
    | MAIN-567       | APPS-5672       | 10              | 1572.94  | 0.00     | 0.00     | 2101.49  | 0.00     | -528.55  | 
    | MAIN-567       | APPS-5672       | 11              | 0.00     | 0.00     | 0.00     | 424.01   | 0.00     | -424.01  | 
    | MAIN-567       | APPS-5672       | 12              | 0.00     | 0.00     | 0.00     | 314.26   | 0.00     | -314.26  | 
    | MAIN-567       | APPS-5672       | 13              | 0.00     | 0.00     | 0.00     | 311.34   | 0.00     | -311.34  | 
    | MAIN-567       | APPS-5672       | 14              | 0.00     | 0.00     | 0.00     | 309.98   | 0.00     | -309.98  | 
    | MAIN-567       | APPS-5672       | 15              | 0.00     | 0.00     | 0.00     | 188.44   | 0.00     | -188.44  | 
    | MAIN-567       | APPS-5672       | 16              | 0.00     | 0.00     | 0.00     | 490.33   | 0.00     | -490.33  | 
    | MAIN-567       | APPS-5672       | 17              | 0.00     | 0.00     | 0.00     | 184.06   | 0.00     | -184.06  | 
    | MAIN-567       | APPS-5672       | 18              | 1569.31  | 0.00     | 0.00     | 2096.64  | 0.00     | -527.33  | 
    | MAIN-567       | APPS-5672       | 19              | 0.00     | 0.00     | 0.00     | 191.29   | 0.00     | -191.29  | 
    | MAIN-567       | APPS-5672       | 20              | 0.00     | 0.00     | 0.00     | 602.47   | 0.00     | -602.47  | 
    | MAIN-567       | APPS-5672       | 21              | 2601.25  | 0.00     | 0.00     | 3475.35  | 0.00     | -874.10  | 
    | MAIN-567       | APPS-5672       | 22              | 0.00     | 0.00     | 0.00     | 245.67   | 0.00     | -245.67  | 
    | MAIN-567       | APPS-5672       | 23              | 0.00     | 0.00     | 0.00     | 297.46   | 0.00     | -297.46  | 
    | MAIN-567       | APPS-5672       | 24              | 2113.57  | 0.00     | 0.00     | 2823.80  | 0.00     | -710.23  | 
    #
    | MAIN-567       | 16TR-5673       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | 16TR-5673       | 2               | 3552.45  | 0.00     | 0.00     | 3552.45  | 0.00     | 0.00     | 
    | MAIN-567       | 16TR-5673       | 3               | 3240.79  | 0.00     | 0.00     | 3240.79  | 0.00     | 0.00     | 
    #
    | MAIN-567       | APPS-5673       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5673       | 2               | 21.15    | 0.00     | 0.00     | 317.19   | 0.00     | -296.04  | 
    | MAIN-567       | APPS-5673       | 3               | 13.07    | 0.00     | 0.00     | 196.03   | 0.00     | -182.96  | 
    | MAIN-567       | APPS-5673       | 4               | 19.72    | 0.00     | 0.00     | 295.69   | 0.00     | -275.97  | 
    | MAIN-567       | APPS-5673       | 5               | 22.16    | 0.00     | 0.00     | 332.34   | 0.00     | -310.18  | 
    | MAIN-567       | APPS-5673       | 6               | 18.18    | 0.00     | 0.00     | 272.64   | 0.00     | -254.46  | 
    | MAIN-567       | APPS-5673       | 7               | 2102.98  | 0.00     | 0.00     | 2102.98  | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5673       | 8               | 18.59    | 0.00     | 0.00     | 278.77   | 0.00     | -260.18  | 
    | MAIN-567       | APPS-5673       | 9               | 23.79    | 0.00     | 0.00     | 356.74   | 0.00     | -332.95  | 
    | MAIN-567       | APPS-5673       | 10              | 2774.57  | 0.00     | 0.00     | 2774.57  | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5673       | 11              | 8.34     | 0.00     | 0.00     | 125.03   | 0.00     | -116.69  | 
    | MAIN-567       | APPS-5673       | 12              | 13.87    | 0.00     | 0.00     | 207.96   | 0.00     | -194.09  | 
    | MAIN-567       | APPS-5673       | 13              | 22.91    | 0.00     | 0.00     | 343.57   | 0.00     | -320.66  | 
    | MAIN-567       | APPS-5673       | 14              | 17.83    | 0.00     | 0.00     | 267.43   | 0.00     | -249.60  | 
    | MAIN-567       | APPS-5673       | 15              | 21.88    | 0.00     | 0.00     | 328.11   | 0.00     | -306.23  | 
    | MAIN-567       | APPS-5673       | 16              | 23.25    | 0.00     | 0.00     | 348.66   | 0.00     | -325.41  | 
    | MAIN-567       | APPS-5673       | 17              | 7.71     | 0.00     | 0.00     | 115.70   | 0.00     | -107.99  | 
    | MAIN-567       | APPS-5673       | 18              | 1573.14  | 0.00     | 0.00     | 1573.14  | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5673       | 19              | 17.37    | 0.00     | 0.00     | 260.52   | 0.00     | -243.15  | 
    | MAIN-567       | APPS-5673       | 20              | 10.42    | 0.00     | 0.00     | 156.30   | 0.00     | -145.88  | 
    | MAIN-567       | APPS-5673       | 21              | 2593.75  | 0.00     | 0.00     | 2593.75  | 0.00     | 0.00     | 
    | MAIN-567       | APPS-5673       | 22              | 22.50    | 0.00     | 0.00     | 337.49   | 0.00     | -314.99  | 
    | MAIN-567       | APPS-5673       | 23              | 14.83    | 0.00     | 0.00     | 222.38   | 0.00     | -207.55  | 
    | MAIN-567       | APPS-5673       | 24              | 2043.01  | 0.00     | 0.00     | 2043.01  | 0.00     | 0.00     | 

    # Check the RECONCILIATION subnominal aggregations in PaaS for Oct and Dec 2018
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017567 | ORG0017567 | 16TR-5671         | 2201300         | 16-18TRN1819               | 201810               | RECONCILIATION  | CM             | False       | 4108.84         |
    | 10017567 | ORG0017567 | 16TR-5671         | 2201350         | 16-18TRN1819               | 201810               | RECONCILIATION  | CM             | False       | 4134.55         |
    | 10017567 | ORG0017567 | 16TR-5671         | 2201300         | 16-18TRN1819               | 201812               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017567 | ORG0017567 | 16TR-5671         | 2201350         | 16-18TRN1819               | 201812               | RECONCILIATION  | CM             | False       | 0.00            |
    #
    | 10217567 | ORG0217567 | APPS-5672         | 2240100         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 7386.91         |
    | 10217567 | ORG0217567 | APPS-5672         | 2240150         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 4147.83         |
    | 10217567 | ORG0217567 | APPS-5672         | 2240160         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 2101.49         |
    | 10217567 | ORG0217567 | APPS-5672         | 2240170         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 2192.34         |
    | 10217567 | ORG0217567 | APPS-5672         | 2340100         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 18613.97        |
    | 10217567 | ORG0217567 | APPS-5672         | 2340150         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 3351.87         |
    | 10217567 | ORG0217567 | APPS-5672         | 2340160         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 2823.80         |
    | 10217567 | ORG0217567 | APPS-5672         | 2340170         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 5571.99         |
    | 10217567 | ORG0217567 | APPS-5672         | 2240100         | APPS1819                   | 201812               | RECONCILIATION  | CM             | False       | 6189.94         |
    | 10217567 | ORG0217567 | APPS-5672         | 2240150         | APPS1819                   | 201812               | RECONCILIATION  | CM             | False       | 3475.72         |
    | 10217567 | ORG0217567 | APPS-5672         | 2240160         | APPS1819                   | 201812               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10217567 | ORG0217567 | APPS-5672         | 2240170         | APPS1819                   | 201812               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10217567 | ORG0217567 | APPS-5672         | 2340100         | APPS1819                   | 201812               | RECONCILIATION  | CM             | False       | 15597.79        |
    | 10217567 | ORG0217567 | APPS-5672         | 2340150         | APPS1819                   | 201812               | RECONCILIATION  | CM             | False       | 2808.74         |
    | 10217567 | ORG0217567 | APPS-5672         | 2340160         | APPS1819                   | 201812               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10217567 | ORG0217567 | APPS-5672         | 2340170         | APPS1819                   | 201812               | RECONCILIATION  | CM             | False       | 0.00            |
    #
    | 10317567 | ORG0317567 | 16TR-5673         | 2201300         | 16-18TRN1819               | 201810               | RECONCILIATION  | CM             | False       | 3552.45         |
    | 10317567 | ORG0317567 | 16TR-5673         | 2201350         | 16-18TRN1819               | 201810               | RECONCILIATION  | CM             | False       | 3240.79         |
    | 10317567 | ORG0317567 | 16TR-5673         | 2201300         | 16-18TRN1819               | 201812               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | 16TR-5673         | 2201350         | 16-18TRN1819               | 201812               | RECONCILIATION  | CM             | False       | 0.00            |
    #
    | 10317567 | ORG0317567 | APPS-5673         | 2240100         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 12755.84        |
    | 10317567 | ORG0317567 | APPS-5673         | 2240150         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 5733.54         |
    | 10317567 | ORG0317567 | APPS-5673         | 2240160         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 2774.57         |
    | 10317567 | ORG0317567 | APPS-5673         | 2240170         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 2102.98         |
    | 10317567 | ORG0317567 | APPS-5673         | 2340100         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 19426.60        |
    | 10317567 | ORG0317567 | APPS-5673         | 2340150         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 5051.04         |
    | 10317567 | ORG0317567 | APPS-5673         | 2340160         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 2043.01         |
    | 10317567 | ORG0317567 | APPS-5673         | 2340170         | APPS1819                   | 201810               | RECONCILIATION  | CM             | False       | 4166.89         |
    | 10317567 | ORG0317567 | APPS-5673         | 2240100         | APPS1819                   | 201812               | RECONCILIATION  | CM             | False       | 11341.95        |
    | 10317567 | ORG0317567 | APPS-5673         | 2240150         | APPS1819                   | 201812               | RECONCILIATION  | CM             | False       | 5098.03         |
    | 10317567 | ORG0317567 | APPS-5673         | 2240160         | APPS1819                   | 201812               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | APPS-5673         | 2240170         | APPS1819                   | 201812               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | APPS-5673         | 2340100         | APPS1819                   | 201812               | RECONCILIATION  | CM             | False       | 17273.32        |
    | 10317567 | ORG0317567 | APPS-5673         | 2340150         | APPS1819                   | 201812               | RECONCILIATION  | CM             | False       | 4491.17         |
    | 10317567 | ORG0317567 | APPS-5673         | 2340160         | APPS1819                   | 201812               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | APPS-5673         | 2340170         | APPS1819                   | 201812               | RECONCILIATION  | CM             | False       | 0.00            |

    # Check the CAPPING subnominal aggregations in PaaS for Oct and Dec 2018
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017567 | ORG0017567 | 16TR-5671         | 2201300         | 16-18TRN1819               | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10017567 | ORG0017567 | 16TR-5671         | 2201350         | 16-18TRN1819               | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10017567 | ORG0017567 | 16TR-5671         | 2201300         | 16-18TRN1819               | 201812               | CAPPING         | CM             | False       | 0.00            |
    | 10017567 | ORG0017567 | 16TR-5671         | 2201350         | 16-18TRN1819               | 201812               | CAPPING         | CM             | False       | 0.00            |
    #
    | 10217567 | ORG0217567 | APPS-5672         | 2240100         | APPS1819                   | 201810               | CAPPING         | CM             | False       | -6189.94        |
    | 10217567 | ORG0217567 | APPS-5672         | 2240150         | APPS1819                   | 201810               | CAPPING         | CM             | False       | -3475.72        |
    | 10217567 | ORG0217567 | APPS-5672         | 2240160         | APPS1819                   | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10217567 | ORG0217567 | APPS-5672         | 2240170         | APPS1819                   | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10217567 | ORG0217567 | APPS-5672         | 2340100         | APPS1819                   | 201810               | CAPPING         | CM             | False       | -15597.79       |
    | 10217567 | ORG0217567 | APPS-5672         | 2340150         | APPS1819                   | 201810               | CAPPING         | CM             | False       | -2808.74        |
    | 10217567 | ORG0217567 | APPS-5672         | 2340160         | APPS1819                   | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10217567 | ORG0217567 | APPS-5672         | 2340170         | APPS1819                   | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10217567 | ORG0217567 | APPS-5672         | 2240100         | APPS1819                   | 201812               | CAPPING         | CM             | False       | -7386.91        |
    | 10217567 | ORG0217567 | APPS-5672         | 2240150         | APPS1819                   | 201812               | CAPPING         | CM             | False       | -4147.83        |
    | 10217567 | ORG0217567 | APPS-5672         | 2240160         | APPS1819                   | 201812               | CAPPING         | CM             | False       | -528.55         |
    | 10217567 | ORG0217567 | APPS-5672         | 2240170         | APPS1819                   | 201812               | CAPPING         | CM             | False       | -551.40         |
    | 10217567 | ORG0217567 | APPS-5672         | 2340100         | APPS1819                   | 201812               | CAPPING         | CM             | False       | -18613.97       |
    | 10217567 | ORG0217567 | APPS-5672         | 2340150         | APPS1819                   | 201812               | CAPPING         | CM             | False       | -3351.87        |
    | 10217567 | ORG0217567 | APPS-5672         | 2340160         | APPS1819                   | 201812               | CAPPING         | CM             | False       | -710.23         |
    | 10217567 | ORG0217567 | APPS-5672         | 2340170         | APPS1819                   | 201812               | CAPPING         | CM             | False       | -1401.43        |
    #
    | 10317567 | ORG0317567 | 16TR-5673         | 2201300         | 16-18TRN1819               | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | 16TR-5673         | 2201350         | 16-18TRN1819               | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | 16TR-5673         | 2201300         | 16-18TRN1819               | 201812               | CAPPING         | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | 16TR-5673         | 2201350         | 16-18TRN1819               | 201812               | CAPPING         | CM             | False       | 0.00            |
    #
    | 10317567 | ORG0317567 | APPS-5673         | 2240100         | APPS1819                   | 201810               | CAPPING         | CM             | False       | -11341.95       |
    | 10317567 | ORG0317567 | APPS-5673         | 2240150         | APPS1819                   | 201810               | CAPPING         | CM             | False       | -5098.03        |
    | 10317567 | ORG0317567 | APPS-5673         | 2240160         | APPS1819                   | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | APPS-5673         | 2240170         | APPS1819                   | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | APPS-5673         | 2340100         | APPS1819                   | 201810               | CAPPING         | CM             | False       | -17273.32       |
    | 10317567 | ORG0317567 | APPS-5673         | 2340150         | APPS1819                   | 201810               | CAPPING         | CM             | False       | -4491.17        |
    | 10317567 | ORG0317567 | APPS-5673         | 2340160         | APPS1819                   | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | APPS-5673         | 2340170         | APPS1819                   | 201810               | CAPPING         | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | APPS-5673         | 2240100         | APPS1819                   | 201812               | CAPPING         | CM             | False       | -12661.56       |
    | 10317567 | ORG0317567 | APPS-5673         | 2240150         | APPS1819                   | 201812               | CAPPING         | CM             | False       | -5691.16        |
    | 10317567 | ORG0317567 | APPS-5673         | 2240160         | APPS1819                   | 201812               | CAPPING         | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | APPS-5673         | 2240170         | APPS1819                   | 201812               | CAPPING         | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | APPS-5673         | 2340100         | APPS1819                   | 201812               | CAPPING         | CM             | False       | -19283.02       |
    | 10317567 | ORG0317567 | APPS-5673         | 2340150         | APPS1819                   | 201812               | CAPPING         | CM             | False       | -5013.71        |
    | 10317567 | ORG0317567 | APPS-5673         | 2340160         | APPS1819                   | 201812               | CAPPING         | CM             | False       | 0.00            |
    | 10317567 | ORG0317567 | APPS-5673         | 2340170         | APPS1819                   | 201812               | CAPPING         | CM             | False       | 0.00            |

#    # Check the RECONCILIATION subnominal aggregations in CRM for Oct and Dec
#    And   the Reconciliation Subnominal Amounts are calculated as follows
#    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Oct-18    | Dec-18    |
#    | MAIN-567       | 16TR-5671       | 2201300                  | 4108.84   | 0.00      | 
#    | MAIN-567       | 16TR-5671       | 2201350                  | 4134.55   | 0.00      | 
#    #															    
#    | MAIN-567       | APPS-5672       | 2240100                  | 7386.91   | 6189.94   | 
#    | MAIN-567       | APPS-5672       | 2240150                  | 4147.83   | 3475.72   | 
#    | MAIN-567       | APPS-5672       | 2240160                  | 2101.49   | 0.00      | 
#    | MAIN-567       | APPS-5672       | 2240170                  | 2192.34   | 0.00      | 
#    | MAIN-567       | APPS-5672       | 2340100                  | 18613.97  | 15597.79  | 
#    | MAIN-567       | APPS-5672       | 2340150                  | 3351.87   | 2808.74   | 
#    | MAIN-567       | APPS-5672       | 2340160                  | 2823.80   | 0.00      | 
#    | MAIN-567       | APPS-5672       | 2340170                  | 5571.99   | 0.00      | 
#    #															    
#    | MAIN-567       | 16TR-5673       | 2201300                  | 3552.45   | 0.00      | 
#    | MAIN-567       | 16TR-5673       | 2201350                  | 3240.79   | 0.00      | 
#    #															    
#    | MAIN-567       | APPS-5673       | 2240100                  | 12755.84  | 11341.95  | 
#    | MAIN-567       | APPS-5673       | 2240150                  | 5733.54   | 5098.03   | 
#    | MAIN-567       | APPS-5673       | 2240160                  | 2774.57   | 0.00      | 
#    | MAIN-567       | APPS-5673       | 2240170                  | 2102.98   | 0.00      | 
#    | MAIN-567       | APPS-5673       | 2340100                  | 19426.60  | 17273.32  | 
#    | MAIN-567       | APPS-5673       | 2340150                  | 5051.04   | 4491.17   | 
#    | MAIN-567       | APPS-5673       | 2340160                  | 2043.01   | 0.00      | 
#    | MAIN-567       | APPS-5673       | 2340170                  | 4166.89   | 0.00      | 
#
#    # Check the CAPPING subnominal aggregations in CRM for Oct and Dec
#    And   the Capping Subnominal Amounts are calculated as follows
#    | ContractNumber | AllocationRef   | CappingSubnominal        | Oct-18    | Dec-18    |
#    | MAIN-567       | 16TR-5671       | 2201300                  | 0.00      | 0.00      | 
#    | MAIN-567       | 16TR-5671       | 2201350                  | 0.00      | 0.00      | 
#    #
#    | MAIN-567       | APPS-5672       | 2240100                  | -6189.94  | -7386.91  | 
#    | MAIN-567       | APPS-5672       | 2240150                  | -3475.72  | -4147.83  | 
#    | MAIN-567       | APPS-5672       | 2240160                  | 0.00      | -528.55   | 
#    | MAIN-567       | APPS-5672       | 2240170                  | 0.00      | -551.40   | 
#    | MAIN-567       | APPS-5672       | 2340100                  | -15597.79 | -18613.97 | 
#    | MAIN-567       | APPS-5672       | 2340150                  | -2808.74  | -3351.87  | 
#    | MAIN-567       | APPS-5672       | 2340160                  | 0.00      | -710.23   | 
#    | MAIN-567       | APPS-5672       | 2340170                  | 0.00      | -1401.43  | 
#    #
#    | MAIN-567       | 16TR-5673       | 2201300                  | 0.00      | 0.00      | 
#    | MAIN-567       | 16TR-5673       | 2201350                  | 0.00      | 0.00      | 
#    #
#    | MAIN-567       | APPS-5673       | 2240100                  | -11341.95 | -12661.56 | 
#    | MAIN-567       | APPS-5673       | 2240150                  | -5098.03  | -5691.16  | 
#    | MAIN-567       | APPS-5673       | 2240160                  | 0.00      | 0.00      | 
#    | MAIN-567       | APPS-5673       | 2240170                  | 0.00      | 0.00      | 
#    | MAIN-567       | APPS-5673       | 2340100                  | -17273.32 | -19283.02 | 
#    | MAIN-567       | APPS-5673       | 2340150                  | -4491.17  | -5013.71  | 
#    | MAIN-567       | APPS-5673       | 2340160                  | 0.00      | 0.00      | 
#    | MAIN-567       | APPS-5673       | 2340170                  | 0.00      | 0.00      | 

	# Tidy up
    And   the override date is reset
	 
