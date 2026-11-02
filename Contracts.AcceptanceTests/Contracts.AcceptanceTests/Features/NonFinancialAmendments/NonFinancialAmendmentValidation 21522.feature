Feature: NonFinancialAmendmentValidation 21522

@AcceptanceTest @Withdrawn20231002
Scenario: A791 Create and approve a 2-allocation 1718 Mainstream contract. Initiate one non-financial variation amendment while one is already in progress. Fail. Reset indicator and retry. Pass
    Given there is no Contract, Task or Workflow data for UKPRN '10017791' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017791'
    And   there are no notifications in CRM of type 'Non-Financial Contract Amendment Failed' for UKPRN '10017791'
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16AP-791      |
    | 16NL-791      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017791' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017791 Co Ltd' with UKPRN '10017791' and OrgId 'ORG0017791' and has 'FCS1 Test' as a manager 
    And   UPIN '117791' is associated with UKPRN '10017791' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017791 | 117791 | 10017791 Co Ltd | 0              | Active | Yes           | AA017791      | ?             | 

    # Change the date
    And   the override date is '15/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017791 | 10017791 Co Ltd      | ESFA-791             | MAIN-791       | 1                     | 01/08/2017        | 31/07/2018      | 43029.00      |                                | Contract for Services | 1718   | New          | ORG0017791 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode    | AllocationDescription | CRMIntent    |
    | 10017791 | MAIN-791       | 16AP-791      | 16-18 APPS        | 16-18APPS1718           | AY                      | 01/08/2017          | 31/07/2018        | 22605.00        |         |            |                       | New          |
    | 10017791 | MAIN-791       | 16NL-791      | 16-18NLA          | 16-18NLA1718            | AY                      | 01/08/2017          | 31/07/2018        | 20424.00        |         |            |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                        | CRMIntent    |
    | 10017791 | MAIN-791       | 16AP-791      | 2               | 0                     | 22605.00  | 2202.00  | 1013.00  | 2084.00  | 967.00   | 406.00   | 3258.00  | 2193.00  | 1683.00  | 2897.00  | 3442.00  | 247.00   | 2213.00  | 16-18 Apprenticeships Total Funding           | New          |
    | 10017791 | MAIN-791       | 16NL-791      | 1               | 0                     | 20424.00  | 834.00   | 1552.00  | 3404.00  | 1145.00  | 401.00   | 827.00   | 2163.00  | 2176.00  | 2795.00  | 2203.00  | 830.00   | 2094.00  | Total 16-18 Non-Levy Apprenticeships Funding  | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    And   the override date is '17/07/2017'

    # Publish the contract
    And   the latest version of contract 'MAIN-791' is in a state of 'Published to Provider'

    # Change the date
    And   the override date is '19/07/2017'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-791' and actual ContractNumber 'MAIN-791'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-791' is in status 'Approved'

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017791 | MAIN-791           | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017791 | ESFA-791           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/08/2017        | 31/07/2018      | ?             |              

    # Change the date 
    And   the override date is '21/07/2017' 

    # Simulate non-financial amendment in progress by setting Amendment in Progress indicator TRUE
    Given the CRM Amendment Creation in Progress indicator on version '1' subversion '0' of contract 'MAIN-791' is set 'True'
   #Given the CRM Amendment Creation in Progress indicator on version '1' subversion '0' of contract 'MAIN-791' is set 'False'

    # Initiate a non-financial amendment request. This should fail
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'MAIN-791' for a non-financial VARIATION contract amendment
   #And   a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'MAIN-791' for a non-financial NOTIFICATION contract amendment

    # Check CONTRACT version, status and dates in CRM. They should not have changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017791 | MAIN-791           | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017791 | ESFA-791           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/08/2017        | 31/07/2018      | ?             |              
   
    # Check that a NOTIFICATION has been created and sent to the initiating User 
	And   there is '1' notification of type 'Non-Financial Contract Amendment Failed' owned by user 'FCS2 Test' which matches the following 
    | Status | NotificationName                                   | NotificationText                                                                                                                       |
    | New    | Non-Financial Contract Amendment Failed - MAIN-791 | Contract MAIN-791 v1 for provider 10017791 (10017791 Co Ltd) cannot be amended - A non-financial amendment has already been initiated. |

    # Check that the Amendment in Progress indicator is still set to TRUE
    And   the value of the CRM Amendment Creation in Progress indicator on version '1' subversion '0' of contract 'MAIN-791' is 'True'

    # Set the Amendment in Progress indicator to FALSE
   #Given the CRM Amendment Creation in Progress indicator on version '1' subversion '0' of contract 'MAIN-791' is set 'True'
    Given the CRM Amendment Creation in Progress indicator on version '1' subversion '0' of contract 'MAIN-791' is set 'False'

    # Initiate a non-financial amendment request. This should succeed
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'MAIN-791' for a non-financial VARIATION contract amendment
   #And   a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'MAIN-791' for a non-financial NOTIFICATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017791 | MAIN-791           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017791 | MAIN-791           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017791 | ESFA-791           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |              

    # Check the WORKFLOW HISTORY for v1
    And   the workflow history on contract 'MAIN-791' version '1' includes the following
    | Action                                    | CompletedBy     | Comment                        |
    | Initiate Non-Financial Amendment (Vary)   | FCS2 Test      | ?                              |

    # Check the WORKFLOW HISTORY for v2
    And   the workflow history on contract 'MAIN-791' version '2' includes the following
    | Action                                    | CompletedBy     | Comment                        |
    | Non-Financial Amendment Created           | CRM Integration | ?                              |

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '2' of contract 'MAIN-791' for provider '10017791'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge          | 10017791 - 10017791 Co Ltd Awaiting documentation           | MAIN-791       | Document Management Team  | ?                        | Open            | Not Started      |

    # Check that the Amendment in Progress indicator is still set to FALSE
    And   the value of the CRM Amendment Creation in Progress indicator on version '1' subversion '0' of contract 'MAIN-791' is 'False'

    # Tidy up
    And   the override date is reset

