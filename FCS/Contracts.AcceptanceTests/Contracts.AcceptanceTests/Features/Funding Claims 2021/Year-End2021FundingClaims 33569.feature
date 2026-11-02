Feature: Year-End2021FundingClaims 33569

@AcceptanceTest @Withdrawn20230123
@FundingClaim
Scenario: A586 Create and approve a 19-24 Traineeships contract with a 19TRN2020-LS2021 alloc. Process a YearEnd Funding Claim with under-delivery. Check CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017586' 
    And   there are no terminated or closed allocations for UKPRN '10017586' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017586' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017586' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017586' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 19TL-586      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 19TL-586      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 19TRN2020-LS2021  |

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | 19TL-586      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | 19TR20-586     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017586'


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017586' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017586 Co Ltd' with UKPRN '10017586' and OrgId 'ORG0017586' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017586' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017586 | 117586 | 10017586 Co Ltd | 0              | Locked Restructure    | Yes           | AA017586      | ?             | 4 White Oak Square     | London Road            | ?                      | ?                      | Swanley                | Kent                   | BR8 7AG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017586 |





    # Change the date
    Given the override date is '07/02/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-586'
    And   there are no details on ContractManagement.CreatedContract for '19TR20-586'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017586 | 10017586 Co Ltd      | ESFA-586             | 19TR20-586     | 1                     | 01/02/2021        | 31/07/2021      | 12539.00      |                                       | Contract for Services                      | 2021   | New          | ORG0017586 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017586 | 19TR20-586     | 19TL-586      | 19TRN2020-LS      | 19TRN2020-LS2021        | AY                      | 01/02/2021          | 31/07/2021        | 12539.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017586 | 19TR20-586     | 19TL-586      | 1               | 0                     | 12539.00  | 1632.00  | 2749.00  | 382.00   | 1815.00  | 3183.00  | 2778.00  | 19-24 Traineeships Learner Support Total Funding                | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-586'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-586' and actual ContractNumber '19TR20-586'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-586' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017586 | 19TR20-586         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/02/2021        | 31/07/2021      | ?             |
    | 10017586 | ESFA-586           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-586' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '6' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '6' deliverable period rows in CRM linked to the latest version of contract '19TR20-586'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TL-586        | 2355875          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017586 | 19TR20-586     | 1               | 19TL-586      | 1               | 0                     | 12539.00     | 0             | 0        | 19-24 Traineeships Learner Support Total Funding                | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-586' agree with the most recent entry for this contract in the ContractManagement feed





    # Funding Claims ...

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
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
    | 10017586 |

    # Populate stub with Claim data

    # Change the date
    Given the override date is '09/07/2021'

    #Set up claim data from DC for a 'Year End'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017586     | 10017586 | 3                  | Year End      | AY             | 2021   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017586     | 10017586 | 3                  | Year End      | AY             | 2021   | 19TL-586      | 19TRN2020-LS2021        |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017586     | 10017586 | 3                  | Year End      | AY             | 2021   | 19TL-586      | 2               | 5080.00     | 71.62         | 13.84           | 5165.46    |
    | ORG0017586     | 10017586 | 3                  | Year End      | AY             | 2021   | 19TL-586      | 3               | 5564.00     | 74.35         | 8.92            | 5647.27    |
    #                                                                                                                                                                            £ 10812.73  

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed




    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017586 | 2021          | Year End         | 19TRN2020-LS2021    | 3                  | 12539.00     | 10812.73     | -1726.27                    | -1726.27            | 10812.73         | 0.00            | 10812.73                 | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017586 | 2021          | Year End         | 19TRN2020-LS2021    | 19TL-586      | 12539.00     | 10812.73     | -1726.27                    | -1726.27            | 10812.73         | 0.00            | ?                     | 10812.73                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017586 | 2021          | Year End         | 19TRN2020-LS2021    | 19TL-586      | 19TRN2020-LS2021     | 2               | 19-24 Traineeships Learner Support                     | 0.00         | 5165.46      |
    | 10017586 | 2021          | Year End         | 19TRN2020-LS2021    | 19TL-586      | 19TRN2020-LS2021     | 3               | 19-24 Traineeships Administration Expenditure          | 0.00         | 5647.27      |




    # Change the date 
    Given the override date is '11/07/2021'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither ... 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017586 | 2021          | Year End         | 19TRN2020-LS2021    | 3                  | 19TL-586      | 12539.00     | 10812.73     | -1726.27                    | -1726.27            | 10812.73         | 0.00            | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017586 | 2021          | Year End         | 19TRN2020-LS2021    | 3                  | 12539.00     | 10812.73     | -1726.27                    | -1726.27            | 10812.73         | 0.00            | 10812.73                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017586 | 2021          | Year End         | 19TRN2020-LS2021    | 19TL-586      | 12539.00     | 10812.73     | -1726.27                    | -1726.27            | 10812.73         | 0.00            | ?                     | 10812.73                 |




    # Change the date
    Given the override date is '13/07/2021'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2021-YearEnd' and Allocation Group Code '19TRN2020-LS2021'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2021-YearEnd' and Allocation Group Code '19TRN2020-LS2021'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017586 | 2021          | Year End         | 19TRN2020-LS2021    | 3                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017586 | 2021          | Year End         | 19TRN2020-LS2021    | 3                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017586 | 2021          | Year End         | 19TRN2020-LS2021    | 3                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                               | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017586 | 19TL-586         | 2021   | Year End      | 19-24 Traineeships - 2020 Procurement - Learner Support 20/21     | 12539.00     | 10812.73     | -1726.27                    | -1726.27                 | 10812.73           | ?               | ?                     | 10812.73                 |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
