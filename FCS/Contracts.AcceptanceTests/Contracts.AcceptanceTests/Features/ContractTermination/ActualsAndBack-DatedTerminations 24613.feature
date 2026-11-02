Feature: ActualsAndBack-DatedTerminations 24613

@AcceptanceTest @Withdrawn20231002 
Scenario: A852 Create and approve an 1819 NCS contract with just an NCS-C1819 (PoA) allocation. Consume and pay actuals. Initiate future-dated termination (without amendment) and approve initiation. Check there are no changes in CRM, PaaS and Feed
    Given there are no allocations marked as Under Termination for UKPRN '10017852' 
    And   there are no terminated or closed allocations for UKPRN '10017852' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017852' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down the MonitoringDeliverables.HeldReportedActualGroup data for specified Collection Returns
    Given there are no rows on HeldReportedActualGroup for OrgId 'ORG0017852'

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | NCSC-852      |




    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017852' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017852 Co Ltd' with UKPRN '10017852' and OrgId 'ORG0017852' and has 'FCS1 Test' as a manager 
    And   UPIN '117852' is associated with UKPRN '10017852' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017852 | 117852 | 10017852 Co Ltd | 0              | Active | Yes           | AA017852      | ?             | 




    # Change the date
    Given the override date is '01/09/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017852 | 10017852 Co Ltd      | ESFA-852             | NCS-852        | 1                     | 01/10/2018        | 31/03/2019      | 28756.00      |                                | Contract for Services | 1819   | New          | ORG0017852 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017852 | NCS-852        | NCSC-852      | NCS-C             | NCS-C1819               | NCS                     | 01/10/2018          | 31/03/2019        | 28756.00        | Yorkshire and Humber                    | 0000000109 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017852 | NCS-852        | NCSC-852      | 1               | 0                     | 28756.00  | 2341.00  | 6160.00  | 4822.00  | 3171.00  | 7371.00  | 4891.00  | Total In The Community Funding                                  | New          |             |
    | 10017852 | NCS-852        | NCSC-852      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             |
    | 10017852 | NCS-852        | NCSC-852      | 2               | 1                     | 7862.00   | 484.00   | 745.00   | 943.00   | 350.00   | 2129.00  | 3211.00  | Customer Satisfaction                                           | New          |             |
    | 10017852 | NCS-852        | NCSC-852      | 3               | 1                     | 20894.00  | 1857.00  | 5415.00  | 3879.00  | 2821.00  | 5242.00  | 1680.00  | Career Management and Jobs and Learning                         | New          |             |
    | 10017852 | NCS-852        | NCSC-852      | 4               | 3                     | 11705.00  | 376.00   | 2946.00  | 1656.00  | 1824.00  | 3286.00  | 1617.00  | Career Management                                               | New          |             |
    | 10017852 | NCS-852        | NCSC-852      | 5               | 3                     | 9189.00   | 1481.00  | 2469.00  | 2223.00  | 997.00   | 1956.00  | 63.00    | Jobs and Learning                                               | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | 
    | 10017852 | NCS-852        | 6               | NCSC-852      | 35       | 248     | 63       | 12       | 24       | 37       | 90       | 22       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NCS-852' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/09/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-852' and actual ContractNumber 'NCS-852'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-852' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017852 | NCS-852            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/10/2018        | 31/03/2019      | ?             |
    | 10017852 | ESFA-852           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'NCS-852'




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/12/2018'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Nov 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201810 | NCS-C1819               | NCSC-852                 | 0000000109 | 2               | 0            | 1944.34     |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201810 | NCS-C1819               | NCSC-852                 | 0000000109 | 4               | 0            | 920.82      |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201810 | NCS-C1819               | NCSC-852                 | 0000000109 | 5               | 0            | 1367.77     |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201811 | NCS-C1819               | NCSC-852                 | 0000000109 | 2               | 0            | 941.44      |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201811 | NCS-C1819               | NCSC-852                 | 0000000109 | 4               | 0            | 1445.61     |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201811 | NCS-C1819               | NCSC-852                 | 0000000109 | 5               | 0            | 551.30      |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201812 | NCS-C1819               | NCSC-852                 | 0000000109 | 2               | 0            | 2298.41     |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201812 | NCS-C1819               | NCSC-852                 | 0000000109 | 4               | 0            | 1308.25     |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201812 | NCS-C1819               | NCSC-852                 | 0000000109 | 5               | 0            | 1894.06     |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201901 | NCS-C1819               | NCSC-852                 | 0000000109 | 2               | 0            | 1384.39     |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201901 | NCS-C1819               | NCSC-852                 | 0000000109 | 4               | 0            | 2188.83     |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201901 | NCS-C1819               | NCSC-852                 | 0000000109 | 5               | 0            | 1292.97     |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201902 | NCS-C1819               | NCSC-852                 | 0000000109 | 2               | 0            | 1396.95     |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201902 | NCS-C1819               | NCSC-852                 | 0000000109 | 4               | 0            | 829.55      |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201902 | NCS-C1819               | NCSC-852                 | 0000000109 | 5               | 0            | 2116.85     |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201903 | NCS-C1819               | NCSC-852                 | 0000000109 | 2               | 0            | 943.42      |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201903 | NCS-C1819               | NCSC-852                 | 0000000109 | 4               | 0            | 467.10      |
    | NCS1819        | N07                  | ORG0017852     | CM             | 201903 | NCS-C1819               | NCSC-852                 | 0000000109 | 5               | 0            | 1679.58     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service




    # Check CRM and PaaS financials BEFORE termination initiated
	
    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-852        | NCSC-852        | 1               | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | NCS-852        | NCSC-852        | 2               | 2885.78  | 1944.34  | 941.44   | ?        | ?        | ?        | ?        | 
    | NCS-852        | NCSC-852        | 3               | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | NCS-852        | NCSC-852        | 4               | 2366.43  | 920.82   | 1445.61  | ?        | ?        | ?        | ?        | 
    | NCS-852        | NCSC-852        | 5               | 1919.07  | 1367.77  | 551.30   | ?        | ?        | ?        | ?        | 
    | NCS-852        | NCSC-852        | 6               | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-852        | NCSC-852        | 1               | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | NCS-852        | NCSC-852        | 2               | 2885.78  | 0.00     | 2885.78  | ?        | ?        | ?        | ?        | 
    | NCS-852        | NCSC-852        | 3               | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | NCS-852        | NCSC-852        | 4               | 2366.43  | 0.00     | 2366.43  | ?        | ?        | ?        | ?        | 
    | NCS-852        | NCSC-852        | 5               | 1919.07  | 0.00     | 1919.07  | ?        | ?        | ?        | ?        | 
    | NCS-852        | NCSC-852        | 6               | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-852        | NCSC-852        | 1               | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | NCS-852        | NCSC-852        | 2               | 2885.78  | 0.00     | 2885.78  | ?        | ?        | ?        | ?        | 
    | NCS-852        | NCSC-852        | 3               | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 
    | NCS-852        | NCSC-852        | 4               | 2366.43  | 0.00     | 2366.43  | ?        | ?        | ?        | ?        | 
    | NCS-852        | NCSC-852        | 5               | 1919.07  | 0.00     | 1919.07  | ?        | ?        | ?        | ?        | 
    | NCS-852        | NCSC-852        | 6               | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | NCSC-852         | 1             | 1               | 201810 | 2              | 0             | 2341.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-852         | 1             | 2               | 201810 | 2              | 0             | 484.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1944.34     |
    | NCSC-852         | 1             | 3               | 201810 | 2              | 0             | 1857.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-852         | 1             | 4               | 201810 | 2              | 0             | 376.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 920.82      |
    | NCSC-852         | 1             | 5               | 201810 | 2              | 0             | 1481.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1367.77     |
    | NCSC-852         | 1             | 6               | 201810 | 2              | 63            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    #
    | NCSC-852         | 1             | 1               | 201811 | 2              | 0             | 6160.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-852         | 1             | 2               | 201811 | 2              | 0             | 745.00       | 0.00                 | 0.00                | 0.00                   | 2885.78                     | 2885.78          | 0            | 941.44      |
    | NCSC-852         | 1             | 3               | 201811 | 2              | 0             | 5415.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-852         | 1             | 4               | 201811 | 2              | 0             | 2946.00      | 0.00                 | 0.00                | 0.00                   | 2366.43                     | 2366.43          | 0            | 1445.61     |
    | NCSC-852         | 1             | 5               | 201811 | 2              | 0             | 2469.00      | 0.00                 | 0.00                | 0.00                   | 1919.07                     | 1919.07          | 0            | 551.30      |
    | NCSC-852         | 1             | 6               | 201811 | 2              | 12            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    #
    | NCSC-852         | 1             | 1               | 201812 | 2              | 0             | 4822.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 2               | 201812 | 2              | 0             | 943.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 3               | 201812 | 2              | 0             | 3879.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 4               | 201812 | 2              | 0             | 1656.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 5               | 201812 | 2              | 0             | 2223.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 6               | 201812 | 2              | 24            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NCSC-852         | 1             | 1               | 201901 | 2              | 0             | 3171.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 2               | 201901 | 2              | 0             | 350.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 3               | 201901 | 2              | 0             | 2821.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 4               | 201901 | 2              | 0             | 1824.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 5               | 201901 | 2              | 0             | 997.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 6               | 201901 | 2              | 37            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NCSC-852         | 1             | 1               | 201902 | 2              | 0             | 7371.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 2               | 201902 | 2              | 0             | 2129.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 3               | 201902 | 2              | 0             | 5242.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 4               | 201902 | 2              | 0             | 3286.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 5               | 201902 | 2              | 0             | 1956.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 6               | 201902 | 2              | 90            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NCSC-852         | 1             | 1               | 201903 | 2              | 0             | 4891.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 2               | 201903 | 2              | 0             | 3211.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 3               | 201903 | 2              | 0             | 1680.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 4               | 201903 | 2              | 0             | 1617.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 5               | 201903 | 2              | 0             | 63.00        | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 6               | 201903 | 2              | 22            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '16/01/2019'

    # Request termination of the contract via the CRM UI
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'NCS-852' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 25/02/2019               | 25/02/2019              | No                          | Serious Breach          | Company sold            |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | NCSC-852         | 25/02/2019                  | 25/02/2019                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task
    Given the following Tasks are created against version '1' of contract 'NCS-852' for UKPRN '10017852'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017852 - 10017852 Co Ltd     | NCS-852        | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017852 | NCS-852             | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/10/2018        | 31/03/2019      | ?             |
    | 10017852 | ESFA-852            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | NCS-852        | 1                     | 0                        | 25/02/2019              | Company sold            |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | NCSC-852         | 1                     | 0                        | 25/02/2019        | 25/02/2019                |

    
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'NCS-852' for provider '10017852'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017852 - 10017852 Co Ltd     | NCS-852        | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'NCS-852' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | Company sold                     |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '18/01/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'NCS-852' for provider '10017852' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'NCS-852' for provider '10017852'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017852 - 10017852 Co Ltd      | NCS-852        | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'NCS-852' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Company sold                     |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017852 | NCS-852             | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/10/2018        | 31/03/2019      | ?             |
    | 10017852 | ESFA-852            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/10/2018        | 31/03/2019      | ?             |




    # Check CRM and PaaS financials AFTER Termination Initiation approval 

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-852        | NCSC-852        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-852        | NCSC-852        | 2               | 2885.78  | 1944.34  | 941.44   | 0.00     | 0.00     | ?        | ?        | 
    | NCS-852        | NCSC-852        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-852        | NCSC-852        | 4               | 2366.43  | 920.82   | 1445.61  | 0.00     | 0.00     | ?        | ?        | 
    | NCS-852        | NCSC-852        | 5               | 1919.07  | 1367.77  | 551.30   | 0.00     | 0.00     | ?        | ?        | 
    | NCS-852        | NCSC-852        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-852        | NCSC-852        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-852        | NCSC-852        | 2               | 2885.78  | 0.00     | 2885.78  | 0.00     | 0.00     | ?        | ?        | 
    | NCS-852        | NCSC-852        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-852        | NCSC-852        | 4               | 2366.43  | 0.00     | 2366.43  | 0.00     | 0.00     | ?        | ?        | 
    | NCS-852        | NCSC-852        | 5               | 1919.07  | 0.00     | 1919.07  | 0.00     | 0.00     | ?        | ?        | 
    | NCS-852        | NCSC-852        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-852        | NCSC-852        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-852        | NCSC-852        | 2               | 2885.78  | 0.00     | 2885.78  | 0.00     | 0.00     | ?        | ?        | 
    | NCS-852        | NCSC-852        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-852        | NCSC-852        | 4               | 2366.43  | 0.00     | 2366.43  | 0.00     | 0.00     | ?        | ?        | 
    | NCS-852        | NCSC-852        | 5               | 1919.07  | 0.00     | 1919.07  | 0.00     | 0.00     | ?        | ?        | 
    | NCS-852        | NCSC-852        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | NCSC-852         | 1             | 1               | 201810 | 2              | 0             | 2341.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-852         | 1             | 2               | 201810 | 2              | 0             | 484.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1944.34     |
    | NCSC-852         | 1             | 3               | 201810 | 2              | 0             | 1857.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-852         | 1             | 4               | 201810 | 2              | 0             | 376.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 920.82      |
    | NCSC-852         | 1             | 5               | 201810 | 2              | 0             | 1481.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1367.77     |
    | NCSC-852         | 1             | 6               | 201810 | 2              | 63            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    #
    | NCSC-852         | 1             | 1               | 201811 | 2              | 0             | 6160.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-852         | 1             | 2               | 201811 | 2              | 0             | 745.00       | 0.00                 | 0.00                | 0.00                   | 2885.78                     | 2885.78          | 0            | 941.44      |
    | NCSC-852         | 1             | 3               | 201811 | 2              | 0             | 5415.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-852         | 1             | 4               | 201811 | 2              | 0             | 2946.00      | 0.00                 | 0.00                | 0.00                   | 2366.43                     | 2366.43          | 0            | 1445.61     |
    | NCSC-852         | 1             | 5               | 201811 | 2              | 0             | 2469.00      | 0.00                 | 0.00                | 0.00                   | 1919.07                     | 1919.07          | 0            | 551.30      |
    | NCSC-852         | 1             | 6               | 201811 | 2              | 12            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    #
    | NCSC-852         | 1             | 1               | 201812 | 2              | 0             | 4822.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-852         | 1             | 2               | 201812 | 2              | 0             | 943.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-852         | 1             | 3               | 201812 | 2              | 0             | 3879.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-852         | 1             | 4               | 201812 | 2              | 0             | 1656.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-852         | 1             | 5               | 201812 | 2              | 0             | 2223.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-852         | 1             | 6               | 201812 | 2              | 24            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    #
    | NCSC-852         | 1             | 1               | 201901 | 2              | 0             | 3171.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 2               | 201901 | 2              | 0             | 350.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 3               | 201901 | 2              | 0             | 2821.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 4               | 201901 | 2              | 0             | 1824.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 5               | 201901 | 2              | 0             | 997.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 6               | 201901 | 2              | 37            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NCSC-852         | 1             | 1               | 201902 | 2              | 0             | 7371.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 2               | 201902 | 2              | 0             | 2129.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 3               | 201902 | 2              | 0             | 5242.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 4               | 201902 | 2              | 0             | 3286.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 5               | 201902 | 2              | 0             | 1956.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 6               | 201902 | 2              | 90            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NCSC-852         | 1             | 1               | 201903 | 2              | 0             | 4891.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 2               | 201903 | 2              | 0             | 3211.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 3               | 201903 | 2              | 0             | 1680.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 4               | 201903 | 2              | 0             | 1617.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 5               | 201903 | 2              | 0             | 63.00        | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-852         | 1             | 6               | 201903 | 2              | 22            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |




    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

 #  # Check the ADP feed for category 4 (ActualsUpdated) events
 #  Then  the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events
 #  | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | AllocationNumber | ContractVersionNumber |
 #  | ContractAllocationActualsUpdated  | 4      | NCS-852        | NCSC-852         | 1                     |

    # Check that relevant events are on the ADP feed
    Then  the ADP feed includes the following values
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    | ContractAllocationActualsUpdated  | 4      | NCS-852        | 1                     | 0                | NCSC-852         | ?                         | ?                            |

    # Check the ADP feed event header information
    And   the Allocation Delivery feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                     | CategoryLabel                        | Title                                                                               |
    | 10017852 | NCS-852        | 1               | 0                  | ContractAllocationActualsUpdated | Contract Allocation Actuals Updated  | Actuals for Allocation NCSC-852 of Contract NCS-852: 1.0 have been updated          |

    # Check financials on the ADP feed 
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
    | AllocationDeliveryEntryCategory   | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 1               | 201810 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 2               | 201810 | 1944.34     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 3               | 201810 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 4               | 201810 | 920.82      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 5               | 201810 | 1367.77     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 6               | 201810 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 1               | 201811 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 2               | 201811 | 941.44      | 0.00           | 0.00             | 2885.78               | 0.00           | 2885.78    |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 3               | 201811 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 4               | 201811 | 1445.61     | 0.00           | 0.00             | 2366.43               | 0.00           | 2366.43    |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 5               | 201811 | 551.30      | 0.00           | 0.00             | 1919.07               | 0.00           | 1919.07    |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 6               | 201811 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 1               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 2               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 3               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 4               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 5               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 6               | 201812 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 1               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 2               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 3               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 4               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 5               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 6               | 201901 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 1               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 2               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 3               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 4               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 5               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 6               | 201902 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 1               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 2               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 3               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 4               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 5               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | NCS-852        | 1             | NCSC-852         | 6               | 201903 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Complete 
