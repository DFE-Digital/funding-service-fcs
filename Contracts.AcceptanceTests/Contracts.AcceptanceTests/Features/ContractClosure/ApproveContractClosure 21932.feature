Feature: ApproveContractClosure 21932

@AcceptanceTest @Withdrawn20201209
@ContractClosure
Scenario: A846 Create and approve a 1-allocation 1718 EFA(1619F) contract. Request then approve contract closure. Check CRM, Tasks and Workflow History
    Given there is no Contract, Task or Workflow data for UKPRN '10017846'
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    And   there is no data in the PerformanceManagement.ContractAllocation or ContractAllocationDeliverable tables for the following providers 
    | UKPRN    | 
    | 10017846 | 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16LR-846      |
    | NMF-846       |
    | SSF-846       |

   # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017846'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017846 Co Ltd' with UKPRN '10017846' and OrgId 'ORG0017846' and has 'FCS1 Test' as a manager
    And   UPIN '117846' is associated with UKPRN '10017846' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017846 | 117846 | 10017846 Co Ltd | 0              | Active |

    # Change the date
    And   the override date is '10/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017846 | 10017846 Co Ltd      | ESFA-846             | 1619F-846      | 1                     | 01/08/2017        | 31/07/2018      | 89098.00      |                                | Contract for Services | 1718   | New          | ORG0017846 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017846 | 1619F-846      | SSF-846       | SSF               | SSF1718                 | AY                      | 01/08/2017          | 31/07/2018        | 89098.00        |                         |            | LESLIE FRANCES (HAIR FASHIONS) LIMITED (107027)             | New          | 11784601    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                  | CRMIntent    | DeliveryOrg |
    | 10017846 | 1619F-846      | SSF-846       | 2               | 0                     | 25834.00  | 693.35   | 4918.23  | 1876.96  | 3063.16  | -570.17  | 4216.53  | 3808.76  | -262.35  | 3946.73  | 1194.72  | -1162.38 | 4110.78  | SSF Total Programme funding                             | New          | 11784601    |
    | 10017846 | 1619F-846      | SSF-846       | 13              | 0                     | 16098.00  | 998.20   | 4877.73  | -2573.77 | 4781.98  | 3823.43  | -564.39  | -1198.06 | 656.76   | 2543.37  | -607.08  | 4728.60  | -1368.95 | SSF Bursary Funds                                       | New          | 11784601    |
    | 10017846 | 1619F-846      | SSF-846       | 14              | 0                     | 6762.00   | 2307.73  | -2411.93 | 4028.45  | -2374.39 | 991.79   | 882.72   | -1945.99 | -2029.66 | 43.28    | -2378.85 | 4709.98  | 4938.73  | SSF Formula Protection Funding                          | New          | 11784601    |
    | 10017846 | 1619F-846      | SSF-846       | 15              | 0                     | 12747.00  | 1679.30  | -2760.39 | 2025.04  | 3032.16  | 233.12   | 1625.76  | -1526.21 | 2414.36  | -1148.88 | 1827.95  | 3848.62  | 1495.71  | SSF High Needs Element 2                                | New          | 11784601    |
    | 10017846 | 1619F-846      | SSF-846       | 17              | 0                     | 22799.00  | 4739.65  | 114.68   | 2081.52  | -1732.35 | 2961.85  | 2783.96  | 4016.05  | 3587.06  | 2384.63  | -677.40  | 729.14   | 1810.62  | Maintained Special SSF Element 2                        | New          | 11784601    |
    | 10017846 | 1619F-846      | SSF-846       | 18              | 0                     | 4858.00   | -2224.56 | -1884.27 | 4603.03  | -820.83  | 4049.23  | 1706.06  | -1252.96 | 3952.14  | -1134.76 | -396.72  | -2430.41 | 691.85   | Maintained Special SSF Student Support                  | New          | 11784601    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    And   the override date is '12/07/2017'

    # Publish the contract
    And   the latest version of contract '1619F-846' is in a state of 'Published to Provider'

    # Change the date
    And   the override date is '14/07/2017'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-846' and actual ContractNumber '1619F-846'

    # Check that the contract is now approved
    Then  the status and sub-status of the latest version of contract '1619F-846' are changed to 'Approved'
    And   the latest version of contract '1619F-846' is marked as the last approved version

    # Check the deliverable count in CRM  
    And   there are '72' deliverable periods in CRM linked to the latest version of contract '1619F-846' and allocation 'SSF-846' 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017846 | 1619F-846          | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017846 | ESFA-846           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017846 | 1619F-846          | 1                     | SSF-846       | 01/08/2017          | 31/07/2018        |




    # Request contract closure
	
	# Change the date 
    Given the override date is '03/08/2018' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '1619F-846' for provider '10017846'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017846 | 1619F-846          | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017846 | ESFA-846           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017846 | 1619F-846          | 1                     | SSF-846       | 01/08/2017          | 31/07/2018        |
 
    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '1619F-846' for provider '10017846'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017846 - 10017846 Co Ltd | 1619F-846 | FCS1 Test | Contract Managers Team | Open  | Not Started |
    
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract '1619F-846' version '1' includes the following
    | Action                        | CompletedBy     | Comment                           |
    | Closure Initiation Successful | CRM Integration | ?                                 |
    | Initiate Contract Closure     | FCS2 Test       | ?                                 |
	  
	# Check the CM feed for the absence of an ItemType 3 (Closure) row
    And   the ContractManagement.AtomFeedItem table does not contain an ItemType '3' event for version '1' of actual contract number '1619F-846'




	# Approve contract closure

    # Change the date 
    Given the override date is '04/08/2018' 

    # Approve closure of the contract. This should succeed
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract '1619F-846' for provider '10017846'
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract '1619F-846' for provider '10017846'
 
    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017846 | 1619F-846          | 1                     | 0                        | Closed         | Closed            | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017846 | ESFA-846           | 1                     | 0                        | Draft          | ?                 | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017846 | 1619F-846          | 1                     | SSF-846       | 01/08/2017          | 31/07/2018        |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '1619F-846' for provider '10017846'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State     | Status    |
    | Confirm Closure Approval | 10017846 - 10017846 Co Ltd | 1619F-846 | FCS1 Test  | Contract Managers Team | Completed | Completed |

    # Check the WORKFLOW HISTORY
    And   the workflow history on contract '1619F-846' version '1' includes the following
    | Action                        | CompletedBy     | Comment                           |
    | Contract Closure Successful   | CRM Integration | ?                                 |
    | Approve Closure               | FCS1 Test       | ?                                 |
    | Closure Initiation Successful | CRM Integration | ?                                 |
    | Initiate Contract Closure     | FCS2 Test       | ?                                 |

    # Check the CM feed for the presence of an ItemType 3 (Closure) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '3' event for version '1' of actual contract number '1619F-846'
    And   the ItemType '3' event for version '1' of actual contract number '1619F-846' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema


    # Tidy up
    And   the override date is reset 
    
