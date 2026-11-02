Feature: CloseContractUnderTermination 23894

@AcceptanceTest @Withdrawn20201016
@Long2Run @Long2Run67
@HighValue
Scenario: A737 Create and approve an 1718 Mainstream contract and move to Approved/Under Termination sans a contract termination date. Request then REJECT Closure. Request again then APPROVE Closure. Fail bulk and non-financial amendments. Fail actuals. Check CRM, Tasks, Notification and Workflow History
    Given there are no allocations marked as Under Termination for UKPRN '10017737' 
    And   there are no terminated or closed allocations for UKPRN '10017737' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017737' 
   #And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017737'
    And   there are no notifications of type 'Non-Financial Contract Amendment Failed' 
	And   there are no notifications of type 'Approval Received'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEC-737       |
    | AECL-737      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017737' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017737 Co Ltd' with UKPRN '10017737' and OrgId 'ORG0017737' and has 'Grace Green' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017737 | 117737 | 10017737 Co Ltd | 0              | Locked Restructure    | Yes           | AA017737      | ?             | 7 Lovers Walk          | Preston Park           | ?                      | ?                      | Brighton               | East Sussex            | BN1 6AH   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017737 |




    # Change the date
    Given the override date is '01/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017737 | 10017737 Co Ltd      | ESFA-737             | MAIN-737       | 1                     | 01/08/2017        | 31/07/2018      | 70538.00      |                                    | Contract for Services | 1718   | New          | ORG0017737 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017737 | MAIN-737       | AEC-737       | AEBC              | AEBC1718                | AY                      | 01/08/2017          | 31/07/2018        | 16783.00        |                                         |            |                                                             | New          |             |
    | 10017737 | MAIN-737       | AECL-737      | AEBTO-CL          | AEBTO-CL1718            | AY                      | 01/08/2017          | 31/07/2018        | 31913.00        |                                         |            |                                                             | New          |             |
    | 10017737 | MAIN-737       | ANL-737       | ANLA              | ANLA1718                | AY                      | 01/08/2017          | 31/07/2018        | 21842.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017737 | MAIN-737       | AEC-737       | 1               | 0                     | 16783.00  | 466.00   | 2151.00  | 1780.00  | 174.00   | 308.00   | 2625.00  | 357.00   | 743.00   | 1321.00  | 570.00   | 2823.00  | 3465.00  | Adult Education Budget Total Funding                            | New          |             |
    | 10017737 | MAIN-737       | AECL-737      | 1               | 0                     | 31913.00  | 3444.00  | 3326.00  | 3681.00  | 1631.00  | 2115.00  | 2629.00  | 1087.00  | 2012.00  | 1957.00  | 3103.00  | 3365.00  | 3563.00  | Adult Education Budget - Community Learning                     | New          |             |
    | 10017737 | MAIN-737       | ANL-737       | 1               | 0                     | 21842.00  | 2679.00  | 757.00   | 1839.00  | 1310.00  | 179.00   | 2590.00  | 2758.00  | 520.00   | 2551.00  | 2877.00  | 164.00   | 3618.00  | Total Adult Non-Levy Apprenticeships Funding                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-737' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-737' and actual ContractNumber 'MAIN-737'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-737' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017737 | MAIN-737           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017737 | ESFA-737           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '132' deliverable period rows in CRM linked to the latest version of contract 'MAIN-737'




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '19/08/2018'

    # Request termination of the contract via the CRM SDK
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-737' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | ?                        | ?                       | No                          | Other                   | Police involvement      |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | AEC-737          | 04/06/2018                  | 11/06/2018                |
    | AECL-737         | ?                           | ?                         |
    | ANL-737          | ?                           | ?                         |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'MAIN-737' for UKPRN '10017737'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017737 - 10017737 Co Ltd     | MAIN-737       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017737 | MAIN-737            | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017737 | ESFA-737            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | MAIN-737       | 1                     | 0                        | ?                       | Police involvement      |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | AEC-737          | 1                     | 0                        | 04/06/2018        | 11/06/2018                |
    | AECL-737         | 1                     | 0                        | ?                 | ?                         |
    | ANL-737          | 1                     | 0                        | ?                 | ?                         |

#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'MAIN-737' for provider '10017737'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017737 - 10017737 Co Ltd     | MAIN-737       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'MAIN-737' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | Police involvement               |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '21/08/2018'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'MAIN-737' for provider '10017737' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'MAIN-737' for provider '10017737'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017737 - 10017737 Co Ltd      | MAIN-737       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'MAIN-737' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Police involvement               |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017737 | MAIN-737            | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017737 | ESFA-737            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2017        | 31/07/2018      | ?             |




    # Initiate contract closure - first time

    Given there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017737'
   #Given there are no notifications of type 'Contract Closure Rejected'

    # Zoe requests closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'MAIN-737' for provider '10017737'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017737 | MAIN-737            | 1                     | 0                        | Approved       | Awaiting Closure Approval                | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017737 | ESFA-737            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'MAIN-737' for provider '10017737'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017737 - 10017737 Co Ltd | MAIN-737  | FCS1 Test  | Contract Managers Team | Open  | Not Started |
    
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'MAIN-737' version '1' includes the following
    | Action                        | CompletedBy     | Comment                        |
    | Closure Initiation Successful | CRM Integration | ?                              |
    | Initiate Contract Closure     | FCS2 Test       | ?                              | 




    # REJECT first closure request

   #When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract 'MAIN-737' for provider '10017737'
    When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract 'MAIN-737' for provider '10017737' for the following reason
    | RejectionReason                                           |
    | Provider in dispute. Restated actuals may be forthcoming  |
    
    # Check the current state of the TASKS for this contract. Task should be completed
    Then  the following Tasks are present against version '1' of contract 'MAIN-737' for provider '10017737'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State     | Status    |
    | Confirm Closure Approval | 10017737 - 10017737 Co Ltd | MAIN-737  | FCS1 Test  | Contract Managers Team | Completed | Completed |

    # Check CONTRACT version, status and dates in CRM. Contract should again be marked as Approved
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017737 | MAIN-737            | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017737 | ESFA-737            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
    
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'MAIN-737' version '1' includes the following
    | Action                        | CompletedBy      | Comment                                                  | 
    | Reject Closure (Termination)  | FCS1 Test        | Provider in dispute. Restated actuals may be forthcoming | 

    # Check that a NOTIFICATION has been created and sent to the Advisor explaining why the closure has been rejected
   #And   there are notifications of type 'Contract Closure Rejected' owned by the 'Lead Manager Team' as follows
   #And   there are notifications of type 'Contract Closure Rejected' owned by the user 'FCS2 Test' as follows
    And   there is '1' notification of type 'Contract Closure Rejected' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                     | NotificationText                                                                                                                                     |
    | New    | Contract Closure Rejected - MAIN-737 | Closure of contract MAIN-737 v1 for provider 10017737 (10017737 Co Ltd) has been rejected - Provider in dispute. Restated actuals may be forthcoming |




    # Initiate contract closure - second time

    Given there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017737'
   #Given there are no notifications of type 'Contract Closure Rejected'

    # Zoe requests closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'MAIN-737' for provider '10017737'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017737 | MAIN-737            | 1                     | 0                        | Approved       | Awaiting Closure Approval                | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017737 | ESFA-737            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'MAIN-737' for provider '10017737'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017737 - 10017737 Co Ltd | MAIN-737  | FCS1 Test  | Contract Managers Team | Open  | Not Started |
    
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'MAIN-737' version '1' includes the following
    | Action                        | CompletedBy     | Comment                        |
    | Closure Initiation Successful | CRM Integration | ?                              |
    | Initiate Contract Closure     | FCS2 Test       | ?                              | 




    # APPROVE second closure request

    # Approve closure of the contract. This should succeed
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract 'MAIN-737' for provider '10017737'
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract 'MAIN-737' for provider '10017737'

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract 'MAIN-737' for provider '10017737'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State     | Status    |
    | Confirm Closure Approval | 10017737 - 10017737 Co Ltd | MAIN-737  | FCS1 Test  | Contract Managers Team | Completed | Completed |

    # Check CONTRACT version, status and dates in CRM. The contract end date should have been set
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017737 | MAIN-737           | 1                     | 0                        | Closed           | Under Termination         | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017737 | ESFA-737           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the WORKFLOW HISTORY for v1
    Then  the workflow history on contract 'MAIN-737' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                                                   |
    | Contract Closure Successful (Termination)      | CRM Integration     | ?                                                         |
    | Approve Closure                                | FCS1 Test           | ?                                                         |
    | Closure Initiation Successful                  | CRM Integration     | ?                                                         |
    | Initiate Contract Closure                      | FCS2 Test           | ?                                                         |
    | Reject Closure (Termination)                   | FCS1 Test           | Provider in dispute. Restated actuals may be forthcoming  |
    | Closure Initiation Successful                  | CRM Integration     | ?                                                         |
    | Initiate Contract Closure                      | FCS2 Test           | ?                                                         |
    | Termination Initiation Successful              | CRM Integration     | ?                                                         |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                                         |
