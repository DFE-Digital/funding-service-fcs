Feature: TerminationsAfterWithdrawalsBUG 30152

@AcceptanceTest @Complete
Scenario: A089 Create and approve a new Levy contract with a LEVY1799 allocation. Singleton amendment to create v2. Approve. Singleton amendment to create v3 adding NONLEVY2019. Publish then withdraw v3. Initiate then complete termination of v2. Check feed.
    Given there are no allocations marked as Under Termination for UKPRN '10017089' 
    And   there are no terminated or closed allocations for UKPRN '10017089' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017089' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017089' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017089' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017089' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017089' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017089' 
 
    # Clear down all subnominal data from PaaS for an FSP 
    And   there is no Subnominal data in PaaS for the following FSPs 
    | FSP            | 
    | LEVY1799       | 
    | NONLEVY2019    | 
 
 
    # Remove the provider from RoATP (ContractManagement.RoATPProvider) 
    And   there is no data on RoATP for the following providers 
    | Ukprn    | 
    | 10017089 | 
 
    # Add the provider to RoATP (ContractManagement.RoATPProvider) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017089 | 10017089 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017089' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017089 Co Ltd' with UKPRN '10017089' and OrgId 'ORG0017089' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017089' 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017089 | 117089 | 10017089 Co Ltd | 0              | Active                | Yes           | AA017089      | ?             | 8 Beaumont Gate        | Shenley Hill           | ?                      | ?                      | Radlett                | Hertfordshire          | WD7 7AR   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017089 |

 
 
 
    # Change the date 
    Given the override date is '22/03/2017' 
 
    # Inject data into the stub and create a new LEVY contract with one allocation 
   #And   the following Levy event data is available in the DAS agreement stub 
    And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 2089  | INITIATED | 2017-09-15T18:03:12.2089 | 10017089   | 28089             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017089' 
    Then  there is only one Levy contract in CRM for UKPRN '10017089' with a status of 'Draft' 
 
    # Publish the contract 
    Given the latest version of contract 'APPLEVY-089' is in a state of 'Published to Provider' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    Then  the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 
 
    # Retrieve parameters from CRM 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017089' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017089' 
    And   I retrieve the latest contract details from CRM for provider '10017089' for FundingType 'LEVY' and period '1799' 
 
 
 
 
 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017089 | 10017089 Co Ltd      | LEVY        | ESFA-089             | APPLEVY-089    | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017089 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef    | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017089 | LEVY              | LEVY1799                | APPLEVY-089    | LEVY-089         | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017089 | LEVY              | LEVY-089            | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017089 | LEVY              | LEVY-089            | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
 
 #  And   there are no open tasks for the contract 
 #  And   there is no contract owner assigned to the latest version of the contract 
 
    ## Check deliverable period count prior to approval 
    #And   there are '2' deliverable period rows in CRM linked to the latest version of contract number 'APPLEVY-089' 
 
 
 
 
    # Change the date 
    Given the override date is '06/05/2017' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-089' and ContractNumber 'APPLEVY-089' and Version '1' 
 
    ## Check deliverable period count after approval 
    #Then  there are '14' deliverable period rows in CRM linked to the latest version of contract number 'APPLEVY-089' 
 
    # After approval there should be a May-17 deliverable period for each of deliverables 1 through 14 for the allocation 
    Then the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                               | 
    | 10017089 | LEVY              | LEVY-089            | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017089 | LEVY              | LEVY-089            | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017089 | LEVY              | LEVY-089            | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017089 | LEVY              | LEVY-089            | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017089 | LEVY              | LEVY-089            | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017089 | LEVY              | LEVY-089            | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017089 | LEVY              | LEVY-089            | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017089 | LEVY              | LEVY-089            | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017089 | LEVY              | LEVY-089            | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017089 | LEVY              | LEVY-089            | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017089 | LEVY              | LEVY-089            | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017089 | LEVY              | LEVY-089            | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017089 | LEVY              | LEVY-089            | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017089 | LEVY              | LEVY-089            | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
 
    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017089 | APPLEVY-089        | 1                     | 0                        | Approved         | Approved               | True          | True                | 06/05/2017        | ?               | ?             | 
    | 10017089 | ESFA-089           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
 
    # Check ALLOCATION dates in CRM 
    And   the following allocation values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | 
    | 10017089 | APPLEVY-089        | 1                     | LEVY-089            | 06/05/2017          | ?                 | 
 



    # Amend v1 using the singleton mechanism without adding the NONLEVY allocation (Variation and No)

    # Change the date
    Given the override date is '05/08/2019'

    # Issue a contract amendment request on v1 to create v2 (using the singleton mechanism) without adding a NONLEVY allocation
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus  | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017089 | ESFA-089             | APPLEVY-089    | 1       | Approved | Approved   | Variation     | No                       | No                           |

    # Check CONTRACT version, status and dates in CRM (Waiting for publication to occur)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber    | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017089 | APPLEVY-089       | 2                     | 0                        | Draft            | Published to Provider  | True          | False               | 06/05/2017        | ?               | Variation     |
    | 10017089 | APPLEVY-089       | 1                     | 0                        | Approved         | Approved               | False         | True                | 06/05/2017        | ?               | ?             |
    | 10017089 | ESFA-089          | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Approve v2 of the contract 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-089' and ContractNumber 'APPLEVY-089' and Version '2' 

    # Check CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017089 | APPLEVY-089        | 2                     | 0                        | Approved         | Approved               | True          | True                | 06/05/2017        | ?               | Variation     | 
    | 10017089 | APPLEVY-089        | 1                     | 0                        | Replaced         | Approved               | False         | False               | 06/05/2017        | ?               | ?             | 
    | 10017089 | ESFA-089           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
    
