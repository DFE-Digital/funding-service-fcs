Feature: Year-End1819FundingClaims 25712

@AcceptanceTest @Withdrawn20211005
@FundingClaim
Scenario: A551SLD Create and approve an 1819 Mainstream contract without a Delivery Org. Inject a Final Funding Claim for AEBC1819 below the profile by more than the 3% tolerance. ClaimAdjustment is non-zero (2x) and Reconciliation value changes. Publish. Check CRM, PaaS and Feed
    Given there are no allocations marked as Under Termination for UKPRN '10017551' 
    And   there are no terminated or closed allocations for UKPRN '10017551' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017551' 
    And   there are no notifications of type 'Approval Received'
    And   there are no notifications of type 'Reconciliation Publication Failed'
    And   there are no notifications of type 'FCR Hold Failed'
    And   there are no notifications of type 'Held FCR Release Failed'
    And   there are no notifications of type 'FCR Allocation Update Failed'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEC-551       |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Final         | 1718   |
    | Final         | 1819   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017551 |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEC-551       |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017551' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017551 Co Ltd' with UKPRN '10017551' and OrgId 'ORG0017551' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017551 | 117551 | 10017551 Co Ltd | 0              | Active                | Yes           | AA017551      | ?             | 49 Lyon Meade          | Stanmore               | London                 | ?                      | ?                      | ?                      | HA7 1HZ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017551 |



    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017551 | 10017551 Co Ltd      | ESFA-551             | MAIN-551       | 1                     | 01/08/2018        | 31/07/2019      | 36971.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017551 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017551 | MAIN-551       | AEC-551       | AEBC              | AEBC1819                | AY                      | 01/08/2018          | 31/07/2019        | 36971.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017551 | MAIN-551       | AEC-551       | 1               | 0                     | 36971.00  | 4041.00  | 923.00   | 4610.00  | 1937.00  | 2554.00  | 1685.00  | 4294.00  | 2885.00  | 2426.00  | 3804.00  | 6319.00  | 1493.00  | Adult Education Budget Total Funding                         | New          |             |
    | 10017551 | MAIN-551       | AEC-551       | 13              | 1                     | 17520.00  | 792.00   | 135.00   | 1124.00  | 1860.00  | 634.00   | 610.00   | 3402.00  | 2428.00  | 664.00   | 2255.00  | 3149.00  | 467.00   | Community Learning                                           | New          |             |
    | 10017551 | MAIN-551       | AEC-551       | 14              | 1                     | 19451.00  | 3249.00  | 788.00   | 3486.00  | 77.00    | 1920.00  | 1075.00  | 892.00   | 457.00   | 1762.00  | 1549.00  | 3170.00  | 1026.00  | Other AEB Funding                                            | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-551' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-551' and actual ContractNumber 'MAIN-551'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-551' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017551 | MAIN-551           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017551 | ESFA-551           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'MAIN-551'




    # Populate stub with Claim data

    # Change the date
    Given the override date is '19/10/2019'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017551     | 10017551 | 1                  | Final         | AY             | 1819   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017551     | 10017551 | 1                  | Final         | AY             | 1819   | AEC-551       | AEBC1819                |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017551     | 10017551 | 1                  | Final         | AY             | 1819   | AEC-551       | 2               | 2113.00     | 54.51         | 8.23            | 2175.74    |
    | ORG0017551     | 10017551 | 1                  | Final         | AY             | 1819   | AEC-551       | 3               | 1758.00     | 59.55         | 6.84            | 1824.39    |
    | ORG0017551     | 10017551 | 1                  | Final         | AY             | 1819   | AEC-551       | 4               | 2076.00     | 29.25         | 10.15           | 2115.40    |
    | ORG0017551     | 10017551 | 1                  | Final         | AY             | 1819   | AEC-551       | 5               | 1874.00     | 61.20         | 9.41            | 1944.61    |
    | ORG0017551     | 10017551 | 1                  | Final         | AY             | 1819   | AEC-551       | 6               | 1876.00     | 46.29         | 5.10            | 1927.39    |
    | ORG0017551     | 10017551 | 1                  | Final         | AY             | 1819   | AEC-551       | 7               | 1803.00     | 56.16         | 8.97            | 1868.13    |
    | ORG0017551     | 10017551 | 1                  | Final         | AY             | 1819   | AEC-551       | 8               | 2112.00     | 46.07         | 9.99            | 2168.06    |
    | ORG0017551     | 10017551 | 1                  | Final         | AY             | 1819   | AEC-551       | 9               | 1796.00     | 60.05         | 14.52           | 1870.57    |
    | ORG0017551     | 10017551 | 1                  | Final         | AY             | 1819   | AEC-551       | 10              | 1831.00     | 35.30         | 5.07            | 1871.37    |
    | ORG0017551     | 10017551 | 1                  | Final         | AY             | 1819   | AEC-551       | 13              | 17221.00    | 72.27         | 10.38           | 17303.65   |

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    


    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017551 | 1819          | Final            | AEBC1819            | 1                  | 36971.00     | 35069.31     | -1901.69                    | -1901.69            | 35069.31         | 0.00            | 35069.31                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017551 | 1819          | Final            | AEBC1819            | AEC-551       | 36971.00     | 35069.31     | -1901.69                    | -1901.69            | 35069.31         | 0.00            | ?                     | 35069.31                 | 1109.13          |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017551 | 1819          | Final            | AEBC1819            | AEC-551       | AEBC1819_AS_LS       | 2               | 19-24 Traineeships Programme Funding                   | 0.00         | 2175.74      |
    | 10017551 | 1819          | Final            | AEBC1819            | AEC-551       | AEBC1819_AS_LS       | 3               | 19-24 Traineeships Learning Support                    | 0.00         | 1824.39      |
    | 10017551 | 1819          | Final            | AEBC1819            | AEC-551       | AEBC1819_AS_LS       | 4               | 19-24 Traineeships Learner Support                     | 0.00         | 2115.40      |
    | 10017551 | 1819          | Final            | AEBC1819            | AEC-551       | AEBC1819_AS_LS       | 5               | Other Learning Programme Funding                       | 0.00         | 1944.61      |
    | 10017551 | 1819          | Final            | AEBC1819            | AEC-551       | AEBC1819_AS_LS       | 6               | Other Learning - Learning Support                      | 0.00         | 1927.39      |
    | 10017551 | 1819          | Final            | AEBC1819            | AEC-551       | AEBC1819_AS_LS       | 7               | Learner Support - 19+ Hardship                         | 0.00         | 1868.13      |
    | 10017551 | 1819          | Final            | AEBC1819            | AEC-551       | AEBC1819_AS_LS       | 8               | Learner Support - 20+ Childcare                        | 0.00         | 2168.06      |
    | 10017551 | 1819          | Final            | AEBC1819            | AEC-551       | AEBC1819_AS_LS       | 9               | Learner Support - Residential Access Fund              | 0.00         | 1870.57      |
    | 10017551 | 1819          | Final            | AEBC1819            | AEC-551       | AEBC1819_AS_LS       | 10              | Learner Support - Administration Expenditure           | 0.00         | 1871.37      |
    | 10017551 | 1819          | Final            | AEBC1819            | AEC-551       | AEBC1819_CL          | 13              | Community Learning                                     | 17520.00     | 17303.65     |




    # Change the date 
    Given the override date is '21/10/2019'

    # User updates the Reconciliation value or includes a Claim Adjustment or both or neither. In this case, just the Claim Adjustment
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | 
    | 10017551 | 1819          | Final            | AEBC1819            | 1                  | AEC-551       | 36971.00     | 35069.31     | -1901.69                    | -1901.69            | 35069.31         | 250.00          | Other                 | 

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017551 | 1819          | Final            | AEBC1819            | 1                  | 36971.00     | 35069.31     | -1651.69                    | -1651.69            | 35069.31         | 250.00          | 35319.31                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017551 | 1819          | Final            | AEBC1819            | AEC-551       | 36971.00     | 35069.31     | -1651.69                    | -1651.69            | 35069.31         | 250.00          | Other                 | 35319.31                 | 1109.13          |



    # Change the date 
    Given the override date is '22/10/2019'

    # User updates the Reconciliation value or includes a Claim Adjustment or both or neither. In this case, both
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | 
    | 10017551 | 1819          | Final            | AEBC1819            | 1                  | AEC-551       | 36971.00     | 35069.31     | -1651.69                    | -1250.00            | 35069.31         | 550.00          | Audit                 | 

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017551 | 1819          | Final            | AEBC1819            | 1                  | 36971.00     | 35069.31     | -1351.69                    | -1250.00            | 35069.31         | 550.00          | 35619.31                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017551 | 1819          | Final            | AEBC1819            | AEC-551       | 36971.00     | 35069.31     | -1351.69                    | -1250.00            | 35069.31         | 550.00          | Audit                 | 35619.31                 | 1109.13          |




     # Change the date 
    Given the override date is '23/10/2019'

    # User updates the Reconciliation value or includes a Claim Adjustment or both or neither. In this case, both such that ProposedReconciliationValue is zero but (Final) ReconciliationValue is > 3%
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017551 | 1819          | Final            | AEBC1819            | 1                  | AEC-551       | 36971.00     | 35069.31     | -1351.69                    | 2000.00             | 35069.31         | 1000.00         | FRM Data Query        |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017551 | 1819          | Final            | AEBC1819            | 1                  | 36971.00     | 35069.31     | 0.00                        | 2000.00             | 35069.31         | 1000.00         | 36069.31                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017551 | 1819          | Final            | AEBC1819            | AEC-551       | 36971.00     | 35069.31     | 0.00                        | 2000.00             | 35069.31         | 1000.00         | FRM Data Query        | 36069.31                 | 1109.13          |




    # Change the date
    Given the override date is '26/10/2019'

    # Check the current date against the Publication Close Date for the AGC
   #And   the override date is after the Publication Close Date for Claim Reconciliation Code '1819-Final' and Allocation Group Code '???'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '1819-Final' and Allocation Group Code 'AEBC1819'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017551 | 1819          | Final            | AEBC1819            | 1                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017551 | 1819          | Final            | AEBC1819            | 1                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017551 | 1819          | Final            | AEBC1819            | 1                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017551 | AEC-551          | 1819   | Final         | Adult Education Budget (College) 18/19                      | 36971.00     | 35069.31     | 0.00                        | 2000.00                  | 35069.31           | 1000.00         | FRM Data Query        | 36069.31                 |



    # CRM Payment checks for Nov 2019 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract for Nov 2019
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Nov-19   |
    | MAIN-551       | AEC-551         | 1               | 0.00     | 
    | MAIN-551       | AEC-551         | 2               | 0.00     | 
    | MAIN-551       | AEC-551         | 3               | 0.00     | 
    | MAIN-551       | AEC-551         | 4               | 0.00     | 
    | MAIN-551       | AEC-551         | 5               | 0.00     | 
    | MAIN-551       | AEC-551         | 6               | 0.00     | 
    | MAIN-551       | AEC-551         | 13              | 947.77   | 
    | MAIN-551       | AEC-551         | 14              | 1052.23  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract for Nov 2019
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Nov-19   |
    | MAIN-551       | AEC-551         | 1               | 0.00     | 
    | MAIN-551       | AEC-551         | 2               | 0.00     | 
    | MAIN-551       | AEC-551         | 3               | 0.00     | 
    | MAIN-551       | AEC-551         | 4               | 0.00     | 
    | MAIN-551       | AEC-551         | 5               | 0.00     | 
    | MAIN-551       | AEC-551         | 6               | 0.00     | 
    | MAIN-551       | AEC-551         | 13              | 947.77   | 
    | MAIN-551       | AEC-551         | 14              | 1052.23  | 

    # Check the RECONCILIATION subnominal aggregations in CRM for Nov 2019
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Nov-19    |
    | MAIN-551       | AEC-551         | 2371075                  | 2000.00   | 

    
    # PaaS Payment checks for Nov 2019 
    
    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table for No 2019
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber    | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | AEC-551             | 1             | 13              | 201911 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 947.77                      | 947.77           | ?            | ?           |
    | AEC-551             | 1             | 14              | 201911 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1052.23                     | 1052.23          | ?            | ?           |

    # Check the RECONCILIATION subnominal aggregations in PaaS for Nov 2019
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017551 | ORG0017551 | AEC-551           | 2371075         | AEBC1819                   | 201911               | RECONCILIATION  | CM             | False       | 2000.00         |


    # ADP Feed

	# Check the ADP feed contains an event (incorrect type) for Nov-19 with the apportioned values
    And   the Allocation Delivery Performance atom feed contains the following FCR Published events
    | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment | AggregatedPaymentType | SubnominalCode | AggregatedValue |
    | MAIN-551       | 1             | AEC-551          | 13              | 201911 | 0.00           | 0.00             | 947.77                | 0.00           | 947.77     | RECONCILIATION        | 2371075        | 2000            |
    | MAIN-551       | 1             | AEC-551          | 14              | 201911 | 0.00           | 0.00             | 1052.23               | 0.00           | 1052.23    | RECONCILIATION        | 2371075        | 2000            |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20211005
