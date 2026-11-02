Feature: InhibitAmendmentsDuringTermination 23809

@AcceptanceTest @Withdrawn20230123
Scenario: A773 Create and approve an 1819 AEB contract. Initiate termination (without amendment) through the SDK. Attempt bulk amendment. Fail: UDC-020. Attempt Non-Financial amendments (both). Fail. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017773'
    And   there is no Contract, Task or Workflow data for UKPRN '10017773'
    And   there are no notifications of type 'Non-Financial Contract Amendment Failed'
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBT-773      |

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for this provider
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017773'

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017773' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017773 Co Ltd' with UKPRN '10017773' and OrgId 'ORG0017773' and has 'FCS1 Test' as a manager 
    And   UPIN '117773' is associated with UKPRN '10017773' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017773 | 117773 | 10017773 Co Ltd | 0              | Active | Yes           | AA017773      | ?             | 




    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017773 | 10017773 Co Ltd      | ESFA-773             | AEBP-773       | 1                     | 01/08/2018        | 31/07/2019      | 27255.00      |                                | Contract for Services | 1819   | New          | ORG0017773 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017773 | AEBP-773       | AEBT-773      | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 27255.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017773 | AEBP-773       | AEBT-773      | 1               | 0                     | 27255.00  | 3481.00  | 2665.00  | 427.00   | 3441.00  | 2784.00  | 71.00    | 807.00   | 3283.00  | 3258.00  | 2349.00  | 1376.00  | 3313.00  | Adult Education - Traineeships and Other Learning Total Funding | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-773' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2018'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-773' and actual ContractNumber 'AEBP-773'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-773' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017773 | AEBP-773       | 1                     | 0                        | Approved       | Approved                                 | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017773 | ESFA-773       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'AEBP-773'




    # Initiate a TERMINATION
	
	# Change the date
    Given the override date is '22/09/2018'

    # Request termination of the contract
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'AEBP-773' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 05/10/2018               | 06/10/2018              | No                          | Other                   | Suspected fraud         |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | AEBT-773         | 05/10/2018                  | 06/10/2018                |

    # Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'AEBP-773' for UKPRN '10017773'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017773 - 10017773 Co Ltd     | AEBP-773       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017773 | AEBP-773       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017773 | ESFA-773       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments  |
    | AEBP-773       | 1                     | 0                        | 06/10/2018              | Suspected fraud      |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | AEBT-773         | 1                     | 0                        | 05/10/2018        | 06/10/2018                |
    
    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract 'AEBP-773' for provider '10017773'
    | Task                                       | Description                      | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017773 - 10017773 Co Ltd       | AEBP-773       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |




    # Change the date
    Given the override date is '01/10/2018'

    # Attempt to amend the contract by bulk upload. This should fail UDC020 because the contract is being terminated
    And   there are no files prefixed '10017773_AEBP-773' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 23072018124342 v3_A773' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 23072018124342 v3_A773' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 23072018124342 v3_A773.xlsx' exists in the Datafiles folder and UKPRN '10017773' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # UDC020
    And   '[Contract] Cannot create a draft Contract Amendment if there is no existing Approved Contract, or if the Contract is awaiting approval of either termination initiation, modification or closure' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Attempt a non-financial NOTIFICATION amendment request on v1 to create v2. This should fail
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'AEBP-773' for a non-financial NOTIFICATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'AEBP-773' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017773 | AEBP-773           | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017773 | ESFA-773           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the WORKFLOW HISTORY for v1
    And   the workflow history on contract 'AEBP-773' version '1' includes the following
    | Action                                    | CompletedBy      | Comment      |
    | Initiate Non-Financial Amendment (Notify) | FCS2 Test        | ?            |
    | Non-Financial Amendment Initiation Failed | CRM Integration  | ?            |

    # Check that a NOTIFICATION has been created and sent to the initiating User 
    And   there is '1' notification of type 'Non-Financial Contract Amendment Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                                    | NotificationText                                                                                                                                                                              |
    | New    | Non-Financial Contract Amendment Failed - AEBP-773  | Contract AEBP-773 v1 for provider 10017773 (10017773 Co Ltd) cannot be amended - It must be in a status of "Approved" and a substatus of either "Approved", "Modified" or "Under Termination" |




    # Attempt a non-financial VARIATION amendment request on v1 to create v2. This should fail too
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'AEBP-773' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'AEBP-773' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017773 | AEBP-773           | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017773 | ESFA-773           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the WORKFLOW HISTORY for v1
    And   the workflow history on contract 'AEBP-773' version '1' includes the following
    | Action                                    | CompletedBy      | Comment      |
    | Initiate Non-Financial Amendment (Vary)   | FCS2 Test        | ?            |
    | Non-Financial Amendment Initiation Failed | CRM Integration  | ?            |

    # Check that another NOTIFICATION has been created and sent to the initiating User 
    And   there are '2' notifications of type 'Non-Financial Contract Amendment Failed' owned by user 'FCS2 Test' which match the following
    | Status | NotificationName                                    | NotificationText                                                                                                                                                                              |
    | New    | Non-Financial Contract Amendment Failed - AEBP-773  | Contract AEBP-773 v1 for provider 10017773 (10017773 Co Ltd) cannot be amended - It must be in a status of "Approved" and a substatus of either "Approved", "Modified" or "Under Termination" |


    # Tidy up
    And  the override date is reset

