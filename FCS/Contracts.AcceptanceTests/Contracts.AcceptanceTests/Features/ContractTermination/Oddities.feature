Feature: Oddities

@AcceptanceTest @Withdrawn20221103
Scenario: A480 Attempt to terminate a 1516 Age contract mid-contract but after the activity close date. Contract has payments
    Given there are no allocations marked as Under Termination for UKPRN '10017480' 
    And   there are no terminated or closed allocations for UKPRN '10017480' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017480' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AGE-480       |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017480' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017480 Co Ltd' with UKPRN '10017480' and OrgId 'ORG0017480' and has 'FCS1 Test' as a manager 
    And   UPIN '117480' is associated with UKPRN '10017480' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017480 | 117480 | 10017480 Co Ltd | 0              | Active | Yes           | AA017480      | ?             | 




    # Change the date
    And   the override date is '01/03/2015'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017480 | 10017480 Co Ltd      | ESFA-480             | EMPAGE-480     | 1                     | 01/04/2015        | 31/03/2016      | 51127.00      |                                | Contract for Services | 1516   | New          | ORG0017480 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017480 | EMPAGE-480     | AGE-480       | AGE               | AGE1516                 | FY                      | 01/04/2015          | 31/03/2016        | 51127.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017480 | EMPAGE-480     | AGE-480       | 1               | 0                     | 27495.00  | 2649.00  | 2752.00  | 3424.00  | 425.00   | 55.00    | 2150.00  | 3266.00  | 900.00   | 2332.00  | 3701.00  | 3296.00  | 2545.00  | 16-18 Apprenticeship Grant for Employers                        | New          |             |
    | 10017480 | EMPAGE-480     | AGE-480       | 2               | 0                     | 23632.00  | 3288.00  | 229.00   | 268.00   | 150.00   | 505.00   | 3139.00  | 2640.00  | 3154.00  | 1612.00  | 2537.00  | 2482.00  | 3628.00  | 19-24 Apprenticeship Grant for Employers                        | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EMPAGE-480' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-480' and actual ContractNumber 'EMPAGE-480'

    # Check that the contract is now approved
    Then  the latest version of contract 'EMPAGE-480' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017480 | EMPAGE-480         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2015        | 31/03/2016      | ?             |
    | 10017480 | ESFA-480           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2015        | 31/03/2016      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'EMPAGE-480'




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/01/2016'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017480'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Jan 2000
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode   | DeliverableCode | ActualVolume | ActualValue |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201504 | AGE1516                 | EMPAGE-480               |           | 1               | 0            | 1052.82     |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201504 | AGE1516                 | EMPAGE-480               |           | 2               | 0            | 493.12      |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201505 | AGE1516                 | EMPAGE-480               |           | 1               | 0            | 1422.90     |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201505 | AGE1516                 | EMPAGE-480               |           | 2               | 0            | 794.00      |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201506 | AGE1516                 | EMPAGE-480               |           | 1               | 0            | 661.95      |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201506 | AGE1516                 | EMPAGE-480               |           | 2               | 0            | 726.82      |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201507 | AGE1516                 | EMPAGE-480               |           | 1               | 0            | 1088.56     |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201507 | AGE1516                 | EMPAGE-480               |           | 2               | 0            | 1046.75     |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201508 | AGE1516                 | EMPAGE-480               |           | 1               | 0            | 1104.43     |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201508 | AGE1516                 | EMPAGE-480               |           | 2               | 0            | 347.18      |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201509 | AGE1516                 | EMPAGE-480               |           | 1               | 0            | 1134.06     |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201509 | AGE1516                 | EMPAGE-480               |           | 2               | 0            | 340.49      |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201510 | AGE1516                 | EMPAGE-480               |           | 1               | 0            | 1082.54     |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201510 | AGE1516                 | EMPAGE-480               |           | 2               | 0            | 184.87      |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201511 | AGE1516                 | EMPAGE-480               |           | 1               | 0            | 1254.93     |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201511 | AGE1516                 | EMPAGE-480               |           | 2               | 0            | 1426.09     |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201512 | AGE1516                 | EMPAGE-480               |           | 1               | 0            | 831.18      |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201512 | AGE1516                 | EMPAGE-480               |           | 2               | 0            | 672.69      |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201601 | AGE1516                 | EMPAGE-480               |           | 1               | 0            | 940.26      |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201601 | AGE1516                 | EMPAGE-480               |           | 2               | 0            | 673.73      |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201602 | AGE1516                 | EMPAGE-480               |           | 1               | 0            | 127.24      |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201602 | AGE1516                 | EMPAGE-480               |           | 2               | 0            | 817.45      |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201603 | AGE1516                 | EMPAGE-480               |           | 1               | 0            | 1157.10     |
    | AGE1516        | G09                  | ORG0017480     | CM             | 201603 | AGE1516                 | EMPAGE-480               |           | 2               | 0            | 1219.85     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



    # Check CRM

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   |
    | EMPAGE-480     | AGE-480         | 1               | 9633.37  | 1052.82  | 1422.90  | 661.95   | 1088.56  | 1104.43  | 1134.06  | 1082.54  | 1254.93  | 831.18   | ?        | ?        | ?        | 
    | EMPAGE-480     | AGE-480         | 2               | 6032.01  | 493.12   | 794.00   | 726.82   | 1046.75  | 347.18   | 340.49   | 184.87   | 1426.09  | 672.69   | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   |
    | EMPAGE-480     | AGE-480         | 1               | 9633.37  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 9633.37  | ?        | ?        | ?        | 
    | EMPAGE-480     | AGE-480         | 2               | 6032.01  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6032.01  | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   |
    | EMPAGE-480     | AGE-480         | 1               | 9633.37  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 9633.37  | ?        | ?        | ?        | 
    | EMPAGE-480     | AGE-480         | 2               | 6032.01  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6032.01  | ?        | ?        | ?        | 

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'EMPAGE-480'




    # Initiate a TERMINATION

    # Change the date (Activity Close Date = 18/06/2017)
    Given the override date is '14/07/2017'

    # Request termination of the contract 
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'EMPAGE-480' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 16/09/2015               | 16/09/2015              | No                          | Provider in Liquidation | Company sold            |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | AGE-480          | 16/09/2015                  | 16/09/2015                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'EMPAGE-480' for UKPRN '10017480'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017480 - 10017480 Co Ltd     | EMPAGE-480     | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017480 | EMPAGE-480          | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/04/2015        | 31/03/2016      | ?             |
    | 10017480 | ESFA-480            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/04/2015        | 31/03/2016      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | EMPAGE-480     | 1                     | 0                        | 16/09/2015              | Company sold            |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | AGE-480          | 1                     | 0                        | 16/09/2015        | 16/09/2015                |

    
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'EMPAGE-480' for provider '10017480'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017480 - 10017480 Co Ltd     | EMPAGE-480     | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'EMPAGE-480' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | Company sold                     |




    # Approve the Termination Initiation

    # Change the date (Activity Close Date = 18/06/2017)
    Given the override date is '17/07/2017'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'EMPAGE-480' for provider '10017480' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'EMPAGE-480' for provider '10017480'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017480 - 10017480 Co Ltd      | EMPAGE-480     | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'EMPAGE-480' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Company sold                     |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017480 | EMPAGE-480          | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/04/2015        | 31/03/2016      | ?             |
    | 10017480 | ESFA-480            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/04/2015        | 31/03/2016      | ?             |




	# Check CRM

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   |
    | EMPAGE-480     | AGE-480         | 1               | 9633.37  | 1052.82  | 1422.90  | 661.95   | 1088.56  | 1104.43  | 1134.06  | 1082.54  | 1254.93  | 831.18   | ?        | ?        | ?        | 
    | EMPAGE-480     | AGE-480         | 2               | 6032.01  | 493.12   | 794.00   | 726.82   | 1046.75  | 347.18   | 340.49   | 184.87   | 1426.09  | 672.69   | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   |
    | EMPAGE-480     | AGE-480         | 1               | 9633.37  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 9633.37  | ?        | ?        | ?        | 
    | EMPAGE-480     | AGE-480         | 2               | 6032.01  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6032.01  | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   |
    | EMPAGE-480     | AGE-480         | 1               | 9633.37  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 9633.37  | ?        | ?        | ?        | 
    | EMPAGE-480     | AGE-480         | 2               | 6032.01  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6032.01  | ?        | ?        | ?        | 

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'EMPAGE-480'




	# Tidy up
	And the override date is reset