@FundingClaim
Scenario: A587 Create and approve an AEB contract with 19TRLS and ASLS allocs. Process a YearEnd Funding Claim with under-delivery. Check CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017587' 
    And   there are no terminated or closed allocations for UKPRN '10017587' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017587' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017587' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017587' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-587      |
    | AETL-587      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-587      |
    | AETL-587      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-19TRLS2021    |
    | AEB-ASLS2021      |

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEAL-587      |
    | AETL-587      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-587       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017587'

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
    | 10017587 |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017587' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017587 Co Ltd' with UKPRN '10017587' and OrgId 'ORG0017587' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017587' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017587 | 117587 | 10017587 Co Ltd | 0              | In Administration     | Yes           | AA017587      | ?             | 52 Park Street         | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 3PT  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017587 |





    # Change the date
    Given the override date is '02/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP-587'
    And   there are no details on ContractManagement.CreatedContract for 'AEBP-587'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017587 | 10017587 Co Ltd      | ESFA-587             | AEBP-587       | 1                     | 01/08/2020        | 31/07/2021      | 48274.00      |                                       | Procured                                   | 2021   | New          | ORG0017587 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017587 | AEBP-587       | AEAL-587      | AEB-ASLS          | AEB-ASLS2021            | AY                      | 01/08/2020          | 31/07/2021        | 29602.00        |                                         |            |                                                             | New          |             |
    | 10017587 | AEBP-587       | AETL-587      | AEB-19TRLS        | AEB-19TRLS2021          | AY                      | 01/08/2020          | 31/07/2021        | 18672.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017587 | AEBP-587       | AEAL-587      | 1               | 0                     | 29602.00  | 19164.00  | 10438.00  | 3507.00  | 3705.00  | 3112.00  | 1190.00  | 2272.00  | 1743.00  | 612.00   | 3023.00  | 3191.00  | 953.00   | 2984.00  | 3310.00  | Adult Education Budget - Adult Skills Learner Support           | New          |             | 
    | 10017587 | AEBP-587       | AETL-587      | 1               | 0                     | 18672.00  | 13767.00  | 4905.00   | 2733.00  | 3469.00  | 1261.00  | 2219.00  | 1310.00  | 337.00   | 2274.00  | 164.00   | 75.00    | 2076.00  | 757.00   | 1997.00  | Adult Education Budget - 19-24 Traineeships Learner Support     | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-587'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-587' and actual ContractNumber 'AEBP-587'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-587' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017587 | AEBP-587           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017587 | ESFA-587           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP-587' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'AEBP-587'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AETL-587        | 2355875          | Jul-21 | Reconciliation |
    | AEAL-587        | 2372175          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017587 | AEBP-587       | 1               | AEAL-587      | 1               | 0                     | 29602.00     | 0             | 0        | Adult Education Budget - Adult Skills Learner Support           | ?                                                           |
    | 10017587 | AEBP-587       | 1               | AETL-587      | 1               | 0                     | 18672.00     | 0             | 0        | Adult Education Budget - 19-24 Traineeships Learner Support     | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP-587' agree with the most recent entry for this contract in the ContractManagement feed





    # Funding Claims ...


    # Populate stub with Claim data

    # Change the date
    Given the override date is '04/07/2021'

    #Set up claim data from DC for a 'Year End'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017587     | 10017587 | 3                  | Year End      | AY             | 2021   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017587     | 10017587 | 3                  | Year End      | AY             | 2021   | AEAL-587      | AEB-ASLS2021            |
    | ORG0017587     | 10017587 | 3                  | Year End      | AY             | 2021   | AETL-587      | AEB-19TRLS2021          |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017587     | 10017587 | 3                  | Year End      | AY             | 2021   | AEAL-587      | 2               | 5801.00     | 67.66         | 10.42           | 5879.08    |
    | ORG0017587     | 10017587 | 3                  | Year End      | AY             | 2021   | AEAL-587      | 3               | 5637.00     | 46.81         | 13.53           | 5697.34    |
    | ORG0017587     | 10017587 | 3                  | Year End      | AY             | 2021   | AEAL-587      | 4               | 5874.00     | 49.89         | 9.89            | 5933.78    |
    | ORG0017587     | 10017587 | 3                  | Year End      | AY             | 2021   | AEAL-587      | 5               | 4917.00     | 71.80         | 6.99            | 4995.79    |
    #                                                                                                                                                                            £ 22505.99  
    | ORG0017587     | 10017587 | 3                  | Year End      | AY             | 2021   | AETL-587      | 2               | 8170.00     | 70.29         | 10.64           | 8250.93    |
    | ORG0017587     | 10017587 | 3                  | Year End      | AY             | 2021   | AETL-587      | 3               | 8000.00     | 61.22         | 10.35           | 8071.57    |
    #                                                                                                                                                                            £ 16322.50  

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed




    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017587 | 2021          | Year End         | AEB-19TRLS2021      | 3                  | 18672.00     | 16322.50     | -2349.50                    | -2349.50            | 16322.50         | 0.00            | 16322.50                 | Draft      |
    | 10017587 | 2021          | Year End         | AEB-ASLS2021        | 3                  | 29602.00     | 22505.99     | -7096.01                    | -7096.01            | 22505.99         | 0.00            | 22505.99                 | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017587 | 2021          | Year End         | AEB-19TRLS2021      | AETL-587      | 18672.00     | 16322.50     | -2349.50                    | -2349.50            | 16322.50         | 0.00            | ?                     | 16322.50                 |
    | 10017587 | 2021          | Year End         | AEB-ASLS2021        | AEAL-587      | 29602.00     | 22505.99     | -7096.01                    | -7096.01            | 22505.99         | 0.00            | ?                     | 22505.99                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017587 | 2021          | Year End         | AEB-19TRLS2021      | AETL-587      | AEB-19TRLS2021       | 2               | 19-24 Traineeships Learner Support                     | 0.00         | 8250.93      |
    | 10017587 | 2021          | Year End         | AEB-19TRLS2021      | AETL-587      | AEB-19TRLS2021       | 3               | 19-24 Traineeships Administration Expenditure          | 0.00         | 8071.57      |
    #
    | 10017587 | 2021          | Year End         | AEB-ASLS2021        | AEAL-587      | AEB-ASLS2021         | 2               | Adult Skills 19+ Hardship                              | 0.00         | 5879.08      |
    | 10017587 | 2021          | Year End         | AEB-ASLS2021        | AEAL-587      | AEB-ASLS2021         | 3               | Adult Skills 20+ Childcare                             | 0.00         | 5697.34      |
    | 10017587 | 2021          | Year End         | AEB-ASLS2021        | AEAL-587      | AEB-ASLS2021         | 4               | Adult Skills Residential Access Fund                   | 0.00         | 5933.78      |
    | 10017587 | 2021          | Year End         | AEB-ASLS2021        | AEAL-587      | AEB-ASLS2021         | 5               | Adult Skills Administration Expenditure                | 0.00         | 4995.79      |




    # Change the date 
    Given the override date is '06/07/2021'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither ... 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017587 | 2021          | Year End         | AEB-19TRLS2021      | 3                  | AETL-587      | 18672.00     | 16322.50     | -2349.50                    | -2349.50            | 16322.50         | 0.00            | ?                     |
    | 10017587 | 2021          | Year End         | AEB-ASLS2021        | 3                  | AEAL-587      | 29602.00     | 22505.99     | -7096.01                    | -7096.01            | 22505.99         | 0.00            | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017587 | 2021          | Year End         | AEB-19TRLS2021      | 3                  | 18672.00     | 16322.50     | -2349.50                    | -2349.50            | 16322.50         | 0.00            | 16322.50                 | Draft      |
    | 10017587 | 2021          | Year End         | AEB-ASLS2021        | 3                  | 29602.00     | 22505.99     | -7096.01                    | -7096.01            | 22505.99         | 0.00            | 22505.99                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017587 | 2021          | Year End         | AEB-19TRLS2021      | AETL-587      | 18672.00     | 16322.50     | -2349.50                    | -2349.50            | 16322.50         | 0.00            | ?                     | 16322.50                 |
    | 10017587 | 2021          | Year End         | AEB-ASLS2021        | AEAL-587      | 29602.00     | 22505.99     | -7096.01                    | -7096.01            | 22505.99         | 0.00            | ?                     | 22505.99                 |




    # Change the date
    Given the override date is '08/07/2021'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2021-YearEnd' and Allocation Group Code 'AEB-ASLS2021'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2021-YearEnd' and Allocation Group Code 'AEB-ASLS2021'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017587 | 2021          | Year End         | AEB-19TRLS2021      | 3                  |
    | 10017587 | 2021          | Year End         | AEB-ASLS2021        | 3                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017587 | 2021          | Year End         | AEB-19TRLS2021      | 3                  |
    | 10017587 | 2021          | Year End         | AEB-ASLS2021        | 3                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017587 | 2021          | Year End         | AEB-19TRLS2021      | 3                  |
    | 10017587 | 2021          | Year End         | AEB-ASLS2021        | 3                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                               | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017587 | AETL-587         | 2021   | Year End      | AEB (Procured) - 19 to 24 Traineeships Learner Support 20/21      | 18672.00     | 16322.50     | -2349.50                    | -2349.50                 | 16322.50           | ?               | ?                     | 16322.50                 |
    | 10017587 | AEAL-587         | 2021   | Year End      | AEB (Procured) - Adult Skills Learner Support 20/21               | 29602.00     | 22505.99     | -7096.01                    | -7096.01                 | 22505.99           | ?               | ?                     | 22505.99                 |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