#    | Initiate Contract Termination                  | FCS8 Test           | Police involvement                                        |
	



	# Attempt a BULK IMPORT amendment. This should fail. Amendments are not permitted once contract has been closed  (21935)

    # Change the date
    Given the override date is '22/08/2018'
	
	And   there are no files prefixed '10017737_MAIN-737' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1718 22012019113438 v2_A737' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 22012019113438 v2_A737' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 22012019113438 v2_A737' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 1718 22012019113438 v2_A737.xlsx' exists in the Datafiles folder and UKPRN '10017737' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
   #And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # UDC020
    And   '[Contract] Cannot create a draft Contract Amendment if there is no existing Approved Contract, or if the Contract is awaiting approval of either termination initiation or closure' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Attempt a NON-FINANCIAL amendment. This should fail too

   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'MAIN-737' for a non-financial VARIATION contract amendment

    # Check CONTRACT version, status and dates in CRM. There should not have been any changes
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017737 | MAIN-737           | 1                     | 0                        | Closed           | Under Termination         | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017737 | ESFA-737           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check that a NOTIFICATION has been created and sent to the initiating User 
   #And   there are notifications of type 'Non-Financial Contract Amendment Failed' owned by the 'Document Management Team' as follows
   #And   there are notifications of type 'Non-Financial Contract Amendment Failed' owned by the user 'FCS2 Test' as follows
	And   there is '1' notification of type 'Non-Financial Contract Amendment Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                                   | NotificationText                                                                                                                                                                  |
    | New    | Non-Financial Contract Amendment Failed - MAIN-737 | Contract MAIN-737 v1 for provider 10017737 (10017737 Co Ltd) cannot be amended - It must be in a status of "Approved" and a substatus of either "Approved" or "Under Termination" |




    # Attempt to consume actuals after the contract has closed. These should be disregarded

    # Change the date
    Given the override date is '04/08/2018'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017737'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Jul 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201708 | ANLA1718                | ANL-737                  | ?          | 2               | 0            | 144.47      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201708 | ANLA1718                | ANL-737                  | ?          | 3               | 0            | 861.47      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201708 | ANLA1718                | ANL-737                  | ?          | 4               | 0            | 737.91      |
    #
    | ILR1718        | R12                  | ORG0017737     | CM             | 201709 | ANLA1718                | ANL-737                  | ?          | 2               | 0            | 538.73      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201709 | ANLA1718                | ANL-737                  | ?          | 3               | 0            | 308.36      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201709 | ANLA1718                | ANL-737                  | ?          | 4               | 0            | 1295.73     |
    #
    | ILR1718        | R12                  | ORG0017737     | CM             | 201710 | ANLA1718                | ANL-737                  | ?          | 2               | 0            | 1207.39     |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201710 | ANLA1718                | ANL-737                  | ?          | 3               | 0            | 1163.66     |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201710 | ANLA1718                | ANL-737                  | ?          | 4               | 0            | 1083.52     |
    #
    | ILR1718        | R12                  | ORG0017737     | CM             | 201711 | ANLA1718                | ANL-737                  | ?          | 2               | 0            | 1170.39     |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201711 | ANLA1718                | ANL-737                  | ?          | 3               | 0            | 932.95      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201711 | ANLA1718                | ANL-737                  | ?          | 4               | 0            | 1488.31     |
    #
    | ILR1718        | R12                  | ORG0017737     | CM             | 201712 | ANLA1718                | ANL-737                  | ?          | 2               | 0            | 555.63      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201712 | ANLA1718                | ANL-737                  | ?          | 3               | 0            | 365.93      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201712 | ANLA1718                | ANL-737                  | ?          | 4               | 0            | 1060.72     |
    #
    | ILR1718        | R12                  | ORG0017737     | CM             | 201801 | ANLA1718                | ANL-737                  | ?          | 2               | 0            | 1311.78     |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201801 | ANLA1718                | ANL-737                  | ?          | 3               | 0            | 814.86      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201801 | ANLA1718                | ANL-737                  | ?          | 4               | 0            | 749.33      |
    #
    | ILR1718        | R12                  | ORG0017737     | CM             | 201802 | ANLA1718                | ANL-737                  | ?          | 2               | 0            | 977.27      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201802 | ANLA1718                | ANL-737                  | ?          | 3               | 0            | 111.89      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201802 | ANLA1718                | ANL-737                  | ?          | 4               | 0            | 715.25      |
    #
    | ILR1718        | R12                  | ORG0017737     | CM             | 201803 | ANLA1718                | ANL-737                  | ?          | 2               | 0            | 1295.97     |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201803 | ANLA1718                | ANL-737                  | ?          | 3               | 0            | 343.95      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201803 | ANLA1718                | ANL-737                  | ?          | 4               | 0            | 742.06      |
    #
    | ILR1718        | R12                  | ORG0017737     | CM             | 201804 | ANLA1718                | ANL-737                  | ?          | 2               | 0            | 184.08      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201804 | ANLA1718                | ANL-737                  | ?          | 3               | 0            | 561.49      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201804 | ANLA1718                | ANL-737                  | ?          | 4               | 0            | 1481.33     |
    #
    | ILR1718        | R12                  | ORG0017737     | CM             | 201805 | ANLA1718                | ANL-737                  | ?          | 2               | 0            | 878.14      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201805 | ANLA1718                | ANL-737                  | ?          | 3               | 0            | 681.26      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201805 | ANLA1718                | ANL-737                  | ?          | 4               | 0            | 903.70      |
    #
    | ILR1718        | R12                  | ORG0017737     | CM             | 201806 | ANLA1718                | ANL-737                  | ?          | 2               | 0            | 903.48      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201806 | ANLA1718                | ANL-737                  | ?          | 3               | 0            | 215.33      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201806 | ANLA1718                | ANL-737                  | ?          | 4               | 0            | 408.67      |
    #
    | ILR1718        | R12                  | ORG0017737     | CM             | 201807 | ANLA1718                | ANL-737                  | ?          | 2               | 0            | 454.42      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201807 | ANLA1718                | ANL-737                  | ?          | 3               | 0            | 802.44      |
    | ILR1718        | R12                  | ORG0017737     | CM             | 201807 | ANLA1718                | ANL-737                  | ?          | 4               | 0            | 1015.07     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-737       | AEC-737         | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-737       | AEC-737         | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-737       | AEC-737         | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-737       | AEC-737         | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-737       | AEC-737         | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-737       | AEC-737         | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | MAIN-737       | AECL-737        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | MAIN-737       | ANL-737         | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-737       | ANL-737         | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-737       | ANL-737         | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-737       | ANL-737         | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-737       | AEC-737         | 1               | 16783.00 | 466.00   | 2151.00  | 1780.00  | 174.00   | 308.00   | 2625.00  | 357.00   | 743.00   | 1321.00  | 570.00   | 2823.00  | 3465.00  | 
    | MAIN-737       | AEC-737         | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-737       | AEC-737         | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-737       | AEC-737         | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-737       | AEC-737         | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-737       | AEC-737         | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | MAIN-737       | AECL-737        | 1               | 31913.00 | 3444.00  | 3326.00  | 3681.00  | 1631.00  | 2115.00  | 2629.00  | 1087.00  | 2012.00  | 1957.00  | 3103.00  | 3365.00  | 3563.00  | 
    #
    | MAIN-737       | ANL-737         | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-737       | ANL-737         | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-737       | ANL-737         | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-737       | ANL-737         | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 



    # Tidy up
    Then  the override date is reset 

