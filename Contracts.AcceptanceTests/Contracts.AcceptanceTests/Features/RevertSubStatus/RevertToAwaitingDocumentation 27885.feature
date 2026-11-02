Feature: RevertToAwaitingDocumentation 27885

@AcceptanceTest @Withdrawn_21052026
@Long2Run @Long2Run123
Scenario: A177 Create a 1920 AEB contract. Step through Tasks to set desired sub-status then attempt to revert to Awaiting Documentation. Three should succeed and three fail. Check CRM, Tasks and Workflow Histories
    Given there are no allocations marked as Under Termination for UKPRN '10017177' 
    And   there are no terminated or closed allocations for UKPRN '10017177' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017177' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017177' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AETL-177      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | AEB-19TRLS1920 |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017177' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017177 Co Ltd' with UKPRN '10017177' and OrgId 'ORG0017177' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017177' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017177 | 117177 | 10017177 Co Ltd | 0              | Locked Restructure    | Yes           | AA017177      | ?             | 1 Cadogan Square       | ?                      | ?                      | ?                      | Cadogan Street         | Glasgow                | G2 7HF    |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017177 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017177 | 10017177 Co Ltd      | ESFA-177             | AEBP-177       | 1                     | 01/08/2019        | 31/07/2020      | 21347.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017177 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017177 | AEBP-177       | AETL-177      | AEB-19TRLS        | AEB-19TRLS1920          | AY                      | 01/08/2019          | 31/07/2020        | 21347.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017177 | AEBP-177       | AETL-177      | 1               | 0                     | 21347.00  | 2851.00  | 518.00   | 113.00   | 3063.00  | 1616.00  | 2258.00  | 2297.00  | 2179.00  | 2535.00  | 1467.00  | 968.00   | 1482.00  | Adult Education Budget - 19-24 Traineeships Learner Support     | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017177 | AEBP-177           | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017177 | ESFA-177           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |




	# Test 1/6
    # The contract is at 'Awaiting Documentation'. Attempt to REVERT it to 'Awaiting Documentation'. This should not change anything
	
	# Change the date
    Given the override date is '02/07/2019'

