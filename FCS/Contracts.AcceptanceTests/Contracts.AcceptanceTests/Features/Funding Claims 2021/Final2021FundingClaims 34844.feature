Feature: Final2021FundingClaims 34844

@AcceptanceTest @Withdrawn20231002
Scenario: A823 Create and approve a 19-24 Traineeships contract with a 19TRN2020-LS2021 alloc. Process a Final Funding Claim with under-delivery and apportioned claw-back. Check CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017823' 
    And   there are no terminated or closed allocations for UKPRN '10017823' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017823' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017823' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017823' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 19TL-823      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 19TL-823      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 19TRN2020-LS2021  |

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | 19TL-823      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | 19TR20-823     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017823'

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
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
    | 10017823 |
    
    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    And   there is no data in the Reconciliation Profiling table for UKPRN '10017823' and FundingPeriod 'AY2021'

    # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
    And   the Reconciliation Profiling table includes a row for UKPRN '10017823' and FundingPeriod 'AY2021'



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017823' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017823 Co Ltd' with UKPRN '10017823' and OrgId 'ORG0017823' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017823' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017823 | 117823 | 10017823 Co Ltd | 0              | Locked Restructure    | Yes           | AA017823      | ?             | 4 White Oak Square     | London Road            | ?                      | ?                      | Swanley                | Kent                   | BR8 7AG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017823 |





    # Change the date
    Given the override date is '17/01/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-823'
    And   there are no details on ContractManagement.CreatedContract for '19TR20-823'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017823 | 10017823 Co Ltd      | ESFA-823             | 19TR20-823     | 1                     | 01/02/2021        | 31/07/2021      | 12539.00      |                                       | Contract for Services                      | 2021   | New          | ORG0017823 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017823 | 19TR20-823     | 19TL-823      | 19TRN2020-LS      | 19TRN2020-LS2021        | AY                      | 01/02/2021          | 31/07/2021        | 12539.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017823 | 19TR20-823     | 19TL-823      | 1               | 0                     | 12539.00  | 1632.00  | 2749.00  | 382.00   | 1815.00  | 3183.00  | 2778.00  | 19-24 Traineeships Learner Support Total Funding                | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-823'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-823' and actual ContractNumber '19TR20-823'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-823' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017823 | 19TR20-823         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/02/2021        | 31/07/2021      | ?             |
    | 10017823 | ESFA-823           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-823' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '6' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '6' deliverable period rows in CRM linked to the latest version of contract '19TR20-823'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TL-823        | 2355870          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                    | DeliverableDescription  | 
    | 10017823 | 19TR20-823     | 1               | 19TL-823      | 1               | 0                     | 12539.00     | 0             | 0        | 19-24 Traineeships Learner Support Total Funding   | ?                       |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-823' agree with the most recent entry for this contract in the ContractManagement feed





    # Funding Claims ...

    # Populate stub with Claim data

    # Change the date
    Given the override date is '01/10/2021'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017823     | 10017823 | 3                  | Final         | AY             | 2021   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017823     | 10017823 | 3                  | Final         | AY             | 2021   | 19TL-823      | 19TRN2020-LS2021        |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017823     | 10017823 | 3                  | Final         | AY             | 2021   | 19TL-823      | 2               | 5080.00     | 71.62         | 13.84           | 5165.46    |
    | ORG0017823     | 10017823 | 3                  | Final         | AY             | 2021   | 19TL-823      | 3               | 5564.00     | 74.35         | 8.92            | 5647.27    |
    #                                                                                                                                                                            £ 10812.73  

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed




    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017823 | 2021          | Final            | 19TRN2020-LS2021    | 3                  | 12539.00     | 10812.73     | -1726.27                    | -1726.27            | 10812.73         | 0.00            | 10812.73                 | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017823 | 2021          | Final            | 19TRN2020-LS2021    | 19TL-823      | 12539.00     | 10812.73     | -1726.27                    | -1726.27            | 10812.73         | 0.00            | ?                     | 10812.73                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017823 | 2021          | Final            | 19TRN2020-LS2021    | 19TL-823      | 19TRN2020-LS2021     | 2               | 19-24 Traineeships Learner Support                     | 0.00         | 5165.46      |
    | 10017823 | 2021          | Final            | 19TRN2020-LS2021    | 19TL-823      | 19TRN2020-LS2021     | 3               | 19-24 Traineeships Administration Expenditure          | 0.00         | 5647.27      |




    # Change the date 
    Given the override date is '02/10/2021'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither ... 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017823 | 2021          | Final            | 19TRN2020-LS2021    | 3                  | 19TL-823      | 12539.00     | 10812.73     | -1726.27                    | -1726.27            | 10812.73         | 0.00            | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017823 | 2021          | Final            | 19TRN2020-LS2021    | 3                  | 12539.00     | 10812.73     | -1726.27                    | -1726.27            | 10812.73         | 0.00            | 10812.73                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017823 | 2021          | Final            | 19TRN2020-LS2021    | 19TL-823      | 12539.00     | 10812.73     | -1726.27                    | -1726.27            | 10812.73         | 0.00            | ?                     | 10812.73                 |




    # Change the date
    Given the override date is '03/10/2021'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2021-Final' and Allocation Group Code '19TRN2020-LS2021'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2021-Final' and Allocation Group Code '19TRN2020-LS2021'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017823 | 2021          | Final            | 19TRN2020-LS2021    | 3                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017823 | 2021          | Final            | 19TRN2020-LS2021    | 3                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017823 | 2021          | Final            | 19TRN2020-LS2021    | 3                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                               | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017823 | 19TL-823         | 2021   | Final         | 19-24 Traineeships - 2020 Procurement - Learner Support 20/21     | 12539.00     | 10812.73     | -1726.27                    | -1726.27                 | 10812.73           | ?               | ?                     | 10812.73                 |



    # Check financials
    
    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   |
    | 19TR20-823     | 19TL-823           | 1               | 12539.00  | 1632.00  | 2749.00  | 382.00   | 1815.00  | 3183.00  | 2778.00  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   |
    | 19TR20-823     | 19TL-823           | 1               | 12539.00  | 1632.00  | 2749.00  | 382.00   | 1815.00  | 3183.00  | 2778.00  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   |
    | 19TR20-823     | 19TL-823           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   |
    | 19TR20-823     | 19TL-823           | 1               | -1726.27  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -431.56  | -431.56  | -431.56  | -431.59  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   |
    | 19TR20-823     | 19TL-823           | 1               | 10812.73  | 1632.00  | 2749.00  | 382.00   | 1815.00  | 3183.00  | 2778.00  | -431.56  | -431.56  | -431.56  | -431.59  | 

   
    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    |
    | 10017823 | 19TR20-823     | 19TL-823           | 2355870                  | 1632.00   | 2749.00   | 382.00    | 1815.00   | 3183.00   | 2778.00   | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    |
    | 10017823 | 19TR20-823     | 19TL-823           | 2355875                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | -431.56   | -431.56   | -431.56   | -431.59   |


    # Tidy up
    Given the override date is reset

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    And   there is no data in the Reconciliation Profiling table for UKPRN '10017823' and FundingPeriod 'AY2021'

