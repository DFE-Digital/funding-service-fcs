Feature: InitiateModification 30697

@AcceptanceTest @Withdrawn20231002
Scenario: A571 Create and approve a 4-alloc 2021 AEBP contract. Initiate, reject, re-initiate, approve then update Modification. Bulk amend to add alloc. Check CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017571' 
    And   there are no terminated or closed allocations for UKPRN '10017571' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017571' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017571'

    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017571' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-571      |
    | AEBA-571      |
    | AEBR-571      |
    | AETL-571      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-571      |
    | AEBA-571      |
    | AEBR-571      |
    | AETL-571      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-19TRLS2021    |
    | AEB-19TRN2021     |
    | AEB-AS2021        |
    | AEB-ASLS2021      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-571       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017571'



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017571' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017571 Co Ltd' with UKPRN '10017571' and OrgId 'ORG0017571' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017571' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017571 | 117571 | 10017571 Co Ltd | 0              | Locked Restructure    | Yes           | AA017571      | ?             | 29 Church Street       | Basingstoke            | ?                      | ?                      | ?                      | ?                      | RG21 7QQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017571 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017571 | 10017571 Co Ltd      | ESFA-571             | AEBP-571       | 1                     | 01/08/2020        | 31/07/2021      | 95957.00      |                                       | Procured                                   | 2021   | New          | ORG0017571 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017571 | AEBP-571       | AEAL-571      | AEB-ASLS          | AEB-ASLS2021            | AY                      | 01/08/2020          | 31/07/2021        | 24262.00        |                                         |            |                                                             | New          |             |
    | 10017571 | AEBP-571       | AEBA-571      | AEB-AS            | AEB-AS2021              | AY                      | 01/08/2020          | 31/07/2021        | 28053.00        |                                         |            |                                                             | New          |             |
    | 10017571 | AEBP-571       | AEBR-571      | AEB-19TRN         | AEB-19TRN2021           | AY                      | 01/08/2020          | 31/07/2021        | 20198.00        |                                         |            |                                                             | New          |             |
    | 10017571 | AEBP-571       | AETL-571      | AEB-19TRLS        | AEB-19TRLS2021          | AY                      | 01/08/2020          | 31/07/2021        | 23444.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017571 | AEBP-571       | AEAL-571      | 1               | 0                     | 24262.00  | 16260.00  | 8002.00   | 1270.00  | 2100.00  | 2328.00  | 3380.00  | 1206.00  | 1310.00  | 1982.00  | 2684.00  | 2313.00  | 707.00   | 1824.00  | 3158.00  | Adult Education Budget - Adult Skills Learner Support           | New          |             | 
    | 10017571 | AEBP-571       | AEBA-571      | 1               | 0                     | 28053.00  | 18133.00  | 9920.00   | 3718.00  | 1386.00  | 981.00   | 230.00   | 2483.00  | 3125.00  | 3164.00  | 3046.00  | 3402.00  | 2334.00  | 1835.00  | 2349.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017571 | AEBP-571       | AEBR-571      | 1               | 0                     | 20198.00  | 12644.00  | 7554.00   | 280.00   | 1204.00  | 1149.00  | 2296.00  | 2558.00  | 2755.00  | 2162.00  | 240.00   | 1323.00  | 794.00   | 3363.00  | 2074.00  | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10017571 | AEBP-571       | AETL-571      | 1               | 0                     | 23444.00  | 13825.00  | 9619.00   | 1159.00  | 2622.00  | 952.00   | 1278.00  | 2266.00  | 3002.00  | 794.00   | 1752.00  | 843.00   | 3571.00  | 1807.00  | 3398.00  | Adult Education Budget - 19-24 Traineeships Learner Support     | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP-571       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-571' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-571'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-571' and actual ContractNumber 'AEBP-571'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-571' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017571 | AEBP-571           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017571 | ESFA-571           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'AEBP-571'

