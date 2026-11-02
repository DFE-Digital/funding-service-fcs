Feature: InitiateContractTermination 30634

@AcceptanceTest @Withdrawn20230123
Scenario: A261 Create and approve a 4-alloc 2021 AEBP contract. Initiate termination then approve the initiation. Update details then Complete Termination. Check CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017261' 
    And   there are no terminated or closed allocations for UKPRN '10017261' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017261' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017261' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-261      |
    | AEBA-261      |
    | AEBR-261      |
    | AETL-261      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-261      |
    | AEBA-261      |
    | AEBR-261      |
    | AETL-261      |

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
    | AEBP-261       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017261'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017261' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017261 Co Ltd' with UKPRN '10017261' and OrgId 'ORG0017261' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017261' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017261 | 117261 | 10017261 Co Ltd | 0              | Active                | Yes           | AA017261      | ?             | 9 Kneesworth Street    | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017261 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017261 | 10017261 Co Ltd      | ESFA-261             | AEBP-261       | 1                     | 01/08/2020        | 31/07/2021      | 93653.00      |                                       | Procured                                   | 2021   | New          | ORG0017261 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017261 | AEBP-261       | AEAL-261      | AEB-ASLS          | AEB-ASLS2021            | AY                      | 01/08/2020          | 31/07/2021        | 24955.00        |                                         |            |                                                             | New          |             |
    | 10017261 | AEBP-261       | AEBA-261      | AEB-AS            | AEB-AS2021              | AY                      | 01/08/2020          | 31/07/2021        | 27301.00        |                                         |            |                                                             | New          |             |
    | 10017261 | AEBP-261       | AEBR-261      | AEB-19TRN         | AEB-19TRN2021           | AY                      | 01/08/2020          | 31/07/2021        | 15926.00        |                                         |            |                                                             | New          |             |
    | 10017261 | AEBP-261       | AETL-261      | AEB-19TRLS        | AEB-19TRLS2021          | AY                      | 01/08/2020          | 31/07/2021        | 25471.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017261 | AEBP-261       | AEAL-261      | 1               | 0                     | 24955.00  | 14833.00  | 10122.00  | 67.00    | 2795.00  | 1031.00  | 2622.00  | 3516.00  | 833.00   | 3215.00  | 754.00   | 3452.00  | 3744.00  | 1886.00  | 1040.00  | Adult Education Budget - Adult Skills Learner Support           | New          |             | 
    | 10017261 | AEBP-261       | AEBA-261      | 1               | 0                     | 27301.00  | 18864.00  | 8437.00   | 2785.00  | 2350.00  | 3655.00  | 3442.00  | 1362.00  | 2918.00  | 966.00   | 1386.00  | 1110.00  | 1940.00  | 2167.00  | 3220.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017261 | AEBP-261       | AEBR-261      | 1               | 0                     | 15926.00  | 11608.00  | 4318.00   | 759.00   | 863.00   | 1535.00  | 2237.00  | 1866.00  | 260.00   | 1377.00  | 2711.00  | 443.00   | 1812.00  | 1407.00  | 656.00   | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10017261 | AEBP-261       | AETL-261      | 1               | 0                     | 25471.00  | 17066.00  | 8405.00   | 3749.00  | 690.00   | 730.00   | 611.00   | 967.00   | 3601.00  | 3102.00  | 3616.00  | 2074.00  | 2998.00  | 2944.00  | 389.00   | Adult Education Budget - 19-24 Traineeships Learner Support     | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP-261       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-261' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-261'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-261' and actual ContractNumber 'AEBP-261'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-261' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017261 | AEBP-261           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017261 | ESFA-261           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'AEBP-261'

#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | AETL-261        | 2355875          | Jul-21 | Reconciliation |
#    | AEBR-261        | 2355800          | Jul-21 | Reconciliation |
#    | AEBA-261        | 2372010          | Jul-21 | Reconciliation |
#    | AEAL-261        | 2372175          | Jul-21 | Reconciliation |




    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '09/10/2020'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 Test' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | AEBP-261      | 1               | 0                  | 09/10/2020              | Inadequate Financial Health | Company insolvent                   |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | AEAL-261           | 25/09/2020                   | 02/10/2020                      |
    | AEBA-261           | 26/09/2020                   | 03/10/2020                      |
    | AEBR-261           | 23/09/2020                   | 30/09/2020                      |
    | AETL-261           | 28/09/2020                   | 05/10/2020                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017261 | AEBP-261       | 1                     | 0                        | 09/10/2020                 | Inadequate Financial Health  | ?                              | 09/10/2020              | Inadequate Financial Health | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017261 | AEBP-261      | AEAL-261         | 1                     | 0                        | 25/09/2020                   | 25/09/2020        | 02/10/2020                      | 02/10/2020           |
    | 10017261 | AEBP-261      | AEBA-261         | 1                     | 0                        | 26/09/2020                   | 26/09/2020        | 03/10/2020                      | 03/10/2020           |
    | 10017261 | AEBP-261      | AEBR-261         | 1                     | 0                        | 23/09/2020                   | 23/09/2020        | 30/09/2020                      | 30/09/2020           |
    | 10017261 | AEBP-261      | AETL-261         | 1                     | 0                        | 28/09/2020                   | 28/09/2020        | 05/10/2020                      | 05/10/2020           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract 'AEBP-261' for provider '10017261'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017261 - 10017261 Co Ltd     | AEBP-261       | FCS1 Test               | Contract Managers Team   | Open            | Not Started      |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'AEBP-261' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                             | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus        |
    | 10017261 | ESFA-261           | AEBP-261       | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval | FCS2 TEST             | Document Management Team  | Approved       | Approved                 |
    | 10017261 | ESFA-261           | AEBP-261       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                 | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider    |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-261' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Initiate Contract Termination                  | FCS8 TEST                     | Company insolvent                |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017261 | AEBP-261           | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017261 | ESFA-261           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |




    # Approve Termination Initiation (30635)

    # Change the date - CRM ignores this
    Given the override date is '10/10/2020'

    # Complete an existing open Task
    When the following open Task currently linked to version '1' of contract 'AEBP-261' for provider '10017261' is triggered by User 'FCS5 Test'
    | Task                                     | Owner                     |
    | Confirm Termination Initiation Approval  | FCS1 Test                 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017261 | AEBP-261           | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017261 | ESFA-261           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-261' for provider '10017261'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017261 - 10017261 Co Ltd     | AEBP-261       | FCS1 Test               | Contract Managers Team   | Completed       | Completed        |

    # Check the Termination details on the contract in CRM (These should not have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017261 | AEBP-261       | 1                     | 0                        | 09/10/2020                 | Inadequate Financial Health  | ?                              | 09/10/2020              | Inadequate Financial Health | ?                             |

    # Check the Termination details on the allocations in CRM (These should not have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017261 | AEBP-261      | AEAL-261         | 1                     | 0                        | 25/09/2020                   | 25/09/2020        | 02/10/2020                      | 02/10/2020           |
    | 10017261 | AEBP-261      | AEBA-261         | 1                     | 0                        | 26/09/2020                   | 26/09/2020        | 03/10/2020                      | 03/10/2020           |
    | 10017261 | AEBP-261      | AEBR-261         | 1                     | 0                        | 23/09/2020                   | 23/09/2020        | 30/09/2020                      | 30/09/2020           |
    | 10017261 | AEBP-261      | AETL-261         | 1                     | 0                        | 28/09/2020                   | 28/09/2020        | 05/10/2020                      | 05/10/2020           |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'AEBP-261' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                  | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017261 | ESFA-261           | AEBP-261       | 1                     | Termination Initiation Successful           | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Initiation Approval in Progress  |
    | 10017261 | ESFA-261           | AEBP-261       | 1                     | Approve Termination Initiation              | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Initiation Approval in Progress   | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Termination Initiation Approval     |
    | 10017261 | ESFA-261           | AEBP-261       | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval      | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017261 | ESFA-261           | AEBP-261       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                      | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-261' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Termination Initiation Successful              | CRM Integration               | ?                                |
    | Approve Termination Initiation                 | FCS5 TEST                     | ?                                |
    | Initiate Contract Termination                  | FCS8 TEST                     | Company insolvent                |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CM feed for the presence of a Contract Termination Initiation row (ItemType 4)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number 'AEBP-261'
    And   the ItemType '4' event for version '1' of actual contract number 'AEBP-261' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017261 | AEBP-261       | 1               | 0                  | 09/10/2020              | Inadequate Financial Health     | AEAL-261        | 25/09/2020            | 02/10/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 09/10/2020              | Inadequate Financial Health     | AEBA-261        | 26/09/2020            | 03/10/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 09/10/2020              | Inadequate Financial Health     | AEBR-261        | 23/09/2020            | 30/09/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 09/10/2020              | Inadequate Financial Health     | AETL-261        | 28/09/2020            | 05/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017261 | AEBP-261       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract AEBP-261:1.0 was placed under termination     |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017261 | AEBP-261       | 1               | 0                  | 09/10/2020              | Inadequate Financial Health     | AEAL-261        | 25/09/2020            | 02/10/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 09/10/2020              | Inadequate Financial Health     | AEBA-261        | 26/09/2020            | 03/10/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 09/10/2020              | Inadequate Financial Health     | AEBR-261        | 23/09/2020            | 30/09/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 09/10/2020              | Inadequate Financial Health     | AETL-261        | 28/09/2020            | 05/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017261 | AEBP-261       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract AEBP-261:1.0 was placed under termination     |




    # Update Termination Details (30638)

    # Change the date - CRM ignores this
    Given the override date is '11/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Update Termination Details - contract 
    #  (Add 2 days to the termination date, change reason from 'Inadequate Financial Health' to 'Inadequate Ofsted' and add a new comment)
    When  CRM user 'FCS8 TEST' updates contract termination details for Contract 'AEBP-261' Version '1' SubVersion '0' with the following options
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | TerminationComments                 |
    | AEBP-261      | 1               | 0                  | 11/10/2020              | Inadequate Ofsted           | Director in prison                  |

    # Update Termination Details - allocations 
    #  (Add 3 days to each of the dates)
    And   with the following updated allocation termination options
    | AllocationNumber   | AllocationStopNewStartsDate  | AllocationTerminationDate       |
    | AEAL-261           | 28/09/2020                   | 05/10/2020                      |
    | AEBA-261           | 29/09/2020                   | 06/10/2020                      |
    | AEBR-261           | 26/09/2020                   | 03/10/2020                      |
    | AETL-261           | 01/10/2020                   | 08/10/2020                      |

    # Use the SDK to submit a request to amend termination details
    And   the user completes the termination amendment request via SDK

    # Check the Termination details on the contract in CRM (These should have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017261 | AEBP-261       | 1                     | 0                        | 11/10/2020                 | Inadequate Ofsted            | ?                              | 11/10/2020              | Inadequate Ofsted           | ?                             |

    # Check the Termination details on the allocations in CRM (These should have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017261 | AEBP-261      | AEAL-261         | 1                     | 0                        | 28/09/2020                   | 28/09/2020        | 05/10/2020                      | 05/10/2020           |
    | 10017261 | AEBP-261      | AEBA-261         | 1                     | 0                        | 29/09/2020                   | 29/09/2020        | 06/10/2020                      | 06/10/2020           |
    | 10017261 | AEBP-261      | AEBR-261         | 1                     | 0                        | 26/09/2020                   | 26/09/2020        | 03/10/2020                      | 03/10/2020           |
    | 10017261 | AEBP-261      | AETL-261         | 1                     | 0                        | 01/10/2020                   | 01/10/2020        | 08/10/2020                      | 08/10/2020           |

    # Check the CONTRACT version, status and dates in CRM (These should not have changed)
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017261 | AEBP-261           | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017261 | ESFA-261           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'AEBP-261' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                  | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017261 | ESFA-261           | AEBP-261       | 1                     | Termination Details Update Successful       | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Details Update in Progress       |
    | 10017261 | ESFA-261           | AEBP-261       | 1                     | Update Termination Details                  | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Details Update in Progress        | FCS2 TEST             | FCS1 TEST                 | Approved       | Under Termination                            |
    | 10017261 | ESFA-261           | AEBP-261       | 1                     | Termination Initiation Successful           | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Initiation Approval in Progress  |
    | 10017261 | ESFA-261           | AEBP-261       | 1                     | Approve Termination Initiation              | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Initiation Approval in Progress   | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Termination Initiation Approval     |
    | 10017261 | ESFA-261           | AEBP-261       | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval      | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017261 | ESFA-261           | AEBP-261       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                      | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-261' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Termination Details Update Successful          | CRM Integration               | ?                                |
    | Update Termination Details                     | FCS8 TEST                     | Director in prison               |
    | Termination Initiation Successful              | CRM Integration               | ?                                |
    | Approve Termination Initiation                 | FCS5 TEST                     | ?                                |
    | Initiate Contract Termination                  | FCS8 TEST                     | Company insolvent                |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CM feed for the presence of a Contract Termination Details Updated row (ItemType 7)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '7' event for version '1' of actual contract number 'AEBP-261'
    And   the ItemType '7' event for version '1' of actual contract number 'AEBP-261' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017261 | AEBP-261       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AEAL-261        | 28/09/2020            | 05/10/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AEBA-261        | 29/09/2020            | 06/10/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AEBR-261        | 26/09/2020            | 03/10/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AETL-261        | 01/10/2020            | 08/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                        | Title                                                               |
    | 10017261 | AEBP-261       | 1               | 0                  | Contract Termination Details Updated | Termination details for a contract have been updated | Termination details for contract AEBP-261:1.0 have been updated     |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017261 | AEBP-261       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AEAL-261        | 28/09/2020            | 05/10/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AEBA-261        | 29/09/2020            | 06/10/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AEBR-261        | 26/09/2020            | 03/10/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AETL-261        | 01/10/2020            | 08/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                        | Title                                                               |
    | 10017261 | AEBP-261       | 1               | 0                  | Contract Termination Details Updated | Termination details for a contract have been updated | Termination details for contract AEBP-261:1.0 have been updated     |





   # Manager successfully COMPLETES the Termination (31411)

    # Change the date - CRM ignores this but it's used by .Net
    Given the override date is '12/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination
#   When  CRM user 'FCS1 TEST' completes the termination request for Contract 'AEBP-261' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS1 TEST' completes the termination request for Contract 'AEBP-261' Version '1' SubVersion '0' via SDK

    # Check the CONTRACT version, status and dates in CRM (These should not have changed)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017261 | AEBP-261       | 1                     | 0                        | Closed           | Terminated                               | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017261 | ESFA-261       | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'AEBP-261' includes the following
    | UKPRN    | ParentContract   | ContractNumber | ContractVersionNumber | Action                   | CompletedBy      | NewContractOwner | NewTaskOwner  | NewStatus         | NewSubStatus             | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus        |
    | 10017261 | ESFA-261         | AEBP-261       | 1                     | Termination Successful   | CRM Integration  | FCS2 TEST        | FCS1 TEST     | Closed            | Terminated               | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination in Progress  |
    | 10017261 | ESFA-261         | AEBP-261       | 1                     | Terminate Contract       | FCS1 TEST        | FCS2 TEST        | FCS1 TEST     | Approved          | Termination in Progress  | FCS2 TEST             | FCS1 TEST                 | Approved       | Under Termination        |


    # Check the CM feed for the presence of a Contract Terminated row (ItemType 6)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '6' event for version '1' of actual contract number 'AEBP-261'
    And   the ItemType '6' event for version '1' of actual contract number 'AEBP-261' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Terminated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017261 | AEBP-261       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AEAL-261        | 28/09/2020            | 05/10/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AEBA-261        | 29/09/2020            | 06/10/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AEBR-261        | 26/09/2020            | 03/10/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AETL-261        | 01/10/2020            | 08/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm            | CategoryLabel                   | Title                                      |
    | 10017261 | AEBP-261       | 1               | 0                  | Contract Terminated     | Contract has been terminated    | Contract AEBP-261:1.0 has been terminated  |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Terminated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017261 | AEBP-261       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AEAL-261        | 28/09/2020            | 05/10/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AEBA-261        | 29/09/2020            | 06/10/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AEBR-261        | 26/09/2020            | 03/10/2020                |
    | 10017261 | AEBP-261       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AETL-261        | 01/10/2020            | 08/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm            | CategoryLabel                   | Title                                      |
    | 10017261 | AEBP-261       | 1               | 0                  | Contract Terminated     | Contract has been terminated    | Contract AEBP-261:1.0 has been terminated  |


    # Tidy Up
    And   the override date is reset
 
