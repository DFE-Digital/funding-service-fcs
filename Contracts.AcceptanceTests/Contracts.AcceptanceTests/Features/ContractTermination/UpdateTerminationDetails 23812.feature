Feature: UpdateTerminationDetails 23812

@AcceptanceTest @Withdrawn20231002 
Scenario: A736 Create and approve an 1819 Mainstream contract with two PoA allocations. Initiate termination (without amendment) and approve initiation. Update termination details repeatedly and check CRM and Feeds
    Given there are no allocations marked as Under Termination for UKPRN '10017736' 
    And   there are no terminated or closed allocations for UKPRN '10017736' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017736' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | APPS-736      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017736' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017736 Co Ltd' with UKPRN '10017736' and OrgId 'ORG0017736' and has 'FCS1 Test' as a manager 
    And   UPIN '117736' is associated with UKPRN '10017736' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017736 | 117736 | 10017736 Co Ltd | 0              | Active | Yes           | AA017736      | ?             | 

    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017736 | 10017736 Co Ltd      | ESFA-736             | MAIN-736       | 1                     | 01/08/2018        | 31/07/2019      | 73537.00      |                                | Contract for Services | 1819   | New          | ORG0017736 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017736 | MAIN-736       | 16TR-736      | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2018          | 31/07/2019        | 48184.00        |                                         |            |                                                             | New          |             |
    | 10017736 | MAIN-736       | APPS-736      | APPS              | APPS1819                | AY                      | 01/08/2018          | 31/07/2019        | 25353.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017736 | MAIN-736       | 16TR-736      | 1               | 0                     | 48184.00  | 5587.00  | 3862.00  | 4352.00  | 5603.00  | 6536.00  | 4717.00  | 2771.00  | 3926.00  | 1442.00  | 2247.00  | 3531.00  | 3610.00  | 16-18 Traineeships Funding                                      | New          |             |
    | 10017736 | MAIN-736       | 16TR-736      | 2               | 1                     | 26205.00  | 2587.00  | 1549.00  | 2696.00  | 2958.00  | 3155.00  | 2562.00  | 640.00   | 2705.00  | 1194.00  | 62.00    | 3456.00  | 2641.00  | 16-18 Traineeships Programme Funding                            | New          |             |
    | 10017736 | MAIN-736       | 16TR-736      | 3               | 1                     | 21979.00  | 3000.00  | 2313.00  | 1656.00  | 2645.00  | 3381.00  | 2155.00  | 2131.00  | 1221.00  | 248.00   | 2185.00  | 75.00    | 969.00   | 16-18 Traineeships Bursary Funding                              | New          |             |
    | 10017736 | MAIN-736       | APPS-736      | 1               | 0                     | 25353.00  | 2915.00  | 1595.00  | 2836.00  | 1832.00  | 2124.00  | 266.00   | 3122.00  | 2939.00  | 2504.00  | 108.00   | 3596.00  | 1516.00  | Apprenticeships Carry-In Total Funding                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-736' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-736' and actual ContractNumber 'MAIN-736'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-736' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017736 | MAIN-736           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017736 | ESFA-736           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '324' deliverable period rows in CRM linked to the latest version of contract 'MAIN-736'




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '06/10/2018'

    # Request termination of the contract 
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-736' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 08/11/2018               | 10/11/2018              | No                          | Notice from Agency      | Director arrested       |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | 16TR-736         | 27/10/2018                  | 03/11/2018                |
    | APPS-736         | 27/10/2018                  | 03/11/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
   And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'MAIN-736' for UKPRN '10017736'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017736 - 10017736 Co Ltd     | MAIN-736       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017736 | MAIN-736            | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017736 | ESFA-736            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | MAIN-736       | 1                     | 0                        | 10/11/2018              | Director arrested       |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | 16TR-736         | 1                     | 0                        | 27/10/2018        | 03/11/2018                |
    | APPS-736         | 1                     | 0                        | 27/10/2018        | 03/11/2018                |

    
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'MAIN-736' for provider '10017736'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017736 - 10017736 Co Ltd     | MAIN-736       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'MAIN-736' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | Director arrested                |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '09/10/2018'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'MAIN-736' for provider '10017736' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'MAIN-736' for provider '10017736'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017736 - 10017736 Co Ltd      | MAIN-736       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'MAIN-736' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Director arrested                |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017736 | MAIN-736            | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017736 | ESFA-736            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Initiate UPDATE TERMINATION DETAILS

    # Change the date
    Given the override date is '08/11/2018'

	# Clear down the ADP feed prior to updating the termination details
	And   the Allocation Delivery Monitoring Service atom feed is empty

    # Issue an 'Update termination details' request (23812)
	When  CRM user 'FCS8 Test' updates contract termination details for Contract 'MAIN-736' Version '1' SubVersion '0' with the following options
    | ContractTerminationDate | TerminationReason       | TerminationComments     |
    | 11/11/2018              | Notice from Agency      | Director in prison      |

    And   with the following updated allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | 16TR-736         | 28/10/2018                  | 04/11/2018                |
    | APPS-736         | 28/10/2018                  | 04/11/2018                |

    # Use either the CRM UI (slow) or the SDK (fast) to amend the termination details