#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | AETL-571        | 2355875          | Jul-21 | Reconciliation |
#    | AEBR-571        | 2355800          | Jul-21 | Reconciliation |
#    | AEBA-571        | 2372010          | Jul-21 | Reconciliation |
#    | AEAL-571        | 2372175          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '4' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                             | DeliverableDescription     | 
    | 10017571 | AEBP-571       | 1               | AEAL-571      | 1               | 0                     | 24262.00     | 0             | 0        | Adult Education Budget - Adult Skills Learner Support       | ?                          |
    | 10017571 | AEBP-571       | 1               | AEBA-571      | 1               | 0                     | 28053.00     | 0             | 0        | Adult Skills Total Funding                                  | ?                          |
    | 10017571 | AEBP-571       | 1               | AEBR-571      | 1               | 0                     | 20198.00     | 0             | 0        | 19-24 Traineeships Total Funding                            | ?                          |
    | 10017571 | AEBP-571       | 1               | AETL-571      | 1               | 0                     | 23444.00     | 0             | 0        | Adult Education Budget - 19-24 Traineeships Learner Support | ?                          |





    # Initiate Modification (30697)

    # Change the date - CRM ignores this
    Given the override date is '14/10/2020'

    # Modification Initiation setup
    When  CRM user 'FCS2 TEST' initiates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017571 | AEBP-571      | 1               | 0                  | 09/10/2020               | Other                           | No longer providing training            |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate modification request for manager approval via SDK

    # If all ok then Modification Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017571 | AEBP-571       | 1                     | 0                        | 09/10/2020               | 09/10/2020                   | Other                           | Other                               |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017571 | AEBP-571      | AEAL-571         | 1                     | 0                        | 09/10/2020                   | 09/10/2020        | Other                               | Other                               |
    | 10017571 | AEBP-571      | AEBA-571         | 1                     | 0                        | 09/10/2020                   | 09/10/2020        | Other                               | Other                               |
    | 10017571 | AEBP-571      | AEBR-571         | 1                     | 0                        | 09/10/2020                   | 09/10/2020        | Other                               | Other                               |
    | 10017571 | AEBP-571      | AETL-571         | 1                     | 0                        | 09/10/2020                   | 09/10/2020        | Other                               | Other                               |

    # A Modification Approval Task should have been created
    And   the following Tasks are present against version '1' of contract 'AEBP-571' for provider '10017571'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017571 - 10017571 Co Ltd     | AEBP-571       | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'AEBP-571' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-571' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Initiate Contract Modification                 | FCS2 TEST                     | No longer providing training     |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017571 | AEBP-571           | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017571 | ESFA-571           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Reject Modification (30698)

    # Change the date - CRM ignores this
    Given the override date is '15/10/2020'

    # Clear out specific Notifications
    And   there are no notifications of type 'Contract Modification Rejected' 

    # Reject Modification using the Next Action step
    When the next action performed by manager 'FCS1 Test' on the latest version of contract 'AEBP-571' is to 'Reject Modification' specifying the reason as 'Technical misunderstanding'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017571 | AEBP-571           | 1                     | 0                        | Approved         | Approved                                 | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017571 | ESFA-571           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the Task has been marked as completed - even though it hasn't been actioned
    Then  the following Tasks are present against version '1' of contract 'AEBP-571' for provider '10017571'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017571 - 10017571 Co Ltd     | AEBP-571       | FCS1 TEST               | Contract Managers Team   | Completed       | Completed        |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'AEBP-571' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                             | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus               |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Reject Modification                         | FCS1 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Approved                                 | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval  |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval           | FCS2 TEST             | Document Management Team  | Approved       | Approved                        |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                 | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider           |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-571' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Reject Modification                            | FCS1 TEST                     | Technical misunderstanding       |
    | Initiate Contract Modification                 | FCS2 TEST                     | No longer providing training     |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check that a NOTIFICATION has been created
   #Then  there is '1' notification of type 'Contract Modification Rejected' owned by team 'CRMDeploy CRMDeploy' which matches the following
   #Then  there are notifications of type 'Contract Modification Rejected' owned by the 'CRMDeploy CRMDeploy' as follows
    Then  there are notifications of type 'Contract Modification Rejected' owned by the user 'CRMDeploy CRMDeploy' as follows
    | Status | NotificationName                                          | NotificationText                                                                                                                                      |
    | New    | Contract Modification Rejected-AEBP-571                   | Modification for contract AEBP-571 v1 for provider 10017571 (10017571 Co Ltd) has been rejected - Technical misunderstanding                          |

    # The contract data will have been reset in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017571 | AEBP-571       | 1                     | 0                        | ?                        | ?                            | ?                               | ?                                   |

    # ... and the allocation data will have been reset in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017571 | AEBP-571      | AEAL-571         | 1                     | 0                        | ?                            | ?                 | ?                                   | ?                                   |
    | 10017571 | AEBP-571      | AEBA-571         | 1                     | 0                        | ?                            | ?                 | ?                                   | ?                                   |
    | 10017571 | AEBP-571      | AEBR-571         | 1                     | 0                        | ?                            | ?                 | ?                                   | ?                                   |
    | 10017571 | AEBP-571      | AETL-571         | 1                     | 0                        | ?                            | ?                 | ?                                   | ?                                   |





    # Initiate Modification for a second time (30697)

    # Change the date - CRM ignores this
    Given the override date is '16/10/2020'

    # Delete Task created by the first Modification Initiation
    And   there are no Tasks in CRM for version '1' of contract 'AEBP-571' with a State of 'Completed' and a Status of 'Completed'

    # Modification Initiation setup
    When  CRM user 'FCS2 TEST' initiates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017571 | AEBP-571      | 1               | 0                  | 10/10/2020               | Inadequate Financial Health     | Ofsted formal warning                   |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate modification request for manager approval via SDK

    # If all ok then Modification Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017571 | AEBP-571       | 1                     | 0                        | 10/10/2020               | 10/10/2020                   | Inadequate Financial Health     | Inadequate Financial Health         |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017571 | AEBP-571      | AEAL-571         | 1                     | 0                        | 10/10/2020                   | 10/10/2020        | Inadequate Financial Health         | Inadequate Financial Health         |
    | 10017571 | AEBP-571      | AEBA-571         | 1                     | 0                        | 10/10/2020                   | 10/10/2020        | Inadequate Financial Health         | Inadequate Financial Health         |
    | 10017571 | AEBP-571      | AEBR-571         | 1                     | 0                        | 10/10/2020                   | 10/10/2020        | Inadequate Financial Health         | Inadequate Financial Health         |
    | 10017571 | AEBP-571      | AETL-571         | 1                     | 0                        | 10/10/2020                   | 10/10/2020        | Inadequate Financial Health         | Inadequate Financial Health         |

    # A Modification Approval Task should have been created
    And   the following Tasks are present against version '1' of contract 'AEBP-571' for provider '10017571'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017571 - 10017571 Co Ltd     | AEBP-571       | Contract Managers Team  | ?                        | Open            | Not Started      |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract 'AEBP-571' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | Contract Managers Team      | Approved          | Awaiting Modification Approval               | FCS2 TEST             | FCS1 TEST                 | Approved       | Approved                                     |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Reject Modification                         | FCS1 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Approved                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-571' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Initiate Contract Modification                 | FCS2 TEST                     | Ofsted formal warning                |
    | Reject Modification                            | FCS1 TEST                     | Technical misunderstanding           |
    | Initiate Contract Modification                 | FCS2 TEST                     | No longer providing training         |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017571 | AEBP-571           | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017571 | ESFA-571           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Authorise Modification (30698)

    # Change the date - CRM ignores this
    Given the override date is '16/10/2020'

    # Complete an existing open Task to approve the Authorise the Modification
    When the following open Task currently linked to version '1' of contract 'AEBP-571' for provider '10017571' is triggered by User 'FCS1 Test'
    | Task                              | Owner                    |
    | Confirm Modification Approval     | Contract Managers Team   |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017571 | AEBP-571           | 1                     | 0                        | Approved         | Modified                                 | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017571 | ESFA-571           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the Task has been marked as completed
    Then  the following Tasks are present against version '1' of contract 'AEBP-571' for provider '10017571'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017571 - 10017571 Co Ltd     | AEBP-571       | Contract Managers Team  | ?                        | Completed       | Completed        |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract 'AEBP-571' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Modification Successful                     | CRM Integration               | FCS2 TEST        | Contract Managers Team      | Approved          | Modified                                     | FCS2 TEST             | Contract Managers Team    | Approved       | Modification Approval in Progress            |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Approve Modification                        | FCS1 TEST                     | FCS2 TEST        | Contract Managers Team      | Approved          | Modification Approval in Progress            | FCS2 TEST             | Contract Managers Team    | Approved       | Awaiting Modification Approval               |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | Contract Managers Team      | Approved          | Awaiting Modification Approval               | FCS2 TEST             | FCS1 TEST                 | Approved       | Approved                                     |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Reject Modification                         | FCS1 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Approved                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-571' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Modification Successful                        | CRM Integration               | ?                                    |
    | Approve Modification                           | FCS1 TEST                     | ?                                    |
    | Initiate Contract Modification                 | FCS2 TEST                     | Ofsted formal warning                |
    | Reject Modification                            | FCS1 TEST                     | Technical misunderstanding           |
    | Initiate Contract Modification                 | FCS2 TEST                     | No longer providing training         |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |

    # Check the contract modification details in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017571 | AEBP-571       | 1                     | 0                        | 10/10/2020               | 10/10/2020                   | Inadequate Financial Health     | Inadequate Financial Health         |

    # ... and the CRM allocation data too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017571 | AEBP-571      | AEAL-571         | 1                     | 0                        | 10/10/2020                   | 10/10/2020        | Inadequate Financial Health         | Inadequate Financial Health         |
    | 10017571 | AEBP-571      | AEBA-571         | 1                     | 0                        | 10/10/2020                   | 10/10/2020        | Inadequate Financial Health         | Inadequate Financial Health         |
    | 10017571 | AEBP-571      | AEBR-571         | 1                     | 0                        | 10/10/2020                   | 10/10/2020        | Inadequate Financial Health         | Inadequate Financial Health         |
    | 10017571 | AEBP-571      | AETL-571         | 1                     | 0                        | 10/10/2020                   | 10/10/2020        | Inadequate Financial Health         | Inadequate Financial Health         |

    # Check the CM feed table for the presence of a 'Contract Modified' entry (ItemType 8)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '8' event for version '1' of actual contract number 'AEBP-571'
    And   the ItemType '8' event for version '1' of actual contract number 'AEBP-571' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                        | CategoryLabel                                | Title                                                  |
    | 10017571 | AEBP-571       | 1               | 0                  | Contract Modified                   | Contract has been modified                   | Contract AEBP-571:1.0 was modified                     |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AEAL-571        | 10/10/2020            | ?                         | Inadequate Financial Health      |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AEBA-571        | 10/10/2020            | ?                         | Inadequate Financial Health      |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AEBR-571        | 10/10/2020            | ?                         | Inadequate Financial Health      |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AETL-571        | 10/10/2020            | ?                         | Inadequate Financial Health      |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                        | CategoryLabel                                | Title                                                  |
    | 10017571 | AEBP-571       | 1               | 0                  | Contract Modified                   | Contract has been modified                   | Contract AEBP-571:1.0 was modified                     |

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AEAL-571        | 10/10/2020            | ?                         | Inadequate Financial Health      |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AEBA-571        | 10/10/2020            | ?                         | Inadequate Financial Health      |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AEBR-571        | 10/10/2020            | ?                         | Inadequate Financial Health      |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AETL-571        | 10/10/2020            | ?                         | Inadequate Financial Health      |
   




    # Update Modification details (30699)

    # Change the date - CRM ignores this
    Given the override date is '22/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Update Modification setup
    When  CRM user 'FCS1 TEST' updates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017571 | AEBP-571      | 1               | 0                  | 15/10/2020               | Removed from RoATP              | Minimum standards not met               |

    # Use the SDK to submit the request
    And   the user issues an update modification request via SDK

    # If all ok then Update Modification proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017571 | AEBP-571       | 1                     | 0                        | 15/10/2020               | 15/10/2020                   | Removed from RoATP              | Removed from RoATP                  |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017571 | AEBP-571      | AEAL-571         | 1                     | 0                        | 15/10/2020                   | 15/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017571 | AEBP-571      | AEBA-571         | 1                     | 0                        | 15/10/2020                   | 15/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017571 | AEBP-571      | AEBR-571         | 1                     | 0                        | 15/10/2020                   | 15/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017571 | AEBP-571      | AETL-571         | 1                     | 0                        | 15/10/2020                   | 15/10/2020        | Removed from RoATP                  | Removed from RoATP                  |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract 'AEBP-571' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Modification Details Update Successful      | CRM Integration               | FCS2 TEST        | Contract Managers Team      | Approved          | Modified                                     | FCS2 TEST             | Contract Managers Team    | Approved       | Modification Details Update in Progress      |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Update Modification Details                 | FCS1 TEST                     | FCS2 TEST        | Contract Managers Team      | Approved          | Modification Details Update in Progress      | FCS2 TEST             | Contract Managers Team    | Approved       | Modified                                     |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Modification Successful                     | CRM Integration               | FCS2 TEST        | Contract Managers Team      | Approved          | Modified                                     | FCS2 TEST             | Contract Managers Team    | Approved       | Modification Approval in Progress            |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Approve Modification                        | FCS1 TEST                     | FCS2 TEST        | Contract Managers Team      | Approved          | Modification Approval in Progress            | FCS2 TEST             | Contract Managers Team    | Approved       | Awaiting Modification Approval               |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | Contract Managers Team      | Approved          | Awaiting Modification Approval               | FCS2 TEST             | FCS1 TEST                 | Approved       | Approved                                     |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Reject Modification                         | FCS1 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Approved                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017571 | ESFA-571           | AEBP-571       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-571' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Modification Details Update Successful         | CRM Integration               | ?                                    |
    | Update Modification Details                    | FCS1 TEST                     | Minimum standards not met            |
    | Modification Successful                        | CRM Integration               | ?                                    |
    | Approve Modification                           | FCS1 TEST                     | ?                                    |
    | Initiate Contract Modification                 | FCS2 TEST                     | Ofsted formal warning                |
    | Reject Modification                            | FCS1 TEST                     | Technical misunderstanding           |
    | Initiate Contract Modification                 | FCS2 TEST                     | No longer providing training         |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |
    
    # Check the CONTRACT version, status and dates in CRM (These should not have changed)
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017571 | AEBP-571           | 1                     | 0                        | Approved         | Modified                                 | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017571 | ESFA-571           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CM feed for the presence of a 'Contract Modification Details Updated' event (ItemType 9)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '9' event for version '1' of actual contract number 'AEBP-571'
    And   the ItemType '9' event for version '1' of actual contract number 'AEBP-571' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                           | CategoryLabel                                          | Title                                                               |
    | 10017571 | AEBP-571       | 1               | 0                  | Contract Modification Details Updated  | Modification details for a contract have been updated  | Modification details for contract AEBP-571:1.0 have been updated    |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modification Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AEAL-571        | 15/10/2020            | ?                         | Removed from RoATP               |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AEBA-571        | 15/10/2020            | ?                         | Removed from RoATP               |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AEBR-571        | 15/10/2020            | ?                         | Removed from RoATP               |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AETL-571        | 15/10/2020            | ?                         | Removed from RoATP               |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                           | CategoryLabel                                          | Title                                                               |
    | 10017571 | AEBP-571       | 1               | 0                  | Contract Modification Details Updated  | Modification details for a contract have been updated  | Modification details for contract AEBP-571:1.0 have been updated    |

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modification Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AEAL-571        | 15/10/2020            | ?                         | Removed from RoATP               |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AEBA-571        | 15/10/2020            | ?                         | Removed from RoATP               |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AEBR-571        | 15/10/2020            | ?                         | Removed from RoATP               |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AETL-571        | 15/10/2020            | ?                         | Removed from RoATP               |





    # Bulk amend to add an allocation (30519)

    # Change the date - CRM ignores this
    Given the override date is '12/11/2020'

    # Bulk file
    And   there are no files prefixed '10017571' in the Sharepoint 'AEB-2021-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 2021 11112020130205 v3_A571' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 2021 11112020130205 v3_A571' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 2021 11112020130205 v3_A571' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 2021 11112020130205 v3_A571' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 2021 11112020130205 v3_A571.xlsx' exists in the Datafiles folder and UKPRN '10017571' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017571' for FundingType 'AEB' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017571' for FundingType 'AEB' and period '2021'

    # Check the CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017571 | AEBP-571           | 2                     | 0                        | Draft            | Awaiting Documentation   | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017571 | AEBP-571           | 1                     | 0                        | Approved         | Modified                 | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017571 | ESFA-571           | 1                     | 0                        | Draft            | ?                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    
    # Contract modification details should not have changed
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017571 | AEBP-571       | 1                     | 0                        | 15/10/2020               | 15/10/2020                   | Removed from RoATP              | Removed from RoATP                  |

    # ... but a new allocation should have been added and given the same dates as other allocs
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason  |
    | 10017571 | AEBP-571      | AEAL-571         | 2                     | 0                        | 15/10/2020                   | 15/10/2020        | Removed from RoATP                  | Removed from RoATP        |
    | 10017571 | AEBP-571      | AEBA-571         | 2                     | 0                        | 15/10/2020                   | 15/10/2020        | Removed from RoATP                  | Removed from RoATP        |
    | 10017571 | AEBP-571      | AEBR-571         | 2                     | 0                        | 15/10/2020                   | 15/10/2020        | Removed from RoATP                  | Removed from RoATP        |
    | 10017571 | AEBP-571      | AETL-571         | 2                     | 0                        | 15/10/2020                   | 15/10/2020        | Removed from RoATP                  | Removed from RoATP        |
    # New alloc for AEB-PRS
    | 10017571 | AEBP-571      | [AllocRef_AERS]  | 2                     | 0                        | 15/10/2020                   | 15/10/2020        | Removed from RoATP                  | Removed from RoATP        |


    # Tidy Up
    And   the override date is reset
  
