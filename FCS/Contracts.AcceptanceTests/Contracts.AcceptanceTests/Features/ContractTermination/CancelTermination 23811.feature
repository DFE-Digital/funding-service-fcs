Feature: CancelTermination 23811

@AcceptanceTest @Complete 
Scenario: A771 Create and approve a Levy contract. Initiate termination (without amendment) then approve the initiation by completing the open task. Cancel termination. Check CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017771' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017771' 
	And   the Contract Management atom feed is empty
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017771' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017771 Co Ltd' with UKPRN '10017771' and OrgId 'ORG0017771' and has 'FCS1 Test' as a manager 
    And   UPIN '117771' is associated with UKPRN '10017771' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017771 | 117771 | 10017771 Co Ltd | 0              | Active | Yes           | AA017771      | ?             | 

    # Set RoATP data 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.
    And   the following providers exist on RoATP
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
    | 10017771 | 10017771 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    




    # Change the date 
    Given the override date is '16/05/2018'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 47264 | INITIATED | 2017-09-15T18:03:12.2539 | 10017771   | 72893             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017771'
    And   there is only one Levy contract in CRM for UKPRN '10017771' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017771 | 10017771 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017771 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017771 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
    | 10017771 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                  | 
    | 10017771 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships        | 
    | 10017771 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships        | 
    | 10017771 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017771 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017771' for FundingType 'LEVY' and period '1799'

    ## Check deliverable period count prior to approval
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus     | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017771 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider | True          | False               | 01/05/2017        | ?               | ?             |
    | 10017771 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                     | False         | False               | 01/05/2017        | ?               | ?             |




    # Change the date
    Given the override date is '01/08/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    ## Check the deliverable count in CRM
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # After approval there should be a Aug-20 deliverable period for each of deliverables 1 through 14 for each allocation
    Then  the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Aug-20   | DeliverableDescription                               | 
    | 10017771 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017771 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017771 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017771 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017771 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017771 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017771 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017771 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017771 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017771 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017771 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017771 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017771 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017771 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017771 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017771 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017771 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017771 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017771 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017771 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017771 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017771 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017771 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017771 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017771 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017771 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017771 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017771 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check version and status values in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017771 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/08/2020        | ?               | ?             |
    | 10017771 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |




    # Initiate a TERMINATION then approve the initiation

    # Change the date
    Given the override date is '01/10/2018'

    # Request termination of the contract 
    When  CRM user 'FCS8 Test' initiates contract termination for Contract '[ContractNo]' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | TerminationReason       | TerminationComments     |
    | 03/12/2020               | 18/12/2020              | Inadequate Ofsted       | Suspected fraud         |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | [AllocRef_LEVY]  | 03/12/2020                  | 18/12/2020                |
    | [AllocRef_NLA]   | 03/12/2020                  | 18/12/2020                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract '[ContractNo]' for UKPRN '10017771'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017771 - 10017771 Co Ltd     | [ContractNo]   | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017771 | [ContractNo]       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2020        | ?               | ?             |
    | 10017771 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | [ContractNo]   | 1                     | 0                        | 18/12/2020              | Suspected fraud         |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | [AllocRef_LEVY]  | 1                     | 0                        | 03/12/2020        | 18/12/2020                |
    | [AllocRef_NLA]   | 1                     | 0                        | 03/12/2020        | 18/12/2020                |
    
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017771'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017771 - 10017771 Co Ltd     | [ContractNo]   | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract '[ContractNo]' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected fraud                  |




    # Change the date
    Given the override date is '04/10/2020'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017771' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017771'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017771 - 10017771 Co Ltd      | [ContractNo]   | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected fraud                  |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017771 | [ContractNo]       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2020        | ?               | ?             |
    | 10017771 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |



    # Check the CM feed for the presence of an ItemType 4 (Termination) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number '[ContractNo]'
    And   the ItemType '4' event for version '1' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber     | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017771 | [ContractNo]       | 1               | 0                  | 18/12/2020              | Inadequate Ofsted         | [AllocRef]      | 03/12/2020            | 18/12/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017771 | [ContractNo]   | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract [ContractNo]:1.0 was placed under termination |

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber     | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017771 | [ContractNo]       | 1               | 0                  | 18/12/2020              | Inadequate Ofsted         | [AllocRef]      | 03/12/2020            | 18/12/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017771 | [ContractNo]   | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract [ContractNo]:1.0 was placed under termination |



    # Manager CANCELS termination request (23811)
