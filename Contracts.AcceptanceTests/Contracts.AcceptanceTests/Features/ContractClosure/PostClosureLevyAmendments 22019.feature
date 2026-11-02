Feature: PostClosureLevyAmendments 22019

@AcceptanceTest @Withdrawn20230123
@PublishNewLevyContract @ContractClosure
Scenario: A941 Create and approve a Levy contract. Successfully request contract closure. Attempt (singleton) contract amendment after closure has been initiated. Fail. Check for notification. Check CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017941'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017941'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017941'
   #And   there are no notifications of type 'Contract Closure Failed'
    And   there are no notifications in CRM of type 'Contract Closure Initiation Failed' for UKPRN '10017941'
	And   there are no notifications in CRM of type 'Contract Closure Failed' for UKPRN '10017941'
	And   there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017941'
	And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017941'
	And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017941'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
   # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017941'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017941 Co Ltd' with UKPRN '10017941' and OrgId 'ORG0017941' and has 'FCS1 Test' as a manager
    And   UPIN '117941' is associated with UKPRN '10017941' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017941 | 117941 | 10017941 Co Ltd | 0              | Active |

	# Set RoATP data (needed for amendment checks) 
	# Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.
	And   the following providers exist on RoATP
	| Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
	| 10017941 | 10017941 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    

    # Change the date 
    And   the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42864 | INITIATED | 2017-09-15T18:03:12.2539 | 10017941   | 28913             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017941'
    And   there is only one Levy contract in CRM for UKPRN '10017941' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017941 | 10017941 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017941 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017941 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
    | 10017941 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription               | 
    | 10017941 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships     | 
    | 10017941 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships     | 
    | 10017941 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships | 
    | 10017941 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships |

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017941' for FundingType 'LEVY' and period '1799'

    # Check deliverable period count prior to approval
    And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Change the date 
    Given the override date is '02/01/2021'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    # Check deliverable period count after approval
    Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # After approval there should be a Jan-21 deliverable period for each of deliverables 1 through 12
    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Jan-21   | DeliverableDescription                               | 
	| 10017941 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017941 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017941 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017941 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017941 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017941 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017941 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017941 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017941 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017941 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017941 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017941 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017941 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017941 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017941 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017941 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017941 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017941 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017941 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017941 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017941 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017941 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017941 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017941 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017941 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017941 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017941 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017941 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017941 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 02/01/2021        | ?               | ?             |
    | 10017941 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017941 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 02/01/2021          | ?                 |
    | 10017941 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 02/01/2021          | ?                 |




    # Change the date 
    Given the override date is '11/07/2021' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '[ContractNo]' for provider '10017941'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017941 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 02/01/2021        | ?               | ?             |
    | 10017941 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017941 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 02/01/2021          | ?                 |
    | 10017941 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 02/01/2021          | ?                 |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017941'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017941 - 10017941 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Open  | Not Started |
  
    # Check that the workflow history includes two new entries
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy      | Comment                           | 
    | Closure Initiation Successful | CRM Integration  | ?                                 | 
    | Initiate Contract Closure     | FCS2 Test        | ?                                 | 




    # Change the date
    Given the override date is '12/07/2021'

    # Issue a contract amendment request against v1 to create v2 using the singleton mechanism. The amendment should not occur and a notification should be sent
   #When  a request is issued to amend the following Levy contract
   #When  a request is issued to amend the following Levy contract via Bulk
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus                 | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017941 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Awaiting Closure Approval | Variation     | No                       | Yes                          |

    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017941' for FundingType 'LEVY' and period '1799'

    # Check CONTRACT version, status and dates in CRM have not changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017941 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 02/01/2021        | ?               | ?             |
    | 10017941 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

	# Check that a NOTIFICATION has been created and sent to the Advisor who issued the closure request
	And   there is '1' notification of type 'Contract Amendment Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                         | NotificationText                                                                                                          |
    | New    | Contract Amendment Failed - [ContractNo] | Contract [ContractNo] v1 for provider 10017941 (10017941 Co Ltd) cannot be amended - contract closure has been initiated  |


	# Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
