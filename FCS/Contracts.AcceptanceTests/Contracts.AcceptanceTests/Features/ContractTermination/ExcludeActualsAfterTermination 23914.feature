Feature: ExcludeActualsAfterTermination 23914

@AcceptanceTest @Withdrawn20231002 
Scenario: A779 Create and approve an 1819 Mainstream contract with just an AEBC1819 (PoP) allocation. Move to Awaiting Initiation Approval through the UI. Consume actuals ok after Termination date. Move to Under Termination. Consume actuals for a subsequent month (with restatement) after Termination date. Check CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017779' 
	And   there is no Contract, Task or Workflow data for UKPRN '10017779' 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEC-779       |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017779' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017779 Co Ltd' with UKPRN '10017779' and OrgId 'ORG0017779' and has 'FCS1 Test' as a manager 
    And   UPIN '117779' is associated with UKPRN '10017779' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017779 | 117779 | 10017779 Co Ltd | 0              | Active | Yes           | AA017779      | ?             | 




    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017779 | 10017779 Co Ltd      | ESFA-779             | MAIN-779       | 1                     | 01/08/2018        | 31/07/2019      | 40627.00      |                                | Contract for Services | 1819   | New          | ORG0017779 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017779 | MAIN-779       | AEC-779       | AEBC              | AEBC1819                | AY                      | 01/08/2018          | 31/07/2019        | 40627.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017779 | MAIN-779       | AEC-779       | 1               | 0                     | 40627.00  | 3506.00  | 1499.00  | 2083.00  | 2067.00  | 3095.00  | 3713.00  | 2843.00  | 5452.00  | 4044.00  | 3585.00  | 4963.00  | 3777.00  | Total 16-18 Traineeships Funding                                | New          |             |
    | 10017779 | MAIN-779       | AEC-779       | 13              | 1                     | 22356.00  | 1798.00  | 1111.00  | 454.00   | 1442.00  | 2178.00  | 953.00   | 928.00   | 3720.00  | 2747.00  | 983.00   | 2574.00  | 3468.00  | Community Learning                                              | New          |             |
    | 10017779 | MAIN-779       | AEC-779       | 14              | 1                     | 18271.00  | 1708.00  | 388.00   | 1629.00  | 625.00   | 917.00   | 2760.00  | 1915.00  | 1732.00  | 1297.00  | 2602.00  | 2389.00  | 309.00   | Other AEB Funding                                               | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-779' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-779' and actual ContractNumber 'MAIN-779'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-779' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017779 | MAIN-779           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017779 | ESFA-779           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'MAIN-779'




    # Initiate but don't confirm a TERMINATION 

    # Change the date
    Given the override date is '18/03/2019'

    # Request termination of the contract via the CRM SDK
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-779' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 06/04/2019               | 25/04/2019              | No                          | Notice from Agency      | Acquisition in progress |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | AEC-779          | 06/04/2019                  | 25/04/2019                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'MAIN-779' for UKPRN '10017779'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017779 - 10017779 Co Ltd     | MAIN-779       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017779 | MAIN-779       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017779 | ESFA-779       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | MAIN-779       | 1                     | 0                        | 25/04/2019              | Acquisition in progress |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | AEC-779          | 1                     | 0                        | 06/04/2019        | 25/04/2019                |

   
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'MAIN-779' for provider '10017779'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017779 - 10017779 Co Ltd     | MAIN-779       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'MAIN-779' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | Acquisition in progress          |




    # Consume actuals BEFORE the Termination is confirmed but AFTER the Termination date

    # Change the date
    Given the override date is '04/06/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017779'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for May 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201808 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 1362.06     |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201808 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 1317.63     |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201808 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 167.72      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201808 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 1079.50     |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201808 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 1320.47     |
    #
    | ILR1819        | R10                  | ORG0017779     | CM             | 201809 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 1381.23     |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201809 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 510.47      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201809 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 200.61      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201809 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 1059.02     |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201809 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 1409.86     |
    #
    | ILR1819        | R10                  | ORG0017779     | CM             | 201810 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 241.71      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201810 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 505.49      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201810 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 598.64      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201810 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 378.22      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201810 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 1124.86     |
    #
    | ILR1819        | R10                  | ORG0017779     | CM             | 201811 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 641.37      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201811 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 585.09      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201811 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 986.60      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201811 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 746.55      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201811 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 585.78      |
    #
    | ILR1819        | R10                  | ORG0017779     | CM             | 201812 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 473.28      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201812 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 1107.73     |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201812 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 1376.10     |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201812 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 268.41      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201812 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 1261.69     |
    #
    | ILR1819        | R10                  | ORG0017779     | CM             | 201901 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 983.68      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201901 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 974.74      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201901 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 1342.95     |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201901 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 176.70      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201901 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 972.76      |
    #
    | ILR1819        | R10                  | ORG0017779     | CM             | 201902 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 1355.12     |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201902 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 908.99      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201902 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 1107.05     |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201902 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 1046.33     |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201902 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 1290.61     |
    #
    | ILR1819        | R10                  | ORG0017779     | CM             | 201903 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 983.91      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201903 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 188.10      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201903 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 635.72      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201903 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 1174.71     |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201903 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 124.71      |
    #
    | ILR1819        | R10                  | ORG0017779     | CM             | 201904 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 1136.32     |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201904 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 229.12      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201904 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 1030.40     |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201904 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 799.97      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201904 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 133.55      |
    #
    | ILR1819        | R10                  | ORG0017779     | CM             | 201905 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 518.40      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201905 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 269.54      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201905 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 311.60      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201905 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 461.50      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201905 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 496.03      |
    #
    | ILR1819        | R10                  | ORG0017779     | CM             | 201906 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 602.22      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201906 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 266.82      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201906 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 886.02      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201906 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 101.94      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201906 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 896.16      |
    #
    | ILR1819        | R10                  | ORG0017779     | CM             | 201907 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 1000.01     |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201907 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 1191.50     |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201907 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 420.40      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201907 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 786.05      |
    | ILR1819        | R10                  | ORG0017779     | CM             | 201907 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 544.53      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



	# Check CRM and PaaS

   # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-779       | AEC-779         | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-779       | AEC-779         | 2               | 9077.08  | 1362.06  | 1381.23  | 241.71   | 641.37   | 473.28   | 983.68   | 1355.12  | 983.91   | 1136.32  | 518.40   | ?        | ?        | 
    | MAIN-779       | AEC-779         | 3               | 6596.90  | 1317.63  | 510.47   | 505.49   | 585.09   | 1107.73  | 974.74   | 908.99   | 188.10   | 229.12   | 269.54   | ?        | ?        | 
    | MAIN-779       | AEC-779         | 4               | 7757.39  | 167.72   | 200.61   | 598.64   | 986.60   | 1376.10  | 1342.95  | 1107.05  | 635.72   | 1030.40  | 311.60   | ?        | ?        | 
    | MAIN-779       | AEC-779         | 5               | 7190.91  | 1079.50  | 1059.02  | 378.22   | 746.55   | 268.41   | 176.70   | 1046.33  | 1174.71  | 799.97   | 461.50   | ?        | ?        | 
    | MAIN-779       | AEC-779         | 6               | 8720.32  | 1320.47  | 1409.86  | 1124.86  | 585.78   | 1261.69  | 972.76   | 1290.61  | 124.71   | 133.55   | 496.03   | ?        | ?        | 
    | MAIN-779       | AEC-779         | 13              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-779       | AEC-779         | 14              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | AEC-779          | 1             | 1               | 201808 | 2              | 0             | 3506.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1362.06     |
    | AEC-779          | 1             | 3               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1317.63     |
    | AEC-779          | 1             | 4               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 167.72      |
    | AEC-779          | 1             | 5               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1079.50     |
    | AEC-779          | 1             | 6               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1320.47     |
    | AEC-779          | 1             | 13              | 201808 | 2              | 0             | 1798.00      | 1798.00              | 0.00                | 0.00                   | 0.00                        | 1798.00          | ?            | ?           |
    | AEC-779          | 1             | 14              | 201808 | 2              | 0             | 1708.00      | 1708.00              | 0.00                | 0.00                   | 0.00                        | 1708.00          | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201809 | 2              | 0             | 1499.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1381.23     |
    | AEC-779          | 1             | 3               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 510.47      |
    | AEC-779          | 1             | 4               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 200.61      |
    | AEC-779          | 1             | 5               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1059.02     |
    | AEC-779          | 1             | 6               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1409.86     |
    | AEC-779          | 1             | 13              | 201809 | 2              | 0             | 1111.00      | 1111.00              | 0.00                | 0.00                   | 0.00                        | 1111.00          | ?            | ?           |
    | AEC-779          | 1             | 14              | 201809 | 2              | 0             | 388.00       | 388.00               | 0.00                | 0.00                   | 0.00                        | 388.00           | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201810 | 2              | 0             | 2083.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 241.71      |
    | AEC-779          | 1             | 3               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 505.49      |
    | AEC-779          | 1             | 4               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 598.64      |
    | AEC-779          | 1             | 5               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 378.22      |
    | AEC-779          | 1             | 6               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1124.86     |
    | AEC-779          | 1             | 13              | 201810 | 2              | 0             | 454.00       | 454.00               | 0.00                | 0.00                   | 0.00                        | 454.00           | ?            | ?           |
    | AEC-779          | 1             | 14              | 201810 | 2              | 0             | 1629.00      | 1629.00              | 0.00                | 0.00                   | 0.00                        | 1629.00          | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201811 | 2              | 0             | 2067.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 641.37      |
    | AEC-779          | 1             | 3               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 585.09      |
    | AEC-779          | 1             | 4               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 986.60      |
    | AEC-779          | 1             | 5               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 746.55      |
    | AEC-779          | 1             | 6               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 585.78      |
    | AEC-779          | 1             | 13              | 201811 | 2              | 0             | 1442.00      | 1442.00              | 0.00                | 0.00                   | 0.00                        | 1442.00          | ?            | ?           |
    | AEC-779          | 1             | 14              | 201811 | 2              | 0             | 625.00       | 625.00               | 0.00                | 0.00                   | 0.00                        | 625.00           | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201812 | 2              | 0             | 3095.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 473.28      |
    | AEC-779          | 1             | 3               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1107.73     |
    | AEC-779          | 1             | 4               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1376.10     |
    | AEC-779          | 1             | 5               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 268.41      |
    | AEC-779          | 1             | 6               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1261.69     |
    | AEC-779          | 1             | 13              | 201812 | 2              | 0             | 2178.00      | 2178.00              | 0.00                | 0.00                   | 0.00                        | 2178.00          | ?            | ?           |
    | AEC-779          | 1             | 14              | 201812 | 2              | 0             | 917.00       | 917.00               | 0.00                | 0.00                   | 0.00                        | 917.00           | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201901 | 2              | 0             | 3713.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 983.68      |
    | AEC-779          | 1             | 3               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 974.74      |
    | AEC-779          | 1             | 4               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1342.95     |
    | AEC-779          | 1             | 5               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 176.70      |
    | AEC-779          | 1             | 6               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 972.76      |
    | AEC-779          | 1             | 13              | 201901 | 2              | 0             | 953.00       | 953.00               | 0.00                | 0.00                   | 0.00                        | 953.00           | ?            | ?           |
    | AEC-779          | 1             | 14              | 201901 | 2              | 0             | 2760.00      | 2760.00              | 0.00                | 0.00                   | 0.00                        | 2760.00          | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201902 | 2              | 0             | 2843.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1355.12     |
    | AEC-779          | 1             | 3               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 908.99      |
    | AEC-779          | 1             | 4               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1107.05     |
    | AEC-779          | 1             | 5               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1046.33     |
    | AEC-779          | 1             | 6               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1290.61     |
    | AEC-779          | 1             | 13              | 201902 | 2              | 0             | 928.00       | 928.00               | 0.00                | 0.00                   | 0.00                        | 928.00           | ?            | ?           |
    | AEC-779          | 1             | 14              | 201902 | 2              | 0             | 1915.00      | 1915.00              | 0.00                | 0.00                   | 0.00                        | 1915.00          | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201903 | 2              | 0             | 5452.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 983.91      |
    | AEC-779          | 1             | 3               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 188.10      |
    | AEC-779          | 1             | 4               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 635.72      |
    | AEC-779          | 1             | 5               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1174.71     |
    | AEC-779          | 1             | 6               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 124.71      |
    | AEC-779          | 1             | 13              | 201903 | 2              | 0             | 3720.00      | 3720.00              | 0.00                | 0.00                   | 0.00                        | 3720.00          | ?            | ?           |
    | AEC-779          | 1             | 14              | 201903 | 2              | 0             | 1732.00      | 1732.00              | 0.00                | 0.00                   | 0.00                        | 1732.00          | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201904 | 2              | 0             | 4044.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1136.32     |
    | AEC-779          | 1             | 3               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 229.12      |
    | AEC-779          | 1             | 4               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1030.40     |
    | AEC-779          | 1             | 5               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 799.97      |
    | AEC-779          | 1             | 6               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 133.55      |
    | AEC-779          | 1             | 13              | 201904 | 2              | 0             | 2747.00      | 2747.00              | 0.00                | 0.00                   | 0.00                        | 2747.00          | ?            | ?           |
    | AEC-779          | 1             | 14              | 201904 | 2              | 0             | 1297.00      | 1297.00              | 0.00                | 0.00                   | 0.00                        | 1297.00          | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201905 | 2              | 0             | 3585.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 518.40      |
    | AEC-779          | 1             | 3               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 269.54      |
    | AEC-779          | 1             | 4               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 311.60      |
    | AEC-779          | 1             | 5               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 461.50      |
    | AEC-779          | 1             | 6               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 496.03      |
    | AEC-779          | 1             | 13              | 201905 | 2              | 0             | 983.00       | 983.00               | 0.00                | 0.00                   | 0.00                        | 983.00           | ?            | ?           |
    | AEC-779          | 1             | 14              | 201905 | 2              | 0             | 2602.00      | 2602.00              | 0.00                | 0.00                   | 0.00                        | 2602.00          | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201906 | 2              | 0             | 4963.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 3               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 4               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 5               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 6               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 13              | 201906 | 2              | 0             | 2574.00      | 2574.00              | 0.00                | 0.00                   | 0.00                        | 2574.00          | ?            | ?           |
    | AEC-779          | 1             | 14              | 201906 | 2              | 0             | 2389.00      | 2389.00              | 0.00                | 0.00                   | 0.00                        | 2389.00          | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201907 | 2              | 0             | 3777.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 3               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 4               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 5               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 6               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 13              | 201907 | 2              | 0             | 3468.00      | 3468.00              | 0.00                | 0.00                   | 0.00                        | 3468.00          | ?            | ?           |
    | AEC-779          | 1             | 14              | 201907 | 2              | 0             | 309.00       | 309.00               | 0.00                | 0.00                   | 0.00                        | 309.00           | ?            | ?           |




    # Confirm the Termination

    # Change the date
    Given the override date is '15/06/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'MAIN-779' for provider '10017779' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'MAIN-779' for provider '10017779'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017779 - 10017779 Co Ltd      | MAIN-779       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'MAIN-779' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Acquisition in progress          |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017779 | MAIN-779       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017779 | ESFA-779       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the CM feed for the presence of an ItemType 4 (Termination Initiation) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number 'MAIN-779'
    And   the ItemType '4' event for version '1' of actual contract number 'MAIN-779' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017779 | MAIN-779       | 1               | 0                  | 25/04/2019              | Notice from Agency        | AEC-779         | 06/04/2019            | 25/04/2019                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017779 | MAIN-779       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract MAIN-779:1.0 was placed under termination     |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017779 | MAIN-779       | 1               | 0                  | 25/04/2019              | Notice from Agency        | AEC-779         | 06/04/2019            | 25/04/2019                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017779 | MAIN-779       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract MAIN-779:1.0 was placed under termination     |




    # Consume actuals AFTER the Termination is confirmed and AFTER the Termination date

    # Change the date
    Given the override date is '04/07/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017779'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for June 2019
    And   the following closed collections are available in DCFS 

    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201808 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 682.52      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201808 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 1212.48     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201808 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 1314.42     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201808 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 745.69      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201808 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 1403.14     |
    #
    | ILR1819        | R11                  | ORG0017779     | CM             | 201809 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 1089.46     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201809 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 117.02      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201809 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 987.22      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201809 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 1280.46     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201809 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 1401.79     |
    #
    | ILR1819        | R11                  | ORG0017779     | CM             | 201810 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 1097.19     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201810 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 1045.32     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201810 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 860.42      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201810 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 949.15      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201810 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 943.32      |
    #
    | ILR1819        | R11                  | ORG0017779     | CM             | 201811 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 792.23      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201811 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 1313.77     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201811 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 856.84      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201811 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 567.07      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201811 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 1430.50     |
    #
    | ILR1819        | R11                  | ORG0017779     | CM             | 201812 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 1220.41     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201812 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 222.59      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201812 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 1362.72     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201812 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 1314.78     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201812 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 703.83      |
    #
    | ILR1819        | R11                  | ORG0017779     | CM             | 201901 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 513.50      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201901 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 416.53      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201901 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 523.78      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201901 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 315.43      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201901 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 512.83      |
    #
    | ILR1819        | R11                  | ORG0017779     | CM             | 201902 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 1466.16     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201902 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 182.11      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201902 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 268.91      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201902 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 1416.97     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201902 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 1009.95     |
    #
    | ILR1819        | R11                  | ORG0017779     | CM             | 201903 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 732.13      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201903 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 1424.69     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201903 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 1082.24     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201903 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 1366.42     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201903 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 555.85      |
    #
    | ILR1819        | R11                  | ORG0017779     | CM             | 201904 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 1024.17     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201904 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 1221.83     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201904 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 283.53      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201904 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 546.83      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201904 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 1374.24     |
    #
    | ILR1819        | R11                  | ORG0017779     | CM             | 201905 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 952.62      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201905 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 498.16      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201905 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 631.99      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201905 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 681.58      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201905 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 492.06      |
    #
    | ILR1819        | R11                  | ORG0017779     | CM             | 201906 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 1445.40     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201906 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 843.57      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201906 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 1037.05     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201906 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 1005.10     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201906 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 1117.95     |
    #
    | ILR1819        | R11                  | ORG0017779     | CM             | 201907 | AEBC1819                | AEC-779                  | ?          | 2               | 0            | 1340.91     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201907 | AEBC1819                | AEC-779                  | ?          | 3               | 0            | 1350.06     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201907 | AEBC1819                | AEC-779                  | ?          | 4               | 0            | 601.00      |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201907 | AEBC1819                | AEC-779                  | ?          | 5               | 0            | 1075.52     |
    | ILR1819        | R11                  | ORG0017779     | CM             | 201907 | AEBC1819                | AEC-779                  | ?          | 6               | 0            | 1382.41     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



   # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-779       | AEC-779         | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-779       | AEC-779         | 2               | 8617.77  | 682.52   | 1089.46  | 1097.19  | 792.23   | 1220.41  | 513.50   | 1466.16  | 732.13   | 1024.17  | 0.00     | ?        | ?        | 
    | MAIN-779       | AEC-779         | 3               | 7156.34  | 1212.48  | 117.02   | 1045.32  | 1313.77  | 222.59   | 416.53   | 182.11   | 1424.69  | 1221.83  | 0.00     | ?        | ?        | 
    | MAIN-779       | AEC-779         | 4               | 7540.08  | 1314.42  | 987.22   | 860.42   | 856.84   | 1362.72  | 523.78   | 268.91   | 1082.24  | 283.53   | 0.00     | ?        | ?        | 
    | MAIN-779       | AEC-779         | 5               | 8502.80  | 745.69   | 1280.46  | 949.15   | 567.07   | 1314.78  | 315.43   | 1416.97  | 1366.42  | 546.83   | 0.00     | ?        | ?        | 
    | MAIN-779       | AEC-779         | 6               | 9335.45  | 1403.14  | 1401.79  | 943.32   | 1430.50  | 703.83   | 512.83   | 1009.95  | 555.85   | 1374.24  | 0.00     | ?        | ?        | 
    | MAIN-779       | AEC-779         | 13              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-779       | AEC-779         | 14              | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | AEC-779          | 1             | 1               | 201808 | 2              | 0             | 3506.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 682.52      |
    | AEC-779          | 1             | 3               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1212.48     |
    | AEC-779          | 1             | 4               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1314.42     |
    | AEC-779          | 1             | 5               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 745.69      |
    | AEC-779          | 1             | 6               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1403.14     |
    | AEC-779          | 1             | 13              | 201808 | 2              | 0             | 1798.00      | 1798.00              | 0.00                | 0.00                   | 0.00                        | 1798.00          | ?            | ?           |
    | AEC-779          | 1             | 14              | 201808 | 2              | 0             | 1708.00      | 1708.00              | 0.00                | 0.00                   | 0.00                        | 1708.00          | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201809 | 2              | 0             | 1499.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1089.46     |
    | AEC-779          | 1             | 3               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 117.02      |
    | AEC-779          | 1             | 4               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 987.22      |
    | AEC-779          | 1             | 5               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1280.46     |
    | AEC-779          | 1             | 6               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1401.79     |
    | AEC-779          | 1             | 13              | 201809 | 2              | 0             | 1111.00      | 1111.00              | 0.00                | 0.00                   | 0.00                        | 1111.00          | ?            | ?           |
    | AEC-779          | 1             | 14              | 201809 | 2              | 0             | 388.00       | 388.00               | 0.00                | 0.00                   | 0.00                        | 388.00           | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201810 | 2              | 0             | 2083.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1097.19     |
    | AEC-779          | 1             | 3               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1045.32     |
    | AEC-779          | 1             | 4               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 860.42      |
    | AEC-779          | 1             | 5               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 949.15      |
    | AEC-779          | 1             | 6               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 943.32      |
    | AEC-779          | 1             | 13              | 201810 | 2              | 0             | 454.00       | 454.00               | 0.00                | 0.00                   | 0.00                        | 454.00           | ?            | ?           |
    | AEC-779          | 1             | 14              | 201810 | 2              | 0             | 1629.00      | 1629.00              | 0.00                | 0.00                   | 0.00                        | 1629.00          | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201811 | 2              | 0             | 2067.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 792.23      |
    | AEC-779          | 1             | 3               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1313.77     |
    | AEC-779          | 1             | 4               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 856.84      |
    | AEC-779          | 1             | 5               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 567.07      |
    | AEC-779          | 1             | 6               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1430.50     |
    | AEC-779          | 1             | 13              | 201811 | 2              | 0             | 1442.00      | 1442.00              | 0.00                | 0.00                   | 0.00                        | 1442.00          | ?            | ?           |
    | AEC-779          | 1             | 14              | 201811 | 2              | 0             | 625.00       | 625.00               | 0.00                | 0.00                   | 0.00                        | 625.00           | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201812 | 2              | 0             | 3095.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1220.41     |
    | AEC-779          | 1             | 3               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 222.59      |
    | AEC-779          | 1             | 4               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1362.72     |
    | AEC-779          | 1             | 5               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1314.78     |
    | AEC-779          | 1             | 6               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 703.83      |
    | AEC-779          | 1             | 13              | 201812 | 2              | 0             | 2178.00      | 2178.00              | 0.00                | 0.00                   | 0.00                        | 2178.00          | ?            | ?           |
    | AEC-779          | 1             | 14              | 201812 | 2              | 0             | 917.00       | 917.00               | 0.00                | 0.00                   | 0.00                        | 917.00           | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201901 | 2              | 0             | 3713.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 513.50      |
    | AEC-779          | 1             | 3               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 416.53      |
    | AEC-779          | 1             | 4               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 523.78      |
    | AEC-779          | 1             | 5               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 315.43      |
    | AEC-779          | 1             | 6               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 512.83      |
    | AEC-779          | 1             | 13              | 201901 | 2              | 0             | 953.00       | 953.00               | 0.00                | 0.00                   | 0.00                        | 953.00           | ?            | ?           |
    | AEC-779          | 1             | 14              | 201901 | 2              | 0             | 2760.00      | 2760.00              | 0.00                | 0.00                   | 0.00                        | 2760.00          | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201902 | 2              | 0             | 2843.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1466.16     |
    | AEC-779          | 1             | 3               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 182.11      |
    | AEC-779          | 1             | 4               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 268.91      |
    | AEC-779          | 1             | 5               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1416.97     |
    | AEC-779          | 1             | 6               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1009.95     |
    | AEC-779          | 1             | 13              | 201902 | 2              | 0             | 928.00       | 928.00               | 0.00                | 0.00                   | 0.00                        | 928.00           | ?            | ?           |
    | AEC-779          | 1             | 14              | 201902 | 2              | 0             | 1915.00      | 1915.00              | 0.00                | 0.00                   | 0.00                        | 1915.00          | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201903 | 2              | 0             | 5452.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 732.13      |
    | AEC-779          | 1             | 3               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1424.69     |
    | AEC-779          | 1             | 4               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1082.24     |
    | AEC-779          | 1             | 5               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1366.42     |
    | AEC-779          | 1             | 6               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 555.85      |
    | AEC-779          | 1             | 13              | 201903 | 2              | 0             | 3720.00      | 3720.00              | 0.00                | 0.00                   | 0.00                        | 3720.00          | ?            | ?           |
    | AEC-779          | 1             | 14              | 201903 | 2              | 0             | 1732.00      | 1732.00              | 0.00                | 0.00                   | 0.00                        | 1732.00          | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201904 | 2              | 0             | 4044.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1024.17     |
    | AEC-779          | 1             | 3               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1221.83     |
    | AEC-779          | 1             | 4               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 283.53      |
    | AEC-779          | 1             | 5               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 546.83      |
    | AEC-779          | 1             | 6               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1374.24     |
    | AEC-779          | 1             | 13              | 201904 | 2              | 0             | 2747.00      | 2747.00              | 0.00                | 0.00                   | 0.00                        | 2747.00          | ?            | ?           |
    | AEC-779          | 1             | 14              | 201904 | 2              | 0             | 1297.00      | 1297.00              | 0.00                | 0.00                   | 0.00                        | 1297.00          | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201905 | 2              | 0             | 3585.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | AEC-779          | 1             | 3               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | AEC-779          | 1             | 4               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | AEC-779          | 1             | 5               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | AEC-779          | 1             | 6               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | AEC-779          | 1             | 13              | 201905 | 2              | 0             | 983.00       | 983.00               | 0.00                | 0.00                   | 0.00                        | 983.00           | ?            | ?           |
    | AEC-779          | 1             | 14              | 201905 | 2              | 0             | 2602.00      | 2602.00              | 0.00                | 0.00                   | 0.00                        | 2602.00          | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201906 | 2              | 0             | 4963.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 3               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 4               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 5               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 6               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 13              | 201906 | 2              | 0             | 2574.00      | 2574.00              | 0.00                | 0.00                   | 0.00                        | 2574.00          | ?            | ?           |
    | AEC-779          | 1             | 14              | 201906 | 2              | 0             | 2389.00      | 2389.00              | 0.00                | 0.00                   | 0.00                        | 2389.00          | ?            | ?           |
    #
    | AEC-779          | 1             | 1               | 201907 | 2              | 0             | 3777.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 2               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 3               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 4               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 5               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 6               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-779          | 1             | 13              | 201907 | 2              | 0             | 3468.00      | 3468.00              | 0.00                | 0.00                   | 0.00                        | 3468.00          | ?            | ?           |
    | AEC-779          | 1             | 14              | 201907 | 2              | 0             | 309.00       | 309.00               | 0.00                | 0.00                   | 0.00                        | 309.00           | ?            | ?           |

	# Tidy up
	And   the override date is reset
	    