@AcceptanceTest @Withdrawn20201016 
@Long2Run @Long2Run67
Scenario: A738 Create and approve an ESF contract and move to Approved/Under Termination sans a contract termination date. Request then REJECT Closure. Request again then APPROVE Closure. Fail bulk and non-financial amendments. Fail actuals. Check CRM, Tasks, Notification and Workflow History
    Given there is no Contract, Task or Workflow data for UKPRN '10017738' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
	And   there are no notifications of type 'Approval Received'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017738'
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ESF-738       |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017738' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017738 Co Ltd' with UKPRN '10017738' and OrgId 'ORG0017738' and has 'FCS1 Test' as a manager 
    And   UPIN '117738' is associated with UKPRN '10017738' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017738 | 117738 | 10017738 Co Ltd | 0              | Active | Yes           | AA017738      | ?             | 

    # Change the date 
    And   the override date is '21/07/2017'     

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017738 | 10017738 Co Ltd      | ESFA-738             | ESIF-738       | 1                     | 01/08/2017        | 31/07/2018      | 150326.00     | Contract for Services | 1420   | New          | ORG0017738 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference | TenderAwardReference          | InvestmentPriority         | AgreementNumber | ActivityDescription | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017738 | ESIF-738       | ESF-738       | ESF 201420        | ESF                     | 01/08/2017          | 31/07/2018        | 150326.00       |                         |            | Skills Support for the Unemployed                           | New          | Leicester and Leicestershire LEP            | E37021       | 00-1         | TSS_20125                    | 20125/23-415-00-1/10017738    | 1.4 Active Inclusion       | 777\SD\7738     | Job Seekers Fund    | SSW                   | Transition     | 1.07                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                     | CRMIntent    | DeliveryOrg |
    | 10017738 | ESIF-738       | ESF-738       | 2               | 0                     |          | 38251.00  | 4260.00  | 291.00   | 2496.00  | 5179.00  | 4747.00  | 3486.00  | 1751.00  | 1825.00  | 4653.00  | 103.00   | 4569.00  | 4891.00  | RQ01 Regulated Learning                                    | New          |             |
    | 10017738 | ESIF-738       | ESF-738       | 3               | 0                     |          | 37807.00  | 4608.00  | 340.00   | 3563.00  | 2823.00  | 1803.00  | 2254.00  | 5773.00  | 5232.00  | 356.00   | 5699.00  | 2197.00  | 3159.00  | NR01 Non Regulated Activity                                | New          |             |
    | 10017738 | ESIF-738       | ESF-738       | 8               | 0                     |          | 47221.00  | 5917.00  | 5468.00  | 1376.00  | 4177.00  | 5881.00  | 3744.00  | 3894.00  | 1597.00  | 1690.00  | 4983.00  | 4951.00  | 3543.00  | SD01 Specification Defined Deliverable (with Description)  | New          |             |
    | 10017738 | ESIF-738       | ESF-738       | 9               | 0                     |          | 27047.00  | 618.00   | 636.00   | 4798.00  | 1721.00  | 293.00   | 1478.00  | 3213.00  | 656.00   | 5997.00  | 4064.00  | 113.00   | 3460.00  | SD02 Specification Defined Deliverable (with Description)  | New          |             |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 

    # Check the deliverable count in CRM (essentially just a wait)
    Then  there are '48' deliverable period rows in CRM linked to the latest version of contract 'ESIF-738'
    And   there are '48' deliverable periods in CRM linked to the latest version of contract 'ESIF-738' and allocation 'ESF-738'
 
    # Publish the contract 
    Given the latest version of contract 'ESIF-738' is in a state of 'Published to Provider' 
 
    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-738' and actual ContractNumber 'ESIF-738' 
 
    # Check that the contract is now approved 
    Then  the latest version of contract 'ESIF-738' is in status 'Approved' 
 
    # Check the deliverable count in CRM (48 + 4 on approval. Now corrected to 48)
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'ESIF-738'
    And   there are '48' deliverable periods in CRM linked to the latest version of contract 'ESIF-738' and allocation 'ESF-738'

    # Check CONTRACT version, status and dates in CRM
    Then the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017738 | ESIF-738           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017738 | ESFA-738           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '22/01/2019'

    # Request termination of the contract via the CRM SDK
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'ESIF-738' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments      |
    | ?                        | ?                       | No                          | Other                   | Director fraud suspected |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ESF-738          | 22/06/2018                  | 28/06/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'ESIF-738' for UKPRN '10017738'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017738 - 10017738 Co Ltd     | ESIF-738       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017738 | ESIF-738            | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017738 | ESFA-738            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments      |
    | ESIF-738       | 1                     | 0                        | ?                       | Director fraud suspected |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | ESF-738          | 1                     | 0                        | 22/06/2018        | 28/06/2018                |
    
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'ESIF-738' for provider '10017737'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017738 - 10017738 Co Ltd     | ESIF-738       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'ESIF-738' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                  |
#    | Initiate Contract Termination                  | FCS8 Test           | Director fraud suspected |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '22/01/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'ESIF-738' for provider '10017738' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'ESIF-738' for provider '10017738'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017738 - 10017738 Co Ltd      | ESIF-738       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'ESIF-738' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Director fraud suspected         |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017738 | ESIF-738            | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017738 | ESFA-738            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2017        | 31/07/2018      | ?             |




    # Initiate contract closure - first time

    Given there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017738'
   #Given there are no notifications of type 'Contract Closure Rejected'

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'ESIF-738' for provider '10017738'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017738 | ESIF-738            | 1                     | 0                        | Approved       | Awaiting Closure Approval                | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017738 | ESFA-738            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'ESIF-738' for provider '10017738'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017738 - 10017738 Co Ltd | ESIF-738  | FCS1 Test  | Contract Managers Team | Open  | Not Started |
    
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'ESIF-738' version '1' includes the following
    | Action                        | CompletedBy     | Comment                        |
    | Closure Initiation Successful | CRM Integration | ?                              |
    | Initiate Contract Closure     | FCS2 Test       | ?                              | 




    # REJECT first closure request

   #When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract 'ESIF-738' for provider '10017738'
    When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract 'ESIF-738' for provider '10017738' for the following reason
    | RejectionReason                            |
    | Director denies misappropriation of funds  |
    
    # Check the current state of the TASKS for this contract. Task should be completed
    Then  the following Tasks are present against version '1' of contract 'ESIF-738' for provider '10017738'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State     | Status    |
    | Confirm Closure Approval | 10017738 - 10017738 Co Ltd | ESIF-738  | FCS1 Test  | Contract Managers Team | Completed | Completed |

    # Check CONTRACT version, status and dates in CRM. Contract should again be marked as Approved
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017738 | ESIF-738            | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017738 | ESFA-738            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
    
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'ESIF-738' version '1' includes the following
    | Action                        | CompletedBy      | Comment                                   | 
    | Reject Closure (Termination)  | FCS1 Test        | Director denies misappropriation of funds | 

    # Check that a NOTIFICATION has been created and sent to the Advisor explaining why the closure has been rejected
	And   there is '1' notification of type 'Contract Closure Rejected' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                     | NotificationText                                                                                                                      |
    | New    | Contract Closure Rejected - ESIF-738 | Closure of contract ESIF-738 v1 for provider 10017738 (10017738 Co Ltd) has been rejected - Director denies misappropriation of funds |




    # Initiate contract closure - second time

    Given there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017738'
   #Given there are no notifications of type 'Contract Closure Rejected'

    # Zoe requests closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'ESIF-738' for provider '10017738'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017738 | ESIF-738            | 1                     | 0                        | Approved       | Awaiting Closure Approval                | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017738 | ESFA-738            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'ESIF-738' for provider '10017738'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017738 - 10017738 Co Ltd | ESIF-738  | FCS1 Test  | Contract Managers Team | Open  | Not Started |
    
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'ESIF-738' version '1' includes the following
    | Action                        | CompletedBy     | Comment                        |
    | Closure Initiation Successful | CRM Integration | ?                              |
    | Initiate Contract Closure     | FCS2 Test       | ?                              | 




    # APPROVE second closure request

    # Approve closure of the contract. This should succeed
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract 'ESIF-738' for provider '10017738'
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract 'ESIF-738' for provider '10017738'

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract 'ESIF-738' for provider '10017738'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State     | Status    |
    | Confirm Closure Approval | 10017738 - 10017738 Co Ltd | ESIF-738  | FCS1 Test  | Contract Managers Team | Completed | Completed |

    # Check CONTRACT version, status and dates in CRM. The contract end date should have been set
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017738 | ESIF-738           | 1                     | 0                        | Closed           | Under Termination         | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017738 | ESFA-738           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the WORKFLOW HISTORY for v1
    Then  the workflow history on contract 'ESIF-738' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                                      |
    | Contract Closure Successful (Termination)      | CRM Integration     | ?                                            |
    | Approve Closure                                | FCS1 Test           | ?                                            |
    | Closure Initiation Successful                  | CRM Integration     | ?                                            |
    | Initiate Contract Closure                      | FCS2 Test           | ?                                            |
    | Reject Closure (Termination)                   | FCS1 Test           | Director denies misappropriation of funds    |
    | Closure Initiation Successful                  | CRM Integration     | ?                                            |
    | Initiate Contract Closure                      | FCS2 Test           | ?                                            |
    | Termination Initiation Successful              | CRM Integration     | ?                                            |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                            |