@AcceptanceTest @Complete
Scenario: A572 Create and approve a 2-alloc Levy contract. Initiate, approve then update Modification. Check CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017572' 
    And   there are no terminated or closed allocations for UKPRN '10017572' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017572' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017572'
    And   there are no notifications in CRM of type 'Contract Modification Rejected' for UKPRN '10017572'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017572' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017572' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017572' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017572' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017572' 
 
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
    | 10017572 | 
 
    # Add the provider to RoATP (ContractManagement.RoATPProvider) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017572 | 10017572 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 
 
 
 
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017572' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017572 Co Ltd' with UKPRN '10017572' and OrgId 'ORG0017572' and has 'FCS1 Test' as a manager 
 
    # Put data in the PaaS Organisation table (Organisation.Organisation) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017572 | 117572 | 10017572 Co Ltd | 0              | Locked Restructure    | Yes           | AA017572      | ?             | 2 Westbourne House     | Wheatlands Estate      | ?                      | ?                      | Heston                 | Middlesex              | TW5 0SA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017572 |

 
 
 
    # Change the date 
    Given the override date is '16/03/2020' 
 
    # Inject data into the stub to create a contract with two allocations 
   #And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation 
    And   the following Levy event data is available in the DAS agreement stub 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 62572 | INITIATED | 2019-12-15T18:03:12.2572 | 10017572   | 28572             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017572' 
    Then  there is only one Levy contract in CRM for UKPRN '10017572' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017572' for FundingType 'LEVY' and period '1799' 
 
 
 
 
 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017572 | 10017572 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017572 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017572 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017572 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017572 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017572 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017572 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017572 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
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
    | 10017572 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017572 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017572 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017572 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017572 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017572 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017572 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017572 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017572 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017572 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017572 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017572 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017572 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017572 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
    # 
    | 10017572 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017572 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017572 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017572 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017572 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017572 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017572 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017572 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017572 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017572 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017572 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017572 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017572 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017572 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 
 
    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017572 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 09/04/2020        | ?               | ?             | 
    | 10017572 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
 
    # Check ALLOCATION dates in CRM 
    And   the following allocation values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | 
    | 10017572 | [ContractNo]       | 1                     | [AllocRef_LEVY]     | 09/04/2020          | ?                 | 
    | 10017572 | [ContractNo]       | 1                     | [AllocRef_NLA]      | 09/04/2020          | ?                 | 
 
 

 

    # Initiate Modification (30697)

    # Change the date - CRM ignores this
    Given the override date is '13/10/2020'

    # Modification Initiation setup
    When  CRM user 'FCS2 TEST' initiates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017572 | [ContractNo]  | 1               | 0                  | 13/10/2020               | Removed from RoATP              | Administrative decision                 |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate modification request for manager approval via SDK

    # If all ok then Modification Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017572 | [ContractNo]   | 1                     | 0                        | 13/10/2020               | 13/10/2020                   | Removed from RoATP              | Removed from RoATP                  |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017572 | [ContractNo]  | [AllocRef_LEVY]  | 1                     | 0                        | 13/10/2020                   | 13/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017572 | [ContractNo]  | [AllocRef_NLA]   | 1                     | 0                        | 13/10/2020                   | 13/10/2020        | Removed from RoATP                  | Removed from RoATP                  |

    # A Modification Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017572'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017572 - 10017572 Co Ltd     | [ContractNo]   | Contract Managers Team  | ?                        | Open            | Not Started      |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017572 | [MasterContractNo] | [ContractNo]   | 1                     | Initiate Contract Modification              | FCS2 TEST                     | ?                | Contract Managers Team      | Approved          | Awaiting Modification Approval               | ?                     | CRM Integration           | Approved       | Approved                                     |
    | 10017572 | [MasterContractNo] | [ContractNo]   | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | ?                | CRM Integration             | Approved          | Approved                                     | ?                     | CRM Integration           | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Initiate Contract Modification                 | FCS2 TEST                     | Administrative decision          |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017572 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017572 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |




    # Authorise Modification (30698)

    # Change the date - CRM ignores this
    Given the override date is '19/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task to Authorise the Modification
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017572' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Modification Approval            | Contract Managers Team    |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017572 | [ContractNo]       | 1                     | 0                        | Approved         | Modified                                 | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017572 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the Task has been marked as completed
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017572'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017572 - 10017572 Co Ltd     | [ContractNo]   | Contract Managers Team  | ?                        | Completed       | Completed        |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017572 | [MasterContractNo] | [ContractNo]   | 1                     | Modification Successful                     | CRM Integration               | ?                | Contract Managers Team      | Approved          | Modified                                     | ?                     | Contract Managers Team    | Approved       | Modification Approval in Progress            |
    | 10017572 | [MasterContractNo] | [ContractNo]   | 1                     | Approve Modification                        | FCS5 TEST                     | ?                | Contract Managers Team      | Approved          | Modification Approval in Progress            | ?                     | Contract Managers Team    | Approved       | Awaiting Modification Approval               |
    | 10017572 | [MasterContractNo] | [ContractNo]   | 1                     | Initiate Contract Modification              | FCS2 TEST                     | ?                | Contract Managers Team      | Approved          | Awaiting Modification Approval               | ?                     | CRM Integration           | Approved       | Approved                                     |
    | 10017572 | [MasterContractNo] | [ContractNo]   | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | ?                | CRM Integration             | Approved          | Approved                                     | ?                     | CRM Integration           | Draft          | Published to Provider                        |
    | 10017572 | [MasterContractNo] | [ContractNo]   | 1                     | Document Published For Digital Sign Off     | CRM Integration               | ?                | CRM Integration             | Draft             | Published to Provider                        | ?                     | CRM Integration           | Draft          | Document Transfer in Progress                |

    # Check the Workflow History comments 
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Modification Successful                        | CRM Integration               | ?                                    |
    | Approve Modification                           | FCS5 TEST                     | ?                                    |
    | Initiate Contract Modification                 | FCS2 TEST                     | Administrative decision              |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |
    | Document Published For Digital Sign Off        | CRM Integration               | ?                                    |

    # Check the contract modification details in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017572 | [ContractNo]   | 1                     | 0                        | 13/10/2020               | 13/10/2020                   | Removed from RoATP              | Removed from RoATP                  |

    # ... and the CRM allocation data too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017572 | [ContractNo]  | [AllocRef_LEVY]  | 1                     | 0                        | 13/10/2020                   | 13/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017572 | [ContractNo]  | [AllocRef_NLA]   | 1                     | 0                        | 13/10/2020                   | 13/10/2020        | Removed from RoATP                  | Removed from RoATP                  |

    # Check the CM feed for the presence of a 'Contract Modified' event (ItemType 8)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '8' event for version '1' of actual contract number '[ContractNo]'
    And   the ItemType '8' event for version '1' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017572 | [ContractNo]   | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract [ContractNo]:1.0 was modified                 |


    # ok up to here


    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017572 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_LEVY] | 13/10/2020            | ?                         | Removed from RoATP               |
    | 10017572 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_NLA]  | 13/10/2020            | ?                         | Removed from RoATP               |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017572 | [ContractNo]   | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract [ContractNo]:1.0 was modified                 |

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017572 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_LEVY] | 13/10/2020            | ?                         | Removed from RoATP               |
    | 10017572 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_NLA]  | 13/10/2020            | ?                         | Removed from RoATP               |





    # Update Modification details (30699)

    # Change the date - CRM ignores this
    Given the override date is '22/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Update Modification setup
    When  CRM user 'FCS1 TEST' updates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017572 | [ContractNo]  | 1               | 0                  | 15/10/2020               | Removed from RoATP              | Administrative decision                 |

    # Use the SDK to submit the request
    And   the user issues an update modification request via SDK

    # If all ok then Update Modification proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017572 | [ContractNo]   | 1                     | 0                        | 15/10/2020               | 15/10/2020                   | Removed from RoATP              | Removed from RoATP                  |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017572 | [ContractNo]  | [AllocRef_LEVY]  | 1                     | 0                        | 15/10/2020                   | 15/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017572 | [ContractNo]  | [AllocRef_NLA]   | 1                     | 0                        | 15/10/2020                   | 15/10/2020        | Removed from RoATP                  | Removed from RoATP                  |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017572 | [MasterContractNo] | [ContractNo]   | 1                     | Modification Details Update Successful      | CRM Integration               | ?                | Contract Managers Team      | Approved          | Modified                                     | ?                     | Contract Managers Team    | Approved       | Modification Details Update in Progress      |
    | 10017572 | [MasterContractNo] | [ContractNo]   | 1                     | Update Modification Details                 | FCS1 TEST                     | ?                | Contract Managers Team      | Approved          | Modification Details Update in Progress      | ?                     | Contract Managers Team    | Approved       | Modified                                     |
    | 10017572 | [MasterContractNo] | [ContractNo]   | 1                     | Modification Successful                     | CRM Integration               | ?                | Contract Managers Team      | Approved          | Modified                                     | ?                     | Contract Managers Team    | Approved       | Modification Approval in Progress            |
    | 10017572 | [MasterContractNo] | [ContractNo]   | 1                     | Approve Modification                        | FCS5 TEST                     | ?                | Contract Managers Team      | Approved          | Modification Approval in Progress            | ?                     | Contract Managers Team    | Approved       | Awaiting Modification Approval               |
    | 10017572 | [MasterContractNo] | [ContractNo]   | 1                     | Initiate Contract Modification              | FCS2 TEST                     | ?                | Contract Managers Team      | Approved          | Awaiting Modification Approval               | ?                     | CRM Integration           | Approved       | Approved                                     |
    | 10017572 | [MasterContractNo] | [ContractNo]   | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | ?                | CRM Integration             | Approved          | Approved                                     | ?                     | CRM Integration           | Draft          | Published to Provider                        |
    | 10017572 | [MasterContractNo] | [ContractNo]   | 1                     | Document Published For Digital Sign Off     | CRM Integration               | ?                | CRM Integration             | Draft             | Published to Provider                        | ?                     | CRM Integration           | Draft          | Document Transfer in Progress                |

    # Check the Workflow History comments 
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Modification Details Update Successful         | CRM Integration               | ?                                    |
    | Update Modification Details                    | FCS1 TEST                     | Administrative decision              |
    | Modification Successful                        | CRM Integration               | ?                                    |
    | Approve Modification                           | FCS5 TEST                     | ?                                    |
    | Initiate Contract Modification                 | FCS2 TEST                     | Administrative decision              |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |
    | Document Published For Digital Sign Off        | CRM Integration               | ?                                    |

    # Check the CONTRACT version, status and dates in CRM (These should not have changed)
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017572 | [ContractNo]       | 1                     | 0                        | Approved         | Modified                                 | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017572 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the CM feed for the presence of a 'Contract Modification Details Updated' event (ItemType 9)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '9' event for version '1' of actual contract number '[ContractNo]'
    And   the ItemType '9' event for version '1' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                           | CategoryLabel                                          | Title                                                               |
    | 10017572 | [ContractNo]   | 1               | 0                  | Contract Modification Details Updated  | Modification details for a contract have been updated  | Modification details for contract [ContractNo]:1.0 have been updated|

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modification Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017572 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_LEVY] | 15/10/2020            | ?                         | Removed from RoATP               |
    | 10017572 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_NLA]  | 15/10/2020            | ?                         | Removed from RoATP               |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                           | CategoryLabel                                          | Title                                                               |
    | 10017572 | [ContractNo]   | 1               | 0                  | Contract Modification Details Updated  | Modification details for a contract have been updated  | Modification details for contract [ContractNo]:1.0 have been updated|

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modification Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017572 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_LEVY] | 15/10/2020            | ?                         | Removed from RoATP               |
    | 10017572 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_NLA]  | 15/10/2020            | ?                         | Removed from RoATP               |





