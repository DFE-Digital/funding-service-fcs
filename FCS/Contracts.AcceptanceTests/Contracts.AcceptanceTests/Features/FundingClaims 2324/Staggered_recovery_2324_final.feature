Feature: Staggered_recovery_2324_final

@AcceptanceTest @Withdrawn20260521
@FundingClaims
Scenario: AK030 Create and approve an EDSK contract with an AEBC-ASCL2324 alloc. Process a Final Funding Claim with D5. Deliver nothing. Publish. Clawback everything but staggered recovery in 4 months. 
    Given there are no allocations marked as Under Termination for UKPRN '10010030' 
    And   there are no terminated or closed allocations for UKPRN '10010030' 
    And   there is no Contract, Task or Workflow data for UKPRN '10010030' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10010030' 
 
    # Clear down ContractRequest.FundingAllocationRelease table (J146). 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10010030' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-030      |

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECA-030      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-030      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-ASCL2324     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-030       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10010030'

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Year End      | 1920   |
    | Year End      | 2023   |
	| Year End      | 2324   |
    | Year End      | 2223   |
	| Year End      | 2324   |
    | Final         | 1718   |
    | Final         | 1819   |
    | Final         | 1920   |
    | Final         | 2023   |
	| Final         | 2324   |
	| Final         | 2223   |
	| Final         | 2324   |

	
	

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10010030 |

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    Given there is no data in the Reconciliation Profiling table for UKPRN '10010030' and FundingPeriod 'AY2324'

   # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
    And   the Reconciliation Profiling table includes a row for UKPRN '10010030' and FundingPeriod 'AY2324'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10010030' 
    And   there is no caseload advisor for UKPRN '10010030' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10010030 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10010030' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10010030 Co Ltd' with UKPRN '10010030' and OrgId 'ORG0010030' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10010030 | 110030 | 10010030 Co Ltd | 0              | Active                | Yes           | AA010030      | ?             | 41 Send Barns Lane     | Send                   | Woking                 | ?                      | ?                      | Surrey                 | GU23 7BS  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10010030 |



    # Part 1: Create and approve and EDSK2324 with one FCR allocs

    # Change the date
    Given the override date is '01/05/2023'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-030'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-030'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10010030 | 10010030 Co Ltd      | ESFA-030             | EDSK-030       | 1                     | 01/08/2023        | 31/07/2024      | 46756.00      |                                       | Conditions of Funding (Grant) (LA)         | 2324   | New          | ORG0010030 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10010030 | EDSK-030       | AECA-030      | AEBC-ASCL         | AEBC-ASCL2324           | AY                      | 01/08/2023          | 31/07/2024        | 46756.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10010030 | EDSK-030       | AECA-030      | 1               | 0                     |  46756.00  | 28797.00  | 17959.00  | 6110.00  | 4608.00  | 1713.00  | 2014.00  | 2093.00  | 5557.00  | 2568.00  | 4134.00  | 4119.00  | 5147.00  | 4782.00  | 3911.00  | Adult Skills and Community Learning Total Funding               | New          |             | 
    | 10010030 | EDSK-030       | AECA-030      | 2               | 1                     | 18779.00  | 10388.00  | 8391.00   | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | Adult Skills Total Funding                                      | New          |             | 
    | 10010030 | EDSK-030       | AECA-030      | 5               | 1                     | 27977.00  | 18409.00  | 9568.00   | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | Community Learning                                              | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-030'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
   #When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-030' and actual ContractNumber 'EDSK-030'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-030' and ContractNumber 'EDSK-030' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-030' has a substatus of 'Approved'





    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010030 | EDSK-030           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10010030 | ESFA-030           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-030' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'EDSK-030'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECA-030        | 2371175          | Jul-24 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10010030 | EDSK-030       | 1               | AECA-030      | 1               | 0                     | 46756.00     | 0             | 0        | Adult Skills and Community Learning Total Funding               | ?                                                           |
    | 10010030 | EDSK-030       | 1               | AECA-030      | 2               | 1                     | 18779.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
    | 10010030 | EDSK-030       | 1               | AECA-030      | 5               | 1                     | 27977.00     | 0             | 0        | Community Learning                                              | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-030' agree with the most recent entry for this contract in the ContractManagement feed


    
 # Funding Claims ...
 
 # Populate stub with Claim data

 # Change the date
 Given the override date is '14/11/2023'

 #Set up claim data from DC for a 'Final'
#And   funding claim data is present in the DEDS stub as follows
 And   funding claim data is present in the funding claim stub as follows
 | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
 | ORG0010030     | 10010030 | 2                  | Final         | AY             | 2324   | False         |

#And   allocation data is present in the DEDS stub as follows 
 And   allocation data is present in the funding claim stub as follows 
 | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
 | ORG0010030     | 10010030 | 2                  | Final         | AY             | 2324   | AECA-030      | AEBC-ASCL2324           |