@FundingClaim
Scenario: A588 Create and approve an EDSK contract with 19TRN, ASCL, CSO and ALLBC allocs. Process a YearEnd Funding Claim with over-delivery. Check CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017588' 
    And   there are no terminated or closed allocations for UKPRN '10017588' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017588' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017588' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017588' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-588      |
    | AECS-588      |
    | AECT-588      |
    | ALLC-588      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-588      |
    | AECS-588      |
    | AECT-588      |
    | ALLC-588      |

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
    | AECA-588      |
    | AECS-588      |
    | AECT-588      |
    | ALLC-588      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-588       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017588'

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017588 |

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


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017588' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017588 Co Ltd' with UKPRN '10017588' and OrgId 'ORG0017588' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017588' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017588 | 117588 | 10017588 Co Ltd | 0              | Provider Under Change | Yes           | AA017588      | ?             | 1 Church Mews          | ?                      | ?                      | ?                      | Clophill               | Bedfordshire           | MK45 4BQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017588 |





    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-588'
    And   there are no details on ContractManagement.CreatedContract for 'EDSK-588'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017588 | 10017588 Co Ltd      | ESFA-588             | EDSK-588       | 1                     | 01/08/2020        | 31/07/2021      | 142022.00     |                                       | Conditions of Funding (Grant) (Employer)   | 2021   | New          | ORG0017588 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017588 | EDSK-588       | AECA-588      | AEBC-ASCL         | AEBC-ASCL2021           | AY                      | 01/08/2020          | 31/07/2021        | 49187.00        |                                         |            |                                                             | New          |             |
    | 10017588 | EDSK-588       | AECS-588      | AEBC-CSO          | AEBC-CSO2021            | AY                      | 01/08/2020          | 31/07/2021        | 47670.00        |                                         |            |                                                             | New          |             |
    | 10017588 | EDSK-588       | AECT-588      | AEBC-19TRN        | AEBC-19TRN2021          | AY                      | 01/08/2020          | 31/07/2021        | 20889.00        |                                         |            |                                                             | New          |             |
    | 10017588 | EDSK-588       | ALLC-588      | ALLBC             | ALLBC2021               | AY                      | 01/08/2020          | 31/07/2021        | 24276.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017588 | EDSK-588       | AECA-588      | 1               | 0                     | 49187.00  | 33539.00  | 15648.00  | 4419.00  | 2917.00  | 6440.00  | 3041.00  | 3120.00  | 3865.00  | 4577.00  | 5160.00  | 5146.00  | 2473.00  | 3090.00  | 4939.00  | COVID-19 Skills Offer Total Funding                             | New          |             | 
    | 10017588 | EDSK-588       | AECA-588      | 2               | 1                     | 27132.00  | 16939.00  | 10193.00  | 1818.00  | 2648.00  | 2875.00  | 227.00   | 1754.00  | 1857.00  | 2529.00  | 3231.00  | 2861.00  | 1255.00  | 2371.00  | 3706.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017588 | EDSK-588       | AECA-588      | 5               | 1                     | 22055.00  | 16600.00  | 5455.00   | 2601.00  | 269.00   | 3565.00  | 2814.00  | 1366.00  | 2008.00  | 2048.00  | 1929.00  | 2285.00  | 1218.00  | 719.00   | 1233.00  | Community Learning                                              | New          |             | 
    | 10017588 | EDSK-588       | AECS-588      | 1               | 0                     | 47670.00  | 31624.00  | 16046.00  | 4859.00  | 3545.00  | 5522.00  | 3293.00  | 4543.00  | 1775.00  | 2675.00  | 5412.00  | 5586.00  | 4083.00  | 4888.00  | 1489.00  | COVID-19 Skills Offer Total Funding                             | New          |             | 
    | 10017588 | EDSK-588       | AECS-588      | 2               | 1                     | 21705.00  | 13649.00  | 8056.00   | 2256.00  | 3180.00  | 3126.00  | 571.00   | 833.00   | 1030.00  | 437.00   | 2216.00  | 3299.00  | 2770.00  | 1638.00  | 349.00   | High Value Courses for School and College Leavers Funding       | New          |             | 
    | 10017588 | EDSK-588       | AECS-588      | 6               | 1                     | 25965.00  | 17975.00  | 7990.00   | 2603.00  | 365.00   | 2396.00  | 2722.00  | 3710.00  | 745.00   | 2238.00  | 3196.00  | 2287.00  | 1313.00  | 3250.00  | 1140.00  | National Skills Fund Level 3 Offer for 24 year old and over     | New          |             | 
    | 10017588 | EDSK-588       | AECT-588      | 1               | 0                     | 20889.00  | 17636.00  | 3253.00   | 2216.00  | 516.00   | 2897.00  | 437.00   | 3135.00  | 3426.00  | 1568.00  | 3441.00  | 540.00   | 106.00   | 1410.00  | 1197.00  | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10017588 | EDSK-588       | ALLC-588      | 1               | 0                     | 24276.00  | 15942.00  | 8334.00   | 452.00   | 2008.00  | 56.00    | 3194.00  | 2917.00  | 3748.00  | 1257.00  | 2310.00  | 135.00   | 2957.00  | 3629.00  | 1613.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-588       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-588'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-588' and actual ContractNumber 'EDSK-588'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-588' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017588 | EDSK-588           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017588 | ESFA-588           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'EDSK-588'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECT-588        | 2355775          | Jul-21 | Reconciliation |
    | AECA-588        | 2371175          | Jul-21 | Reconciliation |
    | AECS-588        | 2372091          | Jul-21 | Profile        |
    | ALLC-588        | 2303975          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '8' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017588 | EDSK-588       | 1               | AECA-588      | 1               | 0                     | 49187.00     | 0             | 0        | COVID-19 Skills Offer Total Funding                             | ?                                                           |
    | 10017588 | EDSK-588       | 1               | AECA-588      | 2               | 1                     | 27132.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
    | 10017588 | EDSK-588       | 1               | AECA-588      | 5               | 1                     | 22055.00     | 0             | 0        | Community Learning                                              | ?                                                           |
    | 10017588 | EDSK-588       | 1               | AECS-588      | 1               | 0                     | 47670.00     | 0             | 0        | COVID-19 Skills Offer Total Funding                             | ?                                                           |
    | 10017588 | EDSK-588       | 1               | AECS-588      | 2               | 1                     | 21705.00     | 0             | 0        | High Value Courses for School and College Leavers Funding       | ?                                                           |
    | 10017588 | EDSK-588       | 1               | AECS-588      | 6               | 1                     | 25965.00     | 0             | 0        | National Skills Fund Level 3 Offer for 24 year old and over     | ?                                                           |
    | 10017588 | EDSK-588       | 1               | AECT-588      | 1               | 0                     | 20889.00     | 0             | 0        | 19-24 Traineeships Total Funding                                | ?                                                           |
    | 10017588 | EDSK-588       | 1               | ALLC-588      | 1               | 0                     | 24276.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding                    | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-588' agree with the most recent entry for this contract in the ContractManagement feed





    # Funding Claims ...

    # Populate stub with Claim data

    # Change the date
    Given the override date is '11/07/2021'

    #Set up claim data from DC for a 'Year End'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECA-588      | AEBC-ASCL2021           |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECS-588      | AEBC-CSO2021            |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECT-588      | AEBC-19TRN2021          |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | ALLC-588      | ALLBC2021               |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECA-588      | 3               | 7111.00     | 26.04         | 7.04            | 7144.08    |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECA-588      | 4               | 6645.00     | 37.08         | 8.52            | 6690.60    |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECA-588      | 5               | 6567.00     | 67.49         | 10.86           | 6645.35    |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECA-588      | 6               | 6799.00     | 46.41         | 14.81           | 6860.22    |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECA-588      | 7               | 6478.00     | 50.42         | 11.63           | 6540.05    |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECA-588      | 8               | 6169.00     | 34.41         | 14.05           | 6217.46    |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECA-588      | 9               | 6464.00     | 31.64         | 8.93            | 6504.57    |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECA-588      | 10              | 7238.00     | 63.55         | 9.64            | 7311.19    |
    #                                                                                                                                                                            £ 53913.52  
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECS-588      | 3               | 15999.00    | 40.71         | 11.85           | 16051.56   |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECS-588      | 4               | 17092.00    | 53.39         | 6.31            | 17151.70   |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECS-588      | 5               | 16627.00    | 74.65         | 7.08            | 16708.73   |
    #                                                                                                                                                                            £ 49911.99  
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECT-588      | 2               | 5356.00     | 63.31         | 13.80           | 5433.11    |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECT-588      | 3               | 6155.00     | 48.87         | 12.88           | 6216.75    |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECT-588      | 4               | 6115.00     | 29.61         | 12.52           | 6157.13    |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | AECT-588      | 5               | 5850.00     | 62.91         | 11.08           | 5923.99    |
    #                                                                                                                                                                            £ 23730.98  
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | ALLC-588      | 2               | 3471.00     | 48.65         | 14.36           | 3534.01    |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | ALLC-588      | 3               | 3907.00     | 35.81         | 11.26           | 3954.07    |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | ALLC-588      | 4               | 3720.00     | 71.81         | 13.02           | 3804.83    |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | ALLC-588      | 5               | 3916.00     | 36.38         | 13.25           | 3965.63    |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | ALLC-588      | 6               | 4121.00     | 27.47         | 12.88           | 4161.35    |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | ALLC-588      | 7               | 3525.00     | 55.35         | 14.96           | 3595.31    |
    | ORG0017588     | 10017588 | 3                  | Year End      | AY             | 2021   | ALLC-588      | 8               | 3731.00     | 38.22         | 9.39            | 3778.61    |
    #                                                                                                                                                                            £ 26793.81  

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017588 | 2021          | Year End         | AEBC-19TRN2021      | 3                  | 20889.00     | 23730.98     | 2088.90                     | 2088.90             | 23730.98         | 0.00            | 23730.98                 | Draft      |
    | 10017588 | 2021          | Year End         | ALLBC2021           | 3                  | 24276.00     | 26793.81     | 0.00                        | 0.00                | 26793.81         | 0.00            | 26793.81                 | Draft      |
    | 10017588 | 2021          | Year End         | AEBC-CSO2021        | 3                  | 47670.00     | 49911.99     | 2241.99                     | 2241.99             | 49911.99         | 0.00            | 49911.99                 | Draft      |
    | 10017588 | 2021          | Year End         | AEBC-ASCL2021       | 3                  | 49187.00     | 53913.52     | 1475.61                     | 1475.61             | 53913.52         | 0.00            | 53913.52                 | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017588 | 2021          | Year End         | AEBC-19TRN2021      | AECT-588      | 20889.00     | 23730.98     | 2088.90                     | 2088.90             | 23730.98         | 0.00            | ?                     | 23730.98                 |
    | 10017588 | 2021          | Year End         | ALLBC2021           | ALLC-588      | 24276.00     | 26793.81     | 0.00                        | 0.00                | 26793.81         | 0.00            | ?                     | 26793.81                 |
    | 10017588 | 2021          | Year End         | AEBC-CSO2021        | AECS-588      | 47670.00     | 49911.99     | 2241.99                     | 2241.99             | 49911.99         | 0.00            | ?                     | 49911.99                 |
    | 10017588 | 2021          | Year End         | AEBC-ASCL2021       | AECA-588      | 49187.00     | 53913.52     | 1475.61                     | 1475.61             | 53913.52         | 0.00            | ?                     | 53913.52                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017588 | 2021          | Year End         | AEBC-19TRN2021      | AECT-588      | AEBC-19TRN2021       | 2               | 19-24 Traineeships Programme Funding                   | 0.00         | 5433.11      |
    | 10017588 | 2021          | Year End         | AEBC-19TRN2021      | AECT-588      | AEBC-19TRN2021       | 3               | 19-24 Traineeships Learning Support                    | 0.00         | 6216.75      |
    | 10017588 | 2021          | Year End         | AEBC-19TRN2021      | AECT-588      | AEBC-19TRN2021       | 4               | 19-24 Traineeships Learner Support                     | 0.00         | 6157.13      |
    | 10017588 | 2021          | Year End         | AEBC-19TRN2021      | AECT-588      | AEBC-19TRN2021       | 5               | 19-24 Traineeships Admin Expenditure                   | 0.00         | 5923.99      |
    #
    | 10017588 | 2021          | Year End         | AEBC-ASCL2021       | AECA-588      | AEBC-ASCL-2021       | 3               | Adult Skills Programme Funding                         | 0.00         | 7144.08      |
    | 10017588 | 2021          | Year End         | AEBC-ASCL2021       | AECA-588      | AEBC-ASCL-2021       | 4               | Adult Skills Learning Support                          | 0.00         | 6690.60      |
    | 10017588 | 2021          | Year End         | AEBC-ASCL2021       | AECA-588      | AEBC-ASCL-2021       | 5               | Community Learning                                     | 22055.00     | 6645.35      |
    | 10017588 | 2021          | Year End         | AEBC-ASCL2021       | AECA-588      | AEBC-ASCL-2021       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 6860.22      |
    | 10017588 | 2021          | Year End         | AEBC-ASCL2021       | AECA-588      | AEBC-ASCL-2021       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 6540.05      |
    | 10017588 | 2021          | Year End         | AEBC-ASCL2021       | AECA-588      | AEBC-ASCL-2021       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 6217.46      |
    | 10017588 | 2021          | Year End         | AEBC-ASCL2021       | AECA-588      | AEBC-ASCL-2021       | 9               | Adult Skills Administration Expenditure                | 0.00         | 6504.57      |
    | 10017588 | 2021          | Year End         | AEBC-ASCL2021       | AECA-588      | AEBC-ASCL-2021       | 10              | Learner Support - COVID-19 Response                    | 0.00         | 7311.19      |
    #
    | 10017588 | 2021          | Year End         | AEBC-CSO2021        | AECS-588      | AEBC-CSO2021         | 3               | COVID-19 Skills Offer Programme Funding                | 0.00         | 16051.56     |
    | 10017588 | 2021          | Year End         | AEBC-CSO2021        | AECS-588      | AEBC-CSO2021         | 4               | COVID-19 Skills Offer Learning Support                 | 0.00         | 17151.70     |
    | 10017588 | 2021          | Year End         | AEBC-CSO2021        | AECS-588      | AEBC-CSO2021         | 5               | COVID-19 Skills Offer Learner Support                  | 0.00         | 16708.73     |
    #
    | 10017588 | 2021          | Year End         | ALLBC2021           | ALLC-588      | ALLBC2021            | 2               | Loans - Bursary Funding                                | 0.00         | 3534.01      |
    | 10017588 | 2021          | Year End         | ALLBC2021           | ALLC-588      | ALLBC2021            | 3               | Loans - Area Costs                                     | 0.00         | 3954.07      |
    | 10017588 | 2021          | Year End         | ALLBC2021           | ALLC-588      | ALLBC2021            | 4               | Loans - Excess Claims                                  | 0.00         | 3804.83      |
    | 10017588 | 2021          | Year End         | ALLBC2021           | ALLC-588      | ALLBC2021            | 5               | Loans - Hardship                                       | 0.00         | 3965.63      |
    | 10017588 | 2021          | Year End         | ALLBC2021           | ALLC-588      | ALLBC2021            | 6               | Loans - Childcare                                      | 0.00         | 4161.35      |
    | 10017588 | 2021          | Year End         | ALLBC2021           | ALLC-588      | ALLBC2021            | 7               | Loans - Residential Access Fund                        | 0.00         | 3595.31      |
    | 10017588 | 2021          | Year End         | ALLBC2021           | ALLC-588      | ALLBC2021            | 8               | Loans - Administration Expenditure                     | 0.00         | 3778.61      |




    # Change the date 
    Given the override date is '13/07/2021'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither ... 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017588 | 2021          | Year End         | AEBC-19TRN2021      | 3                  | AECT-588      | 20889.00     | 23730.98     | 2088.90                     | 2088.90             | 23730.98         | 0.00            | ?                     |
    | 10017588 | 2021          | Year End         | ALLBC2021           | 3                  | ALLC-588      | 24276.00     | 26793.81     | 0.00                        | 0.00                | 26793.81         | 0.00            | ?                     |
    | 10017588 | 2021          | Year End         | AEBC-CSO2021        | 3                  | AECS-588      | 47670.00     | 49911.99     | 2241.99                     | 2241.99             | 49911.99         | 0.00            | ?                     |
    | 10017588 | 2021          | Year End         | AEBC-ASCL2021       | 3                  | AECA-588      | 49187.00     | 53913.52     | 1475.61                     | 1475.61             | 53913.52         | 0.00            | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017588 | 2021          | Year End         | AEBC-19TRN2021      | 3                  | 20889.00     | 23730.98     | 2088.90                     | 2088.90             | 23730.98         | 0.00            | 23730.98                 | Draft      |
    | 10017588 | 2021          | Year End         | ALLBC2021           | 3                  | 24276.00     | 26793.81     | 0.00                        | 0.00                | 26793.81         | 0.00            | 26793.81                 | Draft      |
    | 10017588 | 2021          | Year End         | AEBC-CSO2021        | 3                  | 47670.00     | 49911.99     | 2241.99                     | 2241.99             | 49911.99         | 0.00            | 49911.99                 | Draft      |
    | 10017588 | 2021          | Year End         | AEBC-ASCL2021       | 3                  | 49187.00     | 53913.52     | 1475.61                     | 1475.61             | 53913.52         | 0.00            | 53913.52                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017588 | 2021          | Year End         | AEBC-19TRN2021      | AECT-588      | 20889.00     | 23730.98     | 2088.90                     | 2088.90             | 23730.98         | 0.00            | ?                     | 23730.98                 |
    | 10017588 | 2021          | Year End         | ALLBC2021           | ALLC-588      | 24276.00     | 26793.81     | 0.00                        | 0.00                | 26793.81         | 0.00            | ?                     | 26793.81                 |
    | 10017588 | 2021          | Year End         | AEBC-CSO2021        | AECS-588      | 47670.00     | 49911.99     | 2241.99                     | 2241.99             | 49911.99         | 0.00            | ?                     | 49911.99                 |
    | 10017588 | 2021          | Year End         | AEBC-ASCL2021       | AECA-588      | 49187.00     | 53913.52     | 1475.61                     | 1475.61             | 53913.52         | 0.00            | ?                     | 53913.52                 |




    # Change the date
    Given the override date is '15/07/2021'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2021-YearEnd' and Allocation Group Code 'AEBC-ASCL2021'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2021-YearEnd' and Allocation Group Code 'AEBC-ASCL2021'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017588 | 2021          | Year End         | AEBC-19TRN2021      | 3                  |
    | 10017588 | 2021          | Year End         | AEBC-ASCL2021       | 3                  |
    | 10017588 | 2021          | Year End         | AEBC-CSO2021        | 3                  |
    | 10017588 | 2021          | Year End         | ALLBC2021           | 3                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017588 | 2021          | Year End         | AEBC-19TRN2021      | 3                  |
    | 10017588 | 2021          | Year End         | AEBC-ASCL2021       | 3                  |
    | 10017588 | 2021          | Year End         | AEBC-CSO2021        | 3                  |
    | 10017588 | 2021          | Year End         | ALLBC2021           | 3                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017588 | 2021          | Year End         | AEBC-19TRN2021      | 3                  |
    | 10017588 | 2021          | Year End         | AEBC-ASCL2021       | 3                  |
    | 10017588 | 2021          | Year End         | AEBC-CSO2021        | 3                  |
    | 10017588 | 2021          | Year End         | ALLBC2021           | 3                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                               | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017588 | AECT-588         | 2021   | Year End      | AEB (College) - 19 to 24 Traineeships 20/21                       | 20889.00     | 23730.98     | 2088.90                     | 2088.90                  | 23730.98           | ?               | ?                     | 23730.98                 |
    | 10017588 | ALLC-588         | 2021   | Year End      | Advanced Learner Loans Bursary (College) 20/21                    | 24276.00     | 26793.81     | 0.00                        | 0.00                     | 26793.81           | ?               | ?                     | 26793.81                 |
    | 10017588 | AECS-588         | 2021   | Year End      | AEB (College) - COVID-19 Skills Offer 20/21                       | 47670.00     | 49911.99     | 2241.99                     | 2241.99                  | 49911.99           | ?               | ?                     | 49911.99                 |
    | 10017588 | AECA-588         | 2021   | Year End      | AEB (College) - Adult Skills and Community Learning 20/21         | 49187.00     | 53913.52     | 1475.61                     | 1475.61                  | 53913.52           | ?               | ?                     | 53913.52                 |

    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
