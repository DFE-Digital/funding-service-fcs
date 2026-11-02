Feature: TerminateContract 23893

@AcceptanceTest @Withdrawn20231002 
Scenario: A750 Create and approve an 1819 AEB contract with an AEB-CL1819 (PoP) allocation. Initiate termination (without amendment) then approve the initiation by completing the open task. Fail to confirm termination (outstanding PoP payments)
    Given there are no allocations marked as Under Termination for UKPRN '10017750' 
	And   there are no terminated or closed allocations for UKPRN '10017750'
    And   there is no Contract, Task or Workflow data for UKPRN '10017750' 
	And   there are no notifications of type 'Contract Termination Failed'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBC-750      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017750' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017750 Co Ltd' with UKPRN '10017750' and OrgId 'ORG0017750' and has 'FCS1 Test' as a manager 
    And   UPIN '117750' is associated with UKPRN '10017750' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017750 | 117750 | 10017750 Co Ltd | 0              | Active | Yes           | AA017750      | ?             | 




    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017750 | 10017750 Co Ltd      | ESFA-750             | AEBP-750       | 1                     | 01/08/2018        | 31/07/2019      | 25552.00      |                                | Contract for Services | 1819   | New          | ORG0017750 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017750 | AEBP-750       | AEBC-750      | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 25552.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017750 | AEBP-750       | AEBC-750      | 1               | 0                     | 25552.00  | 2681.00  | 1994.00  | 1337.00  | 2325.00  | 3062.00  | 1836.00  | 1812.00  | 902.00   | 3630.00  | 1866.00  | 3457.00  | 650.00   | Adult Education Budget - Community Learning                     | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-750' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

	# Set PaymentGeneration.PaymentTimetable to NotStarted for one period (This steps starts off by setting everything for the FSP to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB-CL1819                 | 201907               |                      | A              | NotStarted |

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-750' and actual ContractNumber 'AEBP-750'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-750' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017750 | AEBP-750           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017750 | ESFA-750           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'AEBP-750'




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '24/08/2019'

    # Request termination of the contract via the CRM SDK
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'AEBP-750' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 26/09/2018               | 11/10/2018              | No                          | Provider in Liquidation | Police involvement      |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | AEBC-750         | 29/08/2018                  | 13/09/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'AEBP-750' for UKPRN '10017750'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017750 - 10017750 Co Ltd     | AEBP-750       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017750 | AEBP-750       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017750 | ESFA-750       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | AEBP-750       | 1                     | 0                        | 11/10/2018              | Police involvement      |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | AEBC-750         | 1                     | 0                        | 29/08/2018        | 13/09/2018                |

    
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'AEBP-750' for provider '10017750'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017750 - 10017750 Co Ltd     | AEBP-750       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'AEBP-750' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | Police involvement               |




	# Approve the initiation

    # Change the date
    Given the override date is '27/08/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'AEBP-750' for provider '10017750' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'AEBP-750' for provider '10017750'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017750 - 10017750 Co Ltd      | AEBP-750       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'AEBP-750' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Police involvement               |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017750 | AEBP-750       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017750 | ESFA-750       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |



	# Check feed

    # Check the CM feed for the presence of an ItemType 4 (Contract Termination Initiated) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number 'AEBP-750'
    And   the ItemType '4' event for version '1' of actual contract number 'AEBP-750' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017750 | AEBP-750       | 1               | 0                  | 11/10/2018              | Provider in Liquidation   | AEBC-750        | 29/08/2018            | 13/09/2018                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017750 | AEBP-750       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract AEBP-750:1.0 was placed under termination     |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017750 | AEBP-750       | 1               | 0                  | 11/10/2018              | Provider in Liquidation   | AEBC-750        | 29/08/2018            | 13/09/2018                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017750 | AEBP-750       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract AEBP-750:1.0 was placed under termination     |




    # Manager attemps to CONFIRM termination while future PoP payments for AEB-CL1819 exist: FAIL termination

    # Change the current date to a date AFTER the termination date (This is ignored by CRM)
    Given the override date is '01/11/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination (23893)
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'AEBP-750' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract 'AEBP-750' Version '1' SubVersion '0' via SDK

    # Have 'Terminate Contract' and 'Contract Termination Failed' Workflow History entries been created ?
    Then  the workflow history on contract 'AEBP-750' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Contract Termination Failed                    | CRM Integration     | ?                                |
    | Terminate Contract                             | FCS8 Test           | ?                                |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Police involvement               |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017750 | AEBP-750       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017750 | ESFA-750       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check that a termination failure notification has been created
	And   there is '1' notification of type 'Contract Termination Failed' owned by user 'FCS8 Test' which matches the following
    | Status | NotificationName                        | NotificationText                                                                                                |
    | New    | Contract Termination Failed - AEBP-750  | Contract AEBP-750 v1 for provider 10017750 (10017750 Co Ltd) cannot be terminated - outstanding payments exist  |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Complete
