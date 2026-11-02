Feature: ContractAmendmentsDuringModification 30567

@AcceptanceTest @Withdrawn20231002
Scenario: A575 Create and approve a DADA2021 contract. Initiate Modification. NFA fail. Approve Modification. NFA success. Approve. Cancel authorised Modification. Check CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017575' 
    And   there are no terminated or closed allocations for UKPRN '10017575' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017575' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017575' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017575' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | DADA-575      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | DADA-575      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | DADA2021          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | DADAS-575      | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017575'

    # Set the base timestamp for each of the 6 DADA document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_DADA_2020-08-01.docx                        | 2020-05-20 10:00:00.000 | 
    | DADA2020_TAC_2020-08-01.docx                    | 2020-05-20 10:00:00.000 | 
    | DADA2021_S1_2020-08-01.docx                     | 2020-05-20 10:00:00.000 | 
    | DADA2020_S2_2020-08-01.docx                     | 2020-05-20 10:00:00.000 | 
    | FA_DADA2021_2020-08-01.docx                     | 2020-05-20 10:00:00.000 | 
    | DADA2020_S3ON_2020-08-01.docx                   | 2020-05-20 10:00:00.000 | 




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017575' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017575 Co Ltd' with UKPRN '10017575' and OrgId 'ORG0017575' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017575' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017575 | 117575 | 10017575 Co Ltd | 0              | Active                | Yes           | AA017575      | ?             | 35 Mosbach Gardens     | Hutton                 | ?                      | ?                      | Brentwood              | Essex                  | CM13 2UW  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017575 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017575 | 10017575 Co Ltd      | ESFA-575             | DADAS-575      | 1                     | 01/08/2020        | 31/07/2021      | 5215.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017575 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017575 | DADAS-575      | DADA-575      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 5215.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017575 | DADAS-575      | DADA-575      | 1               | 0                     | 5215.00   | 2951.00   | 2264.00   | 0.00     | 2951.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2264.00  | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | DADAS-575      | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'DADAS-575' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'DADAS-575'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-575' and actual ContractNumber 'DADAS-575'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-575' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017575 | DADAS-575          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017575 | ESFA-575           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'DADAS-575'