@AcceptanceTest @Complete 
@PublishNewLevyContract
Scenario: A793 Create a Levy contract in Sep 2017 and approve it in Apr 2018. Initiate a non-financial variation amendment mid-term. Fail: Skip Document Merge=Yes. Check CRM, workflow history and notifications
    Given there is no Contract, Task or Workflow data for UKPRN '10017793'
	And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017793'
	And   there are no notifications in CRM of type 'Non-Financial Contract Amendment Failed' for UKPRN '10017793'
	And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'NACRO' with UKPRN '10017793' and OrgId 'ORG0017793' and has 'FCS1 Test' as a manager
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017793'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017793'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS

    # Change the date 
    And   the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42864 | INITIATED | 2016-12-07T18:03:12.2539 | 10017793   | 28913             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017793'

    # Check contract creation
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017793 | NACRO                | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017793 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017793 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
    | 10017793 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                  | 
    | 10017793 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships        | 
    | 10017793 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships        | 
    | 10017793 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017793 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |


    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017793' for FundingType 'LEVY' and period '1799'

    ## Check deliverable period count prior to approval
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Change the date 
    Given the override date is '12/04/2020'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    ## Check deliverable period count after approval
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # After approval there should be a Apr-20 deliverable period for each of deliverables 1 through 14 for each allocation
    Then  the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Apr-20   | DeliverableDescription                               | 
    | 10017793 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017793 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017793 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017793 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017793 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017793 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017793 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017793 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017793 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017793 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017793 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017793 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017793 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017793 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017793 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017793 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017793 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017793 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017793 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017793 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017793 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017793 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017793 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017793 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017793 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017793 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017793 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017793 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017793 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 12/04/2020        | ?               | ?             |
    | 10017793 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017793 | [ContractNo]       | 1                     | [AllocRef]    | 12/04/2020          | ?                 |




    # Change the date
    Given the override date is '15/05/2020'

    # Initiate non-financial amendment request on v1 to create v2. This should fail
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017793 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 12/04/2020        | ?               | ?             |
    | 10017793 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |
   
    # Check the WORKFLOW HISTORY for v1
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                    | CompletedBy      | Comment  |
    | Initiate Non-Financial Amendment (Vary)   | FCS2 Test        | ?        |
    | Non-Financial Amendment Initiation Failed | CRM Integration  | ?        |

    # Check that a NOTIFICATION has been created and sent to the initiating User 
	And   there is '1' notification of type 'Non-Financial Contract Amendment Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                                       | NotificationText                                                                                                                                       |
    | New    | Non-Financial Contract Amendment Failed - [ContractNo] | Contract [ContractNo] v1 for provider 10017793 (NACRO) cannot be amended - Non-financial amendments cannot be created for LEVY LEVY1799 contracts      |



    # Tidy up
    And   the override date is reset
      
