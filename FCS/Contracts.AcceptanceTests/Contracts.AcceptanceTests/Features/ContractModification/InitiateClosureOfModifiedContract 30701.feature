Feature: InitiateClosureOfModifiedContract 30701

@AcceptanceTest @Withdrawn20231002
Scenario: A701 Create and approve a 1920AEBP contract. Initiate Modification. Approve Modification Initiation. Initiate contract closure. Reject. Initiate again. Authorise. Check CRM 
    Given there are no allocations marked as Under Termination for UKPRN '10017701' 
    And   there are no terminated or closed allocations for UKPRN '10017701' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017701' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017701' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017701' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-701      |
    | AETL-701      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-701      |
    | AETL-701      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-19TRLS1920    |
    | AEB-ASLS1920      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-701       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017701'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017701' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017701 Co Ltd' with UKPRN '10017701' and OrgId 'ORG0017701' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017701' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017701 | 117701 | 10017701 Co Ltd | 0              | Active                | Yes           | AA017701      | ?             | 3 Church Street        | ?                      | ?                      | ?                      | Tewkesbury             | Gloucestershire        | GL20 5PA  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017701 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017701 | 10017701 Co Ltd      | ESFA-701             | AEBP-701       | 1                     | 01/08/2019        | 31/07/2020      | 49352.00      |                                       | Procured                                   | 1920   | New          | ORG0017701 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017701 | AEBP-701       | AEAL-701      | AEB-ASLS          | AEB-ASLS1920            | AY                      | 01/08/2019          | 31/07/2020        | 21011.00        |                                         |            |                                                             | New          |             |
    | 10017701 | AEBP-701       | AETL-701      | AEB-19TRLS        | AEB-19TRLS1920          | AY                      | 01/08/2019          | 31/07/2020        | 28341.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017701 | AEBP-701       | AEAL-701      | 1               | 0                     | 21011.00  | 12079.00  | 8932.00   | 1392.00  | 735.00   | 1723.00  | 2459.00  | 1234.00  | 1209.00  | 300.00   | 3027.00  | 1263.00  | 2854.00  | 3749.00  | 1066.00  | Adult Education Budget - Adult Skills Learner Support           | New          |             | 
    | 10017701 | AEBP-701       | AETL-701      | 1               | 0                     | 28341.00  | 21572.00  | 6769.00   | 2139.00  | 3380.00  | 2377.00  | 2668.00  | 810.00   | 3666.00  | 3483.00  | 3049.00  | 652.00   | 440.00   | 2060.00  | 3617.00  | Adult Education Budget - 19-24 Traineeships Learner Support     | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP-701       | 1                     | 0                        | 2019-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-701'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-701' and actual ContractNumber 'AEBP-701'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-701' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017701 | AEBP-701           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017701 | ESFA-701           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'AEBP-701'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AETL-701        | 2355875          | Jul-20 | Reconciliation |
    | AEAL-701        | 2372175          | Jul-20 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                             | DeliverableDescription   | 
    | 10017701 | AEBP-701       | 1               | AEAL-701      | 1               | 0                     | 21011.00     | 0             | 0        | Adult Education Budget - Adult Skills Learner Support       | ?                        |
    | 10017701 | AEBP-701       | 1               | AETL-701      | 1               | 0                     | 28341.00     | 0             | 0        | Adult Education Budget - 19-24 Traineeships Learner Support | ?                        |




    # Initiate Modification (30697)

    # Change the date - CRM ignores this
    Given the override date is '01/07/2020'

    # Modification Initiation setup
    When  CRM user 'FCS2 TEST' initiates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017701 | AEBP-701      | 1               | 0                  | 05/07/2020               | Ofsted Insufficient Progress    | Provider request                        |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate modification request for manager approval via SDK

    # If all ok then Modification Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017701 | AEBP-701       | 1                     | 0                        | 05/07/2020               | 05/07/2020                   | Ofsted Insufficient Progress    | Ofsted Insufficient Progress        |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017701 | AEBP-701      | AEAL-701         | 1                     | 0                        | 05/07/2020                   | 05/07/2020        | Ofsted Insufficient Progress        | Ofsted Insufficient Progress        |
    | 10017701 | AEBP-701      | AETL-701         | 1                     | 0                        | 05/07/2020                   | 05/07/2020        | Ofsted Insufficient Progress        | Ofsted Insufficient Progress        |

    # A Modification Approval Task should have been created
    And   the following Tasks are present against version '1' of contract 'AEBP-701' for provider '10017701'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017701 - 10017701 Co Ltd     | AEBP-701       | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017701 | AEBP-701           | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017701 | ESFA-701           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2019        | 31/07/2020      | ?             |





    # Authorise Modification (30698)

    # Change the date - CRM ignores this
    Given the override date is '02/07/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task to Authorise the Modification
    When the following open Task currently linked to version '1' of contract 'AEBP-701' for provider '10017701' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Modification Approval            | FCS1 TEST                 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017701 | AEBP-701           | 1                     | 0                        | Approved         | Modified                                 | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017701 | ESFA-701           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the Task has been marked as completed
    Then  the following Tasks are present against version '1' of contract 'AEBP-701' for provider '10017701'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017701 - 10017701 Co Ltd     | AEBP-701       | FCS1 TEST               | Contract Managers Team   | Completed       | Completed        |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract 'AEBP-701' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Modification Successful                     | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Modification Approval in Progress            |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Approve Modification                        | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Modification Approval in Progress            | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-701' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                             |
    | Modification Successful                        | CRM Integration               | ?                                   |
    | Approve Modification                           | FCS5 TEST                     | ?                                   |
    | Initiate Contract Modification                 | FCS2 TEST                     | Provider request                    |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                   |

    # Check the contract modification details in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017701 | AEBP-701       | 1                     | 0                        | 05/07/2020               | 05/07/2020                   | Ofsted Insufficient Progress    | Ofsted Insufficient Progress        |

    # ... and the CRM allocation data too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason         |
    | 10017701 | AEBP-701      | AEAL-701         | 1                     | 0                        | 05/07/2020                   | 05/07/2020        | Ofsted Insufficient Progress        | Ofsted Insufficient Progress     |
    | 10017701 | AEBP-701      | AETL-701         | 1                     | 0                        | 05/07/2020                   | 05/07/2020        | Ofsted Insufficient Progress        | Ofsted Insufficient Progress     |

    # Check the CM feed for the presence of a 'Contract Modified' event (ItemType 8)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '8' event for version '1' of actual contract number 'AEBP-701'
    And   the ItemType '8' event for version '1' of actual contract number 'AEBP-701' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017701 | AEBP-701       | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract AEBP-701:1.0 was modified                     |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017701 | AEBP-701       | 1               | 0                  | ?                       | ?                               | AEAL-701        | 05/07/2020            | ?                         | Ofsted Insufficient Progress     |
    | 10017701 | AEBP-701       | 1               | 0                  | ?                       | ?                               | AETL-701        | 05/07/2020            | ?                         | Ofsted Insufficient Progress     |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017701 | AEBP-701       | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract AEBP-701:1.0 was modified                     |

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017701 | AEBP-701       | 1               | 0                  | ?                       | ?                               | AEAL-701        | 05/07/2020            | ?                         | Ofsted Insufficient Progress     |
    | 10017701 | AEBP-701       | 1               | 0                  | ?                       | ?                               | AETL-701        | 05/07/2020            | ?                         | Ofsted Insufficient Progress     |





    # Initiate Contract Closure (30701)
    
    # Change the date - CRM ignores this
    Given the override date is '03/08/2020' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'AEBP-701' for provider '10017701'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017701 | AEBP-701           | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017701 | ESFA-701           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017701 | AEBP-701           | 1                     | AEAL-701      | 01/08/2019          | 31/07/2020        |
    | 10017701 | AEBP-701           | 1                     | AETL-701      | 01/08/2019          | 31/07/2020        |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'AEBP-701' for provider '10017701'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State | Status        |
    | Confirm Closure Approval | 10017701 - 10017701 Co Ltd | AEBP-701  | FCS1 Test  | Contract Managers Team | Open  | Not Started   |
    
    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract 'AEBP-701' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Closure Initiation Successful               | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Closure Approval                    | FCS2 TEST             | FCS2 TEST                 | Approved       | Closure Initiation in Progress               |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Initiate Contract Closure                   | FCS2 TEST                     | FCS2 TEST        | FCS2 TEST                   | Approved          | Closure Initiation in Progress               | FCS2 TEST             | FCS1 TEST                 | Approved       | Modified                                     |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Modification Successful                     | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Modification Approval in Progress            |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Approve Modification                        | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Modification Approval in Progress            | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-701' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Closure Initiation Successful                  | CRM Integration               | ?                                    |
    | Initiate Contract Closure                      | FCS2 TEST                     | ?                                    |
    | Modification Successful                        | CRM Integration               | ?                                    |
    | Approve Modification                           | FCS5 TEST                     | ?                                    |
    | Initiate Contract Modification                 | FCS2 TEST                     | Provider request                     |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |
      
    # Check the CM feed for the absence of an ItemType 3 (Closure) row. This is not created until the closure is approved
    And   the ContractManagement.AtomFeedItem table does not contain an ItemType '3' event for version '1' of actual contract number 'AEBP-701'





    # Reject Contract Closure (30702)

    # Change the date - CRM ignores this
    Given the override date is '05/08/2020'

    And   there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017701' 

    # Reject closure of the contract. This should succeed
    #When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract 'AEBP-701' for provider '10017701'
    When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract 'AEBP-701' for provider '10017701' for the following reason
    | RejectionReason      |
    | Provider in dispute  |
 
    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017701 | AEBP-701           | 1                     | 0                        | Approved       | Modified          | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017701 | ESFA-701           | 1                     | 0                        | Draft          | ?                 | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'AEBP-701' for provider '10017701'
    | Task                     | Description                 | Regarding | Owner      | Assigned Team           | State      | Status     |
    | Confirm Closure Approval | 10017701 - 10017701 Co Ltd  | AEBP-701  | FCS1 Test  | Contract Managers Team  | Completed  | Completed  |

    # Check that a NOTIFICATION has been created and sent to the Advisor explaining why the closure has been rejected
   #And   there are notifications of type 'Contract Closure Rejected' owned by the 'Lead Manager Team' as follows
   #And   there are notifications of type 'Contract Closure Rejected' owned by the user 'FCS2 Test' as follows
    And   there is '1' notification of type 'Contract Closure Rejected' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                     | NotificationText                                                                                                 |
    | New    | Contract Closure Rejected - AEBP-701 | Closure of contract AEBP-701 v1 for provider 10017701 (10017701 Co Ltd) has been rejected - Provider in dispute  |

    # Check the CM feed for the absence of an ItemType 3 (Closure) row. This is not created until the closure is approved
    And   the ContractManagement.AtomFeedItem table does not contain an ItemType '3' event for version '1' of actual contract number 'AEBP-701'

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract 'AEBP-701' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Reject Closure (Modification)               | FCS1 TEST                     | FCS2 TEST        | FCS2 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Closure Approval                    |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Closure Initiation Successful               | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Closure Approval                    | FCS2 TEST             | FCS2 TEST                 | Approved       | Closure Initiation in Progress               |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Initiate Contract Closure                   | FCS2 TEST                     | FCS2 TEST        | FCS2 TEST                   | Approved          | Closure Initiation in Progress               | FCS2 TEST             | FCS1 TEST                 | Approved       | Modified                                     |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Modification Successful                     | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Modification Approval in Progress            |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Approve Modification                        | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Modification Approval in Progress            | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-701' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Reject Closure (Modification)                  | FCS1 TEST                     | Provider in dispute                  |
    | Closure Initiation Successful                  | CRM Integration               | ?                                    |
    | Initiate Contract Closure                      | FCS2 TEST                     | ?                                    |
    | Modification Successful                        | CRM Integration               | ?                                    |
    | Approve Modification                           | FCS5 TEST                     | ?                                    |
    | Initiate Contract Modification                 | FCS2 TEST                     | Provider request                     |





    # Initiate Contract Closure a second time (30701)
    
    # Change the date - CRM ignores this
    Given the override date is '19/10/2020' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'AEBP-701' for provider '10017701'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017701 | AEBP-701           | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017701 | ESFA-701           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017701 | AEBP-701           | 1                     | AEAL-701      | 01/08/2019          | 31/07/2020        |
    | 10017701 | AEBP-701           | 1                     | AETL-701      | 01/08/2019          | 31/07/2020        |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'AEBP-701' for provider '10017701'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State | Status        |
    | Confirm Closure Approval | 10017701 - 10017701 Co Ltd | AEBP-701  | FCS1 Test  | Contract Managers Team | Open  | Not Started   |

    # Check the CM feed for the absence of an ItemType 3 (Closure) row. This is not created until the closure is approved
    And   the ContractManagement.AtomFeedItem table does not contain an ItemType '3' event for version '1' of actual contract number 'AEBP-701'

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract 'AEBP-701' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Closure Initiation Successful               | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Closure Approval                    | FCS2 TEST             | FCS2 TEST                 | Approved       | Closure Initiation in Progress               |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Initiate Contract Closure                   | FCS2 TEST                     | FCS2 TEST        | FCS2 TEST                   | Approved          | Closure Initiation in Progress               | FCS2 TEST             | FCS2 TEST                 | Approved       | Modified                                     |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Reject Closure (Modification)               | FCS1 TEST                     | FCS2 TEST        | FCS2 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Closure Approval                    |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Closure Initiation Successful               | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Closure Approval                    | FCS2 TEST             | FCS2 TEST                 | Approved       | Closure Initiation in Progress               |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Initiate Contract Closure                   | FCS2 TEST                     | FCS2 TEST        | FCS2 TEST                   | Approved          | Closure Initiation in Progress               | FCS2 TEST             | FCS1 TEST                 | Approved       | Modified                                     |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Modification Successful                     | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Modification Approval in Progress            |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Approve Modification                        | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Modification Approval in Progress            | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-701' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                             |
    | Closure Initiation Successful                  | CRM Integration               | ?                                   |
    | Initiate Contract Closure                      | FCS2 TEST                     | ?                                   |
    | Reject Closure (Modification)                  | FCS1 TEST                     | Provider in dispute                 |
    | Closure Initiation Successful                  | CRM Integration               | ?                                   |
    | Initiate Contract Closure                      | FCS2 TEST                     | ?                                   |
    | Modification Successful                        | CRM Integration               | ?                                   |
    | Approve Modification                           | FCS5 TEST                     | ?                                   |
    | Initiate Contract Modification                 | FCS2 TEST                     | Provider request                    |





    # Authorise Contract Closure (30702)

    # Change the date - CRM ignores this
    Given the override date is '22/10/2020'

    # Approve closure of the contract. This should succeed
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract 'AEBP-701' for provider '10017701'
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract 'AEBP-701' for provider '10017701'
 
    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017701 | AEBP-701           | 1                     | 0                        | Closed         | Modified          | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017701 | ESFA-701           | 1                     | 0                        | Draft          | ?                 | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'AEBP-701' for provider '10017701'
    | Task                     | Description                 | Regarding | Owner      | Assigned Team           | State      | Status     |
    | Confirm Closure Approval | 10017701 - 10017701 Co Ltd  | AEBP-701  | FCS1 Test  | Contract Managers Team  | Completed  | Completed  |

    # Check the CM feed for the presence of an ItemType 3 (Closure) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '3' event for version '1' of actual contract number 'AEBP-701'
    And   the ItemType '3' event for version '1' of actual contract number 'AEBP-701' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract 'AEBP-701' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Contract Closure Successful (Modification)  | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Closed            | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Closure in Progress                          |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Approve Closure                             | FCS1 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Closure in Progress                          | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Closure Approval                    |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Closure Initiation Successful               | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Closure Approval                    | FCS2 TEST             | FCS2 TEST                 | Approved       | Closure Initiation in Progress               |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Initiate Contract Closure                   | FCS2 TEST                     | FCS2 TEST        | FCS2 TEST                   | Approved          | Closure Initiation in Progress               | FCS2 TEST             | FCS2 TEST                 | Approved       | Modified                                     |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Reject Closure (Modification)               | FCS1 TEST                     | FCS2 TEST        | FCS2 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Closure Approval                    |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Closure Initiation Successful               | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Closure Approval                    | FCS2 TEST             | FCS2 TEST                 | Approved       | Closure Initiation in Progress               |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Initiate Contract Closure                   | FCS2 TEST                     | FCS2 TEST        | FCS2 TEST                   | Approved          | Closure Initiation in Progress               | FCS2 TEST             | FCS1 TEST                 | Approved       | Modified                                     |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Modification Successful                     | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Modification Approval in Progress            |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Approve Modification                        | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Modification Approval in Progress            | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017701 | ESFA-701           | AEBP-701       | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-701' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Contract Closure Successful (Modification)     | CRM Integration               | ?                                    |
    | Approve Closure                                | FCS1 TEST                     | ?                                    |
    | Closure Initiation Successful                  | CRM Integration               | ?                                    |
    | Initiate Contract Closure                      | FCS2 TEST                     | ?                                    |
    | Reject Closure (Modification)                  | FCS1 TEST                     | Provider in dispute                  |
    | Closure Initiation Successful                  | CRM Integration               | ?                                    |
    | Initiate Contract Closure                      | FCS2 TEST                     | ?                                    |
    | Modification Successful                        | CRM Integration               | ?                                    |
    | Approve Modification                           | FCS5 TEST                     | ?                                    |
    | Initiate Contract Modification                 | FCS2 TEST                     | Provider request                     |


    # Tidy Up
    And   the override date is reset
  