#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | DADA-575        | 2207010          | Jul-21 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                 | DeliverableDescription  | 
    | 10017575 | DADAS-575      | 1               | DADA-575      | 1               | 0                     | 5215.00      | 0             | 0        | Dance and Drama Awards Scheme   | ?                       |





    # Initiate Modification (30697)

    # Change the date - CRM ignores this
    Given the override date is '21/10/2020'

    # Modification Initiation setup
    When  CRM user 'FCS2 TEST' initiates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017575 | DADAS-575     | 1               | 0                  | 16/10/2020               | Removed from RoATP              | Reassessment of circumstances           |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate modification request for manager approval via SDK

    # If all ok then Modification Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017575 | DADAS-575      | 1                     | 0                        | 16/10/2020               | 16/10/2020                   | Removed from RoATP              | Removed from RoATP                  |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017575 | DADAS-575     | DADA-575         | 1                     | 0                        | 16/10/2020                   | 16/10/2020        | Removed from RoATP                  | Removed from RoATP                  |

    # A Modification Approval Task should have been created
    And   the following Tasks are present against version '1' of contract 'DADAS-575' for provider '10017575'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017575 - 10017575 Co Ltd     | DADAS-575      | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017575 | DADAS-575          | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017575 | ESFA-575           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Unsuccessfully execute a NON-FINANCIAL amendment (30567)

    # Change the date
    Given the override date is '02/11/2020'

    # Delete Notification
    And   there are no notifications in CRM of type 'Non-Financial Contract Amendment Failed' for UKPRN '10017575'

    # Issue a non-financial VARIATION amendment on v1 to create v2. This should fail
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'DADAS-575' for a non-financial VARIATION contract amendment

    # NFA fails. Check that a notification has been created
    Then  there is '1' notification of type 'Non-Financial Contract Amendment Failed' owned by user 'FCS2 TEST' which matches the following 
    | Status | NotificationName                                    | NotificationText                                                                                                                                                                               |
    | New    | Non-Financial Contract Amendment Failed - DADAS-575 | Contract DADAS-575 v1 for provider 10017575 (10017575 Co Ltd) cannot be amended - It must be in a status of "Approved" and a substatus of either "Approved", "Modified" or "Under Termination" |

    # Check the CONTRACT version, status and dates in CRM (This should not have changed)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017575 | DADAS-575          | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017575 | ESFA-575           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract 'DADAS-575' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Non-Financial Amendment Initiation Failed   | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Initiate Non-Financial Amendment (Vary)     | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'DADAS-575' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Non-Financial Amendment Initiation Failed      | CRM Integration               | ?                                    |
    | Initiate Non-Financial Amendment (Vary)        | FCS2 TEST                     | ?                                    |
    | Initiate Contract Modification                 | FCS2 TEST                     | Reassessment of circumstances        |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |



  

    # Authorise Modification (30698)

    # Change the date - CRM ignores this
    Given the override date is '04/11/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task to Authorise the Modification
    When the following open Task currently linked to version '1' of contract 'DADAS-575' for provider '10017575' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Modification Approval            | FCS1 TEST                 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017575 | DADAS-575          | 1                     | 0                        | Approved         | Modified                                 | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017575 | ESFA-575           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the Task has been marked as completed
    Then  the following Tasks are present against version '1' of contract 'DADAS-575' for provider '10017575'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017575 - 10017575 Co Ltd     | DADAS-575      | FCS1 TEST               | Contract Managers Team   | Completed       | Completed        |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract 'DADAS-575' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Modification Successful                     | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Modification Approval in Progress            |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Approve Modification                        | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Modification Approval in Progress            | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Non-Financial Amendment Initiation Failed   | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Initiate Non-Financial Amendment (Vary)     | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'DADAS-575' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Modification Successful                        | CRM Integration               | ?                                    |
    | Approve Modification                           | FCS5 TEST                     | ?                                    |
    | Non-Financial Amendment Initiation Failed      | CRM Integration               | ?                                    |
    | Initiate Non-Financial Amendment (Vary)        | FCS2 TEST                     | ?                                    |
    | Initiate Contract Modification                 | FCS2 TEST                     | Reassessment of circumstances        |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |

    # Check the contract modification details in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017575 | DADAS-575      | 1                     | 0                        | 16/10/2020               | 16/10/2020                   | Removed from RoATP              | Removed from RoATP                  |

    # ... and the CRM allocation data too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017575 | DADAS-575     | DADA-575         | 1                     | 0                        | 16/10/2020                   | 16/10/2020        | Removed from RoATP                  | Removed from RoATP                  |

    # Check the CM feed for the presence of a 'Contract Modified' event (ItemType 8)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '8' event for version '1' of actual contract number 'DADAS-575'
    And   the ItemType '8' event for version '1' of actual contract number 'DADAS-575' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017575 | DADAS-575      | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract DADAS-575:1.0 was modified                    |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017575 | DADAS-575      | 1               | 0                  | ?                       | ?                               | DADA-575        | 16/10/2020            | ?                         | Removed from RoATP               |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017575 | DADAS-575      | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract DADAS-575:1.0 was modified                    |

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017575 | DADAS-575      | 1               | 0                  | ?                       | ?                               | DADA-575        | 16/10/2020            | ?                         | Removed from RoATP               |





    # Successfully execute a NON-FINANCIAL amendment (30567)

    # Change the date
    Given the override date is '06/11/2020'

    # Issue a non-financial VARIATION amendment on v1 to create v2. This should work
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'DADAS-575' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017575 | DADAS-575          | 2                     | 0                        | Draft            | Awaiting Documentation   | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017575 | DADAS-575          | 1                     | 0                        | Approved         | Modified                 | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017575 | ESFA-575           | 1                     | 0                        | Draft            | ?                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |



    
    
    # Publish and Approve v2
    
    # Change the date
    Given the override date is '08/11/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'DADAS-575'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-575' and actual ContractNumber 'DADAS-575'

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017575 | DADAS-575          | 2                     | 0                        | Approved         | Modified                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017575 | DADAS-575          | 1                     | 0                        | Replaced         | Modified                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017575 | ESFA-575           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the contract modification details in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017575 | DADAS-575      | 2                     | 0                        | 16/10/2020               | 16/10/2020                   | Removed from RoATP              | Removed from RoATP                  |
    | 10017575 | DADAS-575      | 1                     | 0                        | 16/10/2020               | 16/10/2020                   | Removed from RoATP              | Removed from RoATP                  |

    # ... and the CRM allocation data too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017575 | DADAS-575     | DADA-575         | 2                     | 0                        | 16/10/2020                   | 16/10/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017575 | DADAS-575     | DADA-575         | 1                     | 0                        | 16/10/2020                   | 16/10/2020        | Removed from RoATP                  | Removed from RoATP                  |

    # Check contents of the ContractManagement.AtomFeedItem (CM) feed for a Type 0 (Approval) event messages for v2
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '2' of actual contract number 'DADAS-575'

    # Contract Schema check
    And   the ItemType '0' event for version '2' of contract number 'DADAS-575' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
   
    # ALLCONTRACT

    # Check the CM feed event data (ItemType 0)
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Approved Contract' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017575 | DADAS-575      | 2               | 0                  | ?                       | ?                               | DADA-575        | 16/10/2020            | ?                         | Removed from RoATP               |

    # Check the CM feed event data (ItemType 8)
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017575 | DADAS-575      | 1               | 0                  | ?                       | ?                               | DADA-575        | 16/10/2020            | ?                         | Removed from RoATP               |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed event data (ItemType 0)
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Approved Contract' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017575 | DADAS-575      | 2               | 0                  | ?                       | ?                               | DADA-575        | 16/10/2020            | ?                         | Removed from RoATP               |

    # Check the CM feed event data (ItemType 8)
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017575 | DADAS-575      | 1               | 0                  | ?                       | ?                               | DADA-575        | 16/10/2020            | ?                         | Removed from RoATP               |





    # Cancel the Authorised Modification (30700)

    # Change the date
    Given the override date is '10/11/2020'

    # Clear down CM feed 
    And   the Contract Management atom feed is empty 

    # Cancel authorised modification
    When  CRM user 'FCS1 TEST' cancels the authorised modification for Contract 'DADAS-575' Version '2' SubVersion '0' via SDK 

    # Check the CONTRACT version, status and dates in CRM. (Contract reverts to Approved\Approved)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017575 | DADAS-575          | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017575 | DADAS-575          | 1                     | 0                        | Replaced         | Modified                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017575 | ESFA-575           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the contract modification details in CRM (Modification details should have been wiped)
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017575 | DADAS-575      | 2                     | 0                        | ?                        | ?                            | ?                               | ?                                   |
    | 10017575 | DADAS-575      | 1                     | 0                        | 16/10/2020               | 16/10/2020                   | Removed from RoATP              | Removed from RoATP                  |

    # ... and the CRM allocation data too (Wiped from here too)
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017575 | DADAS-575     | DADA-575         | 2                     | 0                        | ?                            | ?                 | ?                                   | ?                                   |
    | 10017575 | DADAS-575     | DADA-575         | 1                     | 0                        | 16/10/2020                   | 16/10/2020        | Removed from RoATP                  | Removed from RoATP                  |


    # Workflow History

    # v1
    Then  the Workflow History for version '1' of contract 'DADAS-575' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Initiate Non-Financial Amendment (Vary)     | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Modified                                     |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Modification Successful                     | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Modification Approval in Progress            |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Approve Modification                        | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Modification Approval in Progress            | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Non-Financial Amendment Initiation Failed   | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Initiate Non-Financial Amendment (Vary)     | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017575 | ESFA-575           | DADAS-575      | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # v1 comments
    And   the workflow history on contract 'DADAS-575' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Initiate Non-Financial Amendment (Vary)        | FCS2 TEST                     | ?                                    |
    | Modification Successful                        | CRM Integration               | ?                                    |
    | Approve Modification                           | FCS5 TEST                     | ?                                    |
    | Non-Financial Amendment Initiation Failed      | CRM Integration               | ?                                    |
    | Initiate Non-Financial Amendment (Vary)        | FCS2 TEST                     | ?                                    |
    | Initiate Contract Modification                 | FCS2 TEST                     | Reassessment of circumstances        |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |

    # v2 
    Then  the Workflow History for version '2' of contract 'DADAS-575' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017575 | ESFA-575           | DADAS-575      | 2                     | Modification Cancellation Successful        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Approved       | Modification Cancellation in Progress        |
    | 10017575 | ESFA-575           | DADAS-575      | 2                     | Cancel Modification                         | FCS1 TEST                     | FCS2 TEST        | Document Management Team    | Approved          | Modification Cancellation in Progress        | FCS2 TEST             | Document Management Team  | Approved       | Modified                                     |
    | 10017575 | ESFA-575           | DADAS-575      | 2                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Modified                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |
    | 10017575 | ESFA-575           | DADAS-575      | 2                     | Record Imported (Task generated)            | CRM Integration               | FCS2 TEST        | Document Management Team    | Draft             | Awaiting Documentation                       | FCS2 TEST             | FCS1 TEST                 | Draft          | ?                                            |