Scenario: A768 Create and approve a Levy contract. Initiate termination (without amendment) then approve the initiation by completing the open task. Confirm termination. Check CRM and feed. Attempt bulk and non-financial amendments: Fail. Check RoATP Anomalies report.
    Given there are no allocations marked as Under Termination for UKPRN '10017768' 
	And   there are no terminated or closed allocations for UKPRN '10017768'
    And   there is no Contract, Task or Workflow data for UKPRN '10017768' 
	And   there are no notifications of type 'Non-Financial Contract Amendment Failed'
    And   there is no Levy event data in the DAS agreement stub
	And   the Contract Management atom feed is empty
	And   there are no entries in the ContractManagement.EngagementEvent table




    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017768' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017768 Co Ltd' with UKPRN '10017768' and OrgId 'ORG0017768' and has 'FCS1 Test' as a manager 
    And   UPIN '117768' is associated with UKPRN '10017768' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017768 | 117768 | 10017768 Co Ltd | 0              | Active | Yes           | AA017768      | ?             | 

    # Set RoATP data 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.
    And   the following providers exist on RoATP
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
    | 10017768 | 10017768 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    




    # Change the date 
    And   the override date is '16/05/2018'

    # Create dummy docs in Sharepoint
    And   a file with filename '10017768_APPLEVY-768_v1.pdf' is created in 'LEVY-1799-Input-Appendices'
    And   a file with filename '10017768_APPLEVY-768_v1.pdf' is created in 'LEVY-1799-Output-Documents for Publication'

    # Inject data into the stub 
   #And   the following Levy event data is available in the DAS agreement stub 
    And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 7264  | INITIATED | 2017-09-15T18:03:12.2539 | 10017768   | 72893             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017768'
    And   there is only one Levy contract in CRM for UKPRN '10017768' with a status of 'Draft'

    # Publish the contract (This is needed because the injection step above leaves the contract in the wrong state)
    Given the latest version of contract 'APPLEVY-768' is in a state of 'Published to Provider'





    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017768 | 10017768 Co Ltd      | LEVY        | ESFA-768             | APPLEVY-768    | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017768 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017768 | LEVY              | LEVY1799                | APPLEVY-768    | LEVY-768            | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017768 | LEVY              | LEVY-768            | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017768 | LEVY              | LEVY-768            | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 

    # Check deliverable period count 
    And   there are '2' deliverable period rows in CRM linked to the latest version of contract number 'APPLEVY-768' 

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017768 | APPLEVY-768        | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/05/2017        | ?               | ?             |
    | 10017768 | ESFA-768           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |




    # Change the date
    Given the override date is '01/08/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-768' and ContractNumber 'APPLEVY-768' and Version '1'

    # Check the deliverable count in CRM
    Then  there are '14' deliverable period rows in CRM linked to the latest version of contract number 'APPLEVY-768'

    # After approval there should be a Aug-19 deliverable period for each of deliverables 1 through 14 for each allocation 
    Then   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Aug-19   | DeliverableDescription                               | 
    | 10017775 | LEVY              | LEVY-768            | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017775 | LEVY              | LEVY-768            | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017775 | LEVY              | LEVY-768            | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017775 | LEVY              | LEVY-768            | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017775 | LEVY              | LEVY-768            | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017775 | LEVY              | LEVY-768            | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017775 | LEVY              | LEVY-768            | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017775 | LEVY              | LEVY-768            | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017775 | LEVY              | LEVY-768            | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017775 | LEVY              | LEVY-768            | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017775 | LEVY              | LEVY-768            | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017775 | LEVY              | LEVY-768            | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017775 | LEVY              | LEVY-768            | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017775 | LEVY              | LEVY-768            | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 

    # Check version and status values in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017768 | APPLEVY-768        | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/08/2019        | ?               | ?             |
    | 10017768 | ESFA-768           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |




    # Initiate a TERMINATION then approve the initiation

    # Change the date
    Given the override date is '01/10/2019'

    # Request termination of the contract via the CRM SDK
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'APPLEVY-768' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | TerminationReason       | TerminationComments     |
    | 03/10/2019               | 18/10/2019              | Provider in Liquidation | Suspected fraud         |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | LEVY-768         | 03/10/2019                  | 18/10/2019                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'APPLEVY-768' for UKPRN '10017768'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017768 - 10017768 Co Ltd     | APPLEVY-768    | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017768 | APPLEVY-768        | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2019        | ?               | ?             |
    | 10017768 | ESFA-768           | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | APPLEVY-768    | 1                     | 0                        | 18/10/2019              | Suspected fraud         |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | LEVY-768         | 1                     | 0                        | 03/10/2019        | 18/10/2019                |

    
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017768'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017768 - 10017768 Co Ltd     | [ContractNo]   | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract '[ContractNo]' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected fraud                  |




    # Change the date
    Given the override date is '04/10/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'APPLEVY-768' for provider '10017768' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'APPLEVY-768' for provider '10017768'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017768 - 10017768 Co Ltd      | APPLEVY-768    | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'APPLEVY-768' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected fraud                  |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017768 | APPLEVY-768        | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2019        | ?               | ?             |
    | 10017768 | ESFA-768           | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the CM feed for the presence of an ItemType 4 (Termination) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number 'APPLEVY-768'
    And   the ItemType '4' event for version '1' of actual contract number 'APPLEVY-768' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber     | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017768 | APPLEVY-768        | 1               | 0                  | 18/10/2019              | Provider in Liquidation   | LEVY-768        | 03/10/2019            | 18/10/2019                |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber     | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017768 | APPLEVY-768        | 1               | 0                  | 18/10/2019              | Provider in Liquidation   | LEVY-768        | 03/10/2019            | 18/10/2019                |




	# Complete the Termination

	# Change the date
    Given the override date is '24/12/2019'

	# Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination (23893)
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'APPLEVY-768' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract 'APPLEVY-768' Version '1' SubVersion '0' via SDK

    # Has a 'Terminate Contract' Workflow History entry been created ?
    Then  the workflow history on contract 'APPLEVY-768' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Terminate Contract                             | FCS8 Test           | ?                                |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected fraud                  |

    # Check the CM feed for the presence of an ItemType 6 (Contract Terminated) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '6' event for version '1' of actual contract number 'APPLEVY-768'
    And   the ItemType '6' event for version '1' of contract number 'APPLEVY-768' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Terminated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017768 | APPLEVY-768    | 1               | 0                  | 18/10/2019              | Provider in Liquidation   | LEVY-768        | 03/10/2019            | 18/10/2019                |

    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm        | CategoryLabel                | Title                                        |
    | 10017768 | APPLEVY-768    | 1               | 0                  | Contract Terminated | Contract has been terminated | Contract APPLEVY-768:1.0 has been terminated |


    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Terminated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017768 | APPLEVY-768    | 1               | 0                  | 18/10/2019              | Provider in Liquidation   | LEVY-768        | 03/10/2019            | 18/10/2019                |

    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm        | CategoryLabel                | Title                                         |
    | 10017768 | APPLEVY-768    | 1               | 0                  | Contract Terminated | Contract has been terminated | Contract APPLEVY-768:1.0 has been terminated  |


    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus    | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017768 | APPLEVY-768        | 1                     | 0                        | Closed         | Terminated           | True          | True                | 01/08/2019        | 18/10/2019      | ?             |
    | 10017768 | ESFA-768           | 1                     | 0                        | Draft          | ?                    | False         | False               | 01/05/2017        | ?               | ?             |

    # Has a 'Termination Cancellation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'APPLEVY-768' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Successful                         | CRM Integration     | ?                                |
    | Terminate Contract                             | FCS8 Test           | ?                                |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected fraud                  |




    # Attempt each of the Non-Financial amendments. They should fail (23976)

   #Given there are no notifications of type 'Non-Financial Contract Amendment Failed' 
    Given there are no notifications in CRM of type 'Non-Financial Contract Amendment Failed' for UKPRN '10017768'

    # Attempt a non-financial NOTIFICATION amendment request on v1 to create v2. This should fail
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'APPLEVY-768' for a non-financial NOTIFICATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus    | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017768 | APPLEVY-768        | 1                     | 0                        | Closed         | Terminated           | True          | True                | 01/08/2019        | 18/10/2019      | ?             |
    | 10017768 | ESFA-768           | 1                     | 0                        | Draft          | ?                    | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the WORKFLOW HISTORY for v1
    And   the workflow history on contract 'APPLEVY-768' version '1' includes the following
    | Action                                    | CompletedBy      | Comment      |
    | Initiate Non-Financial Amendment (Notify) | FCS2 Test        | ?            |
    | Non-Financial Amendment Initiation Failed | CRM Integration  | ?            |

    # Check that a NOTIFICATION has been created and sent to the initiating User 
	And   there is '1' notification of type 'Non-Financial Contract Amendment Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                                       | NotificationText                                                                                                                                           |
    | New    | Non-Financial Contract Amendment Failed - APPLEVY-768  | Contract APPLEVY-768 v1 for provider 10017768 (10017768 Co Ltd) cannot be amended - Non-financial amendments cannot be created for LEVY LEVY1799 contracts |