#   When  CRM user 'FCS8 Test' cancels the termination request for Contract '[ContractNo]' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' cancels the termination request for Contract '[ContractNo]' Version '1' SubVersion '0' via SDK

    # Has a 'Cancel Termination' Workflow History entry been created ?
    Then  the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Cancel Termination                             | FCS8 Test           | ?                                |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected fraud                  |


    # Check the CM feed for the presence of an ItemType 5 (Contract Termination Cancelled) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '5' event for version '1' of actual contract number '[ContractNo]'
    And   the ItemType '5' event for version '1' of contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Cancelled' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017771 | [ContractNo]   | 1               | 0                  | ?                       | ?                         | [AllocRef_LEVY] | ?                     | ?                         |
    | 10017771 | [ContractNo]   | 1               | 0                  | ?                       | ?                         | [AllocRef_NLA]  | ?                     | ?                         |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017771 | [ContractNo]   | 1               | 0                  | Contract Termination Cancelled | Termination of a contract has been cancelled | Termination of contract [ContractNo]:1.0 was cancelled |


    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Cancelled' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017771 | [ContractNo]   | 1               | 0                  | ?                       | ?                         | [AllocRef_LEVY] | ?                     | ?                         |
    | 10017771 | [ContractNo]   | 1               | 0                  | ?                       | ?                         | [AllocRef_NLA]  | ?                     | ?                         |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017771 | [ContractNo]   | 1               | 0                  | Contract Termination Cancelled | Termination of a contract has been cancelled | Termination of contract [ContractNo]:1.0 was cancelled |



    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus    | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017771 | [ContractNo]       | 1                     | 0                        | Approved       | Approved             | True          | True                | 01/08/2020        | ?               | ?             |
    | 10017771 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                    | False         | False               | 01/05/2017        | ?               | ?             |

    # Has a 'Termination Cancellation Successful' Workflow History entry been created ?
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Cancellation Successful            | CRM Integration     | ?                                |
    | Cancel Termination                             | FCS8 Test           | ?                                |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected fraud                  |


    # Tidy up
    And   the override date is reset 