#   | 10017575 | ESFA-575           | DADAS-575      | 2                     | Non-Financial Amendment Created             | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Draft             | ?                                            | ?                     | ?                         | Draft          | ?                                            |

    # v2 comments
    And   the workflow history on contract 'DADAS-575' version '2' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Modification Cancellation Successful           | CRM Integration               | ?                                    |
    | Cancel Modification                            | FCS1 TEST                     | ?                                    |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |
    | Record Imported (Task generated)               | CRM Integration               | ?                                    |
#   | Non-Financial Amendment Created                | CRM Integration               | ?                                    |


    # CM Feed

    # Check the CM feed for the presence of a 'Contract Modification Cancelled' event (ItemType 10)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '10' event for version '2' of actual contract number 'DADAS-575'
    And   the ItemType '10' event for version '2' of actual contract number 'DADAS-575' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                    | CategoryLabel                                  | Title                                                 |
    | 10017575 | DADAS-575      | 2               | 0                  | Contract Modification Cancelled | Modification of a contract has been cancelled  | Modification of contract DADAS-575:2.0 was cancelled  |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modification Cancelled' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason  |
    | 10017575 | DADAS-575      | 2               | 0                  | ?                       | ?                               | DADA-575        | ?                     | ?                         | ?                         |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                    | CategoryLabel                                  | Title                                                 |
    | 10017575 | DADAS-575      | 2               | 0                  | Contract Modification Cancelled | Modification of a contract has been cancelled  | Modification of contract DADAS-575:2.0 was cancelled  |

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modification Cancelled' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason  |
    | 10017575 | DADAS-575      | 2               | 0                  | ?                       | ?                               | DADA-575        | ?                     | ?                         | ?                         |


    # Tidy Up
    And   the override date is reset
 
@AcceptanceTest @Withdrawn20231002
Scenario: A576 Create and approve a CCF2021 contract. Initiate Modification. Bulk amendment fail UDC-020. Approve Modification. Bulk amendment success. Check CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017576' 
    And   there are no terminated or closed allocations for UKPRN '10017576' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017576' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017576' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017576' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | CCF-576       |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | CCF-576       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | CCF2021           |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | CCFUND-576     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017576'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017576' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017576 Co Ltd' with UKPRN '10017576' and OrgId 'ORG0017576' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017576' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017576 | 117576 | 10017576 Co Ltd | 0              | Active                | Yes           | AA017576      | ?             | 9 Colme Street         | Edinburgh              | ?                      | ?                      | ?                      | ?                      | EH3 6AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017576 |




    # Change the date
    Given the override date is '01/06/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription     | ContractType             | Period | CRMIntent    | OrgId      |
    | 10017576 | 10017576 Co Ltd      | ESFA-576             | CCFUND-576     | 1                     | 01/04/2020        | 31/03/2021      | 10000.00      |                         | Contract for Services    | 2021   | New          | ORG0017576 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName      | UoPCode    | AllocationDescription            | CRMIntent    | DeliveryOrg |
    | 10017576 | CCFUND-576     | CCF-576       | CCF               | CCF2021                 | FY                      | 01/04/2020          | 31/03/2021        | 10000.00        |              |            |                                  | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription            | CRMIntent    | DeliveryOrg |
    | 10017576 | CCFUND-576     | CCF-576       | 1               | 0                     | 10000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 10000.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | College Collaboration Fund (CCF)  | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | CCFUND-576     | 1                     | 0                        | 2020-06-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'CCFUND-576' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'CCFUND-576'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-576' and actual ContractNumber 'CCFUND-576'

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017576 | CCFUND-576         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017576 | ESFA-576           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'CCFUND-576'

