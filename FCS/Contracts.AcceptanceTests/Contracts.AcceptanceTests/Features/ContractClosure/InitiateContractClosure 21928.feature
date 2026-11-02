Feature: InitiateContractClosure 21928

@AcceptanceTest @Withdrawn20260521 
@ContractClosure
Scenario: A813 Create and approve an ESF contract. Successfully request contract closure. Attempt to amend while contract closure is pending. Fail UDC020
    Given there is no Contract, Task or Workflow data for UKPRN '10017813' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no data in the PerformanceManagement.ContractAllocation or ContractAllocationDeliverable tables for the following providers 
    | UKPRN    | 
    | 10017813 | 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ESF-813       |

    # Change the date 
    And   the override date is '12/07/2017' 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017813' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017813 Co Ltd' with UKPRN '10017813' and OrgId 'ORG0017813' and has 'FCS1 Test' as a manager 
    And   UPIN '117813' is associated with UKPRN '10017813' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017813 | 117813 | 10017813 Co Ltd | 0              | Active | Yes           | AA017813      | ?             | 

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017813 | 10017813 Co Ltd      | ESFA-813             | ESIF-813       | 1                     | 01/08/2017        | 31/07/2018      | 121727.00     | Contract for Services | 1420   | New          | ORG0017813 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName  | UoPCode  | AllocationDescription | CRMIntent  | LEPName                           | LEPCode | LotReference | TenderSpecificationReference | TenderAwardReference          | InvestmentPriority    | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017813 | ESIF-813       | ESF-813       | ESF 201420        | ESF                     | 01/08/2017          | 31/07/2018        | 121727.00       |          |          |                       | New        | Leicester and Leicestershire LEP  | E37021  | 00-1         | TSS_20125                    | 20125/23-415-00-1/10017813    | 1.4 Active Inclusion  | 777\SD\7813     | Job Seekers Fund    | SSR                | Transition     | 1.07                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                     | CRMIntent    | DeliveryOrg |
    | 10017813 | ESIF-813       | ESF-813       | 2               | 0                     |          | 29175.00  | 5000.00  | 132.00   | 1278.00  | 462.00   | 650.00   | 3046.00  | 2355.00  | 662.00   | 4709.00  | 2769.00  | 4527.00  | 3585.00  | RQ01 Regulated Learning                                    | New          |             |
    | 10017813 | ESIF-813       | ESF-813       | 3               | 0                     |          | 28878.00  | 509.00   | 1167.00  | 4080.00  | 2736.00  | 2155.00  | 2003.00  | 787.00   | 21.00    | 3230.00  | 3949.00  | 3273.00  | 4968.00  | NR01 Non Regulated Activity                                | New          |             |
    | 10017813 | ESIF-813       | ESF-813       | 8               | 0                     |          | 31033.00  | 2782.00  | 2963.00  | 1261.00  | 1992.00  | 590.00   | 917.00   | 4232.00  | 5575.00  | 3191.00  | 556.00   | 4551.00  | 2423.00  | SD01 Specification Defined Deliverable (with Description)  | New          |             |
    | 10017813 | ESIF-813       | ESF-813       | 9               | 0                     |          | 32641.00  | 4509.00  | 1652.00  | 4049.00  | 1554.00  | 557.00   | 3547.00  | 1036.00  | 5568.00  | 605.00   | 2674.00  | 1652.00  | 5238.00  | SD02 Specification Defined Deliverable (with Description)  | New          |             |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 
 
    # Change the date 
    And   the override date is '16/07/2017' 
 
    # Publish the contract 
    And   the latest version of contract 'ESIF-813' is in a state of 'Published to Provider' 
 
    # Change the date 
    And   the override date is '22/07/2017' 
 
    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-813' and actual ContractNumber 'ESIF-813' 
 
    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017813 | ESIF-813           | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017813 | ESFA-813           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017813 | ESIF-813           | 1                     | ESF-813       | 01/08/2017          | 31/07/2018        |
 
    # Change the date 
    And   the override date is '16/09/2018' 

	# Request closure of the contract. This should succeed
	When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'ESIF-813' for provider '10017813'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017813 | ESIF-813           | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017813 | ESFA-813           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017813 | ESIF-813           | 1                     | ESF-813       | 01/08/2017          | 31/07/2018        |
 
    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'ESIF-813' for provider '10017813'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017813 - 10017813 Co Ltd | ESIF-813  | FCS1 Test | Contract Managers Team | Open  | Not Started |
    
 	# Check the WORKFLOW HISTORY
	And   the workflow history on contract 'ESIF-813' version '1' includes the following
	| Action                        | CompletedBy      | Comment                       | 
	| Closure Initiation Successful | CRM Integration  | ?                             |
	| Initiate Contract Closure     | FCS2 Test       | ?                             |

    # Change the date 
    And   the override date is '18/09/2018' 

    # Bulk file to attempt a contract amendment. This should fail. Amendments are not permitted once contract closure has started  (21777)
    Given there are no files prefixed '10017813_ESF-813' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 19012018111614 v2_A813' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 19012018111614 v2_A813' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 19012018111614 v2_A813' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 19012018111614 v2_A813.xlsx' exists in the Datafiles folder and UKPRN '10017813' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
   #And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report
    
	# UDC020 error message
	And   '[Contract] Cannot create a draft Contract Amendment if there is no existing Approved Contract' is displayed in field 'J2' on the 'Contract' tab of the result report file

    # Tidy up
    And   the override date is reset