#    # Check deliverable period count after approval 
#    And   there are '14' deliverable period rows in CRM linked to the latest version of contract number 'APPLEVY-089' 
#

    

    # Amend v2 using the singleton mechanism but this time add the NONLEVY allocation (Variation and Yes)

    # Change the date
    Given the override date is '13/01/2020'

    # Issue a contract amendment request on v2 to create v3 (using the singleton mechanism) adding a NONLEVY allocation
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus  | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017089 | ESFA-089             | APPLEVY-089    | 2       | Approved | Approved   | Variation     | Yes                      | No                           |

    # Check CONTRACT version, status and dates in CRM (Waiting for publication to occur)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber    | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017089 | APPLEVY-089       | 3                     | 0                        | Draft            | Published to Provider  | True          | False               | 06/05/2017        | ?               | Variation     |
    | 10017089 | APPLEVY-089       | 2                     | 0                        | Approved         | Approved               | False         | True                | 06/05/2017        | ?               | Variation     |
#   | 10017089 | APPLEVY-089       | 1                     | 0                        | Replaced         | Approved               | False         | False               | 06/05/2017        | ?               | ?             |
    | 10017089 | ESFA-089          | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |
   
#    # Check deliverable period count after publication of v3
#    And   there are '4' deliverable period rows in CRM linked to the latest version of contract number 'APPLEVY-089' 
#



    # Withdraw v3
    
    # Change the date
    Given the override date is '27/01/2020'

    # Withdraw the contract (Levy version of withdrawal)
    When  the next action performed by manager 'FCS1 Test' on the latest version of contract 'APPLEVY-089' is to 'Withdraw On Behalf Of Provider' specifying the reason as 'Test A089'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber    | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017089 | APPLEVY-089       | 3                     | 0                        | Withdrawn        | Withdrawn By Provider  | False         | False               | 06/05/2017        | ?               | Variation     |
    | 10017089 | APPLEVY-089       | 2                     | 0                        | Approved         | Approved               | True          | True                | 06/05/2017        | ?               | Variation     |
#   | 10017089 | APPLEVY-089       | 1                     | 0                        | Replaced         | Approved               | False         | False               | 06/05/2017        | ?               | ?             |
    | 10017089 | ESFA-089          | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    ## Check the deliverable count in CRM on v2
    #And   there are '14' deliverable period rows in CRM linked to the latest version of contract number 'APPLEVY-089'




    # Initiate TERMINATION of v2

    # Change the date
    Given the override date is '11/03/2020'

    # Request termination of the contract 
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'APPLEVY-089' Version '2' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 13/12/2019               | 13/12/2019              | No                          | Notice from Agency      | Test A089               |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | LEVY-089         | 13/12/2019                  | 13/12/2019                |

    # Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber    | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017089 | APPLEVY-089       | 3                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 06/05/2017        | ?               | Variation     |
    | 10017089 | APPLEVY-089       | 2                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 06/05/2017        | ?               | Variation     |
#   | 10017089 | APPLEVY-089       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 06/05/2017        | ?               | ?             |
    | 10017089 | ESFA-089          | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments     |
    | APPLEVY-089    | 2                     | 0                        | 13/12/2019              | Test A089               |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | LEVY-089         | 2                     | 0                        | 13/12/2019        | 13/12/2019                |

    # Create a new Task
    Given the following Tasks are created against version '2' of contract 'APPLEVY-089' for UKPRN '10017089'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017089 - 10017089 Co Ltd     | APPLEVY-089    | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '11/03/2020'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '2' of contract 'APPLEVY-089' for provider '10017089' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the termination task been completed
    Then  the following Tasks are present against version '2' of contract 'APPLEVY-089' for provider '10017089'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017089 - 10017089 Co Ltd      | APPLEVY-089    | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