@AcceptanceTest @Withdrawn20230123
Scenario: A797 Create and approve an EOF1417 contract. Initiate a non-financial variation amendment. Fail: Generate Contract Documentation=No. Check CRM, workflow history and notifications
    Given there is no Contract, Task or Workflow data for UKPRN '10017797'
	And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017797'
	And   there are no notifications in CRM of type 'Non-Financial Contract Amendment Failed' for UKPRN '10017797'
	And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | EOF-797       |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017797' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017797 Co Ltd' with UKPRN '10017797' and OrgId 'ORG0017797' and has 'FCS1 Test' as a manager 
    And   UPIN '117797' is associated with UKPRN '10017797' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017797 | 117797 | 10017797 Co Ltd | 0              | Active | Yes           | AA017797      | ?             | 

    # Change the date
    And   the override date is '20/03/2016'

    # Create contract
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017797 | 10017797 Co Ltd      | ESFA-797             | EMPF-797       | 1                     |  01/04/2016       |  31/03/2017     | 67978.00      | Contract for Services | 1420   | New          | ORG0017797 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName             | UoPCode | AllocationDescription  | CRMIntent    |
    | 10017797 | EMPF-797       | EOF-797       | EOF               | EOF                     |  01/04/2016         |  31/03/2017       | 67978.00        |                     |         |                        | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Apr-16   | May-16   | Jun-16   | Jul-16   | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | DeliverableDescription                  | CRMIntent    |
    | EMPF-797       | EOF-797       | 1               | 0                     | 66278.00 | 4237.00  | 5387.00  | 5795.00  | 8014.00  | 3185.00  | 7322.00  | 6881.00  | 6665.00  | 2269.00  | 5865.00  | 6402.00  | 4256.00  | Total Project Funding                   | New          |
    | EMPF-797       | EOF-797       | 2               | 1                     | 23456.00 | 707.00   | 2354.00  | 1027.00  | 3913.00  | 1291.00  | 2800.00  | 2088.00  | 2532.00  | 1027.00  | 1809.00  | 3415.00  | 493.00   | 16-18 Participation                     | New          |
    | EMPF-797       | EOF-797       | 3               | 1                     | 26599.00 | 2318.00  | 1419.00  | 3141.00  | 2649.00  | 852.00   | 3814.00  | 2964.00  | 3154.00  | 415.00   | 2886.00  | 1461.00  | 1526.00  | 19+ Participation                       | New          |
    | EMPF-797       | EOF-797       | 4               | 1                     | 16223.00 | 1212.00  | 1614.00  | 1627.00  | 1452.00  | 1042.00  | 708.00   | 1829.00  | 979.00   | 827.00   | 1170.00  | 1526.00  | 2237.00  | Infrastructure                          | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    And   the override date is '22/03/2016'

    # Publish the contract
    And   the latest version of contract 'EMPF-797' is in a state of 'Published to Provider'

    # Change the date
    And   the override date is '23/03/2016'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-797' and actual ContractNumber 'EMPF-797'

    # Check that the contract is now approved
    Then  the latest version of contract 'EMPF-797' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017797 | EMPF-797           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2016        | 31/03/2017      | ?             |
    | 10017797 | ESFA-797           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2016        | 31/03/2017      | ?             |

    # Change the date
    And   the override date is '15/09/2016'

    # Initiate non-financial amendment request on v1 to create v2. This should fail
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EMPF-797' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EMPF-797' for a non-financial VARIATION contract amendment

   # Check the state of the Amendment in Progress indicator. At this point it should be True
    Then  the value of the CRM Amendment Creation in Progress indicator on version '1' subversion '0' of contract 'EMPF-797' is 'True'
 
    # Check CONTRACT version, status and dates in CRM. Should be unchanged
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017797 | EMPF-797           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2016        | 31/03/2017      | ?             |
    | 10017797 | ESFA-797           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2016        | 31/03/2017      | ?             |

    # Check the WORKFLOW HISTORY for v1
    And   the workflow history on contract 'EMPF-797' version '1' includes the following
    | Action                                    | CompletedBy      | Comment  |
    | Initiate Non-Financial Amendment (Vary)   | FCS2 Test        | ?        |
    | Non-Financial Amendment Initiation Failed | CRM Integration  | ?        |

    # Check that a NOTIFICATION has been created and sent to the initiating User 
	And   there is '1' notification of type 'Non-Financial Contract Amendment Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                                       | NotificationText                                                                                                                                       |
    | New    | Non-Financial Contract Amendment Failed - EMPF-797     | Contract EMPF-797 v1 for provider 10017797 (10017797 Co Ltd) cannot be amended - Non-financial amendments cannot be created for EOF EOF1420 contracts  |

   # Check the state of the Amendment in Progress indicator. At this point it should be False
    And   the value of the CRM Amendment Creation in Progress indicator on version '1' subversion '0' of contract 'EMPF-797' is 'False'

    # Tidy up
    And   the override date is reset
	