@AcceptanceTest @Complete 
@PublishNewLevyContract @ContractClosure
Scenario: A814 Create and approve a Levy contract. Successfully request contract closure. Minimal validation
    Given there is no Contract, Task or Workflow data for UKPRN '10017814'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017814 Co Ltd' with UKPRN '10017814' and OrgId 'ORG0017814' and has 'FCS1 Test' as a manager
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017814'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017814'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS

    # Change the date 
    And   the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id     | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42864  | INITIATED | 2017-09-15T18:03:12.2539 | 10017814   | 28913             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017814'
    And   there is only one Levy contract in CRM for UKPRN '10017814' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017814 | 10017814 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017814 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017814 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
	| 10017814 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription              | 
    | 10017814 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships    | 
    | 10017814 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships    | 
	| 10017814 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017814 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve parameters from CRM  
   #When  I retrieve the latest EFA contract details from CRM for provider '10017814' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017814' 
    And   I retrieve the latest contract details from CRM for provider '10017814' for FundingType 'LEVY' and period '1799' 

    ## Check deliverable period count prior to approval
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Change the date 
    Given the override date is '12/04/2020'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    ## Check deliverable period count after approval 
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a Apr-20 deliverable period for each of deliverables 1 through 14 for each allocation
    Then   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Apr-20   | DeliverableDescription                               | 
    | 10017814 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017814 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017814 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017814 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017814 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017814 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017814 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017814 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017814 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017814 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017814 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017814 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017814 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017814 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017814 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017814 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017814 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017814 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017814 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017814 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017814 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017814 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017814 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017814 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017814 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017814 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017814 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017814 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017814 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 12/04/2020        | ?               | ?             |
    | 10017814 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017814 | [ContractNo]       | 1                     | [AllocRef]    | 12/04/2020          | ?                 |




    # Change the date 
    Given the override date is '16/09/2020' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '[ContractNo]' for provider '10017814'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017814 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 12/04/2020        | ?               | ?             |
    | 10017814 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017814 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 12/04/2020          | ?                 |
    | 10017814 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 12/04/2020          | ?                 |
 
    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017814'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017814 - 10017814 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Open  | Not Started |
    
    # Check that the workflow history includes two new entries
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
	| Action                        | CompletedBy      | Comment                           | 
	| Closure Initiation Successful | CRM Integration  | ?                                 | 
	| Initiate Contract Closure     | FCS2 Test        | ?                                 | 


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002 
@ContractClosure
Scenario: A815 Create and approve a 2-allocation 1718 Mainstream contract. Fail to close contract: contract not yet ended
    Given there is no Contract, Task or Workflow data for UKPRN '10017815' 
	And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there are no notifications of type 'Contract Closure Initiation Failed' 
   #And   there are no notifications in CRM of type 'Contract Closure Initiation Failed' for UKPRN '10017815'
 
    And   there is no data in the PerformanceManagement.ContractAllocation or ContractAllocationDeliverable tables for the following providers 
    | UKPRN    | 
    | 10017815 | 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16AP-815      |
    | 16NL-815      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017815' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017815 Co Ltd' with UKPRN '10017815' and OrgId 'ORG0017815' and has 'FCS1 Test' as a manager 
    And   UPIN '117815' is associated with UKPRN '10017815' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017815 | 117815 | 10017815 Co Ltd | 0              | Active | Yes           | AA017815      | ?             | 

    # Change the date
    And   the override date is '10/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription | ContractType          | Period | CRMIntent | OrgId      |
    | 10017815 | 10017815 Co Ltd      | ESFA-815             | MAIN-815       | 1                     | 01/08/2017        | 31/07/2018      | 39253.00      |                     | Contract for Services | 1718   | New       | ORG0017815 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent |
    | 10017815 | MAIN-815       | 16AP-815      | 16-18 APPS        | 16-18APPS1718           | AY                      | 01/08/2017          | 09/07/2018        | 16684.00        |         |         |                       | New       |
    | 10017815 | MAIN-815       | 16NL-815      | 16-18NLA          | 16-18NLA1718            | AY                      | 22/08/2017          | 31/07/2018        | 22569.00        |         |         |                       | New       |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                        | CRMIntent |
    | 10017815 | MAIN-815       | 16AP-815      | 2               | 0                     | 16684.00  | 2584.00  | 1006.00  | 1280.00  | 1545.00  | 3311.00  | 469.00   | 2279.00  | 1250.00  | 410.00   | 689.00   | 318.00   | 1543.00  | 16-18 Apprenticeships Total Funding           | New       |
    | 10017815 | MAIN-815       | 16NL-815      | 1               | 0                     | 22569.00  | 3360.00  | 1920.00  | 1756.00  | 3407.00  | 801.00   | 1357.00  | 1416.00  | 1021.00  | 1787.00  | 528.00   | 1835.00  | 3381.00  | Total 16-18 Non-Levy Apprenticeships Funding  | New       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract 'MAIN-815' is in a state of 'Published to Provider'

    # Check the deliverable count in CRM 
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'MAIN-815'

    # Change the date
    And   the override date is '12/07/2017'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-815' and actual ContractNumber 'MAIN-815'

    # Check the deliverable count in CRM has increased to reflect the addition of monitoring deliverables 
    Then  there are '72' deliverable periods in CRM linked to the latest version of contract 'MAIN-815' and allocation '16AP-815'
    And   there are '48' deliverable periods in CRM linked to the latest version of contract 'MAIN-815' and allocation '16NL-815'

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017815 | MAIN-815           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017815 | ESFA-815           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017815 | MAIN-815           | 1                     | 16AP-815      | 01/08/2017          | 09/07/2018        |
    | 10017815 | MAIN-815           | 1                     | 16NL-815      | 22/08/2017          | 31/07/2018        |

    # Change the date 
    And   the override date is '22/07/2018' 

	# Request closure of the contract. This should fail because the contract has not yet ended
	When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'MAIN-815' for provider '10017815'

    # Check that CONTRACT version, status and dates in CRM have not changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017815 | MAIN-815           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017815 | ESFA-815           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check that ALLOCATION dates in CRM have not changed
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017815 | MAIN-815           | 1                     | 16AP-815      | 01/08/2017          | 09/07/2018        |
    | 10017815 | MAIN-815           | 1                     | 16NL-815      | 22/08/2017          | 31/07/2018        |

	# Check that a NOTIFICATION has been created and sent to the Advisor explaining why the closure failed
	And   there is '1' notification of type 'Contract Closure Initiation Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                              | NotificationText                                                                                                 |
    | New    | Contract Closure Initiation Failed - MAIN-815 | Contract MAIN-815 v1 for provider 10017815 (10017815 Co Ltd) cannot be closed - its end date must be in the past |

 	# Check that the workflow history includes two new entries
	And   the workflow history on contract 'MAIN-815' version '1' includes the following
	| Action                        | CompletedBy      | Comment                       | 
	| Closure Initiation Failed     | CRM Integration  | ?                             |
	| Initiate Contract Closure     | FCS2 Test        | ?                             |

    # Tidy up
    And   the override date is reset