@FundingClaim
Scenario: A552SLD Create and approve an 1819 AEB contract without a Delivery Org. Inject a Final Funding Claim for AEB-LS1819 below the profile by more than the 3% tolerance. ClaimAdjustment is non-zero and Reconciliation value unchanged. Publish. Check CRM, PaaS and Feed
    Given there are no allocations marked as Under Termination for UKPRN '10017552' 
    And   there are no terminated or closed allocations for UKPRN '10017552' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017552' 
    And   there are no notifications of type 'Approval Received'
    And   there are no notifications of type 'Reconciliation Publication Failed'
    And   there are no notifications of type 'FCR Hold Failed'
    And   there are no notifications of type 'Held FCR Release Failed'
    And   there are no notifications of type 'FCR Allocation Update Failed'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBL-552      |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Final         | 1718   |
    | Final         | 1819   |


    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017552 |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEBL-552      |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017552' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017552 Co Ltd' with UKPRN '10017552' and OrgId 'ORG0017552' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017552 | 117552 | 10017552 Co Ltd | 0              | Provider Under Change | Yes           | AA017552      | ?             | 10 Witcham Close       | Lower Early            | ?                      | ?                      | Reading                | Berkshire              | RG6 4H6   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017552 |



    # Change the date
    Given the override date is '01/11/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017552 | 10017552 Co Ltd      | ESFA-552             | AEBP-552       | 1                     | 01/11/2018        | 31/07/2019      | 13130.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017552 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017552 | AEBP-552       | AEBL-552      | AEB-LS            | AEB-LS1819              | AY                      | 01/11/2018          | 31/07/2019        | 13130.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017552 | AEBP-552       | AEBL-552      | 1               | 0                     | 13130.00  | 957.00   | 300.00   | 1288.00  | 2024.00  | 799.00   | 774.00   | 3566.00  | 2593.00  | 829.00   | Adult Education Budget - Learner Support                        | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-552' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-552' and actual ContractNumber 'AEBP-552'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-552' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017552 | AEBP-552           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/11/2018        | 31/07/2019      | ?             |
    | 10017552 | ESFA-552           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '9' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '9' deliverable period rows in CRM linked to the latest version of contract 'AEBP-552'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBL-552        | 2372065          | Jul-19 | Profile        | 



    # Populate stub with Claim data 

    # Change the date
    Given the override date is '19/10/2019'

    #Set up claim data from DC for a 'Final'
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017552     | 10017552 | 1                  | Final         | AY             | 1819   | False         |

    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017552     | 10017552 | 1                  | Final         | AY             | 1819   | AEBL-552      | AEB-LS1819              |

    And   deliverable data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017552     | 10017552 | 1                  | Final         | AY             | 1819   | AEBL-552      | 2               | 2738.00     | 25.88         | 6.07            | 2769.95    |
    | ORG0017552     | 10017552 | 1                  | Final         | AY             | 1819   | AEBL-552      | 3               | 3209.00     | 53.94         | 13.43           | 3276.37    |
    | ORG0017552     | 10017552 | 1                  | Final         | AY             | 1819   | AEBL-552      | 4               | 3109.00     | 71.70         | 13.96           | 3194.66    |
    | ORG0017552     | 10017552 | 1                  | Final         | AY             | 1819   | AEBL-552      | 5               | 3143.00     | 48.15         | 8.17            | 3199.32    |

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    


    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017552 | 1819          | Final            | AEB-LS1819          | 1                  | 13130.00     | 12440.30     | -689.70                     | -689.70             | 12440.30         | 0.00            | 12440.30                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017552 | 1819          | Final            | AEB-LS1819          | AEBL-552      | 13130.00     | 12440.30     | -689.70                     | -689.70             | 12440.30         | 0.00            | ?                     | 12440.30                 | 393.90           |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017552 | 1819          | Final            | AEB-LS1819          | AEBL-552      | AEB-LS1819           | 2               | 19+ Hardship                                           | 0.00         | 2769.95      |
    | 10017552 | 1819          | Final            | AEB-LS1819          | AEBL-552      | AEB-LS1819           | 3               | 20+ Childcare                                          | 0.00         | 3276.37      |
    | 10017552 | 1819          | Final            | AEB-LS1819          | AEBL-552      | AEB-LS1819           | 4               | Residential Access Fund                                | 0.00         | 3194.66      |
    | 10017552 | 1819          | Final            | AEB-LS1819          | AEBL-552      | AEB-LS1819           | 5               | Administration Expenditure                             | 0.00         | 3199.32      |




    # Change the date 
    Given the override date is '21/10/2019'

    # User updates the Reconciliation value or includes a Claim Adjustment or both or neither. In this case, only a Claim adjustment
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | 
    | 10017552 | 1819          | Final            | AEB-LS1819          | 1                  | AEBL-552      | 13130.00     | 12440.30     | -689.70                     | -689.70             | 12440.30         | -500.00         | FRM Data Query        | 

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017552 | 1819          | Final            | AEB-LS1819          | 1                  | 13130.00     | 12440.30     | -1189.70                    | -1189.70            | 12440.30         | -500.00         | 11940.30                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017552 | 1819          | Final            | AEB-LS1819          | AEBL-552      | 13130.00     | 12440.30     | -1189.70                    | -1189.70            | 12440.30         | -500.00         | FRM Data Query        | 11940.30                 | 393.90           |


	# Allow system to finish processing all events before publishing FCR
	When  there are no messages left in the system

    # Change the date
    Given the override date is '23/10/2019'

    # Check the current date against the Publication Close Date for the AGC
   #And   the override date is after the Publication Close Date for Claim Reconciliation Code '1819-Final' and Allocation Group Code '???'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '1819-Final' and Allocation Group Code 'AEB-LS1819'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017552 | 1819          | Final            | AEB-LS1819          | 1                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017552 | 1819          | Final            | AEB-LS1819          | 1                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017552 | 1819          | Final            | AEB-LS1819          | 1                  |

    # Check the content of the type 0 events in the PaaS PerformanceManagement.AtomFeedItem table
    And   the Performance Management atom feed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                    | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017552 | AEBL-552         | 1819   | Final         | Adult Education Budget - Learner Support 18/19         | 13130.00     | 12440.30     | -1189.70                    | -1189.70                 | 12440.30           | -500.00         | FRM Data Query        | 11940.30                 |
 



    # Add Payment checks for Nov 2019 (26007)
	
	# Check the RECONCILIATION AMOUNT in CRM for Nov 2019
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Nov-19   |
    | AEBP-552       | AEBL-552        | 1               | -1189.70 |

	# Check the NET AMOUNT in CRM for Nov 2019
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Nov-19   |
    | AEBP-552       | AEBL-552        | 1               | -1189.70 |
    
    # Check the RECONCILIATION subnominal aggregations in CRM for Nov 2019
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Nov-19    |
    | AEBP-552       | AEBL-552        | 2372075                  | -1189.70  | 

    # Check the RECONCILIATION subnominal aggregations in PaaS for Nov 2019
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017552 | ORG0017552 | AEBL-552          | 2372075         | AEB-LS1819                 | 201911               | RECONCILIATION  | CM             | False       | -1189.70        |


    # ADP Feed

    # Check the ADP feed contains an event (incorrect type) for Nov-19 
    Then  the Allocation Delivery Performance atom feed contains the following FCR Published events
    | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment | AggregatedPaymentType | SubnominalCode | AggregatedValue |
    | AEBP-552       | 1             | AEBL-552         | 1               | 201911 | 0.00           | 0.00             | -1189.70              | 0.00           | -1189.70   | RECONCILIATION        | 2372075        | -1189.70        |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20211005
