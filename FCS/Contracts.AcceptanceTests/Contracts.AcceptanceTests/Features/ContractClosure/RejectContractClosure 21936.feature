Feature: RejectContractClosure 21936

@AcceptanceTest @Withdrawn20240103 
@ContractClosure
@HighValue
Scenario: A827 Create and approve an ESF1420 contract. Successfully request contract closure then reject the closure approval. Check CRM. Request contract closure again then approve the closure. Check CRM, Tasks and Workflow History
    Given there is no Contract, Task or Workflow data for UKPRN '10017827' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there are no notifications of type 'Contract Closure Rejected'
    And   there are no notifications of type 'Contract Closure Initiation Failed'

    And   there is no data in the PerformanceManagement.ContractAllocation or ContractAllocationDeliverable tables for the following providers 
    | UKPRN    | 
    | 10017827 | 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ESF-827       |

    # Change the date 
    And   the override date is '12/07/2017' 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017827' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017827 Co Ltd' with UKPRN '10017827' and OrgId 'ORG0017827' and has 'FCS1 Test' as a manager 
    And   UPIN '117827' is associated with UKPRN '10017827' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017827 | 117827 | 10017827 Co Ltd | 0              | Active | Yes           | AA017827      | ?             | 

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017827 | 10017827 Co Ltd      | ESFA-827             | ESIF-827       | 1                     | 01/08/2017        | 31/07/2018      | 121727.00     | Contract for Services | 1420   | New          | ORG0017827 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName  | UoPCode  | AllocationDescription | CRMIntent  | LEPName                           | LEPCode | LotReference | TenderSpecificationReference | TenderAwardReference          | InvestmentPriority    | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017827 | ESIF-827       | ESF-827       | ESF 201420        | ESF                     | 01/08/2017          | 31/07/2018        | 121727.00       |          |          |                       | New        | Leicester and Leicestershire LEP  | E37021  | 00-1         | TSS_20125                    | 20125/23-415-00-1/10017827    | 1.4 Active Inclusion  | 777\SD\7827     | Job Seekers Fund    | SSR                | Transition     | 1.07                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                     | CRMIntent    | DeliveryOrg |
    | 10017827 | ESIF-827       | ESF-827       | 2               | 0                     |          | 29175.00  | 5000.00  | 132.00   | 1278.00  | 462.00   | 650.00   | 3046.00  | 2355.00  | 662.00   | 4709.00  | 2769.00  | 4527.00  | 3585.00  | RQ01 Regulated Learning                                    | New          |             |
    | 10017827 | ESIF-827       | ESF-827       | 3               | 0                     |          | 28878.00  | 509.00   | 1167.00  | 4080.00  | 2736.00  | 2155.00  | 2003.00  | 787.00   | 21.00    | 3230.00  | 3949.00  | 3273.00  | 4968.00  | NR01 Non Regulated Activity                                | New          |             |
    | 10017827 | ESIF-827       | ESF-827       | 8               | 0                     |          | 31033.00  | 2782.00  | 2963.00  | 1261.00  | 1992.00  | 590.00   | 917.00   | 4232.00  | 5575.00  | 3191.00  | 556.00   | 4551.00  | 2423.00  | SD01 Specification Defined Deliverable (with Description)  | New          |             |
    | 10017827 | ESIF-827       | ESF-827       | 9               | 0                     |          | 32641.00  | 4509.00  | 1652.00  | 4049.00  | 1554.00  | 557.00   | 3547.00  | 1036.00  | 5568.00  | 605.00   | 2674.00  | 1652.00  | 5238.00  | SD02 Specification Defined Deliverable (with Description)  | New          |             |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 
 
    # Change the date 
    And   the override date is '16/07/2017' 
 
    # Publish the contract 
    And   the latest version of contract 'ESIF-827' is in a state of 'Published to Provider' 
 
    # Change the date 
    And   the override date is '22/07/2017' 
 
    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-827' and actual ContractNumber 'ESIF-827' 
 
    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017827 | ESIF-827           | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017827 | ESFA-827           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017827 | ESIF-827           | 1                     | ESF-827       | 01/08/2017          | 31/07/2018        |
 
    # Change the date 
    And   the override date is '16/09/2018' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'ESIF-827' for provider '10017827'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017827 | ESIF-827           | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017827 | ESFA-827           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017827 | ESIF-827           | 1                     | ESF-827       | 01/08/2017          | 31/07/2018        |
 
    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'ESIF-827' for provider '10017827'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017827 - 10017827 Co Ltd | ESIF-827  | FCS1 Test | Contract Managers Team | Open  | Not Started |
    
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'ESIF-827' version '1' includes the following
    | Action                        | CompletedBy     | Comment                        |
    | Closure Initiation Successful | CRM Integration | ?                              |
    | Initiate Contract Closure     | FCS2 Test      | ?                              | 

    # Change the date 
    And   the override date is '18/09/2018' 

    # Reject closure approval in CRM. This should succeed
   #When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract 'ESIF-827' for provider '10017827'
    When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract 'ESIF-827' for provider '10017827' for the following reason
	| RejectionReason                                           |
	| Provider in dispute. Restated actuals may be forthcoming  |
	
    # Check the current state of the TASKS for this contract. Task should be completed
    Then  the following Tasks are present against version '1' of contract 'ESIF-827' for provider '10017827'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State     | Status    |
    | Confirm Closure Approval | 10017827 - 10017827 Co Ltd | ESIF-827  | FCS1 Test | Contract Managers Team | Completed | Completed |

    # Check CONTRACT version, status and dates in CRM. Contract should again be marked as Approved
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017827 | ESIF-827           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017827 | ESFA-827           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM. There should be no change
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017827 | ESIF-827           | 1                     | ESF-827       | 01/08/2017          | 31/07/2018        |
     
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'ESIF-827' version '1' includes the following
    | Action                        | CompletedBy      | Comment                                                  | 
    | Reject Closure                | FCS1 Test       | Provider in dispute. Restated actuals may be forthcoming | 
    | Closure Initiation Successful | CRM Integration  | ?                                                        | 
    | Initiate Contract Closure     | FCS2 Test       | ?                                                        | 

    # Check that a NOTIFICATION has been created and sent to the Advisor explaining why the closure has been rejected
	And   there is '1' notification of type 'Contract Closure Rejected' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                     | NotificationText                                                                                                                                     |
    | New    | Contract Closure Rejected - ESIF-827 | Closure of contract ESIF-827 v1 for provider 10017827 (10017827 Co Ltd) has been rejected - Provider in dispute. Restated actuals may be forthcoming |

    # Change the date 
    And   the override date is '19/09/2018' 

    # Request closure of the contract a second time. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'ESIF-827' for provider '10017827'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017827 | ESIF-827           | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017827 | ESFA-827           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017827 | ESIF-827           | 1                     | ESF-827       | 01/08/2017          | 31/07/2018        |
 
    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'ESIF-827' for provider '10017827'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State     | Status      |
    | Confirm Closure Approval | 10017827 - 10017827 Co Ltd | ESIF-827  | FCS1 Test | Contract Managers Team | Open      | Not Started |
    | Confirm Closure Approval | 10017827 - 10017827 Co Ltd | ESIF-827  | FCS1 Test | Contract Managers Team | Completed | Completed   |
    
     # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'ESIF-827' version '1' includes the following
    | Action                        | CompletedBy      | Comment                                                  | 
    | Reject Closure                | FCS1 Test       | Provider in dispute. Restated actuals may be forthcoming | 
    | Closure Initiation Successful | CRM Integration  | ?                                                        | 
    | Initiate Contract Closure     | FCS2 Test       | ?                                                        | 

    # Change the date 
    And   the override date is '20/09/2018' 

    # This time, approve closure of the contract. This should succeed
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract 'ESIF-827' for provider '10017827'
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract 'ESIF-827' for provider '10017827'

    # Check that there are no open Tasks
    Then  all Tasks against version '1' of contract 'ESIF-827' for provider '10017827' have their state and status set to Completed

    # Check CONTRACT version, status and dates in CRM. The contract end date should have been set
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017827 | ESIF-827           | 1                     | 0                        | Closed           | Closed                    | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017827 | ESFA-827           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM. The allocation end date should have been set
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017827 | ESIF-827       | 1                     | ESF-827       | 01/08/2017          | 31/07/2018        |

    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'ESIF-827' version '1' includes the following
    | Action                        | CompletedBy      | Comment                                                  | 
    | Contract Closure Successful   | CRM Integration  | ?                                                        | 
    | Reject Closure                | FCS1 Test       | Provider in dispute. Restated actuals may be forthcoming | 
    | Closure Initiation Successful | CRM Integration  | ?                                                        | 
    | Initiate Contract Closure     | FCS2 Test       | ?                                                        | 

    # Tidy up
    And   the override date is reset
 