@AcceptanceTest @Complete 
@PublishNewLevyContract @ContractClosure
Scenario: A816 Create and approve a Levy contract. Fail to close contract: contract not approved
    Given there is no Contract, Task or Workflow data for UKPRN '10017816'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017816 Co Ltd' with UKPRN '10017816' and OrgId 'ORG0017816' and has 'FCS1 Test' as a manager
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017816'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017816'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
   #And   there are no notifications of type 'Contract Closure Initiation Failed'
    And   there are no notifications in CRM of type 'Contract Closure Initiation Failed' for UKPRN '10017816'

    # Change the date 
    And   the override date is '20/10/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id     | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 45963  | INITIATED | 2017-10-19T18:03:12.3145 | 10017816   | 20553             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017816'
    And   there is only one Levy contract in CRM for UKPRN '10017816' with a status of 'Draft'

    Then  there is only one Levy contract in CRM for UKPRN '10017816' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 

    # Retrieve parameters from CRM  
   #When  I retrieve the latest EFA contract details from CRM for provider '10017816' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017816' 
    And   I retrieve the latest contract details from CRM for provider '10017816' for FundingType 'LEVY' and period '1799' 

    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017816 | 10017816 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017816 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017816 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017816 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017816 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017816 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017816 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017816 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    ## Check deliverable period count prior to approval 
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017816 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider  | True          | False               | 01/05/2017        | ?               | ?             |
    | 10017816 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017816 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 01/05/2017          | ?                 |
    | 10017816 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 01/05/2017          | ?                 |




    # Change the date 
    Given the override date is '22/10/2017'

    # Request closure of the contract. This should fail because the contract is not in an approved state
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '[ContractNo]' for provider '10017816'

    # Check that CONTRACT version, status and dates in CRM have not changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017816 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider  | True          | False               | 01/05/2017        | ?               | ?             |
    | 10017816 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check that ALLOCATION dates in CRM have not changed
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017816 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 01/05/2017          | ?                 |
	| 10017816 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 01/05/2017          | ?                 |
 
	# Check that a NOTIFICATION has been created and sent to the Advisor explaining why the closure failed
	And   there is '1' notification of type 'Contract Closure Initiation Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                                  | NotificationText                                                                                                                                                           |