@FundingClaim
Scenario: A589 Create and approve an EDSK contract with an AEBC-ASCL2021 alloc. Process a YearEnd Funding Claim where D5 is missing. Over-deliver. Amend contract. Recalc FCR. Publish. Check CRM, PaaS and feed
    
    # 1. Create an approved EDSK contract with just an AEBC-ASCL2021 allocation
    # 2. Inject and consume a YearEnd Funding Claim without a claim value for deliverable 5
    # 3. Claim (£49,510.74) is more than 2x the profile value (£22,451.00). Adjust claim down by £26,000
    # 4. Check calcs
    # 5. Amend (and approve) contract to increase profile by £782
    # 6. Check calcs
    # 7. Publish FCR
    # 8. Check feed 

    Given there are no allocations marked as Under Termination for UKPRN '10017589' 
    And   there are no terminated or closed allocations for UKPRN '10017589' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017589' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017589' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table  

    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017589' 

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
    | 10017589 |

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECA-589      |

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-589      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-589      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-ASCL2021     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-589       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017589'





   # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017589' 
    And   there is no caseload advisor for UKPRN '10017589' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017589 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017589' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017589 Co Ltd' with UKPRN '10017589' and OrgId 'ORG0017589' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017589 | 117589 | 10017589 Co Ltd | 0              | Locked Restructure    | Yes           | AA017589      | ?             | 43 Hill Avenue         | ?                      | ?                      | ?                      | Amersham               | Buckinghamshire        | HP6 5BX   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017589 |





    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-589'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-589'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017589 | 10017589 Co Ltd      | ESFA-589             | EDSK-589       | 1                     | 01/08/2020        | 31/07/2021      | 22451.00      |                       | Conditions of Funding (Grant) (NMSS)       | 2021   | New          | ORG0017589 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName     | UoPCode    | AllocationDescription       | CRMIntent    | DeliveryOrg |
    | 10017589 | EDSK-589       | AECA-589      | AEBC-ASCL         | AEBC-ASCL2021           | AY                      | 01/08/2020          | 31/07/2021        | 22451.00        |             |            |                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                              | CRMIntent    | DeliveryOrg |
    | 10017589 | EDSK-589       | AECA-589      | 1               | 0                     | 22451.00  | 15506.00  | 6945.00   | 2745.00  | 2088.00  | 3077.00  | 112.00   | 2587.00  | 2563.00  | 1654.00  | 680.00   | 2617.00  | 507.00   | 1401.00  | 2420.00  | Adult Skills and Community Learning Total Funding   | New          |             | 
    | 10017589 | EDSK-589       | AECA-589      | 2               | 1                     | 22451.00  | 15506.00  | 6945.00   | 2745.00  | 2088.00  | 3077.00  | 112.00   | 2587.00  | 2563.00  | 1654.00  | 680.00   | 2617.00  | 507.00   | 1401.00  | 2420.00  | Adult Skills Total Funding                          | New          |             | 