@PublishNewLevyContract @ContractClosure
Scenario: A942 Create and approve a Levy contract. Successfully request contract closure. Attempt (bulk) contract amendment while closure initiation is in progress (Variation and No). Fail. Check for notification
    Given there is no Contract, Task or Workflow data for UKPRN '10017942'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017942'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017942'
   #And   there are no notifications of type 'Contract Closure Failed'
    And   there are no notifications in CRM of type 'Contract Closure Initiation Failed' for UKPRN '10017942'
	And   there are no notifications in CRM of type 'Contract Closure Failed' for UKPRN '10017942'
	And   there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017942'
	And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017942'
	And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017942'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
   
	# Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017942'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017942 Co Ltd' with UKPRN '10017942' and OrgId 'ORG0017942' and has 'FCS1 Test' as a manager
    And   UPIN '117942' is associated with UKPRN '10017942' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017942 | 117942 | 10017942 Co Ltd | 0              | Active |

	# Set RoATP data (needed for amendment checks)
	# Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.
	And   the following providers exist on RoATP
	| Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
	| 10017942 | 10017942 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    




    # Change the date 
    Given the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42864 | INITIATED | 2017-09-15T18:03:12.2539 | 10017942   | 28913             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017942'
    And   there is only one Levy contract in CRM for UKPRN '10017942' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017942 | 10017942 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017942 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017942 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
	| 10017942 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription               | 
    | 10017942 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships     | 
    | 10017942 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships     | 
	| 10017942 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships | 
    | 10017942 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships |

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017942' for FundingType 'LEVY' and period '1799'

    # Check deliverable period count prior to approval
    And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Change the date 
    Given the override date is '02/01/2021'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    # Check deliverable period count after approval
    Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # After approval there should be a Jan-21 deliverable period for each of deliverables 1 through 14 for each allocation
    Then  the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Jan-21   | DeliverableDescription                               | 
    | 10017942 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017942 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017942 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017942 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017942 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017942 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017942 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017942 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017942 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017942 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017942 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017942 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017942 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017942 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017942 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017942 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017942 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017942 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017942 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017942 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017942 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017942 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017942 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017942 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017942 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017942 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017942 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017942 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017942 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 02/01/2021        | ?               | ?             |
    | 10017942 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017942 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 02/01/2021          | ?                 |
    | 10017942 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 02/01/2021          | ?                 |



    # Change the date 
    And   the override date is '11/07/2021' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '[ContractNo]' for provider '10017942'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017942 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 02/01/2021        | ?               | ?             |
    | 10017942 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017942 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 02/01/2021          | ?                 |
    | 10017942 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 02/01/2021          | ?                 |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017942'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017942 - 10017942 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Open  | Not Started |
  
    # Check that the workflow history includes two new entries
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy      | Comment                           | 
    | Closure Initiation Successful | CRM Integration  | ?                                 | 
    | Initiate Contract Closure     | FCS2 Test        | ?                                 | 

    # Reset the contract status and sub-status to the transient values immediately prior to 'Awaiting Closure Approval'
    Given the status and substatus of version '1' of contract '[ContractNo]' are set to 'Approved' and 'Closure Initiation in Progress' respectively  

	# Check that the contract status and substatus have changed 
	Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus              | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017942 | [ContractNo]       | 1                     | 0                        | Approved       | Closure Initiation in Progress | True          | True                | 02/01/2021        | ?               | ?             |
    | 10017942 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                              | False         | False               | 01/05/2017        | ?               | ?             |




    # Issue a contract amendment request against v1 to create v2. This should fail
    Given the override date is '12/07/2021'

	# Issue a contract amendment request against v1 to create v2 using the singleton mechanism. The amendment should not occur and a notification should be sent
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus                      | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017942 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Closure Initiation in Progress | Variation     | No                       | Yes                   | Yes                          |

    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017942' for FundingType 'LEVY' and period '1799'

    # Check CONTRACT version, status and dates in CRM have not changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus              | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017942 | [ContractNo]       | 1                     | 0                        | Approved         | Closure Initiation in Progress | True          | True                | 02/01/2021        | ?               | ?             |
    | 10017942 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                              | False         | False               | 01/05/2017        | ?               | ?             |

    # Check that an Amendment Failure NOTIFICATION has been created and sent to the User who issued the closure request (Zoe in this case)
	And   there is '1' notification of type 'Contract Amendment Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                         | NotificationText                                                                                                          |
    | New    | Contract Amendment Failed - [ContractNo] | Contract [ContractNo] v1 for provider 10017942 (10017942 Co Ltd) cannot be amended - contract closure has been initiated  |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Complete