@AcceptanceTest @Complete 
@PublishNewLevyContract @ContractClosure
Scenario: A847 Create and approve a Levy contract. Request then approve contract closure. Check CRM, Tasks and Workflow History
    Given there is no Contract, Task or Workflow data for UKPRN '10017847'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017847 Co Ltd' with UKPRN '10017847' and OrgId 'ORG0017847' and has 'FCS1 Test' as a manager
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017847'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017847'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS

   # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017847'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017847 Co Ltd' with UKPRN '10017847' and OrgId 'ORG0017847' and has 'FCS1 Test' as a manager
    And   UPIN '117847' is associated with UKPRN '10017847' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017847 | 117847 | 10017847 Co Ltd | 0              | Active |




    # Change the date 
    Given the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id     | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42864  | INITIATED | 2017-09-15T18:03:12.2539 | 10017847   | 28913             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017847'
    And   there is only one Levy contract in CRM for UKPRN '10017847' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017847 | 10017847 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017847 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017847 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
	| 10017847 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription              | 
    | 10017847 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships    | 
    | 10017847 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships    | 
	| 10017847 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017847 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017847' for FundingType 'LEVY' and period '1799'

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
    | 10017847 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017847 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017847 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017847 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017847 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017847 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017847 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017847 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017847 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017847 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017847 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017847 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017847 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017847 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017847 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017847 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017847 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017847 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017847 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017847 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017847 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017847 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017847 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017847 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017847 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017847 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017847 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017847 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017847 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 12/04/2020        | ?               | ?             |
    | 10017847 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017847 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 12/04/2020          | ?                 |
    | 10017847 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 12/04/2020          | ?                 |




    # Change the date 
    Given the override date is '16/09/2020' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '[ContractNo]' for provider '10017847'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017847 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 12/04/2020        | ?               | ?             |
    | 10017847 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017847 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 12/04/2020          | ?                 |
    | 10017847 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 12/04/2020          | ?                 |
 
    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017847'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017847 - 10017847 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Open  | Not Started |

    # Check the WORKFLOW HISTORY
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy     | Comment                            |
    | Closure Initiation Successful | CRM Integration | ?                                  |
    | Initiate Contract Closure     | FCS2 Test       | ?                                  |     
	
    # Check the CM feed for the absence of an ItemType 3 (Closure) row
    And   the ContractManagement.AtomFeedItem table does not contain an ItemType '3' event for version '1' of contract number '[ContractNo]'	
	              
				  


    # Change the date 
    Given the override date is '19/09/2020' 

    # Approve closure of the contract. This should succeed
	When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract '[ContractNo]' for provider '10017847'
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract '[ContractNo]' for provider '10017847'

    # Check CONTRACT version, status and dates in CRM. The contract end date should have been set
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017847 | [ContractNo]       | 1                     | 0                        | Closed         | Closed            | True          | True                | 12/04/2020        | 19/09/2020      | ?             |
    | 10017847 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                 | False         | False               | 01/05/2017        | ?               | ?             |

   # Check ALLOCATION dates in CRM. The allocation end date should have been set
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017847 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 12/04/2020          | 19/09/2020        |
    | 10017847 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 12/04/2020          | 19/09/2020        |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017847'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State     | Status      |
    | Confirm Closure Approval | 10017847 - 10017847 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Completed | Completed   |

    # Check the WORKFLOW HISTORY
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy      | Comment                           | 
    | Contract Closure Successful   | CRM Integration  | ?                                 |
    | Approve Closure               | FCS1 Test        | ?                                 | 
    | Closure Initiation Successful | CRM Integration  | ?                                 | 
    | Initiate Contract Closure     | FCS2 Test        | ?                                 | 

    # Check the CM feed for the presence of an ItemType 3 (Closure) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '3' event for version '1' of contract number '[ContractNo]'
    And   the ItemType '3' event for version '1' of contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002 
