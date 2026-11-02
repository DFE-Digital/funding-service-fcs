Feature: LevyAmdtUnderTermination 24175

@AcceptanceTest @Withdrawn20230123
@PublishNewLevyContract
Scenario: A301 Create and approve a Levy contract. Process payment instructions. Initiate termination and approve initiation. Amend (singleton) then Withdraw. Amend (bulk) then Approve. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017301' 
    And   there are no terminated or closed allocations for UKPRN '10017301'
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS
    And   there is no Contract, Task or Workflow data for UKPRN '10017301'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017301'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017301'
   #And   there are no notifications of type 'Contract Amendment Failed'
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017301'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017301'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
   


   # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017301'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017301 Co Ltd' with UKPRN '10017301' and OrgId 'ORG0017301' and has 'FCS1 Test' as a manager
    And   UPIN '117301' is associated with UKPRN '10017301' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017301 | 117301 | 10017301 Co Ltd | 0              | Active |

    # Set RoATP data (needed for amendment checks) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.
    And   the following providers exist on RoATP
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
    | 10017301 | 10017301 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    




    # Change the date 
    And   the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42864 | INITIATED | 2017-09-15T18:03:12.2539 | 10017301   | 28993             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017301'
    And   there is only one Levy contract in CRM for UKPRN '10017301' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017301 | 10017301 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017301 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017301 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
    | 10017301 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                  | 
    | 10017301 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships        | 
    | 10017301 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships        |
    | 10017301 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017301 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

	# I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved by the next step
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve parameters from CRM 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017301' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017301' 
    And   I retrieve the latest contract details from CRM for provider '10017301' for FundingType 'LEVY' and period '1799' 

    # Check deliverable period count prior to approval
    And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Change the date 
    Given the override date is '06/01/2021'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    # Check deliverable period count after approval
    Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # After approval there should be a Jan-21 deliverable period for each of deliverables 1 through 14 for each allocation 
    Then   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Jan-21   | DeliverableDescription                               | 
    | 10017301 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017301 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017301 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017301 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017301 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017301 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017301 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017301 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017301 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017301 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017301 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017301 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017301 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017301 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017301 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017301 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017301 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017301 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017301 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017301 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017301 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017301 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017301 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017301 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017301 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017301 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017301 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017301 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017301 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 06/01/2021        | ?               | ?             |
    | 10017301 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017301 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 06/01/2021          | ?                 |




    # Add PoI 'actuals' to the contract
	
	# Change the date
    Given the override date is '04/06/2021'

	# Clear down the actuals 
	And   there are no entries in the DCFS stub table

    # Pull DCFS PoI actuals from DC for May 2021 
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS43               | ORG0017301     | CM             | 202105 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 417.41      |
    | APPS           | APPS43               | ORG0017301     | CM             | 202105 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 421.21      |
    | APPS           | APPS43               | ORG0017301     | CM             | 202105 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 105.55      |
    | APPS           | APPS43               | ORG0017301     | CM             | 202105 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 110.00      |
    | APPS           | APPS43               | ORG0017301     | CM             | 202105 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 267.05      |
    | APPS           | APPS43               | ORG0017301     | CM             | 202105 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1168.10     |
    | APPS           | APPS43               | ORG0017301     | CM             | 202105 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 228.41      |
    | APPS           | APPS43               | ORG0017301     | CM             | 202105 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 405.00      |
    | APPS           | APPS43               | ORG0017301     | CM             | 202105 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 260.74      |
    | APPS           | APPS43               | ORG0017301     | CM             | 202105 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 8.00        |
    | APPS           | APPS43               | ORG0017301     | CM             | 202105 | LEVY1799                | [AllocRef_LEVY]          |         | 13              | 0            | 260.74      |
    | APPS           | APPS43               | ORG0017301     | CM             | 202105 | LEVY1799                | [AllocRef_LEVY]          |         | 14              | 0            | 823.00      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

	# Check the deliverable count in CRM 26 (14+12)
    Then  there are '40' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '02/08/2021'

    # Request termination of the contract via the CRM UI
    When  CRM user 'FCS8 Test' initiates contract termination for Contract '[ContractNo]' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | TerminationReason       | TerminationComments     |
    | 02/09/2021               | 17/09/2021              | Notice from Provider    | Company wound up        |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | [AllocRef_LEVY]  | 02/09/2021                  | 17/09/2021                |
    | [AllocRef_NLA]   | 02/09/2021                  | 17/09/2021                |