#   #Given there are no notifications of type 'Non-Financial Contract Amendment Failed' 
#    Given there are no notifications in CRM of type 'Non-Financial Contract Amendment Failed' for UKPRN '10017768'

    # Attempt a non-financial VARIATION amendment request on v1 to create v2. This should fail too
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'APPLEVY-768' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus    | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017768 | APPLEVY-768        | 1                     | 0                        | Closed         | Terminated           | True          | True                | 01/08/2019        | 18/10/2019      | ?             |
    | 10017768 | ESFA-768           | 1                     | 0                        | Draft          | ?                    | False         | False               | 01/05/2017        | ?               | ?             |
    
    # Check the WORKFLOW HISTORY for v1
    And   the workflow history on contract 'APPLEVY-768' version '1' includes the following
    | Action                                    | CompletedBy      | Comment      |
    | Initiate Non-Financial Amendment (Vary)   | FCS2 Test        | ?            |
    | Non-Financial Amendment Initiation Failed | CRM Integration  | ?            |

    # Check that a NOTIFICATION has been created and sent to the initiating User 
	And   there are '2' notifications of type 'Non-Financial Contract Amendment Failed' owned by user 'FCS2 Test' which match the following
    | Status | NotificationName                                       | NotificationText                                                                                                                                           |
    | New    | Non-Financial Contract Amendment Failed - APPLEVY-768  | Contract APPLEVY-768 v1 for provider 10017768 (10017768 Co Ltd) cannot be amended - Non-financial amendments cannot be created for LEVY LEVY1799 contracts |



	# Issue a contract amendment request on v1 to attempt to create v2 using the SINGLETON mechanism. This should fail
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status | SubStatus  | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017768 | ESFA-768             | APPLEVY-768    | 1       | Closed | Terminated | Variation     | No                       | Yes                          |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus    | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017768 | APPLEVY-768        | 1                     | 0                        | Closed         | Terminated           | True          | True                | 01/08/2019        | 18/10/2019      | ?             |
    | 10017768 | ESFA-768           | 1                     | 0                        | Draft          | ?                    | False         | False               | 01/05/2017        | ?               | ?             |


	# Issue a contract amendment request on v1 to attempt to create v2 using the BULK mechanism. This should fail
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status | SubStatus  | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017768 | ESFA-768             | APPLEVY-768    | 1       | Closed | Terminated | Variation     | No                       | Yes                   | Yes                          |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus    | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017768 | APPLEVY-768        | 1                     | 0                        | Closed         | Terminated           | True          | True                | 01/08/2019        | 18/10/2019      | ?             |
    | 10017768 | ESFA-768           | 1                     | 0                        | Draft          | ?                    | False         | False               | 01/05/2017        | ?               | ?             |
	 


    # This provider is on RoATP so shouldn't appear on the RoATP Anomalies report (24907)
    And   the RoATP Anomalies report does not contain a record for provider '10017768'

    # Remove the provider from RoATP
    Given there is no data on RoATP for the following providers
    | Ukprn    |
    | 10017768 |