@AcceptanceTest @Withdrawn20231002
Scenario: A824 Create and approve an AEB contract with 19TRLS and ASLS allocs. Process a Final Funding Claim with under-delivery and apportioned claw-back. Check CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017824' 
    And   there are no terminated or closed allocations for UKPRN '10017824' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017824' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017824' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017824' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-824      |
    | AETL-824      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-824      |
    | AETL-824      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-19TRLS2021    |
    | AEB-ASLS2021      |

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEAL-824      |
    | AETL-824      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-824       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017824'

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
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
    | 10017824 |
    
    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    And   there is no data in the Reconciliation Profiling table for UKPRN '10017824' and FundingPeriod 'AY2021'

    # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
    And   the Reconciliation Profiling table includes a row for UKPRN '10017824' and FundingPeriod 'AY2021'



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017824' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017824 Co Ltd' with UKPRN '10017824' and OrgId 'ORG0017824' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017824' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017824 | 117824 | 10017824 Co Ltd | 0              | In Administration     | Yes           | AA017824      | ?             | 52 Park Street         | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 3PT  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017824 |





    # Change the date
    Given the override date is '12/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP-824'
    And   there are no details on ContractManagement.CreatedContract for 'AEBP-824'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017824 | 10017824 Co Ltd      | ESFA-824             | AEBP-824       | 1                     | 01/08/2020        | 31/07/2021      | 48274.00      |                                       | Procured                                   | 2021   | New          | ORG0017824 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017824 | AEBP-824       | AEAL-824      | AEB-ASLS          | AEB-ASLS2021            | AY                      | 01/08/2020          | 31/07/2021        | 29602.00        |                                         |            |                                                             | New          |             |
    | 10017824 | AEBP-824       | AETL-824      | AEB-19TRLS        | AEB-19TRLS2021          | AY                      | 01/08/2020          | 31/07/2021        | 18672.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017824 | AEBP-824       | AEAL-824      | 1               | 0                     | 29602.00  | 19164.00  | 10438.00  | 3507.00  | 3705.00  | 3112.00  | 1190.00  | 2272.00  | 1743.00  | 612.00   | 3023.00  | 3191.00  | 953.00   | 2984.00  | 3310.00  | Adult Education Budget - Adult Skills Learner Support           | New          |             | 
    | 10017824 | AEBP-824       | AETL-824      | 1               | 0                     | 18672.00  | 13767.00  | 4905.00   | 2733.00  | 3469.00  | 1261.00  | 2219.00  | 1310.00  | 337.00   | 2274.00  | 164.00   | 75.00    | 2076.00  | 757.00   | 1997.00  | Adult Education Budget - 19-24 Traineeships Learner Support     | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-824'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-824' and actual ContractNumber 'AEBP-824'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-824' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017824 | AEBP-824           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017824 | ESFA-824           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP-824' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'AEBP-824'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AETL-824        | 2355875          | Jul-21 | Reconciliation |
    | AEAL-824        | 2372175          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017824 | AEBP-824       | 1               | AEAL-824      | 1               | 0                     | 29602.00     | 0             | 0        | Adult Education Budget - Adult Skills Learner Support           | ?                                                           |
    | 10017824 | AEBP-824       | 1               | AETL-824      | 1               | 0                     | 18672.00     | 0             | 0        | Adult Education Budget - 19-24 Traineeships Learner Support     | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP-824' agree with the most recent entry for this contract in the ContractManagement feed





    # Funding Claims ...

    # Populate stub with Claim data

    # Change the date
    Given the override date is '01/10/2021'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017824     | 10017824 | 3                  | Final         | AY             | 2021   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017824     | 10017824 | 3                  | Final         | AY             | 2021   | AEAL-824      | AEB-ASLS2021            |
    | ORG0017824     | 10017824 | 3                  | Final         | AY             | 2021   | AETL-824      | AEB-19TRLS2021          |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017824     | 10017824 | 3                  | Final         | AY             | 2021   | AEAL-824      | 2               | 5801.00     | 67.66         | 10.42           | 5879.08    |
    | ORG0017824     | 10017824 | 3                  | Final         | AY             | 2021   | AEAL-824      | 3               | 5637.00     | 46.81         | 13.53           | 5697.34    |
    | ORG0017824     | 10017824 | 3                  | Final         | AY             | 2021   | AEAL-824      | 4               | 5874.00     | 49.89         | 9.89            | 5933.78    |
    | ORG0017824     | 10017824 | 3                  | Final         | AY             | 2021   | AEAL-824      | 5               | 4917.00     | 71.80         | 6.99            | 4995.79    |
    #                                                                                                                                                                            £ 22505.99  
    | ORG0017824     | 10017824 | 3                  | Final         | AY             | 2021   | AETL-824      | 2               | 8170.00     | 70.29         | 10.64           | 8250.93    |
    | ORG0017824     | 10017824 | 3                  | Final         | AY             | 2021   | AETL-824      | 3               | 8000.00     | 61.22         | 10.35           | 8071.57    |
    #                                                                                                                                                                            £ 16322.50  

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed




    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017824 | 2021          | Final            | AEB-19TRLS2021      | 3                  | 18672.00     | 16322.50     | -2349.50                    | -2349.50            | 16322.50         | 0.00            | 16322.50                 | Draft      |
    | 10017824 | 2021          | Final            | AEB-ASLS2021        | 3                  | 29602.00     | 22505.99     | -7096.01                    | -7096.01            | 22505.99         | 0.00            | 22505.99                 | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017824 | 2021          | Final            | AEB-19TRLS2021      | AETL-824      | 18672.00     | 16322.50     | -2349.50                    | -2349.50            | 16322.50         | 0.00            | ?                     | 16322.50                 |
    | 10017824 | 2021          | Final            | AEB-ASLS2021        | AEAL-824      | 29602.00     | 22505.99     | -7096.01                    | -7096.01            | 22505.99         | 0.00            | ?                     | 22505.99                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017824 | 2021          | Final            | AEB-19TRLS2021      | AETL-824      | AEB-19TRLS2021       | 2               | 19-24 Traineeships Learner Support                     | 0.00         | 8250.93      |
    | 10017824 | 2021          | Final            | AEB-19TRLS2021      | AETL-824      | AEB-19TRLS2021       | 3               | 19-24 Traineeships Administration Expenditure          | 0.00         | 8071.57      |
    #
    | 10017824 | 2021          | Final            | AEB-ASLS2021        | AEAL-824      | AEB-ASLS2021         | 2               | Adult Skills 19+ Hardship                              | 0.00         | 5879.08      |
    | 10017824 | 2021          | Final            | AEB-ASLS2021        | AEAL-824      | AEB-ASLS2021         | 3               | Adult Skills 20+ Childcare                             | 0.00         | 5697.34      |
    | 10017824 | 2021          | Final            | AEB-ASLS2021        | AEAL-824      | AEB-ASLS2021         | 4               | Adult Skills Residential Access Fund                   | 0.00         | 5933.78      |
    | 10017824 | 2021          | Final            | AEB-ASLS2021        | AEAL-824      | AEB-ASLS2021         | 5               | Adult Skills Administration Expenditure                | 0.00         | 4995.79      |




    # Change the date 
    Given the override date is '02/10/2021'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither ... 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017824 | 2021          | Final            | AEB-19TRLS2021      | 3                  | AETL-824      | 18672.00     | 16322.50     | -2349.50                    | -2349.50            | 16322.50         | 0.00            | ?                     |
    | 10017824 | 2021          | Final            | AEB-ASLS2021        | 3                  | AEAL-824      | 29602.00     | 22505.99     | -7096.01                    | -7096.01            | 22505.99         | 0.00            | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017824 | 2021          | Final            | AEB-19TRLS2021      | 3                  | 18672.00     | 16322.50     | -2349.50                    | -2349.50            | 16322.50         | 0.00            | 16322.50                 | Draft      |
    | 10017824 | 2021          | Final            | AEB-ASLS2021        | 3                  | 29602.00     | 22505.99     | -7096.01                    | -7096.01            | 22505.99         | 0.00            | 22505.99                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017824 | 2021          | Final            | AEB-19TRLS2021      | AETL-824      | 18672.00     | 16322.50     | -2349.50                    | -2349.50            | 16322.50         | 0.00            | ?                     | 16322.50                 |
    | 10017824 | 2021          | Final            | AEB-ASLS2021        | AEAL-824      | 29602.00     | 22505.99     | -7096.01                    | -7096.01            | 22505.99         | 0.00            | ?                     | 22505.99                 |




    # Change the date
    Given the override date is '03/10/2021'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2021-Final' and Allocation Group Code 'AEB-ASLS2021'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2021-Final' and Allocation Group Code 'AEB-ASLS2021'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017824 | 2021          | Final            | AEB-19TRLS2021      | 3                  |
    | 10017824 | 2021          | Final            | AEB-ASLS2021        | 3                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017824 | 2021          | Final            | AEB-19TRLS2021      | 3                  |
    | 10017824 | 2021          | Final            | AEB-ASLS2021        | 3                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017824 | 2021          | Final            | AEB-19TRLS2021      | 3                  |
    | 10017824 | 2021          | Final            | AEB-ASLS2021        | 3                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                               | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017824 | AETL-824         | 2021   | Final         | AEB (Procured) - 19 to 24 Traineeships Learner Support 20/21      | 18672.00     | 16322.50     | -2349.50                    | -2349.50                 | 16322.50           | ?               | ?                     | 16322.50                 |
    | 10017824 | AEAL-824         | 2021   | Final         | AEB (Procured) - Adult Skills Learner Support 20/21               | 29602.00     | 22505.99     | -7096.01                    | -7096.01                 | 22505.99           | ?               | ?                     | 22505.99                 |



    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   |
    | AEBP-824       | AEAL-824           | 1               | 29602.00  | 3507.00  | 3705.00  | 3112.00  | 1190.00  | 2272.00  | 1743.00  | 612.00   | 3023.00  | 3191.00  | 953.00   | 2984.00  | 3310.00  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-824       | AETL-824           | 1               | 18672.00  | 2733.00  | 3469.00  | 1261.00  | 2219.00  | 1310.00  | 337.00   | 2274.00  | 164.00   | 75.00    | 2076.00  | 757.00   | 1997.00  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   |
    | AEBP-824       | AEAL-824           | 1               | 29602.00  | 3507.00  | 3705.00  | 3112.00  | 1190.00  | 2272.00  | 1743.00  | 612.00   | 3023.00  | 3191.00  | 953.00   | 2984.00  | 3310.00  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-824       | AETL-824           | 1               | 18672.00  | 2733.00  | 3469.00  | 1261.00  | 2219.00  | 1310.00  | 337.00   | 2274.00  | 164.00   | 75.00    | 2076.00  | 757.00   | 1997.00  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   |
    | AEBP-824       | AEAL-824           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-824       | AETL-824           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   |
    | AEBP-824       | AEAL-824           | 1               | -7096.01  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1774.00 | -1774.00 | -1774.00 | -1774.01 | 
    | AEBP-824       | AETL-824           | 1               | -2349.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -587.37  | -587.37  | -587.37  | -587.39  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   |
    | AEBP-824       | AEAL-824           | 1               | 22505.99  | 3507.00  | 3705.00  | 3112.00  | 1190.00  | 2272.00  | 1743.00  | 612.00   | 3023.00  | 3191.00  | 953.00   | 2984.00  | 3310.00  | -1774.00 | -1774.00 | -1774.00 | -1774.01 | 
    | AEBP-824       | AETL-824           | 1               | 16322.50  | 2733.00  | 3469.00  | 1261.00  | 2219.00  | 1310.00  | 337.00   | 2274.00  | 164.00   | 75.00    | 2076.00  | 757.00   | 1997.00  | -587.37  | -587.37  | -587.37  | -587.39  | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    |
    | 10017824 | AEBP-824       | AEAL-824           | 2372165                  | 3507.00   | 3705.00   | 3112.00   | 1190.00   | 2272.00   | 1743.00   | 612.00    | 3023.00   | 3191.00   | 953.00    | 2984.00   | 3310.00   | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017824 | AEBP-824       | AETL-824           | 2355870                  | 2733.00   | 3469.00   | 1261.00   | 2219.00   | 1310.00   | 337.00    | 2274.00   | 164.00    | 75.00     | 2076.00   | 757.00    | 1997.00   | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    |
    | 10017824 | AEBP-824       | AEAL-824           | 2372175                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | -1774.00  | -1774.00  | -1774.00  | -1774.01  | 
    | 10017824 | AEBP-824       | AETL-824           | 2355875                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | -587.37   | -587.37   | -587.37   | -587.39   | 


    # Tidy up
    Given the override date is reset

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    And   there is no data in the Reconciliation Profiling table for UKPRN '10017824' and FundingPeriod 'AY2021'