#And   deliverable data is present in the DEDS stub as follows 
 And   deliverable data is present in the funding claim stub as follows
 | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
 | ORG0010030     | 10010030 | 2                  | Final         | AY             | 2324   | AECA-030      | 3               | 0.00        | 0.00          | 0.00            | 0.00       |
 | ORG0010030     | 10010030 | 2                  | Final         | AY             | 2324   | AECA-030      | 4               | 0.00        | 0.00          | 0.00            | 0.00       |
 | ORG0010030     | 10010030 | 2                  | Final         | AY             | 2324   | AECA-030      | 5               | 0.00        | 0.00          | 0.00            | 0.00       |
 | ORG0010030     | 10010030 | 2                  | Final         | AY             | 2324   | AECA-030      | 6               | 0.00        | 0.00          | 0.00            | 0.00       |
 | ORG0010030     | 10010030 | 2                  | Final         | AY             | 2324   | AECA-030      | 7               | 0.00        | 0.00          | 0.00            | 0.00       |
 | ORG0010030     | 10010030 | 2                  | Final         | AY             | 2324   | AECA-030      | 8               | 0.00        | 0.00          | 0.00            | 0.00       |
 | ORG0010030     | 10010030 | 2                  | Final         | AY             | 2324   | AECA-030      | 9               | 0.00        | 0.00          | 0.00            | 0.00       |
 | ORG0010030     | 10010030 | 2                  | Final         | AY             | 2324   | AECA-030      | 12              | 0.00        | 0.00          | 0.00            | 0.00       |
 #                                                                                                                                                                            £ 0.00  



 # Consume stub data

 # Change the date
 Given the override date is '16/11/2023'

 # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
 When  data is retrieved from the SLD stub and is consumed

 # Check the details in CRM
 Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
 | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
 | 10010030 | 2324          | Final            | AEBC-ASCL2324       | 2                  | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | 0.00            | 0.00                     | Draft      |

 # FCR Allocation 
 And   allocation data is present in the CRM funding claim reconciliation tables as follows 
 | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
 | 10010030 | 2324          | Final            | AEBC-ASCL2324       | AECA-030      | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | 0.00            | ?                     | 0.00                     |

 # FCR Allocation Deliverable
 And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
 | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
 | 10010030 | 2324          | Final            | AEBC-ASCL2324       | AECA-030      | AEBC-ASCL-2324       | 3               | Adult Skills Programme Funding                         | 0.00         | 0.00         |
 | 10010030 | 2324          | Final            | AEBC-ASCL2324       | AECA-030      | AEBC-ASCL-2324       | 4               | Adult Skills Learning Support                          | 0.00         | 0.00         |
 | 10010030 | 2324          | Final            | AEBC-ASCL2324       | AECA-030      | AEBC-ASCL-2324       | 5               | Community Learning                                     | 27977.00     | 0.00         |
 | 10010030 | 2324          | Final            | AEBC-ASCL2324       | AECA-030      | AEBC-ASCL-2324       | 6               | Adult Skills 19+ Hardship                              | 0.00         | 0.00         |
 | 10010030 | 2324          | Final            | AEBC-ASCL2324       | AECA-030      | AEBC-ASCL-2324       | 7               | Adult Skills 20+ Childcare                             | 0.00         | 0.00         |
 | 10010030 | 2324          | Final            | AEBC-ASCL2324       | AECA-030      | AEBC-ASCL-2324       | 8               | Adult Skills Residential Access Fund                   | 0.00         | 0.00         |
 | 10010030 | 2324          | Final            | AEBC-ASCL2324       | AECA-030      | AEBC-ASCL-2324       | 9               | Adult Skills Administration Expenditure                | 0.00         | 0.00         |
 | 10010030 | 2324          | Final            | AEBC-ASCL2324       | AECA-030      | AEBC-ASCL-2324       | 12              | Funding for Innovative Provision                       | 0.00         | 0.00         |


 # Update FCR

 # Change the date 
 Given the override date is '18/11/2024'

 # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither ... 
 When  the reconciliation values on the CRM funding claim allocations are amended as follows
 | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
 | 10010030 | 2324          | Final            | AEBC-ASCL2324       | 2                  | AECA-030      | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | ?               | ?                     |

 Then  group claim data is present in the CRM funding claim reconciliation tables as follows
 | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
 | 10010030 | 2324          | Final            | AEBC-ASCL2324       | 2                  | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | ?               | 0.00                     | Draft      |

 And   allocation data is present in the CRM funding claim reconciliation tables as follows 
 | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
 | 10010030 | 2324          | Final            | AEBC-ASCL2324       | AECA-030      | 46756.00     | 0.00         | -46756.00                   | -46756.00           | 0.00             | ?               | ?                     | 0.00                     |


 
 # Publish FCR

 # Change the date
 Given the override date is '20/11/2024'

 # Check the current date against the Publication Close Date for the AGC
#Then  the override date is after the Publication Close Date for Claim Reconciliation Code '2024-Final' and Allocation Group Code 'AEBC-ASCL2324'
 Then  the override date is before the Publication Close Date for Claim Reconciliation Code '2324-Final' and Allocation Group Code 'AEBC-ASCL2324'

 # Update Draft Claim Reconciliations to 'Published'
 When  the following funding claim reconciliations are changed to Publish in Progress
 | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
 | 10010030 | 2324          | Final            | AEBC-ASCL2324       | 2                  |