#    # Check the RoATP Anomalies report for an entry for this contract
#    Then  the RoATP Anomalies report includes the following
#    | Contract     | MasterContract     | Ukprn    | Version  | SubVersion  | Status           | Substatus              |
#    | [ContractNo] | [MasterContractNo] | 10017768 | 1        | 0           | Closed           | Terminated             |

    # Now the provider has been removed from RoATP it shouldn't appear on the RoATP Anomalies report 
    Then the RoATP Anomalies report does not contain a record for provider '10017768'



    # Tidy up
    Given there are no notifications of type 'Approval Received'
    And   the override date is reset

@AcceptanceTest @Withdrawn20200604
Scenario: A770 Create and approve a 1920 AEB contract with just a PoA allocation. Initiate termination (without amendment) then approve the initiation by completing the open task. Check fail: future-dated termination
    Given there are no allocations marked as Under Termination for UKPRN '10017770'
    And   there are no terminated or closed allocations for UKPRN '10017770'
    And   there is no Contract, Task or Workflow data for UKPRN '10017770' 
    And   there are no notifications in CRM of type 'Contract Termination Failed' for UKPRN '10017770'
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBA-770      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017770' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017770 Co Ltd' with UKPRN '10017770' and OrgId 'ORG0017770' and has 'FCS1 Test' as a manager 
    And   UPIN '117770' is associated with UKPRN '10017770' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017770 | 117770 | 10017770 Co Ltd | 0              | Active | Yes           | AA017770      | ?             | 




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017770 | 10017770 Co Ltd      | ESFA-770             | AEBP-770       | 1                     | 01/08/2019        | 31/07/2020      | 26448.00      |                                | Contract for Services | 1920   | New          | ORG0017770 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017770 | AEBP-770       | AEBA-770      | AEB-AS            | AEB-AS1920              | AY                      | 01/08/2019          | 31/07/2020        | 26448.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription       | CRMIntent    | DeliveryOrg |
    | 10017770 | AEBP-770       | AEBA-770      | 1               | 0                     | 26448.00  | 1056.00  | 2297.00  | 1294.00  | 1585.00  | 3428.00  | 2583.00  | 2400.00  | 1966.00  | 3270.00  | 3058.00  | 977.00   | 2534.00  | Adult Skills Total Funding   | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-770' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-770' and actual ContractNumber 'AEBP-770'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-770' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017770 | AEBP-770           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017770 | ESFA-770           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'AEBP-770'




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '01/11/2019'

    # Request termination of the contract
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'AEBP-770' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 03/07/2020               | 30/07/2020              | No                          | Notice from Provider    | Suspected fraud         |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | AEBA-770         | 03/07/2020                  | 03/07/2020                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'AEBP-770' for UKPRN '10017770'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017770 - 10017770 Co Ltd     | AEBP-770       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017770 | AEBP-770       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017770 | ESFA-770       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | AEBP-770       | 1                     | 0                        | 30/07/2020              | Suspected fraud         |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | AEBA-770         | 1                     | 0                        | 03/07/2020        | 03/07/2020                |

    
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'AEBP-770' for provider '10017770'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017770 - 10017770 Co Ltd     | AEBP-770       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'AEBP-770' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected fraud                  |




    # Approve Termination Initiation

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'AEBP-770' for provider '10017770' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'AEBP-770' for provider '10017770'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017770 - 10017770 Co Ltd      | AEBP-770       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'AEBP-770' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected fraud                  |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017770 | AEBP-770       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017770 | ESFA-770       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the CM feed for the presence of an ItemType 4 (Termination) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number 'AEBP-770'
    And   the ItemType '4' event for version '1' of actual contract number 'AEBP-770' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017770 | AEBP-770       | 1               | 0                  | 30/07/2020              | Notice from Provider      | AEBA-770        | 03/07/2020            | 03/07/2020                |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017770 | AEBP-770       | 1               | 0                  | 30/07/2020              | Notice from Provider      | AEBA-770        | 03/07/2020            | 03/07/2020                |




    # Manager attempts to COMPLETE termination before the termination date (30/07/2020): FAIL

    # Change the date.  This currently has no effect on CRM which uses the actual current date - but this may change ...?
    Given the override date is '02/07/2020'

    And   the PaaS MonthEndIsRunning indicator is set to 'False'

	# Manager COMPLETES termination (23893)
    When  CRM user 'FCS8 Test' completes the termination request for Contract 'AEBP-770' Version '1' SubVersion '0' via UI
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'AEBP-770' Version '1' SubVersion '0' via SDK
	# Can't use the 'via SDK' option because .Net is not called for this type of failure so the Notification is still created.

    # Check CONTRACT version, status and dates in CRM. This should not have changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017770 | AEBP-770       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017770 | ESFA-770       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check that NOTIFICATION is not generated (25102)
    And   there are '0' notifications of type 'Contract Termination Failed' owned by user 'FCS8 Test' which match the following
    | Status | NotificationName                        | NotificationText                                                                                                                   |
    | New    | Contract Termination Failed - AEBP-770  | Contract AEBP-770 v1 for provider 10017770 (10017770 Co Ltd) cannot be terminated - Contract Termination Date must be in the past  |


    # Tidy up
    And   the override date is reset
	