@AcceptanceTest @Withdrawn20231002
Scenario: A825 Create and approve an EDSK contract with 19TRN, ASCL, CSO and ALLBC allocs. Process a Final Funding Claim with over-delivery. Check CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017825' 
    And   there are no terminated or closed allocations for UKPRN '10017825' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017825' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017825' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017825' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-825      |
    | AECS-825      |
    | AECT-825      |
    | ALLC-825      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-825      |
    | AECS-825      |
    | AECT-825      |
    | ALLC-825      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-19TRN2021    |
    | AEBC-ASCL2021     |
    | AEBC-CSO2021      |
    | ALLBC2021         |

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECA-825      |
    | AECS-825      |
    | AECT-825      |
    | ALLC-825      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-825       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017825'

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
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
    | 10017825 |
    
    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    And   there is no data in the Reconciliation Profiling table for UKPRN '10017825' and FundingPeriod 'AY2021'

    # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
    And   the Reconciliation Profiling table includes a row for UKPRN '10017825' and FundingPeriod 'AY2021'



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017825' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017825 Co Ltd' with UKPRN '10017825' and OrgId 'ORG0017825' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017825' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017825 | 117825 | 10017825 Co Ltd | 0              | Provider Under Change | Yes           | AA017825      | ?             | 1 Church Mews          | ?                      | ?                      | ?                      | Clophill               | Bedfordshire           | MK45 4BQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017825 |





    # Change the date
    Given the override date is '11/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-825'
    And   there are no details on ContractManagement.CreatedContract for 'EDSK-825'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017825 | 10017825 Co Ltd      | ESFA-825             | EDSK-825       | 1                     | 01/08/2020        | 31/07/2021      | 142022.00     |                                       | Conditions of Funding (Grant) (Employer)   | 2021   | New          | ORG0017825 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017825 | EDSK-825       | AECA-825      | AEBC-ASCL         | AEBC-ASCL2021           | AY                      | 01/08/2020          | 31/07/2021        | 49187.00        |                                         |            |                                                             | New          |             |
    | 10017825 | EDSK-825       | AECS-825      | AEBC-CSO          | AEBC-CSO2021            | AY                      | 01/08/2020          | 31/07/2021        | 47670.00        |                                         |            |                                                             | New          |             |
    | 10017825 | EDSK-825       | AECT-825      | AEBC-19TRN        | AEBC-19TRN2021          | AY                      | 01/08/2020          | 31/07/2021        | 20889.00        |                                         |            |                                                             | New          |             |
    | 10017825 | EDSK-825       | ALLC-825      | ALLBC             | ALLBC2021               | AY                      | 01/08/2020          | 31/07/2021        | 24276.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017825 | EDSK-825       | AECA-825      | 1               | 0                     | 49187.00  | 33539.00  | 15648.00  | 4419.00  | 2917.00  | 6440.00  | 3041.00  | 3120.00  | 3865.00  | 4577.00  | 5160.00  | 5146.00  | 2473.00  | 3090.00  | 4939.00  | COVID-19 Skills Offer Total Funding                             | New          |             | 
    | 10017825 | EDSK-825       | AECA-825      | 2               | 1                     | 27132.00  | 16939.00  | 10193.00  | 1818.00  | 2648.00  | 2875.00  | 227.00   | 1754.00  | 1857.00  | 2529.00  | 3231.00  | 2861.00  | 1255.00  | 2371.00  | 3706.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017825 | EDSK-825       | AECA-825      | 5               | 1                     | 22055.00  | 16600.00  | 5455.00   | 2601.00  | 269.00   | 3565.00  | 2814.00  | 1366.00  | 2008.00  | 2048.00  | 1929.00  | 2285.00  | 1218.00  | 719.00   | 1233.00  | Community Learning                                              | New          |             | 
    | 10017825 | EDSK-825       | AECS-825      | 1               | 0                     | 47670.00  | 31624.00  | 16046.00  | 4859.00  | 3545.00  | 5522.00  | 3293.00  | 4543.00  | 1775.00  | 2675.00  | 5412.00  | 5586.00  | 4083.00  | 4888.00  | 1489.00  | COVID-19 Skills Offer Total Funding                             | New          |             | 
    | 10017825 | EDSK-825       | AECS-825      | 2               | 1                     | 21705.00  | 13649.00  | 8056.00   | 2256.00  | 3180.00  | 3126.00  | 571.00   | 833.00   | 1030.00  | 437.00   | 2216.00  | 3299.00  | 2770.00  | 1638.00  | 349.00   | High Value Courses for School and College Leavers Funding       | New          |             | 
    | 10017825 | EDSK-825       | AECS-825      | 6               | 1                     | 25965.00  | 17975.00  | 7990.00   | 2603.00  | 365.00   | 2396.00  | 2722.00  | 3710.00  | 745.00   | 2238.00  | 3196.00  | 2287.00  | 1313.00  | 3250.00  | 1140.00  | National Skills Fund Level 3 Offer for 24 year old and over     | New          |             | 
    | 10017825 | EDSK-825       | AECT-825      | 1               | 0                     | 20889.00  | 17636.00  | 3253.00   | 2216.00  | 516.00   | 2897.00  | 437.00   | 3135.00  | 3426.00  | 1568.00  | 3441.00  | 540.00   | 106.00   | 1410.00  | 1197.00  | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10017825 | EDSK-825       | ALLC-825      | 1               | 0                     | 24276.00  | 15942.00  | 8334.00   | 452.00   | 2008.00  | 56.00    | 3194.00  | 2917.00  | 3748.00  | 1257.00  | 2310.00  | 135.00   | 2957.00  | 3629.00  | 1613.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-825       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-825'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-825' and actual ContractNumber 'EDSK-825'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-825' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017825 | EDSK-825           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017825 | ESFA-825           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'EDSK-825'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECT-825        | 2355775          | Jul-21 | Reconciliation |
    | AECA-825        | 2371175          | Jul-21 | Reconciliation |
    | AECS-825        | 2372091          | Jul-21 | Profile        |
    | ALLC-825        | 2303975          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '8' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription      | 
    | 10017825 | EDSK-825       | 1               | AECA-825      | 1               | 0                     | 49187.00     | 0             | 0        | COVID-19 Skills Offer Total Funding                             | ?                           |
    | 10017825 | EDSK-825       | 1               | AECA-825      | 2               | 1                     | 27132.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                           |
    | 10017825 | EDSK-825       | 1               | AECA-825      | 5               | 1                     | 22055.00     | 0             | 0        | Community Learning                                              | ?                           |
    | 10017825 | EDSK-825       | 1               | AECS-825      | 1               | 0                     | 47670.00     | 0             | 0        | COVID-19 Skills Offer Total Funding                             | ?                           |
    | 10017825 | EDSK-825       | 1               | AECS-825      | 2               | 1                     | 21705.00     | 0             | 0        | High Value Courses for School and College Leavers Funding       | ?                           |
    | 10017825 | EDSK-825       | 1               | AECS-825      | 6               | 1                     | 25965.00     | 0             | 0        | National Skills Fund Level 3 Offer for 24 year old and over     | ?                           |
    | 10017825 | EDSK-825       | 1               | AECT-825      | 1               | 0                     | 20889.00     | 0             | 0        | 19-24 Traineeships Total Funding                                | ?                           |
    | 10017825 | EDSK-825       | 1               | ALLC-825      | 1               | 0                     | 24276.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding                    | ?                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-825' agree with the most recent entry for this contract in the ContractManagement feed





    # Funding Claims ...

    # Populate stub with Claim data

    # Change the date
    Given the override date is '01/10/2021'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECA-825      | AEBC-ASCL2021           |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECS-825      | AEBC-CSO2021            |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECT-825      | AEBC-19TRN2021          |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | ALLC-825      | ALLBC2021               |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECA-825      | 3               | 7111.00     | 26.04         | 7.04            | 7144.08    |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECA-825      | 4               | 6645.00     | 37.08         | 8.52            | 6690.60    |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECA-825      | 5               | 6567.00     | 67.49         | 10.86           | 6645.35    |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECA-825      | 6               | 6799.00     | 46.41         | 14.81           | 6860.22    |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECA-825      | 7               | 6478.00     | 50.42         | 11.63           | 6540.05    |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECA-825      | 8               | 6169.00     | 34.41         | 14.05           | 6217.46    |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECA-825      | 9               | 6464.00     | 31.64         | 8.93            | 6504.57    |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECA-825      | 10              | 7238.00     | 63.55         | 9.64            | 7311.19    |
    #                                                                                                                                                                            £ 53913.52  
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECS-825      | 3               | 15999.00    | 40.71         | 11.85           | 16051.56   |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECS-825      | 4               | 17092.00    | 53.39         | 6.31            | 17151.70   |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECS-825      | 5               | 16627.00    | 74.65         | 7.08            | 16708.73   |
    #                                                                                                                                                                            £ 49911.99  
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECT-825      | 2               | 5356.00     | 63.31         | 13.80           | 5433.11    |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECT-825      | 3               | 6155.00     | 48.87         | 12.88           | 6216.75    |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECT-825      | 4               | 6115.00     | 29.61         | 12.52           | 6157.13    |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | AECT-825      | 5               | 5850.00     | 62.91         | 11.08           | 5923.99    |
    #                                                                                                                                                                            £ 23730.98  
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | ALLC-825      | 2               | 3471.00     | 48.65         | 14.36           | 3534.01    |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | ALLC-825      | 3               | 3907.00     | 35.81         | 11.26           | 3954.07    |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | ALLC-825      | 4               | 3720.00     | 71.81         | 13.02           | 3804.83    |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | ALLC-825      | 5               | 3916.00     | 36.38         | 13.25           | 3965.63    |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | ALLC-825      | 6               | 4121.00     | 27.47         | 12.88           | 4161.35    |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | ALLC-825      | 7               | 3525.00     | 55.35         | 14.96           | 3595.31    |
    | ORG0017825     | 10017825 | 3                  | Final         | AY             | 2021   | ALLC-825      | 8               | 3731.00     | 38.22         | 9.39            | 3778.61    |
    #                                                                                                                                                                            £ 26793.81  

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017825 | 2021          | Final            | AEBC-19TRN2021      | 3                  | 20889.00     | 23730.98     | 2841.98                     | 2841.98             | 23730.98         | 0.00            | 23730.98                 | Draft      |
    | 10017825 | 2021          | Final            | ALLBC2021           | 3                  | 24276.00     | 26793.81     | 0.00                        | 0.00                | 26793.81         | 0.00            | 26793.81                 | Draft      |
    | 10017825 | 2021          | Final            | AEBC-CSO2021        | 3                  | 47670.00     | 49911.99     | 2241.99                     | 2241.99             | 49911.99         | 0.00            | 49911.99                 | Draft      |
    | 10017825 | 2021          | Final            | AEBC-ASCL2021       | 3                  | 49187.00     | 53913.52     | 1475.61                     | 1475.61             | 53913.52         | 0.00            | 53913.52                 | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017825 | 2021          | Final            | AEBC-19TRN2021      | AECT-825      | 20889.00     | 23730.98     | 2841.98                     | 2841.98             | 23730.98         | 0.00            | ?                     | 23730.98                 |
    | 10017825 | 2021          | Final            | ALLBC2021           | ALLC-825      | 24276.00     | 26793.81     | 0.00                        | 0.00                | 26793.81         | 0.00            | ?                     | 26793.81                 |
    | 10017825 | 2021          | Final            | AEBC-CSO2021        | AECS-825      | 47670.00     | 49911.99     | 2241.99                     | 2241.99             | 49911.99         | 0.00            | ?                     | 49911.99                 |
    | 10017825 | 2021          | Final            | AEBC-ASCL2021       | AECA-825      | 49187.00     | 53913.52     | 1475.61                     | 1475.61             | 53913.52         | 0.00            | ?                     | 53913.52                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017825 | 2021          | Final            | AEBC-19TRN2021      | AECT-825      | AEBC-19TRN2021       | 2               | 19-24 Traineeships Programme Funding                   | 0.00         | 5433.11      |
    | 10017825 | 2021          | Final            | AEBC-19TRN2021      | AECT-825      | AEBC-19TRN2021       | 3               | 19-24 Traineeships Learning Support                    | 0.00         | 6216.75      |
    | 10017825 | 2021          | Final            | AEBC-19TRN2021      | AECT-825      | AEBC-19TRN2021       | 4               | 19-24 Traineeships Learner Support                     | 0.00         | 6157.13      |
    | 10017825 | 2021          | Final            | AEBC-19TRN2021      | AECT-825      | AEBC-19TRN2021       | 5               | 19-24 Traineeships Admin Expenditure                   | 0.00         | 5923.99      |
    #
    | 10017825 | 2021          | Final            | AEBC-ASCL2021       | AECA-825      | AEBC-ASCL-2021       | 3               | Adult Skills Programme Funding                         | 0.00         | 7144.08      |
    | 10017825 | 2021          | Final            | AEBC-ASCL2021       | AECA-825      | AEBC-ASCL-2021       | 4               | Adult Skills Learning Support                          | 0.00         | 6690.60      |
    | 10017825 | 2021          | Final            | AEBC-ASCL2021       | AECA-825      | AEBC-ASCL-2021       | 5               | Community Learning                                     | 22055.00     | 6645.35      |
    | 10017825 | 2021          | Final            | AEBC-ASCL2021       | AECA-825      | AEBC-ASCL-2021       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 6860.22      |
    | 10017825 | 2021          | Final            | AEBC-ASCL2021       | AECA-825      | AEBC-ASCL-2021       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 6540.05      |
    | 10017825 | 2021          | Final            | AEBC-ASCL2021       | AECA-825      | AEBC-ASCL-2021       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 6217.46      |
    | 10017825 | 2021          | Final            | AEBC-ASCL2021       | AECA-825      | AEBC-ASCL-2021       | 9               | Adult Skills Administration Expenditure                | 0.00         | 6504.57      |
    | 10017825 | 2021          | Final            | AEBC-ASCL2021       | AECA-825      | AEBC-ASCL-2021       | 10              | Learner Support - COVID-19 Response                    | 0.00         | 7311.19      |
    #
    | 10017825 | 2021          | Final            | AEBC-CSO2021        | AECS-825      | AEBC-CSO2021         | 3               | COVID-19 Skills Offer Programme Funding                | 0.00         | 16051.56     |
    | 10017825 | 2021          | Final            | AEBC-CSO2021        | AECS-825      | AEBC-CSO2021         | 4               | COVID-19 Skills Offer Learning Support                 | 0.00         | 17151.70     |
    | 10017825 | 2021          | Final            | AEBC-CSO2021        | AECS-825      | AEBC-CSO2021         | 5               | COVID-19 Skills Offer Learner Support                  | 0.00         | 16708.73     |
    #
    | 10017825 | 2021          | Final            | ALLBC2021           | ALLC-825      | ALLBC2021            | 2               | Loans - Bursary Funding                                | 0.00         | 3534.01      |
    | 10017825 | 2021          | Final            | ALLBC2021           | ALLC-825      | ALLBC2021            | 3               | Loans - Area Costs                                     | 0.00         | 3954.07      |
    | 10017825 | 2021          | Final            | ALLBC2021           | ALLC-825      | ALLBC2021            | 4               | Loans - Excess Claims                                  | 0.00         | 3804.83      |
    | 10017825 | 2021          | Final            | ALLBC2021           | ALLC-825      | ALLBC2021            | 5               | Loans - Hardship                                       | 0.00         | 3965.63      |
    | 10017825 | 2021          | Final            | ALLBC2021           | ALLC-825      | ALLBC2021            | 6               | Loans - Childcare                                      | 0.00         | 4161.35      |
    | 10017825 | 2021          | Final            | ALLBC2021           | ALLC-825      | ALLBC2021            | 7               | Loans - Residential Access Fund                        | 0.00         | 3595.31      |
    | 10017825 | 2021          | Final            | ALLBC2021           | ALLC-825      | ALLBC2021            | 8               | Loans - Administration Expenditure                     | 0.00         | 3778.61      |




    # Change the date 
    Given the override date is '02/10/2021'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither ... 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017825 | 2021          | Final            | AEBC-19TRN2021      | 3                  | AECT-825      | 20889.00     | 23730.98     | 2841.98                     | 2841.98             | 23730.98         | 0.00            | ?                     |
    | 10017825 | 2021          | Final            | ALLBC2021           | 3                  | ALLC-825      | 24276.00     | 26793.81     | 0.00                        | 0.00                | 26793.81         | 0.00            | ?                     |
    | 10017825 | 2021          | Final            | AEBC-CSO2021        | 3                  | AECS-825      | 47670.00     | 49911.99     | 2241.99                     | 2241.99             | 49911.99         | 0.00            | ?                     |
    | 10017825 | 2021          | Final            | AEBC-ASCL2021       | 3                  | AECA-825      | 49187.00     | 53913.52     | 1475.61                     | 1475.61             | 53913.52         | 0.00            | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017825 | 2021          | Final            | AEBC-19TRN2021      | 3                  | 20889.00     | 23730.98     | 2841.98                     | 2841.98             | 23730.98         | 0.00            | 23730.98                 | Draft      |
    | 10017825 | 2021          | Final            | ALLBC2021           | 3                  | 24276.00     | 26793.81     | 0.00                        | 0.00                | 26793.81         | 0.00            | 26793.81                 | Draft      |
    | 10017825 | 2021          | Final            | AEBC-CSO2021        | 3                  | 47670.00     | 49911.99     | 2241.99                     | 2241.99             | 49911.99         | 0.00            | 49911.99                 | Draft      |
    | 10017825 | 2021          | Final            | AEBC-ASCL2021       | 3                  | 49187.00     | 53913.52     | 1475.61                     | 1475.61             | 53913.52         | 0.00            | 53913.52                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017825 | 2021          | Final            | AEBC-19TRN2021      | AECT-825      | 20889.00     | 23730.98     | 2841.98                     | 2841.98             | 23730.98         | 0.00            | ?                     | 23730.98                 |
    | 10017825 | 2021          | Final            | ALLBC2021           | ALLC-825      | 24276.00     | 26793.81     | 0.00                        | 0.00                | 26793.81         | 0.00            | ?                     | 26793.81                 |
    | 10017825 | 2021          | Final            | AEBC-CSO2021        | AECS-825      | 47670.00     | 49911.99     | 2241.99                     | 2241.99             | 49911.99         | 0.00            | ?                     | 49911.99                 |
    | 10017825 | 2021          | Final            | AEBC-ASCL2021       | AECA-825      | 49187.00     | 53913.52     | 1475.61                     | 1475.61             | 53913.52         | 0.00            | ?                     | 53913.52                 |





    # Change the date
    Given the override date is '03/10/2021'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2021-Final' and Allocation Group Code 'AEBC-ASCL2021'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2021-Final' and Allocation Group Code 'AEBC-ASCL2021'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017825 | 2021          | Final            | AEBC-19TRN2021      | 3                  |
    | 10017825 | 2021          | Final            | AEBC-ASCL2021       | 3                  |
    | 10017825 | 2021          | Final            | AEBC-CSO2021        | 3                  |
    | 10017825 | 2021          | Final            | ALLBC2021           | 3                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017825 | 2021          | Final            | AEBC-19TRN2021      | 3                  |
    | 10017825 | 2021          | Final            | AEBC-ASCL2021       | 3                  |
    | 10017825 | 2021          | Final            | AEBC-CSO2021        | 3                  |
    | 10017825 | 2021          | Final            | ALLBC2021           | 3                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017825 | 2021          | Final            | AEBC-19TRN2021      | 3                  |
    | 10017825 | 2021          | Final            | AEBC-ASCL2021       | 3                  |
    | 10017825 | 2021          | Final            | AEBC-CSO2021        | 3                  |
    | 10017825 | 2021          | Final            | ALLBC2021           | 3                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                               | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017825 | AECT-825         | 2021   | Final         | AEB (College) - 19 to 24 Traineeships 20/21                       | 20889.00     | 23730.98     | 2841.98                     | 2841.98                  | 23730.98           | ?               | ?                     | 23730.98                 |
    | 10017825 | ALLC-825         | 2021   | Final         | Advanced Learner Loans Bursary (College) 20/21                    | 24276.00     | 26793.81     | 0.00                        | 0.00                     | 26793.81           | ?               | ?                     | 26793.81                 |
    | 10017825 | AECS-825         | 2021   | Final         | AEB (College) - COVID-19 Skills Offer 20/21                       | 47670.00     | 49911.99     | 2241.99                     | 2241.99                  | 49911.99           | ?               | ?                     | 49911.99                 |
    | 10017825 | AECA-825         | 2021   | Final         | AEB (College) - Adult Skills and Community Learning 20/21         | 49187.00     | 53913.52     | 1475.61                     | 1475.61                  | 53913.52           | ?               | ?                     | 53913.52                 |



    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   |
    | EDSK-825       | AECA-825           | 1               | 49187.00  | 4419.00  | 2917.00  | 6440.00  | 3041.00  | 3120.00  | 3865.00  | 4577.00  | 5160.00  | 5146.00  | 2473.00  | 3090.00  | 4939.00  | 0.00     | 
    | EDSK-825       | AECA-825           | 2               | 27132.00  | 1818.00  | 2648.00  | 2875.00  | 227.00   | 1754.00  | 1857.00  | 2529.00  | 3231.00  | 2861.00  | 1255.00  | 2371.00  | 3706.00  | 0.00     | 
    | EDSK-825       | AECA-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECA-825           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECA-825           | 5               | 22055.00  | 2601.00  | 269.00   | 3565.00  | 2814.00  | 1366.00  | 2008.00  | 2048.00  | 1929.00  | 2285.00  | 1218.00  | 719.00   | 1233.00  | 0.00     | 
    | EDSK-825       | AECS-825           | 1               | 47670.00  | 4859.00  | 3545.00  | 5522.00  | 3293.00  | 4543.00  | 1775.00  | 2675.00  | 5412.00  | 5586.00  | 4083.00  | 4888.00  | 1489.00  | 0.00     | 
    | EDSK-825       | AECS-825           | 2               | 21705.00  | 2256.00  | 3180.00  | 3126.00  | 571.00   | 833.00   | 1030.00  | 437.00   | 2216.00  | 3299.00  | 2770.00  | 1638.00  | 349.00   | 0.00     | 
    | EDSK-825       | AECS-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECS-825           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECS-825           | 6               | 25965.00  | 2603.00  | 365.00   | 2396.00  | 2722.00  | 3710.00  | 745.00   | 2238.00  | 3196.00  | 2287.00  | 1313.00  | 3250.00  | 1140.00  | 0.00     | 
    | EDSK-825       | AECT-825           | 1               | 20889.00  | 2216.00  | 516.00   | 2897.00  | 437.00   | 3135.00  | 3426.00  | 1568.00  | 3441.00  | 540.00   | 106.00   | 1410.00  | 1197.00  | 0.00     | 
    | EDSK-825       | AECT-825           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECT-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 1               | 24276.00  | 452.00   | 2008.00  | 56.00    | 3194.00  | 2917.00  | 3748.00  | 1257.00  | 2310.00  | 135.00   | 2957.00  | 3629.00  | 1613.00  | 0.00     | 
    | EDSK-825       | ALLC-825           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   |
    | EDSK-825       | AECA-825           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECA-825           | 2               | 27132.00  | 1818.00  | 2648.00  | 2875.00  | 227.00   | 1754.00  | 1857.00  | 2529.00  | 3231.00  | 2861.00  | 1255.00  | 2371.00  | 3706.00  | 0.00     | 
    | EDSK-825       | AECA-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECA-825           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECA-825           | 5               | 22055.00  | 2601.00  | 269.00   | 3565.00  | 2814.00  | 1366.00  | 2008.00  | 2048.00  | 1929.00  | 2285.00  | 1218.00  | 719.00   | 1233.00  | 0.00     | 
    | EDSK-825       | AECS-825           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECS-825           | 2               | 21705.00  | 2256.00  | 3180.00  | 3126.00  | 571.00   | 833.00   | 1030.00  | 437.00   | 2216.00  | 3299.00  | 2770.00  | 1638.00  | 349.00   | 0.00     | 
    | EDSK-825       | AECS-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECS-825           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECS-825           | 6               | 25965.00  | 2603.00  | 365.00   | 2396.00  | 2722.00  | 3710.00  | 745.00   | 2238.00  | 3196.00  | 2287.00  | 1313.00  | 3250.00  | 1140.00  | 0.00     | 
    | EDSK-825       | AECT-825           | 1               | 20889.00  | 2216.00  | 516.00   | 2897.00  | 437.00   | 3135.00  | 3426.00  | 1568.00  | 3441.00  | 540.00   | 106.00   | 1410.00  | 1197.00  | 0.00     | 
    | EDSK-825       | AECT-825           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECT-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 1               | 24276.00  | 452.00   | 2008.00  | 56.00    | 3194.00  | 2917.00  | 3748.00  | 1257.00  | 2310.00  | 135.00   | 2957.00  | 3629.00  | 1613.00  | 0.00     | 
    | EDSK-825       | ALLC-825           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   |
    | EDSK-825       | AECA-825           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECA-825           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECA-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECA-825           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECA-825           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECS-825           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECS-825           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECS-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECS-825           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECS-825           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECT-825           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECT-825           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECT-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   |
    | EDSK-825       | AECA-825           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECA-825           | 2               | 813.96    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 813.96   | 
    | EDSK-825       | AECA-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECA-825           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECA-825           | 5               | 661.65    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 661.65   | 
    | EDSK-825       | AECS-825           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECS-825           | 2               | 1020.82   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1020.82  | 
    | EDSK-825       | AECS-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECS-825           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECS-825           | 6               | 1221.17   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1221.17  | 
    | EDSK-825       | AECT-825           | 1               | 2841.98   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2841.98  | 
    | EDSK-825       | AECT-825           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECT-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   |
    | EDSK-825       | AECA-825           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECA-825           | 2               | 27945.96  | 1818.00  | 2648.00  | 2875.00  | 227.00   | 1754.00  | 1857.00  | 2529.00  | 3231.00  | 2861.00  | 1255.00  | 2371.00  | 3706.00  | 813.96   | 
    | EDSK-825       | AECA-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECA-825           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECA-825           | 5               | 22716.65  | 2601.00  | 269.00   | 3565.00  | 2814.00  | 1366.00  | 2008.00  | 2048.00  | 1929.00  | 2285.00  | 1218.00  | 719.00   | 1233.00  | 661.65   | 
    | EDSK-825       | AECS-825           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECS-825           | 2               | 22725.82  | 2256.00  | 3180.00  | 3126.00  | 571.00   | 833.00   | 1030.00  | 437.00   | 2216.00  | 3299.00  | 2770.00  | 1638.00  | 349.00   | 1020.82  | 
    | EDSK-825       | AECS-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECS-825           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECS-825           | 6               | 27186.17  | 2603.00  | 365.00   | 2396.00  | 2722.00  | 3710.00  | 745.00   | 2238.00  | 3196.00  | 2287.00  | 1313.00  | 3250.00  | 1140.00  | 1221.17  | 
    | EDSK-825       | AECT-825           | 1               | 23730.98  | 2216.00  | 516.00   | 2897.00  | 437.00   | 3135.00  | 3426.00  | 1568.00  | 3441.00  | 540.00   | 106.00   | 1410.00  | 1197.00  | 2841.98  | 
    | EDSK-825       | AECT-825           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | AECT-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 1               | 24276.00  | 452.00   | 2008.00  | 56.00    | 3194.00  | 2917.00  | 3748.00  | 1257.00  | 2310.00  | 135.00   | 2957.00  | 3629.00  | 1613.00  | 0.00     | 
    | EDSK-825       | ALLC-825           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-825       | ALLC-825           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    | Oct-21    |
    | 10017825 | EDSK-825       | AECA-825           | 2371110                  | 1818.00   | 2648.00   | 2875.00   | 227.00    | 1754.00   | 1857.00   | 2529.00   | 3231.00   | 2861.00   | 1255.00   | 2371.00   | 3706.00   | 0.00      | 
    | 10017825 | EDSK-825       | AECA-825           | 2371130                  | 2601.00   | 269.00    | 3565.00   | 2814.00   | 1366.00   | 2008.00   | 2048.00   | 1929.00   | 2285.00   | 1218.00   | 719.00    | 1233.00   | 0.00      | 
    | 10017825 | EDSK-825       | AECS-825           | 2372091                  | 4859.00   | 3545.00   | 5522.00   | 3293.00   | 4543.00   | 1775.00   | 2675.00   | 5412.00   | 5586.00   | 4083.00   | 4888.00   | 1489.00   | 0.00      | 
    | 10017825 | EDSK-825       | AECT-825           | 2355700                  | 2216.00   | 516.00    | 2897.00   | 437.00    | 3135.00   | 3426.00   | 1568.00   | 3441.00   | 540.00    | 106.00    | 1410.00   | 1197.00   | 0.00      | 
    | 10017825 | EDSK-825       | ALLC-825           | 2303900                  | 452.00    | 2008.00   | 56.00     | 3194.00   | 2917.00   | 3748.00   | 1257.00   | 2310.00   | 135.00    | 2957.00   | 3629.00   | 1613.00   | 0.00      | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    | Oct-21    |
    | 10017825 | EDSK-825       | AECA-825           | 2371175                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 1475.61   | 
    | 10017825 | EDSK-825       | AECS-825           | 101005                   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 2241.99   | 
    | 10017825 | EDSK-825       | AECT-825           | 2355775                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 2841.98   | 
    | 10017825 | EDSK-825       | ALLC-825           | 2303975                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 


    # Tidy up
    Given the override date is reset

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    And   there is no data in the Reconciliation Profiling table for UKPRN '10017825' and FundingPeriod 'AY2021'