@AcceptanceTest @Withdrawn20230123
Scenario: A798 Create and approve a 2-allocation 1718 Mainstream contract. Bulk amend. Initiate a non-financial notification amendment on v1. Fail: Draft v2 exists. Check CRM, workflow history and notifications
    Given there is no Contract, Task or Workflow data for UKPRN '10017798' 
	And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017798'
	And   there are no notifications in CRM of type 'Non-Financial Contract Amendment Failed' for UKPRN '10017798'
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16AP-798      |
    | 16NL-798      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017798' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017798 Co Ltd' with UKPRN '10017798' and OrgId 'ORG0017798' and has 'FCS1 Test' as a manager 
    And   UPIN '117798' is associated with UKPRN '10017798' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017798 | 117798 | 10017798 Co Ltd | 0              | Active | Yes           | AA017798      | ?             | 

    # Change the date
    And   the override date is '15/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017798 | 10017798 Co Ltd      | ESFA-798             | MAIN-798       | 1                     | 01/08/2017        | 31/07/2018      | 43029.00      |                                | Contract for Services | 1718   | New          | ORG0017798 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode    | AllocationDescription | CRMIntent    |
    | 10017798 | MAIN-798       | 16AP-798      | 16-18 APPS        | 16-18APPS1718           | AY                      | 01/08/2017          | 31/07/2018        | 22605.00        |         |            |                       | New          |
    | 10017798 | MAIN-798       | 16NL-798      | 16-18NLA          | 16-18NLA1718            | AY                      | 01/08/2017          | 31/07/2018        | 20424.00        |         |            |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                        | CRMIntent    |
    | 10017798 | MAIN-798       | 16AP-798      | 2               | 0                     | 22605.00  | 2202.00  | 1013.00  | 2084.00  | 967.00   | 406.00   | 3258.00  | 2193.00  | 1683.00  | 2897.00  | 3442.00  | 247.00   | 2213.00  | 16-18 Apprenticeships Total Funding           | New          |
    | 10017798 | MAIN-798       | 16NL-798      | 1               | 0                     | 20424.00  | 834.00   | 1552.00  | 3404.00  | 1145.00  | 401.00   | 827.00   | 2163.00  | 2176.00  | 2795.00  | 2203.00  | 830.00   | 2094.00  | Total 16-18 Non-Levy Apprenticeships Funding  | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    And   the override date is '17/07/2017'

    # Publish the contract
    And   the latest version of contract 'MAIN-798' is in a state of 'Published to Provider'

    # Change the date
    And   the override date is '19/07/2017'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-798' and actual ContractNumber 'MAIN-798'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-798' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017798 | MAIN-798           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017798 | ESFA-798           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Change the date 
    And   the override date is '21/07/2017' 

    # Cleardown prior to bulk import
    Given there are no files prefixed '10017798_MAIN-798' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1718 07032018152649 v2_A798' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1718 07032018152649 v2_A798' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 07032018152649 v2_A798' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 07032018152649 v2_A798' in the Sharepoint 'Reports' folder

    # Bulk import to amend the contract
    And   spreadsheet 'MAIN AY 1718 07032018152649 v2_A798.xlsx' exists in the Datafiles folder and UKPRN '10017798' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017798 | MAIN-798           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017798 | MAIN-798           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017798 | ESFA-798           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Change the date
    And   the override date is '23/07/2017'

    # Initiate non-financial amendment request on v1 to create v2. This should fail
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'MAIN-798' for a non-financial NOTIFICATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'MAIN-798' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017798 | MAIN-798           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017798 | MAIN-798           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017798 | ESFA-798           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the WORKFLOW HISTORY for v1
    And   the workflow history on contract 'MAIN-798' version '1' includes the following
    | Action                                    | CompletedBy      | Comment                     |
    | Initiate Non-Financial Amendment (Notify) | FCS2 Test       | ?                           |
    | Non-Financial Amendment Initiation Failed | CRM Integration  | ?                           |

    # Check that a NOTIFICATION has been created and sent to the initiating User 
	And   there is '1' notification of type 'Non-Financial Contract Amendment Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                                       | NotificationText                                                                                                                      |
    | New    | Non-Financial Contract Amendment Failed - MAIN-798     | Contract MAIN-798 v1 for provider 10017798 (10017798 Co Ltd) cannot be amended - A draft amendment already exists                     |

    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