@ContractClosure
Scenario: A848 Create and approve a 1718 NCS contract. Check Notification. Successfully request contract closure. Consume actuals. Fail to approve contract closure: outstanding payment
    Given there is no Contract, Task or Workflow data for UKPRN '10017848'
   #And   there are no notifications of type 'Contract Closure Failed'
	And   there are no notifications in CRM of type 'Contract Closure Failed' for UKPRN '10017848'
	And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017848'
	And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Cleardown and reset PaymentGeneration.PaymentTimetable 
    # This is needed for CM.ApprovedContract and CM.ApprovedContractAllocation checks to work
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | NCS-C1718                  | 201803               |                      | A              | NotStarted |

	# Cleardown subnominal data from CRM and PaymentGeneration.SubnominalAggregation
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | NCSA-848      |
    | NCSC-848      |
    | NCSD-848      |
    | NCSE-848      |
    | NCSF-848      |
    | NCSI-848      |
    | NCSP-848      |
    | NCSS-848      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017848' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017848 Co Ltd' with UKPRN '10017848' and OrgId 'ORG0017848' and has 'FCS1 Test' as a manager 
    And   UPIN '117848' is associated with UKPRN '10017848' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017848 | 117848 | 10017848 Co Ltd | 0              | Active | Yes           | AA017848      | ?             | 

    # Change the date 
    And   the override date is '04/03/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017848 | 10017848 Co Ltd      | ESFA-848             | NCS-848        | 1                     | 01/04/2017        | 31/03/2018      | 349083.00     | Gyrwe                          | Contract for Services | 1718   | New          | ORG0017848 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription   | CRMIntent    |
    | 10017848 | NCS-848        | NCSA-848      | NCS-EA            | NCS-EA1718              | FY                      | 01/04/2017          | 31/03/2018        | 9586.00         | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017848 | NCS-848        | NCSC-848      | NCS-C             | NCS-C1718               | FY                      | 01/04/2017          | 31/03/2018        | 142270.00       | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017848 | NCS-848        | NCSD-848      | NCS-SEEDIC        | NCS-SEEDIC1718          | FY                      | 01/04/2017          | 31/03/2018        | 6515.00         | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017848 | NCS-848        | NCSE-848      | NCS-IC            | NCS-IC1718              | FY                      | 01/04/2017          | 31/03/2018        | 12251.00        | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017848 | NCS-848        | NCSF-848      | NCS-FWL           | NCS-FWL1718             | FY                      | 01/04/2017          | 31/03/2018        | 4157.00         | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017848 | NCS-848        | NCSI-848      | NCS-I             | NCS-I1718               | FY                      | 01/04/2017          | 31/03/2018        | 9759.00         | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017848 | NCS-848        | NCSP-848      | NCS-P             | NCS-P1718               | FY                      | 01/04/2017          | 31/03/2018        | 157038.00       | Central Eastern         | 0000000006 | Central Eastern         | New          |
    | 10017848 | NCS-848        | NCSS-848      | NCS-ASIST         | NCS-ASIST1718           | FY                      | 01/04/2017          | 31/03/2018        | 7507.00         | Central Eastern         | 0000000006 | Central Eastern         | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | DeliverableDescription                                      | CRMIntent    |
    | 10017848 | NCS-848        | NCSA-848      | 1               | 0                     | 9586.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3784.00  | 3114.00  | 0.00     | 0.00     | 2688.00  | Enabling Apprenticeships                                    | New          |
    | 10017848 | NCS-848        | NCSC-848      | 1               | 0                     | 142270.00 | 7775.00  | 13120.00 | 12961.00 | 12941.00 | 13522.00 | 13139.00 | 17026.00 | 7877.00  | 16408.00 | 8887.00  | 10076.00 | 8538.00  | Total In The Community Funding                              | New          |
    | 10017848 | NCS-848        | NCSC-848      | 2               | 1                     | 53348.00  | 4910.00  | 5325.00  | 5916.00  | 2209.00  | 3207.00  | 5548.00  | 5600.00  | 3400.00  | 5400.00  | 3777.00  | 2995.00  | 5061.00  | Customer Satisfaction                                       | New          |
    | 10017848 | NCS-848        | NCSC-848      | 3               | 1                     | 88922.00  | 2865.00  | 7795.00  | 7045.00  | 10732.00 | 10315.00 | 7591.00  | 11426.00 | 4477.00  | 11008.00 | 5110.00  | 7081.00  | 3477.00  | Career Management and Jobs and Learning                     | New          |
    | 10017848 | NCS-848        | NCSC-848      | 4               | 3                     | 46397.00  | 1655.00  | 2420.00  | 3233.00  | 5451.00  | 5305.00  | 2798.00  | 5821.00  | 3416.00  | 5918.00  | 3124.00  | 4852.00  | 2404.00  | Career Management                                           | New          |
    | 10017848 | NCS-848        | NCSC-848      | 5               | 3                     | 42525.00  | 1210.00  | 5375.00  | 3812.00  | 5281.00  | 5010.00  | 4793.00  | 5605.00  | 1061.00  | 5090.00  | 1986.00  | 2229.00  | 1073.00  | Jobs and Learning                                           | New          |
    | 10017848 | NCS-848        | NCSC-848      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                 | New          |
    | 10017848 | NCS-848        | NCSD-848      | 1               | 0                     | 6515.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5257.00  | 1258.00  | Support and Enhance Existing Delivery In-Community Funding  | New          |
    | 10017848 | NCS-848        | NCSE-848      | 1               | 0                     | 12251.00  | 0.00     | 0.00     | 0.00     | 2286.00  | 0.00     | 2396.00  | 0.00     | 0.00     | 4917.00  | 0.00     | 0.00     | 2652.00  | Inspiration and Employer Engagement in Custody Activity     | New          |
    | 10017848 | NCS-848        | NCSF-848      | 1               | 0                     | 4157.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3065.00  | 0.00     | 0.00     | 1092.00  | Fuller Working Lives 50+                                    | New          |
    | 10017848 | NCS-848        | NCSI-848      | 1               | 0                     | 9759.00   | 0.00     | 2047.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4280.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3432.00  | Inspiration Activity                                        | New          |
    | 10017848 | NCS-848        | NCSP-848      | 1               | 0                     | 157038.00 | 12955.00 | 9313.00  | 19224.00 | 17248.00 | 11421.00 | 10852.00 | 8192.00  | 12373.00 | 15117.00 | 16936.00 | 11235.00 | 12172.00 | Total In Custody Funding                                    | New          |
    | 10017848 | NCS-848        | NCSP-848      | 2               | 1                     | 34883.00  | 3681.00  | 1031.00  | 5034.00  | 3244.00  | 3637.00  | 2758.00  | 1564.00  | 4612.00  | 1945.00  | 1893.00  | 2480.00  | 3004.00  | Customer Satisfaction                                       | New          |
    | 10017848 | NCS-848        | NCSP-848      | 3               | 1                     | 122155.00 | 9274.00  | 8282.00  | 14190.00 | 14004.00 | 7784.00  | 8094.00  | 6628.00  | 7761.00  | 13172.00 | 15043.00 | 8755.00  | 9168.00  | Career Management and Jobs and Learning                     | New          |
    | 10017848 | NCS-848        | NCSP-848      | 4               | 3                     | 40208.00  | 4092.00  | 1635.00  | 5515.00  | 2722.00  | 5038.00  | 1653.00  | 3396.00  | 975.00   | 4688.00  | 5172.00  | 2332.00  | 2990.00  | Career Management                                           | New          |
    | 10017848 | NCS-848        | NCSP-848      | 5               | 3                     | 43920.00  | 3474.00  | 820.00   | 4261.00  | 5879.00  | 1285.00  | 4859.00  | 1029.00  | 5823.00  | 5999.00  | 4381.00  | 4377.00  | 1733.00  | Jobs and Learning                                           | New          |
    | 10017848 | NCS-848        | NCSP-848      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                 | New          |
    | 10017848 | NCS-848        | NCSP-848      | 7               | 3                     | 38027.00  | 1708.00  | 5827.00  | 4414.00  | 5403.00  | 1461.00  | 1582.00  | 2203.00  | 963.00   | 2485.00  | 5490.00  | 2046.00  | 4445.00  | Career Management 2                                         | New          |
    | 10017848 | NCS-848        | NCSS-848      | 1               | 0                     | 7507.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5704.00  | 1803.00  | Apprenticeship Specialist Intervention and Support Team     | New          |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | Total     | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | 10017848 | NCS-848        | NCSC-848      | 6               | 2075      | 193      | 147      | 158      | 279      | 140      | 85       | 244      | 116      | 139      | 220      | 72       | 282      |
    | 10017848 | NCS-848        | NCSP-848      | 6               | 1870      | 198      | 128      | 160      | 85       | 90       | 86       | 330      | 82       | 343      | 74       | 164      | 130      |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 
 
    # Check the deliverable counts in CRM 
   #And   there are 'nn' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
   #And   there are 'nn' deliverable periods in CRM linked to the latest version of contract 'NCS-848' and allocation 'xxxx-848' 
    And   there are '228' deliverable period rows in CRM linked to the latest version of contract 'NCS-848' 

    # Change the date 
    And   the override date is '07/03/2017' 
 
    # Publish the contract 
    And   the latest version of contract 'NCS-848' is in a state of 'Published to Provider' 
 
    # Change the date 
    And   the override date is '09/03/2017' 
 
    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-848' and actual ContractNumber 'NCS-848' 
 
    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017848 | NCS-848            | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/04/2017        | 31/03/2018      | ?             |
    | 10017848 | ESFA-848           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/04/2017        | 31/03/2018      | ?             |

    # Check that an Approval NOTIFICATION has been created and sent to the Document Management Team
    And   there is '1' notification of type 'Approval Received' owned by team 'Document Management Team' which matches the following
    | Status | NotificationName           | NotificationText                                                                                              |
    | New    | Approval Received-NCS-848  | The contract : NCS-848 - Version : 1 for UKPRN : 10017848 has been approved by the provider : 10017848 Co Ltd |


    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017848 | NCS-848            | 1                     | NCSA-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSC-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSD-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSE-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSF-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSI-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSP-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSS-848      | 01/04/2017          | 31/03/2018        |

    # Change the date
    And   the override date is '04/04/2018'

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'NCS-848' for provider '10017848'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus              | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017848 | NCS-848            | 1                     | 0                        | Approved         | Awaiting Closure Approval      | True          | True                | 01/04/2017        | 31/03/2018      | ?             |
    | 10017848 | ESFA-848           | 1                     | 0                        | Draft            | ?                              | False         | False               | 01/04/2017        | 31/03/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017848 | NCS-848            | 1                     | NCSA-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSC-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSD-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSE-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSF-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSI-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSP-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSS-848      | 01/04/2017          | 31/03/2018        |
 
    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'NCS-848' for provider '10017813'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017848 - 10017848 Co Ltd | NCS-848   | FCS1 Test | Contract Managers Team | Open  | Not Started |
    
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'NCS-848' version '1' includes the following
    | Action                        | CompletedBy      | Comment                      | 
    | Closure Initiation Successful | CRM Integration  | ?                            | 
    | Initiate Contract Closure     | FCS2 Test        | ?                            | 

    # Check the CM feed for the absence of an ItemType 3 (Closure) row
    And   the ContractManagement.AtomFeedItem table does not contain an ItemType '3' event for version '1' of actual contract number 'NCS-848'

    # Change the date
    And   the override date is '06/04/2018'

    # Consume DCFS Summarised Actuals
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | NCS            | N12                  | ORG0017848     | CM             | 201704 | NCS-C1718               | NCSC-848                 | 0000000006 | 2               | 0            | 400.78      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201704 | NCS-C1718               | NCSC-848                 | 0000000006 | 4               | 0            | 314.45      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201704 | NCS-C1718               | NCSC-848                 | 0000000006 | 5               | 0            | 157.88      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201705 | NCS-C1718               | NCSC-848                 | 0000000006 | 2               | 0            | 462.13      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201705 | NCS-C1718               | NCSC-848                 | 0000000006 | 4               | 0            | 188.22      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201705 | NCS-C1718               | NCSC-848                 | 0000000006 | 5               | 0            | 752.30      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201706 | NCS-C1718               | NCSC-848                 | 0000000006 | 2               | 0            | 432.41      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201706 | NCS-C1718               | NCSC-848                 | 0000000006 | 4               | 0            | 218.22      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201706 | NCS-C1718               | NCSC-848                 | 0000000006 | 5               | 0            | 373.06      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201707 | NCS-C1718               | NCSC-848                 | 0000000006 | 2               | 0            | 428.35      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201707 | NCS-C1718               | NCSC-848                 | 0000000006 | 4               | 0            | 584.24      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201707 | NCS-C1718               | NCSC-848                 | 0000000006 | 5               | 0            | 123.03      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201708 | NCS-C1718               | NCSC-848                 | 0000000006 | 2               | 0            | 746.32      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201708 | NCS-C1718               | NCSC-848                 | 0000000006 | 4               | 0            | 118.21      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201708 | NCS-C1718               | NCSC-848                 | 0000000006 | 5               | 0            | 275.06      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201709 | NCS-C1718               | NCSC-848                 | 0000000006 | 2               | 0            | 346.34      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201709 | NCS-C1718               | NCSC-848                 | 0000000006 | 4               | 0            | 418.27      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201709 | NCS-C1718               | NCSC-848                 | 0000000006 | 5               | 0            | 175.08      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201710 | NCS-C1718               | NCSC-848                 | 0000000006 | 2               | 0            | 246.31      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201710 | NCS-C1718               | NCSC-848                 | 0000000006 | 4               | 0            | 318.24      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201710 | NCS-C1718               | NCSC-848                 | 0000000006 | 5               | 0            | 745.02      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201711 | NCS-C1718               | NCSC-848                 | 0000000006 | 2               | 0            | 196.35      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201711 | NCS-C1718               | NCSC-848                 | 0000000006 | 4               | 0            | 288.22      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201711 | NCS-C1718               | NCSC-848                 | 0000000006 | 5               | 0            | 375.00      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201712 | NCS-C1718               | NCSC-848                 | 0000000006 | 2               | 0            | 466.34      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201712 | NCS-C1718               | NCSC-848                 | 0000000006 | 4               | 0            | 258.22      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201712 | NCS-C1718               | NCSC-848                 | 0000000006 | 5               | 0            | 345.00      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201801 | NCS-C1718               | NCSC-848                 | 0000000006 | 2               | 0            | 436.42      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201801 | NCS-C1718               | NCSC-848                 | 0000000006 | 4               | 0            | 428.29      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201801 | NCS-C1718               | NCSC-848                 | 0000000006 | 5               | 0            | 215.01      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201802 | NCS-C1718               | NCSC-848                 | 0000000006 | 2               | 0            | 346.45      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201802 | NCS-C1718               | NCSC-848                 | 0000000006 | 4               | 0            | 186.24      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201802 | NCS-C1718               | NCSC-848                 | 0000000006 | 5               | 0            | 455.05      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201803 | NCS-C1718               | NCSC-848                 | 0000000006 | 2               | 0            | 564.46      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201803 | NCS-C1718               | NCSC-848                 | 0000000006 | 4               | 0            | 383.27      | 
    | NCS            | N12                  | ORG0017848     | CM             | 201803 | NCS-C1718               | NCSC-848                 | 0000000006 | 5               | 0            | 252.80      | 
 
    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUALS in CRM
    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-848        | NCSC-848        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-848        | NCSC-848        | 2               | 5072.66  | 400.78   | 462.13   | 432.41   | 428.35   | 746.32   | 346.34   | 246.31   | 196.35   | 466.34   | 436.42   | 346.45   | 564.46   | 
    | NCS-848        | NCSC-848        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-848        | NCSC-848        | 4               | 3704.09  | 314.45   | 188.22   | 218.22   | 584.24   | 118.21   | 418.27   | 318.24   | 288.22   | 258.22   | 428.29   | 186.24   | 383.27   | 
    | NCS-848        | NCSC-848        | 5               | 4244.29  | 157.88   | 752.30   | 373.06   | 123.03   | 275.06   | 175.08   | 745.02   | 375.00   | 345.00   | 215.01   | 455.05   | 252.80   | 
    | NCS-848        | NCSC-848        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | NCS-848        | NCSC-848        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-848        | NCSC-848        | 2               | 5072.66  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5072.66  | 
    | NCS-848        | NCSC-848        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-848        | NCSC-848        | 4               | 3704.09  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3704.09  | 
    | NCS-848        | NCSC-848        | 5               | 4244.29  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4244.29  | 
    | NCS-848        | NCSC-848        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017848 | ORG0017848 | NCSC-848          | 2305310         | NCS-C1718                  | 201704               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017848 | ORG0017848 | NCSC-848          | 2305310         | NCS-C1718                  | 201705               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017848 | ORG0017848 | NCSC-848          | 2305310         | NCS-C1718                  | 201706               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017848 | ORG0017848 | NCSC-848          | 2305310         | NCS-C1718                  | 201707               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017848 | ORG0017848 | NCSC-848          | 2305310         | NCS-C1718                  | 201708               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017848 | ORG0017848 | NCSC-848          | 2305310         | NCS-C1718                  | 201709               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017848 | ORG0017848 | NCSC-848          | 2305310         | NCS-C1718                  | 201710               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017848 | ORG0017848 | NCSC-848          | 2305310         | NCS-C1718                  | 201711               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017848 | ORG0017848 | NCSC-848          | 2305310         | NCS-C1718                  | 201712               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017848 | ORG0017848 | NCSC-848          | 2305310         | NCS-C1718                  | 201801               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017848 | ORG0017848 | NCSC-848          | 2305310         | NCS-C1718                  | 201802               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017848 | ORG0017848 | NCSC-848          | 2305310         | NCS-C1718                  | 201803               | RECONCILIATION  | CM             | False       | 13021.04        |

    # Change the date 
    And   the override date is '12/04/2018' 

    # Approve closure of the contract. This should fail because a non-zero reconciliation payment is outstanding
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract 'NCS-848' for provider '10017848'
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract 'NCS-848' for provider '10017848'

    # Check the current state of the TASKS for this contract. Approval will complete the task even though the approval fails validation. 22188 creates a new task
    Then  the following Tasks are present against version '1' of contract 'NCS-848' for provider '10017848'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State      | Status      |
    | Approve Failed Closure   | 10017848 - 10017848 Co Ltd | NCS-848   | FCS1 Test | Contract Managers Team | Open       | Not Started |
    | Confirm Closure Approval | 10017848 - 10017848 Co Ltd | NCS-848   | FCS1 Test | Contract Managers Team | Completed  | Completed   |

    # Check that the CONTRACT version, status and dates in CRM have not changed
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017848 | NCS-848            | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 01/04/2017        | 31/03/2018      | ?             |
    | 10017848 | ESFA-848           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2017        | 31/03/2018      | ?             |

    # Check that the ALLOCATION dates in CRM have not changed
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017848 | NCS-848            | 1                     | NCSA-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSC-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSD-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSE-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSF-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSI-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSP-848      | 01/04/2017          | 31/03/2018        |
    | 10017848 | NCS-848            | 1                     | NCSS-848      | 01/04/2017          | 31/03/2018        |

    # Check that a NOTIFICATION has been created and sent to the Advisor explaining why the closure approval failed
   #And   there are notifications of type 'Contract Closure Failed' owned by the 'Lead Manager Team' as follows
   # And   there are notifications of type 'Contract Closure Failed' owned by the user 'FCS1 Test' as follows
    And   there is '1' notification of type 'Contract Closure Failed' owned by user 'FCS1 Test' which matches the following
    | Status | NotificationName                   | NotificationText                                                                                          |
    | New    | Contract Closure Failed - NCS-848  | Contract NCS-848 v1 for provider 10017848 (10017848 Co Ltd) cannot be closed - outstanding payments exist |

    # Check contents of the WORKFLOW HISTORY
    And   the workflow history on contract 'NCS-848' version '1' includes the following
    | Action                         | CompletedBy      | Comment                     |
    | Contract Closure Failed        | CRM Integration  | ?                           | 
    | Approve Closure                | FCS1 Test        | ?                           | 
    | Closure Initiation Successful  | CRM Integration  | ?                           | 
    | Initiate Contract Closure      | FCS2 Test        | ?                           | 

    # Check the CM feed for the absence of an ItemType 3 (Closure) row
    And   the ContractManagement.AtomFeedItem table does not contain an ItemType '3' event for version '1' of actual contract number 'NCS-848'

    # Tidy up
    And   the override date is reset
  