@Long2Run @Long2Run890
Scenario: A853 Create and approve an NLAP2018 contract. Consume actuals. Initiate and approve then cancel termination. Consume actuals. Amend and approve contract. Initiate and approve termination. Check CRM and Feed
    Given there are no allocations marked as Under Termination for UKPRN '10017853' 
    And   there are no terminated or closed allocations for UKPRN '10017853' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017853' 

    # Clear down ADP and CM feeds
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ANLP-853      |
    | YNLP-853      |




    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017853' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017853 Co Ltd' with UKPRN '10017853' and OrgId 'ORG0017853' and has 'FCS1 Test' as a manager 
    And   UPIN '117853' is associated with UKPRN '10017853' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017853 | 117853 | 10017853 Co Ltd | 0              | Active | Yes           | AA017853      | ?             | 




    # Change the date
    Given the override date is '01/12/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017853 | 10017853 Co Ltd      | ESFA-853             | NLAP-853       | 1                     | 01/01/2018        | 31/03/2019      | 54892.00      |                                | Contract for Services | 2018   | New          | ORG0017853 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017853 | NLAP-853       | ANLP-853      | ANLAP             | ANLAP2018               | NONLEVY                 | 01/01/2018          | 31/03/2019        | 25394.00        |                                         |            |                                                             | New          |             |
    | 10017853 | NLAP-853       | YNLP-853      | 16-18NLAP         | 16-18NLAP2018           | NONLEVY                 | 01/01/2018          | 31/03/2019        | 29498.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017853 | NLAP-853       | ANLP-853      | 1               | 0                     | 25394.00  | 2633.00  | 617.00   | 246.00   | 2341.00  | 2475.00  | 1091.00  | 1541.00  | 2909.00  | 3487.00  | 2736.00  | 1289.00  | 948.00   | 987.00   | 869.00   | 1225.00  | Total Adult Non-Levy Apprenticeships Funding                    | New          |             |
    | 10017853 | NLAP-853       | YNLP-853      | 1               | 0                     | 29498.00  | 1080.00  | 1564.00  | 2078.00  | 3254.00  | 1460.00  | 1406.00  | 2552.00  | 1831.00  | 2028.00  | 1436.00  | 3214.00  | 1579.00  | 67.00    | 3619.00  | 2330.00  | Total 16-18 Non-Levy Apprenticeships Funding                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NLAP-853' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-853' and actual ContractNumber 'NLAP-853'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-853' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017853 | NLAP-853           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017853 | ESFA-853           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '150' deliverable period rows in CRM linked to the latest version of contract 'NLAP-853'



    # Add actuals to the contract

    # Change the date
    Given the override date is '04/01/2019'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Dec 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode   | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201808 | 16-18NLAP2018           | YNLP-853                 |           | 2               | 0            | 1083.52     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201808 | 16-18NLAP2018           | YNLP-853                 |           | 3               | 0            | 1230.21     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201808 | 16-18NLAP2018           | YNLP-853                 |           | 4               | 0            | 224.05      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201808 | 16-18NLAP2018           | YNLP-853                 |           | 5               | 0            | 653.31      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201809 | 16-18NLAP2018           | YNLP-853                 |           | 2               | 0            | 395.64      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201809 | 16-18NLAP2018           | YNLP-853                 |           | 3               | 0            | 1490.87     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201809 | 16-18NLAP2018           | YNLP-853                 |           | 4               | 0            | 1001.00     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201809 | 16-18NLAP2018           | YNLP-853                 |           | 5               | 0            | 995.66      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201810 | 16-18NLAP2018           | YNLP-853                 |           | 2               | 0            | 1499.00     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201810 | 16-18NLAP2018           | YNLP-853                 |           | 3               | 0            | 539.54      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201810 | 16-18NLAP2018           | YNLP-853                 |           | 4               | 0            | 1328.75     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201810 | 16-18NLAP2018           | YNLP-853                 |           | 5               | 0            | 941.09      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201811 | 16-18NLAP2018           | YNLP-853                 |           | 2               | 0            | 626.73      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201811 | 16-18NLAP2018           | YNLP-853                 |           | 3               | 0            | 1014.31     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201811 | 16-18NLAP2018           | YNLP-853                 |           | 4               | 0            | 1080.57     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201811 | 16-18NLAP2018           | YNLP-853                 |           | 5               | 0            | 1307.26     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201812 | 16-18NLAP2018           | YNLP-853                 |           | 2               | 0            | 1013.34     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201812 | 16-18NLAP2018           | YNLP-853                 |           | 3               | 0            | 1349.14     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201812 | 16-18NLAP2018           | YNLP-853                 |           | 4               | 0            | 142.05      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201812 | 16-18NLAP2018           | YNLP-853                 |           | 5               | 0            | 1474.91     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201901 | 16-18NLAP2018           | YNLP-853                 |           | 2               | 0            | 404.09      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201901 | 16-18NLAP2018           | YNLP-853                 |           | 3               | 0            | 1045.78     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201901 | 16-18NLAP2018           | YNLP-853                 |           | 4               | 0            | 795.46      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201901 | 16-18NLAP2018           | YNLP-853                 |           | 5               | 0            | 634.75      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201902 | 16-18NLAP2018           | YNLP-853                 |           | 2               | 0            | 1314.36     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201902 | 16-18NLAP2018           | YNLP-853                 |           | 3               | 0            | 695.61      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201902 | 16-18NLAP2018           | YNLP-853                 |           | 4               | 0            | 654.11      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201902 | 16-18NLAP2018           | YNLP-853                 |           | 5               | 0            | 784.34      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201903 | 16-18NLAP2018           | YNLP-853                 |           | 2               | 0            | 638.98      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201903 | 16-18NLAP2018           | YNLP-853                 |           | 3               | 0            | 951.56      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201903 | 16-18NLAP2018           | YNLP-853                 |           | 4               | 0            | 1346.75     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201903 | 16-18NLAP2018           | YNLP-853                 |           | 5               | 0            | 274.92      |
    #
    | ILR1819        | R05                  | ORG0017853     | CM             | 201808 | ANLAP2018               | ANLP-853                 |           | 2               | 0            | 611.71      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201808 | ANLAP2018               | ANLP-853                 |           | 3               | 0            | 449.95      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201808 | ANLAP2018               | ANLP-853                 |           | 4               | 0            | 751.93      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201808 | ANLAP2018               | ANLP-853                 |           | 5               | 0            | 308.35      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201809 | ANLAP2018               | ANLP-853                 |           | 2               | 0            | 514.49      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201809 | ANLAP2018               | ANLP-853                 |           | 3               | 0            | 1082.36     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201809 | ANLAP2018               | ANLP-853                 |           | 4               | 0            | 982.39      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201809 | ANLAP2018               | ANLP-853                 |           | 5               | 0            | 583.93      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201810 | ANLAP2018               | ANLP-853                 |           | 2               | 0            | 1336.94     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201810 | ANLAP2018               | ANLP-853                 |           | 3               | 0            | 1017.53     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201810 | ANLAP2018               | ANLP-853                 |           | 4               | 0            | 1319.41     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201810 | ANLAP2018               | ANLP-853                 |           | 5               | 0            | 895.29      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201811 | ANLAP2018               | ANLP-853                 |           | 2               | 0            | 985.61      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201811 | ANLAP2018               | ANLP-853                 |           | 3               | 0            | 673.22      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201811 | ANLAP2018               | ANLP-853                 |           | 4               | 0            | 1297.20     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201811 | ANLAP2018               | ANLP-853                 |           | 5               | 0            | 277.29      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201812 | ANLAP2018               | ANLP-853                 |           | 2               | 0            | 1043.46     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201812 | ANLAP2018               | ANLP-853                 |           | 3               | 0            | 638.10      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201812 | ANLAP2018               | ANLP-853                 |           | 4               | 0            | 1337.29     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201812 | ANLAP2018               | ANLP-853                 |           | 5               | 0            | 702.87      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201901 | ANLAP2018               | ANLP-853                 |           | 2               | 0            | 1279.18     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201901 | ANLAP2018               | ANLP-853                 |           | 3               | 0            | 1343.59     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201901 | ANLAP2018               | ANLP-853                 |           | 4               | 0            | 932.88      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201901 | ANLAP2018               | ANLP-853                 |           | 5               | 0            | 1329.93     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201902 | ANLAP2018               | ANLP-853                 |           | 2               | 0            | 106.56      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201902 | ANLAP2018               | ANLP-853                 |           | 3               | 0            | 285.77      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201902 | ANLAP2018               | ANLP-853                 |           | 4               | 0            | 1383.22     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201902 | ANLAP2018               | ANLP-853                 |           | 5               | 0            | 1498.19     |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201903 | ANLAP2018               | ANLP-853                 |           | 2               | 0            | 993.93      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201903 | ANLAP2018               | ANLP-853                 |           | 3               | 0            | 797.27      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201903 | ANLAP2018               | ANLP-853                 |           | 4               | 0            | 478.00      |
    | ILR1819        | R05                  | ORG0017853     | CM             | 201903 | ANLAP2018               | ANLP-853                 |           | 5               | 0            | 1276.09     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service




    # Check CRM

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
#   | NLAP-853       | ANLP-853        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 2               | 4492.21  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 611.71   | 514.49   | 1336.94  | 985.61   | 1043.46  | ?        | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 3               | 3861.16  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 449.95   | 1082.36  | 1017.53  | 673.22   | 638.10   | ?        | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 4               | 5688.22  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 751.93   | 982.39   | 1319.41  | 1297.20  | 1337.29  | ?        | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 5               | 2767.73  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 308.35   | 583.93   | 895.29   | 277.29   | 702.87   | ?        | ?        | ?        | 
    #