#Then  the following funding claim reconciliations will have a status of 'Published'
 Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
 | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
 | 10010030 | 2324          | Final            | AEBC-ASCL2324       | 2                  |

 # Use Atom feed to inform downstream systems of claim reconciliation publication event
 And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
 | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
 | 10010030 | 2324          | Final            | AEBC-ASCL2324       | 2                  |

 # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
 And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
 | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                               | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
 | 10010030 | AECA-030         | 2324   | Final         | AEB (Grant) - Adult Skills and Community Learning 23/24           | 46756.00     | 0.00         | -46756.00                   | -46756.00                | 0.00               | ?               | ?                     | 0.00                     |

 

  # Check Financials 


 # Check the deliverable count in CRM (12 mths x 5 deliverables) + (4 mths x 5 deliverables) = 80 deliverable periods
 And   there are '80' deliverable period rows in CRM linked to the latest version of contract 'EDSK-030'

# Check the PLANNED VALUES in CRM on the latest approved contract
 And   the Planned Values are calculated as follows 
 | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
 | EDSK-030       | AECA-030           | 1               | 46756.00  | 6110.00  | 4608.00  | 1713.00  | 2014.00  | 2093.00  | 5557.00  | 2568.00  | 4134.00  | 4119.00  | 5147.00  | 4782.00  | 3911.00  | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 2               | 18779.00  | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 5               | 27977.00  | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | 0.00     | 0.00     | 0.00     | 0.00     | 

 # Check the PROFILE PAYMENTS in CRM on the latest approved contract
 And   the Profile Payments are calculated as follows 
 | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
 | EDSK-030       | AECA-030           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 2               | 18779.00  | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 5               | 27977.00  | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | 0.00     | 0.00     | 0.00     | 0.00     | 

 # Check the BALANCING PAYMENTS in CRM on the latest approved contract
 And   the Balancing Payments are calculated as follows 
 | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
 | EDSK-030       | AECA-030           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

 # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
 And   the Reconciliation Data is calculated as follows 
 | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
 | EDSK-030       | AECA-030           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 2               | -18779.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4694.75 | -4694.75 | -4694.75 | -4694.75 | 
 | EDSK-030       | AECA-030           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 5               | -27977.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6994.25 | -6994.25 | -6994.25 | -6994.25 | 

 # Check the NET AMOUNTS in CRM on the latest approved contract
 And   the Net Payments are calculated as follows 
 | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
 | EDSK-030       | AECA-030           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 2               | 0.00      | 3160.00  | 2631.00  | 1500.00  | 210.00   | 378.00   | 1841.00  | 171.00   | 497.00   | 1485.00  | 2221.00  | 3714.00  | 971.00   | -4694.75 | -4694.75 | -4694.75 | -4694.75 | 
 | EDSK-030       | AECA-030           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | EDSK-030       | AECA-030           | 5               | 0.00      | 2950.00  | 1977.00  | 213.00   | 1804.00  | 1715.00  | 3716.00  | 2397.00  | 3637.00  | 2634.00  | 2926.00  | 1068.00  | 2940.00  | -6994.25 | -6994.25 | -6994.25 | -6994.25 | 


 # Check the PROFILE subnominal aggregations in CRM
 And   the Profile Subnominal Amounts are calculated as follows
 | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-23    | Sep-23    | Oct-23    | Nov-23    | Dec-23    | Jan-24    | Feb-24    | Mar-24    | Apr-24    | May-24    | Jun-24    | Jul-24    | Dec-24    | Jan-25    | Feb-25   | Mar-25    |
 | 10010030 | EDSK-030       | AECA-030           | 2371110                  | 3160.00   | 2631.00   | 1500.00   | 210.00    | 378.00    | 1841.00   | 171.00    | 497.00    | 1485.00   | 2221.00   | 3714.00   | 971.00    | 0.00      | 0.00      | 0.00      | 0.00      | 
 | 10010030 | EDSK-030       | AECA-030           | 2371130                  | 2950.00   | 1977.00   | 213.00    | 1804.00   | 1715.00   | 3716.00   | 2397.00   | 3637.00   | 2634.00   | 2926.00   | 1068.00   | 2940.00   | 0.00      | 0.00      | 0.00      | 0.00      | 

 # Check the RECONCILIATION subnominal aggregations in CRM
 And   the Reconciliation Subnominal Amounts are calculated as follows
 | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-23    | Sep-23    | Oct-23    | Nov-23    | Dec-23    | Jan-24    | Feb-24    | Mar-24    | Apr-24    | May-24    | Jun-24    | Jul-24    | Dec-24    | Jan-25    | Feb-25    | Mar-25    |
 | 10010030 | EDSK-030       | AECA-030           | 2371175                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | -11689.00 | -11689.00 | -11689.00 | -11689.00 | 
 