#	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#    And   the user forwards the termination request for manager approval via UI
#    And   the user forwards the termination request for manager approval via SDK
#
#    # Create a new Task. (Only needed where termination initiation is via SDK)
#    Given the following Tasks are created against version '1' of contract '[ContractNo]' for UKPRN '10017301'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017301 - 10017301 Co Ltd     | [ContractNo]   | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017301 | [ContractNo]       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 06/01/2021        | ?               | ?             |
    | 10017301 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | [ContractNo]   | 1                     | 0                        | 17/09/2021              | ?                       |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | [AllocRef_LEVY]  | 1                     | 0                        | 02/09/2021        | 17/09/2021                |
    | [AllocRef_NLA]   | 1                     | 0                        | 02/09/2021        | 17/09/2021                |

    


    # Approve the Termination Initiation

    # Change the date
    Given the override date is '03/08/2021'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017301' is triggered by User 'FCS5 Test'
    | Task                                       | Owner                   |
    | Confirm Termination Initiation Approval    | Contract Managers Team  |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017301 | [ContractNo]       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 06/01/2021        | ?               | ?             |
    | 10017301 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |




    # Amend the contract using singleton mechanism (Variation and No)

    # Change the date
    Given the override date is '04/08/2021'

    # Issue a contract amendment request on v1 to create v2 (using the singleton mechanism) without adding a NONLEVY allocation. This should succeed
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus          | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017301 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Under Termination  | Variation     | No                       | Yes                          |


    # Check CONTRACT version, status and dates in CRM have not changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017301 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider  | True          | False               | 06/01/2021        | ?               | Variation     |
    | 10017301 | [ContractNo]       | 1                     | 0                        | Approved         | Under Termination      | False         | True                | 06/01/2021        | ?               | ?             |
    | 10017301 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

	# Check the deliverable count in CRM (2 LEVY and 2 NONLEVY)
    And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Withdraw v2
    
    # Change the date
    Given the override date is '06/08/2021'

    # Withdraw the contract (Levy version of withdrawal)
    When  the next action performed by manager 'FCS1 Test' on the latest version of contract '[ContractNo]' is to 'Withdraw On Behalf Of Provider' specifying the reason as 'Test A301'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017301 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 06/01/2021        | ?               | Variation     |
    | 10017301 | [ContractNo]       | 1                     | 0                        | Approved         | Under Termination         | True          | True                | 06/01/2021        | ?               | ?             |
    | 10017301 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

	# Check the deliverable count in CRM 26 (14+12)
    And   there are '40' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




	# Amend the contract using bulk mechanism

    # Change the date
    Given the override date is '10/08/2021'

    # Issue a contract amendment request on v1 to create v3 (using the bulk mechanism) adding a NONLEVY allocation. This should succeed
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus         | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017301 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Under Termination | Variation     | Yes                      | Yes                   | Yes                          |

    Then  the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 3                     |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017301 | [ContractNo]       | 3                     | 0                        | Draft            | Published to Provider     | True          | False               | 06/01/2021        | ?               | Variation     |
    | 10017301 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 06/01/2021        | ?               | Variation     |
    | 10017301 | [ContractNo]       | 1                     | 0                        | Approved         | Under Termination         | False         | True                | 06/01/2021        | ?               | ?             |
    | 10017301 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

	# Check the deliverable count in CRM on v3 = 4 (2 LEVY + 2 NONLEVY)
    And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    


    # Approve the amendment
	
    Given the override date is '12/08/2021'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3' 

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017301 | [ContractNo]       | 3                     | 0                        | Approved         | Under Termination         | True          | True                | 06/01/2021        | ?               | Variation     |
    | 10017301 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 06/01/2021        | ?               | Variation     |
    | 10017301 | [ContractNo]       | 1                     | 0                        | Replaced         | Under Termination         | False         | False               | 06/01/2021        | ?               | ?             |
    | 10017301 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |


    # Check the deliverable count in CRM on v3 = 40 (14 LEVY + 12 LEVY 'Actuals' + 14 NONLEVY)
    And   there are '40' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | [AllocRef_LEVY]  | 1             | 1               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 1             | 2               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 1             | 3               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 1             | 4               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 1             | 5               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 1             | 6               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 1             | 7               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 1             | 8               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 1             | 9               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 1             | 10              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 1             | 11              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 1             | 12              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 1             | 13              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 1             | 14              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    #
    | [AllocRef_LEVY]  | 1             | 2               | 202105 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 417.41                      | 417.41           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 3               | 202105 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 421.21                      | 421.21           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 4               | 202105 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 105.55                      | 105.55           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 5               | 202105 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 110.00                      | 110.00           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 6               | 202105 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 267.05                      | 267.05           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 8               | 202105 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1168.10                     | 1168.10          | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 9               | 202105 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 228.41                      | 228.41           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 10              | 202105 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 405.00                      | 405.00           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 11              | 202105 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 260.74                      | 260.74           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 12              | 202105 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 8.00                        | 8.00             | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 13              | 202105 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 260.74                      | 260.74           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 14              | 202105 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 823.00                      | 823.00           | ?            | 0.00        |
    #
    | [AllocRef_LEVY]  | 3             | 1               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 3             | 2               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 3             | 3               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 3             | 4               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 3             | 5               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 3             | 6               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 3             | 7               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 3             | 8               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 3             | 9               | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 3             | 10              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 3             | 11              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 3             | 12              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 3             | 13              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]  | 3             | 14              | 202101 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
    #
    | [AllocRef_LEVY]  | 3             | 2               | 202105 | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 417.41                      | 417.41           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 3             | 3               | 202105 | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 421.21                      | 421.21           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 3             | 4               | 202105 | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 105.55                      | 105.55           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 3             | 5               | 202105 | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 110.00                      | 110.00           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 3             | 6               | 202105 | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 267.05                      | 267.05           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 3             | 8               | 202105 | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 1168.10                     | 1168.10          | ?            | 0.00        |
    | [AllocRef_LEVY]  | 3             | 9               | 202105 | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 228.41                      | 228.41           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 3             | 10              | 202105 | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 405.00                      | 405.00           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 3             | 11              | 202105 | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 260.74                      | 260.74           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 3             | 12              | 202105 | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 8.00                        | 8.00             | ?            | 0.00        |
    | [AllocRef_LEVY]  | 3             | 13              | 202105 | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 260.74                      | 260.74           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 3             | 14              | 202105 | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 823.00                      | 823.00           | ?            | 0.00        |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Complete 