#    | Initiate Contract Termination                  | FCS8 Test           | Director fraud suspected                     |




	# Attempt a BULK IMPORT amendment. This should fail. Amendments are not permitted once contract has been closed  (21935)

    # Change the date
    Given the override date is '23/01/2019'
	
	And   there are no files prefixed '10017737_MAIN-737' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 22012019130944 v2_A738' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 22012019130944 v2_A738' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 22012019130944 v2_A738' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 22012019130944 v2_A738.xlsx' exists in the Datafiles folder and UKPRN '10017738' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
   #And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # UDC020
    And   '[Contract] Cannot create a draft Contract Amendment if there is no existing Approved Contract, or if the Contract is awaiting approval of either termination initiation or closure' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Attempt a NON-FINANCIAL amendment. This should fail too

    # Clear down notifications
    Given there are no notifications of type 'Non-Financial Contract Amendment Failed' 
   #Given there are no notifications in CRM of type 'Non-Financial Contract Amendment Failed' for UKPRN '10017737'

   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'ESIF-738' for a non-financial NOTIFICATION contract amendment

    # Check CONTRACT version, status and dates in CRM. There should not have been any changes
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017738 | ESIF-738           | 1                     | 0                        | Closed           | Under Termination         | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017738 | ESFA-738           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check that a NOTIFICATION has been created and sent to the initiating User 
	And   there is '1' notification of type 'Non-Financial Contract Amendment Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                                   | NotificationText                                                                                                                                                                  |
    | New    | Non-Financial Contract Amendment Failed - ESIF-738 | Contract ESIF-738 v1 for provider 10017738 (10017738 Co Ltd) cannot be amended - It must be in a status of "Approved" and a substatus of either "Approved" or "Under Termination" |




	# Attempt to consume actuals after the contract has closed. These should be disregarded

    # Change the date
    Given the override date is '04/02/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017738'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Jan 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ESF            | ESF12                | ORG0017738     | CM             | 201708 | ESF1420                 | ESF-738                  | ?          | 2               | 0            | 1053.90     |
    | ESF            | ESF12                | ORG0017738     | CM             | 201708 | ESF1420                 | ESF-738                  | ?          | 3               | 0            | 205.08      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201708 | ESF1420                 | ESF-738                  | ?          | 8               | 35           | 1384.04     |
    | ESF            | ESF12                | ORG0017738     | CM             | 201708 | ESF1420                 | ESF-738                  | ?          | 9               | 30           | 1213.20     |
    | ESF            | ESF12                | ORG0017738     | CM             | 201709 | ESF1420                 | ESF-738                  | ?          | 2               | 0            | 455.12      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201709 | ESF1420                 | ESF-738                  | ?          | 3               | 0            | 382.48      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201709 | ESF1420                 | ESF-738                  | ?          | 8               | 20           | 606.56      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201709 | ESF1420                 | ESF-738                  | ?          | 9               | 45           | 369.70      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201710 | ESF1420                 | ESF-738                  | ?          | 2               | 0            | 1211.50     |
    | ESF            | ESF12                | ORG0017738     | CM             | 201710 | ESF1420                 | ESF-738                  | ?          | 3               | 0            | 1160.65     |
    | ESF            | ESF12                | ORG0017738     | CM             | 201710 | ESF1420                 | ESF-738                  | ?          | 8               | 50           | 1091.95     |
    | ESF            | ESF12                | ORG0017738     | CM             | 201710 | ESF1420                 | ESF-738                  | ?          | 9               | 29           | 1028.84     |
    | ESF            | ESF12                | ORG0017738     | CM             | 201711 | ESF1420                 | ESF-738                  | ?          | 2               | 0            | 108.23      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201711 | ESF1420                 | ESF-738                  | ?          | 3               | 0            | 973.00      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201711 | ESF1420                 | ESF-738                  | ?          | 8               | 16           | 958.44      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201711 | ESF1420                 | ESF-738                  | ?          | 9               | 53           | 1174.70     |
    | ESF            | ESF12                | ORG0017738     | CM             | 201712 | ESF1420                 | ESF-738                  | ?          | 2               | 0            | 579.00      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201712 | ESF1420                 | ESF-738                  | ?          | 3               | 0            | 160.73      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201712 | ESF1420                 | ESF-738                  | ?          | 8               | 14           | 508.94      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201712 | ESF1420                 | ESF-738                  | ?          | 9               | 44           | 572.02      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201801 | ESF1420                 | ESF-738                  | ?          | 2               | 0            | 956.10      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201801 | ESF1420                 | ESF-738                  | ?          | 3               | 0            | 1047.22     |
    | ESF            | ESF12                | ORG0017738     | CM             | 201801 | ESF1420                 | ESF-738                  | ?          | 8               | 35           | 1279.86     |
    | ESF            | ESF12                | ORG0017738     | CM             | 201801 | ESF1420                 | ESF-738                  | ?          | 9               | 34           | 197.69      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201802 | ESF1420                 | ESF-738                  | ?          | 2               | 0            | 266.70      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201802 | ESF1420                 | ESF-738                  | ?          | 3               | 0            | 677.55      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201802 | ESF1420                 | ESF-738                  | ?          | 8               | 43           | 310.18      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201802 | ESF1420                 | ESF-738                  | ?          | 9               | 45           | 203.70      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201803 | ESF1420                 | ESF-738                  | ?          | 2               | 0            | 1259.54     |
    | ESF            | ESF12                | ORG0017738     | CM             | 201803 | ESF1420                 | ESF-738                  | ?          | 3               | 0            | 791.45      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201803 | ESF1420                 | ESF-738                  | ?          | 8               | 32           | 1472.39     |
    | ESF            | ESF12                | ORG0017738     | CM             | 201803 | ESF1420                 | ESF-738                  | ?          | 9               | 41           | 101.69      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201804 | ESF1420                 | ESF-738                  | ?          | 2               | 0            | 1451.23     |
    | ESF            | ESF12                | ORG0017738     | CM             | 201804 | ESF1420                 | ESF-738                  | ?          | 3               | 0            | 1084.38     |
    | ESF            | ESF12                | ORG0017738     | CM             | 201804 | ESF1420                 | ESF-738                  | ?          | 8               | 35           | 1471.95     |
    | ESF            | ESF12                | ORG0017738     | CM             | 201804 | ESF1420                 | ESF-738                  | ?          | 9               | 27           | 364.42      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201805 | ESF1420                 | ESF-738                  | ?          | 2               | 0            | 703.19      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201805 | ESF1420                 | ESF-738                  | ?          | 3               | 0            | 933.02      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201805 | ESF1420                 | ESF-738                  | ?          | 8               | 37           | 263.56      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201805 | ESF1420                 | ESF-738                  | ?          | 9               | 28           | 790.70      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201806 | ESF1420                 | ESF-738                  | ?          | 2               | 0            | 614.33      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201806 | ESF1420                 | ESF-738                  | ?          | 3               | 0            | 954.69      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201806 | ESF1420                 | ESF-738                  | ?          | 8               | 53           | 643.33      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201806 | ESF1420                 | ESF-738                  | ?          | 9               | 48           | 295.75      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201807 | ESF1420                 | ESF-738                  | ?          | 2               | 0            | 512.39      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201807 | ESF1420                 | ESF-738                  | ?          | 3               | 0            | 945.88      |
    | ESF            | ESF12                | ORG0017738     | CM             | 201807 | ESF1420                 | ESF-738                  | ?          | 8               | 53           | 1145.83     |
    | ESF            | ESF12                | ORG0017738     | CM             | 201807 | ESF1420                 | ESF-738                  | ?          | 9               | 25           | 904.92      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-738       | ESF-738         | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-738       | ESF-738         | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-738       | ESF-738         | 8               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-738       | ESF-738         | 9               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
	
    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-738       | ESF-738         | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-738       | ESF-738         | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-738       | ESF-738         | 8               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-738       | ESF-738         | 9               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
	

	# Tidy up
    And   the override date is reset 	