#   | 10017589 | EDSK-589       | AECA-589      | 5               | 1                     | 28083.00  | 16465.00  | 11618.00  | 1501.00  | 2741.00  | 1738.00  | 2030.00  | 172.00   | 3028.00  | 2845.00  | 2410.00  | 3715.00  | 3502.00  | 1422.00  | 2979.00  | Community Learning                                  | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-589       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-589'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-589' and actual ContractNumber 'EDSK-589'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-589' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017589 | EDSK-589           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017589 | ESFA-589           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-589' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'EDSK-589'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECA-589        | 2371175          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                     | DeliverableDescription       | 
    | 10017589 | EDSK-589       | 1               | AECA-589      | 1               | 0                     | 22451.00     | 0             | 0        | Adult Skills and Community Learning Total Funding   | ?                            |
    | 10017589 | EDSK-589       | 1               | AECA-589      | 2               | 1                     | 22451.00     | 0             | 0        | Adult Skills Total Funding                          | ?                            |
#   | 10017589 | EDSK-589       | 1               | AECA-589      | 5               | 1                     | 28083.00     | 0             | 0        | Community Learning                                  | ?                            |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-589' agree with the most recent entry for this contract in the ContractManagement feed





    # Populate stub with Claim data

    # Change the date
    Given the override date is '11/07/2021'

    #Set up claim data from DC for a 'Year End'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017589     | 10017589 | 3                  | Year End      | AY             | 2021   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017589     | 10017589 | 3                  | Year End      | AY             | 2021   | AECA-589      | AEBC-ASCL2021           |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017589     | 10017589 | 3                  | Year End      | AY             | 2021   | AECA-589      | 3               | 7362.00     | 72.76         | 13.23           | 7447.99    |
    | ORG0017589     | 10017589 | 3                  | Year End      | AY             | 2021   | AECA-589      | 4               | 6835.00     | 38.13         | 7.97            | 6881.10    |