#   And   the user completes the termination amendment request via UI
    And   the user completes the termination amendment request via SDK

    # Has a 'Termination Details Update Successful' Workflow History entry been created ?
    Then  the workflow history on contract 'MAIN-736' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Details Update Successful          | CRM Integration     | ?                                |
    | Update Termination Details                     | FCS8 Test           | Director in prison               |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Director arrested                |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017736 | MAIN-736            | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017736 | ESFA-736            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Check the CM feed for a termination updated event

    # Check the CM feed for the presence of an ItemType 7 (Contract Termination Details Updated) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '7' event for version '1' of actual contract number 'MAIN-736'
    And   the ItemType '7' event for version '1' of actual contract number 'MAIN-736' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017736 | MAIN-736       | 1               | 0                  | 11/11/2018              | Notice from Agency        | 16TR-736        | 28/10/2018            | 04/11/2018                |
    | 10017736 | MAIN-736       | 1               | 0                  | 11/11/2018              | Notice from Agency        | APPS-736        | 28/10/2018            | 04/11/2018                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                            | CategoryLabel                                           | Title                                                                 |
    | 10017736 | MAIN-736       | 1               | 0                  | Contract Termination Details Updated    | Termination details for a contract have been updated    | Termination details for contract MAIN-736:1.0 have been updated       |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017736 | MAIN-736       | 1               | 0                  | 11/11/2018              | Notice from Agency        | 16TR-736        | 28/10/2018            | 04/11/2018                |
    | 10017736 | MAIN-736       | 1               | 0                  | 11/11/2018              | Notice from Agency        | APPS-736        | 28/10/2018            | 04/11/2018                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                            | CategoryLabel                                           | Title                                                                 |
    | 10017736 | MAIN-736       | 1               | 0                  | Contract Termination Details Updated    | Termination details for a contract have been updated    | Termination details for contract MAIN-736:1.0 have been updated       |




    # Check there isn't a termination updated event on the AllocationDelivery.AllocationDeliveryEntry table

    # Check all activity has finished
    When   there are no messages left in the system

    # Check that an ActualsUpdated row has not been written to the AllocationDelivery.AllocationDeliveryEntry table
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '4' event for version '1' of contract number 'MAIN-736' and allocation number 'APPS-736'



    
    # Initiate UPDATE TERMINATION DETAILS again 
	#   Contract  : Set date to null and change reason and comments
	#   Allocation: Set StopNewStarts and Termination dates removed from APPS and set before contract start date on 16TR

    # Change the date
    Given the override date is '09/11/2018'

    # Clear down the ADP and CM feeds prior to updating the termination details
    And   the Allocation Delivery Monitoring Service atom feed is empty
	And   the Contract Management atom feed is empty

    # Issue an 'Update termination details' request (23812)
    When  CRM user 'FCS8 Test' updates contract termination details for Contract 'MAIN-736' Version '1' SubVersion '0' with the following options
    | ContractTerminationDate | TerminationReason       | TerminationComments     |
    | ?                       | Notice from Provider    | Director made bankrupt  |

    And   with the following updated allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | 16TR-736         | 01/07/2018                  | 01/07/2018                |
    | APPS-736         | ?                           | ?                         |

    # Use either the CRM UI (slow) or the SDK (fast) to amend the termination details