@FundingClaim
@Long2Run @Long2Run45
Scenario: A553SLD Create and approve an 1819 Loans contract without a Delivery Org. Inject a Final Funding Claim for ALLBC1819 equal to the profile value. ClaimAdjustment is zero. Reconciliation value unchanged. Publish. Check CRM and Feed
    Given there are no allocations marked as Under Termination for UKPRN '10017553' 
    And   there are no terminated or closed allocations for UKPRN '10017553' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017553' 
    And   there are no notifications of type 'Approval Received'
    And   there are no notifications of type 'Reconciliation Publication Failed'
    And   there are no notifications of type 'FCR Hold Failed'
    And   there are no notifications of type 'Held FCR Release Failed'
    And   there are no notifications of type 'FCR Allocation Update Failed'
    
    # Clear down ADP and CM feeds
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLC-553      |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | ALLC-553      |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Final         | 1718   |
    | Final         | 1819   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017553 |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017553' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017553 Co Ltd' with UKPRN '10017553' and OrgId 'ORG0017553' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017553 | 117553 | 10017553 Co Ltd | 0              | In Administration     | Yes           | AA017553      | ?             | 5 Alton House          | Gatehouse Way          | ?                      | ?                      | Alyesbury              | Buckinghamshire        | HP19 8HN  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017553 |




    # Change the date
    Given the override date is '01/08/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017553 | 10017553 Co Ltd      | ESFA-553             | LOANS-553      | 1                     | 01/08/2018        | 31/07/2019      | 23879.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017553 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017553 | LOANS-553      | ALLC-553      | ALLBC             | ALLBC1819               | AY                      | 01/08/2018          | 31/07/2019        | 23879.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017553 | LOANS-553      | ALLC-553      | 1               | 0                     | 23879.00  | 2556.00  | 1899.00  | 2887.00  | 3623.00  | 2398.00  | 2373.00  | 1464.00  | 491.00   | 2428.00  | 318.00   | 1212.00  | 2230.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'LOANS-553' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-553' and actual ContractNumber 'LOANS-553'

    # Check that the contract is now approved
    Then  the latest version of contract 'LOANS-553' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017553 | LOANS-553          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017553 | ESFA-553           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'LOANS-553'




    # Populate stub with Claim data 

    # Change the date
    Given the override date is '19/10/2019'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017553     | 10017553 | 1                  | Final         | AY             | 1819   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017553     | 10017553 | 1                  | Final         | AY             | 1819   | ALLC-553      | ALLBC1819               |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017553     | 10017553 | 1                  | Final         | AY             | 1819   | ALLC-553      | 2               | 3396.00     | 56.18         | 5.85            | 3458.03    |
    | ORG0017553     | 10017553 | 1                  | Final         | AY             | 1819   | ALLC-553      | 3               | 3370.00     | 42.06         | 6.81            | 3418.87    |
    | ORG0017553     | 10017553 | 1                  | Final         | AY             | 1819   | ALLC-553      | 4               | 3219.00     | 43.55         | 8.11            | 3270.66    |
    | ORG0017553     | 10017553 | 1                  | Final         | AY             | 1819   | ALLC-553      | 5               | 3230.00     | 70.78         | 9.57            | 3310.35    |
    | ORG0017553     | 10017553 | 1                  | Final         | AY             | 1819   | ALLC-553      | 6               | 2914.00     | 47.38         | 7.49            | 2968.87    |
    | ORG0017553     | 10017553 | 1                  | Final         | AY             | 1819   | ALLC-553      | 7               | 2928.00     | 50.23         | 12.84           | 2991.07    |
    | ORG0017553     | 10017553 | 1                  | Final         | AY             | 1819   | ALLC-553      | 8               | 2993.00     | 59.29         | 1408.86         | 4461.15    |
    
    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    


    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017553 | 1819          | Final            | ALLBC1819           | 1                  | 23879.00     | 23879.00     | 0.00                        | 0.00                | 23879.00         | 0.00            | 23879.00                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017553 | 1819          | Final            | ALLBC1819           | ALLC-553      | 23879.00     | 23879.00     | 0.00                        | 0.00                | 23879.00         | 0.00            | ?                     | 23879.00                 | 716.37           |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017553 | 1819          | Final            | ALLBC1819           | ALLC-553      | ALLBC1819_AS_LS      | 2               | Loans - Bursary Funding                                | 0.00         | 3458.03      |
    | 10017553 | 1819          | Final            | ALLBC1819           | ALLC-553      | ALLBC1819_AS_LS      | 3               | Loans - Area Costs                                     | 0.00         | 3418.87      |
    | 10017553 | 1819          | Final            | ALLBC1819           | ALLC-553      | ALLBC1819_AS_LS      | 4               | Loans - Excess Claims                                  | 0.00         | 3270.66      |
    | 10017553 | 1819          | Final            | ALLBC1819           | ALLC-553      | ALLBC1819_AS_LS      | 5               | Loans - Hardship                                       | 0.00         | 3310.35      |
    | 10017553 | 1819          | Final            | ALLBC1819           | ALLC-553      | ALLBC1819_AS_LS      | 6               | Loans - Childcare                                      | 0.00         | 2968.87      |
    | 10017553 | 1819          | Final            | ALLBC1819           | ALLC-553      | ALLBC1819_AS_LS      | 7               | Loans - Residential Access Fund                        | 0.00         | 2991.07      |
    | 10017553 | 1819          | Final            | ALLBC1819           | ALLC-553      | ALLBC1819_AS_LS      | 8               | Loans - Administration Expenditure                     | 0.00         | 4461.15      |




    # Change the date 
    Given the override date is '21/10/2019'

    # User updates the Reconciliation value or includes a Claim Adjustment or both or neither. In this case, neither
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | 
    | 10017553 | 1819          | Final            | ALLBC1819           | 1                  | ALLC-553      | 23879.00     | 23879.00     | 0.00                        | 0.00                | 23879.00         | ?               | ?                     | 

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017553 | 1819          | Final            | ALLBC1819           | 1                  | 23879.00     | 23879.00     | 0.00                        | 0.00                | 23879.00         | 0.00            | 23879.00                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017553 | 1819          | Final            | ALLBC1819           | ALLC-553      | 23879.00     | 23879.00     | 0.00                        | 0.00                | 23879.00         | 0.00            | ?                     | 23879.00                 | 716.37           |




    # Change the date
    Given the override date is '23/10/2019'

    # Check the current date against the Publication Close Date for the AGC   
   #And   the override date is after the Publication Close Date for Claim Reconciliation Code '1819-Final' and Allocation Group Code '???'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '1819-Final' and Allocation Group Code 'ALLBC1819'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017553 | 1819          | Final            | ALLBC1819           | 1                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017553 | 1819          | Final            | ALLBC1819           | 1                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017553 | 1819          | Final            | ALLBC1819           | 1                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017553 | ALLC-553         | 1819   | Final         | Advanced Learner Loans Bursary (College) 18/19              | 23879.00     | 23879.00     | 0.00                        | 0.00                     | 23879.00           | ?               | ?                     | 23879.00                 |




    # Add Payment checks for Nov 2019 (26007)
    
    # Check the RECONCILIATION AMOUNTS in CRM for Nov 2019
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Nov-19   |
    | LOANS-553      | ALLC-553        | 1               | 0.00     |

    # Check the RECONCILIATION subnominal aggregations in CRM for Nov 2019
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Nov-19    |
    | LOANS-553      | ALLC-553        | 2303975                  | 0.00      | 

    # Check the RECONCILIATION subnominal aggregations in PaaS for Nov 2019
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017553 | ORG0017553 | ALLC-553          | 2303975         | ALLBC1819                  | 201911               | RECONCILIATION  | CM             | False       | 0.00            |



    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check the ADP feed contains an event (incorrect type) for Nov-19 
    Then  the Allocation Delivery Performance atom feed contains the following FCR Published events
    | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment | AggregatedPaymentType | SubnominalCode | AggregatedValue |
    | LOANS-553      | 1             | ALLC-553         | 1               | 201911 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       | RECONCILIATION        | 2303975        | 0.00            |
    
    
    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20211005