@AcceptanceTest @Withdrawn20210702 
Scenario: A759 Create and approve an 1819 AEB contract with just a PoA allocation. Zoe to initiate termination (without amendment) then Helen to approve initiation by completing the open task. Fail: outstanding PoA payments. Fail: month-end running. Check CRM and notifications
    Given there are no allocations marked as Under Termination for UKPRN '10017759'
    And   there are no terminated or closed allocations for UKPRN '10017759'
    And   there is no Contract, Task or Workflow data for UKPRN '10017759' 
    And   there are no notifications in CRM of type 'Contract Termination Failed' for UKPRN '10017759'
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBT-759      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017759' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017759 Co Ltd' with UKPRN '10017759' and OrgId 'ORG0017759' and has 'FCS1 Test' as a manager 
    And   UPIN '117759' is associated with UKPRN '10017759' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017759 | 117759 | 10017759 Co Ltd | 0              | Active | Yes           | AA017759      | ?             | 




    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017759 | 10017759 Co Ltd      | ESFA-759             | AEBP-759       | 1                     | 01/08/2018        | 31/07/2019      | 26448.00      |                                | Contract for Services | 1819   | New          | ORG0017759 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017759 | AEBP-759       | AEBT-759      | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 26448.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017759 | AEBP-759       | AEBT-759      | 1               | 0                     | 26448.00  | 1056.00  | 2297.00  | 1294.00  | 1585.00  | 3428.00  | 2583.00  | 2400.00  | 1966.00  | 3270.00  | 3058.00  | 977.00   | 2534.00  | Adult Education - Traineeships and Other Learning Total Funding | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-759' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-759' and actual ContractNumber 'AEBP-759'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-759' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017759 | AEBP-759           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017759 | ESFA-759           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'AEBP-759'




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '01/11/2018'

    # Request termination of the contract via the CRM SDK
    When  CRM user 'FCS2 Test' initiates contract termination for Contract 'AEBP-759' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason          | TerminationComments     |
    | 03/10/2018               | 03/10/2018              | No                          | Provider in Administration | Suspected fraud         |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | AEBT-759         | 03/10/2018                  | 03/10/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'AEBP-759' for UKPRN '10017759'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017759 - 10017759 Co Ltd     | AEBP-759       | FCS1 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017759 | AEBP-759       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017759 | ESFA-759       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | AEBP-759       | 1                     | 0                        | 03/10/2018              | Suspected fraud         |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | AEBT-759         | 1                     | 0                        | 03/10/2018        | 03/10/2018                |

    
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'AEBP-759' for provider '10017759'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017759 - 10017759 Co Ltd     | AEBP-759       | FCS1 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'AEBP-759' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS2 Test           | Suspected fraud                  |




    # Approve Termination Initiation

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'AEBP-759' for provider '10017759' is triggered by User 'FCS1 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS1 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'AEBP-759' for provider '10017759'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017759 - 10017759 Co Ltd      | AEBP-759       | FCS1 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'AEBP-759' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS1 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS2 Test           | Suspected fraud                  |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017759 | AEBP-759       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017759 | ESFA-759       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the CM feed for the presence of an ItemType 4 (Termination) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number 'AEBP-759'
    And   the ItemType '4' event for version '1' of actual contract number 'AEBP-759' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason  | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017759 | AEBP-759       | 1               | 0                  | 03/10/2018              | Provider in Administration | AEBT-759        | 03/10/2018            | 03/10/2018                |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason  | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017759 | AEBP-759       | 1               | 0                  | 03/10/2018              | Provider in Administration | AEBT-759        | 03/10/2018            | 03/10/2018                |




    # Manager attemps to COMPLETE termination while month-end is running: FAIL

    # Change the date (termination date is 03/10/2018)
    Given the override date is '04/12/2018'

    And   the PaaS MonthEndIsRunning indicator is set to 'True'

	# Manager COMPLETES termination (23893)
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'AEBP-759' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract 'AEBP-759' Version '1' SubVersion '0' via SDK

    # Have 'Terminate Contract' and 'Contract Termination Failed' Workflow History entries been created ?
    Then  the workflow history on contract 'AEBP-759' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Contract Termination Failed                    | CRM Integration     | ?                                |
    | Terminate Contract                             | FCS8 Test           | ?                                |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS1 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS2 Test           | Suspected fraud                  |

    # Check CONTRACT version, status and dates in CRM. This should not have changed
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017759 | AEBP-759       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017759 | ESFA-759       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check that NOTIFICATION is being generated
    And   there is '1' notification of type 'Contract Termination Failed' owned by user 'FCS8 Test' which match the following
    | Status | NotificationName                        | NotificationText                                                                                                                                 |
    | New    | Contract Termination Failed - AEBP-759  | Contract AEBP-759 v1 for provider 10017759 (10017759 Co Ltd) cannot be terminated - month-end processing is in progress - please try again later |




    # Consume actuals 

    # Clear down the stub
    Given  there are no entries in the DCFS stub table

    # Pull actuals from DC for Nov 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201808 | AEB-TOL1819             | AEBT-759                 | ?          | 2               | 0            | 1693.13     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201808 | AEB-TOL1819             | AEBT-759                 | ?          | 3               | 0            | 435.07      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201808 | AEB-TOL1819             | AEBT-759                 | ?          | 4               | 0            | 2063.40     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201808 | AEB-TOL1819             | AEBT-759                 | ?          | 5               | 0            | 2265.96     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201808 | AEB-TOL1819             | AEBT-759                 | ?          | 6               | 0            | 2445.63     |
    #
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201809 | AEB-TOL1819             | AEBT-759                 | ?          | 2               | 0            | 1794.57     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201809 | AEB-TOL1819             | AEBT-759                 | ?          | 3               | 0            | 2133.93     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201809 | AEB-TOL1819             | AEBT-759                 | ?          | 4               | 0            | 2207.32     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201809 | AEB-TOL1819             | AEBT-759                 | ?          | 5               | 0            | 362.78      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201809 | AEB-TOL1819             | AEBT-759                 | ?          | 6               | 0            | 1019.47     |
    #
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201810 | AEB-TOL1819             | AEBT-759                 | ?          | 2               | 0            | 2130.12     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201810 | AEB-TOL1819             | AEBT-759                 | ?          | 3               | 0            | 206.03      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201810 | AEB-TOL1819             | AEBT-759                 | ?          | 4               | 0            | 1004.70     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201810 | AEB-TOL1819             | AEBT-759                 | ?          | 5               | 0            | 1379.45     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201810 | AEB-TOL1819             | AEBT-759                 | ?          | 6               | 0            | 1992.95     |
    #
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201811 | AEB-TOL1819             | AEBT-759                 | ?          | 2               | 0            | 789.22      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201811 | AEB-TOL1819             | AEBT-759                 | ?          | 3               | 0            | 1740.09     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201811 | AEB-TOL1819             | AEBT-759                 | ?          | 4               | 0            | 1918.41     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201811 | AEB-TOL1819             | AEBT-759                 | ?          | 5               | 0            | 2340.73     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201811 | AEB-TOL1819             | AEBT-759                 | ?          | 6               | 0            | 1651.96     |
    #
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201812 | AEB-TOL1819             | AEBT-759                 | ?          | 2               | 0            | 1233.74     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201812 | AEB-TOL1819             | AEBT-759                 | ?          | 3               | 0            | 191.95      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201812 | AEB-TOL1819             | AEBT-759                 | ?          | 4               | 0            | 1056.60     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201812 | AEB-TOL1819             | AEBT-759                 | ?          | 5               | 0            | 1494.76     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201812 | AEB-TOL1819             | AEBT-759                 | ?          | 6               | 0            | 2334.04     |
    #
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201901 | AEB-TOL1819             | AEBT-759                 | ?          | 2               | 0            | 404.93      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201901 | AEB-TOL1819             | AEBT-759                 | ?          | 3               | 0            | 2476.08     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201901 | AEB-TOL1819             | AEBT-759                 | ?          | 4               | 0            | 1261.15     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201901 | AEB-TOL1819             | AEBT-759                 | ?          | 5               | 0            | 1160.46     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201901 | AEB-TOL1819             | AEBT-759                 | ?          | 6               | 0            | 548.88      |
    #
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201902 | AEB-TOL1819             | AEBT-759                 | ?          | 2               | 0            | 774.48      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201902 | AEB-TOL1819             | AEBT-759                 | ?          | 3               | 0            | 1175.09     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201902 | AEB-TOL1819             | AEBT-759                 | ?          | 4               | 0            | 791.10      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201902 | AEB-TOL1819             | AEBT-759                 | ?          | 5               | 0            | 1739.59     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201902 | AEB-TOL1819             | AEBT-759                 | ?          | 6               | 0            | 2354.53     |
    #
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201903 | AEB-TOL1819             | AEBT-759                 | ?          | 2               | 0            | 778.52      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201903 | AEB-TOL1819             | AEBT-759                 | ?          | 3               | 0            | 1550.12     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201903 | AEB-TOL1819             | AEBT-759                 | ?          | 4               | 0            | 1354.53     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201903 | AEB-TOL1819             | AEBT-759                 | ?          | 5               | 0            | 833.71      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201903 | AEB-TOL1819             | AEBT-759                 | ?          | 6               | 0            | 1968.88     |
    #
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201904 | AEB-TOL1819             | AEBT-759                 | ?          | 2               | 0            | 1495.28     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201904 | AEB-TOL1819             | AEBT-759                 | ?          | 3               | 0            | 1170.43     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201904 | AEB-TOL1819             | AEBT-759                 | ?          | 4               | 0            | 631.93      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201904 | AEB-TOL1819             | AEBT-759                 | ?          | 5               | 0            | 636.52      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201904 | AEB-TOL1819             | AEBT-759                 | ?          | 6               | 0            | 2305.44     |
    #
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201905 | AEB-TOL1819             | AEBT-759                 | ?          | 2               | 0            | 1700.70     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201905 | AEB-TOL1819             | AEBT-759                 | ?          | 3               | 0            | 358.90      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201905 | AEB-TOL1819             | AEBT-759                 | ?          | 4               | 0            | 502.30      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201905 | AEB-TOL1819             | AEBT-759                 | ?          | 5               | 0            | 1368.04     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201905 | AEB-TOL1819             | AEBT-759                 | ?          | 6               | 0            | 1932.99     |
    #
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201906 | AEB-TOL1819             | AEBT-759                 | ?          | 2               | 0            | 801.67      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201906 | AEB-TOL1819             | AEBT-759                 | ?          | 3               | 0            | 1155.05     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201906 | AEB-TOL1819             | AEBT-759                 | ?          | 4               | 0            | 1266.64     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201906 | AEB-TOL1819             | AEBT-759                 | ?          | 5               | 0            | 2066.67     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201906 | AEB-TOL1819             | AEBT-759                 | ?          | 6               | 0            | 1512.15     |
    #
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201907 | AEB-TOL1819             | AEBT-759                 | ?          | 2               | 0            | 1089.04     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201907 | AEB-TOL1819             | AEBT-759                 | ?          | 3               | 0            | 668.38      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201907 | AEB-TOL1819             | AEBT-759                 | ?          | 4               | 0            | 2050.33     |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201907 | AEB-TOL1819             | AEBT-759                 | ?          | 5               | 0            | 394.58      |
    | AEB1819        | AEB04                | ORG0017759     | CM             | 201907 | AEB-TOL1819             | AEBT-759                 | ?          | 6               | 0            | 1341.53     |

    # Set PaymentGeneration.PaymentTimetable to NotStarted for one period (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB-TOL1819                | 201907               |                      | A              | NotStarted |
    
    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the RECONCILIATION subnominal aggregations in PaaS for November. The payment posted indicator should show that payments are outstanding, ie set FALSE
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017759 | ORG0017759 | AEBT-759          | 2355800         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 5617.82         |
    | 10017759 | ORG0017759 | AEBT-759          | 2355860         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 2775.03         |
    | 10017759 | ORG0017759 | AEBT-759          | 2355865         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 5275.42         |
    | 10017759 | ORG0017759 | AEBT-759          | 2372010         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 4008.19         |
    | 10017759 | ORG0017759 | AEBT-759          | 2372060         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | False       | 5458.05         |

    # Check the CAPPING subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017759 | ORG0017759 | AEBT-759          | 2355816         | AEB-TOL1819                | 201811               | CAPPING         | CM             | False       | -3855.39        |
    | 10017759 | ORG0017759 | AEBT-759          | 2372016         | AEB-TOL1819                | 201811               | CAPPING         | CM             | False       | -2670.12        |




    # Manager attemps to COMPLETE termination while PoA payments are outstanding: FAIL

    Given the PaaS MonthEndIsRunning indicator is set to 'False'

	# Manager COMPLETES termination (23893)
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'AEBP-759' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract 'AEBP-759' Version '1' SubVersion '0' via SDK

    # Have 'Terminate Contract' and 'Contract Termination Failed' Workflow History entries been created ?
    Then  the workflow history on contract 'AEBP-759' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Contract Termination Failed                    | CRM Integration     | ?                                |
    | Terminate Contract                             | FCS8 Test           | ?                                |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS1 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS2 Test           | Suspected fraud                  |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017759 | AEBP-759       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017759 | ESFA-759       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check that a termination failure notification has been created
	And   there is '1' notification of type 'Contract Termination Failed' owned by user 'FCS8 Test' which matches the following
    | Status | NotificationName                       | NotificationText                                                                                               |
    | New    | Contract Termination Failed - AEBP-759 | Contract AEBP-759 v1 for provider 10017759 (10017759 Co Ltd) cannot be terminated - outstanding payments exist |




    # Clear down the termination failure notification and associated workflow histories
    Given there are no notifications in CRM of type 'Contract Termination Failed' for UKPRN '10017759'

    And   the following workflow histories against version '1' of contract 'AEBP-759' are removed
    | Action                                         | CompletedBy         | Comment                          |
    | Contract Termination Failed                    | CRM Integration     | ?                                |
    | Terminate Contract                             | FCS1 Test           | ?                                |

    # Change the date
    Given the override date is '07/12/2018 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-TOL1819' AccountingPaymentPeriod '201808' CensusEndDate '07/12/2018' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaaS. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | AEBT-759                 | 201811 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB-TOL1819                | 201811               |                      | A              | NotStarted |