#   | NLAP-853       | YNLP-853        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 2               | 4618.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1083.52  | 395.64   | 1499.00  | 626.73   | 1013.34  | ?        | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 3               | 5624.07  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1230.21  | 1490.87  | 539.54   | 1014.31  | 1349.14  | ?        | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 4               | 3776.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 224.05   | 1001.00  | 1328.75  | 1080.57  | 142.05   | ?        | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 5               | 5372.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 653.31   | 995.66   | 941.09   | 1307.26  | 1474.91  | ?        | ?        | ?        | 




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '09/01/2019'

    # Request termination of the contract 
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'NLAP-853' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 28/09/2018               | 28/09/2018              | No                          | Notice from Agency      | Director in prison      |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ANLP-853         | 28/09/2018                  | 28/09/2018                |
    | YNLP-853         | 28/09/2018                  | 28/09/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'NLAP-853' for UKPRN '10017853'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017853 - 10017853 Co Ltd     | NLAP-853       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017853 | NLAP-853            | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017853 | ESFA-853            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '12/01/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'NLAP-853' for provider '10017853' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'NLAP-853' for provider '10017853'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017853 - 10017853 Co Ltd      | NLAP-853       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017853 | NLAP-853            | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017853 | ESFA-853            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Check CRM
	
    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