@AcceptanceTest @Withdrawn20231002
Scenario: A826 Create and approve an EDSK contract with an AEBC-ASCL2021 alloc. Process a Final Funding Claim where D5 is missing. Over-deliver. Amend contract. Recalc FCR. Publish. Check CRM, PaaS and feed
    
    # 1. Create an approved EDSK contract with just an AEBC-ASCL2021 allocation
    # 2. Inject and consume a Final Funding Claim without a claim value for deliverable 5
    # 3. Claim (£49,510.74) is more than 2x the profile value (£22,451.00). Adjust claim down by £26,000
    # 4. Check calcs
    # 5. Amend (and approve) contract to increase profile by £782
    # 6. Check calcs
    # 7. Publish FCR
    # 8. Check feed 

    Given there are no allocations marked as Under Termination for UKPRN '10017826' 
    And   there are no terminated or closed allocations for UKPRN '10017826' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017826' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017826' 
 
    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table  

    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017826' 

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
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
    | 10017826 |

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECA-826      |

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-826      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-826      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-ASCL2021     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-826       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017826'

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    And   there is no data in the Reconciliation Profiling table for UKPRN '10017826' and FundingPeriod 'AY2021'

    # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
    And   the Reconciliation Profiling table includes a row for UKPRN '10017826' and FundingPeriod 'AY2021'



   # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017826' 
    And   there is no caseload advisor for UKPRN '10017826' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017826 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017826' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017826 Co Ltd' with UKPRN '10017826' and OrgId 'ORG0017826' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017826 | 117826 | 10017826 Co Ltd | 0              | Locked Restructure    | Yes           | AA017826      | ?             | 43 Hill Avenue         | ?                      | ?                      | ?                      | Amersham               | Buckinghamshire        | HP6 5BX   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017826 |





    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-826'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-826'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017826 | 10017826 Co Ltd      | ESFA-826             | EDSK-826       | 1                     | 01/08/2020        | 31/07/2021      | 22451.00      |                       | Conditions of Funding (Grant) (NMSS)       | 2021   | New          | ORG0017826 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName     | UoPCode    | AllocationDescription       | CRMIntent    | DeliveryOrg |
    | 10017826 | EDSK-826       | AECA-826      | AEBC-ASCL         | AEBC-ASCL2021           | AY                      | 01/08/2020          | 31/07/2021        | 22451.00        |             |            |                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                              | CRMIntent    | DeliveryOrg |
    | 10017826 | EDSK-826       | AECA-826      | 1               | 0                     | 22451.00  | 15506.00  | 6945.00   | 2745.00  | 2088.00  | 3077.00  | 112.00   | 2587.00  | 2563.00  | 1654.00  | 680.00   | 2617.00  | 507.00   | 1401.00  | 2420.00  | Adult Skills and Community Learning Total Funding   | New          |             | 
    | 10017826 | EDSK-826       | AECA-826      | 2               | 1                     | 22451.00  | 15506.00  | 6945.00   | 2745.00  | 2088.00  | 3077.00  | 112.00   | 2587.00  | 2563.00  | 1654.00  | 680.00   | 2617.00  | 507.00   | 1401.00  | 2420.00  | Adult Skills Total Funding                          | New          |             | 