#    # Cancel Authorised Modification (30700)
#
#    # Change the date - CRM ignores this
#    Given the override date is '24/10/2020'
#
#    # Clear down CM feed
#    And   the Contract Management atom feed is empty
#
#    # Manager CANCELS an approved Modification (30700)
#    When  CRM user 'FCS1 Test' cancels the Modification request for Contract '[ContractNo]' Version '1' SubVersion '0' via SDK
#
#    # If all ok then cancellation proceeds and the Modification data will be removed from CRM
#    Then  the following contract modification values are present in CRM
#    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
#    | 10017572 | [ContractNo]   | 1                     | 0                        | ?                        | ?                            | ?                               | ?                                   |
#
#    # ... and the allocation data will have been removed from CRM too
#    And   the following allocation modification values are present in CRM
#    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason  |
#    | 10017572 | [ContractNo]  | [AllocRef_LEVY]  | 1                     | 0                        | ?                            | ?                 | ?                                   | ?                         |
#    | 10017572 | [ContractNo]  | [AllocRef_NLA]   | 1                     | 0                        | ?                            | ?                 | ?                                   | ?                         |
#
#
#    # Check the contents of the Workflow History inc comments
#
#
#    # Check the CONTRACT version, status and dates in CRM
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus   | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10017572 | [ContractNo]       | 1                     | 0                        | Approved         | Approved            | True          | True                | 09/04/2020        | ?               | ?             |
#    | 10017572 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                   | False         | False               | 01/05/2017        | ?               | ?             |
#
#    # Check the CM feed for the presence of a 'Contract Modification Cancelled' event (ItemType 10)
#    Then  the ContractManagement.AtomFeedItem table contains one ItemType '10' event for version '1' of actual contract number '[ContractNo]'
#    And   the ItemType '10' event for version '1' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
#
#    # ALLCONTRACT
#
#    # Check the CM feed table event header information
#    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
#    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                      | CategoryLabel                                  | Title                                                    |
#    | 10017572 | [ContractNo]   | 1               | 0                  | Contract Modification Cancelled   | Modification of a contract has been cancelled  | Modification of contract [ContractNo]:1.0 was cancelled  |
#
#    # Check the CM feed event data
#    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modification Details Updated' event details as follows
#    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason  | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason |
#    | 10017572 | [ContractNo]   | 1               | 0                  | ?                       | ?                          | [AllocRef_LEVY] | ?                     | ?                         | ?                        |
#    | 10017572 | [ContractNo]   | 1               | 0                  | ?                       | ?                          | [AllocRef_NLA]  | ?                     | ?                         | ?                        |
#
#    # APPROVALONWARDSCONTRACT
#
#    # Check the CM feed table event header information
#    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
#    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                      | CategoryLabel                                  | Title                                                    |
#    | 10017572 | [ContractNo]   | 1               | 0                  | Contract Modification Cancelled   | Modification of a contract has been cancelled  | Modification of contract [ContractNo]:1.0 was cancelled  |
#
#    # Check the CM feed event data
#    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modification Details Updated' event details as follows
#    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason  | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason |
#    | 10017572 | [ContractNo]   | 1               | 0                  | ?                       | ?                          | [AllocRef_LEVY] | ?                     | ?                         | ?                        |
#    | 10017572 | [ContractNo]   | 1               | 0                  | ?                       | ?                          | [AllocRef_NLA]  | ?                     | ?                         | ?                        |


    # Tidy Up
    And   the override date is reset
    