@AcceptanceTest @Withdrawn20201016 
@Long2Run @Long2Run67
Scenario: A739SLD Create and approve a LEVY contract and move to Approved/Under Termination sans a contract termination date. Request then REJECT Closure. Request again then APPROVE Closure. Fail bulk, singleton and non-financial amendments. Fail payment instructions. Check CRM, Tasks, Notification and Workflow History
    Given there are no allocations marked as Under Termination for UKPRN '10017739' 
    And   there are no terminated or closed allocations for UKPRN '10017739' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017739' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017739' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017739' 
   #And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017739'
    And   there are no notifications of type 'Non-Financial Contract Amendment Failed' 
    And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications of type 'Approval Received' 
	And   there are no notifications of type 'Contract Closure Rejected' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table
    And   there are no DAS engagement events stored in FCS 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017739'
 



    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017739' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017739 Co Ltd' with UKPRN '10017739' and OrgId 'ORG0017739' and has 'FCS1 Test' as a manager 
    And   UPIN '117739' is associated with UKPRN '10017739' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | 
    | 10017739 | 117739 | 10017739 Co Ltd | 0              | Active | 
 
    # Set RoATP data 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017739 | 10017739 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 



    # Change the date 
    Given the override date is '16/09/2017' 
 
    # Inject data into the stub 
    And   the following Levy event data is available in the DAS agreement stub 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 42739 | INITIATED | 2017-09-15T18:03:12.2739 | 10017739   | 28739             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017739' 
    And   there is only one Levy contract in CRM for UKPRN '10017739' with a status of 'Draft' 
 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017739 | 10017739 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017739 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017739 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
	| 10017739 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                  | 
    | 10017739 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships        | 
    | 10017739 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships        |
	| 10017739 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017739 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |
 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 

     # Retrieve parameters 
	And   I retrieve the latest contract details from CRM for provider '10017739' for FundingType 'LEVY' and period '1799'
 
    # Check deliverable period count prior to approval 
    And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 



    # Change the date 
    Given the override date is '01/05/2020' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 
 
    # Check deliverable period count after approval 
    Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a May-20 deliverable period for each of deliverables 1 through 14 for each allocation 
    Then   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-20   | DeliverableDescription                               | 
    | 10017739 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017739 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017739 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017739 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017739 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017739 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017739 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017739 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017739 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017739 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017739 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017739 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017739 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017739 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017739 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017739 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017739 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017739 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017739 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017739 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017739 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017739 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017739 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017739 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017739 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017739 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017739 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017739 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 
 
    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017739 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/05/2020        | ?               | ?             | 
    | 10017739 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 

 


    # Initiate a TERMINATION.

    # Change the date
    Given the override date is '12/01/2021'

    # Request termination of the contract via the CRM SDK
    When  CRM user 'FCS8 Test' initiates contract termination for Contract '[ContractNo]' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | TerminationReason       | TerminationComments     |
    | 02/10/2018               | ?                       | Provider Change         | Suspected Bankrupcy     |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | [AllocRef_LEVY]  | 02/10/2020                  | 13/10/2020                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract '[ContractNo]' for UKPRN '10017739'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017739 - 10017739 Co Ltd     | [ContractNo]   | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017739 | [ContractNo]        | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/05/2020        | ?               | ?             |
    | 10017739 | [MasterContractNo]  | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    


    # Approve the Termination Initiation

    # Change the date
    Given the override date is '20/01/2021'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017739' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017739 | [ContractNo]        | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/05/2020        | ?               | ?             |
    | 10017739 | [MasterContractNo]  | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |




    # Initiate contract closure - first time

    Given there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017739'
   #Given there are no notifications of type 'Contract Closure Rejected'

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '[ContractNo]' for provider '10017739'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017739 | [ContractNo]        | 1                     | 0                        | Approved       | Awaiting Closure Approval                | True          | True                | 01/05/2020        | ?               | ?             |
    | 10017739 | [MasterContractNo]  | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017739'
    | Task                     | Description                | Regarding     | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017739 - 10017739 Co Ltd | [ContractNo]  | FCS1 Test  | Contract Managers Team | Open  | Not Started |
    
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy     | Comment                        |
    | Closure Initiation Successful | CRM Integration | ?                              |
    | Initiate Contract Closure     | FCS2 Test       | ?                              | 




    # REJECT first closure request

   #When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract '[ContractNo]' for provider '10017738'
    When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract '[ContractNo]' for provider '10017738' for the following reason
    | RejectionReason               |
    | Bankrupcy set aside by Court  |
    
    # Check the current state of the TASKS for this contract. Task should be completed
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017738'
    | Task                     | Description                | Regarding     | Owner      | Assigned Team          | State     | Status    |
    | Confirm Closure Approval | 10017739 - 10017739 Co Ltd | [ContractNo]  | FCS1 Test  | Contract Managers Team | Completed | Completed |

    # Check CONTRACT version, status and dates in CRM. Contract should again be marked as Approved
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017739 | [ContractNo]        | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/05/2020        | ?               | ?             |
    | 10017739 | [MasterContractNo]  | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |
    
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy      | Comment                       | 
    | Reject Closure (Termination)  | FCS1 Test        | Bankrupcy set aside by Court  | 

    # Check that a NOTIFICATION has been created and sent to the Advisor explaining why the closure has been rejected
	And   there is '1' notification of type 'Contract Closure Rejected' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                         | NotificationText                                                                                                             |
    | New    | Contract Closure Rejected - [ContractNo] | Closure of contract [ContractNo] v1 for provider 10017739 (10017739 Co Ltd) has been rejected - Bankrupcy set aside by Court |




    # Initiate contract closure - second time

    Given there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017739'
   #Given there are no notifications of type 'Contract Closure Rejected'

    # Zoe requests closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '[ContractNo]' for provider '10017739'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017739 | [ContractNo]        | 1                     | 0                        | Approved       | Awaiting Closure Approval                | True          | True                | 01/05/2020        | ?               | ?             |
    | 10017739 | [MasterContractNo]  | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017739'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017739 - 10017739 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Open  | Not Started |
    
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy     | Comment                        |
    | Closure Initiation Successful | CRM Integration | ?                              |
    | Initiate Contract Closure     | FCS2 Test       | ?                              | 




    # APPROVE second closure request

    # Change the date
    Given the override date is '21/01/2021'

    # Approve closure of the contract. This should succeed
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract '[ContractNo]' for provider '10017739'
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract '[ContractNo]' for provider '10017739'

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017739'
    | Task                     | Description                | Regarding     | Owner      | Assigned Team          | State     | Status    |
    | Confirm Closure Approval | 10017739 - 10017739 Co Ltd | [ContractNo]  | FCS1 Test  | Contract Managers Team | Completed | Completed |

    # Check CONTRACT version, status and dates in CRM. The contract end date should have been set
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017739 | [ContractNo]       | 1                     | 0                        | Closed           | Under Termination         | True          | True                | 01/05/2020        | 21/01/2021      | ?             |
    | 10017739 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the WORKFLOW HISTORY for v1
    Then  the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                                      |
    | Contract Closure Successful (Termination)      | CRM Integration     | ?                                            |
    | Approve Closure                                | FCS1 Test           | ?                                            |
    | Closure Initiation Successful                  | CRM Integration     | ?                                            |
    | Initiate Contract Closure                      | FCS2 Test           | ?                                            |
    | Reject Closure (Termination)                   | FCS1 Test           | Bankrupcy set aside by Court                 |
    | Closure Initiation Successful                  | CRM Integration     | ?                                            |
    | Initiate Contract Closure                      | FCS2 Test           | ?                                            |
    | Termination Initiation Successful              | CRM Integration     | ?                                            |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                            |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected Bankrupcy                          |
	



	# Attempt to amend the contract by bulk and singleton methods

    # Change the date
    Given the override date is '23/01/2021'

    # Issue a contract amendment request on v1 to attempt to create v2 using the SINGLETON mechanism. This should fail
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status | SubStatus         | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017739 | [MasterContractNo]   | [ContractNo]   | 1       | Closed | Under Termination | Variation     | No                       | Yes                          |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus    | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017739 | [ContractNo]       | 1                     | 0                        | Closed         | Under Termination    | True          | True                | 01/05/2020        | 21/01/2021      | ?             |
    | 10017739 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                    | False         | False               | 01/05/2017        | ?               | ?             |


    # Issue a contract amendment request on v1 to attempt to create v2 using the BULK mechanism. This should fail
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status | SubStatus         | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017739 | [MasterContractNo]   | [ContractNo]   | 1       | Closed | Under Termination | Variation     | No                       | Yes                   | Yes                          |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus    | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017739 | [ContractNo]       | 1                     | 0                        | Closed         | Under Termination    | True          | True                | 01/05/2020        | 21/01/2021      | ?             |
    | 10017739 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                    | False         | False               | 01/05/2017        | ?               | ?             |




    # Attempt a NON-FINANCIAL notification amendment

	# Clear down notifications
    Given there are no notifications of type 'Non-Financial Contract Amendment Failed' 
   #Given there are no notifications in CRM of type 'Non-Financial Contract Amendment Failed' for UKPRN '10017739'
	
    # Attempt a non-financial NOTIFICATION amendment. This should fail
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment
	
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus    | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017739 | [ContractNo]       | 1                     | 0                        | Closed         | Under Termination    | True          | True                | 01/05/2020        | 21/01/2021      | ?             |
    | 10017739 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                    | False         | False               | 01/05/2017        | ?               | ?             |

    # Check that a NOTIFICATION has been created and sent to the initiating User 
	And   there is '1' notification of type 'Non-Financial Contract Amendment Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                                       | NotificationText                                                                                                                                            |
    | New    | Non-Financial Contract Amendment Failed - [ContractNo] | Contract [ContractNo] v1 for provider 10017739 (10017739 Co Ltd) cannot be amended - Non-financial amendments cannot be created for LEVY LEVY1799 contracts |

    # Check the WORKFLOW HISTORY for v1
    Then  the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Non-Financial Amendment Initiation Failed      | CRM Integration     | ?                                |
    | Initiate Non-Financial Amendment (Notify)      | FCS2 Test           | ?                                |


	

    # Attempt to consume payment instructions after the contract has closed. These should be disregarded

    # Change the date
    Given the override date is '04/02/2021'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017739'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull DCFS PoI actuals for Jan 2021
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS41               | ORG0017739     | CM             | 202101 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 488.41      |
    | APPS           | APPS41               | ORG0017739     | CM             | 202101 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 981.20      |
    | APPS           | APPS41               | ORG0017739     | CM             | 202101 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 2105.55     |
    | APPS           | APPS41               | ORG0017739     | CM             | 202101 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 0.00        |
    | APPS           | APPS41               | ORG0017739     | CM             | 202101 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 1267.05     |
    | APPS           | APPS41               | ORG0017739     | CM             | 202101 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1168.10     |
    | APPS           | APPS41               | ORG0017739     | CM             | 202101 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 228.41      |
    | APPS           | APPS41               | ORG0017739     | CM             | 202101 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 1250.00     |
    | APPS           | APPS41               | ORG0017739     | CM             | 202101 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 750.74      |
    | APPS           | APPS41               | ORG0017739     | CM             | 202101 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 0.00        |
    | APPS           | APPS41               | ORG0017739     | CM             | 202101 | LEVY1799                | [AllocRef_LEVY]          |         | 13              | 0            | 785.25      |
    | APPS           | APPS41               | ORG0017739     | CM             | 202101 | LEVY1799                | [AllocRef_LEVY]          |         | 14              | 0            | 600.50      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check deliverable period count prior to approval 
    Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 




    # Check CRM financials

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef    | DeliverableCode | Total    | May-20   |
    | [ContractNo]   | [AllocRef_LEVY]  | 1               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]  | 2               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]  | 3               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]  | 4               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]  | 5               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]  | 6               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]  | 7               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]  | 8               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]  | 9               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]  | 10              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]  | 11              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]  | 12              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]  | 13              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]  | 14              | 0.00     | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | May-20   |
    | [ContractNo]   | [AllocRef_LEVY] | 1               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 2               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 3               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 4               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 5               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 6               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 7               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 8               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 9               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 10              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 11              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 12              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 13              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 14              | 0.00     | ?        | 



	# Tidy up
    Then  the override date is reset 	