@PublishNewLevyContract @ContractClosure
Scenario: A943 Create and approve a Levy contract. Request then approve contract closure. Attempt (bulk) contract amendment after contract closure has concluded. Fail. Check for no notification
    Given there is no Contract, Task or Workflow data for UKPRN '10017943'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017943'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017943'
	And   there are no notifications in CRM of type 'Contract Closure Initiation Failed' for UKPRN '10017943'
	And   there are no notifications in CRM of type 'Contract Closure Failed' for UKPRN '10017943'
	And   there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017943'
	And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017943'
	And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017943'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS

   # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017943'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017943 Co Ltd' with UKPRN '10017943' and OrgId 'ORG0017943' and has 'FCS1 Test' as a manager
    And   UPIN '117943' is associated with UKPRN '10017943' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017943 | 117943 | 10017943 Co Ltd | 0              | Active |

    # Set RoATP data (needed for amendment checks)
	# Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.
    And   the following providers exist on RoATP
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
    | 10017943 | 10017943 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    




    # Change the date 
    Given the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42864 | INITIATED | 2017-09-15T18:03:12.2539 | 10017943   | 28913             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017943'
    And   there is only one Levy contract in CRM for UKPRN '10017943' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017943 | 10017943 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017943 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017943 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
	| 10017943 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription               | 
    | 10017943 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships     | 
    | 10017943 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships     | 
	| 10017943 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships | 
    | 10017943 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships |

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017943' for FundingType 'LEVY' and period '1799'
#
#    # Check deliverable period count prior to approval
#    And   there are '6' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Change the date 
    Given the override date is '12/04/2021'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    ## Check deliverable period count after approval
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # After approval there should be a Apr-21 deliverable period for each of deliverables 1 through 14 for each allocation
    Then  the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Apr-21   | DeliverableDescription                               | 
    | 10017943 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017943 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017943 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017943 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017943 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017943 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017943 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017943 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017943 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017943 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017943 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017943 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017943 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017943 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017943 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017943 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017943 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017943 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017943 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017943 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017943 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017943 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017943 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017943 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017943 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017943 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017943 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017943 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017943 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 12/04/2021        | ?               | ?             |
    | 10017943 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017943 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 12/04/2021          | ?                 |
    | 10017943 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 12/04/2021          | ?                 |



    # Change the date 
    And   the override date is '16/09/2021' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '[ContractNo]' for provider '10017943'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017943 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 12/04/2021        | ?               | ?             |
    | 10017943 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017943 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 12/04/2021          | ?                 |
    | 10017943 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 12/04/2021          | ?                 |
 
    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017943'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017943 - 10017943 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Open  | Not Started |

    # Check the WORKFLOW HISTORY
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy     | Comment                            |
    | Closure Initiation Successful | CRM Integration | ?                                  |
    | Initiate Contract Closure     | FCS2 Test       | ?                                  |                       
   



    # Change the date 
    Given the override date is '19/09/2021' 

    # Approve closure of the contract. This should succeed
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract '[ContractNo]' for provider '10017943'
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract '[ContractNo]' for provider '10017943'

    # Check CONTRACT version, status and dates in CRM. The contract end date should have been set
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017943 | [ContractNo]       | 1                     | 0                        | Closed         | Closed            | True          | True                | 12/04/2021        | 19/09/2021      | ?             |
    | 10017943 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                 | False         | False               | 01/05/2017        | ?               | ?             |

   # Check ALLOCATION dates in CRM. The allocation end date should have been set
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017943 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 12/04/2021          | 19/09/2021        |
    | 10017943 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 12/04/2021          | 19/09/2021        |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017943'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State     | Status      |
    | Confirm Closure Approval | 10017943 - 10017943 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Completed | Completed   |

    # Check the WORKFLOW HISTORY
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy      | Comment                           | 
    | Contract Closure Successful   | CRM Integration  | ?                                 |
    | Approve Closure               | FCS1 Test        | ?                                 | 
    | Closure Initiation Successful | CRM Integration  | ?                                 | 
    | Initiate Contract Closure     | FCS2 Test        | ?                                 | 



    # Change the date
    Given the override date is '12/10/2021'

	# Issue a contract amendment request against v1 to create v2 using the singleton mechanism. The amendment should not occur and a notification should not be sent
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017943 | [MasterContractNo]   | [ContractNo]   | 1       | Closed   | Closed    | Variation     | No                       | Yes                   | Yes                          |

    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017943' for FundingType 'LEVY' and period '1799'

    # Check CONTRACT version, status and dates in CRM have not changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017943 | [ContractNo]       | 1                     | 0                        | Closed         | Closed            | True          | True                | 12/04/2021        | 19/09/2021      | ?             |
    | 10017943 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                 | False         | False               | 01/05/2017        | ?               | ?             |

    # Check that an amendment failure NOTIFICATION has not been created 
    And   a new notification for 'Contract Amendment Failed - [ContractNo]' is not sent with Notification Type 'Contract Amendment Failed'


    # Tidy up
	Given there are no notifications of type 'Approval Received'
	And   the override date is reset