@AcceptanceTest @Withdrawn20231002
Scenario: A573 Create and approve a 3-alloc 2021 EDSK contract with 2 Delivery Orgs. Initiate, approve then update Modification. Check CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017573' 
    And   there are no terminated or closed allocations for UKPRN '10017573' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017573' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017573'
    And   there are no notifications in CRM of type 'Contract Modification Rejected' for UKPRN '10017573'
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017573' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-5731     |
    | AECS-5731     |
    | AECT-5731     |
    | 16TR-5732     |
    | AECS-5732     |
    | AECT-5732     |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-5731     |
    | AECS-5731     |
    | AECT-5731     |
    | 16TR-5732     |
    | AECS-5732     |
    | AECT-5732     |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2021      |
    | AEBC-19TRN2021    |
    | AEBC-CSO2021      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-573       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017573'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017573' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017573 Co Ltd' with UKPRN '10017573' and OrgId 'ORG0017573' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017573' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status  | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017573 | 117573 | 10017573 Co Ltd | 0              | Active  | Yes           | AA017573      | ?             | 27 Sandyford Place     | Glasgow                | ?                      | ?                      | ?                      | ?                      | G3 7NG    |
    | 10000527 | 100527 | 10000527 Co Ltd | 0              | Active  | Yes           | AA000527      | ?             | March Buildings North  | 8 Brook Street         | High Street North      | Ledsham                | Ellesmere Port         | Merseyside             | CH66 4TT  |
    | 10000528 | 100528 | 10000528 Co Ltd | 0              | Active  | Yes           | AA000528      | ?             | March Buildings South  | 8 Brook Street         | High Street North      | Ledsham                | Ellesmere Port         | Merseyside             | CH66 4TT  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017573 |
    | 10000527 |
    | 10000528 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017573 | 10017573 Co Ltd      | ESFA-573             | EDSK-573       | 1                     | 01/08/2020        | 31/07/2021      | 104446.00     |                                       | Conditions of Funding (Grant) (Trust)      | 2021   | New          | ORG0017573 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName     | UoPCode    | AllocationDescription    | CRMIntent    | DeliveryOrg |
    | 10017573 | EDSK-573       | 16TR-5731     | 16-18TRN          | 16-18TRN2021            | AY                      | 01/08/2020          | 31/07/2021        | 55076.00        |             |            |                          | New          | 10000527    |
    | 10017573 | EDSK-573       | AECS-5731     | AEBC-CSO          | AEBC-CSO2021            | AY                      | 01/08/2020          | 31/07/2021        | 26175.00        |             |            |                          | New          | 10000527    |
    | 10017573 | EDSK-573       | AECT-5731     | AEBC-19TRN        | AEBC-19TRN2021          | AY                      | 01/08/2020          | 31/07/2021        | 23195.00        |             |            |                          | New          | 10000527    |
    #
    | 10017573 | EDSK-573       | 16TR-5732     | 16-18TRN          | 16-18TRN2021            | AY                      | 01/08/2020          | 31/07/2021        | 46399.00        |             |            |                          | New          | 10000528    |
    | 10017573 | EDSK-573       | AECS-5732     | AEBC-CSO          | AEBC-CSO2021            | AY                      | 01/08/2020          | 31/07/2021        | 25338.00        |             |            |                          | New          | 10000528    |
    | 10017573 | EDSK-573       | AECT-5732     | AEBC-19TRN        | AEBC-19TRN2021          | AY                      | 01/08/2020          | 31/07/2021        | 26619.00        |             |            |                          | New          | 10000528    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017573 | EDSK-573       | 16TR-5731     | 1               | 0                     | 55076.00  | 37014.00  | 18062.00  | 4690.00  | 6128.00  | 4532.00  | 3884.00  | 3109.00  | 4452.00  | 4121.00  | 6098.00  | 2886.00  | 4136.00  | 5070.00  | 5970.00  | Total 16-18 Traineeships Funding                                | New          | 10000527    | 
    | 10017573 | EDSK-573       | 16TR-5731     | 2               | 1                     | 25584.00  | 16173.00  | 9411.00   | 1749.00  | 3464.00  | 1037.00  | 2880.00  | 1052.00  | 1852.00  | 1417.00  | 2722.00  | 1526.00  | 3147.00  | 1986.00  | 2752.00  | 16-18 Traineeships Programme Funding                            | New          | 10000527    | 
    | 10017573 | EDSK-573       | 16TR-5731     | 3               | 1                     | 29492.00  | 20841.00  | 8651.00   | 2941.00  | 2664.00  | 3495.00  | 1004.00  | 2057.00  | 2600.00  | 2704.00  | 3376.00  | 1360.00  | 989.00   | 3084.00  | 3218.00  | 16-18 Traineeships Bursary Funding                              | New          | 10000527    | 
    | 10017573 | EDSK-573       | AECS-5731     | 1               | 0                     | 26175.00  | 16817.00  | 9358.00   | 2707.00  | 3157.00  | 825.00   | 1403.00  | 652.00   | 2905.00  | 2564.00  | 2604.00  | 2485.00  | 2841.00  | 1774.00  | 2258.00  | COVID-19 Skills Offer Total Funding                             | New          | 10000527    | 
    | 10017573 | EDSK-573       | AECS-5731     | 2               | 1                     | 26175.00  | 16817.00  | 9358.00   | 2707.00  | 3157.00  | 825.00   | 1403.00  | 652.00   | 2905.00  | 2564.00  | 2604.00  | 2485.00  | 2841.00  | 1774.00  | 2258.00  | High Value Courses for School and College Leavers Funding       | New          | 10000527    | 
    | 10017573 | EDSK-573       | AECT-5731     | 1               | 0                     | 23195.00  | 18860.00  | 4335.00   | 2892.00  | 368.00   | 2275.00  | 2220.00  | 3367.00  | 2645.00  | 2843.00  | 2250.00  | 328.00   | 2393.00  | 881.00   | 733.00   | 19-24 Traineeships Total Funding                                | New          | 10000527    | 
    #
    | 10017573 | EDSK-573       | 16TR-5732     | 1               | 0                     | 46399.00  | 34275.00  | 12124.00  | 3885.00  | 3964.00  | 3727.00  | 4439.00  | 2303.00  | 5990.00  | 7017.00  | 2950.00  | 5782.00  | 1973.00  | 564.00   | 3805.00  | Total 16-18 Traineeships Funding                                | New          | 10000528    | 
    | 10017573 | EDSK-573       | 16TR-5732     | 2               | 1                     | 20932.00  | 15462.00  | 5470.00   | 1291.00  | 1459.00  | 2922.00  | 1252.00  | 1577.00  | 2566.00  | 3302.00  | 1093.00  | 2052.00  | 1143.00  | 169.00   | 2106.00  | 16-18 Traineeships Programme Funding                            | New          | 10000528    | 
    | 10017573 | EDSK-573       | 16TR-5732     | 3               | 1                     | 25467.00  | 18813.00  | 6654.00   | 2594.00  | 2505.00  | 805.00   | 3187.00  | 726.00   | 3424.00  | 3715.00  | 1857.00  | 3730.00  | 830.00   | 395.00   | 1699.00  | 16-18 Traineeships Bursary Funding                              | New          | 10000528    | 
    | 10017573 | EDSK-573       | AECS-5732     | 1               | 0                     | 25338.00  | 16259.00  | 9079.00   | 1618.00  | 3239.00  | 1095.00  | 2844.00  | 2281.00  | 2004.00  | 2834.00  | 344.00   | 1396.00  | 2923.00  | 2044.00  | 2716.00  | COVID-19 Skills Offer Total Funding                             | New          | 10000528    | 
    | 10017573 | EDSK-573       | AECS-5732     | 2               | 1                     | 25338.00  | 16259.00  | 9079.00   | 1618.00  | 3239.00  | 1095.00  | 2844.00  | 2281.00  | 2004.00  | 2834.00  | 344.00   | 1396.00  | 2923.00  | 2044.00  | 2716.00  | High Value Courses for School and College Leavers Funding       | New          | 10000528    | 
    | 10017573 | EDSK-573       | AECT-5732     | 1               | 0                     | 26619.00  | 17692.00  | 8927.00   | 1792.00  | 1421.00  | 3517.00  | 3650.00  | 2267.00  | 3699.00  | 384.00   | 962.00   | 211.00   | 2464.00  | 3106.00  | 3146.00  | 19-24 Traineeships Total Funding                                | New          | 10000528    | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-573       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-573' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-573'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-573' and actual ContractNumber 'EDSK-573'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-573' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017573 | EDSK-573           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017573 | ESFA-573           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '240' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '240' deliverable period rows in CRM linked to the latest version of contract 'EDSK-573'

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    And   the Legal Contract CM feed contains the following '12' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                             | DeliverableDescription      | 
    | 10017573 | EDSK-573       | 1               | 16TR-5731     | 1               | 0                     | 55076.00     | 0             | 0        | Total 16-18 Traineeships Funding                            | ?                           |
    | 10017573 | EDSK-573       | 1               | 16TR-5731     | 2               | 1                     | 25584.00     | 0             | 0        | 16-18 Traineeships Programme Funding                        | ?                           |
    | 10017573 | EDSK-573       | 1               | 16TR-5731     | 3               | 1                     | 29492.00     | 0             | 0        | 16-18 Traineeships Bursary Funding                          | ?                           |
    | 10017573 | EDSK-573       | 1               | AECS-5731     | 1               | 0                     | 26175.00     | 0             | 0        | COVID-19 Skills Offer Total Funding                         | ?                           |
    | 10017573 | EDSK-573       | 1               | AECS-5731     | 2               | 1                     | 26175.00     | 0             | 0        | High Value Courses for School and College Leavers Funding   | ?                           |
    | 10017573 | EDSK-573       | 1               | AECT-5731     | 1               | 0                     | 23195.00     | 0             | 0        | 19-24 Traineeships Total Funding                            | ?                           |
    #
    | 10017573 | EDSK-573       | 1               | 16TR-5732     | 1               | 0                     | 46399.00     | 0             | 0        | Total 16-18 Traineeships Funding                            | ?                           |
    | 10017573 | EDSK-573       | 1               | 16TR-5732     | 2               | 1                     | 20932.00     | 0             | 0        | 16-18 Traineeships Programme Funding                        | ?                           |
    | 10017573 | EDSK-573       | 1               | 16TR-5732     | 3               | 1                     | 25467.00     | 0             | 0        | 16-18 Traineeships Bursary Funding                          | ?                           |
    | 10017573 | EDSK-573       | 1               | AECS-5732     | 1               | 0                     | 25338.00     | 0             | 0        | COVID-19 Skills Offer Total Funding                         | ?                           |
    | 10017573 | EDSK-573       | 1               | AECS-5732     | 2               | 1                     | 25338.00     | 0             | 0        | High Value Courses for School and College Leavers Funding   | ?                           |
    | 10017573 | EDSK-573       | 1               | AECT-5732     | 1               | 0                     | 26619.00     | 0             | 0        | 19-24 Traineeships Total Funding                            | ?                           |





    # Initiate Modification (30697)

    # Change the date - CRM ignores this
    Given the override date is '13/10/2020'

    # Modification Initiation setup
    When  CRM user 'FCS2 TEST' initiates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017573 | EDSK-573      | 1               | 0                  | 13/10/2020               | Removed from RoATP              | ?                                       |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate modification request for manager approval via SDK

    # If all ok then Modification Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017573 | EDSK-573       | 1                     | 0                        | 13/10/2020               | 13/10/2020                   | Removed from RoATP              | Removed from RoATP                  |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017573 | EDSK-573      | 16TR-5731        | 1                     | 0                        | 13/10/2020                   | 13/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017573 | EDSK-573      | AECS-5731        | 1                     | 0                        | 13/10/2020                   | 13/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017573 | EDSK-573      | AECT-5731        | 1                     | 0                        | 13/10/2020                   | 13/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    #
    | 10017573 | EDSK-573      | 16TR-5732        | 1                     | 0                        | 13/10/2020                   | 13/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017573 | EDSK-573      | AECS-5732        | 1                     | 0                        | 13/10/2020                   | 13/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017573 | EDSK-573      | AECT-5732        | 1                     | 0                        | 13/10/2020                   | 13/10/2020        | Removed from RoATP                  | Removed from RoATP                  |

    # A Modification Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract 'EDSK-573' for provider '10017573'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017573 - 10017573 Co Ltd     | EDSK-573       | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'EDSK-573' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017573 | ESFA-573           | EDSK-573       | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017573 | ESFA-573           | EDSK-573       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'EDSK-573' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Initiate Contract Modification                 | FCS2 TEST                     | ?                                |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017573 | EDSK-573           | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017573 | ESFA-573           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |




    # Authorise Modification (30698)

    # Change the date - CRM ignores this
    Given the override date is '16/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task to Authorise the Modification
    When the following open Task currently linked to version '1' of contract 'EDSK-573' for provider '10017573' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Modification Approval            | FCS1 TEST                 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017573 | EDSK-573           | 1                     | 0                        | Approved         | Modified                                 | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017573 | ESFA-573           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the Task has been marked as completed
    Then  the following Tasks are present against version '1' of contract 'EDSK-573' for provider '10017573'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017573 - 10017573 Co Ltd     | EDSK-573       | FCS1 TEST               | Contract Managers Team   | Completed       | Completed        |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract 'EDSK-573' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017573 | ESFA-573           | EDSK-573       | 1                     | Modification Successful                     | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Modification Approval in Progress            |
    | 10017573 | ESFA-573           | EDSK-573       | 1                     | Approve Modification                        | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Modification Approval in Progress            | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017573 | ESFA-573           | EDSK-573       | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017573 | ESFA-573           | EDSK-573       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'EDSK-573' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Modification Successful                        | CRM Integration               | ?                                    |
    | Approve Modification                           | FCS5 TEST                     | ?                                    |
    | Initiate Contract Modification                 | FCS2 TEST                     | ?                                    |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |

    # Check the contract modification details in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017573 | EDSK-573       | 1                     | 0                        | 13/10/2020               | 13/10/2020                   | Removed from RoATP              | Removed from RoATP                  |

    # ... and the CRM allocation data too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017573 | EDSK-573      | 16TR-5731        | 1                     | 0                        | 13/10/2020                   | 13/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017573 | EDSK-573      | AECS-5731        | 1                     | 0                        | 13/10/2020                   | 13/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017573 | EDSK-573      | AECT-5731        | 1                     | 0                        | 13/10/2020                   | 13/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    #
    | 10017573 | EDSK-573      | 16TR-5732        | 1                     | 0                        | 13/10/2020                   | 13/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017573 | EDSK-573      | AECS-5732        | 1                     | 0                        | 13/10/2020                   | 13/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017573 | EDSK-573      | AECT-5732        | 1                     | 0                        | 13/10/2020                   | 13/10/2020        | Removed from RoATP                  | Removed from RoATP                  |

    # Check the CM feed for the presence of a 'Contract Modified' event (ItemType 8)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '8' event for version '1' of actual contract number 'EDSK-573'
    And   the ItemType '8' event for version '1' of actual contract number 'EDSK-573' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017573 | EDSK-573       | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract EDSK-573:1.0 was modified                     |


    # ok up to here


    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | 16TR-5731       | 13/10/2020            | ?                         | Removed from RoATP               |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | AECS-5731       | 13/10/2020            | ?                         | Removed from RoATP               |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | AECT-5731       | 13/10/2020            | ?                         | Removed from RoATP               |
    #
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | 16TR-5732       | 13/10/2020            | ?                         | Removed from RoATP               |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | AECS-5732       | 13/10/2020            | ?                         | Removed from RoATP               |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | AECT-5732       | 13/10/2020            | ?                         | Removed from RoATP               |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017573 | EDSK-573       | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract EDSK-573:1.0 was modified                     |

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | 16TR-5731       | 13/10/2020            | ?                         | Removed from RoATP               |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | AECS-5731       | 13/10/2020            | ?                         | Removed from RoATP               |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | AECT-5731       | 13/10/2020            | ?                         | Removed from RoATP               |
    #
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | 16TR-5732       | 13/10/2020            | ?                         | Removed from RoATP               |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | AECS-5732       | 13/10/2020            | ?                         | Removed from RoATP               |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | AECT-5732       | 13/10/2020            | ?                         | Removed from RoATP               |





    # Update Modification details (30699)

    # Change the date - CRM ignores this
    Given the override date is '22/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Update Modification setup
    When  CRM user 'FCS1 TEST' updates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017573 | EDSK-573      | 1               | 0                  | 15/10/2020               | Other                           | Withdrawing from sector                 |

    # Use the SDK to submit the request
    And   the user issues an update modification request via SDK

    # If all ok then Update Modification proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017573 | EDSK-573       | 1                     | 0                        | 15/10/2020               | 15/10/2020                   | Other                           | Other                               |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017573 | EDSK-573      | 16TR-5731        | 1                     | 0                        | 15/10/2020                   | 15/10/2020        | Other                               | Other                               |
    | 10017573 | EDSK-573      | AECS-5731        | 1                     | 0                        | 15/10/2020                   | 15/10/2020        | Other                               | Other                               |
    | 10017573 | EDSK-573      | AECT-5731        | 1                     | 0                        | 15/10/2020                   | 15/10/2020        | Other                               | Other                               |
    #
    | 10017573 | EDSK-573      | 16TR-5732        | 1                     | 0                        | 15/10/2020                   | 15/10/2020        | Other                               | Other                               |
    | 10017573 | EDSK-573      | AECS-5732        | 1                     | 0                        | 15/10/2020                   | 15/10/2020        | Other                               | Other                               |
    | 10017573 | EDSK-573      | AECT-5732        | 1                     | 0                        | 15/10/2020                   | 15/10/2020        | Other                               | Other                               |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract 'EDSK-573' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017573 | ESFA-573           | EDSK-573       | 1                     | Modification Details Update Successful      | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Modification Details Update in Progress      |
    | 10017573 | ESFA-573           | EDSK-573       | 1                     | Update Modification Details                 | FCS1 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Modification Details Update in Progress      | FCS2 TEST             | FCS1 TEST                 | Approved       | Modified                                     |
    | 10017573 | ESFA-573           | EDSK-573       | 1                     | Modification Successful                     | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Modification Approval in Progress            |
    | 10017573 | ESFA-573           | EDSK-573       | 1                     | Approve Modification                        | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Modification Approval in Progress            | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017573 | ESFA-573           | EDSK-573       | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017573 | ESFA-573           | EDSK-573       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'EDSK-573' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Modification Details Update Successful         | CRM Integration               | ?                                    |
    | Update Modification Details                    | FCS1 TEST                     | Withdrawing from sector              |
    | Modification Successful                        | CRM Integration               | ?                                    |
    | Approve Modification                           | FCS5 TEST                     | ?                                    |
    | Initiate Contract Modification                 | FCS2 TEST                     | ?                                    |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |

    # Check the CONTRACT version, status and dates in CRM (These should not have changed)
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017573 | EDSK-573           | 1                     | 0                        | Approved         | Modified                                 | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017573 | ESFA-573           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the CM feed for the presence of a 'Contract Modification Details Updated' event (ItemType 9)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '9' event for version '1' of actual contract number 'EDSK-573'
    And   the ItemType '9' event for version '1' of actual contract number 'EDSK-573' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                           | CategoryLabel                                          | Title                                                               |
    | 10017573 | EDSK-573       | 1               | 0                  | Contract Modification Details Updated  | Modification details for a contract have been updated  | Modification details for contract EDSK-573:1.0 have been updated    |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modification Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | 16TR-5731       | 15/10/2020            | ?                         | Other                            |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | AECS-5731       | 15/10/2020            | ?                         | Other                            |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | AECT-5731       | 15/10/2020            | ?                         | Other                            |
    #
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | 16TR-5732       | 15/10/2020            | ?                         | Other                            |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | AECS-5732       | 15/10/2020            | ?                         | Other                            |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | AECT-5732       | 15/10/2020            | ?                         | Other                            |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                           | CategoryLabel                                          | Title                                                               |
    | 10017573 | EDSK-573       | 1               | 0                  | Contract Modification Details Updated  | Modification details for a contract have been updated  | Modification details for contract EDSK-573:1.0 have been updated    |

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modification Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | 16TR-5731       | 15/10/2020            | ?                         | Other                            |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | AECS-5731       | 15/10/2020            | ?                         | Other                            |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | AECT-5731       | 15/10/2020            | ?                         | Other                            |
    #
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | 16TR-5732       | 15/10/2020            | ?                         | Other                            |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | AECS-5732       | 15/10/2020            | ?                         | Other                            |
    | 10017573 | EDSK-573       | 1               | 0                  | ?                       | ?                               | AECT-5732       | 15/10/2020            | ?                         | Other                            |


    # Tidy Up
    And   the override date is reset 
   