@AcceptanceTest @Complete 
Scenario: A774 Create and approve an 2018 NLAP contract. Initiate termination (without amendment) through the SDK then approve same by completing the open task. Consume actuals after termination date. Check CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017774'
	And   there is no Contract, Task or Workflow data for UKPRN '10017774' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   the Contract Management atom feed is empty

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017774'

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ANLP-774      |
    | YNLP-774      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017774' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017774 Co Ltd' with UKPRN '10017774' and OrgId 'ORG0017774' and has 'FCS1 Test' as a manager 
    And   UPIN '117774' is associated with UKPRN '10017774' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017774 | 117774 | 10017774 Co Ltd | 0              | Active | Yes           | AA017774      | ?             | 




    # Change the date
    Given the override date is '01/12/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017774 | 10017774 Co Ltd      | ESFA-774             | NLAP-774       | 1                     | 01/01/2018        | 31/03/2019      | 53890.00      |                                | Contract for Services | 2018   | New          | ORG0017774 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017774 | NLAP-774       | ANLP-774      | ANLAP             | 16-18NLAP2018           | NONLEVY                 | 01/01/2018          | 31/03/2019        | 24984.00        |                         |            |                                                             | New          |             |
    | 10017774 | NLAP-774       | YNLP-774      | 16-18NLAP         | 16-18NLAP2018           | NONLEVY                 | 01/01/2018          | 31/03/2019        | 28906.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017774 | NLAP-774       | ANLP-774      | 1               | 0                     | 24984.00  | 1174.00  | 359.00   | 1822.00  | 1135.00  | 478.00   | 1466.00  | 2202.00  | 977.00   | 952.00   | 3744.00  | 2770.00  | 1007.00  | 2597.00  | 3492.00  | 809.00   | Total Adult Non-Levy Apprenticeships Funding                    | New          |             |
    | 10017774 | NLAP-774       | YNLP-774      | 1               | 0                     | 28906.00  | 1807.00  | 3047.00  | 2044.00  | 2335.00  | 477.00   | 3333.00  | 3151.00  | 2716.00  | 319.00   | 107.00   | 1727.00  | 3284.00  | 1332.00  | 1752.00  | 1475.00  | Total 16-18 Non-Levy Apprenticeships Funding                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NLAP-774' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-774' and actual ContractNumber 'NLAP-774'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-774' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017774 | NLAP-774           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017774 | ESFA-774           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '150' deliverable period rows in CRM linked to the latest version of contract 'NLAP-774'




    # Change the date
    Given the override date is '07/11/2018'

    # Request termination of the contract via the CRM SDK
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'NLAP-774' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 10/12/2018               | 25/12/2018              | No                          | Provider Change         | Police involvement      |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ANLP-774         | 25/11/2018                  | 10/12/2018                |
    | YNLP-774         | 03/12/2018                  | 18/12/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task
    Given the following Tasks are created against version '1' of contract 'NLAP-774' for UKPRN '10017774'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017774 - 10017774 Co Ltd     | NLAP-774       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017774 | NLAP-774       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017774 | ESFA-774       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | NLAP-774       | 1                     | 0                        | 25/12/2018              | Police involvement      |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | ANLP-774         | 1                     | 0                        | 25/11/2018        | 10/12/2018                |
    | YNLP-774         | 1                     | 0                        | 03/12/2018        | 18/12/2018                |

    
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'NLAP-774' for provider '10017774'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017774 - 10017774 Co Ltd     | NLAP-774       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'NLAP-774' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | Police involvement               |




    # Change the date
    Given the override date is '10/11/2018'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'NLAP-774' for provider '10017774' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'NLAP-774' for provider '10017774'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017774 - 10017774 Co Ltd      | NLAP-774       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'NLAP-774' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Police involvement               |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017774 | NLAP-774       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017774 | ESFA-774       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check the CM feed for the presence of an ItemType 4 (Termination Initiation) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number 'NLAP-774'
    And   the ItemType '4' event for version '1' of actual contract number 'NLAP-774' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017774 | NLAP-774       | 1               | 0                  | 25/12/2018              | Provider Change           | ANLP-774        | 25/11/2018            | 10/12/2018                |
    | 10017774 | NLAP-774       | 1               | 0                  | 25/12/2018              | Provider Change           | YNLP-774        | 03/12/2018            | 18/12/2018                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017774 | NLAP-774       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract NLAP-774:1.0 was placed under termination     |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017774 | NLAP-774       | 1               | 0                  | 25/12/2018              | Provider Change           | ANLP-774        | 25/11/2018            | 10/12/2018                |
    | 10017774 | NLAP-774       | 1               | 0                  | 25/12/2018              | Provider Change           | YNLP-774        | 03/12/2018            | 18/12/2018                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017774 | NLAP-774       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract NLAP-774:1.0 was placed under termination     |




	# Exclude actuals beyond termination date (23914)

    # Change the date
    Given the override date is '04/02/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017774'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Jan 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201808 | 16-18NLAP2018           | YNLP-774                 | ?          | 2               | 0            | 1067.97     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201808 | 16-18NLAP2018           | YNLP-774                 | ?          | 3               | 0            | 1230.39     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201808 | 16-18NLAP2018           | YNLP-774                 | ?          | 4               | 0            | 362.97      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201808 | 16-18NLAP2018           | YNLP-774                 | ?          | 5               | 0            | 1218.20     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201809 | 16-18NLAP2018           | YNLP-774                 | ?          | 2               | 0            | 1356.05     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201809 | 16-18NLAP2018           | YNLP-774                 | ?          | 3               | 0            | 444.42      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201809 | 16-18NLAP2018           | YNLP-774                 | ?          | 4               | 0            | 1436.05     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201809 | 16-18NLAP2018           | YNLP-774                 | ?          | 5               | 0            | 803.43      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201810 | 16-18NLAP2018           | YNLP-774                 | ?          | 2               | 0            | 137.01      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201810 | 16-18NLAP2018           | YNLP-774                 | ?          | 3               | 0            | 641.49      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201810 | 16-18NLAP2018           | YNLP-774                 | ?          | 4               | 0            | 374.85      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201810 | 16-18NLAP2018           | YNLP-774                 | ?          | 5               | 0            | 146.91      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201811 | 16-18NLAP2018           | YNLP-774                 | ?          | 2               | 0            | 1376.84     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201811 | 16-18NLAP2018           | YNLP-774                 | ?          | 3               | 0            | 861.24      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201811 | 16-18NLAP2018           | YNLP-774                 | ?          | 4               | 0            | 848.00      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201811 | 16-18NLAP2018           | YNLP-774                 | ?          | 5               | 0            | 1280.37     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201812 | 16-18NLAP2018           | YNLP-774                 | ?          | 2               | 0            | 467.83      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201812 | 16-18NLAP2018           | YNLP-774                 | ?          | 3               | 0            | 664.19      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201812 | 16-18NLAP2018           | YNLP-774                 | ?          | 4               | 0            | 761.36      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201812 | 16-18NLAP2018           | YNLP-774                 | ?          | 5               | 0            | 1123.61     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201901 | 16-18NLAP2018           | YNLP-774                 | ?          | 2               | 0            | 1138.06     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201901 | 16-18NLAP2018           | YNLP-774                 | ?          | 3               | 0            | 1203.65     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201901 | 16-18NLAP2018           | YNLP-774                 | ?          | 4               | 0            | 242.53      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201901 | 16-18NLAP2018           | YNLP-774                 | ?          | 5               | 0            | 1131.41     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201902 | 16-18NLAP2018           | YNLP-774                 | ?          | 2               | 0            | 510.70      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201902 | 16-18NLAP2018           | YNLP-774                 | ?          | 3               | 0            | 1047.59     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201902 | 16-18NLAP2018           | YNLP-774                 | ?          | 4               | 0            | 175.14      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201902 | 16-18NLAP2018           | YNLP-774                 | ?          | 5               | 0            | 490.37      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201903 | 16-18NLAP2018           | YNLP-774                 | ?          | 2               | 0            | 1113.44     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201903 | 16-18NLAP2018           | YNLP-774                 | ?          | 3               | 0            | 750.47      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201903 | 16-18NLAP2018           | YNLP-774                 | ?          | 4               | 0            | 1083.25     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201903 | 16-18NLAP2018           | YNLP-774                 | ?          | 5               | 0            | 865.83      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201904 | 16-18NLAP2018           | YNLP-774                 | ?          | 2               | 0            | 837.80      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201904 | 16-18NLAP2018           | YNLP-774                 | ?          | 3               | 0            | 775.18      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201904 | 16-18NLAP2018           | YNLP-774                 | ?          | 4               | 0            | 965.70      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201904 | 16-18NLAP2018           | YNLP-774                 | ?          | 5               | 0            | 298.68      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201905 | 16-18NLAP2018           | YNLP-774                 | ?          | 2               | 0            | 1448.58     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201905 | 16-18NLAP2018           | YNLP-774                 | ?          | 3               | 0            | 1164.87     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201905 | 16-18NLAP2018           | YNLP-774                 | ?          | 4               | 0            | 480.56      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201905 | 16-18NLAP2018           | YNLP-774                 | ?          | 5               | 0            | 1452.30     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201906 | 16-18NLAP2018           | YNLP-774                 | ?          | 2               | 0            | 643.17      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201906 | 16-18NLAP2018           | YNLP-774                 | ?          | 3               | 0            | 164.84      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201906 | 16-18NLAP2018           | YNLP-774                 | ?          | 4               | 0            | 1479.43     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201906 | 16-18NLAP2018           | YNLP-774                 | ?          | 5               | 0            | 609.36      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201907 | 16-18NLAP2018           | YNLP-774                 | ?          | 2               | 0            | 1260.97     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201907 | 16-18NLAP2018           | YNLP-774                 | ?          | 3               | 0            | 194.41      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201907 | 16-18NLAP2018           | YNLP-774                 | ?          | 4               | 0            | 291.82      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201907 | 16-18NLAP2018           | YNLP-774                 | ?          | 5               | 0            | 818.82      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201808 | ANLAP2018               | ANLP-774                 | ?          | 2               | 0            | 1242.72     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201808 | ANLAP2018               | ANLP-774                 | ?          | 3               | 0            | 168.82      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201808 | ANLAP2018               | ANLP-774                 | ?          | 4               | 0            | 959.58      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201808 | ANLAP2018               | ANLP-774                 | ?          | 5               | 0            | 192.64      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201809 | ANLAP2018               | ANLP-774                 | ?          | 2               | 0            | 739.94      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201809 | ANLAP2018               | ANLP-774                 | ?          | 3               | 0            | 771.05      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201809 | ANLAP2018               | ANLP-774                 | ?          | 4               | 0            | 821.21      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201809 | ANLAP2018               | ANLP-774                 | ?          | 5               | 0            | 152.80      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201810 | ANLAP2018               | ANLP-774                 | ?          | 2               | 0            | 1174.26     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201810 | ANLAP2018               | ANLP-774                 | ?          | 3               | 0            | 273.73      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201810 | ANLAP2018               | ANLP-774                 | ?          | 4               | 0            | 246.29      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201810 | ANLAP2018               | ANLP-774                 | ?          | 5               | 0            | 1428.10     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201811 | ANLAP2018               | ANLP-774                 | ?          | 2               | 0            | 446.75      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201811 | ANLAP2018               | ANLP-774                 | ?          | 3               | 0            | 511.06      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201811 | ANLAP2018               | ANLP-774                 | ?          | 4               | 0            | 119.81      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201811 | ANLAP2018               | ANLP-774                 | ?          | 5               | 0            | 401.03      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201812 | ANLAP2018               | ANLP-774                 | ?          | 2               | 0            | 1097.43     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201812 | ANLAP2018               | ANLP-774                 | ?          | 3               | 0            | 600.58      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201812 | ANLAP2018               | ANLP-774                 | ?          | 4               | 0            | 1076.59     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201812 | ANLAP2018               | ANLP-774                 | ?          | 5               | 0            | 1204.71     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201901 | ANLAP2018               | ANLP-774                 | ?          | 2               | 0            | 614.50      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201901 | ANLAP2018               | ANLP-774                 | ?          | 3               | 0            | 815.15      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201901 | ANLAP2018               | ANLP-774                 | ?          | 4               | 0            | 285.58      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201901 | ANLAP2018               | ANLP-774                 | ?          | 5               | 0            | 169.66      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201902 | ANLAP2018               | ANLP-774                 | ?          | 2               | 0            | 293.80      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201902 | ANLAP2018               | ANLP-774                 | ?          | 3               | 0            | 1204.74     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201902 | ANLAP2018               | ANLP-774                 | ?          | 4               | 0            | 1184.34     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201902 | ANLAP2018               | ANLP-774                 | ?          | 5               | 0            | 1420.80     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201903 | ANLAP2018               | ANLP-774                 | ?          | 2               | 0            | 448.16      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201903 | ANLAP2018               | ANLP-774                 | ?          | 3               | 0            | 568.37      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201903 | ANLAP2018               | ANLP-774                 | ?          | 4               | 0            | 1163.33     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201903 | ANLAP2018               | ANLP-774                 | ?          | 5               | 0            | 624.21      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201904 | ANLAP2018               | ANLP-774                 | ?          | 2               | 0            | 166.77      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201904 | ANLAP2018               | ANLP-774                 | ?          | 3               | 0            | 1375.95     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201904 | ANLAP2018               | ANLP-774                 | ?          | 4               | 0            | 600.32      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201904 | ANLAP2018               | ANLP-774                 | ?          | 5               | 0            | 1284.09     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201905 | ANLAP2018               | ANLP-774                 | ?          | 2               | 0            | 224.59      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201905 | ANLAP2018               | ANLP-774                 | ?          | 3               | 0            | 1040.15     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201905 | ANLAP2018               | ANLP-774                 | ?          | 4               | 0            | 1044.76     |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201905 | ANLAP2018               | ANLP-774                 | ?          | 5               | 0            | 589.58      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201906 | ANLAP2018               | ANLP-774                 | ?          | 2               | 0            | 741.66      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201906 | ANLAP2018               | ANLP-774                 | ?          | 3               | 0            | 338.31      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201906 | ANLAP2018               | ANLP-774                 | ?          | 4               | 0            | 952.16      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201906 | ANLAP2018               | ANLP-774                 | ?          | 5               | 0            | 811.67      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201907 | ANLAP2018               | ANLP-774                 | ?          | 2               | 0            | 592.52      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201907 | ANLAP2018               | ANLP-774                 | ?          | 3               | 0            | 984.30      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201907 | ANLAP2018               | ANLP-774                 | ?          | 4               | 0            | 168.45      |
    | ILR1819        | R06                  | ORG0017774     | CM             | 201907 | ANLAP2018               | ANLP-774                 | ?          | 5               | 0            | 1450.06     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

   # Check the ACTUAL VALUES in CRM (Dec18 actuals should have been processed but Jan19 actuals should have been discarded)
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-774       | ANLP-774        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-774       | ANLP-774        | 2               | 4701.10  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1242.72  | 739.94   | 1174.26  | 446.75   | 1097.43  | 0.00     | ?        | ?        | 
    | NLAP-774       | ANLP-774        | 3               | 2325.24  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 168.82   | 771.05   | 273.73   | 511.06   | 600.58   | 0.00     | ?        | ?        | 
    | NLAP-774       | ANLP-774        | 4               | 3223.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 959.58   | 821.21   | 246.29   | 119.81   | 1076.59  | 0.00     | ?        | ?        | 
    | NLAP-774       | ANLP-774        | 5               | 3379.28  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 192.64   | 152.80   | 1428.10  | 401.03   | 1204.71  | 0.00     | ?        | ?        | 
    #
    | NLAP-774       | YNLP-774        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-774       | YNLP-774        | 2               | 4405.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1067.97  | 1356.05  | 137.01   | 1376.84  | 467.83   | 0.00     | ?        | ?        | 
    | NLAP-774       | YNLP-774        | 3               | 3841.73  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1230.39  | 444.42   | 641.49   | 861.24   | 664.19   | 0.00     | ?        | ?        | 
    | NLAP-774       | YNLP-774        | 4               | 3783.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 362.97   | 1436.05  | 374.85   | 848.00   | 761.36   | 0.00     | ?        | ?        | 
    | NLAP-774       | YNLP-774        | 5               | 4572.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1218.20  | 803.43   | 146.91   | 1280.37  | 1123.61  | 0.00     | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-774       | ANLP-774        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-774       | ANLP-774        | 2               | 4701.10  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4701.10  | ?        | ?        | 
    | NLAP-774       | ANLP-774        | 3               | 2325.24  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2325.24  | ?        | ?        | 
    | NLAP-774       | ANLP-774        | 4               | 3223.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3223.48  | ?        | ?        | 
    | NLAP-774       | ANLP-774        | 5               | 3379.28  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3379.28  | ?        | ?        | 
    #
    | NLAP-774       | YNLP-774        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-774       | YNLP-774        | 2               | 4405.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4405.70  | ?        | ?        | 
    | NLAP-774       | YNLP-774        | 3               | 3841.73  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3841.73  | ?        | ?        | 
    | NLAP-774       | YNLP-774        | 4               | 3783.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3783.23  | ?        | ?        | 
    | NLAP-774       | YNLP-774        | 5               | 4572.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4572.52  | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-774       | ANLP-774        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-774       | ANLP-774        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-774       | ANLP-774        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-774       | ANLP-774        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-774       | ANLP-774        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    #
    | NLAP-774       | YNLP-774        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-774       | YNLP-774        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-774       | YNLP-774        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-774       | YNLP-774        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-774       | YNLP-774        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-774       | ANLP-774        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-774       | ANLP-774        | 2               | 4701.10  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4701.10  | ?        | ?        | 
    | NLAP-774       | ANLP-774        | 3               | 2325.24  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2325.24  | ?        | ?        | 
    | NLAP-774       | ANLP-774        | 4               | 3223.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3223.48  | ?        | ?        | 
    | NLAP-774       | ANLP-774        | 5               | 3379.28  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3379.28  | ?        | ?        | 
    #
    | NLAP-774       | YNLP-774        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NLAP-774       | YNLP-774        | 2               | 4405.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4405.70  | ?        | ?        | 
    | NLAP-774       | YNLP-774        | 3               | 3841.73  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3841.73  | ?        | ?        | 
    | NLAP-774       | YNLP-774        | 4               | 3783.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3783.23  | ?        | ?        | 
    | NLAP-774       | YNLP-774        | 5               | 4572.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4572.52  | ?        | ?        | 
	
	

    # Tidy up
    Then  the override date is reset 
	
  