#    # Bulk file
#    And   there are no files prefixed '10017177' in the Sharepoint 'AEB-1920-Input-Appendices' folder
#    And   there are no files prefixed 'AEB AY 1920 16102019161913 v3_A177' in the Sharepoint 'Processed' folder
#    And   there are no files prefixed 'AEB AY 1920 16102019161913 v3_A177' in the Sharepoint 'Processing' folder
#    And   there are no files prefixed 'AEB AY 1920 16102019161913 v3_A177' in the Sharepoint 'Reports' folder
#    And   spreadsheet 'AEB AY 1920 16102019161913 v3_A177.xlsx' exists in the Datafiles folder and UKPRN '10017177' is present in cell 'A2' of the Contract tab
#    When  the file is copied to the Sharepoint 'Input' folder 
#    Then  a syntax report should exist in the Sharepoint Reports folder
#    And   a results report should exist in the Sharepoint Reports folder
#    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Create dummy Ts&Cs doc in Sharepoint
    Given there are no files prefixed '10017177' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed '10017177' in the Sharepoint 'AEB-1920-Input-Terms And Conditions' folder
    And   a file with filename '10017177_AEBP-177_v1.pdf' is created in 'AEB-1920-Input-Appendices'
    And   a file with filename '10017177_AEBP-177_11.pdf' is created in 'AEB-1920-Input-Terms And Conditions'

    # Document Manager requests a Contract sub-status reversion (WF39). Currently already at 'Awaiting Documentation' so no changes should occur.  Qn: How will it error, if at all ?
    # (Can be done by Document Managers, Contract Managers and Lead Managers) J079
    When  CRM user 'FCS2 Test' chooses to revert the state of version '1' subversion '0' of contract 'AEBP-177' to Awaiting Documentation

    # Check that the Task on the contract is still open
    Then  the following Tasks are present against version '1' of contract 'AEBP-177' for provider '10017177'
    | Task                                       | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge                    | 10017177 - 10017177 Co Ltd Awaiting documentation           | AEBP-177       | Document Management Team  | ?                        | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017177 | AEBP-177           | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017177 | ESFA-177           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |




	#Test 2/6
	# Move the contract from 'Awaiting Documentation' to 'In Review' by completing the open Task, then REVERT it to 'Awaiting Documentation'. This should succeed

	# Change the date
    Given the override date is '03/07/2019'

	# Delete CRM Tasks that are not Open
    And   there are no Tasks in CRM for version '1' of contract 'AEBP-177' with a State of 'Cancelled' and a Status of 'Cancelled'
	And   there are no Tasks in CRM for version '1' of contract 'AEBP-177' with a State of 'Completed' and a Status of 'Completed'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '1' of contract 'AEBP-177' for provider '10017177' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-177' for provider '10017177'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017177 - 10017177 Co Ltd Please review the contract       | AEBP-177       | FCS2 Test                 | Contract Advisers Team   | Open            | Not Started      |
    | Initiate Document Merge          | 10017177 - 10017177 Co Ltd Awaiting documentation           | AEBP-177       | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017177 | AEBP-177           | 1                     | 0                        | Draft            | In Review                 | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017177 | ESFA-177           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Document Manager requests a Contract sub-status reversion (WF39). This should change the substatus from 'In Review' to 'Awaiting Documentation'
    # (Can be done by Document Managers, Contract Managers and Lead Managers) J079
    When  CRM user 'FCS2 Test' chooses to revert the state of version '1' subversion '0' of contract 'AEBP-177' to Awaiting Documentation

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-177' for provider '10017177'
    | Task                                       | Description                                                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge                    | 10017177 - 10017177 Co Ltd Awaiting documentation               | AEBP-177       | Document Management Team  | ?                        | Open            | Not Started      |
    | Review Contract Details                    | 10017177 - 10017177 Co Ltd Please review the contract           | AEBP-177       | FCS2 TEST                 | Contract Advisers Team   | Canceled        | Canceled         |
    | Initiate Document Merge                    | 10017177 - 10017177 Co Ltd Awaiting documentation               | AEBP-177       | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017177 | AEBP-177           | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017177 | ESFA-177           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'AEBP-177' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                   | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus               |
    | 10017177 | ESFA-177           | AEBP-177       | 1                     | Bulk Revise                                 | FCS2 TEST                     | FCS2 TEST        | Document Management Team    | Draft             | Awaiting Documentation         | FCS2 TEST             | FCS2 TEST                 | Draft          | In Review                       |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-177' version '1' includes the following
    | Action             | CompletedBy                   | Comment                          |
    | Bulk Revise        | FCS2 TEST                     | Bulk contract revision           |





	# Test 3/6
	# Move the contract from 'Awaiting Documentation' to 'Awaiting Internal Approval' by stepping through the Tasks, then REVERT it to 'Awaiting Documentation'. This should succeed

	# Change the date
    Given the override date is '03/07/2019'

	# Delete CRM Tasks that are not Open
    And   there are no Tasks in CRM for version '1' of contract 'AEBP-177' with a State of 'Cancelled' and a Status of 'Cancelled'
	And   there are no Tasks in CRM for version '1' of contract 'AEBP-177' with a State of 'Completed' and a Status of 'Completed'

    # Delete selected Workflow Histories
    And   the following workflow histories against version '1' of contract 'AEBP-177' are removed
    | Action        | CompletedBy         | Comment                          |
    | Bulk Revise   | FCS2 Test           | Bulk contract revision           |
	
	# Create dummy Ts&Cs doc in Sharepoint
    And   there are no files prefixed '10017177' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed '10017177' in the Sharepoint 'AEB-1920-Input-Terms And Conditions' folder
    And   a file with filename '10017177_AEBP-177_v1.pdf' is created in 'AEB-1920-Input-Appendices'
    And   a file with filename '10017177_AEBP-177_11.pdf' is created in 'AEB-1920-Input-Terms And Conditions'
	
	# Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '1' of contract 'AEBP-177' for provider '10017177' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-177' for provider '10017177'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017177 - 10017177 Co Ltd Please review the contract       | AEBP-177       | FCS2 Test                 | Contract Advisers Team   | Open            | Not Started      |
    | Initiate Document Merge          | 10017177 - 10017177 Co Ltd Awaiting documentation           | AEBP-177       | Document Management Team  | ?                        | Completed       | Completed        |

    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '1' of contract 'AEBP-177' for provider '10017177' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-177' for provider '10017177'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017177 - 10017177 Co Ltd                                  | AEBP-177       | FCS1 Test                 | Contract Managers Team   | Open            | Not Started      |
    | Review Contract Details          | 10017177 - 10017177 Co Ltd Please review the contract       | AEBP-177       | FCS2 Test                 | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017177 - 10017177 Co Ltd Awaiting documentation           | AEBP-177       | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus          | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017177 | AEBP-177           | 1                     | 0                        | Draft            | Awaiting Internal Approval | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017177 | ESFA-177           | 1                     | 0                        | Draft            | ?                          | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Document Manager requests a Contract sub-status reversion (WF39). This should change the substatus from 'Awaiting Internal Approval' to 'Awaiting Documentation'
    # (Can be done by Document Managers, Contract Managers and Lead Managers) J079
    When  CRM user 'FCS2 Test' chooses to revert the state of version '1' subversion '0' of contract 'AEBP-177' to Awaiting Documentation

    # Check the current state of the Tasks for this contract
	Then  the following Tasks are present against version '1' of contract 'AEBP-177' for provider '10017177'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge          | 10017177 - 10017177 Co Ltd Awaiting documentation           | AEBP-177       | Document Management Team  | ?                        | Open            | Not Started      |
    | Confirm Internal Approval        | 10017177 - 10017177 Co Ltd                                  | AEBP-177       | FCS1 TEST                 | Contract Managers Team   | Canceled        | Canceled         |
    | Review Contract Details          | 10017177 - 10017177 Co Ltd Please review the contract       | AEBP-177       | FCS2 Test                 | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017177 - 10017177 Co Ltd Awaiting documentation           | AEBP-177       | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017177 | AEBP-177           | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017177 | ESFA-177           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'AEBP-177' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action         | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus          |
    | 10017177 | ESFA-177           | AEBP-177       | 1                     | Bulk Revise    | FCS2 TEST       | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | FCS2 TEST             | FCS1 TEST           | Draft          | Awaiting Internal Approval |


    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-177' version '1' includes the following
    | Action             | CompletedBy               | Comment                          |
    | Bulk Revise        | FCS2 TEST                 | Bulk contract revision           |




	# Test 4/6
	# Move the contract from 'Awaiting Documentation' to 'Internally Approved' by stepping through the Tasks, then REVERT it to 'Awaiting Documentation'. This should succeed

	# Change the date
    Given the override date is '07/07/2019'

    # Delete CRM Tasks that are not Open
    And   there are no Tasks in CRM for version '1' of contract 'AEBP-177' with a State of 'Cancelled' and a Status of 'Cancelled'
    And   there are no Tasks in CRM for version '1' of contract 'AEBP-177' with a State of 'Completed' and a Status of 'Completed'

    # Delete selected Workflow Histories
    And   the following workflow histories against version '1' of contract 'AEBP-177' are removed
    | Action        | CompletedBy         | Comment                          |
    | Bulk Revise   | FCS2 Test           | Bulk contract revision           |
	
	# Create dummy Ts&Cs doc in Sharepoint
    And   there are no files prefixed '10017177' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed '10017177' in the Sharepoint 'AEB-1920-Input-Terms And Conditions' folder
    And   a file with filename '10017177_AEBP-177_v1.pdf' is created in 'AEB-1920-Input-Appendices'
    And   a file with filename '10017177_AEBP-177_11.pdf' is created in 'AEB-1920-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '1' of contract 'AEBP-177' for provider '10017177' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-177' for provider '10017177'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017177 - 10017177 Co Ltd Please review the contract       | AEBP-177       | FCS2 Test                 | Contract Advisers Team   | Open            | Not Started      |
    | Initiate Document Merge          | 10017177 - 10017177 Co Ltd Awaiting documentation           | AEBP-177       | Document Management Team  | ?                        | Completed       | Completed        |

    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '1' of contract 'AEBP-177' for provider '10017177' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-177' for provider '10017177'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017177 - 10017177 Co Ltd                                  | AEBP-177       | FCS1 Test                 | Contract Managers Team   | Open            | Not Started      |
    | Review Contract Details          | 10017177 - 10017177 Co Ltd Please review the contract       | AEBP-177       | FCS2 Test                 | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017177 - 10017177 Co Ltd Awaiting documentation           | AEBP-177       | Document Management Team  | ?                        | Completed       | Completed        |

    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '1' of contract 'AEBP-177' for provider '10017177' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-177' for provider '10017177'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017177 - 10017177 Co Ltd                                  | AEBP-177       | Lead Manager Team         | ?                        | Open            | Not Started      |
    | Confirm Internal Approval        | 10017177 - 10017177 Co Ltd                                  | AEBP-177       | FCS1 Test                 | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details          | 10017177 - 10017177 Co Ltd Please review the contract       | AEBP-177       | FCS2 Test                 | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017177 - 10017177 Co Ltd Awaiting documentation           | AEBP-177       | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus          | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017177 | AEBP-177           | 1                     | 0                        | Draft            | Internally Approved        | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017177 | ESFA-177           | 1                     | 0                        | Draft            | ?                          | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Document Manager requests a Contract sub-status reversion (WF39). This should change the substatus from 'Internally Approved' to 'Awaiting Documentation'
    # (Can be done by Document Managers, Contract Managers and Lead Managers) J079
    When  CRM user 'FCS2 Test' chooses to revert the state of version '1' subversion '0' of contract 'AEBP-177' to Awaiting Documentation

    # Check the current state of the Tasks for this contract
	Then  the following Tasks are present against version '1' of contract 'AEBP-177' for provider '10017177'
    | Task                                       | Description                                                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge                    | 10017177 - 10017177 Co Ltd Awaiting documentation               | AEBP-177       | Document Management Team  | ?                        | Open            | Not Started      |
    | Confirm Publication to Provider            | 10017177 - 10017177 Co Ltd                                      | AEBP-177       | Lead Manager Team         | ?                        | Canceled        | Canceled         |
    | Confirm Internal Approval                  | 10017177 - 10017177 Co Ltd                                      | AEBP-177       | FCS1 TEST                 | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details                    | 10017177 - 10017177 Co Ltd Please review the contract           | AEBP-177       | FCS2 TEST                 | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge                    | 10017177 - 10017177 Co Ltd Awaiting documentation               | AEBP-177       | Document Management Team  | ?                        | Completed       | Completed        |


    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017177 | AEBP-177           | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017177 | ESFA-177           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'AEBP-177' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action         | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus    |
    | 10017177 | ESFA-177           | AEBP-177       | 1                     | Bulk Revise    | FCS2 TEST       | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | FCS2 TEST             | Lead Manager Team   | Draft          | Internally Approved  |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-177' version '1' includes the following
    | Action             | CompletedBy               | Comment                          |
    | Bulk Revise        | FCS2 TEST                 | Bulk contract revision           |




	# Test 5/6
	# Move the contract from 'Awaiting Documentation' to 'Published to Provider' by stepping through the Tasks, then attempt to REVERT it to 'Awaiting Documentation'. This should not change anything

	# Change the date
    Given the override date is '13/07/2019'

    # Delete CRM Tasks that are not Open
    And   there are no Tasks in CRM for version '1' of contract 'AEBP-177' with a State of 'Cancelled' and a Status of 'Cancelled'
    And   there are no Tasks in CRM for version '1' of contract 'AEBP-177' with a State of 'Completed' and a Status of 'Completed'

	# Create dummy Ts&Cs doc in Sharepoint
    And   there are no files prefixed '10017177' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed '10017177' in the Sharepoint 'AEB-1920-Input-Terms And Conditions' folder
    And   a file with filename '10017177_AEBP-177_v1.pdf' is created in 'AEB-1920-Input-Appendices'
    And   a file with filename '10017177_AEBP-177_11.pdf' is created in 'AEB-1920-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '1' of contract 'AEBP-177' for provider '10017177' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-177' for provider '10017177'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017177 - 10017177 Co Ltd Please review the contract       | AEBP-177       | FCS2 Test                 | Contract Advisers Team   | Open            | Not Started      |
    | Initiate Document Merge          | 10017177 - 10017177 Co Ltd Awaiting documentation           | AEBP-177       | Document Management Team  | ?                        | Completed       | Completed        |

    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '1' of contract 'AEBP-177' for provider '10017177' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-177' for provider '10017177'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017177 - 10017177 Co Ltd                                  | AEBP-177       | FCS1 Test                 | Contract Managers Team   | Open            | Not Started      |
    | Review Contract Details          | 10017177 - 10017177 Co Ltd Please review the contract       | AEBP-177       | FCS2 Test                 | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017177 - 10017177 Co Ltd Awaiting documentation           | AEBP-177       | Document Management Team  | ?                        | Completed       | Completed        |

    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '1' of contract 'AEBP-177' for provider '10017177' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-177' for provider '10017177'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017177 - 10017177 Co Ltd                                  | AEBP-177       | Lead Manager Team         | ?                        | Open            | Not Started      |
    | Confirm Internal Approval        | 10017177 - 10017177 Co Ltd                                  | AEBP-177       | FCS1 Test                 | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details          | 10017177 - 10017177 Co Ltd Please review the contract       | AEBP-177       | FCS2 Test                 | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017177 - 10017177 Co Ltd Awaiting documentation           | AEBP-177       | Document Management Team  | ?                        | Completed       | Completed        |

    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When  the following open Task currently linked to version '1' of contract 'AEBP-177' for provider '10017177' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |


    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-177' for provider '10017177'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017177 - 10017177 Co Ltd                                  | AEBP-177       | Lead Manager Team         | ?                        | Completed       | Completed        |
    | Confirm Internal Approval        | 10017177 - 10017177 Co Ltd                                  | AEBP-177       | FCS1 TEST                 | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details          | 10017177 - 10017177 Co Ltd  Please review the contract      | AEBP-177       | FCS2 TEST                 | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017177 - 10017177 Co Ltd  Awaiting documentation          | AEBP-177       | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017177 | AEBP-177           | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017177 | ESFA-177           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |


    # Document Manager requests a Contract sub-status reversion (WF39). This should not change anything.  Qn: How will it error, if at all ?
    # (Can be done by Document Managers, Contract Managers and Lead Managers) J079
    When  CRM user 'FCS2 Test' chooses to revert the state of version '1' subversion '0' of contract 'AEBP-177' to Awaiting Documentation

    # Check the current state of the Tasks for this contract
	Then  the following Tasks are present against version '1' of contract 'AEBP-177' for provider '10017177'
    | Task                                       | Description                                                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider            | 10017177 - 10017177 Co Ltd                                      | AEBP-177       | Lead Manager Team         | ?                        | Completed       | Completed        |
    | Confirm Internal Approval                  | 10017177 - 10017177 Co Ltd                                      | AEBP-177       | FCS1 TEST                 | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details                    | 10017177 - 10017177 Co Ltd Please review the contract           | AEBP-177       | FCS2 TEST                 | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge                    | 10017177 - 10017177 Co Ltd Awaiting documentation               | AEBP-177       | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017177 | AEBP-177           | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017177 | ESFA-177           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'AEBP-177' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action         | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017177 | ESFA-177           | AEBP-177       | 1                     | Bulk Revise    | FCS2 TEST       | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | FCS2 TEST             | Lead Manager Team   | Draft          | Internally Approved |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-177' version '1' includes the following
    | Action             | CompletedBy               | Comment                          |
    | Bulk Revise        | FCS2 TEST                 | Bulk contract revision           |




	# Test 6/6
	# Approve to contract, then attempt to REVERT it to 'Awaiting Documentation'. This should not change anything

    # Change the date
    Given the override date is '22/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-177' and actual ContractNumber 'AEBP-177'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-177' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017177 | AEBP-177           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017177 | ESFA-177           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Document Manager requests a Contract sub-status reversion (WF39). This should not change anything.  Qn: How will it error, if at all ?
    # (Can be done by Document Managers, Contract Managers and Lead Managers) J079
    When  CRM user 'FCS2 Test' chooses to revert the state of version '1' subversion '0' of contract 'AEBP-177' to Awaiting Documentation

    # Check the current state of the Tasks for this contract
	Then  the following Tasks are present against version '1' of contract 'AEBP-177' for provider '10017177'
    | Task                                       | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider            | 10017177 - 10017177 Co Ltd                                  | AEBP-177       | Lead Manager Team         | ?                        | Completed       | Completed        |
    | Confirm Internal Approval                  | 10017177 - 10017177 Co Ltd                                  | AEBP-177       | FCS1 TEST                 | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details                    | 10017177 - 10017177 Co Ltd Please review the contract       | AEBP-177       | FCS2 TEST                 | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge                    | 10017177 - 10017177 Co Ltd Awaiting documentation           | AEBP-177       | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017177 | AEBP-177           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017177 | ESFA-177           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'AEBP-177' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action         | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus   |
    | 10017177 | ESFA-177           | AEBP-177       | 1                     | Bulk Revise    | FCS2 TEST       | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | FCS2 TEST             | Lead Manager Team   | Draft          | Internally Approved |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-177' version '1' includes the following
    | Action             | CompletedBy               | Comment                          |
    | Bulk Revise        | FCS2 TEST                 | Bulk contract revision           |


	
    # Note: Not making any changes in Sharepoint

    # Tidy up
    And   the override date is reset

