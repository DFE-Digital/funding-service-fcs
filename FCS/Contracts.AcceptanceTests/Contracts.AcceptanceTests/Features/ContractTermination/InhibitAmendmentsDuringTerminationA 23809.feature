Feature: InhibitAmendmentsDuringTerminationA 23809

@AcceptanceTest @Withdrawn20200604
@Long2Run @Long2Run67
@PublishNewLevyContract
@UiTest
Scenario: A775SLD Create and approve a LEVY contract. Initiate termination (without amendment). Unsuccessfully attempt to amend the contract (bulk and singleton) (Notification and No x2) while at awaiting termination approval. Approve termination by completing the open task. Check CRM and CM feed. Consume actuals before and after termination date. Check CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017775'
	And   there is no Contract, Task or Workflow data for UKPRN '10017775' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017775'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017775'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
    And   the Contract Management atom feed is empty
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017775'
  


   # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017775'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017775 Co Ltd' with UKPRN '10017775' and OrgId 'ORG0017775' and has 'FCS1 Test' as a manager
    And   UPIN '117775' is associated with UKPRN '10017775' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017775 | 117775 | 10017775 Co Ltd | 0              | Active |

    # Set RoATP data (needed for amendment checks) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.
    And   the following providers exist on RoATP
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
    | 10017775 | 10017775 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    




    # Change the date 
    Given the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42864 | INITIATED | 2017-09-15T18:03:12.2539 | 10017775   | 28993             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017775'
    And   there is only one Levy contract in CRM for UKPRN '10017775' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017775 | 10017775 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017775 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017775 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
	| 10017775 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription              | 
    | 10017775 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships    | 
    | 10017775 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships    |
	| 10017775 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017775 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |


	# Retrieve parameters
	And   I retrieve the latest contract details from CRM for provider '10017775' for FundingType 'LEVY' and period '1799'

    # Check deliverable period count prior to approval
    And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Change the date 
    Given the override date is '02/01/2021'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    # Check deliverable period count after approval
    Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # After approval there should be a Jan-21 deliverable period for each of deliverables 1 through 14 for each allocation 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Jan-21   | DeliverableDescription                               | 
    | 10017775 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017775 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017775 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017775 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017775 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017775 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017775 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017775 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017775 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017775 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017775 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017775 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017775 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017775 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017775 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017775 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017775 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017775 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017775 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017775 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017775 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017775 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017775 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017775 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017775 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017775 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017775 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017775 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 
 
    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017775 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 02/01/2021        | ?               | ?             |
    | 10017775 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017775 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 02/01/2021          | ?                 |




	# Initiate a TERMINATION

    # Change the date
    And   the override date is '16/01/2021'

    # Request termination of the contract via the CRM UI
    When  CRM user 'FCS8 Test' initiates contract termination for Contract '[ContractNo]' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | TerminationReason | TerminationComments |
    | 01/03/2021               | 31/03/2021              | Provider Change   | Company sold        |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | [AllocRef_LEVY]  | 28/03/2021                  | 29/03/2021                |
	
	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
    And   the user forwards the termination request for manager approval via UI
#   And   the user forwards the termination request for manager approval via SDK

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017775 | [ContractNo]       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 02/01/2021        | ?               | ?             |
    | 10017775 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments  |
    | [ContractNo]   | 1                     | 0                        | 31/03/2021              | Company sold         |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | [AllocRef_LEVY]  | 1                     | 0                        | 28/03/2021        | 29/03/2021                |
    
    # Has a Termination Initiation Task been created ?
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017775'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017775 - 10017775 Co Ltd     | [ContractNo]   | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Has a Termination Initiation Workflow History entry been created ?
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Initiate Contract Termination                  | FCS8 Test           | Company sold                     |
	



	# Attempt to amend the contract while it is at 'Awaiting Termination Initiation Approval'  (24546)

	# Attempt an amendment using the bulk method
   #When  a request is issued to amend the following Levy contract via Single
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus                                | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination |	ShouldMergeAmendmentTemplate |
    | 10017775 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Awaiting Termination Initiation Approval | Notification  | No                       | Yes                   |	Yes                          |

	# Check that the amendment has failed and the approved contract is still at 'Awaiting Termination Initiation Approval'
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017775 | [ContractNo]       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 02/01/2021        | ?               | ?             |

	# Check that a notification has been created
	And   there is '1' notification of type 'Contract Amendment Failed' owned by user 'FCS8 Test' which matches the following
    | Status | NotificationName                         | NotificationText                                                                                                                             |
    | New    | Contract Amendment Failed - [ContractNo] | Contract [ContractNo] v1 for provider 10017775 (10017775 Co Ltd) cannot be amended - contract is awaiting approval of termination initiation |
	