@AcceptanceTest @Withdrawn20230123
@PublishNewLevyContract @ContractClosure
Scenario: A944 Create and approve a Levy contract. Request then approve contract closure. Attempt (singleton) contract amendment while contract closure is in progress. Fail. Check for no notification. Check RoATP anomalies report
    Given there is no Contract, Task or Workflow data for UKPRN '10017944'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017944'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017944'
	And   there are no notifications for UKPRN '10017944'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS

   # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017944'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017944 Co Ltd' with UKPRN '10017944' and OrgId 'ORG0017944' and has 'FCS1 Test' as a manager
    And   UPIN '117944' is associated with UKPRN '10017944' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017944 | 117944 | 10017944 Co Ltd | 0              | Active |

    # Set RoATP data (needed for amendment checks)
	# Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.
    And   the following providers exist on RoATP
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
    | 10017944 | 10017944 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    




    # Change the date 
    Given the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42864 | INITIATED | 2017-09-15T18:03:12.2539 | 10017944   | 28913             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017944'
    And   there is only one Levy contract in CRM for UKPRN '10017944' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017944 | 10017944 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017944 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017944 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
    | 10017944 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                  | 
    | 10017944 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships        | 
    | 10017944 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships        | 
    | 10017944 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017944 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve parameters from CRM 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017944' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017944' 
    When  I retrieve the latest contract details from CRM for provider '10017944' for FundingType 'LEVY' and period '1799' 

    # Check deliverable period count prior to approval
    Then  there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Change the date 
    Given the override date is '12/04/2020'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    # Check deliverable period count after approval
    Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # After approval there should be a Apr-18 deliverable period for each of deliverables 1 through 14 for each allocation 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Apr-20   | DeliverableDescription                               | 
    | 10017944 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017944 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017944 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017944 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017944 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017944 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017944 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017944 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017944 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017944 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017944 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017944 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017944 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017944 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
    #
	| 10017944 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017944 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017944 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017944 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017944 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017944 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017944 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017944 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017944 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017944 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017944 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017944 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017944 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017944 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017944 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 12/04/2020        | ?               | ?             |
    | 10017944 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017944 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 12/04/2020          | ?                 |
    | 10017944 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 12/04/2020          | ?                 |




    # Change the date 
    Given the override date is '16/09/2020' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '[ContractNo]' for provider '10017944'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017944 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 12/04/2020        | ?               | ?             |
    | 10017944 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017944 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 12/04/2020          | ?                 |
    | 10017944 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 12/04/2020          | ?                 |
 
    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017944'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017944 - 10017944 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Open  | Not Started |

    # Check the WORKFLOW HISTORY
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy     | Comment                            |
    | Closure Initiation Successful | CRM Integration | ?                                  |
    | Initiate Contract Closure     | FCS2 Test       | ?                                  |                       
   



    # Change the date 
    Given the override date is '19/09/2020' 

    # Approve closure of the contract. This should succeed
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract '[ContractNo]' for provider '10017944'
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract '[ContractNo]' for provider '10017944'

    # Check CONTRACT version, status and dates in CRM. The contract end date should have been set
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017944 | [ContractNo]       | 1                     | 0                        | Closed         | Closed            | True          | True                | 12/04/2020        | 19/09/2020      | ?             |
    | 10017944 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                 | False         | False               | 01/05/2017        | ?               | ?             |

   # Check ALLOCATION dates in CRM. The allocation end date should have been set
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017944 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 12/04/2020          | 19/09/2020        |
    | 10017944 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 12/04/2020          | 19/09/2020        |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017944'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State     | Status      |
    | Confirm Closure Approval | 10017944 - 10017944 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Completed | Completed   |

    # Check the WORKFLOW HISTORY
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy      | Comment                           | 
    | Contract Closure Successful   | CRM Integration  | ?                                 |
    | Approve Closure               | FCS1 Test        | ?                                 | 
    | Closure Initiation Successful | CRM Integration  | ?                                 | 
    | Initiate Contract Closure     | FCS2 Test        | ?                                 | 

    # Reset the contract status and sub-status to the transient values immediately prior to 'Closed\Closed'
    Given the status and substatus of version '1' of contract '[ContractNo]' are set to 'Approved' and 'Closure in Progress' respectively  

	# Check that the contract status and substatus have changed 
	Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus   | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017944 | [ContractNo]       | 1                     | 0                        | Approved       | Closure in Progress | True          | True                | 12/04/2020        | 19/09/2020      | ?             |
    | 10017944 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                   | False         | False               | 01/05/2017        | ?               | ?             |




    # Change the date
    Given the override date is '12/10/2020'

	# Issue a contract amendment request against v1 to create v2 using the singleton mechanism. The amendment should not occur and a notification should not be sent
   #When  a request is issued to amend the following Levy contract
   #When  a request is issued to amend the following Levy contract via Bulk
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus            | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017944 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Closure in Progress  | Variation     | No                       | Yes                          |

    # Check CONTRACT version, status and dates in CRM have not changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus   | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017944 | [ContractNo]       | 1                     | 0                        | Approved       | Closure in Progress | True          | True                | 12/04/2020        | 19/09/2020      | ?             |
    | 10017944 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                   | False         | False               | 01/05/2017        | ?               | ?             |

    # Check that an amendment failure NOTIFICATION has not been created 
    And   a new notification for 'Contract Amendment Failed - [ContractNo]' is not sent with Notification Type 'Contract Amendment Failed'

    # Check that there is nothing on the RoATP Anomalies report for the provider
    And   the RoATP Anomalies report does not contain a record for provider '10017944'


    # Tidy up
    And   the override date is reset