@AcceptanceTest @Withdrawn20230123
Scenario: A772 Create and approve an 1819 Mainstream contract with 16-18TRN and AEBC allocations. Initiate termination (without amendment) then approve the initiation by completing the open task. Cancel termination. Check CRM and feed. Initiate termination again, approve initiation then cancel again. Check CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017772' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017772' 
    And   the Contract Management atom feed is empty

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16TR-772      |
    | AEC-772       |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017772' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017772 Co Ltd' with UKPRN '10017772' and OrgId 'ORG0017772' and has 'FCS1 Test' as a manager 
    And   UPIN '117772' is associated with UKPRN '10017772' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017772 | 117772 | 10017772 Co Ltd | 0              | Active | Yes           | AA017772      | ?             | 

    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017772 | 10017772 Co Ltd      | ESFA-772             | MAIN-772       | 1                     | 01/08/2018        | 31/07/2019      | 89227.00      |                                | Contract for Services | 1819   | New          | ORG0017772 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017772 | MAIN-772       | 16TR-772      | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2018          | 31/07/2019        | 53591.00        |                                         |            |                                                             | New          |             |
    | 10017772 | MAIN-772       | AEC-772       | AEBC              | AEBC1819                | AY                      | 01/08/2018          | 31/07/2019        | 35636.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017772 | MAIN-772       | 16TR-772      | 1               | 0                     | 53591.00  | 5426.00  | 6010.00  | 2294.00  | 3322.00  | 3939.00  | 6771.00  | 5678.00  | 4270.00  | 3811.00  | 1488.00  | 4003.00  | 6579.00  | 16-18 Traineeships Funding                                      | New          |             |
    | 10017772 | MAIN-772       | 16TR-772      | 2               | 1                     | 27149.00  | 3445.00  | 2788.00  | 76.00    | 812.00   | 3287.00  | 3263.00  | 2353.00  | 1380.00  | 3317.00  | 1207.00  | 2101.00  | 3120.00  | 16-18 Traineeships Programme Funding                            | New          |             |
    | 10017772 | MAIN-772       | 16TR-772      | 3               | 1                     | 26442.00  | 1981.00  | 3222.00  | 2218.00  | 2510.00  | 652.00   | 3508.00  | 3325.00  | 2890.00  | 494.00   | 281.00   | 1902.00  | 3459.00  | 16-18 Traineeships Bursary Funding                              | New          |             |
    #
    | 10017772 | MAIN-772       | AEC-772       | 1               | 0                     | 35636.00  | 2501.00  | 4255.00  | 1711.00  | 3910.00  | 3732.00  | 4034.00  | 412.00   | 1157.00  | 1869.00  | 2452.00  | 2437.00  | 7166.00  | Total 16-18 Traineeships Funding                                | New          |             |
    | 10017772 | MAIN-772       | AEC-772       | 13              | 1                     | 14200.00  | 172.00   | 592.00   | 316.00   | 1146.00  | 1373.00  | 2426.00  | 252.00   | 355.00   | 1027.00  | 1729.00  | 1358.00  | 3454.00  | Community Learning                                              | New          |             |
    | 10017772 | MAIN-772       | AEC-772       | 14              | 1                     | 21436.00  | 2329.00  | 3663.00  | 1395.00  | 2764.00  | 2359.00  | 1608.00  | 160.00   | 802.00   | 842.00   | 723.00   | 1079.00  | 3712.00  | Other AEB Funding                                               | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-772' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-772' and actual ContractNumber 'MAIN-772'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-772' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017772 | MAIN-772           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017772 | ESFA-772           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '132' deliverable period rows in CRM linked to the latest version of contract 'MAIN-772'




    # Initiate a TERMINATION then approve the initiation

    # Change the date
    Given the override date is '10/03/2019'

    # Request termination of the contract
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-772' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason           | TerminationComments     |
    | 12/04/2019               | 27/04/2019              | No                          | Inadequate Financial Health | Suspected fraud         |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | 16TR-772         | 01/04/2019                  | 16/04/2019                |
    | AEC-772          | 05/04/2019                  | 20/04/2019                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'MAIN-772' for UKPRN '10017772'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017772 - 10017772 Co Ltd     | MAIN-772       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017772 | MAIN-772       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017772 | ESFA-772       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | MAIN-772       | 1                     | 0                        | 27/04/2019              | Suspected fraud         |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | 16TR-772         | 1                     | 0                        | 01/04/2019        | 16/04/2019                |
    | AEC-772          | 1                     | 0                        | 05/04/2019        | 20/04/2019                |

    
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'MAIN-772' for provider '10017772'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017772 - 10017772 Co Ltd     | MAIN-772       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'MAIN-772' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected fraud                  |




    # Change the date
    Given the override date is '13/03/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'MAIN-772' for provider '10017772' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'MAIN-772' for provider '10017772'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017772 - 10017772 Co Ltd      | MAIN-772       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'MAIN-772' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected fraud                  |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017772 | MAIN-772       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017772 | ESFA-772       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Check the CM feed for the presence of an ItemType 4 (Contract Termination Initiated) row
   #And   the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number 'MAIN-772'
    And   the ContractManagement.AtomFeedItem table contains '1' ItemType '4' event for version '1' of actual contract number 'MAIN-772'
    And   the latest ItemType '4' event for version '1' of actual contract number 'MAIN-772' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
   #And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
	And   the latest 'Contract Termination Initiated' event in the Contract Management 'ALLCONTRACT' feed is as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason   | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017772 | MAIN-772       | 1               | 0                  | 27/04/2019              | Inadequate Financial Health | 16TR-772        | 01/04/2019            | 16/04/2019                |
    | 10017772 | MAIN-772       | 1               | 0                  | 27/04/2019              | Inadequate Financial Health | AEC-772         | 05/04/2019            | 20/04/2019                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017772 | MAIN-772       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract MAIN-772:1.0 was placed under termination     |


    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
   #And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
	And   the latest 'Contract Termination Initiated' event in the Contract Management 'APPROVALONWARDSCONTRACT' feed is as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason   | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017772 | MAIN-772       | 1               | 0                  | 27/04/2019              | Inadequate Financial Health | 16TR-772        | 01/04/2019            | 16/04/2019                |
    | 10017772 | MAIN-772       | 1               | 0                  | 27/04/2019              | Inadequate Financial Health | AEC-772         | 05/04/2019            | 20/04/2019                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017772 | MAIN-772       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract MAIN-772:1.0 was placed under termination     |




    # Manager CANCELS termination request (23811)
