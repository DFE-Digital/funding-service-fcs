Feature: FurtherTerminationReasons 35488

@AcceptanceTest @Withdrawn20230123
Scenario: A647 Create and approve a 16-18FU2122 contract. Initiate termination. Update termination details. Check CRM and feed

    # 1. Create and approve a 16-18FU2122 contract
    # 2. Initiate contract termination with reason 'RoATP Refresh'
    # 3. Update termination reason to 'Merger'

    Given there are no allocations marked as Under Termination for UKPRN '10017647' 
    And   there are no terminated or closed allocations for UKPRN '10017647' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017647' 
    And   there are no notifications in CRM of type 'Contract Termination Failed' for UKPRN '10017647' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017647' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16FU-647      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16FU-647      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18FU2122       |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | 1618FU-647     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017647'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017647' 
    And   there is no caseload advisor for UKPRN '10017647' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017647 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017647' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017647 Co Ltd' with UKPRN '10017647' and OrgId 'ORG0017647' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017647 | 117647 | 10017647 Co Ltd | 0              | Active                | Yes           | AA017647      | ?             | 1301 Stratford Road    | Hall Green             | ?                      | ?                      | Birmingham             | West Midlands          | B28 9HH   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017647 |





    # Part 1: Create and approve a 16-18FU2122 contract
    
    # Change the date
    Given the override date is '01/03/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '1618FU-647'
    And   there are no details in ContractManagement.CreatedContract for '1618FU-647'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017647 | 10017647 Co Ltd      | ESFA-647             | 1618FU-647     | 1                     | 01/04/2021        | 31/03/2022      | 5423.00       |                                       | Contract for Services                      | 2122   | New          | ORG0017647 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017647 | 1618FU-647     | 16FU-647      | 16-18FU           | 16-18FU2122             | FY                      | 01/04/2021          | 31/03/2022        | 5423.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017647 | 1618FU-647     | 16FU-647      | 1               | 0                     | 5423.00   | 1523.00  | 1756.00  | 2144.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-18 Education at an Adolescent Forensic Unit                  | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 1618FU-647     | 1                     | 0                        | 2021-03-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '1618FU-647'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-647' and ContractNumber '1618FU-647' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '1618FU-647' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017647 | 1618FU-647         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017647 | ESFA-647           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '1618FU-647' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract '1618FU-647'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 16FU-647        | 2430670          | Mar-22 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                  | DeliverableDescription  | 
    | 10017647 | 1618FU-647     | 1               | 16FU-647      | 1               | 0                     | 5423.00      | 0             | 0        | 16-18 Education at an Adolescent Forensic Unit   | ?                       |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '1618FU-647' agree with the most recent entry for this contract in the ContractManagement feed





    # Part 2: Initiate contract termination with reason 'RoATP Refresh'

    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '28/10/2021'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | 1618FU-647    | 1               | 0                  | 28/10/2021              | RoATP Refresh               | Acquisition in progress             |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | 16FU-647           | 27/09/2021                   | 04/10/2021                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017647 | 1618FU-647     | 1                     | 0                        | 28/10/2021                 | RoATP Refresh                | ?                              | 28/10/2021              | RoATP Refresh          | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017647 | 1618FU-647    | 16FU-647         | 1                     | 0                        | 27/09/2021                   | 27/09/2021        | 04/10/2021                      | 04/10/2021           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract '1618FU-647' for provider '10017647'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017647 - 10017647 Co Ltd     | 1618FU-647     | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract '1618FU-647' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                             | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus        |
    | 10017647 | ESFA-647           | 1618FU-647     | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval | FCS2 TEST             | Document Management Team  | Approved       | Approved                 |
    | 10017647 | ESFA-647           | 1618FU-647     | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                 | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider    |

    # Check the Workflow History comments 
    And   the workflow history on contract '1618FU-647' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Initiate Contract Termination                  | FCS8 TEST                     | Acquisition in progress          |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017647 | 1618FU-647         | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017647 | ESFA-647           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2021        | 31/03/2022      | ?             |




    # Approve Termination Initiation (30635)

    # Change the date - CRM ignores this
    Given the override date is '29/10/2021'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task
    When the following open Task currently linked to version '1' of contract '1618FU-647' for provider '10017647' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Termination Initiation Approval  | FCS1 TEST                 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017647 | 1618FU-647         | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017647 | ESFA-647           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract '1618FU-647' for provider '10017647'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017647 - 10017647 Co Ltd     | 1618FU-647     | FCS1 TEST               | Contract Managers Team   | Completed       | Completed        |

    # Check the Termination details on the contract in CRM (These should not have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017647 | 1618FU-647     | 1                     | 0                        | 28/10/2021                 | RoATP Refresh                | ?                              | 28/10/2021              | RoATP Refresh          | ?                             |

    # Check the Termination details on the allocations in CRM (These should not have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017647 | 1618FU-647    | 16FU-647         | 1                     | 0                        | 27/09/2021                   | 27/09/2021        | 04/10/2021                      | 04/10/2021           |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract '1618FU-647' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                  | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017647 | ESFA-647           | 1618FU-647     | 1                     | Termination Initiation Successful           | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Initiation Approval in Progress  |
    | 10017647 | ESFA-647           | 1618FU-647     | 1                     | Approve Termination Initiation              | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Initiation Approval in Progress   | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Termination Initiation Approval     |
    | 10017647 | ESFA-647           | 1618FU-647     | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval      | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017647 | ESFA-647           | 1618FU-647     | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                      | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract '1618FU-647' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Termination Initiation Successful              | CRM Integration               | ?                                |
    | Approve Termination Initiation                 | FCS5 TEST                     | ?                                |
    | Initiate Contract Termination                  | FCS8 TEST                     | Acquisition in progress          |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CM feed for the presence of a Contract Termination Initiation row (ItemType 4)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number '1618FU-647'
    And   the ItemType '4' event for version '1' of actual contract number '1618FU-647' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017647 | 1618FU-647     | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract 1618FU-647:1.0 was placed under termination   |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017647 | 1618FU-647     | 1               | 0                  | 28/10/2021              | RoATP Refresh                   | 16FU-647        | 27/09/2021            | 04/10/2021                |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017647 | 1618FU-647     | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract 1618FU-647:1.0 was placed under termination   |

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017647 | 1618FU-647     | 1               | 0                  | 28/10/2021              | RoATP Refresh                   | 16FU-647        | 27/09/2021            | 04/10/2021                |




    # Part 3: Update termination reason to 'Merger'

    # Change the date - CRM ignores this
    Given the override date is '30/10/2021'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Update Termination Details - contract 
    #  (Add 2 days to the termination date, change reason from 'RoATP Refresh' to 'Merger' and add a new comment)
    When  CRM user 'FCS8 TEST' updates contract termination details for Contract '1618FU-647' Version '1' SubVersion '0' with the following options
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | TerminationComments                 |
    | 1618FU-647    | 1               | 0                  | 30/10/2021              | Merger                      | Suspected fraud                     |

    # Update Termination Details - allocations 
    #  (Add 3 days to each of the dates)
    And   with the following updated allocation termination options
    | AllocationNumber   | AllocationStopNewStartsDate  | AllocationTerminationDate       |
    | 16FU-647           | 30/09/2021                   | 07/10/2021                      |

    # Use the SDK to submit a request to amend termination details
    And   the user completes the termination amendment request via SDK

    # Check the Termination details on the contract in CRM (These should have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017647 | 1618FU-647     | 1                     | 0                        | 30/10/2021                 | Merger                       | ?                              | 30/10/2021              | Merger | ?                             |

    # Check the Termination details on the allocations in CRM (These should have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017647 | 1618FU-647    | 16FU-647         | 1                     | 0                        | 30/09/2021                   | 30/09/2021        | 07/10/2021                      | 07/10/2021           |

    # Check the CONTRACT version, status and dates in CRM (These should not have changed)
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017647 | 1618FU-647         | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017647 | ESFA-647           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract '1618FU-647' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                  | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017647 | ESFA-647           | 1618FU-647     | 1                     | Termination Details Update Successful       | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Details Update in Progress       |
    | 10017647 | ESFA-647           | 1618FU-647     | 1                     | Update Termination Details                  | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Details Update in Progress        | FCS2 TEST             | FCS1 TEST                 | Approved       | Under Termination                            |
    | 10017647 | ESFA-647           | 1618FU-647     | 1                     | Termination Initiation Successful           | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Initiation Approval in Progress  |
    | 10017647 | ESFA-647           | 1618FU-647     | 1                     | Approve Termination Initiation              | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Initiation Approval in Progress   | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Termination Initiation Approval     |
    | 10017647 | ESFA-647           | 1618FU-647     | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval      | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017647 | ESFA-647           | 1618FU-647     | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                      | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract '1618FU-647' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Termination Details Update Successful          | CRM Integration               | ?                                |
    | Update Termination Details                     | FCS8 TEST                     | Suspected fraud                  |
    | Termination Initiation Successful              | CRM Integration               | ?                                |
    | Approve Termination Initiation                 | FCS5 TEST                     | ?                                |
    | Initiate Contract Termination                  | FCS8 TEST                     | Acquisition in progress          |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CM feed for the presence of a Contract Termination Details Updated row (ItemType 7)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '7' event for version '1' of actual contract number '1618FU-647'
    And   the ItemType '7' event for version '1' of actual contract number '1618FU-647' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                        | Title                                                               |
    | 10017647 | 1618FU-647     | 1               | 0                  | Contract Termination Details Updated | Termination details for a contract have been updated | Termination details for contract 1618FU-647:1.0 have been updated   |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017647 | 1618FU-647     | 1               | 0                  | 30/10/2021              | Merger                          | 16FU-647        | 30/09/2021            | 07/10/2021                |

    # APPROVALONWARDSCONTRACT

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                        | Title                                                               |
    | 10017647 | 1618FU-647     | 1               | 0                  | Contract Termination Details Updated | Termination details for a contract have been updated | Termination details for contract 1618FU-647:1.0 have been updated   |

    # Check the CM feed event data
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017647 | 1618FU-647     | 1               | 0                  | 30/10/2021              | Merger                          | 16FU-647        | 30/09/2021            | 07/10/2021                |


    # Tidy Up
    Given the override date is reset