@AcceptanceTest @Withdrawn20201016
Scenario: A740 Create and approve a 1718 Loans contract with actuals and move to Approved/Under Termination sans a contract termination date. Request then APPROVE Closure. Fail actuals. Check CRM, Tasks, Notification and Workflow History
    Given there are no allocations marked as Under Termination for UKPRN '10017740' 
    And   there are no terminated or closed allocations for UKPRN '10017740' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017740' 
   #And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017739'
    And   there are no notifications of type 'Approval Received' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-740      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017740' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017740 Co Ltd' with UKPRN '10017740' and OrgId 'ORG0017740' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017740 | 117740 | 10017740 Co Ltd | 0              | Locked Restructure    | Yes           | AA017740      | ?             | 1a Chapeltown          | Pudsey                 | ?                      | ?                      | Leeds                  | West Yorkshire         | LS28 7RZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017740 |




    # Change the date
    Given the override date is '01/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017740 | 10017740 Co Ltd      | ESFA-740             | 24Loans-740    | 1                     | 01/08/2017        | 31/07/2018      | 27177.00      |                                    | Contract for Services | 1718   | New          | ORG0017740 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017740 | 24Loans-740    | ALLF-740      | 24+ ALLF          | ALLF1718                | AY                      | 01/08/2017          | 31/07/2018        | 27177.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017740 | 24Loans-740    | ALLF-740      | 5               | 0                     | 27177.00  | 2564.00  | 3394.00  | 903.00   | 1956.00  | 2500.00  | 2603.00  | 3275.00  | 1259.00  | 888.00   | 2984.00  | 3117.00  | 1734.00  | Advanced Learner Loans Facility                                 | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '24Loans-740' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-740' and actual ContractNumber '24Loans-740'

    # Check that the contract is now approved
    Then  the latest version of contract '24Loans-740' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017740 | 24Loans-740        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017740 | ESFA-740           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract '24Loans-740'

  


    # Add actuals to the contract

    # Change the date
    Given the override date is '04/03/2018'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Feb 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201708 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 1063.07     |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201708 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 1919.54     |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201708 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 2243.01     |
    #
    | ILR1718        | R12                  | ORG0017740     | CM             | 201709 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 1628.10     |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201709 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 2177.04     |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201709 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 1257.07     |
    #
    | ILR1718        | R12                  | ORG0017740     | CM             | 201710 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 276.21      |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201710 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 1664.94     |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201710 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 1106.32     |
    #
    | ILR1718        | R12                  | ORG0017740     | CM             | 201711 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 1439.62     |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201711 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 547.33      |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201711 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 1464.85     |
    #
    | ILR1718        | R12                  | ORG0017740     | CM             | 201712 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 796.91      |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201712 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 2338.78     |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201712 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 1752.27     |
    #
    | ILR1718        | R12                  | ORG0017740     | CM             | 201801 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 1399.36     |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201801 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 932.16      |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201801 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 1612.59     |
    #
    | ILR1718        | R12                  | ORG0017740     | CM             | 201802 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 346.96      |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201802 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 2433.19     |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201802 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 2123.26     |
    #
    | ILR1718        | R12                  | ORG0017740     | CM             | 201803 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 1023.79     |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201803 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 1143.02     |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201803 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 1909.62     |
    #
    | ILR1718        | R12                  | ORG0017740     | CM             | 201804 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 567.09      |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201804 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 1880.05     |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201804 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 1392.34     |
    #
    | ILR1718        | R12                  | ORG0017740     | CM             | 201805 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 1087.53     |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201805 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 871.19      |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201805 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 1875.80     |
    #
    | ILR1718        | R12                  | ORG0017740     | CM             | 201806 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 2316.52     |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201806 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 561.61      |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201806 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 831.53      |
    #
    | ILR1718        | R12                  | ORG0017740     | CM             | 201807 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 2218.31     |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201807 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 2424.93     |
    | ILR1718        | R12                  | ORG0017740     | CM             | 201807 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 1730.12     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | 24Loans-740    | ALLF-740        | 2               | 14163.47 | 1063.07  | 1628.10  | 276.21   | 1439.62  | 796.91   | 1399.36  | 346.96   | 1023.79  | 567.09   | 1087.53  | 2316.52  | 2218.31  | 
    | 24Loans-740    | ALLF-740        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-740    | ALLF-740        | 6               | 18893.78 | 1919.54  | 2177.04  | 1664.94  | 547.33   | 2338.78  | 932.16   | 2433.19  | 1143.02  | 1880.05  | 871.19   | 561.61   | 2424.93  | 
    | 24Loans-740    | ALLF-740        | 7               | 19298.78 | 2243.01  | 1257.07  | 1106.32  | 1464.85  | 1752.27  | 1612.59  | 2123.26  | 1909.62  | 1392.34  | 1875.80  | 831.53   | 1730.12  | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | 24Loans-740    | ALLF-740        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | 
    | 24Loans-740    | ALLF-740        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | 
    | 24Loans-740    | ALLF-740        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | 
    | 24Loans-740    | ALLF-740        | 7               | 11559.37 | 2243.01  | 1257.07  | 1106.32  | 1464.85  | 1752.27  | 1612.59  | 2123.26  | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | 24Loans-740    | ALLF-740        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | 
    | 24Loans-740    | ALLF-740        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | 
    | 24Loans-740    | ALLF-740        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | 
    | 24Loans-740    | ALLF-740        | 7               | 11559.37 | 2243.01  | 1257.07  | 1106.32  | 1464.85  | 1752.27  | 1612.59  | 2123.26  | ?        | ?        | ?        | ?        | ?        | 

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '16/12/2018'

    # Request termination of the contract via the CRM SDK
    When  CRM user 'FCS8 Test' initiates contract termination for Contract '24Loans-740' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | ?                        | ?                       | No                          | Notice from Provider    | ?                       |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ALLF-740         | 12/06/2018                  | 13/06/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract '24Loans-740' for UKPRN '10017740'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017740 - 10017740 Co Ltd     | 24Loans-740    | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017740 | 24Loans-740         | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017740 | ESFA-740            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | 24Loans-740    | 1                     | 0                        | ?                       | ?                       |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | ALLF-740         | 1                     | 0                        | 12/06/2018        | 13/06/2018                |