#   | NLAP-853       | ANLP-853        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 2               | 1126.20  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 611.71   | 514.49   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 3               | 1532.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 449.95   | 1082.36  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 4               | 1734.32  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 751.93   | 982.39   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 5               | 892.28   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 308.35   | 583.93   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    #
#   | NLAP-853       | YNLP-853        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 2               | 1479.16  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1083.52  | 395.64   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 3               | 2721.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1230.21  | 1490.87  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 4               | 1225.05  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 224.05   | 1001.00  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 5               | 1648.97  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 653.31   | 995.66   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
	
	
	
	
	# Cancel Termination

    # Change the date
    Given the override date is '15/01/2019'

    # Manager CANCELS termination request (23811)
#   When  CRM user 'FCS8 Test' cancels the termination request for Contract 'NLAP-853' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' cancels the termination request for Contract 'NLAP-853' Version '1' SubVersion '0' via SDK

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus    | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017853 | NLAP-853       | 1                     | 0                        | Approved       | Approved             | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017853 | ESFA-853       | 1                     | 0                        | Draft          | ?                    | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Check CRM

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
#   | NLAP-853       | ANLP-853        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 2               | 1126.20  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 611.71   | 514.49   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 3               | 1532.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 449.95   | 1082.36  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 4               | 1734.32  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 751.93   | 982.39   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 5               | 892.28   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 308.35   | 583.93   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    #
#   | NLAP-853       | YNLP-853        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 2               | 1479.16  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1083.52  | 395.64   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 3               | 2721.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1230.21  | 1490.87  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 4               | 1225.05  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 224.05   | 1001.00  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 5               | 1648.97  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 653.31   | 995.66   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 



    # Add actuals to the contract again

    # Change the date
    Given the override date is '04/02/2019'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Jan 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode   | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201808 | 16-18NLAP2018           | YNLP-853                 |           | 2               | 0            | 1083.52     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201808 | 16-18NLAP2018           | YNLP-853                 |           | 3               | 0            | 1230.21     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201808 | 16-18NLAP2018           | YNLP-853                 |           | 4               | 0            | 224.05      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201808 | 16-18NLAP2018           | YNLP-853                 |           | 5               | 0            | 653.31      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201809 | 16-18NLAP2018           | YNLP-853                 |           | 2               | 0            | 395.64      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201809 | 16-18NLAP2018           | YNLP-853                 |           | 3               | 0            | 1490.87     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201809 | 16-18NLAP2018           | YNLP-853                 |           | 4               | 0            | 1001.00     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201809 | 16-18NLAP2018           | YNLP-853                 |           | 5               | 0            | 995.66      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201810 | 16-18NLAP2018           | YNLP-853                 |           | 2               | 0            | 1499.00     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201810 | 16-18NLAP2018           | YNLP-853                 |           | 3               | 0            | 539.54      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201810 | 16-18NLAP2018           | YNLP-853                 |           | 4               | 0            | 1328.75     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201810 | 16-18NLAP2018           | YNLP-853                 |           | 5               | 0            | 941.09      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201811 | 16-18NLAP2018           | YNLP-853                 |           | 2               | 0            | 626.73      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201811 | 16-18NLAP2018           | YNLP-853                 |           | 3               | 0            | 1014.31     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201811 | 16-18NLAP2018           | YNLP-853                 |           | 4               | 0            | 1080.57     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201811 | 16-18NLAP2018           | YNLP-853                 |           | 5               | 0            | 1307.26     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201812 | 16-18NLAP2018           | YNLP-853                 |           | 2               | 0            | 1013.34     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201812 | 16-18NLAP2018           | YNLP-853                 |           | 3               | 0            | 1349.14     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201812 | 16-18NLAP2018           | YNLP-853                 |           | 4               | 0            | 142.05      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201812 | 16-18NLAP2018           | YNLP-853                 |           | 5               | 0            | 1474.91     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201901 | 16-18NLAP2018           | YNLP-853                 |           | 2               | 0            | 404.09      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201901 | 16-18NLAP2018           | YNLP-853                 |           | 3               | 0            | 1045.78     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201901 | 16-18NLAP2018           | YNLP-853                 |           | 4               | 0            | 795.46      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201901 | 16-18NLAP2018           | YNLP-853                 |           | 5               | 0            | 634.75      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201902 | 16-18NLAP2018           | YNLP-853                 |           | 2               | 0            | 1314.36     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201902 | 16-18NLAP2018           | YNLP-853                 |           | 3               | 0            | 695.61      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201902 | 16-18NLAP2018           | YNLP-853                 |           | 4               | 0            | 654.11      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201902 | 16-18NLAP2018           | YNLP-853                 |           | 5               | 0            | 784.34      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201903 | 16-18NLAP2018           | YNLP-853                 |           | 2               | 0            | 638.98      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201903 | 16-18NLAP2018           | YNLP-853                 |           | 3               | 0            | 951.56      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201903 | 16-18NLAP2018           | YNLP-853                 |           | 4               | 0            | 1346.75     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201903 | 16-18NLAP2018           | YNLP-853                 |           | 5               | 0            | 274.92      |
    #
    | ILR1819        | R06                  | ORG0017853     | CM             | 201808 | ANLAP2018               | ANLP-853                 |           | 2               | 0            | 611.71      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201808 | ANLAP2018               | ANLP-853                 |           | 3               | 0            | 449.95      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201808 | ANLAP2018               | ANLP-853                 |           | 4               | 0            | 751.93      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201808 | ANLAP2018               | ANLP-853                 |           | 5               | 0            | 308.35      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201809 | ANLAP2018               | ANLP-853                 |           | 2               | 0            | 514.49      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201809 | ANLAP2018               | ANLP-853                 |           | 3               | 0            | 1082.36     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201809 | ANLAP2018               | ANLP-853                 |           | 4               | 0            | 982.39      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201809 | ANLAP2018               | ANLP-853                 |           | 5               | 0            | 583.93      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201810 | ANLAP2018               | ANLP-853                 |           | 2               | 0            | 1336.94     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201810 | ANLAP2018               | ANLP-853                 |           | 3               | 0            | 1017.53     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201810 | ANLAP2018               | ANLP-853                 |           | 4               | 0            | 1319.41     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201810 | ANLAP2018               | ANLP-853                 |           | 5               | 0            | 895.29      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201811 | ANLAP2018               | ANLP-853                 |           | 2               | 0            | 985.61      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201811 | ANLAP2018               | ANLP-853                 |           | 3               | 0            | 673.22      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201811 | ANLAP2018               | ANLP-853                 |           | 4               | 0            | 1297.20     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201811 | ANLAP2018               | ANLP-853                 |           | 5               | 0            | 277.29      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201812 | ANLAP2018               | ANLP-853                 |           | 2               | 0            | 1043.46     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201812 | ANLAP2018               | ANLP-853                 |           | 3               | 0            | 638.10      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201812 | ANLAP2018               | ANLP-853                 |           | 4               | 0            | 1337.29     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201812 | ANLAP2018               | ANLP-853                 |           | 5               | 0            | 702.87      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201901 | ANLAP2018               | ANLP-853                 |           | 2               | 0            | 1279.18     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201901 | ANLAP2018               | ANLP-853                 |           | 3               | 0            | 1343.59     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201901 | ANLAP2018               | ANLP-853                 |           | 4               | 0            | 932.88      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201901 | ANLAP2018               | ANLP-853                 |           | 5               | 0            | 1329.93     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201902 | ANLAP2018               | ANLP-853                 |           | 2               | 0            | 106.56      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201902 | ANLAP2018               | ANLP-853                 |           | 3               | 0            | 285.77      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201902 | ANLAP2018               | ANLP-853                 |           | 4               | 0            | 1383.22     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201902 | ANLAP2018               | ANLP-853                 |           | 5               | 0            | 1498.19     |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201903 | ANLAP2018               | ANLP-853                 |           | 2               | 0            | 993.93      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201903 | ANLAP2018               | ANLP-853                 |           | 3               | 0            | 797.27      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201903 | ANLAP2018               | ANLP-853                 |           | 4               | 0            | 478.00      |
    | ILR1819        | R06                  | ORG0017853     | CM             | 201903 | ANLAP2018               | ANLP-853                 |           | 5               | 0            | 1276.09     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



	# Check CRM

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
#   | NLAP-853       | ANLP-853        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 2               | 5771.39  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 611.71   | 514.49   | 1336.94  | 985.61   | 1043.46  | 1279.18  | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 3               | 5204.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 449.95   | 1082.36  | 1017.53  | 673.22   | 638.10   | 1343.59  | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 4               | 6621.10  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 751.93   | 982.39   | 1319.41  | 1297.20  | 1337.29  | 932.88   | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 5               | 4097.66  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 308.35   | 583.93   | 895.29   | 277.29   | 702.87   | 1329.93  | ?        | ?        | 
    #