#   | ORG0017589     | 10017589 | 3                  | Year End      | AY             | 2021   | AECA-589      | 5               | 6456.00     | 67.98         | 7.30            | 6531.28    |
    | ORG0017589     | 10017589 | 3                  | Year End      | AY             | 2021   | AECA-589      | 6               | 7200.00     | 36.72         | 12.40           | 7249.12    |
    | ORG0017589     | 10017589 | 3                  | Year End      | AY             | 2021   | AECA-589      | 7               | 6416.00     | 71.67         | 9.47            | 6497.14    |
    | ORG0017589     | 10017589 | 3                  | Year End      | AY             | 2021   | AECA-589      | 8               | 7085.00     | 35.13         | 11.25           | 7131.38    |
    | ORG0017589     | 10017589 | 3                  | Year End      | AY             | 2021   | AECA-589      | 9               | 6862.00     | 61.40         | 13.74           | 6937.14    |
    | ORG0017589     | 10017589 | 3                  | Year End      | AY             | 2021   | AECA-589      | 10              | 7292.00     | 62.76         | 12.11           | 7366.87    |
    #                                                                                                                                                                           £ 49510.74  





    # Consume stub data

    # Change the date
    Given the override date is '13/07/2021'

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM (Planned value * Over-Delivery Limit = ProposedReconciliationValue ie 22,451.00 * 3% = 673.53) 
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | 3                  | 22451.00     | 49510.74     | 673.53                      | 673.53              | 49510.74         | 0.00            | 49510.74                 | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | 22451.00     | 49510.74     | 673.53                      | 673.53              | 49510.74         | 0.00            | ?                     | 49510.74                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | AEBC-ASCL-2021       | 3               | Adult Skills Programme Funding                         | 0.00         | 7447.99      |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | AEBC-ASCL-2021       | 4               | Adult Skills Learning Support                          | 0.00         | 6881.10      |
#   | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | AEBC-ASCL-2021       | 5               | Community Learning                                     | 0.00         | 6531.28      |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | AEBC-ASCL-2021       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 7249.12      |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | AEBC-ASCL-2021       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 6497.14      |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | AEBC-ASCL-2021       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 7131.38      |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | AEBC-ASCL-2021       | 9               | Adult Skills Administration Expenditure                | 0.00         | 6937.14      |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | AEBC-ASCL-2021       | 10              | Learner Support - COVID-19 Response                    | 0.00         | 7366.87      |
    #                                                                                                                                                                                                   £ 49510.74  





    # Update FCR

    # Change the date 
    Given the override date is '15/07/2021'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither ... 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | 3                  | AECA-589      | 22451.00     | 49510.74     | 673.53                      | 673.53              | 49510.74         | -26000.00       | Ineligible Data       |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | 3                  | 22451.00     | 49510.74     | 673.53                      | 673.53              | 49510.74         | -26000.00       | 23510.74                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | 22451.00     | 49510.74     | 673.53                      | 673.53              | 49510.74         | -26000.00       | Ineligible Data       | 23510.74                 |





    # Bulk file contract amendment. Increase Profile by £782 (from £22,451 to £23,233)

    # Change the date 
    Given the override date is '17/07/2021'

    # Bulk file
    And   there are no files prefixed '10017589' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 15092021104304 v3_A589' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 15092021104304 v3_A589' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 15092021104304 v3_A589' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 15092021104304 v3_A589' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 15092021104304 v3_A589.xlsx' exists in the Datafiles folder and UKPRN '10017589' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Contract status is now at 'Awaiting Documentation'





    # Publish and approve v2

    # Change the date 
    Given the override date is '19/07/2021'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-589'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-589' and actual ContractNumber 'EDSK-589'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-589' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017589 | EDSK-589           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017589 | EDSK-589           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017589 | ESFA-589           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    And wait '10' seconds

    # Check the details in CRM 
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | 3                  | 23233.00     | 49510.74     | 277.74                      | 673.53              | 49510.74         | -26000.00       | 23510.74                 | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | 23233.00     | 49510.74     | 277.74                      | 673.53              | 49510.74         | -26000.00       | Ineligible Data       | 23510.74                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | AEBC-ASCL-2021       | 3               | Adult Skills Programme Funding                         | 0.00         | 7447.99      |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | AEBC-ASCL-2021       | 4               | Adult Skills Learning Support                          | 0.00         | 6881.10      |
#   | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | AEBC-ASCL-2021       | 5               | Community Learning                                     | 0.00         | 6531.28      |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | AEBC-ASCL-2021       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 7249.12      |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | AEBC-ASCL-2021       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 6497.14      |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | AEBC-ASCL-2021       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 7131.38      |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | AEBC-ASCL-2021       | 9               | Adult Skills Administration Expenditure                | 0.00         | 6937.14      |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | AECA-589      | AEBC-ASCL-2021       | 10              | Learner Support - COVID-19 Response                    | 0.00         | 7366.87      |
    #                                                                                                                                                                                                   £ 49510.74  





    # Publish FCR
 
    # Change the date
    Given the override date is '21/07/2021'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2021-YearEnd' and Allocation Group Code 'AEBC-ASCL2021'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2021-YearEnd' and Allocation Group Code 'AEBC-ASCL2021'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | 3                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | 3                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017589 | 2021          | Year End         | AEBC-ASCL2021       | 3                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                               | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017589 | AECA-589         | 2021   | Year End      | AEB (College) - Adult Skills and Community Learning 20/21         | 23233.00     | 49510.74     | 277.74                      | 673.53                   | 49510.74           | -26000.00       | Ineligible Data       | 23510.74                 |


    # Tidy Up
    Given the override date is reset   
      