#   | New    | Contract Closure Initiation Failed - [ContractNo] | Contract [ContractNo] v1 for provider 10017816 (10017816 Co Ltd) cannot be closed -  it must be either Approved or Under Termination (without a Contract Termination Date) |
    | New    | Contract Closure Initiation Failed - [ContractNo] | Contract [ContractNo] v1 for provider 10017816 (10017816 Co Ltd) cannot be closed - it must be either Approved or Modified                                                 |

# 	# Check that the workflow history includes two new entries
#	And   the workflow history on contract '[ContractNo]' version '1' includes the following
#	| Action                        | CompletedBy      | Comment                           | 
#	| Closure Initiation Failed     | CRM Integration  | ?                                 |
#	| Initiate Contract Closure     | FCS2 Test        | ?                                 |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20260521 
@ContractClosure
Scenario: A817 Create and approve a 1718 AGE contract. Update draft to create v2. Fail to close v1: draft v2 exists
    Given there is no Contract, Task or Workflow data for UKPRN '10017817' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
   #And   there are no notifications of type 'Contract Closure Initiation Failed'
    And   there are no notifications in CRM of type 'Contract Closure Initiation Failed' for UKPRN '10017817'
 
    And   there is no data in the PerformanceManagement.ContractAllocation or ContractAllocationDeliverable tables for the following providers 
    | UKPRN    | 
    | 10017817 | 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AGE-817       |

    # Change the date 
    And   the override date is '12/03/2017' 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017817' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017817 Co Ltd' with UKPRN '10017817' and OrgId 'ORG0017817' and has 'FCS1 Test' as a manager 
    And   UPIN '117817' is associated with UKPRN '10017817' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017817 | 117817 | 10017817 Co Ltd | 0              | Active | Yes           | AA017817      | ?             | 

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017817 | 10017817 Co Ltd      | ESFA-817             | EMPAGE-817     | 1                     |  01/04/2017       |  31/03/2018     | 45377.00      | Contract for Services | 1718   | New          | ORG0017817 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName             | UoPCode | AllocationDescription  | CRMIntent    |
    | 10017817 | EMPAGE-817     | AGE-817       | AGE               | FY                      |  01/04/2017         |  31/03/2018       | 45377.00        |                     |         |                        | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Total     | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | DeliverableName                                   | CRMIntent    |
    | 10017817 | EMPAGE-817     | AGE-817       | 1               | 0                     |          | 17886.00  | 1250.00  | 259.00   | 1686.00  | 319.00   | 426.00   | 1837.00  | 3155.00  | 2301.00  | 318.00   | 1652.00  | 2242.00  | 2441.00  | 16-18 Apprenticeship Grant for Employers          | New          |
    | 10017817 | EMPAGE-817     | AGE-817       | 2               | 0                     |          | 27491.00  | 685.00   | 3178.00  | 2774.00  | 2515.00  | 459.00   | 879.00   | 3611.00  | 3189.00  | 1883.00  | 3268.00  | 1461.00  | 3589.00  | 19-24 Apprenticeship Grant for Employers          | New          |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 
 
    # Change the date 
    And   the override date is '16/03/2017' 
 
    # Publish the contract 
    And   the latest version of contract 'EMPAGE-817' is in a state of 'Published to Provider' 
 
    # Change the date 
    And   the override date is '22/03/2017' 
 
    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-817' and actual ContractNumber 'EMPAGE-817' 
 
    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017817 | EMPAGE-817         | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/04/2017        | 31/03/2018      | ?             |
    | 10017817 | ESFA-817           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/04/2017        | 31/03/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017817 | EMPAGE-817         | 1                     | AGE-817       | 01/04/2017          | 31/03/2018        |
 
    # Change the date 
    And   the override date is '15/12/2017' 

    # Bulk file to amend the contract 
    Given there are no files prefixed '10017817_NCS-817' in the Sharepoint 'AGE-1718-Input-Appendices' folder
    And   there are no files prefixed 'AGE FY 1718 18012018095312 v2_A817' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AGE FY 1718 18012018095312 v2_A817' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AGE FY 1718 18012018095312 v2_A817' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AGE FY 1718 18012018095312 v2_A817.xlsx' exists in the Datafiles folder and UKPRN '10017817' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017817 | EMPAGE-817         | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2017        | 31/03/2018      | Variation     |
    | 10017817 | EMPAGE-817         | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/04/2017        | 31/03/2018      | ?             |
    | 10017817 | ESFA-817           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2017        | 31/03/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017817 | EMPAGE-817         | 2                     | AGE-817       | 01/04/2017          | 31/03/2018        |
    | 10017817 | EMPAGE-817         | 1                     | AGE-817       | 01/04/2017          | 31/03/2018        |

    # Change the date 
    And   the override date is '16/04/2018' 

    # Request closure of the contract. This should fail because there is a draft v2 of the contract
	When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'EMPAGE-817' for provider '10017817'

    # Check that CONTRACT version, status and dates in CRM have not changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017817 | EMPAGE-817         | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2017        | 31/03/2018      | Variation     |
    | 10017817 | EMPAGE-817         | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/04/2017        | 31/03/2018      | ?             |
    | 10017817 | ESFA-817           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2017        | 31/03/2018      | ?             |

    # Check that ALLOCATION dates in CRM have not changed
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017817 | EMPAGE-817         | 2                     | AGE-817       | 01/04/2017          | 31/03/2018        |
    | 10017817 | EMPAGE-817         | 1                     | AGE-817       | 01/04/2017          | 31/03/2018        |
 
	# Check that a NOTIFICATION has been created and sent to the Advisor explaining why the closure failed
	And   there is '1' notification of type 'Contract Closure Initiation Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                                | NotificationText                                                                                                        |
    | New    | Contract Closure Initiation Failed - EMPAGE-817 | Contract EMPAGE-817 v1 for provider 10017817 (10017817 Co Ltd) cannot be closed - an outstanding draft amendment exists |

 	# Check that the WORKFLOW HISTORY includes the following entries
	And   the workflow history on contract 'EMPAGE-817' version '1' includes the following
	| Action                        | CompletedBy      | Comment                         | 
	| Closure Initiation Failed     | CRM Integration  | ?                               | 
	| Initiate Contract Closure     | FCS2 Test        | ?                               | 

    # Tidy up
    And   the override date is reset

