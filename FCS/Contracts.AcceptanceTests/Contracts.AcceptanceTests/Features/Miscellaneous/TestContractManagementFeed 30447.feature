Feature: TestContractManagementFeed 30447

@AcceptanceTest @Withdrawn20240103
Scenario: A013 Bulk load and approve a new ESF1420 contract. Modify, approve then withdraw modification. Terminate. Check CRM against CM feed
    Given there are no allocations marked as Under Termination for UKPRN '10017013' 
    And   there are no terminated or closed allocations for UKPRN '10017013' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017013' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017013' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017013' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ESF-013       |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ESF-013       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ESF1420           |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | ESIF-013       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017013'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017013' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017013 Co Ltd' with UKPRN '10017013' and OrgId 'ORG0017013' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017013' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017013 | 117013 | 10017013 Co Ltd | 0              | Provider Under Change | Yes           | AA017013      | ?             | 345 The Meadway        | Tilehurst              | ?                      | ?                      | Reading                | Berkshire              | RG30 4NU  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017013 |




    # Change the date
    Given the override date is '01/03/2020'

    # Bulk file
    And   there are no files prefixed '10017013' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 08122020110052 v3_A013' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'ESF ESF 1420 08122020110052 v3_A013' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 08122020110052 v3_A013' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 08122020110052 v3_A013' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 08122020110052 v3_A013.xlsx' exists in the Datafiles folder and UKPRN '10017013' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017013' for FundingType 'ESF' and period '1420' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017013' for FundingType 'ESF' and period '1420'

    # Contract status is now at 'Awaiting Documentation'


    # Change the date
    Given the override date is '02/03/2020'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2020-03-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017013 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017013 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    
    # Test Contract Approval event

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed





    # Initiate Modification (30697)

    # Change the date - CRM ignores this
    Given the override date is '23/11/2020'

    # Modification Initiation setup
    When  CRM user 'FCS2 TEST' initiates a contract modification with the following values
    | UKPRN    | ContractNo    | ContractVersion | ContractSubVersion | DefaultStopNewStartsDate | DefaultNewStartsSuspendedReason | Comments                                |
    | 10017013 | [ContractNo]  | 1               | 0                  | 18/11/2020               | Inadequate Ofsted               | ?                                       |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate modification request for manager approval via SDK

    # If all ok then Modification Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017013 | [ContractNo]   | 1                     | 0                        | 18/11/2020               | 18/11/2020                   | Inadequate Ofsted               | Inadequate Ofsted                   |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017013 | [ContractNo]  | [AllocRef_ESF]   | 1                     | 0                        | 18/11/2020                   | 18/11/2020        | Inadequate Ofsted                   | Inadequate Ofsted                   |

    # A Modification Approval Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017013'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017013 - 10017013 Co Ltd     | [ContractNo]   | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017013 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Modification Approval           | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017013 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |





    # Authorise Modification (30698)

    # Change the date - CRM ignores this
    Given the override date is '24/11/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task to Authorise the Modification
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017013' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Modification Approval            | FCS1 TEST                 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017013 | [ContractNo]       | 1                     | 0                        | Approved         | Modified                                 | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017013 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the Task has been marked as completed
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017013'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Modification Approval              | 10017013 - 10017013 Co Ltd     | [ContractNo]   | FCS1 TEST               | Contract Managers Team   | Completed       | Completed        |


    # Check the contract modification details in CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017013 | [ContractNo]   | 1                     | 0                        | 18/11/2020               | 18/11/2020                   | Inadequate Ofsted               | Inadequate Ofsted                   |

    # ... and the CRM allocation data too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason            |
    | 10017013 | [ContractNo]  | [AllocRef_ESF]   | 1                     | 0                        | 18/11/2020                   | 18/11/2020        | Inadequate Ofsted                   | Inadequate Ofsted                   |

    # Check the CM feed for the presence of a 'Contract Modified' event (ItemType 8)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '8' event for version '1' of actual contract number '[ContractNo]'
    And   the ItemType '8' event for version '1' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017013 | [ContractNo]   | 1               | 0                  | Contract Modified              | Contract has been modified                   | Contract [ContractNo]:1.0 was modified                 |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017013 | [ContractNo]   | 1               | 0                  | ?                       | ?                               | [AllocRef_ESF]  | 18/11/2020            | ?                         | Inadequate Ofsted                |


    # Test Modification Authorisation event

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed





    # Cancel Authorised Modification (30700)

    # Change the date - CRM ignores this
    Given the override date is '25/11/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Manager CANCELS an approved Modification (30700)
    When  CRM user 'FCS1 TEST' cancels the authorised modification for Contract '[ContractNo]' Version '1' SubVersion '0' via SDK 

    # If all ok then cancellation proceeds and the Modification data will be removed from CRM
    Then  the following contract modification values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | DefaultStopNewStartsDate | ProvisionalStopNewStartsDate | DefaultNewStartsSuspendedReason | ProvisionalNewStartsSuspendedReason |
    | 10017013 | [ContractNo]   | 1                     | 0                        | ?                        | ?                            | ?                               | ?                                   |

    # ... and the allocation data will have been removed from CRM too
    And   the following allocation modification values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalNewStartsSuspendedReason | NewStartsSuspendedReason  |
    | 10017013 | [ContractNo]  | [AllocRef_ESF]   | 1                     | 0                        | ?                            | ?                 | ?                                   | ?                         |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus   | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017013 | [ContractNo]       | 1                     | 0                        | Approved         | Approved            | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017013 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                   | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the CM feed for the presence of a 'Contract Modification Cancelled' event (ItemType 10)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '10' event for version '1' of actual contract number '[ContractNo]'
    And   the ItemType '10' event for version '1' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed table event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                      | CategoryLabel                                  | Title                                                    |
    | 10017013 | [ContractNo]   | 1               | 0                  | Contract Modification Cancelled   | Modification of a contract has been cancelled  | Modification of contract [ContractNo]:1.0 was cancelled  |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modification Cancelled' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason  | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason |
    | 10017013 | [ContractNo]   | 1               | 0                  | ?                       | ?                          | [AllocRef_ESF]  | ?                     | ?                         | ?                        |


    # Test Modification Cancellation Event

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed





    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '26/11/2020'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | [ContractNo]  | 1               | 0                  | 26/11/2020              | Notice from Provider        | Acquisition in progress             |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | [AllocRef_ESF]     | 22/10/2020                   | 29/10/2020                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017013 | [ContractNo]   | 1                     | 0                        | 26/11/2020                 | Notice from Provider         | ?                              | 26/11/2020              | Notice from Provider        | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017013 | [ContractNo]  | [AllocRef_ESF]   | 1                     | 0                        | 22/10/2020                   | 22/10/2020        | 29/10/2020                      | 29/10/2020           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017013'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017013 - 10017013 Co Ltd     | [ContractNo]   | Contract Managers Team  | ?                        | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017013 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017013 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |





    # Approve Termination Initiation (30635)

    # Change the date - CRM ignores this
    Given the override date is '28/11/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017013' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Termination Initiation Approval  | Contract Managers Team    |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017013 | [ContractNo]       | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017013 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017013'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017013 - 10017013 Co Ltd     | [ContractNo]   | Contract Managers Team  | ?                        | Completed       | Completed        |

    # Check the Termination details on the contract in CRM (These should not have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017013 | [ContractNo]   | 1                     | 0                        | 26/11/2020                 | Notice from Provider         | ?                              | 26/11/2020              | Notice from Provider        | ?                             |

    # Check the Termination details on the allocations in CRM (These should not have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017013 | [ContractNo]  | [AllocRef_ESF]          | 1                     | 0                        | 22/10/2020                   | 22/10/2020        | 29/10/2020                      | 29/10/2020           |

    # Check the CM feed for the presence of a Contract Termination Initiation row (ItemType 4)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number '[ContractNo]'
    And   the ItemType '4' event for version '1' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017013 | [ContractNo]   | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract [ContractNo]:1.0 was placed under termination     |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017013 | [ContractNo]   | 1               | 0                  | 26/11/2020              | Notice from Provider            | [AllocRef_ESF]         | 22/10/2020            | 29/10/2020                |


    # Test Termination Initiation Approval event

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


    # Tidy Up
    And   the override date is reset
       