@AcceptanceTest @Withdrawn20260521
Scenario: A590 Data set-up for FCR test
    Given there are no allocations marked as Under Termination for UKPRN '10017590' 
    And   there are no terminated or closed allocations for UKPRN '10017590' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017590' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017590' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table  

    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017590' 

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
    | 10017590 |

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECA-590      |

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-590      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-590      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-ASCL2021     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-590       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017590'





   # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017590' 
    And   there is no caseload advisor for UKPRN '10017590' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017590 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017590' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017590 Co Ltd' with UKPRN '10017590' and OrgId 'ORG0017590' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017590 | 117590 | 10017590 Co Ltd | 0              | Locked Restructure    | Yes           | AA017590      | ?             | 9 Avenue Road          | ?                      | ?                      | ?                      | Amersham               | Buckinghamshire        | HP6 5BX   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017590 |





    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-590'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-590'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017590 | 10017590 Co Ltd      | ESFA-590             | EDSK-590       | 1                     | 01/08/2020        | 31/07/2021      | 42451.00      |                       | Conditions of Funding (Grant) (NMSS)       | 2021   | New          | ORG0017590 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName     | UoPCode    | AllocationDescription       | CRMIntent    | DeliveryOrg |
    | 10017590 | EDSK-590       | AECA-590      | AEBC-ASCL         | AEBC-ASCL2021           | AY                      | 01/08/2020          | 31/07/2021        | 42451.00        |             |            |                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                              | CRMIntent    | DeliveryOrg |
    | 10017590 | EDSK-590       | AECA-590      | 1               | 0                     | 42451.00  | 15506.00  | 6945.00   | 2745.00  | 2088.00  | 3077.00  | 112.00   | 2587.00  | 2563.00  | 21654.00 | 680.00   | 2617.00  | 507.00   | 1401.00  | 2420.00  | Adult Skills and Community Learning Total Funding   | New          |             | 
    | 10017590 | EDSK-590       | AECA-590      | 2               | 1                     | 42451.00  | 15506.00  | 6945.00   | 2745.00  | 2088.00  | 3077.00  | 112.00   | 2587.00  | 2563.00  | 21654.00 | 680.00   | 2617.00  | 507.00   | 1401.00  | 2420.00  | Adult Skills Total Funding                          | New          |             | 
