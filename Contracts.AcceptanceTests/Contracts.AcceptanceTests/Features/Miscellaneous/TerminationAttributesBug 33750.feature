Feature: TerminationAttributesBug 33750

@AcceptanceTest @Withdrawn20240103
Scenario: A180 Bug: Create and approve an ESF1420 contract. Put under termination. NFA to create v2. Publish and approve. Check termination details on approval event on CM feed
    Given there are no allocations marked as Under Termination for UKPRN '10017180' 
    And   there are no terminated or closed allocations for UKPRN '10017180' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017180' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017180' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017180' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ESF-180       |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ESF-180       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ESF1420           |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | ESIF-180       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017180'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017180' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017180 Co Ltd' with UKPRN '10017180' and OrgId 'ORG0017180' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017180' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017180 | 117180 | 10017180 Co Ltd | 0              | In Administration     | Yes           | AA017180      | ?             | 9 High Street          | Delph                  | ?                      | ?                      | Saddleworth            | Greater Manchester     | OL4 7DJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017180 |





    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'ESIF-180'
    And   there are no details in ContractManagement.CreatedContract for 'ESIF-180'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017180 | 10017180 Co Ltd      | ESFA-180             | ESIF-180       | 1                     | 01/08/2020        | 31/03/2021      | 52199.00      | ESF Contract                          | Contract for Services                      | 1420   | New          | ORG0017180 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                             | AgreementNumber | ActivityDescription                | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017180 | ESIF-180       | ESF-180       | ESF 201420        | ESF1420                 | ESF                     | 01/08/2020          | 31/03/2021        | 52199.00        |                                         |            | ESF Allocation                                              | New          | West of England LEP                         | E37037       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017180    | 1.1 Access to employment for jobseekers/ the inactive | 111\SD\7180     | Skills Support for Young Unemployed | SSR                   | Less Developed | 1.02                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017180 | ESIF-180       | ESF-180       | 2               | 0                     | 12929.00  | 497.00   | 2276.00  | 640.00   | 2829.00  | 2681.00  | 1391.00  | 576.00   | 2039.00  | RQ01 Regulated Learning                                         | New          |             | 
    | 10017180 | ESIF-180       | ESF-180       | 4               | 0                     | 39270.00  | 3213.00  | 2380.00  | 4760.00  | 8330.00  | 11424.00 | 2142.00  | 2499.00  | 4522.00  | FS01 Additional Programme Cost                                  | New          |             | 

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | 
    | 10017180 | ESIF-180       | ESF-180       | 4               | 119      | 330     | 27       | 20       | 40       | 70       | 96       | 18       | 21       | 38       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | ESIF-180       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'ESIF-180'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-180' and actual ContractNumber 'ESIF-180'

    # Check that the contract is now approved
    Then  the latest version of contract 'ESIF-180' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017180 | ESIF-180           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/03/2021      | ?             |
    | 10017180 | ESFA-180           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/03/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'ESIF-180' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '16' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '16' deliverable period rows in CRM linked to the latest version of contract 'ESIF-180'

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017180 | ESIF-180       | 1               | ESF-180       | 2               | 0                     | 12929.00     | 0             | 0        | RQ01 Regulated Learning                                         | ?                                                           |
    | 10017180 | ESIF-180       | 1               | ESF-180       | 4               | 0                     | 39270.00     | 330           | 119      | FS01 Additional Programme Cost                                  | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'ESIF-180' agree with the most recent entry for this contract in the ContractManagement feed





    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '20/02/2021'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | ESIF-180      | 1               | 0                  | 20/02/2021              | Deactivated UKPRN           | Acquisition in progress             |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | ESF-180            | 23/01/2021                   | 30/01/2021                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017180 | ESIF-180       | 1                     | 0                        | 20/02/2021                 | Deactivated UKPRN            | ?                              | 20/02/2021              | Deactivated UKPRN           | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017180 | ESIF-180      | ESF-180          | 1                     | 0                        | 23/01/2021                   | 23/01/2021        | 30/01/2021                      | 30/01/2021           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract 'ESIF-180' for provider '10017180'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017180 - 10017180 Co Ltd     | ESIF-180       | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017180 | ESIF-180           | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 01/08/2020        | 31/03/2021      | ?             |
    | 10017180 | ESFA-180           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/03/2021      | ?             |




    # Approve Termination Initiation (30635)

    # Change the date - CRM ignores this
    Given the override date is '21/02/2021'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task
    When the following open Task currently linked to version '1' of contract 'ESIF-180' for provider '10017180' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Termination Initiation Approval  | FCS1 TEST                 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017180 | ESIF-180           | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 01/08/2020        | 31/03/2021      | ?             |
    | 10017180 | ESFA-180           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/03/2021      | ?             |

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract 'ESIF-180' for provider '10017180'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017180 - 10017180 Co Ltd     | ESIF-180       | FCS1 TEST               | Contract Managers Team   | Completed       | Completed        |

    # Check the Termination details on the contract in CRM (These should not have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017180 | ESIF-180       | 1                     | 0                        | 20/02/2021                 | Deactivated UKPRN            | ?                              | 20/02/2021              | Deactivated UKPRN           | ?                             |

    # Check the Termination details on the allocations in CRM (These should not have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017180 | ESIF-180      | ESF-180          | 1                     | 0                        | 23/01/2021                   | 23/01/2021        | 30/01/2021                      | 30/01/2021           |

    # Check the CM feed for the presence of a Contract Termination Initiation row (ItemType 4)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number 'ESIF-180'
    And   the ItemType '4' event for version '1' of actual contract number 'ESIF-180' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # ALLCONTRACT

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017180 | ESIF-180       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract ESIF-180:1.0 was placed under termination     |

    # Check the CM feed event data
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017180 | ESIF-180       | 1               | 0                  | 20/02/2021              | Deactivated UKPRN               | ESF-180         | 23/01/2021            | 30/01/2021                |





    # Execute a NON-FINANCIAL amendment on v1 to create v2

    # Change the date
    Given the override date is '26/02/2021'

    # Issue a non-financial NOTIFICATION amendment on v2 to create v3
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'ESIF-180' for a non-financial VARIATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'ESIF-180' for a non-financial NOTIFICATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017180 | ESIF-180           | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2020        | 31/03/2021      | Variation     |
    | 10017180 | ESIF-180           | 1                     | 0                        | Approved         | Under Termination                         | False         | True                | 01/08/2020        | 31/03/2021      | ?             |
    | 10017180 | ESFA-180           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/03/2021      | ?             |





    # Publish and Approve v2 then check the termination details on the Approval event on the CM feed

    # Change the date
    Given the override date is '27/02/2021'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'ESIF-180'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-180' and ContractNumber 'ESIF-180' and Version '2'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017180 | ESIF-180           | 2                     | 0                        | Approved         | Under Termination                         | True          | True                | 01/08/2020        | 31/03/2021      | Variation     |
    | 10017180 | ESIF-180           | 1                     | 0                        | Replaced         | Under Termination                         | False         | False               | 01/08/2020        | 31/03/2021      | ?             |
    | 10017180 | ESFA-180           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2020        | 31/03/2021      | ?             |

    # Check the CM feed event data (ItemType 0)
    Then  the Contract Management 'ALLCONTRACT' feed includes category 'Approved Contract' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017180 | ESIF-180       | 2               | 0                  | 20/02/2021              | Deactivated UKPRN               | ESF-180         | 23/01/2021            | 30/01/2021                |


    # Tidy Up
    And   the override date is reset
       