#   | 10017826 | EDSK-826       | AECA-826      | 5               | 1                     | 28083.00  | 16465.00  | 11618.00  | 1501.00  | 2741.00  | 1738.00  | 2030.00  | 172.00   | 3028.00  | 2845.00  | 2410.00  | 3715.00  | 3502.00  | 1422.00  | 2979.00  | Community Learning                                  | New          |             | 


    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-826       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-826'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-826' and actual ContractNumber 'EDSK-826'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-826' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017826 | EDSK-826           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017826 | ESFA-826           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-826' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'EDSK-826'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECA-826        | 2371175          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                     | DeliverableDescription       | 
    | 10017826 | EDSK-826       | 1               | AECA-826      | 1               | 0                     | 22451.00     | 0             | 0        | Adult Skills and Community Learning Total Funding   | ?                            |
    | 10017826 | EDSK-826       | 1               | AECA-826      | 2               | 1                     | 22451.00     | 0             | 0        | Adult Skills Total Funding                          | ?                            |
#   | 10017826 | EDSK-826       | 1               | AECA-826      | 5               | 1                     | 28083.00     | 0             | 0        | Community Learning                                  | ?                            |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-826' agree with the most recent entry for this contract in the ContractManagement feed





    # Populate stub with Claim data

    # Change the date
    Given the override date is '28/09/2021'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017826     | 10017826 | 3                  | Final         | AY             | 2021   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017826     | 10017826 | 3                  | Final         | AY             | 2021   | AECA-826      | AEBC-ASCL2021           |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017826     | 10017826 | 3                  | Final         | AY             | 2021   | AECA-826      | 3               | 7362.00     | 72.76         | 13.23           | 7447.99    |
    | ORG0017826     | 10017826 | 3                  | Final         | AY             | 2021   | AECA-826      | 4               | 6835.00     | 38.13         | 7.97            | 6881.10    |