@AcceptanceTest @Complete
Scenario: A702 Create and approve a LEVY contract. Initiate Modification. Approve Modification Initiation. Initiate contract closure. Reject. Initiate again. Authorise. Check CRM 
    Given there are no allocations marked as Under Termination for UKPRN '10017702' 
    And   there are no terminated or closed allocations for UKPRN '10017702' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017702' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017702' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017702' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017702' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017702' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017702' 
 
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
    | 10017702 | 
 
    # Add the provider to RoATP (ContractManagement.RoATPProvider) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017702 | 10017702 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 
 
 
 
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017702' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017702 Co Ltd' with UKPRN '10017702' and OrgId 'ORG0017702' and has 'FCS1 Test' as a manager 
 
    # Put data in the PaaS Organisation table (Organisation.Organisation) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017702 | 117702 | 10017702 Co Ltd | 0              | Provider Under Change | Yes           | AA017702      | ?             | 60a North Street       | ?                      | ?                      | ?                      | Chichester             | West Sussex            | PO19 1NB  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017702 |

 
 
 
    # Change the date 
    Given the override date is '16/03/2020' 
 
    # Inject data into the stub to create a contract with two allocations 
   #And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation 
    And   the following Levy event data is available in the DAS agreement stub 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 62702 | INITIATED | 2019-12-15T18:03:12.2702 | 10017702   | 28702             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017702' 
    Then  there is only one Levy contract in CRM for UKPRN '10017702' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017702' for FundingType 'LEVY' and period '1799' 
 
 
 
 
 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017702 | 10017702 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017702 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017702 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017702 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017702 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017702 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017702 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017702 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
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
    Then   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Apr-20   | DeliverableDescription                               | 
    | 10017702 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017702 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017702 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017702 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017702 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017702 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017702 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017702 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017702 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017702 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017702 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017702 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017702 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017702 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
    # 
    | 10017702 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017702 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017702 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017702 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017702 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017702 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017702 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017702 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017702 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017702 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017702 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017702 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017702 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017702 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 
 
    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017702 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 09/04/2020        | ?               | ?             | 
    | 10017702 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
 
    # Check ALLOCATION dates in CRM 
    And   the following allocation values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | 
    | 10017702 | [ContractNo]       | 1                     | [AllocRef_LEVY]     | 09/04/2020          | ?                 | 
    | 10017702 | [ContractNo]       | 1                     | [AllocRef_NLA]      | 09/04/2020          | ?                 | 
 



    # Initiate Modification (30697)

    # Change the date - CRM ignores this
    Given the override date is '01/06/2020'

    # Modification Initiation setup
    When  CRM user 'FCS2 TEST' initiates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017702 | [ContractNo]  | 1               | 0                  | 30/06/2020               | Removed from RoATP              | Contract being run down                 |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate modification request for manager approval via SDK

    # If all ok then Modification Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017702 | [ContractNo]   | 1                     | 0                        | 30/06/2020               | 30/06/2020                   | Removed from RoATP              | Removed from RoATP                  |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017702 | [ContractNo]  | [AllocRef_LEVY]  | 1                     | 0                        | 30/06/2020                   | 30/06/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017702 | [ContractNo]  | [AllocRef_NLA]   | 1                     | 0                        | 30/06/2020                   | 30/06/2020        | Removed from RoATP                  | Removed from RoATP                  |

    # A Modification Approval Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017702'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017702 - 10017702 Co Ltd     | [ContractNo]   | Contract Managers Team  | ?                        | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017702 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017702 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |





    # Authorise Modification (30698)

    # Change the date - CRM ignores this
    Given the override date is '02/06/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task to Authorise the Modification
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017702' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Modification Approval            | Contract Managers Team    |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017702 | [ContractNo]       | 1                     | 0                        | Approved         | Modified                                 | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017702 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the Task has been marked as completed
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017702'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017702 - 10017702 Co Ltd     | [ContractNo]   | Contract Managers Team  | ?                        | Completed       | Completed        |

    # Check the contract modification details in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017702 | [ContractNo]   | 1                     | 0                        | 30/06/2020               | 30/06/2020                   | Removed from RoATP              | Removed from RoATP                  |

    # ... and the CRM allocation data too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017702 | [ContractNo]  | [AllocRef_LEVY]  | 1                     | 0                        | 30/06/2020                   | 30/06/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017702 | [ContractNo]  | [AllocRef_NLA]   | 1                     | 0                        | 30/06/2020                   | 30/06/2020        | Removed from RoATP                  | Removed from RoATP                  |

    # Check the CM feed for the presence of a 'Contract Modified' event (ItemType 8)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '8' event for version '1' of actual contract number '[ContractNo]'
    And   the ItemType '8' event for version '1' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017702 | [ContractNo]   | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract [ContractNo]:1.0 was modified                 |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017702 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_LEVY] | 30/06/2020            | ?                         | Removed from RoATP               |
    | 10017702 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_NLA]  | 30/06/2020            | ?                         | Removed from RoATP               |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017702 | [ContractNo]   | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract [ContractNo]:1.0 was modified                 |

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017702 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_LEVY] | 30/06/2020            | ?                         | Removed from RoATP               |
    | 10017702 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_NLA]  | 30/06/2020            | ?                         | Removed from RoATP               |





    # Initiate Contract Closure (30701)
    
    # Change the date - CRM ignores this
    Given the override date is '15/07/2020' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '[ContractNo]' for provider '10017702'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017702 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017702 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | 
    | 10017702 | [ContractNo]       | 1                     | [AllocRef_LEVY]     | 09/04/2020          | ?                 | 
    | 10017702 | [ContractNo]       | 1                     | [AllocRef_NLA]      | 09/04/2020          | ?                 | 

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017702'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State | Status        |
    | Confirm Closure Approval | 10017702 - 10017702 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Open  | Not Started   |
     
    # Check the CM feed for the absence of an ItemType 3 (Closure) row. This is not created until the closure is approved
    And   the ContractManagement.AtomFeedItem table does not contain an ItemType '3' event for version '1' of contract number '[ContractNo]'





    # Reject Contract Closure (30702)

    # Change the date - CRM ignores this
    Given the override date is '05/08/2020'

    And   there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017702' 

    # Reject closure of the contract. This should succeed
    #When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract '[ContractNo]' for provider '10017702'
    When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract '[ContractNo]' for provider '10017702' for the following reason
    | RejectionReason      |
    | Appeal Lodged        |
 
    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017702 | [ContractNo]       | 1                     | 0                        | Approved       | Modified          | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017702 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                 | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017702'
    | Task                     | Description                 | Regarding     | Owner      | Assigned Team           | State      | Status     |
    | Confirm Closure Approval | 10017702 - 10017702 Co Ltd  | [ContractNo]  | FCS1 Test  | Contract Managers Team  | Completed  | Completed  |

    # Check that a NOTIFICATION has been created and sent to the Advisor explaining why the closure has been rejected
   #And   there are notifications of type 'Contract Closure Rejected' owned by the 'Lead Manager Team' as follows
   #And   there are notifications of type 'Contract Closure Rejected' owned by the user 'FCS2 Test' as follows
    And   there is '1' notification of type 'Contract Closure Rejected' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                         | NotificationText                                                                                               |
    | New    | Contract Closure Rejected - [ContractNo] | Closure of contract [ContractNo] v1 for provider 10017702 (10017702 Co Ltd) has been rejected - Appeal Lodged  |

    # Check the CM feed for the absence of an ItemType 3 (Closure) row. This is not created until the closure is approved
    And   the ContractManagement.AtomFeedItem table does not contain an ItemType '3' event for version '1' of actual contract number '[ContractNo]'





    # Initiate Contract Closure for a second time (30702)
    
    # Change the date - CRM ignores this
    Given the override date is '19/10/2020' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '[ContractNo]' for provider '10017702'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017702 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017702 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017702 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 09/04/2020          | ?                 | 
    | 10017702 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 09/04/2020          | ?                 | 

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017702'
    | Task                     | Description                | Regarding     | Owner      | Assigned Team          | State | Status        |
    | Confirm Closure Approval | 10017702 - 10017702 Co Ltd | [ContractNo]  | FCS1 Test  | Contract Managers Team | Open  | Not Started   |

    # Check the CM feed for the absence of an ItemType 3 (Closure) row. This is not created until the closure is approved
    And   the ContractManagement.AtomFeedItem table does not contain an ItemType '3' event for version '1' of actual contract number '[ContractNo]'





    # Authorise Contract Closure (30702)

    # Change the date - CRM ignores this
    Given the override date is '22/10/2020'

    # Approve closure of the contract. This should succeed
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract '[ContractNo]' for provider '10017702'
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract '[ContractNo]' for provider '10017702'
 
    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017702 | [ContractNo]       | 1                     | 0                        | Closed         | Modified          | True          | True                | 09/04/2020        | 22/10/2020      | ?             |
    | 10017702 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                 | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017702 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 09/04/2020          | 22/10/2020        | 
    | 10017702 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 09/04/2020          | 22/10/2020         | 

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017702'
    | Task                     | Description                 | Regarding     | Owner      | Assigned Team           | State      | Status     |
    | Confirm Closure Approval | 10017702 - 10017702 Co Ltd  | [ContractNo]  | FCS1 Test  | Contract Managers Team  | Completed  | Completed  |

    # Check the CM feed for the presence of an ItemType 3 (Closure) row
    And   the ContractManagement.AtomFeedItem table contains one ItemType '3' event for version '1' of actual contract number '[ContractNo]'
    And   the ItemType '3' event for version '1' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017702 | [MasterContractNo] | [ContractNo]   | 1                     | Contract Closure Successful (Modification)  | CRM Integration               | ?                | FCS1 TEST                   | Closed            | Modified                                     | ?                     | FCS1 TEST                 | Approved       | Closure in Progress                          |
    | 10017702 | [MasterContractNo] | [ContractNo]   | 1                     | Approve Closure                             | FCS1 TEST                     | ?                | FCS1 TEST                   | Approved          | Closure in Progress                          | ?                     | FCS1 TEST                 | Approved       | Awaiting Closure Approval                    |
    | 10017702 | [MasterContractNo] | [ContractNo]   | 1                     | Closure Initiation Successful               | CRM Integration               | ?                | FCS1 TEST                   | Approved          | Awaiting Closure Approval                    | ?                     | FCS2 TEST                 | Approved       | Closure Initiation in Progress               |
    | 10017702 | [MasterContractNo] | [ContractNo]   | 1                     | Initiate Contract Closure                   | FCS2 TEST                     | ?                | FCS2 TEST                   | Approved          | Closure Initiation in Progress               | ?                     | FCS2 TEST                 | Approved       | Modified                                     |
    | 10017702 | [MasterContractNo] | [ContractNo]   | 1                     | Reject Closure (Modification)               | FCS1 TEST                     | ?                | FCS2 TEST                   | Approved          | Modified                                     | ?                     | FCS1 TEST                 | Approved       | Awaiting Closure Approval                    |
    | 10017702 | [MasterContractNo] | [ContractNo]   | 1                     | Closure Initiation Successful               | CRM Integration               | ?                | FCS1 TEST                   | Approved          | Awaiting Closure Approval                    | ?                     | FCS2 TEST                 | Approved       | Closure Initiation in Progress               |
    | 10017702 | [MasterContractNo] | [ContractNo]   | 1                     | Initiate Contract Closure                   | FCS2 TEST                     | ?                | FCS2 TEST                   | Approved          | Closure Initiation in Progress               | ?                     | Contract Managers Team    | Approved       | Modified                                     |
    | 10017702 | [MasterContractNo] | [ContractNo]   | 1                     | Modification Successful                     | CRM Integration               | ?                | Contract Managers Team      | Approved          | Modified                                     | ?                     | Contract Managers Team    | Approved       | Modification Approval in Progress            |
    | 10017702 | [MasterContractNo] | [ContractNo]   | 1                     | Approve Modification                        | FCS5 TEST                     | ?                | Contract Managers Team      | Approved          | Modification Approval in Progress            | ?                     | Contract Managers Team    | Approved       | Awaiting Modification Approval               |
    | 10017702 | [MasterContractNo] | [ContractNo]   | 1                     | Initiate Contract Modification              | FCS2 TEST                     | ?                | Contract Managers Team      | Approved          | Awaiting Modification Approval               | ?                     | CRM Integration           | Approved       | Approved                                     |

    # Check the Workflow History comments 
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Contract Closure Successful (Modification)     | CRM Integration               | ?                                    |
    | Approve Closure                                | FCS1 TEST                     | ?                                    |
    | Closure Initiation Successful                  | CRM Integration               | ?                                    |
    | Initiate Contract Closure                      | FCS2 TEST                     | ?                                    |
    | Reject Closure (Modification)                  | FCS1 TEST                     | Appeal Lodged                        |
    | Closure Initiation Successful                  | CRM Integration               | ?                                    |
    | Initiate Contract Closure                      | FCS2 TEST                     | ?                                    |
    | Modification Successful                        | CRM Integration               | ?                                    |
    | Approve Modification                           | FCS5 TEST                     | ?                                    |
    | Initiate Contract Modification                 | FCS2 TEST                     | Contract being run down              |


    # Tidy Up
    And   the override date is reset
       