#   And   the user completes the termination amendment request via UI
    And   the user completes the termination amendment request via SDK

    # Check CONTRACT termination values in CRM
    Then  the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | MAIN-736       | 1                     | 0                        | ?                       | ?                       |
  # | MAIN-736       | 1                     | 0                        | ?                       | Director made bankrupt  |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | 16TR-736         | 1                     | 0                        | 01/07/2018        | 01/07/2018                |
    | APPS-736         | 1                     | 0                        | ?                 | ?                         |

    # Check the CM feed for the presence of an ItemType 7 (Contract Termination Details Updated) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '7' event for version '1' of actual contract number 'MAIN-736'
    And   the ItemType '7' event for version '1' of actual contract number 'MAIN-736' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017736 | MAIN-736       | 1               | 0                  | ?                       | Notice from Provider      | 16TR-736        | 01/07/2018            | 01/07/2018                |
    | 10017736 | MAIN-736       | 1               | 0                  | ?                       | Notice from Provider      | APPS-736        | ?                     | ?                         |




    # Initiate UPDATE TERMINATION DETAILS yet again 
	#   Contract  : No change 
	#   Allocation: Set StopNewStarts and Termination dates on allocations to different dates

    # Change the date
    Given the override date is '11/11/2018'

    # Clear down the ADP and CM feeds prior to updating the termination details
    And   the Allocation Delivery Monitoring Service atom feed is empty
	And   the Contract Management atom feed is empty

    # Issue an 'Update termination details' request (23812)
    When  CRM user 'FCS8 Test' updates contract termination details for Contract 'MAIN-736' Version '1' SubVersion '0' with the following options
    | ContractTerminationDate | TerminationReason       | TerminationComments     |
    | ?                       | Other                   | Director made bankrupt  |

    And   with the following updated allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | 16TR-736         | 12/09/2018                  | 16/10/2018                |
    | APPS-736         | 07/11/2018                  | 28/12/2018                |

    # Use either the CRM UI (slow) or the SDK (fast) to amend the termination details
#   And   the user completes the termination amendment request via UI
    And   the user completes the termination amendment request via SDK

    # Check CONTRACT termination values in CRM
    Then  the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | MAIN-736       | 1                     | 0                        | ?                       | ?                       |
 #  | MAIN-736       | 1                     | 0                        | ?                       | Director made bankrupt  |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | 16TR-736         | 1                     | 0                        | 12/09/2018        | 16/10/2018                |
    | APPS-736         | 1                     | 0                        | 07/11/2018        | 28/12/2018                |

    # Check the CM feed for the presence of an ItemType 7 (Contract Termination Details Updated) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '7' event for version '1' of actual contract number 'MAIN-736'
    And   the ItemType '7' event for version '1' of actual contract number 'MAIN-736' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017736 | MAIN-736       | 1               | 0                  | ?                       | Other                     | 16TR-736        | 12/09/2018            | 16/10/2018                |
    | 10017736 | MAIN-736       | 1               | 0                  | ?                       | Other                     | APPS-736        | 07/11/2018            | 28/12/2018                |




    # Initiate UPDATE TERMINATION DETAILS once more 
	#   Contract  : Set date into future and change reason and comments
	#   Allocation: Set dates into future

    # Change the date
    Given the override date is '13/11/2018'

    # Clear down the ADP and CM feeds prior to updating the termination details
    And   the Allocation Delivery Monitoring Service atom feed is empty
	And   the Contract Management atom feed is empty

    # Issue an 'Update termination details' request (23812)
    When  CRM user 'FCS8 Test' updates contract termination details for Contract 'MAIN-736' Version '1' SubVersion '0' with the following options
    | ContractTerminationDate | TerminationReason       | TerminationComments     |
    | 31/12/2018              | Notice from Provider    | Director excommunicated |

    And   with the following updated allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | 16TR-736         | 12/12/2018                  | 16/12/2018                |
    | APPS-736         | 21/12/2018                  | 28/12/2018                |

    # Use either the CRM UI (slow) or the SDK (fast) to amend the termination details
#   And   the user completes the termination amendment request via UI
    And   the user completes the termination amendment request via SDK

    # Check CONTRACT termination values in CRM
    Then  the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | MAIN-736       | 1                     | 0                        | 31/12/2018              | ?                       |
 #  | MAIN-736       | 1                     | 0                        | 31/12/2018              | Director excommunicated |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | 16TR-736         | 1                     | 0                        | 12/12/2018        | 16/12/2018                |
    | APPS-736         | 1                     | 0                        | 21/12/2018        | 28/12/2018                |

    # Check the CM feed for the presence of an ItemType 7 (Contract Termination Details Updated) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '7' event for version '1' of actual contract number 'MAIN-736'
    And   the ItemType '7' event for version '1' of actual contract number 'MAIN-736' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017736 | MAIN-736       | 1               | 0                  | 31/12/2018              | Notice from Provider      | 16TR-736        | 12/12/2018            | 16/12/2018                |
    | 10017736 | MAIN-736       | 1               | 0                  | 31/12/2018              | Notice from Provider      | APPS-736        | 21/12/2018            | 28/12/2018                |

    # Check the Workflow History comments 
    And   the workflow history on contract 'MAIN-736' version '1' includes the following
    | Action                       | CompletedBy        | Comment                          |
    | Update Termination Details   | FCS8 TEST          | Director excommunicated          |
    | Update Termination Details   | FCS8 TEST          | Director made bankrupt           |
    | Update Termination Details   | FCS8 TEST          | Director in prison               |


    # Tidy up
    And   the override date is reset 