#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract '24Loans-740' for provider '10017740'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017740 - 10017740 Co Ltd     | 24Loans-740    | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract '24Loans-740' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | ?                                |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '19/12/2018'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract '24Loans-740' for provider '10017740' is triggered by User 'FCS1 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract '24Loans-740' for provider '10017740'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017740 - 10017740 Co Ltd      | 24Loans-740    | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract '24Loans-740' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS1 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | ?                                |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017740 | 24Loans-740         | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017740 | ESFA-740            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2017        | 31/07/2018      | ?             |




    # Check CRM financials (Termination dated Jun 18 was done in Dec 18. Therefore, July actuals are zeroised and a recalculation occurs)

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | 24Loans-740    | ALLF-740        | 2               | 11945.16 | 1063.07  | 1628.10  | 276.21   | 1439.62  | 796.91   | 1399.36  | 346.96   | 1023.79  | 567.09   | 1087.53  | 2316.52  | 0.00     | 
    | 24Loans-740    | ALLF-740        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-740    | ALLF-740        | 6               | 16468.85 | 1919.54  | 2177.04  | 1664.94  | 547.33   | 2338.78  | 932.16   | 2433.19  | 1143.02  | 1880.05  | 871.19   | 561.61   | 0.00     | 
    | 24Loans-740    | ALLF-740        | 7               | 17568.66 | 2243.01  | 1257.07  | 1106.32  | 1464.85  | 1752.27  | 1612.59  | 2123.26  | 1909.62  | 1392.34  | 1875.80  | 831.53   | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | 24Loans-740    | ALLF-740        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-740    | ALLF-740        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-740    | ALLF-740        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-740    | ALLF-740        | 7               | 17568.66 | 2243.01  | 1257.07  | 1106.32  | 1464.85  | 1752.27  | 1612.59  | 2123.26  | 1909.62  | 1392.34  | 1875.80  | 831.53   | 0.00     | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | 24Loans-740    | ALLF-740        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-740    | ALLF-740        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-740    | ALLF-740        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-740    | ALLF-740        | 7               | 17568.66 | 2243.01  | 1257.07  | 1106.32  | 1464.85  | 1752.27  | 1612.59  | 2123.26  | 1909.62  | 1392.34  | 1875.80  | 831.53   | 0.00     | 




    # Initiate contract closure

    # Change the date
    Given the override date is '22/12/2018'

    # Zoe requests closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '24Loans-740' for provider '10017740'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017740 | 24Loans-740         | 1                     | 0                        | Approved       | Awaiting Closure Approval                | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017740 | ESFA-740            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '24Loans-740' for provider '10017740'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017740 - 10017740 Co Ltd | 24Loans-740  | FCS1 Test  | Contract Managers Team | Open  | Not Started |
    
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract '24Loans-740' version '1' includes the following
    | Action                        | CompletedBy     | Comment                        |
    | Closure Initiation Successful | CRM Integration | ?                              |
    | Initiate Contract Closure     | FCS2 Test       | ?                              | 




    # APPROVE closure request

    # Change the date
    Given the override date is '23/12/2018'

    # Approve closure of the contract. This should succeed
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract '24Loans-740' for provider '10017740'
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract '24Loans-740' for provider '10017740'

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract '24Loans-740' for provider '10017740'
    | Task                     | Description                | Regarding     | Owner      | Assigned Team          | State     | Status    |
    | Confirm Closure Approval | 10017740 - 10017740 Co Ltd | 24Loans-740   | FCS1 Test  | Contract Managers Team | Completed | Completed |

    # Check CONTRACT version, status and dates in CRM. The contract end date should have been set
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017740 | 24Loans-740        | 1                     | 0                        | Closed           | Under Termination         | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017740 | ESFA-740           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the WORKFLOW HISTORY for v1
    Then  the workflow history on contract '24Loans-740' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                                      |
    | Contract Closure Successful (Termination)      | CRM Integration     | ?                                            |
    | Approve Closure                                | FCS1 Test           | ?                                            |




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/01/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017740'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Dec 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201708 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 1408.29     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201708 | ALLF1718                | ALLF-740                 | ?          | 3               | 0            | 2188.73     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201708 | ALLF1718                | ALLF-740                 | ?          | 4               | 0            | 405.07      |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201708 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 1533.03     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201708 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 1668.16     |
    #
    | ILR1718        | R05                  | ORG0017740     | CM             | 201709 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 1355.78     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201709 | ALLF1718                | ALLF-740                 | ?          | 3               | 0            | 1263.87     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201709 | ALLF1718                | ALLF-740                 | ?          | 4               | 0            | 2076.75     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201709 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 876.65      |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201709 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 1811.36     |
    #
    | ILR1718        | R05                  | ORG0017740     | CM             | 201710 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 1453.98     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201710 | ALLF1718                | ALLF-740                 | ?          | 3               | 0            | 2235.92     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201710 | ALLF1718                | ALLF-740                 | ?          | 4               | 0            | 1210.67     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201710 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 1374.74     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201710 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 1667.54     |
    #
    | ILR1718        | R05                  | ORG0017740     | CM             | 201711 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 684.12      |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201711 | ALLF1718                | ALLF-740                 | ?          | 3               | 0            | 1999.46     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201711 | ALLF1718                | ALLF-740                 | ?          | 4               | 0            | 1608.19     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201711 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 967.77      |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201711 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 981.66      |
    #
    | ILR1718        | R05                  | ORG0017740     | CM             | 201712 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 2312.10     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201712 | ALLF1718                | ALLF-740                 | ?          | 3               | 0            | 2454.44     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201712 | ALLF1718                | ALLF-740                 | ?          | 4               | 0            | 876.50      |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201712 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 1713.07     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201712 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 1745.04     |
    #
    | ILR1718        | R05                  | ORG0017740     | CM             | 201801 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 2274.16     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201801 | ALLF1718                | ALLF-740                 | ?          | 3               | 0            | 461.67      |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201801 | ALLF1718                | ALLF-740                 | ?          | 4               | 0            | 1624.57     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201801 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 1809.56     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201801 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 883.52      |
    #
    | ILR1718        | R05                  | ORG0017740     | CM             | 201802 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 1624.77     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201802 | ALLF1718                | ALLF-740                 | ?          | 3               | 0            | 561.62      |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201802 | ALLF1718                | ALLF-740                 | ?          | 4               | 0            | 719.28      |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201802 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 791.67      |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201802 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 588.42      |
    #
    | ILR1718        | R05                  | ORG0017740     | CM             | 201803 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 1006.42     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201803 | ALLF1718                | ALLF-740                 | ?          | 3               | 0            | 777.67      |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201803 | ALLF1718                | ALLF-740                 | ?          | 4               | 0            | 1838.19     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201803 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 1583.82     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201803 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 615.35      |
    #
    | ILR1718        | R05                  | ORG0017740     | CM             | 201804 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 1965.53     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201804 | ALLF1718                | ALLF-740                 | ?          | 3               | 0            | 1230.66     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201804 | ALLF1718                | ALLF-740                 | ?          | 4               | 0            | 2338.26     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201804 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 2156.53     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201804 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 928.52      |
    #
    | ILR1718        | R05                  | ORG0017740     | CM             | 201805 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 1382.10     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201805 | ALLF1718                | ALLF-740                 | ?          | 3               | 0            | 1762.63     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201805 | ALLF1718                | ALLF-740                 | ?          | 4               | 0            | 2447.29     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201805 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 164.64      |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201805 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 1548.54     |
    #
    | ILR1718        | R05                  | ORG0017740     | CM             | 201806 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 1038.91     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201806 | ALLF1718                | ALLF-740                 | ?          | 3               | 0            | 1091.68     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201806 | ALLF1718                | ALLF-740                 | ?          | 4               | 0            | 1011.74     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201806 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 2066.44     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201806 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 507.68      |
    #
    | ILR1718        | R05                  | ORG0017740     | CM             | 201807 | ALLF1718                | ALLF-740                 | ?          | 2               | 0            | 217.97      |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201807 | ALLF1718                | ALLF-740                 | ?          | 3               | 0            | 2035.00     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201807 | ALLF1718                | ALLF-740                 | ?          | 4               | 0            | 1990.24     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201807 | ALLF1718                | ALLF-740                 | ?          | 6               | 0            | 1955.62     |
    | ILR1718        | R05                  | ORG0017740     | CM             | 201807 | ALLF1718                | ALLF-740                 | ?          | 7               | 0            | 2416.18     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

	# The following figures will be the same as those checked immediately after the termination initiation approval, above.

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | 24Loans-740    | ALLF-740        | 2               | 11945.16 | 1063.07  | 1628.10  | 276.21   | 1439.62  | 796.91   | 1399.36  | 346.96   | 1023.79  | 567.09   | 1087.53  | 2316.52  | 0.00     | 
    | 24Loans-740    | ALLF-740        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-740    | ALLF-740        | 6               | 16468.85 | 1919.54  | 2177.04  | 1664.94  | 547.33   | 2338.78  | 932.16   | 2433.19  | 1143.02  | 1880.05  | 871.19   | 561.61   | 0.00     | 
    | 24Loans-740    | ALLF-740        | 7               | 17568.66 | 2243.01  | 1257.07  | 1106.32  | 1464.85  | 1752.27  | 1612.59  | 2123.26  | 1909.62  | 1392.34  | 1875.80  | 831.53   | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | 24Loans-740    | ALLF-740        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-740    | ALLF-740        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-740    | ALLF-740        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-740    | ALLF-740        | 7               | 17568.66 | 2243.01  | 1257.07  | 1106.32  | 1464.85  | 1752.27  | 1612.59  | 2123.26  | 1909.62  | 1392.34  | 1875.80  | 831.53   | 0.00     | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | 24Loans-740    | ALLF-740        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-740    | ALLF-740        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-740    | ALLF-740        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-740    | ALLF-740        | 7               | 17568.66 | 2243.01  | 1257.07  | 1106.32  | 1464.85  | 1752.27  | 1612.59  | 2123.26  | 1909.62  | 1392.34  | 1875.80  | 831.53   | 0.00     | 



	# Tidy Up
	And   the override date is reset
	  
	 