#   | ORG0017826     | 10017826 | 3                  | Final         | AY             | 2021   | AECA-826      | 5               | 6456.00     | 67.98         | 7.30            | 6531.28    |
    | ORG0017826     | 10017826 | 3                  | Final         | AY             | 2021   | AECA-826      | 6               | 7200.00     | 36.72         | 12.40           | 7249.12    |
    | ORG0017826     | 10017826 | 3                  | Final         | AY             | 2021   | AECA-826      | 7               | 6416.00     | 71.67         | 9.47            | 6497.14    |
    | ORG0017826     | 10017826 | 3                  | Final         | AY             | 2021   | AECA-826      | 8               | 7085.00     | 35.13         | 11.25           | 7131.38    |
    | ORG0017826     | 10017826 | 3                  | Final         | AY             | 2021   | AECA-826      | 9               | 6862.00     | 61.40         | 13.74           | 6937.14    |
    | ORG0017826     | 10017826 | 3                  | Final         | AY             | 2021   | AECA-826      | 10              | 7292.00     | 62.76         | 12.11           | 7366.87    |
    #                                                                                                                                                                           £ 49510.74  





    # Consume stub data

    # Change the date
    Given the override date is '29/09/2021'

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM (Planned value * Over-Delivery Limit = ProposedReconciliationValue ie 22,451.00 * 3% = 673.53) 
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | 3                  | 22451.00     | 49510.74     | 673.53                      | 673.53              | 49510.74         | 0.00            | 49510.74                 | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | 22451.00     | 49510.74     | 673.53                      | 673.53              | 49510.74         | 0.00            | ?                     | 49510.74                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | AEBC-ASCL-2021       | 3               | Adult Skills Programme Funding                         | 0.00         | 7447.99      |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | AEBC-ASCL-2021       | 4               | Adult Skills Learning Support                          | 0.00         | 6881.10      |
#   | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | AEBC-ASCL-2021       | 5               | Community Learning                                     | 0.00         | 6531.28      |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | AEBC-ASCL-2021       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 7249.12      |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | AEBC-ASCL-2021       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 6497.14      |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | AEBC-ASCL-2021       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 7131.38      |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | AEBC-ASCL-2021       | 9               | Adult Skills Administration Expenditure                | 0.00         | 6937.14      |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | AEBC-ASCL-2021       | 10              | Learner Support - COVID-19 Response                    | 0.00         | 7366.87      |
    #                                                                                                                                                                                                   £ 49510.74  





    # Update FCR

    # Change the date 
    Given the override date is '30/09/2021'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither ... 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | 3                  | AECA-826      | 22451.00     | 49510.74     | 673.53                      | 673.53              | 49510.74         | -26000.00       | Ineligible Data       |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | 3                  | 22451.00     | 49510.74     | 673.53                      | 673.53              | 49510.74         | -26000.00       | 23510.74                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | 22451.00     | 49510.74     | 673.53                      | 673.53              | 49510.74         | -26000.00       | Ineligible Data       | 23510.74                 |





    # Bulk file contract amendment. Increase Profile by £782 (from £22,451 to £23,233)

    # Change the date 
    Given the override date is '01/10/2021'

    # Bulk file
    And   there are no files prefixed '10017826' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 15092021104333 v3_A826' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 15092021104333 v3_A826' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 15092021104333 v3_A826' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 15092021104333 v3_A826' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 15092021104333 v3_A826.xlsx' exists in the Datafiles folder and UKPRN '10017826' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Contract status is now at 'Awaiting Documentation'





    # Publish and approve v2

    # Change the date 
    Given the override date is '02/10/2021'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-826'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-826' and actual ContractNumber 'EDSK-826'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-826' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017826 | EDSK-826           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017826 | EDSK-826           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017826 | ESFA-826           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    And wait '10' seconds

    # Check the details in CRM 
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | 3                  | 23233.00     | 49510.74     | 277.74                      | 673.53              | 49510.74         | -26000.00       | 23510.74                 | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | 23233.00     | 49510.74     | 277.74                      | 673.53              | 49510.74         | -26000.00       | Ineligible Data       | 23510.74                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | AEBC-ASCL-2021       | 3               | Adult Skills Programme Funding                         | 0.00         | 7447.99      |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | AEBC-ASCL-2021       | 4               | Adult Skills Learning Support                          | 0.00         | 6881.10      |
#   | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | AEBC-ASCL-2021       | 5               | Community Learning                                     | 0.00         | 6531.28      |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | AEBC-ASCL-2021       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 7249.12      |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | AEBC-ASCL-2021       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 6497.14      |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | AEBC-ASCL-2021       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 7131.38      |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | AEBC-ASCL-2021       | 9               | Adult Skills Administration Expenditure                | 0.00         | 6937.14      |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | AECA-826      | AEBC-ASCL-2021       | 10              | Learner Support - COVID-19 Response                    | 0.00         | 7366.87      |
    #                                                                                                                                                                                                   £ 49510.74  





    # Publish FCR
 
    # Change the date
    Given the override date is '03/10/2021'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2021-Final' and Allocation Group Code 'AEBC-ASCL2021'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2021-Final' and Allocation Group Code 'AEBC-ASCL2021'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | 3                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | 3                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017826 | 2021          | Final            | AEBC-ASCL2021       | 3                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                               | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017826 | AECA-826         | 2021   | Final         | AEB (College) - Adult Skills and Community Learning 20/21         | 23233.00     | 49510.74     | 277.74                      | 673.53                   | 49510.74           | -26000.00       | Ineligible Data       | 23510.74                 |



    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   |
    | EDSK-826       | AECA-826           | 1               | 23233.00  | 2745.00  | 2088.00  | 3077.00  | 894.00   | 2587.00  | 2563.00  | 1654.00  | 680.00   | 2617.00  | 507.00   | 1401.00  | 2420.00  | 0.00     | 
    | EDSK-826       | AECA-826           | 2               | 23233.00  | 2745.00  | 2088.00  | 3077.00  | 894.00   | 2587.00  | 2563.00  | 1654.00  | 680.00   | 2617.00  | 507.00   | 1401.00  | 2420.00  | 0.00     | 
    | EDSK-826       | AECA-826           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-826       | AECA-826           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-826       | AECA-826           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   |
    | EDSK-826       | AECA-826           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-826       | AECA-826           | 2               | 22451.00  | 2745.00  | 2088.00  | 3077.00  | 112.00   | 2587.00  | 2563.00  | 1654.00  | 680.00   | 2617.00  | 507.00   | 1401.00  | 2420.00  | 0.00     | 
    | EDSK-826       | AECA-826           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-826       | AECA-826           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-826       | AECA-826           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   |
    | EDSK-826       | AECA-826           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-826       | AECA-826           | 2               | 782.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 782.00   | 
    | EDSK-826       | AECA-826           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-826       | AECA-826           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-826       | AECA-826           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   |
    | EDSK-826       | AECA-826           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-826       | AECA-826           | 2               | 673.53    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 673.53   | 
    | EDSK-826       | AECA-826           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-826       | AECA-826           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-826       | AECA-826           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   |
    | EDSK-826       | AECA-826           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-826       | AECA-826           | 2               | 23906.53  | 2745.00  | 2088.00  | 3077.00  | 112.00   | 2587.00  | 2563.00  | 1654.00  | 680.00   | 2617.00  | 507.00   | 1401.00  | 2420.00  | 1455.53  | 
    | EDSK-826       | AECA-826           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-826       | AECA-826           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-826       | AECA-826           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    | Oct-21    |
    | 10017826 | EDSK-826       | AECA-826           | 2371110                  | 2745.00   | 2088.00   | 3077.00   | 112.00    | 2587.00   | 2563.00   | 1654.00   | 680.00    | 2617.00   | 507.00    | 1401.00   | 2420.00   | 782.00    | 
    | 10017826 | EDSK-826       | AECA-826           | 2371130                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    | Oct-21    |
    | 10017826 | EDSK-826       | AECA-826           | 2371175                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 673.53    | 


    # Tidy Up
    Given the override date is reset

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    And   there is no data in the Reconciliation Profiling table for UKPRN '10017826' and FundingPeriod 'AY2021'