Scenario: A799 Create and approve a 1718 NCS contract. Initiate a non-financial notification amendment. Fail: Contracting Activity Close Date passed. Check CRM, workflow history and notifications
    Given there is no Contract, Task or Workflow data for UKPRN '10017799'
	And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017799'
	And   there are no notifications in CRM of type 'Non-Financial Contract Amendment Failed' for UKPRN '10017799'
	And   the PaaS MonthEndIsRunning indicator is set to 'False'

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | NCSA-799      |
    | NCSC-799      |
    | NCSD-799      |
    | NCSE-799      |
    | NCSF-799      |
    | NCSI-799      |
    | NCSP-799      |
    | NCSS-799      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017799' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017799 Co Ltd' with UKPRN '10017799' and OrgId 'ORG0017799' and has 'FCS1 Test' as a manager 
    And   UPIN '117799' is associated with UKPRN '10017799' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017799 | 117799 | 10017799 Co Ltd | 0              | Active | Yes           | AA017799      | ?             | 

    # Change the date 
    And   the override date is '11/03/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017799 | 10017799 Co Ltd      | ESFA-799             | NCS-799        | 1                     | 01/04/2017        | 31/03/2018      | 351010.00     | Gyrwe                          | Contract for Services | 1718   | New          | ORG0017799 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription   | CRMIntent    |
    | 10017799 | NCS-799        | NCSA-799      | NCS-EA            | NCS-EA1718              | FY                      | 01/04/2017          | 31/03/2018        | 12893.00        | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017799 | NCS-799        | NCSC-799      | NCS-C             | NCS-C1718               | FY                      | 01/04/2017          | 31/03/2018        | 124811.00       | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017799 | NCS-799        | NCSD-799      | NCS-SEEDIC        | NCS-SEEDIC1718          | FY                      | 01/04/2017          | 31/03/2018        | 7920.00         | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017799 | NCS-799        | NCSE-799      | NCS-IC            | NCS-IC1718              | FY                      | 01/04/2017          | 31/03/2018        | 12509.00        | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017799 | NCS-799        | NCSF-799      | NCS-FWL           | NCS-FWL1718             | FY                      | 01/04/2017          | 31/03/2018        | 10337.00        | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017799 | NCS-799        | NCSI-799      | NCS-I             | NCS-I1718               | FY                      | 01/04/2017          | 31/03/2018        | 8965.00         | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017799 | NCS-799        | NCSP-799      | NCS-P             | NCS-P1718               | FY                      | 01/04/2017          | 31/03/2018        | 165854.00       | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017799 | NCS-799        | NCSS-799      | NCS-ASIST         | NCS-ASIST1718           | FY                      | 01/04/2017          | 31/03/2018        | 7721.00         | Central Eastern         | 0000000006 | Central Eastern         | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | DeliverableDescription                                      | CRMIntent    |
    | 10017799 | NCS-799        | NCSA-799      | 1               | 0                     | 12893.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4616.00  | 3024.00  | 0.00     | 0.00     | 5253.00  | Enabling Apprenticeships                                    | New          |
    | 10017799 | NCS-799        | NCSC-799      | 1               | 0                     | 124811.00 | 8831.00  | 11639.00 | 13644.00 | 7877.00  | 7856.00  | 10798.00 | 10556.00 | 11861.00 | 10437.00 | 10163.00 | 15853.00 | 5296.00  | Total In The Community Funding                              | New          |
    | 10017799 | NCS-799        | NCSC-799      | 2               | 1                     | 46074.00  | 4435.00  | 3351.00  | 5134.00  | 2568.00  | 1592.00  | 5510.00  | 3456.00  | 4900.00  | 3997.00  | 2596.00  | 5805.00  | 2730.00  | Customer Satisfaction                                       | New          |
    | 10017799 | NCS-799        | NCSC-799      | 3               | 1                     | 78737.00  | 4396.00  | 8288.00  | 8510.00  | 5309.00  | 6264.00  | 5288.00  | 7100.00  | 6961.00  | 6440.00  | 7567.00  | 10048.00 | 2566.00  | Career Management and Jobs and Learning                     | New          |
    | 10017799 | NCS-799        | NCSC-799      | 4               | 3                     | 38807.00  | 1597.00  | 4925.00  | 3029.00  | 3628.00  | 1171.00  | 1094.00  | 5144.00  | 5918.00  | 900.00   | 4215.00  | 5762.00  | 1424.00  | Career Management                                           | New          |
    | 10017799 | NCS-799        | NCSC-799      | 5               | 3                     | 39930.00  | 2799.00  | 3363.00  | 5481.00  | 1681.00  | 5093.00  | 4194.00  | 1956.00  | 1043.00  | 5540.00  | 3352.00  | 4286.00  | 1142.00  | Jobs and Learning                                           | New          |
    | 10017799 | NCS-799        | NCSC-799      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                 | New          |
    | 10017799 | NCS-799        | NCSD-799      | 1               | 0                     | 7920.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2606.00  | 5314.00  | Support and Enhance Existing Delivery In-Community Funding  | New          |
    | 10017799 | NCS-799        | NCSE-799      | 1               | 0                     | 12509.00  | 0.00     | 0.00     | 0.00     | 1785.00  | 0.00     | 2144.00  | 0.00     | 0.00     | 3921.00  | 0.00     | 0.00     | 4659.00  | Inspiration and Employer Engagement in Custody Activity     | New          |
    | 10017799 | NCS-799        | NCSF-799      | 1               | 0                     | 10337.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5527.00  | 0.00     | 0.00     | 4810.00  | Fuller Working Lives 50+                                    | New          |
    | 10017799 | NCS-799        | NCSI-799      | 1               | 0                     | 8965.00   | 0.00     | 2824.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5257.00  | 0.00     | 0.00     | 0.00     | 0.00     | 884.00   | Inspiration Activity                                        | New          |
    | 10017799 | NCS-799        | NCSP-799      | 1               | 0                     | 165854.00 | 11655.00 | 17189.00 | 14870.00 | 8890.00  | 12333.00 | 12986.00 | 13179.00 | 15249.00 | 20606.00 | 10134.00 | 13044.00 | 15719.00 | Total In Custody Funding                                    | New          |
    | 10017799 | NCS-799        | NCSP-799      | 2               | 1                     | 45838.00  | 3115.00  | 5120.00  | 5097.00  | 1167.00  | 3821.00  | 3440.00  | 4921.00  | 3039.00  | 5881.00  | 1537.00  | 4298.00  | 4402.00  | Customer Satisfaction                                       | New          |
    | 10017799 | NCS-799        | NCSP-799      | 3               | 1                     | 120016.00 | 8540.00  | 12069.00 | 9773.00  | 7723.00  | 8512.00  | 9546.00  | 8258.00  | 12210.00 | 14725.00 | 8597.00  | 8746.00  | 11317.00 | Career Management and Jobs and Learning                     | New          |
    | 10017799 | NCS-799        | NCSP-799      | 4               | 3                     | 39700.00  | 1359.00  | 4301.00  | 2410.00  | 1253.00  | 4091.00  | 3653.00  | 3813.00  | 5172.00  | 5656.00  | 1897.00  | 1571.00  | 4524.00  | Career Management                                           | New          |
    | 10017799 | NCS-799        | NCSP-799      | 5               | 3                     | 44855.00  | 5016.00  | 2465.00  | 5216.00  | 4846.00  | 2788.00  | 3838.00  | 2728.00  | 3513.00  | 3268.00  | 3851.00  | 4828.00  | 2498.00  | Jobs and Learning                                           | New          |
    | 10017799 | NCS-799        | NCSP-799      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                 | New          |
    | 10017799 | NCS-799        | NCSP-799      | 7               | 3                     | 35461.00  | 2165.00  | 5303.00  | 2147.00  | 1624.00  | 1633.00  | 2055.00  | 1717.00  | 3525.00  | 5801.00  | 2849.00  | 2347.00  | 4295.00  | Career Management 2                                         | New          |
    | 10017799 | NCS-799        | NCSS-799      | 1               | 0                     | 7721.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3181.00  | 4540.00  | Apprenticeship Specialist Intervention and Support Team     | New          |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | Total     | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | 10017799 | NCS-799        | NCSC-799      | 6               | 2692      | 270      | 134      | 287      | 220      | 74       | 204      | 294      | 178      | 332      | 227      | 155      | 317      |
    | 10017799 | NCS-799        | NCSP-799      | 6               | 2896      | 258      | 329      | 280      | 125      | 73       | 145      | 307      | 286      | 343      | 245      | 158      | 347      |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 

    # Check the deliverable counts in CRM 
   #And   there are 'nn' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
    And   there are '228' deliverable period rows in CRM linked to the latest version of contract 'NCS-799' 
   #And   there are 'nn' deliverable periods in CRM linked to the latest version of contract 'NCS-799' and allocation 'xxxx-799' 
 
    # Change the date 
    And   the override date is '17/03/2017' 
 
    # Publish the contract 
    And   the latest version of contract 'NCS-799' is in a state of 'Published to Provider' 
 
    # Change the date 
    And   the override date is '19/03/2017' 
 
    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-799' and actual ContractNumber 'NCS-799' 
 
    # Check that the contract is now approved 
    Then  the latest version of contract 'NCS-799' is in status 'Approved' 

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017799 | NCS-799            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2017        | 31/03/2018      | ?             |
    | 10017799 | ESFA-799           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2017        | 31/03/2018      | ?             |

    # Change the date (Contracting Activity Close Date for NCS1718 is 13/05/2018)
    And   the override date is '22/05/2018' 

    # Initiate non-financial amendment request on v1 to create v2. This should fail
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'NCS-799' for a non-financial NOTIFICATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'NCS-799' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017799 | NCS-799            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2017        | 31/03/2018      | ?             |
    | 10017799 | ESFA-799           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2017        | 31/03/2018      | ?             |

    # Check the WORKFLOW HISTORY for v1
    And   the workflow history on contract 'NCS-799' version '1' includes the following
    | Action                                    | CompletedBy      | Comment                        |
    | Initiate Non-Financial Amendment (Notify) | FCS2 Test       | ?                              |
    | Non-Financial Amendment Initiation Failed | CRM Integration  | ?                              |

    # Check that a NOTIFICATION has been created and sent to the initiating User 
	And   there is '1' notification of type 'Non-Financial Contract Amendment Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                                       | NotificationText                                                                                                                                       |
    | New    | Non-Financial Contract Amendment Failed - NCS-799      | Contract NCS-799 v1 for provider 10017799 (10017799 Co Ltd) cannot be amended - Contracting activity has closed for NCS FY1718 contracts               |

    # Tidy up
    And   the override date is reset

  