@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run123
Scenario: A262 Create and approve a 2-alloc Levy contract. Initiate termination then approve the initiation. Update details then Complete Termination. Check CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017262' 
    And   there are no terminated or closed allocations for UKPRN '10017262' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017262' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017262' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017262' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017262' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017262' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017262' 
 
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
    | 10017262 | 
 
    # Add the provider to RoATP (ContractManagement.RoATPProvider) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017262 | 10017262 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 
 
 
 
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017262' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017262 Co Ltd' with UKPRN '10017262' and OrgId 'ORG0017262' and has 'FCS1 Test' as a manager 
 
    # Put data in the PaaS Organisation table (Organisation.Organisation) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017262 | 117262 | 10017262 Co Ltd | 0              | Locked Restructure    | Yes           | AA017262      | ?             | 2 Westbourne House     | Wheatlands Estate      | ?                      | ?                      | Heston                 | Middlesex              | TW5 0SA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017262 |

 
 
 
    # Change the date 
    Given the override date is '16/03/2020' 
 
    # Inject data into the stub to create a contract with two allocations 
   #And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation 
    And   the following Levy event data is available in the DAS agreement stub 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 62262 | INITIATED | 2019-12-15T18:03:12.2262 | 10017262   | 28262             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017262' 
    Then  there is only one Levy contract in CRM for UKPRN '10017262' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017262' for FundingType 'LEVY' and period '1799' 
 
 
 
 
 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017262 | 10017262 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017262 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017262 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017262 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017262 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017262 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017262 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017262 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    # Check deliverable period count prior to approval 
    And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
 
 
  
    # Change the date 
    Given the override date is '09/04/2020' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 
 
    # Check deliverable period count after approval 
    Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a Apr-20 deliverable period for each of deliverables 1 through 14 for each allocation 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Apr-20   | DeliverableDescription                               | 
    | 10017262 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017262 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017262 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017262 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017262 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017262 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017262 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017262 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017262 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017262 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017262 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017262 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017262 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017262 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
    # 
    | 10017262 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017262 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017262 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017262 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017262 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017262 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017262 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017262 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017262 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017262 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017262 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017262 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017262 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017262 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 
 
    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017262 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 09/04/2020        | ?               | ?             | 
    | 10017262 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
 
    # Check ALLOCATION dates in CRM 
    And   the following allocation values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | 
    | 10017262 | [ContractNo]       | 1                     | [AllocRef_LEVY]     | 09/04/2020          | ?                 | 
    | 10017262 | [ContractNo]       | 1                     | [AllocRef_NLA]      | 09/04/2020          | ?                 | 
 
 


    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '09/10/2020'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 Test' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | [ContractNo]  | 1               | 0                  | 09/10/2020              | Provider in Administration  | Police involvement                  |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | [AllocRef_LEVY]    | 22/09/2020                   | 29/09/2020                      |
    | [AllocRef_NLA]     | 27/09/2020                   | 04/10/2020                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017262 | [ContractNo]   | 1                     | 0                        | 09/10/2020                 | Provider in Administration   | ?                              | 09/10/2020              | Provider in Administration  | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017262 | [ContractNo]  | [AllocRef_LEVY]  | 1                     | 0                        | 22/09/2020                   | 22/09/2020        | 29/09/2020                      | 29/09/2020           |
    | 10017262 | [ContractNo]  | [AllocRef_NLA]   | 1                     | 0                        | 27/09/2020                   | 27/09/2020        | 04/10/2020                      | 04/10/2020           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017262'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017262 - 10017262 Co Ltd     | [ContractNo]   | Contract Managers Team    | ?                        | Open            | Not Started      |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017262 | [MasterContractNo] | [ContractNo]   | 1                     | Initiate Contract Termination               | FCS8 TEST                     | ?                | Contract Managers Team      | Approved          | Awaiting Termination Initiation Approval     | ?                     | CRM Integration           | Approved       | Approved                                     |
    | 10017262 | [MasterContractNo] | [ContractNo]   | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | ?                | CRM Integration             | Approved          | Approved                                     | ?                     | CRM Integration           | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Initiate Contract Termination                  | FCS8 TEST                     | Police involvement               |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017262 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017262 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |




    # Approve Termination Initiation (30635)

    # Change the date - CRM ignores this
    Given the override date is '10/10/2020'

    # Complete an existing open Task
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017262' is triggered by User 'FCS5 Test'
    | Task                                     | Owner                     |
    | Confirm Termination Initiation Approval  | Contract Managers Team    |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017262 | [ContractNo]       | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017262 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017262'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017262 - 10017262 Co Ltd     | [ContractNo]   | Contract Managers Team  | ?                        | Completed       | Completed        |

    # Check the Termination details on the contract in CRM (These should not have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017262 | [ContractNo]   | 1                     | 0                        | 09/10/2020                 | Provider in Administration   | ?                              | 09/10/2020              | Provider in Administration  | ?                             |

    # Check the Termination details on the allocations in CRM (These should not have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017262 | [ContractNo]  | [AllocRef_LEVY]  | 1                     | 0                        | 22/09/2020                   | 22/09/2020        | 29/09/2020                      | 29/09/2020           |
    | 10017262 | [ContractNo]  | [AllocRef_NLA]   | 1                     | 0                        | 27/09/2020                   | 27/09/2020        | 04/10/2020                      | 04/10/2020           |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017262 | [MasterContractNo] | [ContractNo]   | 1                     | Termination Initiation Successful           | CRM Integration               | ?                | Contract Managers Team      | Approved          | Under Termination                            | ?                     | Contract Managers Team    | Approved       | Termination Initiation Approval in Progress  |
    | 10017262 | [MasterContractNo] | [ContractNo]   | 1                     | Approve Termination Initiation              | FCS5 TEST                     | ?                | Contract Managers Team      | Approved          | Termination Initiation Approval in Progress  | ?                     | Contract Managers Team    | Approved       | Awaiting Termination Initiation Approval     |
    | 10017262 | [MasterContractNo] | [ContractNo]   | 1                     | Initiate Contract Termination               | FCS8 TEST                     | ?                | Contract Managers Team      | Approved          | Awaiting Termination Initiation Approval     | ?                     | CRM Integration           | Approved       | Approved                                     |
    | 10017262 | [MasterContractNo] | [ContractNo]   | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | ?                | CRM Integration             | Approved          | Approved                                     | ?                     | CRM Integration           | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Termination Initiation Successful              | CRM Integration               | ?                                |
    | Approve Termination Initiation                 | FCS5 TEST                     | ?                                |
    | Initiate Contract Termination                  | FCS8 TEST                     | Police involvement               |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CM feed for the presence of a Contract Termination Initiation row (ItemType 4)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number '[ContractNo]'
    And   the ItemType '4' event for version '1' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017262 | [ContractNo]   | 1               | 0                  | 09/10/2020              | Provider in Administration      | [AllocRef_LEVY] | 22/09/2020            | 29/09/2020                |
    | 10017262 | [ContractNo]   | 1               | 0                  | 09/10/2020              | Provider in Administration      | [AllocRef_NLA]  | 27/09/2020            | 04/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017262 | [ContractNo]   | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract [ContractNo]:1.0 was placed under termination |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017262 | [ContractNo]   | 1               | 0                  | 09/10/2020              | Provider in Administration      | [AllocRef_LEVY] | 22/09/2020            | 29/09/2020                |
    | 10017262 | [ContractNo]   | 1               | 0                  | 09/10/2020              | Provider in Administration      | [AllocRef_NLA]  | 27/09/2020            | 04/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017262 | [ContractNo]   | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract [ContractNo]:1.0 was placed under termination |




    # Update Termination Details (30638)

    # Change the date - CRM ignores this
    Given the override date is '11/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Update Termination Details - contract 
    #  (Add 2 days to the termination date, change reason from 'Provider in Administration' to 'Inadequate Ofsted' and add a new comment)
    When  CRM user 'FCS8 TEST' updates contract termination details for Contract '[ContractNo]' Version '1' SubVersion '0' with the following options
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | TerminationComments                 |
    | [ContractNo]  | 1               | 0                  | 11/10/2020              | Inadequate Ofsted           | Director in prison                  |

    # Update Termination Details - allocations 
    #  (Add 3 days to each of the dates)
    And   with the following updated allocation termination options
    | AllocationNumber   | AllocationStopNewStartsDate  | AllocationTerminationDate       |
    | [AllocRef_LEVY]    | 25/09/2020                   | 02/10/2020                      |
    | [AllocRef_NLA]     | 29/09/2020                   | 06/10/2020                      |

    # Use the SDK to submit a request to amend termination details
    And   the user completes the termination amendment request via SDK

    # Check the Termination details on the contract in CRM (These should have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017262 | [ContractNo]   | 1                     | 0                        | 11/10/2020                 | Inadequate Ofsted            | ?                              | 11/10/2020              | Inadequate Ofsted           | ?                             |

    # Check the Termination details on the allocations in CRM (These should have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017262 | [ContractNo]  | [AllocRef_LEVY]  | 1                     | 0                        | 25/09/2020                   | 25/09/2020        | 02/10/2020                      | 02/10/2020           |
    | 10017262 | [ContractNo]  | [AllocRef_NLA]   | 1                     | 0                        | 29/09/2020                   | 29/09/2020        | 06/10/2020                      | 06/10/2020           |

    # Check the CONTRACT version, status and dates in CRM (These should not have changed)
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017262 | [ContractNo]       | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 09/04/2020        | ?               | ?             |
    | 10017262 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017262 | [MasterContractNo] | [ContractNo]   | 1                     | Termination Details Update Successful       | CRM Integration               | ?                | Contract Managers Team      | Approved          | Under Termination                            | ?                     | Contract Managers Team    | Approved       | Termination Details Update in Progress       |
    | 10017262 | [MasterContractNo] | [ContractNo]   | 1                     | Update Termination Details                  | FCS8 TEST                     | ?                | Contract Managers Team      | Approved          | Termination Details Update in Progress       | ?                     | Contract Managers Team    | Approved       | Under Termination                            |
    | 10017262 | [MasterContractNo] | [ContractNo]   | 1                     | Termination Initiation Successful           | CRM Integration               | ?                | Contract Managers Team      | Approved          | Under Termination                            | ?                     | Contract Managers Team    | Approved       | Termination Initiation Approval in Progress  |
    | 10017262 | [MasterContractNo] | [ContractNo]   | 1                     | Approve Termination Initiation              | FCS5 TEST                     | ?                | Contract Managers Team      | Approved          | Termination Initiation Approval in Progress  | ?                     | Contract Managers Team    | Approved       | Awaiting Termination Initiation Approval     |
    | 10017262 | [MasterContractNo] | [ContractNo]   | 1                     | Initiate Contract Termination               | FCS8 TEST                     | ?                | Contract Managers Team      | Approved          | Awaiting Termination Initiation Approval     | ?                     | CRM Integration           | Approved       | Approved                                     |
    | 10017262 | [MasterContractNo] | [ContractNo]   | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | ?                | CRM Integration             | Approved          | Approved                                     | ?                     | CRM Integration           | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Termination Details Update Successful          | CRM Integration               | ?                                |
    | Update Termination Details                     | FCS8 TEST                     | Director in prison               |
    | Termination Initiation Successful              | CRM Integration               | ?                                |
    | Approve Termination Initiation                 | FCS5 TEST                     | ?                                |
    | Initiate Contract Termination                  | FCS8 TEST                     | Police involvement               |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CM feed for the presence of a Contract Termination Details Updated row (ItemType 7)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '7' event for version '1' of actual contract number '[ContractNo]'
    And   the ItemType '7' event for version '1' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017262 | [ContractNo]   | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | [AllocRef_LEVY] | 25/09/2020            | 02/10/2020                |
    | 10017262 | [ContractNo]   | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | [AllocRef_NLA]  | 29/09/2020            | 06/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                        | Title                                                                   |
    | 10017262 | [ContractNo]   | 1               | 0                  | Contract Termination Details Updated | Termination details for a contract have been updated | Termination details for contract [ContractNo]:1.0 have been updated     |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017262 | [ContractNo]   | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | [AllocRef_LEVY] | 25/09/2020            | 02/10/2020                |
    | 10017262 | [ContractNo]   | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | [AllocRef_NLA]  | 29/09/2020            | 06/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                        | Title                                                                   |
    | 10017262 | [ContractNo]   | 1               | 0                  | Contract Termination Details Updated | Termination details for a contract have been updated | Termination details for contract [ContractNo]:1.0 have been updated     |




    # Amend and approve the contract by bulk and singleton menthods (31895)

    # Bulk

    # Change the date
    Given the override date is '15/10/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Issue a contract amendment request on v1 to create v2. This should succeed
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status    | SubStatus          | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017262 | [MasterContractNo]   | [ContractNo]   | 1       | Approved  | Under Termination  | Notification  | No                       | Yes                   | Yes                          | 

    # Check the CONTRACT version, status and dates in CRM. Contract should auto-approve
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus     | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017262 | [ContractNo]       | 2                     | 0                        | Approved         | Under Termination     | True          | True                | 09/04/2020        | ?               | Notification  |
    | 10017262 | [ContractNo]       | 1                     | 0                        | Replaced         | Under Termination     | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017262 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                     | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the Termination details on the contract in CRM have been carried forward
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017262 | [ContractNo]   | 2                     | 0                        | 11/10/2020                 | Inadequate Ofsted            | ?                              | 11/10/2020              | Inadequate Ofsted           | ?                             |

    # Check the Termination details on the allocations in CRM have been carried forward
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017262 | [ContractNo]  | [AllocRef_LEVY]  | 2                     | 0                        | 25/09/2020                   | 25/09/2020        | 02/10/2020                      | 02/10/2020           |
    | 10017262 | [ContractNo]  | [AllocRef_NLA]   | 2                     | 0                        | 29/09/2020                   | 29/09/2020        | 06/10/2020                      | 06/10/2020           |


    # Singleton

    # Change the date
    Given the override date is '18/10/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Issue a contract amendment request on v2 to create v3. This should succeed
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status    | SubStatus          | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017262 | [MasterContractNo]   | [ContractNo]   | 2       | Approved  | Under Termination  | Notification  | No                       | Yes                   | Yes                          | 

    # Check the CONTRACT version, status and dates in CRM. Contract should auto-approve
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus     | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017262 | [ContractNo]       | 3                     | 0                        | Approved         | Under Termination     | True          | True                | 09/04/2020        | ?               | Notification  |
    | 10017262 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination     | False         | False               | 09/04/2020        | ?               | Notification  |
    | 10017262 | [ContractNo]       | 1                     | 0                        | Replaced         | Under Termination     | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017262 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                     | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the Termination details on the contract in CRM (Version change and details c/f)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017262 | [ContractNo]   | 3                     | 0                        | 11/10/2020                 | Inadequate Ofsted            | ?                              | 11/10/2020              | Inadequate Ofsted           | ?                             |

    # Check the Termination details on the allocations in CRM (Version change and details c/f)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017262 | [ContractNo]  | [AllocRef_LEVY]  | 3                     | 0                        | 25/09/2020                   | 25/09/2020        | 02/10/2020                      | 02/10/2020           |
    | 10017262 | [ContractNo]  | [AllocRef_NLA]   | 3                     | 0                        | 29/09/2020                   | 29/09/2020        | 06/10/2020                      | 06/10/2020           |





    # Manager successfully COMPLETES the Termination (31411)

    # Change the date - CRM ignores this but it's used by .Net
    Given the override date is '22/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination
#   When  CRM user 'FCS1 TEST' completes the termination request for Contract '[ContractNo]' Version '3' SubVersion '0' via UI
    When  CRM user 'FCS1 TEST' completes the termination request for Contract '[ContractNo]' Version '3' SubVersion '0' via SDK

    # Check the CONTRACT version, status and dates in CRM. Contract should auto-approve
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus     | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017262 | [ContractNo]       | 3                     | 0                        | Closed           | Terminated            | True          | True                | 09/04/2020        | 11/10/2020      | Notification  |
    | 10017262 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination     | False         | False               | 09/04/2020        | ?               | Notification  |
    | 10017262 | [ContractNo]       | 1                     | 0                        | Replaced         | Under Termination     | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017262 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                     | False         | False               | 01/05/2017        | ?               | ?             |