@Long2Run @Long2Run123
@PublishNewLevyContract
Scenario: A298 Create and approve a Levy contract. Initiate termination and approve initiation. Repeatedly amend (bulk) and approve with different parameter settings. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017298' 
    And   there are no terminated or closed allocations for UKPRN '10017298'
    And   there is no Contract, Task or Workflow data for UKPRN '10017298'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017298'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017298'
   #And   there are no notifications of type 'Contract Amendment Failed'
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017298'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017298'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017298' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017298 Co Ltd' with UKPRN '10017298' and OrgId 'ORG0017298' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017298' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017298 | 117298 | 10017298 Co Ltd | 0              | Active                | Yes           | AA017298      | ?             | 108 Welsh Row          | ?                      | ?                      | ?                      | Nantwich               | Cheshire               | CW5 5EY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017298 |



    # Set RoATP data (needed for amendment checks) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.
    And   the following providers exist on RoATP
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
    | 10017298 | 10017298 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    




    # Create Contract

    # Change the date 
    And   the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42864 | INITIATED | 2017-09-15T18:03:12.2823 | 10017298   | 28223             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017298'
    And   there is only one Levy contract in CRM for UKPRN '10017298' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017298 | 10017298 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017298 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017298 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
    | 10017298 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                  | 
    | 10017298 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships        | 
    | 10017298 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships        | 
    | 10017298 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017298 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

	# I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved by the next step
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |




    # Retrieve parameters from CRM 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017298' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017298' 
    And   I retrieve the latest contract details from CRM for provider '10017298' for FundingType 'LEVY' and period '1799' 

    ## Check deliverable period count prior to approval
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Change the date 
    Given the override date is '06/01/2021'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    ## Check deliverable period count after approval
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # After approval there should be a Jan-21 deliverable period for each of deliverables 1 through 14
    Then  the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Jan-21   | DeliverableDescription                               | 
	| 10017298 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017298 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017298 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017298 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017298 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017298 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017298 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017298 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017298 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017298 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017298 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017298 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017298 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017298 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017298 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017298 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017298 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017298 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017298 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017298 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017298 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017298 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017298 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017298 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017298 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017298 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017298 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017298 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017298 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 06/01/2021        | ?               | ?             |
    | 10017298 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017298 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 06/01/2021          | ?                 |

    ## Check the deliverable count in CRM 14
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '02/08/2018'

    # Request termination of the contract 
    When  CRM user 'FCS8 Test' initiates contract termination for Contract '[ContractNo]' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | TerminationReason       | TerminationComments     |
    | 02/09/2021               | 17/09/2021              | Notice from Provider    | Company wound up        |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | [AllocRef_LEVY]  | 02/09/2021                  | 17/09/2021                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract '[ContractNo]' for UKPRN '10017298'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017298 - 10017298 Co Ltd     | [ContractNo]   | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017298 | [ContractNo]       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 06/01/2021        | ?               | ?             |
    | 10017298 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | [ContractNo]   | 1                     | 0                        | 17/09/2021              | Company wound up        |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | [AllocRef_LEVY]  | 1                     | 0                        | 02/09/2021        | 17/09/2021                |

    


    # Approve the Termination Initiation

    # Change the date
    Given the override date is '03/08/2018'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017298' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus   | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017298 | [ContractNo]       | 1                     | 0                        | Approved       | Under Termination   | True          | True                | 06/01/2021        | ?               | ?             |
    | 10017298 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                   | False         | False               | 01/05/2017        | ?               | ?             |

    ## Check the deliverable count in CRM 
    #And   there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




	# Test 1: Amend the contract using bulk mechanism. Parameters are such that an amendment will not occur. (Params= Yes & No)

    # Change the date
    Given the override date is '04/08/2018'

    # Issue a contract amendment request using the bulk mechanism. This should fail.
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus          | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017298 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Under Termination  | Variation     | Yes                      | No                    | Yes                          |

    # Check CONTRACT version, status and dates in CRM. Nothing should have changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus   | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017298 | [ContractNo]       | 1                     | 0                        | Approved       | Under Termination   | True          | True                | 06/01/2021        | ?               | ?             |
    | 10017298 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                   | False         | False               | 01/05/2017        | ?               | ?             |

    ## Check the deliverable count in CRM. This should not have changed
    #And   there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

	
	
	
	# Test 2: Amend the contract using bulk mechanism. Parameters are such that a NONLEVY allocation is not added to the contract but the amendment will occur. (Params= No & Yes)

    # Change the date
    Given the override date is '06/08/2021'

    # Issue a contract amendment request on v1 to create v2  (using the bulk mechanism) without adding a NONLEVY allocation. This should succeed
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus          | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017298 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Under Termination  | Variation     | No                       | Yes                   | Yes                          |

    # Check CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017298 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider  | True          | False               | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 1                     | 0                        | Approved         | Under Termination      | False         | True                | 06/01/2021        | ?               | ?             |
    | 10017298 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    ## Check the deliverable count in CRM 
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2' 

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017298 | [ContractNo]       | 2                     | 0                        | Approved         | Under Termination         | True          | True                | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 1                     | 0                        | Replaced         | Under Termination         | False         | False               | 06/01/2021        | ?               | ?             |
    | 10017298 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    ## Check the deliverable count in CRM 
    #And   there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Test 3: Amend the contract using bulk mechanism.  Parameters are such that a NONLEVY allocation is added to the contract as part of a successful amendment. (Params= Yes & Yes)

    # Change the date
    Given the override date is '08/08/2021'

    # Issue a contract amendment request on v2 to create v3 (using the bulk mechanism) adding a NONLEVY allocation this time. This should succeed
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus          | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017298 | [MasterContractNo]   | [ContractNo]   | 2       | Approved | Under Termination  | Variation     | Yes                      | Yes                   | Yes                          |

    # Check CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017298 | [ContractNo]       | 3                     | 0                        | Draft            | Published to Provider  | True          | False               | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 2                     | 0                        | Approved         | Under Termination      | False         | True                | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 1                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | ?             |
    | 10017298 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    ## Check deliverable period count in CRM after successful amendment (2 LEVY + 2 NONLEVY)
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3' 

    # Check CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017298 | [ContractNo]       | 3                     | 0                        | Approved         | Under Termination      | True          | True                | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 1                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | ?             |
    | 10017298 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    ## Check the deliverable count in CRM after successful amendment (14 LEVY + 14 NONLEVY)
    #And   there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Test 4: Amend the contract using bulk mechanism. Test 3 added a NONLEVY allocation to the contract so it is not added again when the contract is amended. (Params= Yes & Yes)

    # Change the date
    Given the override date is '10/08/2021'

    # Issue a contract amendment request on v3 to create v4 (using the bulk mechanism). A NONLEVY allocation is not added but the amendment should succeed
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus          | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017298 | [MasterContractNo]   | [ContractNo]   | 3       | Approved | Under Termination  | Variation     | Yes                      | Yes                   | Yes                          |

    # Check CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017298 | [ContractNo]       | 4                     | 0                        | Draft            | Published to Provider  | True          | False               | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 3                     | 0                        | Approved         | Under Termination      | False         | True                | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 1                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | ?             |
    | 10017298 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    ## Check deliverable period count in CRM after successful amendment (2 LEVY + 2 NONLEVY)
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '4' 

    # Check CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017298 | [ContractNo]       | 4                     | 0                        | Approved         | Under Termination      | True          | True                | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 3                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 1                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | ?             |
    | 10017298 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    ## Check the deliverable count in CRM after successful amendment (14 LEVY + 14 NONLEVY)
    #And   there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Test 5: Amend the contract using bulk mechanism. Test 3 added a NONLEVY allocation to the contract so it is not added again when the contract is amended. (Params= No & Yes)

    # Change the date
    Given the override date is '12/08/2021'

    # Issue a contract amendment request on v4 to create v5 (using the bulk mechanism). A NONLEVY allocation is not added. The amendment should succeed
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus          | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017298 | [MasterContractNo]   | [ContractNo]   | 4       | Approved | Under Termination  | Variation     | No                       | Yes                   | Yes                          |

    # Check CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017298 | [ContractNo]       | 5                     | 0                        | Draft            | Published to Provider  | True          | False               | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 4                     | 0                        | Approved         | Under Termination      | False         | True                | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 3                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 1                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | ?             |
    | 10017298 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    ## Check deliverable period count in CRM after successful amendment (2 LEVY + 2 NONLEVY)
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '5' 

    # Check CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017298 | [ContractNo]       | 5                     | 0                        | Approved         | Under Termination      | True          | True                | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 4                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 3                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 1                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | ?             |
    | 10017298 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    ## Check the deliverable count in CRM after successful amendment (14 LEVY + 14 NONLEVY)
    #And   there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Test 6: Amend the contract using bulk mechanism. Test 3 added a NONLEVY allocation to the contract so it is not added again when the contract is amended. (Params= No & No)

    # Change the date
    Given the override date is '14/08/2021'

    # Issue a contract amendment request on v5 to create v6 (using the bulk mechanism). A NONLEVY allocation is not added. The amendment should succeed
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus          | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017298 | [MasterContractNo]   | [ContractNo]   | 5       | Approved | Under Termination  | Variation     | No                       | No                    | Yes                          |

    # Check CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017298 | [ContractNo]       | 5                     | 0                        | Approved         | Under Termination      | True          | True                | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 4                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 3                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | Variation     |
    | 10017298 | [ContractNo]       | 1                     | 0                        | Replaced         | Under Termination      | False         | False               | 06/01/2021        | ?               | ?             |
    | 10017298 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    ## Check the deliverable count in CRM is 28 (14 LEVY + 14 NONLEVY)
    #And   there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Complete