#   | NLAP-853       | YNLP-853        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 2               | 5022.32  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1083.52  | 395.64   | 1499.00  | 626.73   | 1013.34  | 404.09   | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 3               | 6669.85  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1230.21  | 1490.87  | 539.54   | 1014.31  | 1349.14  | 1045.78  | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 4               | 4571.88  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 224.05   | 1001.00  | 1328.75  | 1080.57  | 142.05   | 795.46   | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 5               | 6006.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 653.31   | 995.66   | 941.09   | 1307.26  | 1474.91  | 634.75   | ?        | ?        | 




    # Change the date
    Given the override date is '22/03/2019'

    # Amend the contract by bulk upload
    And   there are no files prefixed '10017853_NLAP-853' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 12112018112529 v2_A853' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 12112018112529 v2_A853' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 12112018112529 v2_A853.xlsx' exists in the Datafiles folder and UKPRN '10017853' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Change the date
    Given the override date is '23/03/2019'

    # Publish the contract
    And   the latest version of contract 'NLAP-853' is in a state of 'Published to Provider'

	# Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-853' and actual ContractNumber 'NLAP-853'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017853 | NLAP-853           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2019      | Variation     |
    | 10017853 | NLAP-853           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/01/2018        | 31/03/2019      | ?             |
    | 10017853 | ESFA-853           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




	# Check CRM

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
#   | NLAP-853       | ANLP-853        | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 2               | 5771.39   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 611.71   | 514.49   | 1336.94  | 985.61   | 1043.46  | 1279.18  | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 3               | 5204.75   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 449.95   | 1082.36  | 1017.53  | 673.22   | 638.10   | 1343.59  | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 4               | 6621.10   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 751.93   | 982.39   | 1319.41  | 1297.20  | 1337.29  | 932.88   | ?        | ?        | 
    | NLAP-853       | ANLP-853        | 5               | 4097.66   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 308.35   | 583.93   | 895.29   | 277.29   | 702.87   | 1329.93  | ?        | ?        | 
    #