#   | 10017590 | EDSK-590       | AECA-590      | 5               | 1                     | 28083.00  | 16465.00  | 11618.00  | 1501.00  | 2741.00  | 1738.00  | 2030.00  | 172.00   | 3028.00  | 2845.00  | 2410.00  | 3715.00  | 3502.00  | 1422.00  | 2979.00  | Community Learning                                  | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-590       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-590'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-590' and actual ContractNumber 'EDSK-590'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-590' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017590 | EDSK-590           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017590 | ESFA-590           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-590' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'EDSK-590'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECA-590        | 2371175          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                     | DeliverableDescription       | 
    | 10017590 | EDSK-590       | 1               | AECA-590      | 1               | 0                     | 42451.00     | 0             | 0        | Adult Skills and Community Learning Total Funding   | ?                            |
    | 10017590 | EDSK-590       | 1               | AECA-590      | 2               | 1                     | 42451.00     | 0             | 0        | Adult Skills Total Funding                          | ?                            |
#   | 10017590 | EDSK-590       | 1               | AECA-590      | 5               | 1                     | 28083.00     | 0             | 0        | Community Learning                                  | ?                            |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-590' agree with the most recent entry for this contract in the ContractManagement feed





    # Populate stub with Claim data

    # Change the date
    Given the override date is '11/07/2021'

    #Set up claim data from DC for a 'Year End'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017590     | 10017590 | 3                  | Year End      | AY             | 2021   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017590     | 10017590 | 3                  | Year End      | AY             | 2021   | AECA-590      | AEBC-ASCL2021           |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017590     | 10017590 | 3                  | Year End      | AY             | 2021   | AECA-590      | 3               | 7362.00     | 72.76         | 13.23           | 7447.99    |
    | ORG0017590     | 10017590 | 3                  | Year End      | AY             | 2021   | AECA-590      | 4               | 6835.00     | 38.13         | 7.97            | 6881.10    |
#   | ORG0017590     | 10017590 | 3                  | Year End      | AY             | 2021   | AECA-590      | 5               | 6456.00     | 67.98         | 7.30            | 6531.28    |
    | ORG0017590     | 10017590 | 3                  | Year End      | AY             | 2021   | AECA-590      | 6               | 7200.00     | 36.72         | 12.40           | 7249.12    |
    | ORG0017590     | 10017590 | 3                  | Year End      | AY             | 2021   | AECA-590      | 7               | 6416.00     | 71.67         | 9.47            | 6497.14    |
    | ORG0017590     | 10017590 | 3                  | Year End      | AY             | 2021   | AECA-590      | 8               | 7085.00     | 35.13         | 11.25           | 7131.38    |
    | ORG0017590     | 10017590 | 3                  | Year End      | AY             | 2021   | AECA-590      | 9               | 6862.00     | 61.40         | 13.74           | 6937.14    |
    | ORG0017590     | 10017590 | 3                  | Year End      | AY             | 2021   | AECA-590      | 10              | 7292.00     | 62.76         | 12.11           | 7366.87    |
    #                                                                                                                                                                           £ 49510.74  





    # Consume stub data

    # Change the date
    Given the override date is '13/07/2021'

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM (Planned value * Over-Delivery Limit = ProposedReconciliationValue ie 42,451.00 * 3% = 1273.53) 
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017590 | 2021          | Year End         | AEBC-ASCL2021       | 3                  | 42451.00     | 49510.74     | 1273.53                     | 1273.53             | 49510.74         | 0.00            | 49510.74                 | Draft      |

    # FCR Allocation 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017590 | 2021          | Year End         | AEBC-ASCL2021       | AECA-590      | 42451.00     | 49510.74     | 1273.53                     | 1273.53             | 49510.74         | 0.00            | ?                     | 49510.74                 |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017590 | 2021          | Year End         | AEBC-ASCL2021       | AECA-590      | AEBC-ASCL-2021       | 3               | Adult Skills Programme Funding                         | 0.00         | 7447.99      |
    | 10017590 | 2021          | Year End         | AEBC-ASCL2021       | AECA-590      | AEBC-ASCL-2021       | 4               | Adult Skills Learning Support                          | 0.00         | 6881.10      |
#   | 10017590 | 2021          | Year End         | AEBC-ASCL2021       | AECA-590      | AEBC-ASCL-2021       | 5               | Community Learning                                     | 0.00         | 6531.28      |
    | 10017590 | 2021          | Year End         | AEBC-ASCL2021       | AECA-590      | AEBC-ASCL-2021       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 7249.12      |
    | 10017590 | 2021          | Year End         | AEBC-ASCL2021       | AECA-590      | AEBC-ASCL-2021       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 6497.14      |
    | 10017590 | 2021          | Year End         | AEBC-ASCL2021       | AECA-590      | AEBC-ASCL-2021       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 7131.38      |
    | 10017590 | 2021          | Year End         | AEBC-ASCL2021       | AECA-590      | AEBC-ASCL-2021       | 9               | Adult Skills Administration Expenditure                | 0.00         | 6937.14      |
    | 10017590 | 2021          | Year End         | AEBC-ASCL2021       | AECA-590      | AEBC-ASCL-2021       | 10              | Learner Support - COVID-19 Response                    | 0.00         | 7366.87      |
    #                                                                                                                                                                                                   £ 49510.74  


    # Manually Export, amend the data then Import.

    # Publish 
    
    # Check CRM and PaaS


    # Tidy Up
    Given the override date is reset   
      
              