@AcceptanceTest @Complete
Scenario: A249 Update termination details on a Levy contract then complete termination
    Given there are no allocations marked as Under Termination for UKPRN '10017249' 
    And   there are no terminated or closed allocations for UKPRN '10017249' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017249' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017249' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017249' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017249' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017249' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table
    And   there are no entries in the ContractManagement.EngagementEvent table
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017249' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017249 Co Ltd' with UKPRN '10017249' and OrgId 'ORG0017249' and has 'FCS1 Test' as a manager 
    And   UPIN '117249' is associated with UKPRN '10017249' in the CRM Organisation table 

    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | AddressLine1          | AddressLine2          | AddressLine3          | AddressLine4          | Town                  | County                | Postcode  |
    | 10017249 | 117249 | 10017249 Co Ltd | 0              | Active | 91 Overt Buildings    | Hullbridge Road       | South Woodham Ferrers | ?                     | Chelmsford            | Essex                 | CM3 5LJ   |
 
    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017249 |
    
    
    # Set RoATP data (needed for amendment checks) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017249 | 10017249 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 



    # Change the date 
    Given the override date is '16/09/2017' 

    # Create dummy docs in Sharepoint
    And   a file with filename '10017249_APPLEVY-249_v1.pdf' is created in 'LEVY-1799-Input-Appendices'
    And   a file with filename '10017249_APPLEVY-249_v1.pdf' is created in 'LEVY-1799-Output-Documents for Publication'
 
    # Inject data into the stub 
   #And   the following Levy event data is available in the DAS agreement stub 
    And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 42249 | INITIATED | 2017-09-15T18:03:12.2249 | 10017249   | 28249             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017249' 
    And   there is only one Levy contract in CRM for UKPRN '10017249' with a status of 'Draft' 
 
#    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
#    Then  the latest version of the contract has the following settings 
#    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
#    | Draft  | Internally Approved    | Yes           | No                  | 1                     | 
 
    # Retrieve parameters from CRM  
   #When  I retrieve the latest EFA contract details from CRM for provider '10017249' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017249' 
#   And   I retrieve the latest contract details from CRM for provider '10017249' for FundingType 'LEVY' and period '1799' 

    # Publish the contract (This is needed because the injection step above leaves the contract in the wrong state)
    Given the latest version of contract 'APPLEVY-249' is in a state of 'Published to Provider'




    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017249 | 10017249 Co Ltd      | LEVY        | ESFA-249             | APPLEVY-249    | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017249 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017249 | LEVY              | LEVY1799                | APPLEVY-249   | LEVY-249             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017249 | LEVY              | LEVY-249            | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017249 | LEVY              | LEVY-249            | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 
 
    # Check deliverable period count prior to approval 
    And   there are '2' deliverable period rows in CRM linked to the latest version of contract number 'APPLEVY-249' 
 



    # Change the date 
    Given the override date is '06/01/2020' 

    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-249' and ContractNumber 'APPLEVY-249' and Version '1' 
 
    # Check CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017249 | APPLEVY-249        | 1                     | 0                        | Approved         | Approved               | True          | True                | 06/01/2020        | ?               | ?             | 
    | 10017249 | ESFA-249           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
 
    # Check ALLOCATION dates in CRM 
    And   the following allocation values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef    | AllocationStartDate | AllocationEndDate | 
    | 10017249 | APPLEVY-249        | 1                     | LEVY-249         | 06/01/2020          | ?                 | 

    # Check deliverable period count after approval 
    And   there are '14' deliverable period rows in CRM linked to the latest version of contract number 'APPLEVY-249' 
 
    # After approval there should be a Jan-20 deliverable period for each of deliverables 1 through 14 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Jan-20   | DeliverableDescription                               | 
	| 10017249 | LEVY              | LEVY-249            | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017249 | LEVY              | LEVY-249            | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017249 | LEVY              | LEVY-249            | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017249 | LEVY              | LEVY-249            | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017249 | LEVY              | LEVY-249            | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017249 | LEVY              | LEVY-249            | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017249 | LEVY              | LEVY-249            | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017249 | LEVY              | LEVY-249            | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017249 | LEVY              | LEVY-249            | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017249 | LEVY              | LEVY-249            | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017249 | LEVY              | LEVY-249            | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017249 | LEVY              | LEVY-249            | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017249 | LEVY              | LEVY-249            | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017249 | LEVY              | LEVY-249            | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '19/10/2020'

    # Request termination of the contract via the CRM UI
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'APPLEVY-249' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | TerminationReason       | TerminationComments     |
    | 21/11/2020               | 06/12/2020              | Removed from RoATP      | Acquisition in progress |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | LEVY-249         | 21/11/2020                  | 06/12/2020                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'APPLEVY-249' for UKPRN '10017249'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017249 - 10017249 Co Ltd     | APPLEVY-249    | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

	 
    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017249 | APPLEVY-249         | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 06/01/2020        | ?               | ?             |
    | 10017249 | ESFA-249            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | APPLEVY-249    | 1                     | 0                        | 06/12/2020              | Acquisition in progress |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | LEVY-249         | 1                     | 0                        | 21/11/2020        | 06/12/2020                |
    
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'APPLEVY-249' for provider '10017249'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017249 - 10017249 Co Ltd     | APPLEVY-249    | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'APPLEVY-249' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | Acquisition in progress          |




    # Approve the Termination Initiation.

    # Change the date
    Given the override date is '22/10/2020'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'APPLEVY-249' for provider '10017249' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'APPLEVY-249' for provider '10017249'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017249 - 10017249 Co Ltd      | APPLEVY-249    | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'APPLEVY-249' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Acquisition in progress          |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017249 | APPLEVY-249         | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 06/01/2020        | ?               | ?             |
    | 10017249 | ESFA-249            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |




    # Initiate UPDATE TERMINATION DETAILS

    # Change the date
    Given the override date is '23/10/2020'

    # Clear down the ADP feed prior to updating the termination details
    And   the Allocation Delivery Monitoring Service atom feed is empty

    # Issue an 'Update termination details' request (23812)
    When  CRM user 'FCS8 Test' updates contract termination details for Contract 'APPLEVY-249' Version '1' SubVersion '0' with the following options
    | ContractTerminationDate | TerminationReason        | TerminationComments     |
    | 24/01/2020              | Removed from RoATP       | Acquisition in progress |

    And   with the following updated allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | LEVY-249         | 24/01/2020                  | 24/01/2020                |

	# Use either the CRM UI (slow) or the SDK (fast) to amend the termination details