#    # Coda.AccountCode
#    And   the following configuration exists in the Account Codes table
#    | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#    | 10017759 | AEB-TOL1819                | CODB759   | 8115000      | 01/08/1990           | 31/08/2020         |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEB-TOL1819                | 201811               | Completed |

    # Check the RECONCILIATION subnominal aggregations in PaaS for November. The payment posted indicator should show that no payments are outstanding, ie set TRUE
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017759 | ORG0017759 | AEBT-759          | 2355800         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | True        | 5617.82         |
    | 10017759 | ORG0017759 | AEBT-759          | 2355860         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | True        | 2775.03         |
    | 10017759 | ORG0017759 | AEBT-759          | 2355865         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | True        | 5275.42         |
    | 10017759 | ORG0017759 | AEBT-759          | 2372010         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | True        | 4008.19         |
    | 10017759 | ORG0017759 | AEBT-759          | 2372060         | AEB-TOL1819                | 201811               | RECONCILIATION  | CM             | True        | 5458.05         |

    # Check the CAPPING subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017759 | ORG0017759 | AEBT-759          | 2355816         | AEB-TOL1819                | 201811               | CAPPING         | CM             | True        | -3855.39        |
    | 10017759 | ORG0017759 | AEBT-759          | 2372016         | AEB-TOL1819                | 201811               | CAPPING         | CM             | True        | -2670.12        |

 



    # Manager attemps to COMPLETE termination once PoA payments have been posted: SUCCESS

	# Manager COMPLETES termination (23893)
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'AEBP-759' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract 'AEBP-759' Version '1' SubVersion '0' via SDK

    # Have 'Terminate Contract' and 'Contract Termination Failed' Workflow History entries been created ?
    Then  the workflow history on contract 'AEBP-759' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Successful                         | CRM Integration     | ?                                |
    | Terminate Contract                             | FCS8 Test           | ?                                |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS1 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS2 Test           | Suspected fraud                  |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017759 | AEBP-759       | 1                     | 0                        | Closed         | Terminated                               | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017759 | ESFA-759       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |



    # Tidy up
    And   the override date is reset
      