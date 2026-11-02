Feature: WrongVersionInFeed 32792

@AcceptanceTest @Complete
Scenario: A769 Create and approve a Levy contract. Amend and approve. Amend and withdraw. Initiate then complete Termination. Check feed
    Given there are no allocations marked as Under Termination for UKPRN '10017769' 
    And   there are no terminated or closed allocations for UKPRN '10017769' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017769' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017769' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017769' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017769' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017769' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017769' 

    # Clear down CM feed
    And   the Contract Management atom feed is empty
 
    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS 
 
    # Clear down all subnominal data from PaaS for an FSP 
    And   there is no Subnominal data in PaaS for the following FSPs 
    | FSP            | 
    | LEVY1799       | 
    | NONLEVY2019    | 
 
 
 
 
    # Remove the provider from RoATP (ContractManagement.RoATPProvider) 
    And   there is no data on RoATP for the following providers 
    | Ukprn    | 
    | 10017769 | 
 
    # Add the provider to RoATP (ContractManagement.RoATPProvider) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017769 | 10017769 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 
 
 
 
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017769' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017769 Co Ltd' with UKPRN '10017769' and OrgId 'ORG0017769' and has 'FCS1 Test' as a manager 
 
    # Put data in the PaaS Organisation table (Organisation.Organisation) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017769 | 117769 | 10017769 Co Ltd | 0              | Active                | Yes           | AA017769      | ?             | 27 The Maltings        | ?                      | ?                      | ?                      | Stanstead Abbotts      | Hertfordshire          | SG12 8HG  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017769 |

 
 
 
    # Change the date 
    Given the override date is '16/03/2020' 
 
    # Inject data into the stub to create a contract with two allocations 
   #And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation 
    And   the following Levy event data is available in the DAS agreement stub 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 62769 | INITIATED | 2019-12-15T18:03:12.2769 | 10017769   | 28769             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017769' 
    Then  there is only one Levy contract in CRM for UKPRN '10017769' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017769' for FundingType 'LEVY' and period '1799' 
 
 
 
 
 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017769 | 10017769 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017769 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017769 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017769 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017769 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017769 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017769 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017769 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    ## Check deliverable period count prior to approval 
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
 
 
 
 
    # Change the date 
    Given the override date is '09/04/2020' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 
 
    ## Check deliverable period count after approval 
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a Apr-20 deliverable period for each of deliverables 1 through 14 for each allocation 
    Then  the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Apr-20   | DeliverableDescription                               | 
    | 10017769 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017769 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017769 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017769 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017769 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017769 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017769 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017769 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017769 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017769 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017769 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017769 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017769 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017769 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
    # 
    | 10017769 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017769 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017769 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017769 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017769 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017769 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017769 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017769 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017769 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017769 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017769 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017769 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017769 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017769 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 
 
    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017769 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 09/04/2020        | ?               | ?             | 
    | 10017769 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
 
    # Check ALLOCATION dates in CRM 
    And   the following allocation values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | 
    | 10017769 | [ContractNo]       | 1                     | [AllocRef_LEVY]     | 09/04/2020          | ?                 | 
    | 10017769 | [ContractNo]       | 1                     | [AllocRef_NLA]      | 09/04/2020          | ?                 | 
 
 
 

 
    # Issue a variation amendment against the contract to create v2
     
    # Change the date 
    Given the override date is '25/08/2020' 
 
    # Month end is not running 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
     
    # Issue a contract amendment request on v1 to create v2 
    When  a request is issued to amend the following Levy contract via Single 
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status | SubStatus             | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate | AllowUnderTermination | 
    | 10017769 | [MasterContractNo]   | [ContractNo]   | 1       | Draft  | Published to Provider | Variation     | No                       | Yes                          | Yes                   | 
 
    And   wait '20' seconds 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step  
    Then  the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |  
    | Draft  | Published to Provider  | Yes           | No                  | 2                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017769' for FundingType 'LEVY' and period '1799' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2' 
 
    ## Check deliverable period count after approval 
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # Check CONTRACT version, status and dates in CRM 
    Then   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017769 | [ContractNo]       | 2                     | 0                        | Approved         | Approved               | True          | True                | 09/04/2020        | ?               | Variation     | 
    | 10017769 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved               | False         | False               | 09/04/2020        | ?               | ?             | 
    | 10017769 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 


 


    # Issue a variation amendment against the contract to create v3
     
    # Change the date 
    Given the override date is '13/09/2020' 
 
    # Month end is not running 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
     
    # Issue a contract amendment request on v2 to create v3 
    When  a request is issued to amend the following Levy contract via Single 
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status | SubStatus             | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate | AllowUnderTermination | 
    | 10017769 | [MasterContractNo]   | [ContractNo]   | 2       | Draft  | Published to Provider | Variation     | No                       | Yes                          | Yes                   | 
 
    And   wait '20' seconds 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step  
    Then  the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |  
    | Draft  | Published to Provider  | Yes           | No                  | 3                     | 

    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017769' for FundingType 'LEVY' and period '1799' 

    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017769 | [ContractNo]       | 3                     | 0                        | Draft            | Published to Provider  | True          | False               | 09/04/2020        | ?               | Variation     | 
    | 10017769 | [ContractNo]       | 2                     | 0                        | Approved         | Approved               | False         | True                | 09/04/2020        | ?               | Variation     | 
    | 10017769 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved               | False         | False               | 09/04/2020        | ?               | ?             | 
    | 10017769 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 

 



    # Withdraw v3

    # Change the date 
    Given the override date is '17/09/2020' 

    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017769' for FundingType 'LEVY' and period '1799' 

    # Withdraw the contract
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'To test story 32792' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017769 | [ContractNo]       | 3                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 09/04/2020        | ?               | Variation     | 
    | 10017769 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 09/04/2020        | ?               | Variation     | 
    | 10017769 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 09/04/2020        | ?               | ?             | 
    | 10017769 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             | 





    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '15/10/2020'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | [ContractNo]  | 2               | 0                  | 15/10/2020              | Other                       | ?                                   |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | [AllocRef_LEVY]    | 15/10/2020                   | 15/10/2020                      |
    | [AllocRef_NLA]     | 15/10/2020                   | 15/10/2020                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017769 | [ContractNo]   | 2                     | 0                        | 15/10/2020                 | Other                        | ?                              | 15/10/2020              | Other                       | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017769 | [ContractNo]  | [AllocRef_LEVY]  | 2                     | 0                        | 15/10/2020                   | 15/10/2020        | 15/10/2020                      | 15/10/2020           |
    | 10017769 | [ContractNo]  | [AllocRef_NLA]   | 2                     | 0                        | 15/10/2020                   | 15/10/2020        | 15/10/2020                      | 15/10/2020           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '2' of contract '[ContractNo]' for provider '10017769'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017769 - 10017769 Co Ltd     | [ContractNo]   | Contract Managers Team  | ?                        | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017769 | [ContractNo]       | 3                     | 0                        | Withdrawn        | Withdrawn By Provider                    | False         | False               | 09/04/2020        | ?               | Variation     | 
    | 10017769 | [ContractNo]       | 2                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 09/04/2020        | ?               | Variation     | 
    | 10017769 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                 | False         | False               | 09/04/2020        | ?               | ?             | 
    | 10017769 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             | 





    # Approve Termination Initiation (30635)

    # Change the date - CRM ignores this
    Given the override date is '17/10/2020'

 #   # Clear down CM feed
 #   And   the Contract Management atom feed is empty

    # Complete an existing open Task
    When the following open Task currently linked to version '2' of contract '[ContractNo]' for provider '10017769' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Termination Initiation Approval  | Contract Managers Team    |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017769 | [ContractNo]       | 3                     | 0                        | Withdrawn        | Withdrawn By Provider    | False         | False               | 09/04/2020        | ?               | Variation     | 
    | 10017769 | [ContractNo]       | 2                     | 0                        | Approved         | Under Termination        | True          | True                | 09/04/2020        | ?               | Variation     | 
    | 10017769 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                 | False         | False               | 09/04/2020        | ?               | ?             | 
    | 10017769 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                        | False         | False               | 01/05/2017        | ?               | ?             | 

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '2' of contract '[ContractNo]' for provider '10017769'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017769 - 10017769 Co Ltd     | [ContractNo]   | Contract Managers Team  | ?                        | Completed       | Completed        |

    # Check the Termination details on the contract in CRM (These should not have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017769 | [ContractNo]   | 2                     | 0                        | 15/10/2020                 | Other                        | ?                              | 15/10/2020              | Other                       | ?                             |

    # Check the CM feed for the presence of a Contract Termination Initiation row (ItemType 4)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '2' of actual contract number '[ContractNo]'
    And   the ItemType '4' event for version '2' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017769 | [ContractNo]   | 2               | 0                  | 15/10/2020              | Other                           | [AllocRef_LEVY] | 15/10/2020            | 15/10/2020                |
    | 10017769 | [ContractNo]   | 2               | 0                  | 15/10/2020              | Other                           | [AllocRef_NLA]  | 15/10/2020            | 15/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017769 | [ContractNo]   | 2               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract [ContractNo]:2.0 was placed under termination |





    # Manager successfully COMPLETES the Termination (31411)

    # Change the date - CRM ignores this but it's used by .Net
    Given the override date is '22/10/2020'

 #   # Clear down CM feed
 #   And   the Contract Management atom feed is empty

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination
    When  CRM user 'FCS1 TEST' completes the termination request for Contract '[ContractNo]' Version '2' SubVersion '0' via SDK

    # Check the CONTRACT version, status and dates in CRM. Contract should auto-approve
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017769 | [ContractNo]       | 3                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017769 | [ContractNo]       | 2                     | 0                        | Closed           | Terminated                                | True          | True                | 09/04/2020        | 15/10/2020      | Variation     |
    | 10017769 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017769 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/05/2017        | ?               | ?             |


    # Check the Termination details on the contract in CRM (Version change and details c/f)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017769 | [ContractNo]   | 2                     | 0                        | 15/10/2020                 | Other                        | ?                              | 15/10/2020              | Other                       | ?                             |

    # Check the Termination details on the allocations in CRM (Version change and details c/f)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017769 | [ContractNo]  | [AllocRef_LEVY]  | 2                     | 0                        | 15/10/2020                   | 15/10/2020        | 15/10/2020                      | 15/10/2020           |
    | 10017769 | [ContractNo]  | [AllocRef_NLA]   | 2                     | 0                        | 15/10/2020                   | 15/10/2020        | 15/10/2020                      | 15/10/2020           |

    # Check the CM feed for the presence of a Contract Terminated row (ItemType 6)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '6' event for version '2' of actual contract number '[ContractNo]'
    And   the ItemType '6' event for version '2' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Terminated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017769 | [ContractNo]   | 2               | 0                  | 15/10/2020              | Other                           | [AllocRef_LEVY] | 15/10/2020            | 15/10/2020                |
    | 10017769 | [ContractNo]   | 2               | 0                  | 15/10/2020              | Other                           | [AllocRef_NLA]  | 15/10/2020            | 15/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                | Title                                            |
    | 10017769 | [ContractNo]   | 2               | 0                  | Contract Terminated                  | Contract has been terminated                 | Contract [ContractNo]:2.0 has been terminated    |


    # Tidy Up
    And   the override date is reset
       