#   | NLAP-853       | YNLP-853        | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 2               | 5022.32   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1083.52  | 395.64   | 1499.00  | 626.73   | 1013.34  | 404.09   | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 3               | 6669.85   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1230.21  | 1490.87  | 539.54   | 1014.31  | 1349.14  | 1045.78  | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 4               | 4571.88   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 224.05   | 1001.00  | 1328.75  | 1080.57  | 142.05   | 795.46   | ?        | ?        | 
    | NLAP-853       | YNLP-853        | 5               | 6006.98   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 653.31   | 995.66   | 941.09   | 1307.26  | 1474.91  | 634.75   | ?        | ?        | 




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '25/03/2019'

    # Request termination of the contract 
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'NLAP-853' Version '2' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 02/11/2018               | 02/11/2018              | Yes                         | Notice from Agency      | Director in prison      |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ANLP-853         | 02/11/2018                  | 02/11/2018                |
    | YNLP-853         | 02/11/2018                  | 02/11/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '2' of contract 'NLAP-853' for UKPRN '10017853'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017853 - 10017853 Co Ltd     | NCS-852        | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017853 | NLAP-853           | 2                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 01/01/2018        | 31/03/2019      | Variation     |
    | 10017853 | NLAP-853           | 1                     | 0                        | Replaced         | Approved                                 | False         | False               | 01/01/2018        | 31/03/2019      | ?             |
    | 10017853 | ESFA-853           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '27/03/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '2' of contract 'NLAP-853' for provider '10017853' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '2' of contract 'NLAP-853' for provider '10017853'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017853 - 10017853 Co Ltd      | NLAP-853       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017853 | NLAP-853           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/01/2018        | 31/03/2019      | Notification  |
    | 10017853 | NLAP-853           | 2                     | 0                        | Approved         | Under Termination         | False         | True                | 01/01/2018        | 31/03/2019      | Variation     |
    | 10017853 | NLAP-853           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/01/2018        | 31/03/2019      | ?             |
    | 10017853 | ESFA-853           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Change the date
    Given the override date is '28/03/2019'

    # Publish the contract
    And   the latest version of contract 'NLAP-853' is in a state of 'Published to Provider'

	# Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-853' and actual ContractNumber 'NLAP-853'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017853 | NLAP-853           | 3                     | 0                        | Approved         | Under Termination         | True          | True                | 01/01/2018        | 31/03/2019      | Notification  |
    | 10017853 | NLAP-853           | 2                     | 0                        | Replaced         | Under Termination         | False         | False               | 01/01/2018        | 31/03/2019      | Variation     |
    | 10017853 | NLAP-853           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/01/2018        | 31/03/2019      | ?             |
    | 10017853 | ESFA-853           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Check CRM
	
	# Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