#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | CCF-576         | 2208300          | Mar-21 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                             | DeliverableDescription                                      | 
    | 10017576 | CCFUND-576     | 1               | CCF-576       | 1               | 0                     | 10000.00     | 0             | 0        | College Collaboration Fund (CCF)                            | ?                                                           |





    # Initiate Modification (30697)

    # Change the date - CRM ignores this
    Given the override date is '22/10/2020'

    # Modification Initiation setup
    When  CRM user 'FCS2 TEST' initiates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017576 | CCFUND-576    | 1               | 0                  | 17/10/2020               | Inadequate Financial Health     | Provider request                        |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate modification request for manager approval via SDK

    # If all ok then Modification Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017576 | CCFUND-576     | 1                     | 0                        | 17/10/2020               | 17/10/2020                   | Inadequate Financial Health     | Inadequate Financial Health         |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017576 | CCFUND-576    | CCF-576          | 1                     | 0                        | 17/10/2020                   | 17/10/2020        | Inadequate Financial Health         | Inadequate Financial Health         |

    # A Modification Approval Task should have been created
    And   the following Tasks are present against version '1' of contract 'CCFUND-576' for provider '10017576'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017576 - 10017576 Co Ltd     | CCFUND-576     | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract 'CCFUND-576' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017576 | ESFA-576           | CCFUND-576     | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017576 | ESFA-576           | CCFUND-576     | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'CCFUND-576' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Initiate Contract Modification                 | FCS2 TEST                     | Provider request                     |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017576 | CCFUND-576         | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017576 | ESFA-576           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |





    # Bulk amendment. Fail UDC-020

    # Change the date
    Given the override date is '24/10/2020'

    # Bulk file (Amendment)
    And   there are no files prefixed '10017576' in the Sharepoint 'CCF-2021-Input-Appendices' folder
    And   there are no files prefixed 'CCF FY 2021 06112020112825 v3_A576' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'CCF FY 2021 06112020112825 v3_A576' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'CCF FY 2021 06112020112825 v3_A576' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'CCF FY 2021 06112020112825 v3_A576' in the Sharepoint 'Reports' folder
    And   spreadsheet 'CCF FY 2021 06112020112825 v3_A576.xlsx' exists in the Datafiles folder and UKPRN '10017576' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # UDC020
    And   '[Contract] Cannot create a draft Contract Amendment if there is no existing Approved Contract, or if the Contract is awaiting approval of either termination initiation, modification or closure' is displayed in field 'J2' on the 'Contract' tab of the result report





    # Authorise Modification (30698)

    # Change the date - CRM ignores this
    Given the override date is '28/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task to Authorise the Modification
    When the following open Task currently linked to version '1' of contract 'CCFUND-576' for provider '10017576' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Modification Approval            | FCS1 TEST                 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017576 | CCFUND-576         | 1                     | 0                        | Approved         | Modified                                 | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017576 | ESFA-576           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the Task has been marked as completed
    Then  the following Tasks are present against version '1' of contract 'CCFUND-576' for provider '10017576'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017576 - 10017576 Co Ltd     | CCFUND-576     | FCS1 TEST               | Contract Managers Team   | Completed       | Completed        |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract 'CCFUND-576' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017576 | ESFA-576           | CCFUND-576     | 1                     | Modification Successful                     | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Modified                                     | FCS2 TEST             | FCS1 TEST                 | Approved       | Modification Approval in Progress            |
    | 10017576 | ESFA-576           | CCFUND-576     | 1                     | Approve Modification                        | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Modification Approval in Progress            | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Modification Approval               |
    | 10017576 | ESFA-576           | CCFUND-576     | 1                     | Initiate Contract Modification              | FCS2 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Modification Approval               | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017576 | ESFA-576           | CCFUND-576     | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                     | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'CCFUND-576' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                              |
    | Modification Successful                        | CRM Integration               | ?                                    |
    | Approve Modification                           | FCS5 TEST                     | ?                                    |
    | Initiate Contract Modification                 | FCS2 TEST                     | Provider request                     |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                    |

    # Check the contract modification details in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017576 | CCFUND-576     | 1                     | 0                        | 17/10/2020               | 17/10/2020                   | Inadequate Financial Health     | Inadequate Financial Health         |

    # ... and the CRM allocation data too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017576 | CCFUND-576    | CCF-576          | 1                     | 0                        | 17/10/2020                   | 17/10/2020        | Inadequate Financial Health         | Inadequate Financial Health         |

    # Check the CM feed for the presence of a 'Contract Modified' event (ItemType 8)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '8' event for version '1' of actual contract number 'CCFUND-576'
    And   the ItemType '8' event for version '1' of actual contract number 'CCFUND-576' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017576 | CCFUND-576     | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract CCFUND-576:1.0 was modified                   |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017576 | CCFUND-576     | 1               | 0                  | ?                       | ?                               | CCF-576         | 17/10/2020            | ?                         | Inadequate Financial Health      |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017576 | CCFUND-576     | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract CCFUND-576:1.0 was modified                   |

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017576 | CCFUND-576     | 1               | 0                  | ?                       | ?                               | CCF-576         | 17/10/2020            | ?                         | Inadequate Financial Health      |





    # Change the date
    Given the override date is '04/11/2020'

    # Bulk file (Amendment)
    And   there are no files prefixed '10017576' in the Sharepoint 'CCF-2021-Input-Appendices' folder
    And   there are no files prefixed 'CCF FY 2021 06112020112825 v3_A576' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'CCF FY 2021 06112020112825 v3_A576' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'CCF FY 2021 06112020112825 v3_A576' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'CCF FY 2021 06112020112825 v3_A576' in the Sharepoint 'Reports' folder
    And   spreadsheet 'CCF FY 2021 06112020112825 v3_A576.xlsx' exists in the Datafiles folder and UKPRN '10017576' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017576 | CCFUND-576         | 2                     | 0                        | Draft            | Awaiting Documentation   | True          | False               | 01/04/2020        | 31/03/2021      | Variation     |
    | 10017576 | CCFUND-576         | 1                     | 0                        | Approved         | Modified                 | False         | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017576 | ESFA-576           | 1                     | 0                        | Draft            | ?                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |





    # Publish and Approve
    
    # Change the date
    Given the override date is '06/11/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'CCFUND-576'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-576' and actual ContractNumber 'CCFUND-576'

    # Check the CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017576 | CCFUND-576         | 2                     | 0                        | Approved         | Modified                 | True          | True                | 01/04/2020        | 31/03/2021      | Variation     |
    | 10017576 | CCFUND-576         | 1                     | 0                        | Replaced         | Modified                 | False         | False               | 01/04/2020        | 31/03/2021      | ?             |
    | 10017576 | ESFA-576           | 1                     | 0                        | Draft            | ?                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the contract modification details in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017576 | CCFUND-576     | 2                     | 0                        | 17/10/2020               | 17/10/2020                   | Inadequate Financial Health     | Inadequate Financial Health         |
    | 10017576 | CCFUND-576     | 1                     | 0                        | 17/10/2020               | 17/10/2020                   | Inadequate Financial Health     | Inadequate Financial Health         |

    # ... and the CRM allocation data too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017576 | CCFUND-576    | CCF-576          | 2                     | 0                        | 17/10/2020                   | 17/10/2020        | Inadequate Financial Health         | Inadequate Financial Health         |
    | 10017576 | CCFUND-576    | CCF-576          | 1                     | 0                        | 17/10/2020                   | 17/10/2020        | Inadequate Financial Health         | Inadequate Financial Health         |

    # Check contents of the ContractManagement.AtomFeedItem (CM) feed for a Type 0 (Approval) event messages for v2
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '2' of actual contract number 'CCFUND-576'

    # Contract Schema check
    And   the ItemType '0' event for version '2' of contract number 'CCFUND-576' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
   
    # ALLCONTRACT

    # Check the CM feed event data (ItemType 0)
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Approved Contract' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017576 | CCFUND-576     | 2               | 0                  | ?                       | ?                               | CCF-576         | 17/10/2020            | ?                         | Inadequate Financial Health      |

    # Check the CM feed event data (ItemType 8) 
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017576 | CCFUND-576     | 1               | 0                  | ?                       | ?                               | CCF-576         | 17/10/2020            | ?                         | Inadequate Financial Health      |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed event data (ItemType 0)
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Approved Contract' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017576 | CCFUND-576     | 2               | 0                  | ?                       | ?                               | CCF-576         | 17/10/2020            | ?                         | Inadequate Financial Health      |

    # Check the CM feed event data (ItemType 8)
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017576 | CCFUND-576     | 1               | 0                  | ?                       | ?                               | CCF-576         | 17/10/2020            | ?                         | Inadequate Financial Health      |


    # Tidy Up
    And   the override date is reset
   
