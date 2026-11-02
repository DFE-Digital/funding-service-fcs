Feature: UnStickFCR 35862

@AcceptanceTest @Manual
Scenario: A119 Create and approve an AEBP2021 contract. Import 2021 Funding Claim. Complete termination > Closed\Terminated. Fail to publish FCR. 

    # 1. Create and approve a 2021 AEBP contract for 10045119 with AEBA, AEBR and AETL allocations
    # 2. Create and consume a Funding Claim for AEB-19TRLS2021
    # 3. Terminate the contract > Closed\Terminated 
    # 4. Attempte to publish the FCR. This should get stuck at Draft\Publish in Progress

    Given there are no allocations marked as Under Termination for UKPRN '10045119' 
    And   there are no terminated or closed allocations for UKPRN '10045119' 
    And   there is no Contract, Task or Workflow data for UKPRN '10045119' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10045119' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10045119' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-1881     |
    | AEBR-1369     |
    | AETL-1368     |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-1881     |
    | AEBR-1369     |
    | AETL-1368     |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-19TRLS2021    |
    | AEB-19TRN2021     |
    | AEB-AS2021        |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-2760       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10045119'

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AETL-1368     |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10045119' 
    And   there is no caseload advisor for UKPRN '10045119' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10045119 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10045119' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'VSS TRAINING AND DEVELOPMENT LIMITED' with UKPRN '10045119' and OrgId 'ORG0045119' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                                  | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10045119 | 145119 | VSS TRAINING AND DEVELOPMENT LIMITED  | 0              | In Administration     | Yes           | AA045119      | ?             | 241 High Street        | ?                      | ?                      | ?                      | Waltham Cross          | Hertfordshire          | EN8 7BE   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10045119 |





    # Part 1: Create and approve a 2021 AEBP contract for 10045119 with AEBA, AEBR and AETL allocations
    
    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP-2760'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP-2760'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName                             | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10045119 | VSS TRAINING AND DEVELOPMENT LIMITED  | ESFA-11464           | AEBP-2760      | 1                     | 01/08/2020        | 31/07/2021      | 59388.00      |                                       | Procured                                   | 2021   | New          | ORG0045119 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10045119 | AEBP-2760      | AEBA-1881     | AEB-AS            | AEB-AS2021              | AY                      | 01/08/2020          | 31/07/2021        | 18952.00        |                                         |            |                                                             | New          |             |
    | 10045119 | AEBP-2760      | AEBR-1369     | AEB-19TRN         | AEB-19TRN2021           | AY                      | 01/08/2020          | 31/07/2021        | 21119.00        |                                         |            |                                                             | New          |             |
    | 10045119 | AEBP-2760      | AETL-1368     | AEB-19TRLS        | AEB-19TRLS2021          | AY                      | 01/08/2020          | 31/07/2021        | 19317.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10045119 | AEBP-2760      | AEBA-1881     | 1               | 0                     | 18952.00  | 11674.00  | 7278.00   | 3476.00  | 763.00   | 1499.00  | 274.00   | 249.00   | 3041.00  | 2068.00  | 304.00   | 1895.00  | 2789.00  | 106.00   | 2488.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10045119 | AEBP-2760      | AEBR-1369     | 1               | 0                     | 21119.00  | 13119.00  | 8000.00   | 659.00   | 3356.00  | 3648.00  | 1790.00  | 945.00   | 762.00   | 327.00   | 1632.00  | 1419.00  | 3040.00  | 896.00   | 2645.00  | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10045119 | AEBP-2760      | AETL-1368     | 1               | 0                     | 19317.00  | 12901.00  | 6416.00   | 1269.00  | 992.00   | 1823.00  | 2050.00  | 3103.00  | 928.00   | 1032.00  | 1704.00  | 2406.00  | 2035.00  | 429.00   | 1546.00  | Adult Education Budget - 19-24 Traineeships Learner Support     | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP-2760      | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-2760'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-11464' and ContractNumber 'AEBP-2760' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-2760' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10045119 | AEBP-2760          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10045119 | ESFA-11464         | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP-2760' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'AEBP-2760'





    # Part 2: Create and consume a Funding Claim for AEB-19TRLS2021
    
    # Funding Claims

    # Cleardown DEDs/SLD and PaaS
    Given there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Year End      | 1920   |
    | Year End      | 2021   |
    | Final         | 1718   |
    | Final         | 1819   |
    | Final         | 1920   |
    | Final         | 2021   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10045119 |

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    Given there is no data in the Reconciliation Profiling table for UKPRN '10045119' and FundingPeriod 'AY2021'

    # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
    And   the Reconciliation Profiling table includes a row for UKPRN '10045119' and FundingPeriod 'AY2021'





    # Populate stub with Claim data

    # Change the date
    Given the override date is '14/11/2021'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0045119     | 10045119 | 2                  | Final         | AY             | 2021   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0045119     | 10045119 | 2                  | Final         | AY             | 2021   | AETL-1368     | AEB-19TRLS2021          |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0045119     | 10045119 | 2                  | Final         | AY             | 2021   | AETL-1368     | 2               | 9941.00     | 73.92         | 9.50            | 10024.42   |
    | ORG0045119     | 10045119 | 2                  | Final         | AY             | 2021   | AETL-1368     | 3               | 9609.00     | 56.60         | 13.19           | 9678.79    |





    # Consume stub data

    # Change the date
    Given the override date is '16/11/2021'

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10045119 | 2021          | Final            | AEB-19TRLS2021      | 2                  | 19317.00     | 19703.21     | 386.21                      | 386.21              | 19703.21         | 0.00            | 19703.21                 | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10045119 | 2021          | Final            | AEB-19TRLS2021      | AETL-1368     | 19317.00     | 19703.21     | 386.21                      | 386.21              | 19703.21         | 0.00            | ?                     | 19703.21                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10045119 | 2021          | Final            | AEB-19TRLS2021      | AETL-1368     | AEB-19TRLS2021       | 2               | 19-24 Traineeships Learner Support                     | 0.00         | 10024.42     |
    | 10045119 | 2021          | Final            | AEB-19TRLS2021      | AETL-1368     | AEB-19TRLS2021       | 3               | 19-24 Traineeships Administration Expenditure          | 0.00         | 9678.79      |





    # Part 3: Terminate the contract > Closed\Terminated 
    
    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '22/11/2021'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | AEBP-2760     | 1               | 0                  | 31/07/2021              | Notice from Provider        | Police involvement                  |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | AEBA-1881          | 22/07/2021                   | 31/07/2021                      |
    | AEBR-1369          | 22/07/2021                   | 31/07/2021                      |
    | AETL-1368          | 22/07/2021                   | 31/07/2021                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10045119 | AEBP-2760      | 1                     | 0                        | 31/07/2021                 | Notice from Provider         | ?                              | 31/07/2021              | Notice from Provider        | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10045119 | AEBP-2760     | AEBA-1881        | 1                     | 0                        | 22/07/2021                   | 22/07/2021        | 31/07/2021                      | 31/07/2021           |
    | 10045119 | AEBP-2760     | AEBR-1369        | 1                     | 0                        | 22/07/2021                   | 22/07/2021        | 31/07/2021                      | 31/07/2021           |
    | 10045119 | AEBP-2760     | AETL-1368        | 1                     | 0                        | 22/07/2021                   | 22/07/2021        | 31/07/2021                      | 31/07/2021           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract 'AEBP-2760' for provider '10045119'
    | Task                                       | Description                                      | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10045119 - VSS TRAINING AND DEVELOPMENT LIMITED  | AEBP-2760      | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10045119 | AEBP-2760          | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10045119 | ESFA-11464         | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Approve Termination Initiation (30635)

    # Change the date - CRM ignores this
    Given the override date is '23/11/2021'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task
    When the following open Task currently linked to version '1' of contract 'AEBP-2760' for provider '10045119' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Termination Initiation Approval  | FCS1 TEST                 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10045119 | AEBP-2760          | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10045119 | ESFA-11464         | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-2760' for provider '10045119'
    | Task                                       | Description                                     | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10045119 - VSS TRAINING AND DEVELOPMENT LIMITED | AEBP-2760      | FCS1 TEST               | Contract Managers Team   | Completed       | Completed        |

    # Check the Termination details on the contract in CRM (These should not have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10045119 | AEBP-2760      | 1                     | 0                        | 31/07/2021                 | Notice from Provider         | ?                              | 31/07/2021              | Notice from Provider           | ?                             |

    # Check the Termination details on the allocations in CRM (These should not have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10045119 | AEBP-2760     | AEBA-1881        | 1                     | 0                        | 22/07/2021                   | 22/07/2021        | 31/07/2021                      | 31/07/2021           |
    | 10045119 | AEBP-2760     | AEBR-1369        | 1                     | 0                        | 22/07/2021                   | 22/07/2021        | 31/07/2021                      | 31/07/2021           |
    | 10045119 | AEBP-2760     | AETL-1368        | 1                     | 0                        | 22/07/2021                   | 22/07/2021        | 31/07/2021                      | 31/07/2021           |





    # Manager successfully COMPLETES the Termination (31411)

    # Change the date - CRM ignores this but it's used by .Net
    Given the override date is '24/11/2021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination
#   When  CRM user 'FCS1 TEST' completes the termination request for Contract 'AEBP-2760' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS1 TEST' completes the termination request for Contract 'AEBP-2760' Version '1' SubVersion '0' via SDK

    # Check the CONTRACT version, status and dates in CRM (These should not have changed)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10045119 | AEBP-2760          | 1                     | 0                        | Closed           | Terminated                               | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10045119 | ESFA-11464         | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Part 4: Attempte to publish the FCR. This should get stuck at Draft\Publish in Progress

    # Change the date
    Given the override date is '26/11/2021'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2021-Final' and Allocation Group Code 'AEB-19TRLS2021'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2021-Final' and Allocation Group Code 'AEB-19TRLS2021'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10045119 | 2021          | Final            | AEB-19TRLS2021      | 2                  |

   #Then  the following funding claim reconciliations will stay at 'Publish in Progress'
    Then  the following funding claim reconciliations will have a status 'Draft' and a sub status 'Publish In Progress'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10045119 | 2021          | Final            | AEB-19TRLS2021      | 2                  |


    # Tidy up
    Given the override date is reset