@FundingClaim
@Long2Run @Long2Run45
Scenario: A554SLD Create and approve 1819 Mainstream, Loans and AEB contracts sans Delivery Org. Bulk amend the Loans contract but dont approve it. Inject a Year End Funding Claim for all three contracts. ClaimAdjustment non-zero. Reconciliation value changes. Publish. Check CRM and Feed
    Given there are no allocations marked as Under Termination for UKPRN '10017554' 
    And   there are no terminated or closed allocations for UKPRN '10017554' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017554' 
	And   there are no notifications of type 'Approval Received'
    And   there are no notifications of type 'Reconciliation Publication Failed'
	And   there are no notifications of type 'FCR Hold Failed'
	And   there are no notifications of type 'Held FCR Release Failed'
    And   there are no notifications of type 'FCR Allocation Update Failed'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBL-554      |
	| AEC-554       |
	| ALLC-554      |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Final         | 1718   |
    | Final         | 1819   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017554 |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEBL-554      |
	| AEC-554       |
	| ALLC-554      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017554' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017554 Co Ltd' with UKPRN '10017554' and OrgId 'ORG0017554' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017554 | 117554 | 10017554 Co Ltd | 0              | In Administration     | Yes           | AA017554      | ?             | 6 Eghams Court         | Boston Drive           | ?                      | ?                      | Bourne End             | Buckinghamshire        | SL8 5YS   |

    # Put the same Provider data in the CRM Organisation table
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017554 |




    # Change the date
    Given the override date is '11/07/2018'

    # Create Loans contract for FSP ALLBC1819
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017554 | 10017554 Co Ltd      | ESFA-5541            | LOANS-554      | 1                     | 01/08/2018        | 31/07/2019      | 19899.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017554 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017554 | LOANS-554      | ALLC-554      | ALLBC             | ALLBC1819               | AY                      | 01/08/2018          | 31/07/2019        | 19899.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017554 | LOANS-554      | ALLC-554      | 1               | 0                     | 19899.00  | 1937.00  | 3494.00  | 1542.00  | 979.00   | 702.00   | 1532.00  | 2743.00  | 94.00    | 1621.00  | 742.00   | 1414.00  | 3099.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '12/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'LOANS-554' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '13/07/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-5541' and actual ContractNumber 'LOANS-554'

    # Check that the contract is now approved
    Then  the latest version of contract 'LOANS-554' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017554 | LOANS-554          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017554 | ESFA-5541          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'LOANS-554'




    # Bulk import to amend the Loans contract and change the financials. Don't approve this one.

    # Change the date
    Given the override date is '07/10/2018'

    # Amend the contract
    And   there are no files prefixed '10017554' in the Sharepoint 'LOANS-1819-Input-Appendices' folder
    And   there are no files prefixed '10017554' in the Sharepoint 'LOANS-1819-Output-Merged Document' folder
    And   there are no files prefixed 'LOANS AY 1819 15042019084553 v3_A554' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'LOANS AY 1819 15042019084553 v3_A554' in the Sharepoint 'Reports' folder
    And   spreadsheet 'LOANS AY 1819 15042019084553 v3_A554.xlsx' exists in the Datafiles folder and UKPRN '10017554' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017554 | LOANS-554          | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017554 | LOANS-554          | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017554 | ESFA-5541          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Change the date
    Given the override date is '11/11/2018'

    # Create AEB contract for FSP AEB-CL1819
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017554 | 10017554 Co Ltd      | ESFA-5542            | AEBP-554       | 1                     | 01/11/2018        | 31/07/2019      | 13958.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017554 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription         | CRMIntent    | DeliveryOrg |
    | 10017554 | AEBP-554       | AEBL-554      | AEB-LS            | AEB-LS1819              | AY                      | 01/11/2018          | 31/07/2019        | 13958.00        |                                         |            |                               | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017554 | AEBP-554       | AEBL-554      | 1               | 0                     | 13958.00  | 1049.00  | 392.00   | 1380.00  | 2116.00  | 891.00   | 866.00   | 3658.00  | 2685.00  | 921.00   | Adult Education Budget - Learner Support                        | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '12/11/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-554' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '13/11/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-5542' and actual ContractNumber 'AEBP-554'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-554' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017554 | AEBP-554           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/11/2018        | 31/07/2019      | ?             |
    | 10017554 | ESFA-5542          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '9' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '9' deliverable period rows in CRM linked to the latest version of contract 'AEBP-554'




    # Change the date
    Given the override date is '21/11/2018'

    # Create Mainstream contract for FSP AEBC1819 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017554 | 10017554 Co Ltd      | ESFA-5543            | MAIN-554       | 1                     | 01/08/2018        | 31/07/2019      | 49513.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017554 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017554 | MAIN-554       | AEC-554       | AEBC              | AEBC1819                | AY                      | 01/08/2018          | 31/07/2019        | 49513.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017554 | MAIN-554       | AEC-554       | 1               | 0                     | 49513.00  | 4291.00  | 5225.00  | 3407.00  | 5161.00  | 2616.00  | 4814.00  | 6603.00  | 2220.00  | 2300.00  | 5763.00  | 2773.00  | 4340.00  | Adult Education Budget Total Funding                            | New          |             |
    | 10017554 | MAIN-554       | AEC-554       | 13              | 1                     | 26231.00  | 1665.00  | 1863.00  | 1270.00  | 3049.00  | 1413.00  | 3602.00  | 3454.00  | 2164.00  | 1349.00  | 2811.00  | 2124.00  | 1467.00  | Community Learning                                              | New          |             |
    | 10017554 | MAIN-554       | AEC-554       | 14              | 1                     | 23282.00  | 2626.00  | 3362.00  | 2137.00  | 2112.00  | 1203.00  | 1212.00  | 3149.00  | 56.00    | 951.00   | 2952.00  | 649.00   | 2873.00  | Other AEB Funding                                               | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '22/11/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-554' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '23/11/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-5543' and actual ContractNumber 'MAIN-554'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-554' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017554 | MAIN-554           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017554 | ESFA-5543          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'MAIN-554'




    # Populate stub with Claim data

    # Change the date
    Given the override date is '19/06/2019'

    #Set up claim data from DC for a 'Year End'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | AEBL-554      | AEB-LS1819              |
	| ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | AEC-554       | AEBC1819                |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | ALLC-554      | ALLBC1819               |
    
   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | AEBL-554      | 2               | 3875.00     | 57.63         | 13.59           | 3946.22    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | AEBL-554      | 3               | 3954.00     | 32.74         | 8.96            | 3995.70    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | AEBL-554      | 4               | 3652.00     | 73.84         | 6.73            | 3732.57    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | AEBL-554      | 5               | 4003.00     | 38.70         | 14.15           | 4055.85    |
	#
	| ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | AEC-554       | 2               | 2998.00     | 66.35         | 6.36            | 3070.71    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | AEC-554       | 3               | 3069.00     | 52.77         | 5.86            | 3127.63    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | AEC-554       | 4               | 3097.00     | 62.27         | 7.81            | 3167.08    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | AEC-554       | 5               | 2935.00     | 34.38         | 10.08           | 2979.46    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | AEC-554       | 6               | 2661.00     | 69.07         | 9.19            | 2739.26    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | AEC-554       | 7               | 2843.00     | 44.08         | 13.15           | 2900.23    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | AEC-554       | 8               | 3068.00     | 38.55         | 8.71            | 3115.26    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | AEC-554       | 9               | 2666.00     | 37.44         | 10.72           | 2714.16    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | AEC-554       | 10              | 3083.00     | 33.30         | 6.24            | 3122.54    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | AEC-554       | 13              | 28610.00    | 27.12         | 14.81           | 28651.93   |
	#
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | ALLC-554      | 2               | 3061.00     | 63.96         | 13.66           | 3138.62    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | ALLC-554      | 3               | 3263.00     | 70.42         | 9.64            | 3343.06    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | ALLC-554      | 4               | 3010.00     | 37.28         | 7.50            | 3054.78    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | ALLC-554      | 5               | 2900.00     | 56.73         | 12.15           | 2968.88    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | ALLC-554      | 6               | 3201.00     | 67.54         | 14.76           | 3283.30    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | ALLC-554      | 7               | 2946.00     | 25.09         | 11.60           | 2982.69    |
    | ORG0017554     | 10017554 | 5                  | Year End      | AY             | 1819   | ALLC-554      | 8               | 2859.00     | 66.59         | 13.82           | 2939.41    |

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed




    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017554 | 1819          | Year End         | AEB-LS1819          | 5                  | 13958.00     | 15730.34     | 0.00                        | 0.00                | 15730.34         | 0.00            | 15730.34                 | Draft      |
    | 10017554 | 1819          | Year End         | AEBC1819            | 5                  | 49513.00     | 55588.26     | 1485.39                     | 1485.39             | 53167.33         | 0.00            | 53167.33                 | Draft      |
    | 10017554 | 1819          | Year End         | ALLBC1819           | 5                  | 19899.00     | 21710.74     | 0.00                        | 0.00                | 21710.74         | 0.00            | 21710.74                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017554 | 1819          | Year End         | AEB-LS1819          | AEBL-554      | 13958.00     | 15730.34     | 0.00                        | 0.00                | 15730.34         | 0.00            | ?                     | 15730.34                 | 418.74           |
    | 10017554 | 1819          | Year End         | AEBC1819            | AEC-554       | 49513.00     | 55588.26     | 1485.39                     | 1485.39             | 53167.33         | 0.00            | ?                     | 53167.33                 | 1485.39          |
    | 10017554 | 1819          | Year End         | ALLBC1819           | ALLC-554      | 19899.00     | 21710.74     | 0.00                        | 0.00                | 21710.74         | 0.00            | ?                     | 21710.74                 | 596.97           |
	
	And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017554 | 1819          | Year End         | AEB-LS1819          | AEBL-554      | AEB-LS1819           | 2               | 19+ Hardship                                           | 0.00         | 3946.22      |
    | 10017554 | 1819          | Year End         | AEB-LS1819          | AEBL-554      | AEB-LS1819           | 3               | 20+ Childcare                                          | 0.00         | 3995.70      |
    | 10017554 | 1819          | Year End         | AEB-LS1819          | AEBL-554      | AEB-LS1819           | 4               | Residential Access Fund                                | 0.00         | 3732.57      |
    | 10017554 | 1819          | Year End         | AEB-LS1819          | AEBL-554      | AEB-LS1819           | 5               | Administration Expenditure                             | 0.00         | 4055.85      |
	#
    | 10017554 | 1819          | Year End         | AEBC1819            | AEC-554       | AEBC1819_AS_LS       | 2               | 19-24 Traineeships Programme Funding                   | 0.00         | 3070.71      |
    | 10017554 | 1819          | Year End         | AEBC1819            | AEC-554       | AEBC1819_AS_LS       | 3               | 19-24 Traineeships Learning Support                    | 0.00         | 3127.63      |
    | 10017554 | 1819          | Year End         | AEBC1819            | AEC-554       | AEBC1819_AS_LS       | 4               | 19-24 Traineeships Learner Support                     | 0.00         | 3167.08      |
    | 10017554 | 1819          | Year End         | AEBC1819            | AEC-554       | AEBC1819_AS_LS       | 5               | Other Learning Programme Funding                       | 0.00         | 2979.46      |
    | 10017554 | 1819          | Year End         | AEBC1819            | AEC-554       | AEBC1819_AS_LS       | 6               | Other Learning - Learning Support                      | 0.00         | 2739.26      |
    | 10017554 | 1819          | Year End         | AEBC1819            | AEC-554       | AEBC1819_AS_LS       | 7               | Learner Support - 19+ Hardship                         | 0.00         | 2900.23      |
    | 10017554 | 1819          | Year End         | AEBC1819            | AEC-554       | AEBC1819_AS_LS       | 8               | Learner Support - 20+ Childcare                        | 0.00         | 3115.26      |
    | 10017554 | 1819          | Year End         | AEBC1819            | AEC-554       | AEBC1819_AS_LS       | 9               | Learner Support - Residential Access Fund              | 0.00         | 2714.16      |
    | 10017554 | 1819          | Year End         | AEBC1819            | AEC-554       | AEBC1819_AS_LS       | 10              | Learner Support - Administration Expenditure           | 0.00         | 3122.54      |
    | 10017554 | 1819          | Year End         | AEBC1819            | AEC-554       | AEBC1819_CL          | 13              | Community Learning                                     | 26231.00     | 28651.93     |
	#
	| 10017554 | 1819          | Year End         | ALLBC1819           | ALLC-554      | ALLBC1819            | 2               | Loans - Bursary Funding                                | 0.00         | 3138.62      |
    | 10017554 | 1819          | Year End         | ALLBC1819           | ALLC-554      | ALLBC1819            | 3               | Loans - Area Costs                                     | 0.00         | 3343.06      |
    | 10017554 | 1819          | Year End         | ALLBC1819           | ALLC-554      | ALLBC1819            | 4               | Loans - Excess Claims                                  | 0.00         | 3054.78      |
    | 10017554 | 1819          | Year End         | ALLBC1819           | ALLC-554      | ALLBC1819            | 5               | Loans - Hardship                                       | 0.00         | 2968.88      |
    | 10017554 | 1819          | Year End         | ALLBC1819           | ALLC-554      | ALLBC1819            | 6               | Loans - Childcare                                      | 0.00         | 3283.30      |
    | 10017554 | 1819          | Year End         | ALLBC1819           | ALLC-554      | ALLBC1819            | 7               | Loans - Residential Access Fund                        | 0.00         | 2982.69      |
    | 10017554 | 1819          | Year End         | ALLBC1819           | ALLC-554      | ALLBC1819            | 8               | Loans - Administration Expenditure                     | 0.00         | 2939.41      |



    # Change the date 
    Given the override date is '21/06/2019'

    # User updates the Reconciliation value or includes a Claim Adjustment or both or neither. In this case, Reconciliation value
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | 
    | 10017554 | 1819          | Year End         | AEB-LS1819          | 5                  | AEBL-554      | 13958.00     | 15730.34     | 0.00                        | -30.44              | 15730.34         | 1.00            | Other                 | 
    | 10017554 | 1819          | Year End         | AEBC1819            | 5                  | AEC-554       | 49513.00     | 55588.26     | 1485.39                     | 95.83               | 53167.33         | 1.00            | Other                 | 
    | 10017554 | 1819          | Year End         | ALLBC1819           | 5                  | ALLC-554      | 19899.00     | 21710.74     | 0.00                        | 116.12              | 21710.74         | 1.00            | Other                 | 

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017554 | 1819          | Year End         | AEB-LS1819          | 5                  | 13958.00     | 15730.34     | 0.00                        | -30.44              | 15730.34         | 1.00            | 15731.34                 | Draft      |
    | 10017554 | 1819          | Year End         | AEBC1819            | 5                  | 49513.00     | 55588.26     | 1485.39                     | 95.83               | 53167.33         | 1.00            | 53168.33                 | Draft      |
    | 10017554 | 1819          | Year End         | ALLBC1819           | 5                  | 19899.00     | 21710.74     | 0.00                        | 116.12              | 21710.74         | 1.00            | 21711.74                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017554 | 1819          | Year End         | AEB-LS1819          | AEBL-554      | 13958.00     | 15730.34     | 0.00                        | -30.44              | 15730.34         | 1.00            | Other                 | 15731.34                 | 418.74           |
    | 10017554 | 1819          | Year End         | AEBC1819            | AEC-554       | 49513.00     | 55588.26     | 1485.39                     | 95.83               | 53167.33         | 1.00            | Other                 | 53168.33                 | 1485.39          |    
	| 10017554 | 1819          | Year End         | ALLBC1819           | ALLC-554      | 19899.00     | 21710.74     | 0.00                        | 116.12              | 21710.74         | 1.00            | Other                 | 21711.74                 | 596.97           |



    # Change the date
    Given the override date is '23/06/2019'

    # Check the current date against the Publication Close Date for the AGC
   #And   the override date is after the Publication Close Date for Claim Reconciliation Code '1819-YearEnd' and Allocation Group Code '???'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '1819-YearEnd' and Allocation Group Code 'AEB-LS1819'
	And   the override date is before the Publication Close Date for Claim Reconciliation Code '1819-YearEnd' and Allocation Group Code 'AEBC1819'
    And   the override date is before the Publication Close Date for Claim Reconciliation Code '1819-YearEnd' and Allocation Group Code 'ALLBC1819'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017554 | 1819          | Year End         | AEB-LS1819          | 5                  |
	| 10017554 | 1819          | Year End         | AEBC1819            | 5                  |
    | 10017554 | 1819          | Year End         | ALLBC1819           | 5                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017554 | 1819          | Year End         | AEB-LS1819          | 5                  |
	| 10017554 | 1819          | Year End         | AEBC1819            | 5                  |
    | 10017554 | 1819          | Year End         | ALLBC1819           | 5                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017554 | 1819          | Year End         | AEB-LS1819          | 5                  |
	| 10017554 | 1819          | Year End         | AEBC1819            | 5                  |
    | 10017554 | 1819          | Year End         | ALLBC1819           | 5                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017554 | AEBL-554         | 1819   | Year End      | Adult Education Budget - Learner Support 18/19              | 13958.00     | 15730.34     | 0.00                        | -30.44                   | 15730.34           | 1.00            | Other                 | 15731.34                 |  
    | 10017554 | AEC-554          | 1819   | Year End      | Adult Education Budget (College) 18/19                      | 49513.00     | 55588.26     | 1485.39                     | 95.83                    | 53167.33           | 1.00            | Other                 | 53168.33                 |  
    | 10017554 | ALLC-554         | 1819   | Year End      | Advanced Learner Loans Bursary (College) 18/19              | 19899.00     | 21710.74     | 0.00                        | 116.12                   | 21710.74           | 1.00            | Other                 | 21711.74                 |  


    # Tidy up
    And   the override date is reset

      