@AcceptanceTest @Complete 
@PublishNewLevyContract @ContractClosure
Scenario: A818 Create a Levy contract but leave it at published to provider. Fail to close contract: v1 is in draft
    Given there is no Contract, Task or Workflow data for UKPRN '10017818'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017818 Co Ltd' with UKPRN '10017818' and OrgId 'ORG0017818' and has 'FCS1 Test' as a manager
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017818'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017818'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
   #And   there are no notifications of type 'Contract Closure Initiation Failed'
	And   there are no notifications in CRM of type 'Contract Closure Initiation Failed' for UKPRN '10017818'

    # Change the date 
    And   the override date is '12/12/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id     | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42964  | INITIATED | 2017-09-17T19:03:10.1439 | 10017818   | 59123             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017818'

    Then  there is only one Levy contract in CRM for UKPRN '10017818' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 

    # Retrieve parameters from CRM  
   #When  I retrieve the latest EFA contract details from CRM for provider '10017818' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017818' 
    And   I retrieve the latest contract details from CRM for provider '10017818' for FundingType 'LEVY' and period '1799' 




    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017818 | 10017818 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017818 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017818 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017818 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017818 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017818 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017818 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017818 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    ## Check deliverable period count prior to approval 
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017818 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider  | True          | False               | 01/05/2017        | ?               | ?             |
    | 10017818 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |
																																																				
    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017818 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 01/05/2017          | ?                 |
    | 10017818 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 01/05/2017          | ?                 |




    # Change the date 
    Given the override date is '03/03/2018' 

    # Request closure of the contract. This should fail because the latest version of the contract is draft
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '[ContractNo]' for provider '10017818'

    # Check that CONTRACT version, status and dates in CRM have not changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017818 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/05/2017        | ?               | ?             |
    | 10017818 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check that ALLOCATION dates in CRM have not changed
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017818 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 01/05/2017          | ?                 |
    | 10017818 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 01/05/2017          | ?                 |
 
	# Check that a NOTIFICATION has been created and sent to the Advisor explaining why the closure failed (Text changed when Terminations was rewritten in Oct 20)
	And   there is '1' notification of type 'Contract Closure Initiation Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                                  | NotificationText                                                                                                                                                           |