#   When  CRM user 'FCS8 Test' cancels the termination request for Contract 'MAIN-772' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' cancels the termination request for Contract 'MAIN-772' Version '1' SubVersion '0' via SDK

    # Has a 'Cancel Termination' Workflow History entry been created ?
    Then  the workflow history on contract 'MAIN-772' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Cancel Termination                             | FCS8 Test           | ?                                |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected fraud                  |

    # Check the CM feed for the presence of an ItemType 5 (Contract Termination Cancelled) row
   #And   the ContractManagement.AtomFeedItem table contains one ItemType '5' event for version '1' of actual contract number 'MAIN-772'
    And   the ContractManagement.AtomFeedItem table contains '1' ItemType '5' event for version '1' of actual contract number 'MAIN-772'
    And   the latest ItemType '5' event for version '1' of actual contract number 'MAIN-772' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
   #And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Cancelled' event details as follows
	And   the latest 'Contract Termination Cancelled' event in the Contract Management 'ALLCONTRACT' feed is as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017772 | MAIN-772       | 1               | 0                  | ?                       | ?                         | 16TR-772        | ?                     | ?                         |
    | 10017772 | MAIN-772       | 1               | 0                  | ?                       | ?                         | AEC-772         | ?                     | ?                         |

    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                              |
    | 10017772 | MAIN-772       | 1               | 0                  | Contract Termination Cancelled | Termination of a contract has been cancelled | Termination of contract MAIN-772:1.0 was cancelled |


    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
   #And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Cancelled' event details as follows
	And   the latest 'Contract Termination Cancelled' event in the Contract Management 'APPROVALONWARDSCONTRACT' feed is as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017772 | MAIN-772       | 1               | 0                  | ?                       | ?                         | 16TR-772        | ?                     | ?                         |
    | 10017772 | MAIN-772       | 1               | 0                  | ?                       | ?                         | AEC-772         | ?                     | ?                         |

    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                              |
    | 10017772 | MAIN-772       | 1               | 0                  | Contract Termination Cancelled | Termination of a contract has been cancelled | Termination of contract MAIN-772:1.0 was cancelled |


    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus    | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017772 | MAIN-772       | 1                     | 0                        | Approved       | Approved             | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017772 | ESFA-772       | 1                     | 0                        | Draft          | ?                    | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Has a 'Termination Cancellation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'MAIN-772' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Cancellation Successful            | CRM Integration     | ?                                |
    | Cancel Termination                             | FCS8 Test           | ?                                |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected fraud                  |




    # Re-initiate TERMINATION of the contract (24782)

    # Clear down the termination failure notifications again
    Given there are no notifications in CRM of type 'Contract Termination Failed' for UKPRN '10017772'

    # Clear down the associated workflow histories again
    And   the following workflow histories against version '1' of contract 'MAIN-772' are removed
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Cancellation Successful            | CRM Integration     | ?                                |
    | Cancel Termination                             | FCS8 Test           | ?                                |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected fraud                  |

#    # Clear down the Contract Management feed again
#    And   the Contract Management atom feed is empty

    # Change the date
    And   the override date is '25/03/2019'

    # Request termination of the contract via the CRM UI using different dates and comments
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-772' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason           | TerminationComments     |
    | 14/04/2019               | 28/04/2019              | No                          | Inadequate Financial Health | Suspected embezzlement  |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | 16TR-772         | 03/04/2019                  | 15/04/2019                |
    | AEC-772          | 07/04/2019                  | 19/04/2019                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#    And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'MAIN-772' for UKPRN '10017772'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017772 - 10017772 Co Ltd     | MAIN-772       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017772 | MAIN-772       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017772 | ESFA-772       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | MAIN-772       | 1                     | 0                        | 28/04/2019              | Suspected embezzlement  |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | 16TR-772         | 1                     | 0                        | 03/04/2019        | 15/04/2019                |
    | AEC-772          | 1                     | 0                        | 07/04/2019        | 19/04/2019                |

    