@AcceptanceTest @Complete 
@PublishNewLevyContract @ContractClosure
Scenario: A849 Create and approve a Levy contract. Successfully request contract closure. Fail to approve contract closure: month end is running. Check CM Feed
    Given there is no Contract, Task or Workflow data for UKPRN '10017849'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017849 Co Ltd' with UKPRN '10017849' and OrgId 'ORG0017849' and has 'FCS1 Test' as a manager
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017849'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017849'
   #And   there are no notifications of type 'Contract Closure Failed'
	And   there are no notifications in CRM of type 'Contract Closure Failed' for UKPRN '10017849'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
   
   # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017849'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017849 Co Ltd' with UKPRN '10017849' and OrgId 'ORG0017849' and has 'FCS1 Test' as a manager
    And   UPIN '117849' is associated with UKPRN '10017849' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017849 | 117849 | 10017849 Co Ltd | 0              | Active |




    # Change the date 
    Given the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id     | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42864  | INITIATED | 2017-09-15T18:03:12.2539 | 10017849   | 28913             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017849'
    And   there is only one Levy contract in CRM for UKPRN '10017849' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017849 | 10017849 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017849 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017849 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
    | 10017849 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription              | 
    | 10017849 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships    | 
    | 10017849 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships    | 
    | 10017949 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017849 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve parameters from CRM  
   #When  I retrieve the latest EFA contract details from CRM for provider '1001849' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017849' 
    And   I retrieve the latest contract details from CRM for provider '10017849' for FundingType 'LEVY' and period '1799' 

    ## Check deliverable period count prior to approval
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Change the date 
    Given the override date is '02/01/2021'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    ## Check deliverable period count after approval
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # After approval there should be a Jan-21 deliverable period for each of deliverables 1 through 14 for each allocation 
    Then   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Jan-21   | DeliverableDescription                               | 
    | 10017849 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017849 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017849 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017849 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017849 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017849 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017849 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017849 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017849 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017849 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017849 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017849 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017849 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017849 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017849 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017849 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017849 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017849 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017849 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017849 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017849 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017849 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017849 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017849 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017849 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017849 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017849 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017849 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017849 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 02/01/2021        | ?               | ?             |
    | 10017849 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017849 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 02/01/2021          | ?                 |
    | 10017849 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 02/01/2021          | ?                 |




    # Change the date 
    Given the override date is '11/07/2021' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '[ContractNo]' for provider '10017849'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017849 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 02/01/2021        | ?               | ?             |
    | 10017849 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017849 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 02/01/2021          | ?                 |
    | 10017849 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 02/01/2021          | ?                 |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017849'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017849 - 10017849 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Open  | Not Started |
  
    # Check that the workflow history includes two new entries
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy      | Comment                           | 
    | Closure Initiation Successful | CRM Integration  | ?                                 | 
    | Initiate Contract Closure     | FCS2 Test        | ?                                 | 

    # Check the CM feed for the absence of an ItemType 3 (Closure) row
    And   the ContractManagement.AtomFeedItem table does not contain an ItemType '3' event for version '1' of contract number '[ContractNo]'	




    # Change the date 
    Given the override date is '12/07/2021' 

    # Month end is running
    And   the PaaS MonthEndIsRunning indicator is set to 'True'

    # Approve closure of the contract. This should fail because month end processing is running 
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract '[ContractNo]' for provider '10017849'
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract '[ContractNo]' for provider '10017849'

    # Check the current state of the TASKS for this contract. Approval will complete the task even though the approval fails validation. 22188 creates a new task
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017848'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State      | Status      |
    | Approve Failed Closure   | 10017849 - 10017849 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Open       | Not Started |
    | Confirm Closure Approval | 10017849 - 10017849 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Completed  | Completed   |

    # Check that the CONTRACT version, status and dates in CRM have not changed
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017849 | [ContractNo]       | 1                     | 0                        | Approved       | Awaiting Closure Approval | True          | True                | 02/01/2021        | ?               | ?             |
    | 10017849 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

   # Check that the ALLOCATION dates in CRM have not changed
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017849 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 02/01/2021          | ?                 |
    | 10017849 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 02/01/2021          | ?                 |

    # Check that a NOTIFICATION has been created and sent to the Advisor explaining why the closure approval failed
	And   there is '1' notification of type 'Contract Closure Failed' owned by user 'FCS1 Test' which matches the following
    | Status | NotificationName                        | NotificationText                                                                                                                                 |
    | New    | Contract Closure Failed - [ContractNo]  | Contract [ContractNo] v1 for provider 10017849 (10017849 Co Ltd) cannot be closed - month-end processing is in progress - please try again later |

    # Check WORKFLOW HISTORY
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy      | Comment                           | 
    | Contract Closure Failed       | CRM Integration  | ?                                 | 
    | Approve Closure               | FCS1 Test        | ?                                 | 
    | Closure Initiation Successful | CRM Integration  | ?                                 |
    | Initiate Contract Closure     | FCS2 Test        | ?                                 | 

    # Check the CM feed for the absence of an ItemType 3 (Closure) row
    And   the ContractManagement.AtomFeedItem table does not contain an ItemType '3' event for version '1' of contract number '[ContractNo]'	


    # Tidy up
    And   the override date is reset
  