@AcceptanceTest @Withdrawn20231002
Scenario: A703 Create and approve a 1920 NLG contract. Initiate Modification. Approve Modification Initiation. NFA amendment. Attempt to End contract. Fail. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017703' 
    And   there are no terminated or closed allocations for UKPRN '10017703' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017703' 
    And   there are no notifications in CRM of type 'Contract Closure Initiation Failed' for UKPRN '10017703' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017703' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NLG-703       |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | NLG-703       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | NLG1920           |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | NONLG-703      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017703'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017703' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017703 Co Ltd' with UKPRN '10017703' and OrgId 'ORG0017703' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017703' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017703 | 117703 | 10017703 Co Ltd | 0              | Active                | Yes           | AA017703      | ?             | 4 Denville Road        | Lemington Spa          | ?                      | ?                      | ?                      | ?                      | CV32 5UW  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017703 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017703 | 10017703 Co Ltd      | ESFA-703             | NONLG-703      | 1                     | 01/08/2019        | 31/07/2020      | 50926.00      |                                       | Contract for Services                      | 1920   | New          | ORG0017703 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017703 | NONLG-703      | NLG-703       | NLG               | NLG1920                 | AY                      | 01/08/2019          | 31/07/2020        | 50926.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017703 | NONLG-703      | NLG-703       | 101             | 0                     | 23353.00  | 16951.00  | 6402.00   | 2806.00  | 2119.00  | 1462.00  | 2451.00  | 3187.00  | 1961.00  | 1937.00  | 1028.00  | 54.00    | 1991.00  | 3582.00  | 775.00   | Principals Reference Group (PRG)                                | New          |             | 
    | 10017703 | NONLG-703      | NLG-703       | 102             | 0                     | 27573.00  | 21576.00  | 5997.00   | 3408.00  | 2089.00  | 3329.00  | 2326.00  | 2617.00  | 759.00   | 3615.00  | 3433.00  | 2998.00  | 601.00   | 389.00   | 2009.00  | National Leaders of Further Education (NLFE)                    | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | NONLG-703      | 1                     | 0                        | 2019-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NONLG-703'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-703' and actual ContractNumber 'NONLG-703'

    # Check that the contract is now approved
    Then  the latest version of contract 'NONLG-703' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017703 | NONLG-703          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017703 | ESFA-703           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'NONLG-703'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | NLG-703         | 2208100          | Jul-20 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                             | DeliverableDescription                                      | 
    | 10017703 | NONLG-703      | 1               | NLG-703       | 101             | 0                     | 23353.00     | 0             | 0        | Principals Reference Group (PRG)                            | ?                                                           |
    | 10017703 | NONLG-703      | 1               | NLG-703       | 102             | 0                     | 27573.00     | 0             | 0        | National Leaders of Further Education (NLFE)                | ?                                                           |

 
 


    # Initiate Modification (30697)

    # Change the date - CRM ignores this
    Given the override date is '15/06/2020'

    # Modification Initiation setup
    When  CRM user 'FCS2 TEST' initiates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017703 | NONLG-703     | 1               | 0                  | 15/06/2020               | Inadequate Ofsted               | ?                                       |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate modification request for manager approval via SDK

    # If all ok then Modification Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017703 | NONLG-703      | 1                     | 0                        | 15/06/2020               | 15/06/2020                   | Inadequate Ofsted               | Inadequate Ofsted                   |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017703 | NONLG-703     | NLG-703          | 1                     | 0                        | 15/06/2020                   | 15/06/2020        | Inadequate Ofsted                   | Inadequate Ofsted                   |

    # A Modification Approval Task should have been created
    And   the following Tasks are present against version '1' of contract 'NONLG-703' for provider '10017703'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017703 - 10017703 Co Ltd     | NONLG-703      | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017703 | NONLG-703          | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017703 | ESFA-703           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2019        | 31/07/2020      | ?             |





    # Authorise Modification (30698)

    # Change the date - CRM ignores this
    Given the override date is '16/06/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task to Authorise the Modification
    When the following open Task currently linked to version '1' of contract 'NONLG-703' for provider '10017703' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Modification Approval            | FCS1 TEST                 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017703 | NONLG-703          | 1                     | 0                        | Approved         | Modified                                 | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017703 | ESFA-703           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the Task has been marked as completed
    Then  the following Tasks are present against version '1' of contract 'NONLG-703' for provider '10017703'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017703 - 10017703 Co Ltd     | NONLG-703      | FCS1 TEST               | Contract Managers Team   | Completed       | Completed        |

    # Check the contract modification details in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017703 | NONLG-703      | 1                     | 0                        | 15/06/2020               | 15/06/2020                   | Inadequate Ofsted               | Inadequate Ofsted                   |

    # ... and the CRM allocation data too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017703 | NONLG-703     | NLG-703          | 1                     | 0                        | 15/06/2020                   | 15/06/2020        | Inadequate Ofsted                   | Inadequate Ofsted                   |

    # Check the CM feed for the presence of a 'Contract Modified' event (ItemType 8)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '8' event for version '1' of actual contract number 'NONLG-703'
    And   the ItemType '8' event for version '1' of actual contract number 'NONLG-703' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                              | Title                                                  |
    | 10017703 | NONLG-703      | 1               | 0                  | Contract Modified              | Contract has been modified                 | Contract NONLG-703:1.0 was modified                    |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017703 | NONLG-703      | 1               | 0                  | ?                       | ?                               | NLG-703         | 15/06/2020            | ?                         | Inadequate Ofsted                |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                              | Title                                                  |
    | 10017703 | NONLG-703      | 1               | 0                  | Contract Modified              | Contract has been modified                 | Contract NONLG-703:1.0 was modified                    |

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017703 | NONLG-703      | 1               | 0                  | ?                       | ?                               | NLG-703         | 15/06/2020            | ?                         | Inadequate Ofsted                |





    # Execute a NON-FINANCIAL amendment 

    # Change the date
    Given the override date is '22/06/2020'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'NONLG-703' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017703 | NONLG-703          | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017703 | NONLG-703          | 1                     | 0                        | Approved         | Modified                                 | False         | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017703 | ESFA-703           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2019        | 31/07/2020      | ?             |




    # Attempt Contract Closure

    # Change the date 
    And   the override date is '23/06/2020' 

    # Request Contract Closure. This should fail
    When  a request is raised by Advisor 'FCS2 Test' to close version '2' of contract 'NONLG-703' for provider '10017703'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017703 | NONLG-703          | 2                     | 0                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017703 | NONLG-703          | 1                     | 0                        | Approved         | Modified                                 | False         | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017703 | ESFA-703           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2019        | 31/07/2020      | ?             |


    # Check Notification

    # Check that a NOTIFICATION has been created and sent to the Advisor explaining why the closure failed
    And   there is '1' notification of type 'Contract Closure Initiation Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                                | NotificationText                                                                                                         |
    | New    | Contract Closure Initiation Failed - NONLG-703  | Contract NONLG-703 v2 for provider 10017703 (10017703 Co Ltd) cannot be closed - it must be either Approved or Modified  |


#    # Check Workflow History
#
#    # No entries created for 'Initiate Contract Closure' or 'Closure Initiation Failed'. (Same as 21928 in R39)
#    And   the following workflow history entries are not present on the latest version of the contract 
#    | Action                    |
#    | Initiate Contract Closure |
#    | Closure Initiation Failed |


    # Tidy Up
    And   the override date is reset
       
              