#	# Delete the notification created above
#	Given there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017775'

	# Attempt an amendment using the singleton method
    When  a request is issued to amend the following Levy contract via Single
   #When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus                                | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017775 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Awaiting Termination Initiation Approval | Notification  | No                       | Yes                          |

	# Check that the amendment has failed and the approved contract is still at 'Awaiting Termination Initiation Approval'
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017775 | [ContractNo]       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 02/01/2021        | ?               | ?             |

	# Check that a second notification has been created
	And   there are '2' notifications of type 'Contract Amendment Failed' owned by user 'FCS8 Test' which match the following
    | Status | NotificationName                         | NotificationText                                                                                                                             |
    | New    | Contract Amendment Failed - [ContractNo] | Contract [ContractNo] v1 for provider 10017775 (10017775 Co Ltd) cannot be amended - contract is awaiting approval of termination initiation |




    # Change the date
    Given the override date is '18/01/2021'

    # Complete an existing open Task to approve the termination initiation
    When  the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017775' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017775'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017775 - 10017775 Co Ltd      | [ContractNo]   | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
    | Initiate Contract Termination                  | FCS8 Test           | Company sold                     |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017775 | [ContractNo]       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 02/01/2021        | ?               | ?             |
    | 10017775 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |




    # Check the CM feed for the presence of an ItemType 4 (Termination Initiation) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number '[ContractNo]'
    And   the ItemType '4' event for version '1' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
	
    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef    | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017775 | [ContractNo]   | 1               | 0                  | 31/03/2021              | Provider Change           | [AllocRef_LEVY]  | 28/03/2021            | 29/03/2021                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                      |
    | 10017775 | [ContractNo]   | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract [ContractNo]:1.0 was placed under termination     |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef    | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017775 | [ContractNo]   | 1               | 0                  | 31/03/2021              | Provider Change           | [AllocRef_LEVY]  | 28/03/2021            | 29/03/2021                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                      |
    | 10017775 | [ContractNo]   | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract [ContractNo]:1.0 was placed under termination     |




    # Actuals for Mar 21

    # Change the date
    Given the override date is '04/04/2021'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017775'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And  there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull 'actuals' from DC for Mar 2021. These should go through ok
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS48               | ORG0017775     | CM             | 202103 | LEVY1799                | [AllocRef_LEVY]          | ?          | 2               | 0            | 220.66      |
    | APPS           | APPS48               | ORG0017775     | CM             | 202103 | LEVY1799                | [AllocRef_LEVY]          | ?          | 3               | 0            | 838.14      |
    | APPS           | APPS48               | ORG0017775     | CM             | 202103 | LEVY1799                | [AllocRef_LEVY]          | ?          | 4               | 0            | 367.16      |
    | APPS           | APPS48               | ORG0017775     | CM             | 202103 | LEVY1799                | [AllocRef_LEVY]          | ?          | 5               | 0            | 1048.21     |
    | APPS           | APPS48               | ORG0017775     | CM             | 202103 | LEVY1799                | [AllocRef_LEVY]          | ?          | 6               | 0            | 763.20      |
    | APPS           | APPS48               | ORG0017775     | CM             | 202103 | LEVY1799                | [AllocRef_LEVY]          | ?          | 8               | 0            | 456.39      |
    | APPS           | APPS48               | ORG0017775     | CM             | 202103 | LEVY1799                | [AllocRef_LEVY]          | ?          | 9               | 0            | 924.86      |
    | APPS           | APPS48               | ORG0017775     | CM             | 202103 | LEVY1799                | [AllocRef_LEVY]          | ?          | 10              | 0            | 1487.79     |
    | APPS           | APPS48               | ORG0017775     | CM             | 202103 | LEVY1799                | [AllocRef_LEVY]          | ?          | 11              | 0            | 456.54      |
    | APPS           | APPS48               | ORG0017775     | CM             | 202103 | LEVY1799                | [AllocRef_LEVY]          | ?          | 12              | 0            | 1490.19     |
    | APPS           | APPS48               | ORG0017775     | CM             | 202103 | LEVY1799                | [AllocRef_LEVY]          | ?          | 13              | 0            | 632.04      |
    | APPS           | APPS48               | ORG0017775     | CM             | 202103 | LEVY1799                | [AllocRef_LEVY]          | ?          | 14              | 0            | 1290.62     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the deliverable count in CRM 
    Then  there are '40' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef        | DeliverableCode | Total    | Jan-21   |
    | [ContractNo]   | [AllocRef_LEVY]      | 1               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 7               | 0.00     | ?        | 

    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef        | DeliverableCode | Total    | Jan-21   | Mar-21   |
    | [ContractNo]   | [AllocRef_LEVY]      | 2               | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 3               | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 4               | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 5               | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 6               | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 8               | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 9               | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 10              | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 11              | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 12              | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 13              | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 14              | 0.00     | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef        | DeliverableCode | Total    | Jan-21   |
    | [ContractNo]   | [AllocRef_LEVY]      | 1               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 7               | 0.00     | ?        | 

    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef        | DeliverableCode | Total    | Jan-21   | Mar-21   |
    | [ContractNo]   | [AllocRef_LEVY]      | 2               | 220.66   | ?        | 220.66   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 3               | 838.14   | ?        | 838.14   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 4               | 367.16   | ?        | 367.16   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 5               | 1048.21  | ?        | 1048.21  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 6               | 763.20   | ?        | 763.20   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 8               | 456.39   | ?        | 456.39   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 9               | 924.86   | ?        | 924.86   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 10              | 1487.79  | ?        | 1487.79  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 11              | 456.54   | ?        | 456.54   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 12              | 1490.19  | ?        | 1490.19  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 13              | 632.04   | ?        | 632.04   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 14              | 1290.62  | ?        | 1290.62  | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef        | DeliverableCode | Total    | Jan-21   |
    | [ContractNo]   | [AllocRef_LEVY]      | 1               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 7               | 0.00     | ?        | 

    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef        | DeliverableCode | Total    | Jan-21   | Mar-21   |
    | [ContractNo]   | [AllocRef_LEVY]      | 2               | 220.66   | ?        | 220.66   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 3               | 838.14   | ?        | 838.14   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 4               | 367.16   | ?        | 367.16   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 5               | 1048.21  | ?        | 1048.21  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 6               | 763.20   | ?        | 763.20   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 8               | 456.39   | ?        | 456.39   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 9               | 924.86   | ?        | 924.86   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 10              | 1487.79  | ?        | 1487.79  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 11              | 456.54   | ?        | 456.54   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 12              | 1490.19  | ?        | 1490.19  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 13              | 632.04   | ?        | 632.04   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 14              | 1290.62  | ?        | 1290.62  | 
	
    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber      | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | [AllocRef_LEVY]       | 1             | 1               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 2               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 3               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 4               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 5               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 6               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 7               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 8               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 9               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 10              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 11              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 12              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 13              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 14              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    #
    | [AllocRef_LEVY]       | 1             | 2               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 220.66                      | 220.66           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 3               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 838.14                      | 838.14           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 4               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 367.16                      | 367.16           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 5               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1048.21                     | 1048.21          | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 6               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 763.20                      | 763.20           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 8               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 456.39                      | 456.39           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 9               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 924.86                      | 924.86           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 10              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1487.79                     | 1487.79          | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 11              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 456.54                      | 456.54           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 12              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1490.19                     | 1490.19          | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 13              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 632.04                      | 632.04           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 14              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1290.62                     | 1290.62          | ?            | 0.00        |


	

	# Actuals for Apr-21

	# Change the date
    Given the override date is '04/05/2021'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017775'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull 'actuals' from DC for Apr 2021, ie after the termination date. These should go through too
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber      | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS49               | ORG0017775     | CM             | 202104 | LEVY1799                | [AllocRef_LEVY]               | ?          | 2               | 0            | 424.95      |
    | APPS           | APPS49               | ORG0017775     | CM             | 202104 | LEVY1799                | [AllocRef_LEVY]               | ?          | 3               | 0            | 1004.24     |
    | APPS           | APPS49               | ORG0017775     | CM             | 202104 | LEVY1799                | [AllocRef_LEVY]               | ?          | 4               | 0            | 1382.00     |
    | APPS           | APPS49               | ORG0017775     | CM             | 202104 | LEVY1799                | [AllocRef_LEVY]               | ?          | 5               | 0            | 114.31      |
    | APPS           | APPS49               | ORG0017775     | CM             | 202104 | LEVY1799                | [AllocRef_LEVY]               | ?          | 6               | 0            | 1083.11     |
    | APPS           | APPS49               | ORG0017775     | CM             | 202104 | LEVY1799                | [AllocRef_LEVY]               | ?          | 8               | 0            | 992.02      |
    | APPS           | APPS49               | ORG0017775     | CM             | 202104 | LEVY1799                | [AllocRef_LEVY]               | ?          | 9               | 0            | 1481.92     |
    | APPS           | APPS49               | ORG0017775     | CM             | 202104 | LEVY1799                | [AllocRef_LEVY]               | ?          | 10              | 0            | 1374.88     |
    | APPS           | APPS49               | ORG0017775     | CM             | 202104 | LEVY1799                | [AllocRef_LEVY]               | ?          | 11              | 0            | 1370.52     |
    | APPS           | APPS49               | ORG0017775     | CM             | 202104 | LEVY1799                | [AllocRef_LEVY]               | ?          | 12              | 0            | 872.53      |
    | APPS           | APPS49               | ORG0017775     | CM             | 202104 | LEVY1799                | [AllocRef_LEVY]               | ?          | 13              | 0            | 1362.19     |
    | APPS           | APPS49               | ORG0017775     | CM             | 202104 | LEVY1799                | [AllocRef_LEVY]               | ?          | 14              | 0            | 718.58      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the deliverable count in CRM 
	# Can't check the CRM values directly for Apr19 because there are no rows there to check - this is good but inconvenient. Count rows instead 
    Then  there are '52' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'


    # Check the ACTUAL VALUES in CRM
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef        | DeliverableCode | Total    | Jan-21   |
    | [ContractNo]   | [AllocRef_LEVY]      | 1               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 7               | 0.00     | ?        | 

    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef        | DeliverableCode | Total    | Jan-21   | Mar-21   | Apr-21   |
    | [ContractNo]   | [AllocRef_LEVY]      | 2               | 0.00     | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 3               | 0.00     | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 4               | 0.00     | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 5               | 0.00     | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 6               | 0.00     | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 8               | 0.00     | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 9               | 0.00     | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 10              | 0.00     | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 11              | 0.00     | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 12              | 0.00     | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 13              | 0.00     | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 14              | 0.00     | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef        | DeliverableCode | Total    | Jan-21   |
    | [ContractNo]   | [AllocRef_LEVY]      | 1               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 7               | 0.00     | ?        | 

    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef        | DeliverableCode | Total    | Jan-21   | Mar-21   | Apr-21   |
    | [ContractNo]   | [AllocRef_LEVY]      | 2               | 645.61   | ?        | 220.66   | 424.95   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 3               | 1842.38  | ?        | 838.14   | 1004.24  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 4               | 1749.16  | ?        | 367.16   | 1382.00  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 5               | 1162.52  | ?        | 1048.21  | 114.31   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 6               | 1846.31  | ?        | 763.20   | 1083.11  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 8               | 1448.41  | ?        | 456.39   | 992.02   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 9               | 2406.78  | ?        | 924.86   | 1481.92  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 10              | 2862.67  | ?        | 1487.79  | 1374.88  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 11              | 1827.06  | ?        | 456.54   | 1370.52  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 12              | 2362.72  | ?        | 1490.19  | 872.53   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 13              | 1994.23  | ?        | 632.04   | 1362.19  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 14              | 2009.20  | ?        | 1290.62  | 718.58   | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef        | DeliverableCode | Total    | Jan-21   |
    | [ContractNo]   | [AllocRef_LEVY]      | 1               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]      | 7               | 0.00     | ?        | 

    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef        | DeliverableCode | Total    | Jan-21   | Mar-21   | Apr-21   |
    | [ContractNo]   | [AllocRef_LEVY]      | 2               | 645.61   | ?        | 220.66   | 424.95   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 3               | 1842.38  | ?        | 838.14   | 1004.24  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 4               | 1749.16  | ?        | 367.16   | 1382.00  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 5               | 1162.52  | ?        | 1048.21  | 114.31   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 6               | 1846.31  | ?        | 763.20   | 1083.11  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 8               | 1448.41  | ?        | 456.39   | 992.02   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 9               | 2406.78  | ?        | 924.86   | 1481.92  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 10              | 2862.67  | ?        | 1487.79  | 1374.88  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 11              | 1827.06  | ?        | 456.54   | 1370.52  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 12              | 2362.72  | ?        | 1490.19  | 872.53   | 
    | [ContractNo]   | [AllocRef_LEVY]      | 13              | 1994.23  | ?        | 632.04   | 1362.19  | 
    | [ContractNo]   | [AllocRef_LEVY]      | 14              | 2009.20  | ?        | 1290.62  | 718.58   | 
	

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber      | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | [AllocRef_LEVY]       | 1             | 1               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 2               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 3               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 4               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 5               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 6               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 7               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 8               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 9               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 10              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 11              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 12              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 13              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]       | 1             | 14              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    #
    | [AllocRef_LEVY]       | 1             | 2               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 220.66                      | 220.66           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 3               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 838.14                      | 838.14           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 4               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 367.16                      | 367.16           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 5               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1048.21                     | 1048.21          | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 6               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 763.20                      | 763.20           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 8               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 456.39                      | 456.39           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 9               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 924.86                      | 924.86           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 10              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1487.79                     | 1487.79          | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 11              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 456.54                      | 456.54           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 12              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1490.19                     | 1490.19          | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 13              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 632.04                      | 632.04           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 14              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1290.62                     | 1290.62          | ?            | 0.00        |
    #
    | [AllocRef_LEVY]       | 1             | 2               | 202104 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 424.95                      | 424.95           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 3               | 202104 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1004.24                     | 1004.24          | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 4               | 202104 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1382.00                     | 1382.00          | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 5               | 202104 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 114.31                      | 114.31           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 6               | 202104 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1083.11                     | 1083.11          | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 8               | 202104 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 992.02                      | 992.02           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 9               | 202104 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1481.92                     | 1481.92          | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 10              | 202104 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1374.88                     | 1374.88          | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 11              | 202104 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1370.52                     | 1370.52          | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 12              | 202104 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 872.53                      | 872.53           | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 13              | 202104 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1362.19                     | 1362.19          | ?            | 0.00        |
    | [AllocRef_LEVY]       | 1             | 14              | 202104 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 718.58                      | 718.58           | ?            | 0.00        |

    # Count the rows in PaaS to show that the above is all there is, ie 38 rows
    And   there is '1' deliverable period on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '1'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '2'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '3'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '4'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '5'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '6'

    And   there is '1' deliverable period on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '7'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '8'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '9'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '10'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '11'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '12'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '13'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '14'



    # Tidy up
    And   the override date is reset
	 