@PublishNewLevyContract
Scenario: A279 Create and publish a Levy contract. Amend (single) 2x and auto-withdraw with different parameter settings. Withdraw latest then try and amend it. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017279' 
    And   there are no terminated or closed allocations for UKPRN '10017279'
    And   there is no Contract, Task or Workflow data for UKPRN '10017279'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017279'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017279'
   #And   there are no notifications of type 'Contract Amendment Failed'
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017279'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017279'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017279' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017279 Co Ltd' with UKPRN '10017279' and OrgId 'ORG0017279' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017279' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017279 | 117279 | 10017279 Co Ltd | 0              | Active                | Yes           | AA017279      | ?             | 23 Welsh Road          | ?                      | ?                      | ?                      | Nantwich               | Cheshire               | CW5 5EY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017279 |



    # Set RoATP data (needed for amendment checks) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.
    And   the following providers exist on RoATP
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
    | 10017279 | 10017279 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    




    # Create Contract

    # Change the date 
    And   the override date is '12/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42864 | INITIATED | 2017-09-15T18:03:12.2823 | 10017279   | 28223             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017279'
    And   there is only one Levy contract in CRM for UKPRN '10017279' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017279 | 10017279 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017279 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017279 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
    | 10017279 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |


    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                  | 
    | 10017279 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships        | 
    | 10017279 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships        | 
    | 10017279 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017279 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

	# I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved by the next step
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |




    # Retrieve parameters from CRM 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017279' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017279' 
    And   I retrieve the latest contract details from CRM for provider '10017279' for FundingType 'LEVY' and period '1799' 

    ## Check deliverable period count prior to approval
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Test 1: Amend the contract using singleton mechanism. V1 will be withdrawn and v2 created without a NONLEVY allocation (AddNonLevy param = No)

    # Change the date
    Given the override date is '03/08/2018'

    # Issue a contract amendment request using the single mechanism. This should succeed
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus             | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017279 | [MasterContractNo]   | [ContractNo]   | 1       | Draft    | Published to Provider | Variation     | No                       | Yes                          |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017279 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/05/2017        | ?               | Variation     |
    | 10017279 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Agency       | False         | False               | 01/05/2017        | ?               | ?             |
    | 10017279 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |


    ## Check the deliverable count in CRM (2 LEVY)
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Test 2: Amend the contract using singleton mechanism. V2 will be withdrawn and v3 created with a NONLEVY allocation (AddNonLevy param = Yes)

    # Change the date
    Given the override date is '05/08/2018'

    # Issue a contract amendment request using the single mechanism. This should succeed
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus             | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017279 | [MasterContractNo]   | [ContractNo]   | 2       | Draft    | Published to Provider | Variation     | Yes                      | Yes                          |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017279 | [ContractNo]       | 3                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/05/2017        | ?               | Variation     |
    | 10017279 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Agency       | False         | False               | 01/05/2017        | ?               | Variation     |
    | 10017279 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Agency       | False         | False               | 01/05/2017        | ?               | ?             |
    | 10017279 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    ## Check the deliverable count in CRM (2 LEVY and 2 NONLEVY)
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
	



    # Withdraw v3
    
    # Change the date
    Given the override date is '07/08/2018'

    # Withdraw the contract (Levy version of withdrawal)
    When  the next action performed by manager 'FCS1 Test' on the latest version of contract '[ContractNo]' is to 'Withdraw On Behalf Of Provider' specifying the reason as 'Test A279'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017279 | [ContractNo]       | 3                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/05/2017        | ?               | Variation     |
    | 10017279 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Agency       | False         | False               | 01/05/2017        | ?               | Variation     |
    | 10017279 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Agency       | False         | False               | 01/05/2017        | ?               | ?             |
    | 10017279 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

	## Check the deliverable count in CRM 
 #   And   there are '0' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Test 3: Amend the contract using singleton mechanism. As the latest version has been withdrawn, the amendment should be ignored

    # Change the date
    Given the override date is '09/08/2018'

    # Issue a contract amendment request using the single mechanism. This should succeed
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status    | SubStatus             | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017279 | [MasterContractNo]   | [ContractNo]   | 3       | Withdrawn | Withdrawn By Provider | Variation     | Yes                      | Yes                          |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017279 | [ContractNo]       | 3                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/05/2017        | ?               | Variation     |
    | 10017279 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Agency       | False         | False               | 01/05/2017        | ?               | Variation     |
    | 10017279 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Agency       | False         | False               | 01/05/2017        | ?               | ?             |
    | 10017279 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

	## Check the deliverable count in CRM 
 #   And   there are '0' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'


	# Tidy up
	And   the override date is reset
	 
	  