#    # Check the CONTRACT version, status and dates in CRM 
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10017262 | [ContractNo]       | 1                     | 0                        | Closed           | Terminated         | True          | True                | 09/04/2020        | 11/10/2020      | ?             |
#    | 10017262 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                  | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the Termination details on the contract in CRM (Version change and details c/f)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017262 | [ContractNo]   | 3                     | 0                        | 11/10/2020                 | Inadequate Ofsted            | ?                              | 11/10/2020              | Inadequate Ofsted           | ?                             |

    # Check the Termination details on the allocations in CRM (Version change and details c/f)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017262 | [ContractNo]  | [AllocRef_LEVY]  | 3                     | 0                        | 25/09/2020                   | 25/09/2020        | 02/10/2020                      | 02/10/2020           |
    | 10017262 | [ContractNo]  | [AllocRef_NLA]   | 3                     | 0                        | 29/09/2020                   | 29/09/2020        | 06/10/2020                      | 06/10/2020           |

    # Check the contents of the Workflow History
    Then  the Workflow History for version '3' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                 | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017262 | [MasterContractNo] | [ContractNo]   | 3                     | Termination Successful                      | CRM Integration               | ?                | Contract Managers Team      | Closed            | Terminated                                   | ?                     | Contract Managers Team    | Approved       | Termination in Progress                      |
    | 10017262 | [MasterContractNo] | [ContractNo]   | 3                     | Terminate Contract                          | FCS1 TEST                     | ?                | Contract Managers Team      | Approved          | Termination in Progress                      | ?                     | Contract Managers Team    | Approved       | Under Termination                            |

    # Check the CM feed for the presence of a Contract Terminated row (ItemType 6)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '6' event for version '3' of actual contract number '[ContractNo]'
    And   the ItemType '6' event for version '3' of actual contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Terminated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017262 | [ContractNo]   | 3               | 0                  | 11/10/2020              | Inadequate Ofsted               | [AllocRef_LEVY] | 25/09/2020            | 02/10/2020                |
    | 10017262 | [ContractNo]   | 3               | 0                  | 11/10/2020              | Inadequate Ofsted               | [AllocRef_NLA]  | 29/09/2020            | 06/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                | Title                                            |
    | 10017262 | [ContractNo]   | 3               | 0                  | Contract Terminated                  | Contract has been terminated                 | Contract [ContractNo]:3.0 has been terminated    |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Terminated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017262 | [ContractNo]   | 3               | 0                  | 11/10/2020              | Inadequate Ofsted               | [AllocRef_LEVY] | 25/09/2020            | 02/10/2020                |
    | 10017262 | [ContractNo]   | 3               | 0                  | 11/10/2020              | Inadequate Ofsted               | [AllocRef_NLA]  | 29/09/2020            | 06/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                | Title                                            |
    | 10017262 | [ContractNo]   | 3               | 0                  | Contract Terminated                  | Contract has been terminated                 | Contract [ContractNo]:3.0 has been terminated    |


    # Tidy Up
    And   the override date is reset
  
@AcceptanceTest @Withdrawn20231002
Scenario: A263 Create and approve a 3-alloc 2021 EDSK contract with 2 Delivery Orgs. Initiate termination then approve the initiation. Update details then Complete Termination. Check CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017263' 
    And   there are no terminated or closed allocations for UKPRN '10017263' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017263' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017263' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-2631     |
    | AECS-2631     |
    | AECT-2631     |
    | 16TR-2632     |
    | AECS-2632     |
    | AECT-2632     |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-2631     |
    | AECS-2631     |
    | AECT-2631     |
    | 16TR-2632     |
    | AECS-2632     |
    | AECT-2632     |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2021      |
    | AEBC-19TRN2021    |
    | AEBC-CSO2021      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-263       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017263'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017263' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017263 Co Ltd' with UKPRN '10017263' and OrgId 'ORG0017263' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017263' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status  | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017263 | 117263 | 10017263 Co Ltd | 0              | Active  | Yes           | AA017263      | ?             | 35 Mosbach Gardens     | Hutton                 | ?                      | ?                      | Brentwood              | Essex                  | CM13 2UW  |
    | 10000527 | 100527 | 10000527 Co Ltd | 0              | Active  | Yes           | AA000527      | ?             | March Buildings North  | 8 Brook Street         | High Street North      | Ledsham                | Ellesmere Port         | Merseyside             | CH66 4TT  |
    | 10000528 | 100528 | 10000528 Co Ltd | 0              | Active  | Yes           | AA000528      | ?             | March Buildings South  | 8 Brook Street         | High Street North      | Ledsham                | Ellesmere Port         | Merseyside             | CH66 4TT  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017263 |
    | 10000527 |
    | 10000528 |


    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017263 | 10017263 Co Ltd      | ESFA-263             | EDSK-263       | 1                     | 01/08/2020        | 31/07/2021      | 197132.00     |                       | Conditions of Funding (Grant) (College)    | 2021   | New          | ORG0017263 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName     | UoPCode    | AllocationDescription    | CRMIntent    | DeliveryOrg |
    | 10017263 | EDSK-263       | 16TR-2631     | 16-18TRN          | 16-18TRN2021            | AY                      | 01/08/2020          | 31/07/2021        | 53368.00        |             |            |                          | New          | 10000527    |
    | 10017263 | EDSK-263       | AECS-2631     | AEBC-CSO          | AEBC-CSO2021            | AY                      | 01/08/2020          | 31/07/2021        | 22574.00        |             |            |                          | New          | 10000527    |
    | 10017263 | EDSK-263       | AECT-2631     | AEBC-19TRN        | AEBC-19TRN2021          | AY                      | 01/08/2020          | 31/07/2021        | 22834.00        |             |            |                          | New          | 10000527    |
    #
    | 10017263 | EDSK-263       | 16TR-2632     | 16-18TRN          | 16-18TRN2021            | AY                      | 01/08/2020          | 31/07/2021        | 46399.00        |             |            |                          | New          | 10000528    |
    | 10017263 | EDSK-263       | AECS-2632     | AEBC-CSO          | AEBC-CSO2021            | AY                      | 01/08/2020          | 31/07/2021        | 25338.00        |             |            |                          | New          | 10000528    |
    | 10017263 | EDSK-263       | AECT-2632     | AEBC-19TRN        | AEBC-19TRN2021          | AY                      | 01/08/2020          | 31/07/2021        | 26619.00        |             |            |                          | New          | 10000528    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017263 | EDSK-263       | 16TR-2631     | 1               | 0                     | 53368.00  | 36203.00  | 17165.00  | 3950.00  | 4286.00  | 3510.00  | 3872.00  | 3541.00  | 6500.00  | 3288.00  | 7256.00  | 788.00   | 6371.00  | 4425.00  | 5581.00  | Total 16-18 Traineeships Funding                                | New          | 10000527    | 
    | 10017263 | EDSK-263       | 16TR-2631     | 2               | 1                     | 26906.00  | 18741.00  | 8165.00   | 2907.00  | 3391.00  | 204.00   | 1381.00  | 3288.00  | 3233.00  | 679.00   | 3658.00  | 155.00   | 3263.00  | 1341.00  | 3406.00  | 16-18 Traineeships Programme Funding                            | New          | 10000527    | 
    | 10017263 | EDSK-263       | 16TR-2631     | 3               | 1                     | 26462.00  | 17462.00  | 9000.00   | 1043.00  | 895.00   | 3306.00  | 2491.00  | 253.00   | 3267.00  | 2609.00  | 3598.00  | 633.00   | 3108.00  | 3084.00  | 2175.00  | 16-18 Traineeships Bursary Funding                              | New          | 10000527    | 
    | 10017263 | EDSK-263       | AECS-2631     | 1               | 0                     | 22574.00  | 16759.00  | 5815.00   | 328.00   | 2265.00  | 2873.00  | 67.00    | 2068.00  | 3466.00  | 1989.00  | 3703.00  | 1277.00  | 2137.00  | 1292.00  | 1109.00  | COVID-19 Skills Offer Total Funding                             | New          | 10000527    | 
    | 10017263 | EDSK-263       | AECS-2631     | 2               | 1                     | 22574.00  | 16759.00  | 5815.00   | 328.00   | 2265.00  | 2873.00  | 67.00    | 2068.00  | 3466.00  | 1989.00  | 3703.00  | 1277.00  | 2137.00  | 1292.00  | 1109.00  | High Value Courses for School and College Leavers Funding       | New          | 10000527    | 
    | 10017263 | EDSK-263       | AECT-2631     | 1               | 0                     | 22834.00  | 13810.00  | 9024.00   | 2267.00  | 3572.00  | 3359.00  | 1279.00  | 118.00   | 884.00   | 1304.00  | 1027.00  | 1857.00  | 3067.00  | 3137.00  | 963.00   | 19-24 Traineeships Total Funding                                | New          | 10000527    | 
    #
    | 10017263 | EDSK-263       | 16TR-2632     | 1               | 0                     | 46399.00  | 34275.00  | 12124.00  | 3885.00  | 3964.00  | 3727.00  | 4439.00  | 2303.00  | 5990.00  | 7017.00  | 2950.00  | 5782.00  | 1973.00  | 564.00   | 3805.00  | Total 16-18 Traineeships Funding                                | New          | 10000528    | 
    | 10017263 | EDSK-263       | 16TR-2632     | 2               | 1                     | 20932.00  | 15462.00  | 5470.00   | 1291.00  | 1459.00  | 2922.00  | 1252.00  | 1577.00  | 2566.00  | 3302.00  | 1093.00  | 2052.00  | 1143.00  | 169.00   | 2106.00  | 16-18 Traineeships Programme Funding                            | New          | 10000528    | 
    | 10017263 | EDSK-263       | 16TR-2632     | 3               | 1                     | 25467.00  | 18813.00  | 6654.00   | 2594.00  | 2505.00  | 805.00   | 3187.00  | 726.00   | 3424.00  | 3715.00  | 1857.00  | 3730.00  | 830.00   | 395.00   | 1699.00  | 16-18 Traineeships Bursary Funding                              | New          | 10000528    | 
    | 10017263 | EDSK-263       | AECS-2632     | 1               | 0                     | 25338.00  | 16259.00  | 9079.00   | 1618.00  | 3239.00  | 1095.00  | 2844.00  | 2281.00  | 2004.00  | 2834.00  | 344.00   | 1396.00  | 2923.00  | 2044.00  | 2716.00  | COVID-19 Skills Offer Total Funding                             | New          | 10000528    | 
    | 10017263 | EDSK-263       | AECS-2632     | 2               | 1                     | 25338.00  | 16259.00  | 9079.00   | 1618.00  | 3239.00  | 1095.00  | 2844.00  | 2281.00  | 2004.00  | 2834.00  | 344.00   | 1396.00  | 2923.00  | 2044.00  | 2716.00  | High Value Courses for School and College Leavers Funding       | New          | 10000528    | 
    | 10017263 | EDSK-263       | AECT-2632     | 1               | 0                     | 26619.00  | 17692.00  | 8927.00   | 1792.00  | 1421.00  | 3517.00  | 3650.00  | 2267.00  | 3699.00  | 384.00   | 962.00   | 211.00   | 2464.00  | 3106.00  | 3146.00  | 19-24 Traineeships Total Funding                                | New          | 10000528    | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-263       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-263' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-263'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-263' and actual ContractNumber 'EDSK-263'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-263' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017263 | EDSK-263           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017263 | ESFA-263           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '240' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '240' deliverable period rows in CRM linked to the latest version of contract 'EDSK-263'
  