#   And   the user completes the termination amendment request via UI
    And   the user completes the termination amendment request via SDK




    # Has a 'Termination Details Update Successful' Workflow History entry been created ?
    Then  the workflow history on contract 'APPLEVY-249' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Details Update Successful          | CRM Integration     | ?                                |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017249 | APPLEVY-249         | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 06/01/2020        | ?               | ?             |
    | 10017249 | ESFA-249            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |




    # Check the CM feed for a termination updated event

    # Check the CM feed for the presence of an ItemType 7 (Contract Termination Details Updated) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '7' event for version '1' of actual contract number 'APPLEVY-249'
    And   the ItemType '7' event for version '1' of actual contract number 'APPLEVY-249' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017249 | APPLEVY-249    | 1               | 0                  | 24/01/2020              | Removed from RoATP        | LEVY-249        | 24/01/2020            | 24/01/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                            | CategoryLabel                                           | Title                                                                |
    | 10017249 | APPLEVY-249    | 1               | 0                  | Contract Termination Details Updated    | Termination details for a contract have been updated    | Termination details for contract APPLEVY-249:1.0 have been updated   |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017249 | APPLEVY-249    | 1               | 0                  | 24/01/2020              | Removed from RoATP        | LEVY-249        | 24/01/2020            | 24/01/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                            | CategoryLabel                                           | Title                                                                |
    | 10017249 | APPLEVY-249    | 1               | 0                  | Contract Termination Details Updated    | Termination details for a contract have been updated    | Termination details for contract APPLEVY-249:1.0 have been updated   |




    # Check ADP

    # Check all activity has finished
    When  there are no messages left in the system

    # Check that an ActualsUpdated row has not been written to the AllocationDelivery.AllocationDeliveryEntry table
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '4' event for version '1' of contract number 'APPLEVY-249' and allocation number 'LEVY-249'

 


    # Complete the Termination

    # Change the date (This is ignored by CRM but used by .Net)
    Given the override date is '26/11/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination (23893)
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'APPLEVY-249' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract 'APPLEVY-249' Version '1' SubVersion '0' via SDK

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017249 | APPLEVY-249         | 1                     | 0                        | Closed         | Terminated                               | True          | True                | 06/01/2020        | 24/01/2020      | ?             |
    | 10017249 | ESFA-249            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |



    # Tidy up
    And   the override date is reset 