#   | NLAP-853       | ANLP-853        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | NLAP-853       | ANLP-853        | 2               | 5771.39  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 611.71   | 514.49   | 1336.94  | 985.61   | 0.00     | 0.00     | 0.00     | 0.00     |
    | NLAP-853       | ANLP-853        | 3               | 5204.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 449.95   | 1082.36  | 1017.53  | 673.22   | 0.00     | 0.00     | 0.00     | 0.00     |
    | NLAP-853       | ANLP-853        | 4               | 6621.10  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 751.93   | 982.39   | 1319.41  | 1297.20  | 0.00     | 0.00     | 0.00     | 0.00     |
    | NLAP-853       | ANLP-853        | 5               | 4097.66  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 308.35   | 583.93   | 895.29   | 277.29   | 0.00     | 0.00     | 0.00     | 0.00     |
    #
#   | NLAP-853       | YNLP-853        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |
    | NLAP-853       | YNLP-853        | 2               | 5022.32  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1083.52  | 395.64   | 1499.00  | 626.73   | 0.00     | 0.00     | 0.00     | 0.00     |
    | NLAP-853       | YNLP-853        | 3               | 6669.85  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1230.21  | 1490.87  | 539.54   | 1014.31  | 0.00     | 0.00     | 0.00     | 0.00     |
    | NLAP-853       | YNLP-853        | 4               | 4571.88  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 224.05   | 1001.00  | 1328.75  | 1080.57  | 0.00     | 0.00     | 0.00     | 0.00     |
    | NLAP-853       | YNLP-853        | 5               | 6006.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 653.31   | 995.66   | 941.09   | 1307.26  | 0.00     | 0.00     | 0.00     | 0.00     |


	

    # Check ADP Feed

    # Check all activity has finished
    When   there are no messages left in the system

    # Check the ADP feed for category 4 (ActualsUpdated) events
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events 
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | AllocationNumber | ContractVersionNumber |
    | ContractAllocationActualsUpdated  | 4      | NLAP-853       | ANLP-853         | 1                     |
    | ContractAllocationActualsUpdated  | 4      | NLAP-853       | YNLP-853         | 1                     |

    # Check the ADP feed event header information
    And   the Allocation Delivery feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                        | CategoryLabel                        | Title                                                                         |
    | 10017853 | NLAP-853       | 1               | 0                  | ContractAllocationActualsUpdated    | Contract Allocation Actuals Updated  | Actuals for Allocation ANLP-853 of Contract NLAP-853: 1.0 have been updated   |
    | 10017853 | NLAP-853       | 1               | 0                  | ContractAllocationActualsUpdated    | Contract Allocation Actuals Updated  | Actuals for Allocation YNLP-853 of Contract NLAP-853: 1.0 have been updated   |


	# Tidy up
    And   the override date is reset 