#    # Has a Termination Initiation Task been created ?
#    And   the following Tasks are present against version '1' of contract 'MAIN-772' for provider '10017772'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017772 - 10017772 Co Ltd     | MAIN-772       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#    # Has a Termination Initiation Workflow History entry been created ?
#    And   the workflow history on contract 'MAIN-772' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected embezzlement           |




    # Change the date
    Given the override date is '17/03/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'MAIN-772' for provider '10017772' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '1' of contract 'MAIN-772' for provider '10017772'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017772 - 10017772 Co Ltd      | MAIN-772       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'MAIN-772' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected embezzlement           |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017772 | MAIN-772       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017772 | ESFA-772       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |



    # Check the CM feed for the presence of an ItemType 4 (Contract Termination Initiated) row
   #And   the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number 'MAIN-772'
    And   the ContractManagement.AtomFeedItem table contains '2' ItemType '4' events for version '1' of actual contract number 'MAIN-772'
    And   the latest ItemType '4' event for version '1' of actual contract number 'MAIN-772' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
   #And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
	And   the latest 'Contract Termination Initiated' event in the Contract Management 'ALLCONTRACT' feed is as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason   | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017772 | MAIN-772       | 1               | 0                  | 28/04/2019              | Inadequate Financial Health | 16TR-772        | 03/04/2019            | 15/04/2019                |
    | 10017772 | MAIN-772       | 1               | 0                  | 28/04/2019              | Inadequate Financial Health | AEC-772         | 07/04/2019            | 19/04/2019                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017772 | MAIN-772       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract MAIN-772:1.0 was placed under termination     |


    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
   #And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
	And   the latest 'Contract Termination Initiated' event in the Contract Management 'APPROVALONWARDSCONTRACT' feed is as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason   | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017772 | MAIN-772       | 1               | 0                  | 28/04/2019              | Inadequate Financial Health | 16TR-772        | 03/04/2019            | 15/04/2019                |
    | 10017772 | MAIN-772       | 1               | 0                  | 28/04/2019              | Inadequate Financial Health | AEC-772         | 07/04/2019            | 19/04/2019                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017772 | MAIN-772       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract MAIN-772:1.0 was placed under termination     |



    # Manager CANCELS termination request (23811)
#   When  CRM user 'FCS8 Test' cancels the termination request for Contract 'MAIN-772' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' cancels the termination request for Contract 'MAIN-772' Version '1' SubVersion '0' via SDK

    # Has a 'Cancel Termination' Workflow History entry been created ?
    Then  the workflow history on contract 'MAIN-772' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Cancel Termination                             | FCS8 Test           | ?                                |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected embezzlement           |


    # Check the CM feed for the presence of an ItemType 5 (Contract Termination Cancelled) row
   #And   the ContractManagement.AtomFeedItem table contains one ItemType '5' event for version '1' of actual contract number 'MAIN-772'
    And   the ContractManagement.AtomFeedItem table contains '2' ItemType '5' events for version '1' of actual contract number 'MAIN-772'
	And   the latest ItemType '5' event for version '1' of actual contract number 'MAIN-772' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
   #And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Cancelled' event details as follows
	And   the latest 'Contract Termination Cancelled' event in the Contract Management 'ALLCONTRACT' feed is as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017772 | MAIN-772       | 1               | 0                  | ?                       | ?                         | 16TR-772        | ?                     | ?                         |
    | 10017772 | MAIN-772       | 1               | 0                  | ?                       | ?                         | AEC-772         | ?                     | ?                         |

    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                              |
    | 10017772 | MAIN-772       | 1               | 0                  | Contract Termination Cancelled | Termination of a contract has been cancelled | Termination of contract MAIN-772:1.0 was cancelled |


    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
   #And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Cancelled' event details as follows
	And   the latest 'Contract Termination Cancelled' event in the Contract Management 'APPROVALONWARDSCONTRACT' feed is as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017772 | MAIN-772       | 1               | 0                  | ?                       | ?                         | 16TR-772        | ?                     | ?                         |
    | 10017772 | MAIN-772       | 1               | 0                  | ?                       | ?                         | AEC-772         | ?                     | ?                         |

    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                              |
    | 10017772 | MAIN-772       | 1               | 0                  | Contract Termination Cancelled | Termination of a contract has been cancelled | Termination of contract MAIN-772:1.0 was cancelled |


    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus    | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017772 | MAIN-772       | 1                     | 0                        | Approved       | Approved             | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017772 | ESFA-772       | 1                     | 0                        | Draft          | ?                    | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Has a 'Termination Cancellation Successful' Workflow History entry been created ?
    And   the workflow history on contract 'MAIN-772' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Cancellation Successful            | CRM Integration     | ?                                |
    | Cancel Termination                             | FCS8 Test           | ?                                |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Suspected embezzlement           |


    # Tidy up
    And   the override date is reset 