@AcceptanceTest @Withdrawn20231002
Scenario: A828 Create and approve an EDSK contract with an AEBC-ASCL2021 alloc. Process a Final Funding Claim with D5. Under-deliver. Publish. Check CRM, PaaS and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017828' 
    And   there are no terminated or closed allocations for UKPRN '10017828' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017828' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017828' 
 
    # Clear down ContractRequest.FundingAllocationRelease table (J146). 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017828' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-828      |

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECA-828      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-828      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-ASCL2021     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-828       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017828'

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
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
    | 10017828 |

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    Given there is no data in the Reconciliation Profiling table for UKPRN '10017828' and FundingPeriod 'AY2021'

    # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
    And   the Reconciliation Profiling table includes a row for UKPRN '10017828' and FundingPeriod 'AY2021'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017828' 
    And   there is no caseload advisor for UKPRN '10017828' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017828 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017828' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017828 Co Ltd' with UKPRN '10017828' and OrgId 'ORG0017828' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017828 | 117828 | 10017828 Co Ltd | 0              | Provider Under Change | Yes           | AA017828      | ?             | 41 Send Barns Lane     | Send                   | Woking                 | ?                      | ?                      | Surrey                 | GU23 7BS  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017828 |





    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-828'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-828'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017828 | 10017828 Co Ltd      | ESFA-828             | EDSK-828       | 1                     | 01/08/2020        | 31/07/2021      | 46756.00      |                                       | Conditions of Funding (Grant) (Employer)   | 2021   | New          | ORG0017828 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017828 | EDSK-828       | AECA-828      | AEBC-ASCL         | AEBC-ASCL2021           | AY                      | 01/08/2020          | 31/07/2021        | 46756.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017828 | EDSK-828       | AECA-828      | 1               | 0                     | 46756.00  | 28797.00  | 17959.00  | 6110.00  | 4608.00  | 1713.00  | 2014.00  | 2093.00  | 5557.00  | 2568.00  | 4134.00  | 4119.00  | 5147.00  | 4782.00  | 3911.00  | Adult Skills and Community Learning Total Funding               | New          |             | 
    | 10017828 | EDSK-828       | AECA-828      | 2               | 1                     | 18779.00  | 10388.00  | 8391.00   | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | Adult Skills Total Funding                                      | New          |             | 
    | 10017828 | EDSK-828       | AECA-828      | 5               | 1                     | 27977.00  | 18409.00  | 9568.00   | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | Community Learning                                              | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-828       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-828'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-828' and actual ContractNumber 'EDSK-828'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-828' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017828 | EDSK-828           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017828 | ESFA-828           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-828' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'EDSK-828'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECA-828        | 2371175          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017828 | EDSK-828       | 1               | AECA-828      | 1               | 0                     | 46756.00     | 0             | 0        | Adult Skills and Community Learning Total Funding               | ?                                                           |
    | 10017828 | EDSK-828       | 1               | AECA-828      | 2               | 1                     | 18779.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
    | 10017828 | EDSK-828       | 1               | AECA-828      | 5               | 1                     | 27977.00     | 0             | 0        | Community Learning                                              | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-828' agree with the most recent entry for this contract in the ContractManagement feed





    # Funding Claims ...
    
   # Populate stub with Claim data

    # Change the date
    Given the override date is '14/11/2021'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017828     | 10017828 | 2                  | Final         | AY             | 2021   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017828     | 10017828 | 2                  | Final         | AY             | 2021   | AECA-828      | AEBC-ASCL2021           |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017828     | 10017828 | 2                  | Final         | AY             | 2021   | AECA-828      | 3               | 406.00      | 58.03         | 5.39            | 469.42     |
    | ORG0017828     | 10017828 | 2                  | Final         | AY             | 2021   | AECA-828      | 4               | 712.00      | 29.10         | 7.19            | 748.29     |
    | ORG0017828     | 10017828 | 2                  | Final         | AY             | 2021   | AECA-828      | 5               | 5641.00     | 44.28         | 7.53            | 5692.81    |
    | ORG0017828     | 10017828 | 2                  | Final         | AY             | 2021   | AECA-828      | 6               | 5785.00     | 32.44         | 6.26            | 5823.70    |
    | ORG0017828     | 10017828 | 2                  | Final         | AY             | 2021   | AECA-828      | 7               | 4857.00     | 30.84         | 7.75            | 4895.59    |
    | ORG0017828     | 10017828 | 2                  | Final         | AY             | 2021   | AECA-828      | 8               | 4812.00     | 41.47         | 9.12            | 4862.59    |
    | ORG0017828     | 10017828 | 2                  | Final         | AY             | 2021   | AECA-828      | 9               | 4900.00     | 35.25         | 12.92           | 4948.17    |
    | ORG0017828     | 10017828 | 2                  | Final         | AY             | 2021   | AECA-828      | 10              | 4785.00     | 34.38         | 8.45            | 4827.83    |
    #                                                                                                                                                                            £ 32268.40  





    # Consume stub data

    # Change the date
    Given the override date is '16/11/2021'

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017828 | 2021          | Final            | AEBC-ASCL2021       | 2                  | 46756.00     | 32268.40     | -9812.00                    | -9812.00            | 32268.40         | 0.00            | 32268.40                 | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017828 | 2021          | Final            | AEBC-ASCL2021       | AECA-828      | 46756.00     | 32268.40     | -9812.00                    | -9812.00            | 32268.40         | 0.00            | ?                     | 32268.40                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017828 | 2021          | Final            | AEBC-ASCL2021       | AECA-828      | AEBC-ASCL-2021       | 3               | Adult Skills Programme Funding                         | 0.00         | 469.42       |
    | 10017828 | 2021          | Final            | AEBC-ASCL2021       | AECA-828      | AEBC-ASCL-2021       | 4               | Adult Skills Learning Support                          | 0.00         | 748.29       |
    | 10017828 | 2021          | Final            | AEBC-ASCL2021       | AECA-828      | AEBC-ASCL-2021       | 5               | Community Learning                                     | 27977.00     | 5692.81      |
    | 10017828 | 2021          | Final            | AEBC-ASCL2021       | AECA-828      | AEBC-ASCL-2021       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 5823.70      |
    | 10017828 | 2021          | Final            | AEBC-ASCL2021       | AECA-828      | AEBC-ASCL-2021       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 4895.59      |
    | 10017828 | 2021          | Final            | AEBC-ASCL2021       | AECA-828      | AEBC-ASCL-2021       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 4862.59      |
    | 10017828 | 2021          | Final            | AEBC-ASCL2021       | AECA-828      | AEBC-ASCL-2021       | 9               | Adult Skills Administration Expenditure                | 0.00         | 4948.17      |
    | 10017828 | 2021          | Final            | AEBC-ASCL2021       | AECA-828      | AEBC-ASCL-2021       | 10              | Learner Support - COVID-19 Response                    | 0.00         | 4827.83      |





    # Update FCR

    # Change the date 
    Given the override date is '18/11/2021'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither ... 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017828 | 2021          | Final            | AEBC-ASCL2021       | 2                  | AECA-828      | 46756.00     | 32268.40     | -9812.00                    | -9812.00            | 32268.40         | ?               | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017828 | 2021          | Final            | AEBC-ASCL2021       | 2                  | 46756.00     | 32268.40     | -9812.00                    | -9812.00            | 32268.40         | ?               | 32268.40                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017828 | 2021          | Final            | AEBC-ASCL2021       | AECA-828      | 46756.00     | 32268.40     | -9812.00                    | -9812.00            | 32268.40         | ?               | ?                     | 32268.40                 |





    # Publish FCR

    # Change the date
    Given the override date is '20/11/2021'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2021-Final' and Allocation Group Code 'AEBC-ASCL2021'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2021-Final' and Allocation Group Code 'AEBC-ASCL2021'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017828 | 2021          | Final            | AEBC-ASCL2021       | 2                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017828 | 2021          | Final            | AEBC-ASCL2021       | 2                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017828 | 2021          | Final            | AEBC-ASCL2021       | 2                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                               | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017828 | AECA-828         | 2021   | Final         | AEB (College) - Adult Skills and Community Learning 20/21         | 46756.00     | 32268.40     | -9812.00                    | -9812.00                 | 32268.40           | ?               | ?                     | 32268.40                 |

 

     # Check Financials 


    # Check the deliverable count in CRM (12 mths x 5 deliverables) + (4 mths x 5 deliverables) = 80 deliverable periods
    And   there are '80' deliverable period rows in CRM linked to the latest version of contract 'EDSK-828'

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | EDSK-828       | AECA-828           | 1               | 46756.00  | 6110.00  | 4608.00  | 1713.00  | 2014.00  | 2093.00  | 5557.00  | 2568.00  | 4134.00  | 4119.00  | 5147.00  | 4782.00  | 3911.00  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 2               | 18779.00  | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 5               | 27977.00  | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | EDSK-828       | AECA-828           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 2               | 18779.00  | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 5               | 27977.00  | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | EDSK-828       | AECA-828           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | EDSK-828       | AECA-828           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 2               | -3940.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -985.21  | -985.21  | -985.21  | -985.24  | 
    | EDSK-828       | AECA-828           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 5               | -5871.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1467.78 | -1467.78 | -1467.78 | -1467.79 | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | EDSK-828       | AECA-828           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 2               | 14838.13  | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | -985.21  | -985.21  | -985.21  | -985.24  | 
    | EDSK-828       | AECA-828           | 5               | 22105.87  | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | -1467.78 | -1467.78 | -1467.78 | -1467.79 | 
    | EDSK-828       | AECA-828           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-828       | AECA-828           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 



    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    |
    | 10017828 | EDSK-828       | AECA-828           | 2371110                  | 3160.00   | 2631.00   | 1500.00   | 210.00    | 378.00    | 1841.00   | 171.00    | 497.00    | 1485.00   | 2221.00   | 3714.00   | 971.00    | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017828 | EDSK-828       | AECA-828           | 2371130                  | 2950.00   | 1977.00   | 213.00    | 1804.00   | 1715.00   | 3716.00   | 2397.00   | 3637.00   | 2634.00   | 2926.00   | 1068.00   | 2940.00   | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    |
    | 10017828 | EDSK-828       | AECA-828           | 2371175                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | -2452.99  | -2452.99  | -2452.99  | -2453.03  | 
    

    # Tidy up
    Given the override date is reset

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    And   there is no data in the Reconciliation Profiling table for UKPRN '10017828' and FundingPeriod 'AY2021'