#    # Has a 'Termination Initiation Successful' Workflow History entry been created ?
#    And   the workflow history on contract 'APPLEVY-089' version '2' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Termination Initiation Successful              | CRM Integration     | ?                                |
#    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
##   | Initiate Contract Termination                  | FCS8 Test           | Company sold                     |
#
#    # Check the CONTRACT version, status and dates in CRM
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber    | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus            | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10017089 | APPLEVY-089       | 3                     | 0                        | Withdrawn        | Withdrawn By Provider        | False         | False               | 06/05/2017        | ?               | Variation     |
#    | 10017089 | APPLEVY-089       | 2                     | 0                        | Approved         | Under Termination            | True          | True                | 06/05/2017        | ?               | Variation     |
##   | 10017089 | APPLEVY-089       | 1                     | 0                        | Replaced         | Approved                     | False         | False               | 06/05/2017        | ?               | ?             |
#    | 10017089 | ESFA-089          | 1                     | 0                        | Draft            | ?                            | False         | False               | 01/05/2017        | ?               | ?             |
#



    # Check feed (Was putting termination details for v3 on the feed. Should be putting v2) 

    # Check the CM feed for the presence of an ItemType 4 (Contract Termination Initiated) event
    #And   the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '2' of actual contract number 'APPLEVY-089'
    #And   the ItemType '4' event for version '2' of contract number 'APPLEVY-089' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
  # And   the ItemType '4' event for contract number 'APPLEVY-089' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Check the ContractManagement.AtomFeedItem (CM) feed for specific items and values (23185)
    #   Type 0 = Approval. Type 1 = 'Published to Provider'. Type 2 = Withdrawal. Type 3 = Closure. 
    #   Type 4 = 'Contract Termination Initiated'. Type 5 = 'Contract Termination Cancelled'. Type 6 = Contract Terminated
#    Then  the Legal Contract Feed includes the following values
#    | UKPRN    | ContractNumber | ContractVersion | ItemType | AllocationRef | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
#    | 10017089 | APPLEVY-089    | 2               | 4        | LEVY-089      | ?                         | ?                            |
#
#    # Check the CM feed event header information
#    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
#    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                 |
#    | 10017089 | APPLEVY-089    | 2               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract APPLEVY-089:2.0 was placed under termination |
#



    # Complete the Termination

    # Change the date (This is ignored by CRM)
    Given the override date is '15/03/2020'

    # Clear down the CM feed
    And   the Contract Management atom feed is empty

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination (23893)
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'APPLEVY-089' Version '2' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract 'APPLEVY-089' Version '2' SubVersion '0' via SDK

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber    | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus            | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017089 | APPLEVY-089       | 3                     | 0                        | Withdrawn        | Withdrawn By Provider        | False         | False               | 06/05/2017        | ?               | Variation     |
    | 10017089 | APPLEVY-089       | 2                     | 0                        | Closed           | Terminated                   | True          | True                | 06/05/2017        | 13/12/2019      | Variation     |
#   | 10017089 | APPLEVY-089       | 1                     | 0                        | Replaced         | Approved                     | False         | False               | 06/05/2017        | ?               | ?             |
    | 10017089 | ESFA-089          | 1                     | 0                        | Draft            | ?                            | False         | False               | 01/05/2017        | ?               | ?             |




    # Check feed again (Was putting termination details for v3 on the feed. Should be putting v2) 

    # Check the CM feed for the presence of an ItemType 6 (Contract Terminated) event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '6' event for version '2' of actual contract number 'APPLEVY-089'
    And   the ItemType '6' event for version '2' of contract number 'APPLEVY-089' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
  # And   the ItemType '6' event for contract number 'APPLEVY-089' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Check the ContractManagement.AtomFeedItem (CM) feed for specific items and values (23185)
    #   Type 0 = Approval. Type 1 = 'Published to Provider'. Type 2 = Withdrawal. Type 3 = Closure. 
    #   Type 4 = 'Contract Termination Initiated'. Type 5 = 'Contract Termination Cancelled'. Type 6 = Contract Terminated
    Then  the Legal Contract Feed includes the following values
    | UKPRN    | ContractNumber | ContractVersion | ItemType | AllocationRef | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    | 10017089 | APPLEVY-089    | 2               | 6        | LEVY-089      | ?                         | ?                            |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm         | CategoryLabel                  | Title                                          |
    | 10017089 | APPLEVY-089    | 2               | 0                  | Contract Terminated  | Contract has been terminated   | Contract APPLEVY-089:2.0 has been terminated   |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