#   # Check that the CRM subnominals have been created before moving on
#   And   CRM subnominals have been created for the following allocations
#   | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#   | 16TR-2631       | 2201300          | Jul-21 | Reconciliation |
#   | AECT-2631       | 2355775          | Jul-21 | Reconciliation |
#   | AECS-2631       | 2372091          | Jul-21 | Profile        |
#   | 16TR-2632       | 2201300          | Jul-21 | Reconciliation |
#   | AECT-2632       | 2355775          | Jul-21 | Reconciliation |
#   | AECS-2632       | 2372091          | Jul-21 | Profile        |




    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '09/10/2020'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 Test' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | EDSK-263      | 1               | 0                  | 09/10/2020              | Provider in Administration  | Company insolvent                   |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | 16TR-2631          | 23/09/2020                   | 01/10/2020                      |
    | AECS-2631          | 25/09/2020                   | 02/10/2020                      |
    | AECT-2631          | 27/09/2020                   | 04/10/2020                      |
    #
    | 16TR-2632          | 26/09/2020                   | 03/10/2020                      |
    | AECS-2632          | 28/09/2020                   | 05/10/2020                      |
    | AECT-2632          | 29/09/2020                   | 06/10/2020                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017263 | EDSK-263       | 1                     | 0                        | 09/10/2020                 | Provider in Administration   | ?                              | 09/10/2020              | Provider in Administration  | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017263 | EDSK-263      | 16TR-2631        | 1                     | 0                        | 23/09/2020                   | 23/09/2020        | 01/10/2020                      | 01/10/2020           |
    | 10017263 | EDSK-263      | AECS-2631        | 1                     | 0                        | 25/09/2020                   | 25/09/2020        | 02/10/2020                      | 02/10/2020           |
    | 10017263 | EDSK-263      | AECT-2631        | 1                     | 0                        | 27/09/2020                   | 27/09/2020        | 04/10/2020                      | 04/10/2020           |
    #
    | 10017263 | EDSK-263      | 16TR-2632        | 1                     | 0                        | 26/09/2020                   | 26/09/2020        | 03/10/2020                      | 03/10/2020           |
    | 10017263 | EDSK-263      | AECS-2632        | 1                     | 0                        | 28/09/2020                   | 28/09/2020        | 05/10/2020                      | 05/10/2020           |
    | 10017263 | EDSK-263      | AECT-2632        | 1                     | 0                        | 29/09/2020                   | 29/09/2020        | 06/10/2020                      | 06/10/2020           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract 'EDSK-263' for provider '10017263'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017263 - 10017263 Co Ltd     | EDSK-263       | FCS1 Test               | Contract Managers Team   | Open            | Not Started      |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'EDSK-263' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                             | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus        |
    | 10017263 | ESFA-263           | EDSK-263       | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval | FCS2 TEST             | Document Management Team  | Approved       | Approved                 |
    | 10017263 | ESFA-263           | EDSK-263       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                 | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider    |

    # Check the Workflow History comments 
    And   the workflow history on contract 'EDSK-263' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Initiate Contract Termination                  | FCS8 TEST                     | Company insolvent                |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017263 | EDSK-263           | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017263 | ESFA-263           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |




    # Approve Termination Initiation (30635)

    # Change the date - CRM ignores this
    Given the override date is '10/10/2020'

    # Complete an existing open Task
    When the following open Task currently linked to version '1' of contract 'EDSK-263' for provider '10017263' is triggered by User 'FCS5 Test'
    | Task                                     | Owner                     |
    | Confirm Termination Initiation Approval  | FCS1 Test                 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017263 | EDSK-263           | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017263 | ESFA-263           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract 'EDSK-263' for provider '10017263'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017263 - 10017263 Co Ltd     | EDSK-263       | FCS1 Test               | Contract Managers Team   | Completed       | Completed        |

    # Check the Termination details on the contract in CRM (These should not have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017263 | EDSK-263       | 1                     | 0                        | 09/10/2020                 | Provider in Administration   | ?                              | 09/10/2020              | Provider in Administration  | ?                             |

    # Check the Termination details on the allocations in CRM (These should not have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017263 | EDSK-263      | 16TR-2631        | 1                     | 0                        | 23/09/2020                   | 23/09/2020        | 01/10/2020                      | 01/10/2020           |
    | 10017263 | EDSK-263      | AECS-2631        | 1                     | 0                        | 25/09/2020                   | 25/09/2020        | 02/10/2020                      | 02/10/2020           |
    | 10017263 | EDSK-263      | AECT-2631        | 1                     | 0                        | 27/09/2020                   | 27/09/2020        | 04/10/2020                      | 04/10/2020           |
    #
    | 10017263 | EDSK-263      | 16TR-2632        | 1                     | 0                        | 26/09/2020                   | 26/09/2020        | 03/10/2020                      | 03/10/2020           |
    | 10017263 | EDSK-263      | AECS-2632        | 1                     | 0                        | 28/09/2020                   | 28/09/2020        | 05/10/2020                      | 05/10/2020           |
    | 10017263 | EDSK-263      | AECT-2632        | 1                     | 0                        | 29/09/2020                   | 29/09/2020        | 06/10/2020                      | 06/10/2020           |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'EDSK-263' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                  | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017263 | ESFA-263           | EDSK-263       | 1                     | Termination Initiation Successful           | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Initiation Approval in Progress  |
    | 10017263 | ESFA-263           | EDSK-263       | 1                     | Approve Termination Initiation              | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Initiation Approval in Progress   | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Termination Initiation Approval     |
    | 10017263 | ESFA-263           | EDSK-263       | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval      | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017263 | ESFA-263           | EDSK-263       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                      | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'EDSK-263' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Termination Initiation Successful              | CRM Integration               | ?                                |
    | Approve Termination Initiation                 | FCS5 TEST                     | ?                                |
    | Initiate Contract Termination                  | FCS8 TEST                     | Company insolvent                |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CM feed for the presence of a Contract Termination Initiation row (ItemType 4)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number 'EDSK-263'
    And   the ItemType '4' event for version '1' of actual contract number 'EDSK-263' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017263 | EDSK-263       | 1               | 0                  | 09/10/2020              | Provider in Administration      | 16TR-2631       | 23/09/2020            | 01/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 09/10/2020              | Provider in Administration      | AECS-2631       | 25/09/2020            | 02/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 09/10/2020              | Provider in Administration      | AECT-2631       | 27/09/2020            | 04/10/2020                |
    #
    | 10017263 | EDSK-263       | 1               | 0                  | 09/10/2020              | Provider in Administration      | 16TR-2632       | 26/09/2020            | 03/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 09/10/2020              | Provider in Administration      | AECS-2632       | 28/09/2020            | 05/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 09/10/2020              | Provider in Administration      | AECT-2632       | 29/09/2020            | 06/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017263 | EDSK-263       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract EDSK-263:1.0 was placed under termination     |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017263 | EDSK-263       | 1               | 0                  | 09/10/2020              | Provider in Administration      | 16TR-2631       | 23/09/2020            | 01/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 09/10/2020              | Provider in Administration      | AECS-2631       | 25/09/2020            | 02/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 09/10/2020              | Provider in Administration      | AECT-2631       | 27/09/2020            | 04/10/2020                |
    #
    | 10017263 | EDSK-263       | 1               | 0                  | 09/10/2020              | Provider in Administration      | 16TR-2632       | 26/09/2020            | 03/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 09/10/2020              | Provider in Administration      | AECS-2632       | 28/09/2020            | 05/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 09/10/2020              | Provider in Administration      | AECT-2632       | 29/09/2020            | 06/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017263 | EDSK-263       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract EDSK-263:1.0 was placed under termination     |




    # Update Termination Details (30638)

    # Change the date - CRM ignores this
    Given the override date is '11/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Update Termination Details - contract 
    #  (Add 2 days to the termination date, change reason from 'Provider in Administration' to 'Inadequate Ofsted' and add a new comment)
    When  CRM user 'FCS8 TEST' updates contract termination details for Contract 'EDSK-263' Version '1' SubVersion '0' with the following options
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | TerminationComments                 |
    | EDSK-263      | 1               | 0                  | 11/10/2020              | Inadequate Ofsted           | Provider request                    |

    # Update Termination Details - allocations 
    #  (Add 3 days to each of the dates)
    And   with the following updated allocation termination options
    | AllocationNumber   | AllocationStopNewStartsDate  | AllocationTerminationDate       |
    | 16TR-2631          | 30/09/2020                   | 07/10/2020                      |
    | AECS-2631          | 28/09/2020                   | 05/10/2020                      |
    | AECT-2631          | 30/09/2020                   | 07/10/2020                      |
    #
    | 16TR-2632          | 29/09/2020                   | 06/10/2020                      |
    | AECS-2632          | 01/10/2020                   | 08/10/2020                      |
    | AECT-2632          | 02/10/2020                   | 09/10/2020                      |

    # Use the SDK to submit a request to amend termination details
    And   the user completes the termination amendment request via SDK

    # Check the Termination details on the contract in CRM (These should have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017263 | EDSK-263       | 1                     | 0                        | 11/10/2020                 | Inadequate Ofsted            | ?                              | 11/10/2020              | Inadequate Ofsted           | ?                             |

    # Check the Termination details on the allocations in CRM (These should have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017263 | EDSK-263      | 16TR-2631        | 1                     | 0                        | 30/09/2020                   | 30/09/2020        | 07/10/2020                      | 07/10/2020           |
    | 10017263 | EDSK-263      | AECS-2631        | 1                     | 0                        | 28/09/2020                   | 28/09/2020        | 05/10/2020                      | 05/10/2020           |
    | 10017263 | EDSK-263      | AECT-2631        | 1                     | 0                        | 30/09/2020                   | 30/09/2020        | 07/10/2020                      | 07/10/2020           |
    #
    | 10017263 | EDSK-263      | 16TR-2632        | 1                     | 0                        | 29/09/2020                   | 29/09/2020        | 06/10/2020                      | 06/10/2020           |
    | 10017263 | EDSK-263      | AECS-2632        | 1                     | 0                        | 01/10/2020                   | 01/10/2020        | 08/10/2020                      | 08/10/2020           |
    | 10017263 | EDSK-263      | AECT-2632        | 1                     | 0                        | 02/10/2020                   | 02/10/2020        | 09/10/2020                      | 09/10/2020           |

    # Check the CONTRACT version, status and dates in CRM (These should not have changed)
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017263 | EDSK-263           | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017263 | ESFA-263           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'EDSK-263' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                  | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017263 | ESFA-263           | EDSK-263       | 1                     | Termination Details Update Successful       | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Details Update in Progress       |
    | 10017263 | ESFA-263           | EDSK-263       | 1                     | Update Termination Details                  | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Details Update in Progress        | FCS2 TEST             | FCS1 TEST                 | Approved       | Under Termination                            |
    | 10017263 | ESFA-263           | EDSK-263       | 1                     | Termination Initiation Successful           | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Initiation Approval in Progress  |
    | 10017263 | ESFA-263           | EDSK-263       | 1                     | Approve Termination Initiation              | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Initiation Approval in Progress   | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Termination Initiation Approval     |
    | 10017263 | ESFA-263           | EDSK-263       | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval      | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017263 | ESFA-263           | EDSK-263       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                      | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'EDSK-263' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Termination Details Update Successful          | CRM Integration               | ?                                |
    | Update Termination Details                     | FCS8 TEST                     | Provider request                 |
    | Termination Initiation Successful              | CRM Integration               | ?                                |
    | Approve Termination Initiation                 | FCS5 TEST                     | ?                                |
    | Initiate Contract Termination                  | FCS8 TEST                     | Company insolvent                |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CM feed for the presence of a Contract Termination Details Updated (ItemType 7)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '7' event for version '1' of actual contract number 'EDSK-263'
    And   the ItemType '7' event for version '1' of actual contract number 'EDSK-263' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | 16TR-2631       | 30/09/2020            | 07/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AECS-2631       | 28/09/2020            | 05/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AECT-2631       | 30/09/2020            | 07/10/2020                |
    #
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | 16TR-2632       | 29/09/2020            | 06/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AECS-2632       | 01/10/2020            | 08/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AECT-2632       | 02/10/2020            | 09/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                        | Title                                                               |
    | 10017263 | EDSK-263       | 1               | 0                  | Contract Termination Details Updated | Termination details for a contract have been updated | Termination details for contract EDSK-263:1.0 have been updated     |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | 16TR-2631       | 30/09/2020            | 07/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AECS-2631       | 28/09/2020            | 05/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AECT-2631       | 30/09/2020            | 07/10/2020                |
    #
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | 16TR-2632       | 29/09/2020            | 06/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AECS-2632       | 01/10/2020            | 08/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AECT-2632       | 02/10/2020            | 09/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                        | Title                                                               |
    | 10017263 | EDSK-263       | 1               | 0                  | Contract Termination Details Updated | Termination details for a contract have been updated | Termination details for contract EDSK-263:1.0 have been updated     |




   # Manager successfully COMPLETES the Termination (31411)

    # Change the date - CRM ignores this but it's used by .Net
    Given the override date is '12/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination
#   When  CRM user 'FCS1 TEST' completes the termination request for Contract 'EDSK-263' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS1 TEST' completes the termination request for Contract 'EDSK-263' Version '1' SubVersion '0' via SDK

    # Check the CONTRACT version, status and dates in CRM (These should not have changed)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017263 | EDSK-263       | 1                     | 0                        | Closed           | Terminated                               | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017263 | ESFA-263       | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'EDSK-263' includes the following
    | UKPRN    | ParentContract   | ContractNumber | ContractVersionNumber | Action                   | CompletedBy      | NewContractOwner | NewTaskOwner  | NewStatus         | NewSubStatus             | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus        |
    | 10017263 | ESFA-263         | EDSK-263       | 1                     | Termination Successful   | CRM Integration  | FCS2 TEST        | FCS1 TEST     | Closed            | Terminated               | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination in Progress  |
    | 10017263 | ESFA-263         | EDSK-263       | 1                     | Terminate Contract       | FCS1 TEST        | FCS2 TEST        | FCS1 TEST     | Approved          | Termination in Progress  | FCS2 TEST             | FCS1 TEST                 | Approved       | Under Termination        |


    # Check the CM feed for the presence of a Contract Terminated row (ItemType 6)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '6' event for version '1' of actual contract number 'EDSK-263'
    And   the ItemType '6' event for version '1' of actual contract number 'EDSK-263' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Terminated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | 16TR-2631       | 30/09/2020            | 07/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AECS-2631       | 28/09/2020            | 05/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AECT-2631       | 30/09/2020            | 07/10/2020                |
    #
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | 16TR-2632       | 29/09/2020            | 06/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AECS-2632       | 01/10/2020            | 08/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AECT-2632       | 02/10/2020            | 09/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm            | CategoryLabel                   | Title                                      |
    | 10017263 | EDSK-263       | 1               | 0                  | Contract Terminated     | Contract has been terminated    | Contract EDSK-263:1.0 has been terminated  |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Terminated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | 16TR-2631       | 30/09/2020            | 07/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AECS-2631       | 28/09/2020            | 05/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AECT-2631       | 30/09/2020            | 07/10/2020                |
    #
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | 16TR-2632       | 29/09/2020            | 06/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AECS-2632       | 01/10/2020            | 08/10/2020                |
    | 10017263 | EDSK-263       | 1               | 0                  | 11/10/2020              | Inadequate Ofsted               | AECT-2632       | 02/10/2020            | 09/10/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm            | CategoryLabel                   | Title                                      |
    | 10017263 | EDSK-263       | 1               | 0                  | Contract Terminated     | Contract has been terminated    | Contract EDSK-263:1.0 has been terminated  |


    # Tidy Up
    And   the override date is reset
 
@AcceptanceTest @Withdrawn20231002
Scenario: A264 Create and approve a 16-18FU2021 contract. Initiate termination then approve the initiation. Update details then Complete Termination. Check CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017264' 
    And   there are no terminated or closed allocations for UKPRN '10017264' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017264' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017264' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16FU-264      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16FU-264      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18FU2021       |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | 1618FU-264     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017264'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017264' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017264 Co Ltd' with UKPRN '10017264' and OrgId 'ORG0017264' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017264' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017264 | 117264 | 10017264 Co Ltd | 0              | Active                | Yes           | AA017264      | ?             | 5 Chiswick High Road   | London                 | ?                      | ?                      | ?                      | ?                      | W4 5RG    |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017264 |




    # Change the date
    Given the override date is '01/03/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017264 | 10017264 Co Ltd      | ESFA-264             | 1618FU-264     | 1                     | 01/04/2020        | 31/03/2021      | 7311.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017264 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017264 | 1618FU-264     | 16FU-264      | 16-18FU           | 16-18FU2021             | FY                      | 01/04/2020          | 31/03/2021        | 7311.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017264 | 1618FU-264     | 16FU-264      | 1               | 0                     | 7311.00   | 0.00     | 0.00     | 1642.00  | 0.00     | 0.00     | 985.00   | 0.00     | 0.00     | 1974.00  | 0.00     | 0.00     | 2710.00  | 16-18 Education at an Adolescent Forensic Unit                  | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 1618FU-264     | 1                     | 0                        | 2020-03-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract '1618FU-264' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '1618FU-264'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-264' and actual ContractNumber '1618FU-264'

    # Check that the contract is now approved
    Then  the latest version of contract '1618FU-264' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017264 | 1618FU-264         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017264 | ESFA-264           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract '1618FU-264'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 16FU-264        | 2430670          | Mar-21 | Profile        |




    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '08/10/2020'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 Test' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | 1618FU-264    | 1               | 0                  | 08/10/2020              | Serious Breach              | ?                                   |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | 16FU-264           | 20/09/2020                   | 27/09/2020                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017264 | 1618FU-264     | 1                     | 0                        | 08/10/2020                 | Serious Breach               | ?                              | 08/10/2020              | Serious Breach              | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017264 | 1618FU-264    | 16FU-264         | 1                     | 0                        | 20/09/2020                   | 20/09/2020        | 27/09/2020                      | 27/09/2020           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract '1618FU-264' for provider '10017264'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017264 - 10017264 Co Ltd     | 1618FU-264     | FCS1 Test               | Contract Managers Team   | Open            | Not Started      |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract '1618FU-264' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                             | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus        |
    | 10017264 | ESFA-264           | 1618FU-264     | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval | FCS2 TEST             | Document Management Team  | Approved       | Approved                 |
    | 10017264 | ESFA-264           | 1618FU-264     | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                 | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider    |

    # Check the Workflow History comments 
    And   the workflow history on contract '1618FU-264' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Initiate Contract Termination                  | FCS8 TEST                     | ?                                |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017264 | 1618FU-264         | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017264 | ESFA-264           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |




    # Approve Termination Initiation (30635)

    # Change the date - CRM ignores this
    Given the override date is '09/10/2020'

    # Complete an existing open Task
    When the following open Task currently linked to version '1' of contract '1618FU-264' for provider '10017264' is triggered by User 'FCS5 Test'
    | Task                                     | Owner      |
    | Confirm Termination Initiation Approval  | FCS1 Test  |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017264 | 1618FU-264         | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017264 | ESFA-264           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract '1618FU-264' for provider '10017264'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017264 - 10017264 Co Ltd     | 1618FU-264     | FCS1 Test               | Contract Managers Team   | Completed       | Completed        |

    # Check the Termination details on the contract in CRM (These should not have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017264 | 1618FU-264     | 1                     | 0                        | 08/10/2020                 | Serious Breach               | ?                              | 08/10/2020              | Serious Breach              | ?                             |

    # Check the Termination details on the allocations in CRM (These should not have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017264 | 1618FU-264    | 16FU-264         | 1                     | 0                        | 20/09/2020                   | 20/09/2020        | 27/09/2020                      | 27/09/2020           |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract '1618FU-264' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                  | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017264 | ESFA-264           | 1618FU-264     | 1                     | Termination Initiation Successful           | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Initiation Approval in Progress  |
    | 10017264 | ESFA-264           | 1618FU-264     | 1                     | Approve Termination Initiation              | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Initiation Approval in Progress   | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Termination Initiation Approval     |
    | 10017264 | ESFA-264           | 1618FU-264     | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval      | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017264 | ESFA-264           | 1618FU-264     | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                      | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract '1618FU-264' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Termination Initiation Successful              | CRM Integration               | ?                                |
    | Approve Termination Initiation                 | FCS5 TEST                     | ?                                |
    | Initiate Contract Termination                  | FCS8 TEST                     | ?                                |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CM feed for the presence of a Contract Termination Initiation row (ItemType 4)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number '1618FU-264'
    And   the ItemType '4' event for version '1' of actual contract number '1618FU-264' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017264 | 1618FU-264     | 1               | 0                  | 08/10/2020              | Serious Breach                  | 16FU-264        | 20/09/2020            | 27/09/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017264 | 1618FU-264     | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract 1618FU-264:1.0 was placed under termination   |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017264 | 1618FU-264     | 1               | 0                  | 08/10/2020              | Serious Breach                  | 16FU-264        | 20/09/2020            | 27/09/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017264 | 1618FU-264     | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract 1618FU-264:1.0 was placed under termination   |




    # Update Termination Details (30638)

    # Change the date - CRM ignores this
    Given the override date is '10/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Update Termination Details - contract 
    #  (Add 2 days to the termination date, change reason from 'Serious Breach' to 'Notice from Provider' and add a new comment)
    When  CRM user 'FCS8 TEST' updates contract termination details for Contract '1618FU-264' Version '1' SubVersion '0' with the following options
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | TerminationComments                 |
    | 1618FU-264    | 1               | 0                  | 10/10/2020              | Notice from Provider        | Company struck off                  |

    # Update Termination Details - allocations 
    #  (Add 3 days to each of the dates)
    And   with the following updated allocation termination options
    | AllocationNumber   | AllocationStopNewStartsDate  | AllocationTerminationDate       |
    | 16FU-264           | 23/09/2020                   | 30/09/2020                      |

    # Use the SDK to submit a request to amend termination details
    And   the user completes the termination amendment request via SDK

    # Check the Termination details on the contract in CRM (These should have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017264 | 1618FU-264     | 1                     | 0                        | 10/10/2020                 | Notice from Provider         | ?                              | 10/10/2020              | Notice from Provider        | ?                             |

    # Check the Termination details on the allocations in CRM (These should have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017264 | 1618FU-264    | 16FU-264         | 1                     | 0                        | 23/09/2020                   | 23/09/2020        | 30/09/2020                      | 30/09/2020           |

    # Check the CONTRACT version, status and dates in CRM (These should not have changed)
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017264 | 1618FU-264         | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017264 | ESFA-264           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract '1618FU-264' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                  | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017264 | ESFA-264           | 1618FU-264     | 1                     | Termination Details Update Successful       | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Details Update in Progress       |
    | 10017264 | ESFA-264           | 1618FU-264     | 1                     | Update Termination Details                  | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Details Update in Progress        | FCS2 TEST             | FCS1 TEST                 | Approved       | Under Termination                            |
    | 10017264 | ESFA-264           | 1618FU-264     | 1                     | Termination Initiation Successful           | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Initiation Approval in Progress  |
    | 10017264 | ESFA-264           | 1618FU-264     | 1                     | Approve Termination Initiation              | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Initiation Approval in Progress   | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Termination Initiation Approval     |
    | 10017264 | ESFA-264           | 1618FU-264     | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval      | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017264 | ESFA-264           | 1618FU-264     | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                      | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract '1618FU-264' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Termination Details Update Successful          | CRM Integration               | ?                                |
    | Update Termination Details                     | FCS8 TEST                     | Company struck off               |
    | Termination Initiation Successful              | CRM Integration               | ?                                |
    | Approve Termination Initiation                 | FCS5 TEST                     | ?                                |
    | Initiate Contract Termination                  | FCS8 TEST                     | ?                                |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CM feed for the presence of a Contract Termination Details Updated row (ItemType 7)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '7' event for version '1' of actual contract number '1618FU-264'
    And   the ItemType '7' event for version '1' of actual contract number '1618FU-264' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017264 | 1618FU-264     | 1               | 0                  | 10/10/2020              | Notice from Provider            | 16FU-264        | 23/09/2020            | 30/09/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                        | Title                                                               |
    | 10017264 | 1618FU-264     | 1               | 0                  | Contract Termination Details Updated | Termination details for a contract have been updated | Termination details for contract 1618FU-264:1.0 have been updated   |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    Then  the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017264 | 1618FU-264     | 1               | 0                  | 10/10/2020              | Notice from Provider            | 16FU-264        | 23/09/2020            | 30/09/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                        | Title                                                               |
    | 10017264 | 1618FU-264     | 1               | 0                  | Contract Termination Details Updated | Termination details for a contract have been updated | Termination details for contract 1618FU-264:1.0 have been updated   |




   # Manager successfully COMPLETES the Termination (31411)

    # Change the date - CRM ignores this but it's used by .Net
    Given the override date is '12/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination
#   When  CRM user 'FCS1 TEST' completes the termination request for Contract '1618FU-264' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS1 TEST' completes the termination request for Contract '1618FU-264' Version '1' SubVersion '0' via SDK

    # Check the CONTRACT version, status and dates in CRM (These should not have changed)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017264 | 1618FU-264     | 1                     | 0                        | Closed           | Terminated                               | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017264 | ESFA-264       | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract '1618FU-264' includes the following
    | UKPRN    | ParentContract   | ContractNumber | ContractVersionNumber | Action                   | CompletedBy      | NewContractOwner | NewTaskOwner  | NewStatus         | NewSubStatus             | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus        |
    | 10017264 | ESFA-264         | 1618FU-264     | 1                     | Termination Successful   | CRM Integration  | FCS2 TEST        | FCS1 TEST     | Closed            | Terminated               | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination in Progress  |
    | 10017264 | ESFA-264         | 1618FU-264     | 1                     | Terminate Contract       | FCS1 TEST        | FCS2 TEST        | FCS1 TEST     | Approved          | Termination in Progress  | FCS2 TEST             | FCS1 TEST                 | Approved       | Under Termination        |


    # Check the CM feed for the presence of a Contract Terminated row (ItemType 6)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '6' event for version '1' of actual contract number '1618FU-264'
    And   the ItemType '6' event for version '1' of actual contract number '1618FU-264' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Terminated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017264 | 1618FU-264     | 1               | 0                  | 10/10/2020              | Notice from Provider            | 16FU-264        | 23/09/2020            | 30/09/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm            | CategoryLabel                   | Title                                        |
    | 10017264 | 1618FU-264     | 1               | 0                  | Contract Terminated     | Contract has been terminated    | Contract 1618FU-264:1.0 has been terminated  |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Terminated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017264 | 1618FU-264     | 1               | 0                  | 10/10/2020              | Notice from Provider            | 16FU-264        | 23/09/2020            | 30/09/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm            | CategoryLabel                   | Title                                        |
    | 10017264 | 1618FU-264     | 1               | 0                  | Contract Terminated     | Contract has been terminated    | Contract 1618FU-264:1.0 has been terminated  |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20240103