@AcceptanceTest @Complete
Scenario: A046 Create and approve a LEVY contract. Initiate Modification. Fail to amend contract by bulk and singleton methods. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017046' 
    And   there are no terminated or closed allocations for UKPRN '10017046' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017046' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017046' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017046' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017046' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017046' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017046' 
 
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
    | 10017046 | 
 
    # Add the provider to RoATP (ContractManagement.RoATPProvider) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017046 | 10017046 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 
 
 
 
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017046' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017046 Co Ltd' with UKPRN '10017046' and OrgId 'ORG0017046' and has 'FCS1 Test' as a manager 
 
    # Put data in the PaaS Organisation table (Organisation.Organisation) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017046 | 117046 | 10017046 Co Ltd | 0              | Provider Under Change | Yes           | AA017046      | ?             | 60a North Street       | ?                      | ?                      | ?                      | Chichester             | West Sussex            | PO19 1NB  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017046 |

 
 
 
    # Change the date 
    Given the override date is '16/03/2020' 
 
    # Inject data into the stub to create a contract with two allocations 
   #And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation 
    And   the following Levy event data is available in the DAS agreement stub 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 62046 | INITIATED | 2019-12-15T18:03:12.2046 | 10017046   | 28046             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017046' 
    Then  there is only one Levy contract in CRM for UKPRN '10017046' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017046' for FundingType 'LEVY' and period '1799' 
 
 
 
 
 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017046 | 10017046 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017046 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017046 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017046 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017046 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017046 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017046 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017046 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
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
    Then the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Apr-20   | DeliverableDescription                               | 
    | 10017046 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017046 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017046 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017046 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017046 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017046 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017046 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017046 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017046 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017046 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017046 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017046 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017046 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017046 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
    # 
    | 10017046 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017046 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017046 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017046 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017046 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017046 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017046 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017046 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017046 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017046 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017046 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017046 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017046 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017046 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 
 
    # Check CONTRACT version, status and dates in CRM 
    Then  the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017046 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 09/04/2020        | ?               | ?             | 
    | 10017046 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
 
    # Check ALLOCATION dates in CRM 
    And   the following allocation values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | 
    | 10017046 | [ContractNo]       | 1                     | [AllocRef_LEVY]     | 09/04/2020          | ?                 | 
    | 10017046 | [ContractNo]       | 1                     | [AllocRef_NLA]      | 09/04/2020          | ?                 | 
 



    # Initiate Modification (30697)

    # Change the date - CRM ignores this
    Given the override date is '01/06/2020'

    # Modification Initiation setup
    When  CRM user 'FCS2 TEST' initiates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017046 | [ContractNo]  | 1               | 0                  | 30/06/2020               | Removed from RoATP              | Contract being run down                 |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate modification request for manager approval via SDK

    # If all ok then Modification Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017046 | [ContractNo]   | 1                     | 0                        | 30/06/2020               | 30/06/2020                   | Removed from RoATP              | Removed from RoATP                  |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017046 | [ContractNo]  | [AllocRef_LEVY]  | 1                     | 0                        | 30/06/2020                   | 30/06/2020        | Removed from RoATP                  | Removed from RoATP                  |
    | 10017046 | [ContractNo]  | [AllocRef_NLA]   | 1                     | 0                        | 30/06/2020                   | 30/06/2020        | Removed from RoATP                  | Removed from RoATP                  |

    # A Modification Approval Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017046'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017046 - 10017046 Co Ltd     | [ContractNo]   | Contract Managers Team  | ?                        | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017046 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017046 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |





    # Attempt to amend the contract by bulk and singleton methods. Both should fail

    # Bulk

    # Change the date
    Given the override date is '01/08/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Issue a BULK contract amendment request on v1 to create v2. This should fail
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus                      | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017046 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Awaiting Modification Approval | Variation     | No                       | Yes                   | Yes                          | 

    # Check the CONTRACT version, status and dates in CRM. These should not have changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017046 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017046 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check that a notification has been created 
    Then  there is '1' notification of type 'Contract Amendment Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                           | NotificationText                                                                                                                    |
    | New    | Contract Amendment Failed - [ContractNo]   | Contract [ContractNo] v1 for provider 10017046 (10017046 Co Ltd) cannot be amended - contract is awaiting approval of modification  |



    # Singleton

    # Change the date
    Given the override date is '02/08/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Issue a SINGLETON contract amendment request on v1 to create v2. This should fail
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus                      | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017046 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Awaiting Modification Approval | Variation     | No                       | Yes                   | Yes                          |

    # Check the CONTRACT version, status and dates in CRM. These should not have changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017046 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017046 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check that a second notification has been created 
    Then  there are '2' notifications of type 'Contract Amendment Failed' owned by user 'FCS2 Test' which match the following
    | Status | NotificationName                           | NotificationText                                                                                                                    |
    | New    | Contract Amendment Failed - [ContractNo]   | Contract [ContractNo] v1 for provider 10017046 (10017046 Co Ltd) cannot be amended - contract is awaiting approval of modification  |



    # RoATP Anomalies Report

   # # Check the RoATP Anomalies report for an entry for this contract
   ##Then  the RoATP Anomalies report does not contain a record for provider '10017046'
   # Then  the RoATP Anomalies report includes the following
   # | Contract     | MasterContract     | Ukprn    | Version  | SubVersion  | Status           | Substatus                       |
   # | [ContractNo] | [MasterContractNo] | 10017046 | 1        | 0           | Approved         | Awaiting Modification Approval  |


    # Tidy Up
    And   the override date is reset 
            