#   | New    | Contract Closure Initiation Failed - [ContractNo] | Contract [ContractNo] v1 for provider 10017818 (10017818 Co Ltd) cannot be closed -  it must be either Approved or Under Termination (without a Contract Termination Date) |
    | New    | Contract Closure Initiation Failed - [ContractNo] | Contract [ContractNo] v1 for provider 10017818 (10017818 Co Ltd) cannot be closed - it must be either Approved or Modified                                                 |

    # Check that the WORKFLOW HISTORY includes two new entries
	#And   the workflow history on contract '[ContractNo]' version '1' includes the following
	#| Action                        | CompletedBy      | Comment                           | 
	#| Closure Initiation Failed     | CRM Integration  | ?                                 | 
	#| Initiate Contract Closure     | FCS2 Test        | ?                                 | 

    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002 
@ContractClosure
Scenario: A819 Create and approve a 1718 NCS contract. Consume actuals. Fail to close contract: outstanding payment
    Given there is no Contract, Task or Workflow data for UKPRN '10017819'
   #And   there are no notifications of type 'Contract Closure Initiation Failed'
    And   there are no notifications in CRM of type 'Contract Closure Initiation Failed' for UKPRN '10017819'

	# Cleardown and reset PaymentGeneration.PaymentTimetable 
	# This is needed for CM.ApprovedContract and CM.ApprovedContractAllocation checks to work
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | NCS-C1718                  | 201803               |                      | A              | NotStarted |

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | NCSC-819      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017819' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017819 Co Ltd' with UKPRN '10017819' and OrgId 'ORG0017819' and has 'FCS1 Test' as a manager 
    And   UPIN '117819' is associated with UKPRN '10017819' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017819 | 117819 | 10017819 Co Ltd | 0              | Active | Yes           | AA017819      | ?             | 

    # Change the date 
    And   the override date is '04/03/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017819 | 10017819 Co Ltd      | ESFA-819             | NCS-819        | 1                     | 01/04/2017        | 31/03/2018      | 142270.00     | Gyrwe                          | Contract for Services | 1718   | New          | ORG0017819 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription   | CRMIntent    |
    | 10017819 | NCS-819        | NCSC-819      | NCS-C             | NCS-C1718               | FY                      | 01/04/2017          | 31/03/2018        | 142270.00       | Central Eastern         | 0000000006 | Central Eastern         | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | DeliverableDescription                                      | CRMIntent    |
    | 10017819 | NCS-819        | NCSC-819      | 1               | 0                     | 142270.00 | 7775.00  | 13120.00 | 12961.00 | 12941.00 | 13522.00 | 13139.00 | 17026.00 | 7877.00  | 16408.00 | 8887.00  | 10076.00 | 8538.00  | Total In The Community Funding                              | New          |
    | 10017819 | NCS-819        | NCSC-819      | 2               | 1                     | 53348.00  | 4910.00  | 5325.00  | 5916.00  | 2209.00  | 3207.00  | 5548.00  | 5600.00  | 3400.00  | 5400.00  | 3777.00  | 2995.00  | 5061.00  | Customer Satisfaction                                       | New          |
    | 10017819 | NCS-819        | NCSC-819      | 3               | 1                     | 88922.00  | 2865.00  | 7795.00  | 7045.00  | 10732.00 | 10315.00 | 7591.00  | 11426.00 | 4477.00  | 11008.00 | 5110.00  | 7081.00  | 3477.00  | Career Management and Jobs and Learning                     | New          |
    | 10017819 | NCS-819        | NCSC-819      | 4               | 3                     | 46397.00  | 1655.00  | 2420.00  | 3233.00  | 5451.00  | 5305.00  | 2798.00  | 5821.00  | 3416.00  | 5918.00  | 3124.00  | 4852.00  | 2404.00  | Career Management                                           | New          |
    | 10017819 | NCS-819        | NCSC-819      | 5               | 3                     | 42525.00  | 1210.00  | 5375.00  | 3812.00  | 5281.00  | 5010.00  | 4793.00  | 5605.00  | 1061.00  | 5090.00  | 1986.00  | 2229.00  | 1073.00  | Jobs and Learning                                           | New          |
    | 10017819 | NCS-819        | NCSC-819      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                 | New          |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | Total     | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | 10017819 | NCS-819        | NCSC-819      | 6               | 2075      | 193      | 147      | 158      | 279      | 140      | 85       | 244      | 116      | 139      | 220      | 72       | 282      |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 
 
    # Check the deliverable counts in CRM 
   #And   there are 'nn' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
   #And   there are 'nn' deliverable periods in CRM linked to the latest version of contract 'NCS-819' and allocation 'xxxx-819' 
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'NCS-819' 

    # Change the date 
    And   the override date is '07/03/2017' 
 
    # Publish the contract 
    And   the latest version of contract 'NCS-819' is in a state of 'Published to Provider' 
 
    # Change the date 
    And   the override date is '09/03/2017' 
 
    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-819' and actual ContractNumber 'NCS-819' 
 
    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017819 | NCS-819            | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/04/2017        | 31/03/2018      | ?             |
    | 10017819 | ESFA-819           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/04/2017        | 31/03/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017819 | NCS-819            | 1                     | NCSC-819      | 01/04/2017          | 31/03/2018        |

    # Change the date
    And   the override date is '10/04/2018'

    # Consume DCFS Summarised Actuals
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | NCS            | N12                  | ORG0017819     | CM             | 201704 | NCS-C1718               | NCSC-819                 | 0000000006 | 2               | 0            | 400.78      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201704 | NCS-C1718               | NCSC-819                 | 0000000006 | 4               | 0            | 314.45      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201704 | NCS-C1718               | NCSC-819                 | 0000000006 | 5               | 0            | 157.88      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201705 | NCS-C1718               | NCSC-819                 | 0000000006 | 2               | 0            | 462.13      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201705 | NCS-C1718               | NCSC-819                 | 0000000006 | 4               | 0            | 188.22      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201705 | NCS-C1718               | NCSC-819                 | 0000000006 | 5               | 0            | 752.30      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201706 | NCS-C1718               | NCSC-819                 | 0000000006 | 2               | 0            | 432.41      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201706 | NCS-C1718               | NCSC-819                 | 0000000006 | 4               | 0            | 218.22      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201706 | NCS-C1718               | NCSC-819                 | 0000000006 | 5               | 0            | 373.06      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201707 | NCS-C1718               | NCSC-819                 | 0000000006 | 2               | 0            | 428.35      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201707 | NCS-C1718               | NCSC-819                 | 0000000006 | 4               | 0            | 584.24      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201707 | NCS-C1718               | NCSC-819                 | 0000000006 | 5               | 0            | 123.03      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201708 | NCS-C1718               | NCSC-819                 | 0000000006 | 2               | 0            | 746.32      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201708 | NCS-C1718               | NCSC-819                 | 0000000006 | 4               | 0            | 118.21      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201708 | NCS-C1718               | NCSC-819                 | 0000000006 | 5               | 0            | 275.06      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201709 | NCS-C1718               | NCSC-819                 | 0000000006 | 2               | 0            | 346.34      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201709 | NCS-C1718               | NCSC-819                 | 0000000006 | 4               | 0            | 418.27      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201709 | NCS-C1718               | NCSC-819                 | 0000000006 | 5               | 0            | 175.08      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201710 | NCS-C1718               | NCSC-819                 | 0000000006 | 2               | 0            | 246.31      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201710 | NCS-C1718               | NCSC-819                 | 0000000006 | 4               | 0            | 318.24      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201710 | NCS-C1718               | NCSC-819                 | 0000000006 | 5               | 0            | 745.02      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201711 | NCS-C1718               | NCSC-819                 | 0000000006 | 2               | 0            | 196.35      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201711 | NCS-C1718               | NCSC-819                 | 0000000006 | 4               | 0            | 288.22      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201711 | NCS-C1718               | NCSC-819                 | 0000000006 | 5               | 0            | 375.00      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201712 | NCS-C1718               | NCSC-819                 | 0000000006 | 2               | 0            | 466.34      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201712 | NCS-C1718               | NCSC-819                 | 0000000006 | 4               | 0            | 258.22      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201712 | NCS-C1718               | NCSC-819                 | 0000000006 | 5               | 0            | 345.00      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201801 | NCS-C1718               | NCSC-819                 | 0000000006 | 2               | 0            | 436.42      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201801 | NCS-C1718               | NCSC-819                 | 0000000006 | 4               | 0            | 428.29      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201801 | NCS-C1718               | NCSC-819                 | 0000000006 | 5               | 0            | 215.01      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201802 | NCS-C1718               | NCSC-819                 | 0000000006 | 2               | 0            | 346.45      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201802 | NCS-C1718               | NCSC-819                 | 0000000006 | 4               | 0            | 186.24      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201802 | NCS-C1718               | NCSC-819                 | 0000000006 | 5               | 0            | 455.05      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201803 | NCS-C1718               | NCSC-819                 | 0000000006 | 2               | 0            | 564.46      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201803 | NCS-C1718               | NCSC-819                 | 0000000006 | 4               | 0            | 383.27      | 
    | NCS            | N12                  | ORG0017819     | CM             | 201803 | NCS-C1718               | NCSC-819                 | 0000000006 | 5               | 0            | 252.80      | 
 
    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUALS in CRM
    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-819        | NCSC-819        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-819        | NCSC-819        | 2               | 5072.66  | 400.78   | 462.13   | 432.41   | 428.35   | 746.32   | 346.34   | 246.31   | 196.35   | 466.34   | 436.42   | 346.45   | 564.46   | 
    | NCS-819        | NCSC-819        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-819        | NCSC-819        | 4               | 3704.09  | 314.45   | 188.22   | 218.22   | 584.24   | 118.21   | 418.27   | 318.24   | 288.22   | 258.22   | 428.29   | 186.24   | 383.27   | 
    | NCS-819        | NCSC-819        | 5               | 4244.29  | 157.88   | 752.30   | 373.06   | 123.03   | 275.06   | 175.08   | 745.02   | 375.00   | 345.00   | 215.01   | 455.05   | 252.80   | 
    | NCS-819        | NCSC-819        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-819        | NCSC-819        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-819        | NCSC-819        | 2               | 5072.66  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5072.66  | 
    | NCS-819        | NCSC-819        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-819        | NCSC-819        | 4               | 3704.09  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3704.09  | 
    | NCS-819        | NCSC-819        | 5               | 4244.29  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4244.29  | 
    | NCS-819        | NCSC-819        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017819 | ORG0017819 | NCSC-819          | 2305310         | NCS-C1718                  | 201704               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017819 | ORG0017819 | NCSC-819          | 2305310         | NCS-C1718                  | 201705               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017819 | ORG0017819 | NCSC-819          | 2305310         | NCS-C1718                  | 201706               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017819 | ORG0017819 | NCSC-819          | 2305310         | NCS-C1718                  | 201707               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017819 | ORG0017819 | NCSC-819          | 2305310         | NCS-C1718                  | 201708               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017819 | ORG0017819 | NCSC-819          | 2305310         | NCS-C1718                  | 201709               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017819 | ORG0017819 | NCSC-819          | 2305310         | NCS-C1718                  | 201710               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017819 | ORG0017819 | NCSC-819          | 2305310         | NCS-C1718                  | 201711               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017819 | ORG0017819 | NCSC-819          | 2305310         | NCS-C1718                  | 201712               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017819 | ORG0017819 | NCSC-819          | 2305310         | NCS-C1718                  | 201801               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017819 | ORG0017819 | NCSC-819          | 2305310         | NCS-C1718                  | 201802               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017819 | ORG0017819 | NCSC-819          | 2305310         | NCS-C1718                  | 201803               | RECONCILIATION  | CM             | False       | 13021.04        |

    # Change the date 
    And   the override date is '12/04/2018' 

    # Request closure of the contract. This should fail because a non-zero reconciliation payment is outstanding
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'NCS-819' for provider '10017819'

    # Check that the CONTRACT version, status and dates in CRM have not changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017819 | NCS-819            | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/04/2017        | 31/03/2018      | ?             |
    | 10017819 | ESFA-819           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/04/2017        | 31/03/2018      | ?             |

    # Check that the ALLOCATION dates in CRM have not changed
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017819 | NCS-819            | 1                     | NCSC-819      | 01/04/2017          | 31/03/2018        |

	# Check that a NOTIFICATION has been created and sent to the Advisor explaining why the closure failed
	And   there is '1' notification of type 'Contract Closure Initiation Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                              | NotificationText                                                                                          |
    | New    | Contract Closure Initiation Failed - NCS-819  | Contract NCS-819 v1 for provider 10017819 (10017819 Co Ltd) cannot be closed - outstanding payments exist |

 	# Check that the workflow history includes two new entries
	And   the workflow history on contract 'NCS-819' version '1' includes the following
	| Action                        | CompletedBy      | Comment                        | 
	| Closure Initiation Failed     | CRM Integration  | ?                              | 
	| Initiate Contract Closure     | FCS2 Test        | ?                              | 

    # Tidy up
    And   the override date is reset
  
   