Scenario: A092 Create and approve a DADA2021 contract. Non-financial amendment to create v2. Approve. Non-financial amendment to create v3. Publish then withdraw. Close v2. Check feed.
    Given there are no allocations marked as Under Termination for UKPRN '10017092' 
    And   there are no terminated or closed allocations for UKPRN '10017092' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017092' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017092' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | DADA-092      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | DADA-092      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | DADA2021          |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017092' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017092 Co Ltd' with UKPRN '10017092' and OrgId 'ORG0017092' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017092' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017092 | 117092 | 10017092 Co Ltd | 0              | In Administration     | Yes           | AA017092      | ?             | 43 Townhead Street     | Sheffield              | South Yorkshire        | ?                      | ?                      | ?                      | S1 2EB    |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017092 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017092 | 10017092 Co Ltd      | ESFA-092             | DADAS-092      | 1                     | 01/08/2020        | 31/07/2021      | 4272.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017092 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017092 | DADAS-092      | DADA-092      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 4272.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017092 | DADAS-092      | DADA-092      | 1               | 0                     | 4272.00   | 614.00    | 3658.00   | 0.00     | 614.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3658.00  | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'DADAS-092' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'DADAS-092'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-092' and ContractNumber 'DADAS-092' and Version '1'
  #  When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-092' and actual ContractNumber 'DADAS-092'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-092' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017092 | DADAS-092          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017092 | ESFA-092           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'DADAS-092'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | DADA-092        | 2207010          | Jul-21 | Profile        |





    # Create v2 by executing a non-financial VARIATION amendment on v1. Approve v2.

    # Change the date
    Given the override date is '12/07/2020'

    # Issue a non-financial VARIATION amendment on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'DADAS-092' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'DADAS-092' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017092 | DADAS-092          | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017092 | DADAS-092          | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017092 | ESFA-092           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'DADAS-092' is in a state of 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'DADAS-092'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-092' and ContractNumber 'DADAS-092' and Version '2'
  #  When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-092' and actual ContractNumber 'DADAS-092'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-092' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017092 | DADAS-092          | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017092 | DADAS-092          | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017092 | ESFA-092           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'DADAS-092'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | DADA-092        | 2207010          | Jul-21 | Profile        |

      


    # Create v3 by executing a non-financial VARIATION amendment on v2. Publish then withdraw v3

    # Change the date
    Given the override date is '11/08/2020'

    # Issue a non-financial VARIATION amendment on v2 to create v3
   #When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'DADAS-092' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'DADAS-092' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017092 | DADAS-092          | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017092 | DADAS-092          | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017092 | DADAS-092          | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017092 | ESFA-092           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'DADAS-092' is in a state of 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'DADAS-092'

    # Withdraw v3 of the contract 
    When  the next action performed on the latest version of contract 'DADAS-092' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017092 | DADAS-092          | 3                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017092 | DADAS-092          | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017092 | DADAS-092          | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017092 | ESFA-092           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |




    # Request contract closure
    
    # Change the date (to beyond the contract end-date)
    Given the override date is '02/09/2021'

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '2' of contract 'DADAS-092' for provider '10017092'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017092 | DADAS-092          | 3                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017092 | DADAS-092          | 2                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017092 | DADAS-092          | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017092 | ESFA-092           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |




    # Approve contract closure

    # Change the date 
    Given the override date is '04/09/2021' 

    # Approve closure of the contract. This should succeed
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '2' of contract 'DADAS-092' for provider '10017092'
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '2' of contract 'DADAS-092' for provider '10017092'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017092 | DADAS-092          | 3                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017092 | DADAS-092          | 2                     | 0                        | Closed           | Closed                    | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017092 | DADAS-092          | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017092 | ESFA-092           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |




    # Check feed (Was putting v3 details on the feed. Should be putting v2)

    # Check the CM feed for the presence of an ItemType 3 (Contract Closed) event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '3' event for version '2' of actual contract number 'DADAS-092'
    And   the ItemType '3' event for version '2' of contract number 'DADAS-092' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
  # And   the ItemType '3' event for contract number 'DADAS-092' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Check the ContractManagement.AtomFeedItem (CM) feed for specific items and values (23185)
    #   Type 0 = Approval. Type 1 = 'Published to Provider'. Type 2 = Withdrawal. Type 3 = Closure. 
    #   Type 4 = 'Contract Termination Initiated'. Type 5 = 'Contract Termination Cancelled'. Type 6 = Contract Terminated
    Then  the Legal Contract Feed includes the following values
    | UKPRN    | ContractNumber | ContractVersion | ItemType | AllocationRef | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    | 10017092 | DADAS-092      | 2               | 3        | DADA-092      | ?                         | ?                            |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm    | CategoryLabel              | Title                             |
    | 10017092 | DADAS-092      | 2               | 0                  | Contract Closed | A contract has been closed | Contract DADAS-092:2.0 was Closed |


    # Tidy Up
    And   the override date is reset   
           
               