@AcceptanceTest @Withdrawn20231002
Scenario: A574 Create and approve a 16-18FU2021 contract. Initiate, approve then update Modification. Check CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017574' 
    And   there are no terminated or closed allocations for UKPRN '10017574' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017574' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017574' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017574' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16FU-574      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16FU-574      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18FU2021       |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | 1618FU-574     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017574'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017574' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017574 Co Ltd' with UKPRN '10017574' and OrgId 'ORG0017574' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017574' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017574 | 117574 | 10017574 Co Ltd | 0              | In Administration     | Yes           | AA017574      | ?             | 3 Egremont Street      | ?                      | ?                      | ?                      | Ely                    | Cambridge              | CB6 1AE   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017574 |




    # Change the date
    Given the override date is '01/03/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017574 | 10017574 Co Ltd      | ESFA-574             | 1618FU-574     | 1                     | 01/04/2020        | 31/03/2021      | 9068.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017574 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017574 | 1618FU-574     | 16FU-574      | 16-18FU           | 16-18FU2021             | FY                      | 01/04/2020          | 31/03/2021        | 9068.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017574 | 1618FU-574     | 16FU-574      | 1               | 0                     | 9068.00   | 0.00     | 0.00     | 88.00    | 0.00     | 0.00     | 3102.00  | 0.00     | 0.00     | 2445.00  | 0.00     | 0.00     | 3433.00  | 16-18 Education at an Adolescent Forensic Unit                  | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 1618FU-574     | 1                     | 0                        | 2020-03-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract '1618FU-574' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '1618FU-574'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-574' and actual ContractNumber '1618FU-574'

    # Check that the contract is now approved
    Then  the latest version of contract '1618FU-574' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017574 | 1618FU-574         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017574 | ESFA-574           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract '1618FU-574'