@AcceptanceTest @Withdrawn20231002
Scenario: A047 Create and approve a LEVY contract. Initiate and Authorise Modification. Bulk amend and Approve. Singleton amend and Approve. Check CRM (Test2)

    # 1. Create and approve a Levy contract and check docs
    # 2. Modify contract (No termination date)
    # 3. Bulk amendment > v2.          Letter = LEVY1799_Amendment_Modified.docx    Agreement\Ts&Cs = T&C_LEVY_2017-05-01.docx
    # 4. Singleton amendment > v3.     Letter = LEVY1799_Amendment_Modified.docx    Agreement\Ts&Cs = T&C_LEVY_2017-05-01.docx
    # 5. Default templates used with default expiry date

    Given there are no allocations marked as Under Termination for UKPRN '10017047' 
    And   there are no terminated or closed allocations for UKPRN '10017047' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017047' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017047' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017047' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017047' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017047' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017047' 
 
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
    | 10017047 | 
 
    # Add the provider to RoATP (ContractManagement.RoATPProvider) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017047 | 10017047 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 
 
 
 
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017047' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017047 Co Ltd' with UKPRN '10017047' and OrgId 'ORG0017047' and has 'FCS1 Test' as a manager 
 
    # Put data in the PaaS Organisation table (Organisation.Organisation) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017047 | 117047 | 10017047 Co Ltd | 0              | Locked Restructure    | Yes           | AA017047      | ?             | 20 Birklands Park      | ?                      | ?                      | ?                      | St.Albans              | Hertfordshire          | AL1 1TS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017047 |

 
 
 
    # Change the date 
    Given the override date is '16/03/2020' 
 
    # Inject data into the stub to create a contract with two allocations 
   #And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation 
    And   the following Levy event data is available in the DAS agreement stub 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 62047 | INITIATED | 2019-12-15T18:03:12.2047 | 10017047   | 28047             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017047' 
    Then  there is only one Levy contract in CRM for UKPRN '10017047' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017047' for FundingType 'LEVY' and period '1799' 
 
 
 
 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017047 | 10017047 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017047 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017047 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017047 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017047 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017047 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017047 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017047 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    # Check deliverable period count prior to approval 
    And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017047' for FundingType 'LEVY' and period '1799' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017047' for FundingType 'LEVY' and period '1799'

    # Check the contents of the Appendices
    Then  the file named '10017047_[ContractNo]_v1.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order
    """
	THIS AGREEMENT is made on the date the Agreement is digitally signed by the Training
	Provider through the Manage Your Education and Skills Funding Service having
	already been signed by the Department and is between:
	10017047 Co Ltd THE SECRETARY OF STATE FOR
	20 Birklands Park EDUCATION
	St.Albans DEPARTMENT FOR
	Hertfordshire EDUCATION
	AND
	AL1 1TS 20 GREAT SMITH STREET
	LONDON
	SW1P 3BT
	Company No: AA017047
	UKPRN: 10017047
	Referred to in this Agreement as “the Referred to in this Agreement as “the
	Training Provider” Department”

    Department for Education Apprenticeships-Provider Agreement, Winter 2023, Version 4.2
    Education & Skills Funding Agency
    Education and Skills Funding Agency - GOV.UK (www.gov.uk)
    56
    """

    # The Amendment Letter template is not included
    And   the pdf file does not contain the following text
    """
    Agreement number: [MasterContractNo] 
    """
    
    # Save a copy of the output 
    And   Sharepoint file '10017047_[ContractNo]_v1.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A047v1.pdf'




 
    # Approve the contract
    
    # Change the date 
    Given the override date is '09/04/2020' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 
 
    # Check deliverable period count after approval 
    Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a Apr-20 deliverable period for each of deliverables 1 through 14 for each allocation 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Apr-20   | DeliverableDescription                               | 
    | 10017047 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017047 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017047 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017047 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017047 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017047 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017047 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017047 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017047 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017047 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017047 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017047 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017047 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017047 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
    # 
    | 10017047 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017047 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017047 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017047 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017047 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017047 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017047 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017047 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017047 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017047 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017047 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017047 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017047 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017047 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 
 
    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017047 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 09/04/2020        | ?               | ?             | 
    | 10017047 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
 
    # Check ALLOCATION dates in CRM 
    And   the following allocation values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | 
    | 10017047 | [ContractNo]       | 1                     | [AllocRef_LEVY]     | 09/04/2020          | ?                 | 
    | 10017047 | [ContractNo]       | 1                     | [AllocRef_NLA]      | 09/04/2020          | ?                 | 
 
 


    # Initiate Modification (30697)

    # Change the date - CRM ignores this
    Given the override date is '15/11/2020'

    # Modification Initiation setup
    When  CRM user 'FCS2 TEST' initiates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017047 | [ContractNo]  | 1               | 0                  | 10/11/2020               | Inadequate Ofsted               | Reassessment of circumstances           |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate modification request for manager approval via SDK

    # If all ok then Modification Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017047 | [ContractNo]   | 1                     | 0                        | 10/11/2020               | 10/11/2020                   | Inadequate Ofsted               | Inadequate Ofsted                   |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017047 | [ContractNo]  | [AllocRef_LEVY]  | 1                     | 0                        | 10/11/2020                   | 10/11/2020        | Inadequate Ofsted                   | Inadequate Ofsted                   |
    | 10017047 | [ContractNo]  | [AllocRef_NLA]   | 1                     | 0                        | 10/11/2020                   | 10/11/2020        | Inadequate Ofsted                   | Inadequate Ofsted                   |

    # A Modification Approval Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017047'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017047 - 10017047 Co Ltd     | [ContractNo]   | Contract Managers Team  | ?                        | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017047 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017047 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |





    # Authorise Modification (30698)

    # Change the date - CRM ignores this
    Given the override date is '16/11/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task to Authorise the Modification
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017047' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Modification Approval            | Contract Managers Team    |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017047 | [ContractNo]       | 1                     | 0                        | Approved         | Modified                                 | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017047 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the Task has been marked as completed
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017047'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017047 - 10017047 Co Ltd     | [ContractNo]   | Contract Managers Team  | ?                        | Completed       | Completed        |

    # Check the contract modification details in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017047 | [ContractNo]   | 1                     | 0                        | 10/11/2020               | 10/11/2020                   | Inadequate Ofsted               | Inadequate Ofsted                   |

    # ... and the CRM allocation data too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017047 | [ContractNo]  | [AllocRef_LEVY]  | 1                     | 0                        | 10/11/2020                   | 10/11/2020        | Inadequate Ofsted                   | Inadequate Ofsted                   |
    | 10017047 | [ContractNo]  | [AllocRef_NLA]   | 1                     | 0                        | 10/11/2020                   | 10/11/2020        | Inadequate Ofsted                   | Inadequate Ofsted                   |

    # Check the CM feed for the presence of a 'Contract Modified' event (ItemType 8)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '8' event for version '1' of actual contract number '[ContractNo]'
    And   the ItemType '8' event for version '1' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017047 | [ContractNo]   | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract [ContractNo]:1.0 was modified                 |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017047 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_LEVY] | 10/11/2020            | ?                         | Inadequate Ofsted                |
    | 10017047 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_NLA]  | 10/11/2020            | ?                         | Inadequate Ofsted                |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017047 | [ContractNo]   | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract [ContractNo]:1.0 was modified                 |

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017047 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_LEVY] | 10/11/2020            | ?                         | Inadequate Ofsted                |
    | 10017047 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_NLA]  | 10/11/2020            | ?                         | Inadequate Ofsted                |




    # Bulk Amendment

    # Change the date
    Given the override date is '21/11/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Issue a contract amendment request on v1 to create v2. This should succeed
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status    | SubStatus   | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate | LetterTemplateName                 | AgreementTemplateName     |
    | 10017047 | [MasterContractNo]   | [ContractNo]   | 1       | Approved  | Modified    | Variation     | No                       | Yes                   | Yes                          | LEVY1799_Amendment.docx            | T&C_LEVY_2017-05-01.docx  |  

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017047 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider     | True          | False               | 09/04/2020        | ?               | Variation     |
    | 10017047 | [ContractNo]       | 1                     | 0                        | Approved         | Modified                  | False         | True                | 09/04/2020        | ?               | ?             |
    | 10017047 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the contents of the Appendices
    Then  the file named '10017047_[ContractNo]_v2.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order
    """
    THIS VARIATION is made on the date the Variation is digitally signed by the Training
    Provider on the “Manage your education and skills funding service” (“the Variation
    Date”).
    BETWEEN: -
    (1) THE SECRETARY OF STATE FOR EDUCATION DEPARTMENT FOR
    EDUCATION 20 Great Smith Street London SW1P 3BT (“the Department”);
    and
    (2) 10017047 Co Ltd Company No: AA017047 (10017047) whose registered office
    is situated at 20 Birklands Park, St.Albans, Hertfordshire, AL1 1TS (“the
    Training Provider”).
    RECITALS: -
    (A) The Department and the Training Provider entered into an Apprenticeship
    Agreement for the provision of Apprenticeship Training with the Department’s
    reference number of [MasterContractNo] ("Original Agreement").
    (B) The Department and the Training Provider have agreed to vary the terms of the
    Original Agreement as set out in this Variation.
    (C) The Department’s reference for this Variation is Winter 2023, Version 4.2.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    Agreement number: [MasterContractNo] 
  
    Department for Education Apprenticeships-Provider Agreement
    Terms and Conditions
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the Training
    Provider through the Manage Your Education and Skills Funding Service having
    already been signed by the Department and is between:
    10017047 Co Ltd THE SECRETARY OF STATE FOR
    20 Birklands Park EDUCATION
    St.Albans DEPARTMENT FOR
    Hertfordshire EDUCATION
    AND
    AL1 1TS 20 GREAT SMITH STREET
    LONDON
    SW1P 3BT
    Company No: AA017047
    UKPRN: 10017047
    Referred to in this Agreement as “the Referred to in this Agreement as “the
    Training Provider” Department”
  
    “Expiry Date” means 31 July 2025 or such later date as is notified in writing by
  
    Department for Education Apprenticeships-Provider Agreement, Winter 2023, Version 4.2
    Education & Skills Funding Agency
    Education and Skills Funding Agency - GOV.UK (www.gov.uk)
    56
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017047_[ContractNo]_v2.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A047v2.pdf'


    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2' 
 
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017047 | [ContractNo]       | 2                     | 0                        | Approved         | Modified                  | True          | True                | 09/04/2020        | ?               | Variation     |
    | 10017047 | [ContractNo]       | 1                     | 0                        | Replaced         | Modified                  | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017047 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check deliverable period count after approval 
    And   there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

    # Check the contract modification details in CRM
    And   the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017047 | [ContractNo]   | 2                     | 0                        | 10/11/2020               | 10/11/2020                   | Inadequate Ofsted               | Inadequate Ofsted                   |

    # ... and the CRM allocation data too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017047 | [ContractNo]  | [AllocRef_LEVY]  | 2                     | 0                        | 10/11/2020                   | 10/11/2020        | Inadequate Ofsted                   | Inadequate Ofsted                   |
    | 10017047 | [ContractNo]  | [AllocRef_NLA]   | 2                     | 0                        | 10/11/2020                   | 10/11/2020        | Inadequate Ofsted                   | Inadequate Ofsted                   |

    



    # Singleton Amendment

    # Change the date
    Given the override date is '26/11/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Issue a contract amendment request on v2 to create v3. This should succeed
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status    | SubStatus   | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate | LetterTemplateName                | AgreementTemplateName      |
    | 10017047 | [MasterContractNo]   | [ContractNo]   | 2       | Approved  | Modified    | Variation     | No                       | Yes                   | Yes                          | LEVY1799_Amendment.docx           | T&C_LEVY_2017-05-01.docx   |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017047 | [ContractNo]       | 3                     | 0                        | Draft            | Published to Provider     | True          | False               | 09/04/2020        | ?               | Variation     |
    | 10017047 | [ContractNo]       | 2                     | 0                        | Approved         | Modified                  | False         | True                | 09/04/2020        | ?               | Variation     |
    | 10017047 | [ContractNo]       | 1                     | 0                        | Replaced         | Modified                  | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017047 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |
 
    # Check the contents of the Appendices
    Then  the file named '10017047_[ContractNo]_v3.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order
    """
    THIS VARIATION is made on the date the Variation is digitally signed by the Training
    Provider on the “Manage your education and skills funding service” (“the Variation
    Date”).
    BETWEEN: -
    (1) THE SECRETARY OF STATE FOR EDUCATION DEPARTMENT FOR
    EDUCATION 20 Great Smith Street London SW1P 3BT (“the Department”);
    and
    (2) 10017047 Co Ltd Company No: AA017047 (10017047) whose registered office
    is situated at 20 Birklands Park, St.Albans, Hertfordshire, AL1 1TS (“the
    Training Provider”).
    RECITALS: -
    (A) The Department and the Training Provider entered into an Apprenticeship
    Agreement for the provision of Apprenticeship Training with the Department’s
    reference number of [MasterContractNo] ("Original Agreement").
    (B) The Department and the Training Provider have agreed to vary the terms of the
    Original Agreement as set out in this Variation.
    (C) The Department’s reference for this Variation is Winter 2023, Version 4.2.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    Agreement number: [MasterContractNo] 
  
    Department for Education Apprenticeships-Provider Agreement
    Terms and Conditions
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the Training
    Provider through the Manage Your Education and Skills Funding Service having
    already been signed by the Department and is between:
    10017047 Co Ltd THE SECRETARY OF STATE FOR
    20 Birklands Park EDUCATION
    St.Albans DEPARTMENT FOR
    Hertfordshire EDUCATION
    AND
    AL1 1TS 20 GREAT SMITH STREET
    LONDON
    SW1P 3BT
    Company No: AA017047
    UKPRN: 10017047
    Referred to in this Agreement as “the Referred to in this Agreement as “the
    Training Provider” Department”
  
    “Expiry Date” means 31 July 2025 or such later date as is notified in writing by
  
    Department for Education Apprenticeships-Provider Agreement, Winter 2023, Version 4.2
    Education & Skills Funding Agency
    Education and Skills Funding Agency - GOV.UK (www.gov.uk)
    56
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017047_[ContractNo]_v3.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A047v3.pdf'


    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3' 
   
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017047 | [ContractNo]       | 3                     | 0                        | Approved         | Modified                  | True          | True                | 09/04/2020        | ?               | Variation     |
    | 10017047 | [ContractNo]       | 2                     | 0                        | Replaced         | Modified                  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017047 | [ContractNo]       | 1                     | 0                        | Replaced         | Modified                  | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017047 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check deliverable period count after approval 
    And   there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

    # Check the contract modification details in CRM
    And   the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017047 | [ContractNo]   | 3                     | 0                        | 10/11/2020               | 10/11/2020                   | Inadequate Ofsted               | Inadequate Ofsted                   |

    # ... and the CRM allocation data too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017047 | [ContractNo]  | [AllocRef_LEVY]  | 3                     | 0                        | 10/11/2020                   | 10/11/2020        | Inadequate Ofsted                   | Inadequate Ofsted                   |
    | 10017047 | [ContractNo]  | [AllocRef_NLA]   | 3                     | 0                        | 10/11/2020                   | 10/11/2020        | Inadequate Ofsted                   | Inadequate Ofsted                   |


    # Tidy Up
    And   the override date is reset
       
          