@AcceptanceTest @Complete 
@PublishNewLevyContract @ContractClosure
Scenario: A850 Create and approve a Levy contract. Successfully request contract closure then reject the closure approval. Check CRM. Request contract closure again then approve the closure. Check CRM, Tasks and Workflow History
    Given there is no Contract, Task or Workflow data for UKPRN '10017850'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017850 Co Ltd' with UKPRN '10017850' and OrgId 'ORG0017850' and has 'FCS1 Test' as a manager
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017850'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017850'
    And   there are no notifications of type 'Contract Closure Rejected'
   #And   there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017850'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS

   # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017850'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017850 Co Ltd' with UKPRN '10017850' and OrgId 'ORG0017850' and has 'FCS1 Test' as a manager
    And   UPIN '117850' is associated with UKPRN '10017850' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017850 | 117850 | 10017850 Co Ltd | 0              | Active |




    # Change the date 
    Given the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 41264 | INITIATED | 2017-09-15T18:03:32.2898 | 10017850   | 28966             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017850'
    And   there is only one Levy contract in CRM for UKPRN '10017850' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017850 | 10017850 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017850 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017850 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
    | 10017850 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                  | 
    | 10017850 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships        | 
    | 10017850 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships        | 
    | 10017850 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017850 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve parameters from CRM 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017850' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017850' 
    When  I retrieve the latest contract details from CRM for provider '10017850' for FundingType 'LEVY' and period '1799' 

    ## Check deliverable period count prior to approval
    #Then  there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Change the date 
    Given the override date is '04/02/2021'

    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 
 
    ## Check deliverable period count after approval 
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a Feb-21 deliverable period for each of deliverables 1 through 14 for each allocation 
    Then   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Feb-21   | DeliverableDescription                               | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017850 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 04/02/2021        | ?               | ?             |
    | 10017850 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017850 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 04/02/2021          | ?                 |
    | 10017850 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 04/02/2021          | ?                 |




    # Change the date 
    Given the override date is '05/06/2021' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '[ContractNo]' for provider '10017850'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017850 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 04/02/2021        | ?               | ?             |
    | 10017850 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017850 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 04/02/2021          | ?                 |
    | 10017850 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 04/02/2021          | ?                 |
 
    # Check the current state of the TASKS for this contract
    And   the following new Task has been created against version '1' of contract '[ContractNo]' for provider '10017850'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017850 - 10017850 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Open  | Not Started |

    # Check the WORKFLOW HISTORY
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy      | Comment                           |
    | Closure Initiation Successful | CRM Integration  | ?                                 |
    | Initiate Contract Closure     | FCS2 Test        | ?                                 |

    # Check the CM feed for the absence of an ItemType 3 (Closure) row
    And   the ContractManagement.AtomFeedItem table does not contain an ItemType '3' event for version '1' of contract number '[ContractNo]'	




	# Change the date 
    Given the override date is '08/06/2021' 

    # Reject closure approval in CRM. This should succeed
   #When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract '[ContractNo]' for provider '10017850'
    When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract '[ContractNo]' for provider '10017850' for the following reason
    | RejectionReason                               |
    | Re our discussion, this is the wrong provider |
	
    # Check the current state of the TASKS for this contract. Task should be completed
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017850'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State     | Status    |
    | Confirm Closure Approval | 10017850 - 10017850 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Completed | Completed |

    # Check CONTRACT version, status and dates in CRM. Contract should again be marked as Approved
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017850 | [ContractNo]       | 1                     | 0                        | Approved       | Approved          | True          | True                | 04/02/2021        | ?               | ?             |
    | 10017850 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                 | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM. There should be no change
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017850 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 04/02/2021          | ?                 |
    | 10017850 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 04/02/2021          | ?                 |
     
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy      | Comment                                       | 
    | Reject Closure                | FCS1 Test        | Re our discussion, this is the wrong provider | 
    | Closure Initiation Successful | CRM Integration  | ?                                             | 
    | Initiate Contract Closure     | FCS2 Test        | ?                                             | 

    # Check that a NOTIFICATION has been created and sent to the Advisor explaining why the closure has been rejected
	And   there is '1' notification of type 'Contract Closure Rejected' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                         | NotificationText                                                                                                                              |
    | New    | Contract Closure Rejected - [ContractNo] | Closure of contract [ContractNo] v1 for provider 10017850 (10017850 Co Ltd) has been rejected - Re our discussion, this is the wrong provider |

    # Check the CM feed for the absence of an ItemType 3 (Closure) row
    And   the ContractManagement.AtomFeedItem table does not contain an ItemType '3' event for version '1' of contract number '[ContractNo]'	




    # Change the date 
    Given the override date is '12/06/2021' 

    # Request closure of the contract a second time. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '[ContractNo]' for provider '10017850'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017850 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 04/02/2021        | ?               | ?             |
    | 10017850 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017850 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 04/02/2021          | ?                 |
    | 10017850 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 04/02/2021          | ?                 |
 
    # Check the current state of the TASKS for this contract
    And   the following new Task has been created against version '1' of contract '[ContractNo]' for provider '10017850'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State     | Status      |
    | Confirm Closure Approval | 10017850 - 10017850 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Open      | Not Started |
    | Confirm Closure Approval | 10017850 - 10017850 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Completed | Completed   |

    # Check the WORKFLOW HISTORY
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy      | Comment                                       |
    | Reject Closure                | FCS1 Test        | Re our discussion, this is the wrong provider | 
    | Closure Initiation Successful | CRM Integration  | ?                                             | 
    | Initiate Contract Closure     | FCS2 Test        | ?                                             | 




    # Change the date 
    Given the override date is '22/06/2021' 

    # This time, approve closure of the contract. This should succeed
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract '[ContractNo]' for provider '10017850'
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract 'ContractNo]' for provider '10017850'

    # Check that there are no open Tasks
    Then  all Tasks against version '1' of contract '[ContractNo]' for provider '10017850' have their state and status set to Completed

    # Check CONTRACT version, status and dates in CRM. The contract end date should have been set
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017850 | [ContractNo]       | 1                     | 0                        | Closed         | Closed            | True          | True                | 04/02/2021        | 22/06/2021      | ?             |
    | 10017850 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                 | False         | False               | 01/05/2017        | ?               | ?             |

   # Check ALLOCATION dates in CRM. The allocation end date should have been set
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017850 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 04/02/2021          | 22/06/2021        |
    | 10017850 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 04/02/2021          | 22/06/2021        |

    # Check the WORKFLOW HISTORY
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy      | Comment                                       |
    | Contract Closure Successful   | CRM Integration  | ?                                             |
    | Reject Closure                | FCS1 Test        | Re our discussion, this is the wrong provider | 
    | Closure Initiation Successful | CRM Integration  | ?                                             | 
    | Initiate Contract Closure     | FCS2 Test        | ?                                             | 

    # Check the CM feed for the presence of an ItemType 3 (Closure) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '3' event for version '1' of actual contract number '[ContractNo]'
    And   the ItemType '3' event for version '1' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema


	# Tidy Up
    And   the override date is reset