#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | 16FU-574        | 2430670          | Mar-21 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    And   the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                             | DeliverableDescription                                      | 
    | 10017574 | 1618FU-574     | 1               | 16FU-574      | 1               | 0                     | 9068.00      | 0             | 0        | 16-18 Education at an Adolescent Forensic Unit              | ?                                                           |





    # Initiate Modification (30697)

    # Change the date - CRM ignores this
    Given the override date is '19/10/2020'

    # Modification Initiation setup
    When  CRM user 'FCS2 TEST' initiates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017574 | 1618FU-574    | 1               | 0                  | 14/10/2020               | Other                           | Administrative decision                 |
   
    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate modification request for manager approval via SDK

    # If all ok then Modification Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017574 | 1618FU-574     | 1                     | 0                        | 14/10/2020               | 14/10/2020                   | Other                           | Other                               |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017574 | 1618FU-574    | 16FU-574         | 1                     | 0                        | 14/10/2020                   | 14/10/2020        | Other                               | Other                               |

    # A Modification Approval Task should have been created
    And   the following Tasks are present against version '1' of contract '1618FU-574' for provider '10017574'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017574 - 10017574 Co Ltd     | 1618FU-574     | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract '1618FU-574' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017574 | ESFA-574           | 1618FU-574     | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017574 | ESFA-574           | 1618FU-574     | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract '1618FU-574' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Initiate Contract Modification                 | FCS2 TEST                     | Administrative decision              |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017574 | 1618FU-574         | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017574 | ESFA-574           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |





    # Authorise Modification (30698)

    # Change the date - CRM ignores this
    Given the override date is '21/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task to Authorise the Modification
    When the following open Task currently linked to version '1' of contract '1618FU-574' for provider '10017574' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Modification Approval            | FCS1 TEST                 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017574 | 1618FU-574         | 1                     | 0                        | Approved         | Modified                                 | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017574 | ESFA-574           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the Task has been marked as completed
    Then  the following Tasks are present against version '1' of contract '1618FU-574' for provider '10017574'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017574 - 10017574 Co Ltd     | 1618FU-574     | FCS1 TEST               | Contract Managers Team   | Completed       | Completed        |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract '1618FU-574' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017574 | ESFA-574           | 1618FU-574     | 1                     | Modification Successful                     | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Modification Approval in Progress            |
    | 10017574 | ESFA-574           | 1618FU-574     | 1                     | Approve Modification                        | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Modification Approval in Progress            | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017574 | ESFA-574           | 1618FU-574     | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017574 | ESFA-574           | 1618FU-574     | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract '1618FU-574' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Modification Successful                        | CRM Integration               | ?                                    |
    | Approve Modification                           | FCS5 TEST                     | ?                                    |
    | Initiate Contract Modification                 | FCS2 TEST                     | Administrative decision              |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |

    # Check the contract modification details in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017574 | 1618FU-574     | 1                     | 0                        | 14/10/2020               | 14/10/2020                   | Other                           | Other                               |

    # ... and the CRM allocation data too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017574 | 1618FU-574    | 16FU-574         | 1                     | 0                        | 14/10/2020                   | 14/10/2020        | Other                               | Other                               |

    # Check the CM feed for the presence of a 'Contract Modified' event (ItemType 8)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '8' event for version '1' of actual contract number '1618FU-574'
    And   the ItemType '8' event for version '1' of actual contract number '1618FU-574' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017574 | 1618FU-574     | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract 1618FU-574:1.0 was modified                   |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017574 | 1618FU-574     | 1               | 0                  | ?                       | ?                               | 16FU-574        | 14/10/2020            | ?                         | Other                            |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017574 | 1618FU-574     | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract 1618FU-574:1.0 was modified                   |

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017574 | 1618FU-574     | 1               | 0                  | ?                       | ?                               | 16FU-574        | 14/10/2020            | ?                         | Other                            |





    # Update Modification details (30699)

    Given the override date is '24/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Update Modification setup
    When  CRM user 'FCS1 TEST' updates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017574 | 1618FU-574    | 1               | 0                  | 28/10/2020               | Inadequate Financial Health     | Reassessment of circumstances           |

    # Use the SDK to submit the request
    And   the user issues an update modification request via SDK

    # If all ok then Update Modification proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017574 | 1618FU-574     | 1                     | 0                        | 28/10/2020               | 28/10/2020                   | Inadequate Financial Health     | Inadequate Financial Health         |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017574 | 1618FU-574    | 16FU-574         | 1                     | 0                        | 28/10/2020                   | 28/10/2020        | Inadequate Financial Health         | Inadequate Financial Health         |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract '1618FU-574' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017574 | ESFA-574           | 1618FU-574     | 1                     | Modification Details Update Successful      | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Modification Details Update in Progress      |
    | 10017574 | ESFA-574           | 1618FU-574     | 1                     | Update Modification Details                 | FCS1 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Modification Details Update in Progress      | FCS2 TEST             | FCS1 TEST                 | Approved       | Modified                                     |
    | 10017574 | ESFA-574           | 1618FU-574     | 1                     | Modification Successful                     | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Modification Approval in Progress            |
    | 10017574 | ESFA-574           | 1618FU-574     | 1                     | Approve Modification                        | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Modification Approval in Progress            | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017574 | ESFA-574           | 1618FU-574     | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017574 | ESFA-574           | 1618FU-574     | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract '1618FU-574' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Modification Details Update Successful         | CRM Integration               | ?                                    |
    | Update Modification Details                    | FCS1 TEST                     | Reassessment of circumstances        |
    | Modification Successful                        | CRM Integration               | ?                                    |
    | Approve Modification                           | FCS5 TEST                     | ?                                    |
    | Initiate Contract Modification                 | FCS2 TEST                     | Administrative decision              |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |

    # Check the CONTRACT version, status and dates in CRM (These should not have changed)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017574 | 1618FU-574         | 1                     | 0                        | Approved         | Modified                                 | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017574 | ESFA-574           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the CM feed for the presence of a 'Contract Modification Details Updated' event (ItemType 9)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '9' event for version '1' of actual contract number '1618FU-574'
    And   the ItemType '9' event for version '1' of actual contract number '1618FU-574' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                           | CategoryLabel                                          | Title                                                               |
    | 10017574 | 1618FU-574     | 1               | 0                  | Contract Modification Details Updated  | Modification details for a contract have been updated  | Modification details for contract 1618FU-574:1.0 have been updated  |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modification Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017574 | 1618FU-574     | 1               | 0                  | ?                       | ?                               | 16FU-574        | 28/10/2020            | ?                         | Inadequate Financial Health      |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                           | CategoryLabel                                          | Title                                                               |
    | 10017574 | 1618FU-574     | 1               | 0                  | Contract Modification Details Updated  | Modification details for a contract have been updated  | Modification details for contract 1618FU-574:1.0 have been updated  |

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modification Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017574 | 1618FU-574     | 1               | 0                  | ?                       | ?                               | 16FU-574        | 28/10/2020            | ?                         | Inadequate Financial Health      |


    # Tidy Up
    And   the override date is reset