@AcceptanceTest @Withdrawn20231002
Scenario: A829 Create and approve an EDSK contract with an AEBC-ASCL2021 alloc. Process a Final Funding Claim with D5. Deliver nothing. Clawback everything. Publish. Check CRM, PaaS and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017829' 
    And   there are no terminated or closed allocations for UKPRN '10017829' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017829' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017829' 
 
    # Clear down ContractRequest.FundingAllocationRelease table (J146). 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017829' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-829      |

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECA-829      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-829      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-ASCL2021     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-829       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017829'

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
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
    | 10017829 |

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    Given there is no data in the Reconciliation Profiling table for UKPRN '10017829' and FundingPeriod 'AY2021'

   # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
   And   the Reconciliation Profiling table includes a row for UKPRN '10017829' and FundingPeriod 'AY2021'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017829' 
    And   there is no caseload advisor for UKPRN '10017829' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017829 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017829' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017829 Co Ltd' with UKPRN '10017829' and OrgId 'ORG0017829' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017829 | 117829 | 10017829 Co Ltd | 0              | Provider Under Change | Yes           | AA017829      | ?             | 41 Send Barns Lane     | Send                   | Woking                 | ?                      | ?                      | Surrey                 | GU23 7BS  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017829 |





    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-829'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-829'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017829 | 10017829 Co Ltd      | ESFA-829             | EDSK-829       | 1                     | 01/08/2020        | 31/07/2021      | 46756.00      |                                       | Conditions of Funding (Grant) (Employer)   | 2021   | New          | ORG0017829 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017829 | EDSK-829       | AECA-829      | AEBC-ASCL         | AEBC-ASCL2021           | AY                      | 01/08/2020          | 31/07/2021        | 46756.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017829 | EDSK-829       | AECA-829      | 1               | 0                     | 46756.00  | 28797.00  | 17959.00  | 6110.00  | 4608.00  | 1713.00  | 2014.00  | 2093.00  | 5557.00  | 2568.00  | 4134.00  | 4119.00  | 5147.00  | 4782.00  | 3911.00  | Adult Skills and Community Learning Total Funding               | New          |             | 
    | 10017829 | EDSK-829       | AECA-829      | 2               | 1                     | 18779.00  | 10388.00  | 8391.00   | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | Adult Skills Total Funding                                      | New          |             | 
    | 10017829 | EDSK-829       | AECA-829      | 5               | 1                     | 27977.00  | 18409.00  | 9568.00   | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | Community Learning                                              | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-829       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-829'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-829' and actual ContractNumber 'EDSK-829'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-829' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017829 | EDSK-829           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017829 | ESFA-829           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-829' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'EDSK-829'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECA-829        | 2371175          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017829 | EDSK-829       | 1               | AECA-829      | 1               | 0                     | 46756.00     | 0             | 0        | Adult Skills and Community Learning Total Funding               | ?                                                           |
    | 10017829 | EDSK-829       | 1               | AECA-829      | 2               | 1                     | 18779.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
    | 10017829 | EDSK-829       | 1               | AECA-829      | 5               | 1                     | 27977.00     | 0             | 0        | Community Learning                                              | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-829' agree with the most recent entry for this contract in the ContractManagement feed





    # Funding Claims ...
    
    # Populate stub with Claim data

    # Change the date
    Given the override date is '14/11/2021'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017829     | 10017829 | 2                  | Final         | AY             | 2021   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017829     | 10017829 | 2                  | Final         | AY             | 2021   | AECA-829      | AEBC-ASCL2021           |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017829     | 10017829 | 2                  | Final         | AY             | 2021   | AECA-829      | 3               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0017829     | 10017829 | 2                  | Final         | AY             | 2021   | AECA-829      | 4               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0017829     | 10017829 | 2                  | Final         | AY             | 2021   | AECA-829      | 5               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0017829     | 10017829 | 2                  | Final         | AY             | 2021   | AECA-829      | 6               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0017829     | 10017829 | 2                  | Final         | AY             | 2021   | AECA-829      | 7               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0017829     | 10017829 | 2                  | Final         | AY             | 2021   | AECA-829      | 8               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0017829     | 10017829 | 2                  | Final         | AY             | 2021   | AECA-829      | 9               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0017829     | 10017829 | 2                  | Final         | AY             | 2021   | AECA-829      | 10              | 0.00        | 0.00          | 0.00            | 0.00       |
    #                                                                                                                                                                            £ 0.00  





    # Consume stub data

    # Change the date
    Given the override date is '16/11/2021'

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017829 | 2021          | Final            | AEBC-ASCL2021       | 2                  | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | 0.00            | 0.00                     | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017829 | 2021          | Final            | AEBC-ASCL2021       | AECA-829      | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | 0.00            | ?                     | 0.00                     |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017829 | 2021          | Final            | AEBC-ASCL2021       | AECA-829      | AEBC-ASCL-2021       | 3               | Adult Skills Programme Funding                         | 0.00         | 0.00         |
    | 10017829 | 2021          | Final            | AEBC-ASCL2021       | AECA-829      | AEBC-ASCL-2021       | 4               | Adult Skills Learning Support                          | 0.00         | 0.00         |
    | 10017829 | 2021          | Final            | AEBC-ASCL2021       | AECA-829      | AEBC-ASCL-2021       | 5               | Community Learning                                     | 27977.00     | 0.00         |
    | 10017829 | 2021          | Final            | AEBC-ASCL2021       | AECA-829      | AEBC-ASCL-2021       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 0.00         |
    | 10017829 | 2021          | Final            | AEBC-ASCL2021       | AECA-829      | AEBC-ASCL-2021       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 0.00         |
    | 10017829 | 2021          | Final            | AEBC-ASCL2021       | AECA-829      | AEBC-ASCL-2021       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 0.00         |
    | 10017829 | 2021          | Final            | AEBC-ASCL2021       | AECA-829      | AEBC-ASCL-2021       | 9               | Adult Skills Administration Expenditure                | 0.00         | 0.00         |
    | 10017829 | 2021          | Final            | AEBC-ASCL2021       | AECA-829      | AEBC-ASCL-2021       | 10              | Learner Support - COVID-19 Response                    | 0.00         | 0.00         |





    # Update FCR

    # Change the date 
    Given the override date is '18/11/2021'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither ... 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017829 | 2021          | Final            | AEBC-ASCL2021       | 2                  | AECA-829      | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | ?               | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017829 | 2021          | Final            | AEBC-ASCL2021       | 2                  | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | ?               | 0.00                     | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017829 | 2021          | Final            | AEBC-ASCL2021       | AECA-829      | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | ?               | ?                     | 0.00                     |





    # Publish FCR

    # Change the date
    Given the override date is '20/11/2021'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2021-Final' and Allocation Group Code 'AEBC-ASCL2021'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2021-Final' and Allocation Group Code 'AEBC-ASCL2021'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017829 | 2021          | Final            | AEBC-ASCL2021       | 2                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017829 | 2021          | Final            | AEBC-ASCL2021       | 2                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017829 | 2021          | Final            | AEBC-ASCL2021       | 2                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                               | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017829 | AECA-829         | 2021   | Final         | AEB (College) - Adult Skills and Community Learning 20/21         | 46756.00     | 0.00         | -46756.00                   | -46756.00                | 0.00               | ?               | ?                     | 0.00                     |

 

     # Check Financials 


    # Check the deliverable count in CRM (12 mths x 5 deliverables) + (4 mths x 5 deliverables) = 80 deliverable periods
    And   there are '80' deliverable period rows in CRM linked to the latest version of contract 'EDSK-829'

   # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | EDSK-829       | AECA-829           | 1               | 46756.00  | 6110.00  | 4608.00  | 1713.00  | 2014.00  | 2093.00  | 5557.00  | 2568.00  | 4134.00  | 4119.00  | 5147.00  | 4782.00  | 3911.00  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 2               | 18779.00  | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 5               | 27977.00  | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | EDSK-829       | AECA-829           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 2               | 18779.00  | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 5               | 27977.00  | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | EDSK-829       | AECA-829           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | EDSK-829       | AECA-829           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 2               | -18779.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4694.75 | -4694.75 | -4694.75 | -4694.75 | 
    | EDSK-829       | AECA-829           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 5               | -27977.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6994.25 | -6994.25 | -6994.25 | -6994.25 | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | EDSK-829       | AECA-829           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 2               | 0.00      | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | -4694.75 | -4694.75 | -4694.75 | -4694.75 | 
    | EDSK-829       | AECA-829           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 5               | 0.00      | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | -6994.25 | -6994.25 | -6994.25 | -6994.25 | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    |
    | 10017829 | EDSK-829       | AECA-829           | 2371110                  | 3160.00   | 2631.00   | 1500.00   | 210.00    | 378.00    | 1841.00   | 171.00    | 497.00    | 1485.00   | 2221.00   | 3714.00   | 971.00    | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017829 | EDSK-829       | AECA-829           | 2371130                  | 2950.00   | 1977.00   | 213.00    | 1804.00   | 1715.00   | 3716.00   | 2397.00   | 3637.00   | 2634.00   | 2926.00   | 1068.00   | 2940.00   | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    |
    | 10017829 | EDSK-829       | AECA-829           | 2371175                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | -11689.00 | -11689.00 | -11689.00 | -11689.00 | 
    




    # Amend contract
    
    # Change the date
    Given the override date is '12/01/2022'
    
    # Bulk file
    And   there are no files prefixed '10017203' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 30092021164257 v3_A829' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 30092021164257 v3_A829' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 30092021164257 v3_A829' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 30092021164257 v3_A829' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 30092021164257 v3_A829.xlsx' exists in the Datafiles folder and UKPRN '10017829' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-829'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-829' and actual ContractNumber 'EDSK-829'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-829' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017829 | EDSK-829           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017829 | EDSK-829           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017829 | ESFA-829           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Check the deliverable count in CRM (12 mths x 5 deliverables) + (4 mths x 5 deliverables) = 80 deliverable periods
    And   there are '80' deliverable period rows in CRM linked to the latest version of contract 'EDSK-829'

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | EDSK-829       | AECA-829           | 1               | 45921.00  | 3862.00  | 3266.00  | 3118.00  | 1929.00  | 5497.00  | 3586.00  | 3108.00  | 4605.00  | 6439.00  | 3987.00  | 5114.00  | 1410.00  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 2               | 21473.00  | 3120.00  | 1961.00  | 1389.00  | 1474.00  | 1220.00  | 1984.00  | 1642.00  | 1570.00  | 1174.00  | 3362.00  | 1347.00  | 1230.00  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 5               | 24448.00  | 742.00   | 1305.00  | 1729.00  | 455.00   | 4277.00  | 1602.00  | 1466.00  | 3035.00  | 5265.00  | 625.00   | 3767.00  | 180.00   | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | EDSK-829       | AECA-829           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 2               | 18779.00  | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 5               | 27977.00  | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | EDSK-829       | AECA-829           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | EDSK-829       | AECA-829           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 2               | -18779.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4694.75 | -4694.75 | -4694.75 | -4694.75 | 
    | EDSK-829       | AECA-829           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 5               | -27977.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6994.25 | -6994.25 | -6994.25 | -6994.25 | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | EDSK-829       | AECA-829           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 2               | 0.00      | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | -4694.75 | -4694.75 | -4694.75 | -4694.75 | 
    | EDSK-829       | AECA-829           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-829       | AECA-829           | 5               | 0.00      | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | -6994.25 | -6994.25 | -6994.25 | -6994.25 | 
    

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    |
    | 10017829 | EDSK-829       | AECA-829           | 2371110                  | 3160.00   | 2631.00   | 1500.00   | 210.00    | 378.00    | 1841.00   | 171.00    | 497.00    | 1485.00   | 2221.00   | 3714.00   | 971.00    | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017829 | EDSK-829       | AECA-829           | 2371130                  | 2950.00   | 1977.00   | 213.00    | 1804.00   | 1715.00   | 3716.00   | 2397.00   | 3637.00   | 2634.00   | 2926.00   | 1068.00   | 2940.00   | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    |
    | 10017829 | EDSK-829       | AECA-829           | 2371175                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | -11689.00 | -11689.00 | -11689.00 | -11689.00 | 


    # Tidy up
    Given the override date is reset

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    And   there is no data in the Reconciliation Profiling table for UKPRN '10017829' and FundingPeriod 'AY2021'