Scenario: A265 Create and approve an ESF contract. Initiate termination then approve the initiation. Update details then Complete termination. Check CRM and feed along the way
    Given there are no allocations marked as Under Termination for UKPRN '10017265' 
    And   there are no terminated or closed allocations for UKPRN '10017265' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017265' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017265' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ESF-265       |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ESF-265       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ESF1420           |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | ESIF-265       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017265'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017265' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017265 Co Ltd' with UKPRN '10017265' and OrgId 'ORG0017265' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017265' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017265 | 117265 | 10017265 Co Ltd | 0              | Active                | Yes           | AA017265      | ?             | 49 Fife Road           | Kingston               | ?                      | ?                      | ?                      | Surrey                 | KT1 1SF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017265 |




    # Change the date
    Given the override date is '01/03/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017265 | 10017265 Co Ltd      | ESFA-265             | ESIF-265       | 1                     | 01/04/2020        | 31/03/2021      | 318486.00     | ESF Contract                          | Contract for Services                      | 1420   | New          | ORG0017265 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                             | AgreementNumber | ActivityDescription                | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017265 | ESIF-265       | ESF-265       | ESF 201420        | ESF1420                 | ESF                     | 01/04/2020          | 31/03/2021        | 318486.00       |                                         |            | ESF Allocation                                              | New          | West of England LEP                         | E37037       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017265    | 1.2 Sustainable integration of young people    | 111\SD\7265     | Support for the Unemployed         | SSW Skills            | Transition     | 1.09                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017265 | ESIF-265       | ESF-265       | 5               | 0                     | 24689.00  | 2386.00  | 3532.00  | 93.00    | 290.00   | 3398.00  | 1476.00  | 2559.00  | 2030.00  | 898.00   | 3310.00  | 3478.00  | 1239.00  | AC01 Actual Costs                                               | New          |             | 
    | 10017265 | ESIF-265       | ESF-265       | 7               | 0                     | 14608.00  | 2272.00  | 794.00   | 2509.00  | 83.00    | 1926.00  | 98.00    | 898.00   | 463.00   | 1768.00  | 572.00   | 2193.00  | 1032.00  | CG02 Community Grant Management Cost                            | New          |             | 
    | 10017265 | ESIF-265       | ESF-265       | 14              | 0                     | 38493.00  | 1880.00  | 3337.00  | 2162.00  | 2491.00  | 4606.00  | 3666.00  | 3431.00  | 2914.00  | 4465.00  | 4183.00  | 1786.00  | 3572.00  | SD07 Specification Defined Deliverable (with Description)       | New          |             | 
    | 10017265 | ESIF-265       | ESF-265       | 18              | 0                     | 87016.00  | 3358.00  | 4526.00  | 8030.00  | 10658.00 | 2774.00  | 6132.00  | 2920.00  | 12702.00 | 6424.00  | 12118.00 | 11680.00 | 5694.00  | PG01 Progression Paid Employment (EMP)                          | New          |             | 
    | 10017265 | ESIF-265       | ESF-265       | 19              | 0                     | 53550.00  | 1700.00  | 7310.00  | 7905.00  | 4080.00  | 7990.00  | 1870.00  | 1020.00  | 3740.00  | 3230.00  | 6630.00  | 2210.00  | 5865.00  | PG02 Progression Unpaid Employment (VOL)                        | New          |             | 
    | 10017265 | ESIF-265       | ESF-265       | 25              | 0                     | 72447.00  | 9594.00  | 1968.00  | 5166.00  | 6888.00  | 7134.00  | 9225.00  | 3075.00  | 1968.00  | 8241.00  | 8733.00  | 4551.00  | 5904.00  | SU02 Sustained Unpaid Employment 3 Months                       | New          |             | 
    | 10017265 | ESIF-265       | ESF-265       | 31              | 0                     | 27683.00  | 3760.00  | 2068.00  | 1692.00  | 1739.00  | 1598.00  | 2021.00  | 752.00   | 4465.00  | 799.00   | 3290.00  | 1222.00  | 4277.00  | SU13 Sustained Education 6 Months                               | New          |             | 

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | 
    | 10017265 | ESIF-265       | ESF-265       | 14              | 47       | 819     | 40       | 71       | 46       | 53       | 98       | 78       | 73       | 62       | 95       | 89       | 38       | 76       |
    | 10017265 | ESIF-265       | ESF-265       | 18              | 146      | 596     | 23       | 31       | 55       | 73       | 19       | 42       | 20       | 87       | 44       | 83       | 80       | 39       |
    | 10017265 | ESIF-265       | ESF-265       | 19              | 85       | 630     | 20       | 86       | 93       | 48       | 94       | 22       | 12       | 44       | 38       | 78       | 26       | 69       |
    | 10017265 | ESIF-265       | ESF-265       | 25              | 123      | 589     | 78       | 16       | 42       | 56       | 58       | 75       | 25       | 16       | 67       | 71       | 37       | 48       |
    | 10017265 | ESIF-265       | ESF-265       | 31              | 47       | 589     | 80       | 44       | 36       | 37       | 34       | 43       | 16       | 95       | 17       | 70       | 26       | 91       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | ESIF-265       | 1                     | 0                        | 2020-03-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'ESIF-265' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'ESIF-265'

    # Change the date
    Given the override date is '11/03/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-265' and actual ContractNumber 'ESIF-265'

    # Check that the contract is now approved
    Then  the latest version of contract 'ESIF-265' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017265 | ESIF-265           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017265 | ESFA-265           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '84' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '84' deliverable period rows in CRM linked to the latest version of contract 'ESIF-265'




    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '27/09/2020'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | ESIF-265      | 1               | 0                  | 27/09/2020              | Provider in Liquidation     | Suspected fraud                     |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | ESF-265            | 29/08/2020                   | 05/09/2020                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017265 | ESIF-265       | 1                     | 0                        | 27/09/2020                 | Provider in Liquidation      | ?                              | 27/09/2020              | Provider in Liquidation     | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017265 | ESIF-265      | ESF-265          | 1                     | 0                        | 29/08/2020                   | 29/08/2020        | 05/09/2020                      | 05/09/2020           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract 'ESIF-265' for provider '10017265'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017265 - 10017265 Co Ltd     | ESIF-265       | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'ESIF-265' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                             | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus        |
    | 10017265 | ESFA-265           | ESIF-265       | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval | FCS2 TEST             | Document Management Team  | Approved       | Approved                 |
    | 10017265 | ESFA-265           | ESIF-265       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                 | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider    |

    # Check the Workflow History comments 
    And   the workflow history on contract 'ESIF-265' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Initiate Contract Termination                  | FCS8 TEST                     | Suspected fraud                  |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017265 | ESIF-265           | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017265 | ESFA-265           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |




    # Approve Termination Initiation (30635)

    # Change the date - CRM ignores this
    Given the override date is '28/09/2020'

    # Complete an existing open Task
    When the following open Task currently linked to version '1' of contract 'ESIF-265' for provider '10017265' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Termination Initiation Approval  | FCS1 TEST                 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017265 | ESIF-265           | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017265 | ESFA-265           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract 'ESIF-265' for provider '10017265'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017265 - 10017265 Co Ltd     | ESIF-265       | FCS1 TEST               | Contract Managers Team   | Completed       | Completed        |

    # Check the Termination details on the contract in CRM (These should not have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017265 | ESIF-265       | 1                     | 0                        | 27/09/2020                 | Provider in Liquidation      | ?                              | 27/09/2020              | Provider in Liquidation     | ?                             |

    # Check the Termination details on the allocations in CRM (These should not have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017265 | ESIF-265      | ESF-265          | 1                     | 0                        | 29/08/2020                   | 29/08/2020        | 05/09/2020                      | 05/09/2020           |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'ESIF-265' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                  | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017265 | ESFA-265           | ESIF-265       | 1                     | Termination Initiation Successful           | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Initiation Approval in Progress  |
    | 10017265 | ESFA-265           | ESIF-265       | 1                     | Approve Termination Initiation              | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Initiation Approval in Progress   | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Termination Initiation Approval     |
    | 10017265 | ESFA-265           | ESIF-265       | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval      | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017265 | ESFA-265           | ESIF-265       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                      | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'ESIF-265' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Termination Initiation Successful              | CRM Integration               | ?                                |
    | Approve Termination Initiation                 | FCS5 TEST                     | ?                                |
    | Initiate Contract Termination                  | FCS8 TEST                     | Suspected fraud                  |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CM feed for the presence of a Contract Termination Initiation row (ItemType 4)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '4' event for version '1' of actual contract number 'ESIF-265'
    And   the ItemType '4' event for version '1' of actual contract number 'ESIF-265' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017265 | ESIF-265       | 1               | 0                  | 27/09/2020              | Provider in Liquidation         | ESF-265         | 29/08/2020            | 05/09/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017265 | ESIF-265       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract ESIF-265:1.0 was placed under termination     |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Initiated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017265 | ESIF-265       | 1               | 0                  | 27/09/2020              | Provider in Liquidation         | ESF-265         | 29/08/2020            | 05/09/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                   | CategoryLabel                                | Title                                                  |
    | 10017265 | ESIF-265       | 1               | 0                  | Contract Termination Initiated | A contract has been placed under termination | Contract ESIF-265:1.0 was placed under termination     |




    # Update Termination Details (30638)

    # Change the date - CRM ignores this
    Given the override date is '29/09/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Update Termination Details - contract 
    #  (Add 2 days to the termination date, change reason from 'Provider in Liquidation' to 'Notice from Provider' and add a new comment)
    When  CRM user 'FCS8 TEST' updates contract termination details for Contract 'ESIF-265' Version '1' SubVersion '0' with the following options
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | TerminationComments                 |
    | ESIF-265      | 1               | 0                  | 29/09/2020              | Notice from Provider        | Director in prison                  |

    # Update Termination Details - allocations 
    #  (Add 3 days to each of the dates)
    And   with the following updated allocation termination options
    | AllocationNumber   | AllocationStopNewStartsDate  | AllocationTerminationDate       |
    | ESF-265            | 01/09/2020                   | 08/09/2020                      |

    # Use the SDK to submit a request to amend termination details
    And   the user completes the termination amendment request via SDK

    # Check the Termination details on the contract in CRM (These should have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017265 | ESIF-265       | 1                     | 0                        | 29/09/2020                 | Notice from Provider         | ?                              | 29/09/2020              | Notice from Provider        | ?                             |

    # Check the Termination details on the allocations in CRM (These should have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017265 | ESIF-265      | ESF-265          | 1                     | 0                        | 01/09/2020                   | 01/09/2020        | 08/09/2020                      | 08/09/2020           |

    # Check the CONTRACT version, status and dates in CRM (These should not have changed)
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017265 | ESIF-265           | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017265 | ESFA-265           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'ESIF-265' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                  | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017265 | ESFA-265           | ESIF-265       | 1                     | Termination Details Update Successful       | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Details Update in Progress       |
    | 10017265 | ESFA-265           | ESIF-265       | 1                     | Update Termination Details                  | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Details Update in Progress        | FCS2 TEST             | FCS1 TEST                 | Approved       | Under Termination                            |
    | 10017265 | ESFA-265           | ESIF-265       | 1                     | Termination Initiation Successful           | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Initiation Approval in Progress  |
    | 10017265 | ESFA-265           | ESIF-265       | 1                     | Approve Termination Initiation              | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Initiation Approval in Progress   | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Termination Initiation Approval     |
    | 10017265 | ESFA-265           | ESIF-265       | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval      | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017265 | ESFA-265           | ESIF-265       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                      | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'ESIF-265' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Termination Details Update Successful          | CRM Integration               | ?                                |
    | Update Termination Details                     | FCS8 TEST                     | Director in prison               |
    | Termination Initiation Successful              | CRM Integration               | ?                                |
    | Approve Termination Initiation                 | FCS5 TEST                     | ?                                |
    | Initiate Contract Termination                  | FCS8 TEST                     | Suspected fraud                  |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CM feed for the presence of a Contract Termination Details Updated row (ItemType 7)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '7' event for version '1' of actual contract number 'ESIF-265'
    And   the ItemType '7' event for version '1' of actual contract number 'ESIF-265' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017265 | ESIF-265       | 1               | 0                  | 29/09/2020              | Notice from Provider            | ESF-265         | 01/09/2020            | 08/09/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                        | Title                                                               |
    | 10017265 | ESIF-265       | 1               | 0                  | Contract Termination Details Updated | Termination details for a contract have been updated | Termination details for contract ESIF-265:1.0 have been updated     |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Termination Details Updated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017265 | ESIF-265       | 1               | 0                  | 29/09/2020              | Notice from Provider            | ESF-265         | 01/09/2020            | 08/09/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                        | Title                                                               |
    | 10017265 | ESIF-265       | 1               | 0                  | Contract Termination Details Updated | Termination details for a contract have been updated | Termination details for contract ESIF-265:1.0 have been updated     |




    # Manager attempts to COMPLETE termination while month-end is running: FAIL  (31411)

    # Change the date - CRM ignores this but it's used by .Net
    Given the override date is '30/09/2020'

    # Delete any termination failure notifications
    And   there are no notifications of type 'Contract Termination Failed'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'True'

    # Manager COMPLETES termination
#   When  CRM user 'FCS1 TEST' completes the termination request for Contract 'ESIF-265' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS1 TEST' completes the termination request for Contract 'ESIF-265' Version '1' SubVersion '0' via SDK

    # Check the CONTRACT version, status and dates in CRM (These should not have changed)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus            | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017265 | ESIF-265           | 1                     | 0                        | Approved         | Under Termination            | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017265 | ESFA-265           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'ESIF-265' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                  | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017265 | ESFA-265           | ESIF-265       | 1                     | Contract Termination Failed                 | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination in Progress                      |
    | 10017265 | ESFA-265           | ESIF-265       | 1                     | Terminate Contract                          | FCS1 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination in Progress                       | FCS2 TEST             | FCS1 TEST                 | Approved       | Under Termination                            |

    # Check that NOTIFICATION is being generated
    And   there is '1' notification of type 'Contract Termination Failed' owned by user 'FCS1 TEST' which matches the following
    | Status | NotificationName                        | NotificationText                                                                                                                                 |
    | New    | Contract Termination Failed - ESIF-265  | Contract ESIF-265 v1 for provider 10017265 (10017265 Co Ltd) cannot be terminated - month-end processing is in progress - please try again later |




    # Manager successfully COMPLETES the Termination (31411)

    # Change the date - CRM ignores this but it's used by .Net
    Given the override date is '01/10/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination
#   When  CRM user 'FCS1 TEST' completes the termination request for Contract 'ESIF-265' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS1 TEST' completes the termination request for Contract 'ESIF-265' Version '1' SubVersion '0' via SDK

    # Check the CONTRACT version, status and dates in CRM (These should not have changed)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017265 | ESIF-265           | 1                     | 0                        | Closed           | Terminated                               | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017265 | ESFA-265           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'ESIF-265' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                  | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017265 | ESFA-265           | ESIF-265       | 1                     | Termination Successful                      | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Closed            | Terminated                                    | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination in Progress                      |
    | 10017265 | ESFA-265           | ESIF-265       | 1                     | Terminate Contract                          | FCS1 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination in Progress                       | FCS2 TEST             | FCS1 TEST                 | Approved       | Under Termination                            |


    # Check the CM feed for the presence of a Contract Terminated row (ItemType 6)
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '6' event for version '1' of actual contract number 'ESIF-265'
    And   the ItemType '6' event for version '1' of actual contract number 'ESIF-265' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Use the latest Corporate Contract schema to check the ALLCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'ALLCONTRACT' feed includes category 'Contract Terminated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017265 | ESIF-265       | 1               | 0                  | 29/09/2020              | Notice from Provider            | ESF-265         | 01/09/2020            | 08/09/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'ALLCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                        | Title                                                               |
    | 10017265 | ESIF-265       | 1               | 0                  | Contract Terminated                  | Contract has been terminated                 | Contract ESIF-265:1.0 has been terminated                           |

    # Use the latest Corporate Contract schema to check the APPROVALONWARDSCONTRACT CM feed for specific items and values related to the termination
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes category 'Contract Terminated' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate |
    | 10017265 | ESIF-265       | 1               | 0                  | 29/09/2020              | Notice from Provider            | ESF-265         | 01/09/2020            | 08/09/2020                |

    # Check the CM feed event header information
    And   the Contract Management 'APPROVALONWARDSCONTRACT' feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                         | CategoryLabel                                        | Title                                                               |
    | 10017265 | ESIF-265       | 1               | 0                  | Contract Terminated                  | Contract has been terminated                 | Contract ESIF-265:1.0 has been terminated                           |



    # Tidy Up
    And   the override date is reset