@AcceptanceTest @Complete 
@ContractClosure
Scenario: A837 Create and approve a 2-allocation NLAP2018 contract. Request and approve contract closure. Check CRM, Tasks and Workflow History. Attempt to amend after closure. Fail UDC020
    Given there is no Contract, Task or Workflow data for UKPRN '10017837'
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ANLP-837      |
    | YNLP-837      |

   # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017837'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017837 Co Ltd' with UKPRN '10017837' and OrgId 'ORG0017837' and has 'FCS1 Test' as a manager
    And   UPIN '117837' is associated with UKPRN '10017837' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017837 | 117837 | 10017837 Co Ltd | 0              | Active |

    # Change the date
    And   the override date is '10/12/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017837 | 10017837 Co Ltd      | ESFA-837             | NLAP-837       | 1                     | 01/01/2018        | 31/03/2019      | 33320.00      | Contract for Services | 2018   | New          | ORG0017837 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent    |
    | 10017837 | NLAP-837       | ANLP-837      | ANLAP             | NONLEVY                 | 01/01/2018          | 31/03/2019        | 18210.00        |         |         |                       | New          |
    | 10017837 | NLAP-837       | YNLP-837      | 16-18NLAP         | NONLEVY                 | 01/01/2018          | 31/03/2019        | 15110.00        |         |         |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                        | CRMIntent    |
    | 10017837 | NLAP-837       | ANLP-837      | 1               | 0                     | 18210.00 | 851.00   | 112.00   | 1206.00  | 515.00   | 2162.00  | 1472.00  | 1888.00  | 2320.00  | 827.00   | 1357.00  | 201.00   | 1586.00  | 1025.00  | 2402.00  | 286.00   | Total 16-18 Non-Levy Apprenticeships Funding  | New          |
    | 10017837 | NLAP-837       | YNLP-837      | 1               | 0                     | 15110.00 | 1110.00  | 682.00   | 2182.00  | 1877.00  | 682.00   | 1684.00  | 641.00   | 224.00   | 77.00    | 807.00   | 1976.00  | 743.00   | 588.00   | 1201.00  | 636.00   | Total Adult Non-Levy Apprenticeships Funding  | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    And   the override date is '12/12/2017'

    # Publish the contract
    And   the latest version of contract 'NLAP-837' is in a state of 'Published to Provider'

    # Change the date
    And   the override date is '14/12/2017'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-837' and actual ContractNumber 'NLAP-837'

    # Check the deliverable count in CRM  
    Then  there are '150' deliverable period rows in CRM linked to the latest version of contract 'NLAP-837'
    And   there are '75' deliverable periods in CRM linked to the latest version of contract 'NLAP-837' and allocation 'ANLP-837' 
    And   there are '75' deliverable periods in CRM linked to the latest version of contract 'NLAP-837' and allocation 'YNLP-837' 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017837 | NLAP-837           | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017837 | ESFA-837           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017837 | NLAP-837           | 1                     | ANLP-837      | 01/01/2018          | 31/03/2019        |
    | 10017837 | NLAP-837           | 1                     | YNLP-837      | 01/01/2018          | 31/03/2019        |

    # Change the date 
    And   the override date is '01/04/2019' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'NLAP-837' for provider '10017837'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017837 | NLAP-837           | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017837 | ESFA-837           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017837 | NLAP-837           | 1                     | ANLP-837      | 01/01/2018          | 31/03/2019        |
    | 10017837 | NLAP-837           | 1                     | YNLP-837      | 01/01/2018          | 31/03/2019        |
 
    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'NLAP-837' for provider '10017837'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017837 - 10017837 Co Ltd | NLAP-837  | FCS1 Test | Contract Managers Team | Open  | Not Started |
    
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'NLAP-837' version '1' includes the following
    | Action                        | CompletedBy      | Comment                       | 
    | Closure Initiation Successful | CRM Integration  | ?                             | 
    | Initiate Contract Closure     | FCS2 Test       | ?                             | 

    # Change the date 
    And   the override date is '04/04/2019' 

    # Approve closure of the contract. This should succeed
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract 'NLAP-837' for provider '10017837'
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract 'NLAP-837' for provider '10017837'
 
    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017837 | NLAP-837           | 1                     | 0                        | Closed         | Closed            | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017837 | ESFA-837           | 1                     | 0                        | Draft          | ?                 | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017837 | NLAP-837           | 1                     | ANLP-837      | 01/01/2018          | 31/03/2019        |
    | 10017837 | NLAP-837           | 1                     | YNLP-837      | 01/01/2018          | 31/03/2019        |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'NLAP-837' for provider '10017837'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State     | Status    |
    | Confirm Closure Approval | 10017837 - 10017837 Co Ltd | NLAP-837  | FCS1 Test | Contract Managers Team | Completed | Completed |

    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'NLAP-837' version '1' includes the following
    | Action                        | CompletedBy      | Comment                       |
    | Contract Closure Successful   | CRM Integration  | ?                             |
    | Approve Closure               | FCS1 Test       | ?                             |
    | Closure Initiation Successful | CRM Integration  | ?                             |
    | Initiate Contract Closure     | FCS2 Test       | ?                             |

    # Change the date 
    And   the override date is '06/04/2019' 

    # Bulk file to attempt a contract amendment. This should fail. Amendments are not permitted once contract has been closed  (21935)
    Given there are no files prefixed '10017837_NLAP-837' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 29012018155753 v2_A837' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 29012018155753 v2_A837' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 29012018155753 v2_A837' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 29012018155753 v2_A837.xlsx' exists in the Datafiles folder and UKPRN '10017837' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
   #And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # UDC020
    And   '[Contract] Cannot create a draft Contract Amendment if there is no existing Approved Contract' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Tidy up
    And   the override date is reset 
     