@AcceptanceTest @Withdrawn20230123
Scenario: A776 Create and approve an 1819 LOANS contract. Initiate termination (without amendment) through the SDK then approve same by completing the open task. Consume actuals before and after the termination date. Check CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017776' 
    And   there are no terminated or closed allocations for UKPRN '10017776' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017776' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-776      |

    # Clear down PaymentSchedule.DeliverablePayment data for an allocation
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-776      |

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS




    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017776' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017776 Co Ltd' with UKPRN '10017776' and OrgId 'ORG0017776' and has 'FCS1 Test' as a manager 
    And   UPIN '117776' is associated with UKPRN '10017776' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017776 | 117776 | 10017776 Co Ltd | 0              | Active | Yes           | AA017776      | ?             | 




    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017776 | 10017776 Co Ltd      | ESFA-776             | LOANS-776      | 1                     | 01/08/2018        | 31/07/2019      | 23741.00      |                                | Contract for Services | 1819   | New          | ORG0017776 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017776 | LOANS-776      | ALLF-776      | ALLF              | ALLF1819                | AY                      | 01/08/2018          | 31/07/2019        | 23741.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017776 | LOANS-776      | ALLF-776      | 5               | 0                     | 23741.00  | 3456.00  | 2769.00  | 2111.00  | 3100.00  | 135.00   | 2610.00  | 2586.00  | 1677.00  | 703.00   | 2640.00  | 530.00   | 1424.00  | Advanced Learner Loans Facility                                 | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'LOANS-776' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-776' and actual ContractNumber 'LOANS-776'

    # Check that the contract is now approved
    Then  the latest version of contract 'LOANS-776' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017776 | LOANS-776          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017776 | ESFA-776           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'LOANS-776'




    # Initiate Termination
	
    # Change the date
    Given the override date is '07/10/2018'

    # Request termination of the contract via the CRM UI
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'LOANS-776' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 08/10/2018               | 16/11/2018              | No                          | Provider Change         | Provider request        |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ALLF-776         | 08/10/2018                  | 16/11/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'LOANS-776' for UKPRN '10017776'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017776 - 10017776 Co Ltd     | LOANS-776      | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017776 | LOANS-776          | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017776 | ESFA-776           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | LOANS-776      | 1                     | 0                        | 16/11/2018              | Provider request        |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | ALLF-776         | 1                     | 0                        | 08/10/2018        | 16/11/2018                |

    
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'LOANS-776' for provider '10017776'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017776 - 10017776 Co Ltd     | LOANS-776      | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'LOANS-776' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | Provider request                 |




    # Change the date
    Given the override date is '08/10/2018'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'LOANS-776' for provider '10017776' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'LOANS-776' for provider '10017776'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017776 - 10017776 Co Ltd      | LOANS-776      | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'LOANS-776' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Provider request                 |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017776 | LOANS-776      | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017776 | ESFA-776       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the CM feed for the presence of an ItemType 4 (Termination Initiation) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number 'LOANS-776'
    And   the ItemType '4' event for version '1' of actual contract number 'LOANS-776' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017776 | LOANS-776      | 1               | 0                  | 16/11/2018              | Provider Change           | ALLF-776        | 08/10/2018            | 16/11/2018                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                   |
    | 10017776 | LOANS-776      | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract LOANS-776:1.0 was placed under termination     |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017776 | LOANS-776      | 1               | 0                  | 16/11/2018              | Provider Change           | ALLF-776        | 08/10/2018            | 16/11/2018                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                   |
    | 10017776 | LOANS-776      | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract LOANS-776:1.0 was placed under termination     |



    # Exclude actuals beyond termination date (23914)


    # Change the date
    Given the override date is '04/01/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017776'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Dec 2018 (Figures up to Nov18 should be processed. Dec18 and beyond should be discarded)
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201808 | ALLF1819                | ALLF-776                 | ?          | 2               | 0            | 1635.80     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201808 | ALLF1819                | ALLF-776                 | ?          | 6               | 0            | 2072.64     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201808 | ALLF1819                | ALLF-776                 | ?          | 7               | 0            | 703.97      |
    #
    | ILR1819        | R03                  | ORG0017776     | CM             | 201809 | ALLF1819                | ALLF-776                 | ?          | 2               | 0            | 634.41      |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201809 | ALLF1819                | ALLF-776                 | ?          | 6               | 0            | 2419.71     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201809 | ALLF1819                | ALLF-776                 | ?          | 7               | 0            | 1184.01     |
    #
    | ILR1819        | R03                  | ORG0017776     | CM             | 201810 | ALLF1819                | ALLF-776                 | ?          | 2               | 0            | 1980.58     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201810 | ALLF1819                | ALLF-776                 | ?          | 6               | 0            | 1572.37     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201810 | ALLF1819                | ALLF-776                 | ?          | 7               | 0            | 302.52      |
    #
    | ILR1819        | R03                  | ORG0017776     | CM             | 201811 | ALLF1819                | ALLF-776                 | ?          | 2               | 0            | 1245.50     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201811 | ALLF1819                | ALLF-776                 | ?          | 6               | 0            | 2066.25     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201811 | ALLF1819                | ALLF-776                 | ?          | 7               | 0            | 1105.03     |
    #
    | ILR1819        | R03                  | ORG0017776     | CM             | 201812 | ALLF1819                | ALLF-776                 | ?          | 2               | 0            | 535.59      |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201812 | ALLF1819                | ALLF-776                 | ?          | 6               | 0            | 2253.14     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201812 | ALLF1819                | ALLF-776                 | ?          | 7               | 0            | 1722.83     |
    #
    | ILR1819        | R03                  | ORG0017776     | CM             | 201901 | ALLF1819                | ALLF-776                 | ?          | 2               | 0            | 1896.81     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201901 | ALLF1819                | ALLF-776                 | ?          | 6               | 0            | 1875.69     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201901 | ALLF1819                | ALLF-776                 | ?          | 7               | 0            | 2086.57     |
    #
    | ILR1819        | R03                  | ORG0017776     | CM             | 201902 | ALLF1819                | ALLF-776                 | ?          | 2               | 0            | 861.41      |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201902 | ALLF1819                | ALLF-776                 | ?          | 6               | 0            | 1964.45     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201902 | ALLF1819                | ALLF-776                 | ?          | 7               | 0            | 222.56      |
    #
    | ILR1819        | R03                  | ORG0017776     | CM             | 201903 | ALLF1819                | ALLF-776                 | ?          | 2               | 0            | 2396.52     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201903 | ALLF1819                | ALLF-776                 | ?          | 6               | 0            | 2479.81     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201903 | ALLF1819                | ALLF-776                 | ?          | 7               | 0            | 2064.55     |
    #
    | ILR1819        | R03                  | ORG0017776     | CM             | 201904 | ALLF1819                | ALLF-776                 | ?          | 2               | 0            | 2456.46     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201904 | ALLF1819                | ALLF-776                 | ?          | 6               | 0            | 692.31      |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201904 | ALLF1819                | ALLF-776                 | ?          | 7               | 0            | 400.02      |
    #
    | ILR1819        | R03                  | ORG0017776     | CM             | 201905 | ALLF1819                | ALLF-776                 | ?          | 2               | 0            | 1681.04     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201905 | ALLF1819                | ALLF-776                 | ?          | 6               | 0            | 2475.55     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201905 | ALLF1819                | ALLF-776                 | ?          | 7               | 0            | 2229.38     |
    #
    | ILR1819        | R03                  | ORG0017776     | CM             | 201906 | ALLF1819                | ALLF-776                 | ?          | 2               | 0            | 1205.81     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201906 | ALLF1819                | ALLF-776                 | ?          | 6               | 0            | 412.69      |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201906 | ALLF1819                | ALLF-776                 | ?          | 7               | 0            | 1033.50     |
    #
    | ILR1819        | R03                  | ORG0017776     | CM             | 201907 | ALLF1819                | ALLF-776                 | ?          | 2               | 0            | 1296.73     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201907 | ALLF1819                | ALLF-776                 | ?          | 6               | 0            | 1180.13     |
    | ILR1819        | R03                  | ORG0017776     | CM             | 201907 | ALLF1819                | ALLF-776                 | ?          | 7               | 0            | 2360.65     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service 

   # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-776      | ALLF-776        | 2               | 5496.29  | 1635.80  | 634.41   | 1980.58  | 1245.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-776      | ALLF-776        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-776      | ALLF-776        | 6               | 8130.97  | 2072.64  | 2419.71  | 1572.37  | 2066.25  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-776      | ALLF-776        | 7               | 3295.53  | 703.97   | 1184.01  | 302.52   | 1105.03  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM
	# Actuals are not paid by the SFA but Reconciliation fields will have non-zero values for deliverable 7 to reflect what has been paid by the Student Loans Company 
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-776      | ALLF-776        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-776      | ALLF-776        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-776      | ALLF-776        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-776      | ALLF-776        | 7               | 3295.53  | 703.97   | 1184.01  | 302.52   | 1105.03  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-776      | ALLF-776        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-776      | ALLF-776        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-776      | ALLF-776        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-776      | ALLF-776        | 7               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
	# Actuals are not paid by the SFA but Net fields will have non-zero values for deliverable 7 to reflect what has been paid by the Student Loans Company 
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-776      | ALLF-776        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-776      | ALLF-776        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-776      | ALLF-776        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-776      | ALLF-776        | 7               | 3295.53  | 703.97   | 1184.01  | 302.52   | 1105.03  | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 


    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | ALLF-776         | 1             | 2               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1635.80     |
    | ALLF-776         | 1             | 2               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 634.41      |
    | ALLF-776         | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1980.58     |
    | ALLF-776         | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1245.50     |
    | ALLF-776         | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 2               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 2               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 2               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 2               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    #
    | ALLF-776         | 1             | 5               | 201808 | 2              | 0             | 3456.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 5               | 201809 | 2              | 0             | 2769.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 5               | 201810 | 2              | 0             | 2111.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 5               | 201811 | 2              | 0             | 3100.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 5               | 201812 | 2              | 0             | 135.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 5               | 201901 | 2              | 0             | 2610.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 5               | 201902 | 2              | 0             | 2586.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 5               | 201903 | 2              | 0             | 1677.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 5               | 201904 | 2              | 0             | 703.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 5               | 201905 | 2              | 0             | 2640.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 5               | 201906 | 2              | 0             | 530.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 5               | 201907 | 2              | 0             | 1424.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    #
    | ALLF-776         | 1             | 6               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2072.64     |
    | ALLF-776         | 1             | 6               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2419.71     |
    | ALLF-776         | 1             | 6               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1572.37     |
    | ALLF-776         | 1             | 6               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2066.25     |
    | ALLF-776         | 1             | 6               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 6               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 6               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 6               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 6               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 6               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 6               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 6               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    #
    | ALLF-776         | 1             | 7               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 703.97                      | 703.97           | 0            | 703.97      |
    | ALLF-776         | 1             | 7               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1184.01                     | 1184.01          | 0            | 1184.01     |
    | ALLF-776         | 1             | 7               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 302.52                      | 302.52           | 0            | 302.52      |
    | ALLF-776         | 1             | 7               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1105.03                     | 1105.03          | 0            | 1105.03     |
    | ALLF-776         | 1             | 7               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 7               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 7               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 7               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 7               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 7               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 7               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | ALLF-776         | 1             | 7               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |

    # Tidy up
	And   the override date is reset

	       