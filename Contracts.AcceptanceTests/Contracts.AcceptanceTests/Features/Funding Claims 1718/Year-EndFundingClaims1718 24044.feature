Feature: Year-EndFundingClaims1718 24044

@AcceptanceTest @Withdrawn20200404
@FundingClaim
Scenario: A441 Process a 1718 YearEnd Funding Claim against an AEB-LS1718 allocation where the provider has under-delivered. Amend reconciliation then publish. Check CRM, PaaS and PM feed
    Given there is no Contract, Task or Workflow data for UKPRN '10017441' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBL-441      |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEBL-441      |


    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017441' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017441 Co Ltd' with UKPRN '10017441' and OrgId 'ORG0017441' and has 'FCS1 Test' as a manager 
    And   UPIN '117441' is associated with UKPRN '10017441' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017441 | 117441 | 10017441 Co Ltd | 0              | Active | Yes           | AA017441      | ?             | 

    # Change the date
    And   the override date is '01/10/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017441 | 10017441 Co Ltd      | ESFA-441             | AEBP-441       | 1                     | 01/11/2017        | 31/07/2018      | 11840.00      |                                | Contract for Services | 1718   | New          | ORG0017441 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017441 | AEBP-441       | AEBL-441      | AEB-LS            | AEB-LS1718              | AY                      | 01/11/2017          | 31/07/2018        | 11840.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017441 | AEBP-441       | AEBL-441      | 1               | 0                     | 11840.00  | 999.00   | 312.00   | 3356.00  | 643.00   | 1379.00  | 154.00   | 129.00   | 2921.00  | 1947.00  | Adult Education Budget - Learner Support                        | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/10/2017'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-441' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/10/2017'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-441' and actual ContractNumber 'AEBP-441'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-441' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017441 | AEBP-441           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/11/2017        | 31/07/2018      | ?             |
    | 10017441 | ESFA-441           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '9' deliverable period rows in CRM linked to the latest version of contract 'AEBP-441'
	


    # Change the date
    Given the override date is '22/09/2018'

    # Cleardown DEDs and PaaS
    And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017441 |

    #Set up claim data from DC for a 'Year End'
    And   funding claim data is present in the DEDS stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017441     | 10017441 | 1                  | Year End      | AY             | 1718   | False         |

    And   allocation data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017441     | 10017441 | 1                  | Year End      | AY             | 1718   | AEBL-441      | AEB-LS1718              |

    And   deliverable data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017441     | 10017441 | 1                  | Year End      | AY             | 1718   | AEBL-441      | 2               | 1679.61     | 71.40         | 24.60           | 1775.61    |
    | ORG0017441     | 10017441 | 1                  | Year End      | AY             | 1718   | AEBL-441      | 3               | 2156.53     | 24.48         | 8.21            | 2189.22    |
    | ORG0017441     | 10017441 | 1                  | Year End      | AY             | 1718   | AEBL-441      | 4               | 1023.40     | 50.26         | 13.20           | 1086.86    |
    | ORG0017441     | 10017441 | 1                  | Year End      | AY             | 1718   | AEBL-441      | 5               | 2210.64     | 54.89         | 11.52           | 2277.05    |

    When  data is retrieved from the DEDS stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017441 | 1718          | Year End         | AEB-LS1718          | 1                  | 11840.00     | 7328.74      | -4511.26                    | -4511.26            | 7328.74          | 0.00            | 7328.74                  | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017441 | 1718          | Year End         | AEB-LS1718          | AEBL-441      | 11840.00     | 7328.74      | -4511.26                    | -4511.26            | 7328.74          | 0.00            | ?                     | 7328.74                  | n/a              |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017441 | 1718          | Year End         | AEB-LS1718          | AEBL-441      | AEB-LS1718           | 2               | 19+ Hardship                                           | 0.00         | 1775.61      |
    | 10017441 | 1718          | Year End         | AEB-LS1718          | AEBL-441      | AEB-LS1718           | 3               | 20+ Childcare                                          | 0.00         | 2189.22      |
    | 10017441 | 1718          | Year End         | AEB-LS1718          | AEBL-441      | AEB-LS1718           | 4               | Residential Access Fund                                | 0.00         | 1086.86      |
    | 10017441 | 1718          | Year End         | AEB-LS1718          | AEBL-441      | AEB-LS1718           | 5               | Administration Expenditure                             | 0.00         | 2277.05      |


    # Change the date 
    Given the override date is '24/09/2018'

    # Amend Proposed Reconciliation value
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017441 | 1718          | Year End         | AEB-LS1718          | 1                  | AEBL-441      | 11840.00     | 7328.74      | -4511.26                    | -4457.99            | 7328.74          | 0.00            | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017441 | 1718          | Year End         | AEB-LS1718          | 1                  | 11840.00     | 7328.74      | -4511.26                    | -4457.99            | 7328.74          | 0.00            | 7328.74                  | Draft      |


    # Change the date
    Given the override date is '26/09/2018'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017441 | 1718          | Year End         | AEB-LS1718          | 1                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017441 | 1718          | Year End         | AEB-LS1718          | 1                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeedItem contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017441 | 1718          | Year End         | AEB-LS1718          | 1                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017441 | AEBL-441         | 1718   | Year End      | Adult Education Budget - Learner Support 17/18              | 11840.00     | 7328.74      | -4511.26                    | -4457.99                 | 7328.74            | ?               | ?                     | 7328.74                  |

    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20200404
@FundingClaim
Scenario: A442 Process a 1718 YearEnd Funding Claim against an ALLBC1718 allocation where the provider has over-delivered. Amend reconciliation then publish. Check CRM, PaaS and PM feed
    Given there is no Contract, Task or Workflow data for UKPRN '10017442' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLC-442      |

	# Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | ALLC-442      |


    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017442' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017442 Co Ltd' with UKPRN '10017442' and OrgId 'ORG0017442' and has 'FCS1 Test' as a manager 
    And   UPIN '117442' is associated with UKPRN '10017442' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017442 | 117442 | 10017442 Co Ltd | 0              | Active | Yes           | AA017442      | ?             | 

    # Change the date
    And   the override date is '01/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017442 | 10017442 Co Ltd      | ESFA-442             | 24Loans-442    | 1                     | 01/08/2017        | 31/07/2018      | 28092.00      |                                | Contract for Services | 1718   | New          | ORG0017442 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017442 | 24Loans-442    | ALLC-442      | 24+ ALLBC         | ALLBC1718               | AY                      | 01/08/2017          | 31/07/2018        | 28092.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017442 | 24Loans-442    | ALLC-442      | 9               | 0                     | 28092.00  | 734.00   | 3748.00  | 3091.00  | 378.00   | 1114.00  | 3590.00  | 3565.00  | 2656.00  | 1683.00  | 3620.00  | 1509.00  | 2404.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2017'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '24Loans-442' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '09/07/2017'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-442' and actual ContractNumber '24Loans-442'

    # Check that the contract is now approved
    Then  the latest version of contract '24Loans-442' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017442 | 24Loans-442        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017442 | ESFA-442           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract '24Loans-442'



    # Change the date
    Given the override date is '22/09/2018'

    # Cleardown DEDs and PaaS
    And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017442 |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | ALLC-442      |

    #Set up claim data from DC for a 'Year End'
    And   funding claim data is present in the DEDS stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017442     | 10017442 | 1                  | Year End      | AY             | 1718   | False         |

    And   allocation data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017442     | 10017442 | 1                  | Year End      | AY             | 1718   | ALLC-442      | ALLBC1718               |

    And   deliverable data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017442     | 10017442 | 1                  | Year End      | AY             | 1718   | ALLC-442      | 13              | 8821.49     | 42.34         | 16.59           | 8880.42    |
    | ORG0017442     | 10017442 | 1                  | Year End      | AY             | 1718   | ALLC-442      | 14              | 7157.96     | 26.13         | 20.50           | 7204.59    |
    | ORG0017442     | 10017442 | 1                  | Year End      | AY             | 1718   | ALLC-442      | 15              | 6056.05     | 58.25         | 21.29           | 6135.59    |
    | ORG0017442     | 10017442 | 1                  | Year End      | AY             | 1718   | ALLC-442      | 16              | 8835.44     | 8.17          | 13.28           | 8856.89    |

    When  data is retrieved from the DEDS stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017442 | 1718          | Year End         | ALLBC1718           | 1                  | 28092.00     | 31077.49     | 0.00                        | 0.00                | 31077.49         | 0.00            | 31077.49                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017442 | 1718          | Year End         | ALLBC1718           | ALLC-442      | 28092.00     | 31077.49     | 0.00                        | 0.00                | 31077.49         | 0.00            | ?                     | 31077.49                 | n/a              |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017442 | 1718          | Year End         | ALLBC1718           | ALLC-442      | ALLBC1718_AS_LS      | 13              | Loans - Hardship                                       | 0.00         | 8880.42      |
    | 10017442 | 1718          | Year End         | ALLBC1718           | ALLC-442      | ALLBC1718_AS_LS      | 14              | Loans - Childcare                                      | 0.00         | 7204.59      |
    | 10017442 | 1718          | Year End         | ALLBC1718           | ALLC-442      | ALLBC1718_AS_LS      | 15              | Loans - Residential Access Fund                        | 0.00         | 6135.59      |
    | 10017442 | 1718          | Year End         | ALLBC1718           | ALLC-442      | ALLBC1718_AS_LS      | 16              | Loans - Administration Expenditure                     | 0.00         | 8856.89      |


    # Change the date 
    Given the override date is '24/09/2018'

    # Amend Proposed Reconciliation value
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017442 | 1718          | Year End         | ALLBC1718           | 1                  | ALLC-442      | 28092.00     | 31077.49     | 0.00                        | -500.00             | 31077.49         | 0.00            | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017442 | 1718          | Year End         | ALLBC1718           | 1                  | 28092.00     | 31077.49     | 0.00                        | -500.00             | 31077.49         | 0.00            | 31077.49                 | Draft      |


    # Change the date
    Given the override date is '26/09/2018'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017442 | 1718          | Year End         | ALLBC1718           | 1                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017442 | 1718          | Year End         | ALLBC1718           | 1                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017442 | 1718          | Year End         | ALLBC1718           | 1                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |  
    | 10017442 | ALLC-442         | 1718   | Year End      | Advanced Learner Loans Bursary (College) 17/18              | 28092.00     | 31077.49     | 0.00                        | -500.00                  | 31077.49           | ?               | ?                     | 31077.49                 |

    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20200404
@FundingClaim
Scenario: A443 Process a 1718 YearEnd Funding Claim against a mainstream contract with AEBC1718, AEBTO-CL1718 and AEBTO-LS1718 allocations where the provider has under and over-delivered. Amend reconciliation then publish. Check CRM, PaaS and PM feed
    Given there is no Contract, Task or Workflow data for UKPRN '10017443' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEC-443       |
    | AECL-443      |
    | AELS-443      |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEC-443       |
    | AECL-443      |
    | AELS-443      |


    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017443' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017443 Co Ltd' with UKPRN '10017443' and OrgId 'ORG0017443' and has 'FCS1 Test' as a manager 
    And   UPIN '117443' is associated with UKPRN '10017443' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017443 | 117443 | 10017443 Co Ltd | 0              | Active | Yes           | AA017443      | ?             | 

    # Change the date
    And   the override date is '01/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017443 | 10017443 Co Ltd      | ESFA-443             | MAIN-443       | 1                     | 01/08/2017        | 31/07/2018      | 70444.00      |                                | Contract for Services | 1718   | New          | ORG0017443 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017443 | MAIN-443       | AEC-443       | AEBC              | AEBC1718                | AY                      | 01/08/2017          | 31/07/2018        | 18085.00        |                         |            |                                                             | New          |             |
    | 10017443 | MAIN-443       | AECL-443      | AEBTO-CL          | AEBTO-CL1718            | AY                      | 01/08/2017          | 31/07/2018        | 29667.00        |                         |            |                                                             | New          |             |
    | 10017443 | MAIN-443       | AELS-443      | AEBTO-LS          | AEBTO-LS1718            | AY                      | 01/08/2017          | 31/07/2018        | 22692.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017443 | MAIN-443       | AEC-443       | 1               | 0                     | 18085.00  | 436.00   | 727.00   | 2570.00  | 1725.00  | 1543.00  | 1108.00  | 2412.00  | 2200.00  | 119.00   | 1676.00  | 3425.00  | 144.00   | Adult Education Budget Total Funding                            | New          |             |
    | 10017443 | MAIN-443       | AECL-443      | 1               | 0                     | 29667.00  | 2646.00  | 3476.00  | 3704.00  | 1055.00  | 2582.00  | 2685.00  | 3357.00  | 358.00   | 3689.00  | 2083.00  | 3199.00  | 833.00   | Adult Education Budget - Community Learning                     | New          |             |
    | 10017443 | MAIN-443       | AELS-443      | 1               | 0                     | 22692.00  | 1112.00  | 2481.00  | 2076.00  | 1325.00  | 3578.00  | 519.00   | 559.00   | 440.00   | 796.00   | 3430.00  | 2931.00  | 3445.00  | Adult Education Budget - Learner Support                        | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2017'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-443' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2017'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-443' and actual ContractNumber 'MAIN-443'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-443' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017443 | MAIN-443           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017443 | ESFA-443           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'MAIN-443'     


    # Change the date
    Given the override date is '17/09/2018'

    # Cleardown DEDs and PaaS
    And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017443 |

    # Set 'profile' values for Programme Funding
    And   the following profile values exist in config
    | ClaimReconciliationDeliverableGroupCode | UKPRN    | PlannedValue |
    | AEBC1718_CL                             | 10017443 | 2584.00      |


    #Set up claim data from DC for a 'Year End'
    And   funding claim data is present in the DEDS stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017443     | 10017443 | 1                  | Year End      | AY             | 1718   | False         |

    And   allocation data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017443     | 10017443 | 1                  | Year End      | AY             | 1718   | AEC-443       | AEBC1718                |
    | ORG0017443     | 10017443 | 1                  | Year End      | AY             | 1718   | AECL-443      | AEBTO-CL1718            |
    | ORG0017443     | 10017443 | 1                  | Year End      | AY             | 1718   | AELS-443      | AEBTO-LS1718            |

    And   deliverable data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017443     | 10017443 | 1                  | Year End      | AY             | 1718   | AEC-443       | 7               | 29123.85    | 68.80         | 12.90           | 29205.55   |
    | ORG0017443     | 10017443 | 1                  | Year End      | AY             | 1718   | AEC-443       | 8               | 9495.12     | 8.15          | 24.48           | 9527.75    |
    | ORG0017443     | 10017443 | 1                  | Year End      | AY             | 1718   | AEC-443       | 9               | 3862.16     | 63.23         | 11.80           | 3937.19    |
    | ORG0017443     | 10017443 | 1                  | Year End      | AY             | 1718   | AEC-443       | 10              | 30350.01    | 67.23         | 14.88           | 30432.12   |
    | ORG0017443     | 10017443 | 1                  | Year End      | AY             | 1718   | AEC-443       | 12              | 11776.58    | 44.68         | 12.31           | 11833.57   |
    #
    | ORG0017443     | 10017443 | 1                  | Year End      | AY             | 1718   | AECL-443      | 3               | 10823.80    | 67.99         | 12.07           | 10903.86   |
    #
    | ORG0017443     | 10017443 | 1                  | Year End      | AY             | 1718   | AELS-443      | 2               | 42395.11    | 39.53         | 7.30            | 42441.94   |
    | ORG0017443     | 10017443 | 1                  | Year End      | AY             | 1718   | AELS-443      | 3               | 37593.99    | 60.00         | 15.94           | 37669.93   |
    | ORG0017443     | 10017443 | 1                  | Year End      | AY             | 1718   | AELS-443      | 4               | 29718.35    | 51.61         | 10.20           | 29780.16   |
    | ORG0017443     | 10017443 | 1                  | Year End      | AY             | 1718   | AELS-443      | 5               | 35233.43    | 49.87         | 9.38            | 35292.68   |

    When  data is retrieved from the DEDS stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017443 | 1718          | Year End         | AEBC1718            | 1                  | 18085.00     | 84936.18     | 0.00                        | 0.00                | 75686.61         | 0.00            | 75686.61                 | Draft      |
    | 10017443 | 1718          | Year End         | AEBTO-CL1718        | 1                  | 29667.00     | 10903.86     | -18763.14                   | -18763.14           | 10903.86         | 0.00            | 10903.86                 | Draft      |
    | 10017443 | 1718          | Year End         | AEBTO-LS1718        | 1                  | 22692.00     | 145184.71    | 0.00                        | 0.00                | 145184.71        | 0.00            | 145184.71                | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017443 | 1718          | Year End         | AEBC1718            | AEC-443       | 18085.00     | 84936.18     | 0.00                        | 0.00                | 75686.61         | 0.00            | ?                     | 75686.61                 | n/a              |
    | 10017443 | 1718          | Year End         | AEBTO-CL1718        | AECL-443      | 29667.00     | 10903.86     | -18763.14                   | -18763.14           | 10903.86         | 0.00            | ?                     | 10903.86                 | n/a              |
    | 10017443 | 1718          | Year End         | AEBTO-LS1718        | AELS-443      | 22692.00     | 145184.71    | 0.00                        | 0.00                | 145184.71        | 0.00            | ?                     | 145184.71                | n/a              |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017443 | 1718          | Year End         | AEBC1718            | AEC-443       | AEBC1718             | 7               | Learner Support - 19+ Hardship                         | 0.00         | 29205.55     |
    | 10017443 | 1718          | Year End         | AEBC1718            | AEC-443       | AEBC1718             | 8               | Learner Support - 20+ Childcare                        | 0.00         | 9527.75      |
    | 10017443 | 1718          | Year End         | AEBC1718            | AEC-443       | AEBC1718             | 9               | Learner Support - Residential Access Fund              | 0.00         | 3937.19      |
    | 10017443 | 1718          | Year End         | AEBC1718            | AEC-443       | AEBC1718             | 10              | Learner Support - Administration Expenditure           | 0.00         | 30432.12     |
    | 10017443 | 1718          | Year End         | AEBC1718            | AEC-443       | AEBC1718             | 12              | Community Learning - Programme Funding                 | 0.00         | 11833.57     |
    #
    | 10017443 | 1718          | Year End         | AEBTO-CL1718        | AECL-443      | AEBTO-CL1718         | 3               | Programme Funding                                      | 0.00         | 10903.86     |
    #
    | 10017443 | 1718          | Year End         | AEBTO-LS1718        | AELS-443      | AEBTO-LS1718         | 2               | 19+ Hardship                                           | 0.00         | 42441.94     |
    | 10017443 | 1718          | Year End         | AEBTO-LS1718        | AELS-443      | AEBTO-LS1718         | 3               | 20+ Childcare                                          | 0.00         | 37669.93     |
    | 10017443 | 1718          | Year End         | AEBTO-LS1718        | AELS-443      | AEBTO-LS1718         | 4               | Residential Access Fund                                | 0.00         | 29780.16     |
    | 10017443 | 1718          | Year End         | AEBTO-LS1718        | AELS-443      | AEBTO-LS1718         | 5               | Administration Expenditure                             | 0.00         | 35292.68     |


    # Change the date 
    Given the override date is '19/09/2018'

    # Amend Proposed Reconciliation value
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017443 | 1718          | Year End         | AEBC1718            | 1                  | AEC-443       | 18085.00     | 84936.18     | 0.00                        | 93.77               | 75686.61         | 0.00            | ?                     |
    | 10017443 | 1718          | Year End         | AEBTO-CL1718        | 1                  | AECL-443      | 29667.00     | 10903.86     | -18763.14                   | -18912.42           | 10903.86         | 0.00            | ?                     |
    | 10017443 | 1718          | Year End         | AEBTO-LS1718        | 1                  | AELS-443      | 22692.00     | 145184.70    | 0.00                        | -171.25             | 145184.70        | 0.00            | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017443 | 1718          | Year End         | AEBC1718            | 1                  | 18085.00     | 84936.18     | 0.00                        | 93.77               | 75686.61         | 0.00            | 75686.61                 | Draft      |
    | 10017443 | 1718          | Year End         | AEBTO-CL1718        | 1                  | 29667.00     | 10903.86     | -18763.14                   | -18912.42           | 10903.86         | 0.00            | 10903.86                 | Draft      |
    | 10017443 | 1718          | Year End         | AEBTO-LS1718        | 1                  | 22692.00     | 145184.71    | 0.00                        | -171.25             | 145184.71        | 0.00            | 145184.71                | Draft      |


    # Change the date
    Given the override date is '21/09/2018'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017443 | 1718          | Year End         | AEBC1718            | 1                  |
    | 10017443 | 1718          | Year End         | AEBTO-CL1718        | 1                  |
    | 10017443 | 1718          | Year End         | AEBTO-LS1718        | 1                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017443 | 1718          | Year End         | AEBC1718            | 1                  |
    | 10017443 | 1718          | Year End         | AEBTO-CL1718        | 1                  |
    | 10017443 | 1718          | Year End         | AEBTO-LS1718        | 1                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017443 | 1718          | Year End         | AEBC1718            | 1                  |
    | 10017443 | 1718          | Year End         | AEBTO-CL1718        | 1                  |
    | 10017443 | 1718          | Year End         | AEBTO-LS1718        | 1                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017443 | AEC-443          | 1718   | Year End      | Adult Education Budget (College) 17/18                      | 18085.00     | 84936.18     | 0.00                        | 93.77                    | 75686.61           | ?               | ?                     | 75686.61                 |
    | 10017443 | AECL-443         | 1718   | Year End      | Adult Education Budget - Community Learning (TO) 17/18      | 29667.00     | 10903.86     | -18763.14                   | -18912.42                | 10903.86           | ?               | ?                     | 10903.86                 |   
    | 10017443 | AELS-443         | 1718   | Year End      | Adult Education Budget - Learner Support (TO) 17/18         | 22692.00     | 145184.71    | 0.00                        | -171.25                  | 145184.71          | ?               | ?                     | 145184.71                |

    # Tidy up
	And   there are no profile values in config for the following UKPRNs
    | UKPRN    |
    | 10017443 |

    And   the override date is reset

@AcceptanceTest @Withdrawn20200404
@FundingClaim
Scenario: A785 Process a 1718 YearEnd Funding Claim against a 16-19 Funding contract with an 1619LR1718 allocation. All claim data to be ignored
    Given there is no Contract, Task or Workflow data for UKPRN '10017785' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
	And   there isn't any FCR data in the DEDS stub 
    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16LR-785      |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | 16LR-785      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017785' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017785 Co Ltd' with UKPRN '10017785' and OrgId 'ORG0017785' and has 'FCS1 Test' as a manager 
    And   UPIN '117785' is associated with UKPRN '10017785' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017785 | 117785 | 10017785 Co Ltd | 0              | Active | Yes           | AA017785      | ?             | 

    # Change the date
    And   the override date is '01/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017785 | 10017785 Co Ltd      | ESFA-785             | 1619F-785      | 1                     | 01/08/2017        | 31/07/2018      | 744062.00     |                                | Contract for Services | 1718   | New          | ORG0017785 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName           | UoPCode    | AllocationDescription    | CRMIntent    | DeliveryOrg |
    | 10017785 | 1619F-785      | 16LR-785      | 1619LR            | 1619LR1718              | AY                      | 01/08/2017          | 31/07/2018        | 195204.00       |                   |            |                          | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017785 | 1619F-785      | 16LR-785      | 19              | 0                     | 19372.00  | 719.00   | 822.00   | 1495.00  | 3179.00  | 1826.00  | 220.00   | 1336.00  | 3654.00  | 403.00   | 1771.00  | 2349.00  | 1598.00  | 16-19 Bursary Funds                                             | New          |             |
    | 10017785 | 1619F-785      | 16LR-785      | 20              | 0                     | 15772.00  | 1293.00  | 952.00   | 991.00   | 873.00   | 1229.00  | 161.00   | 3363.00  | 176.00   | 2336.00  | 542.00   | 3205.00  | 651.00   | 16-19 Total Programme Funding                                   | New          |             |
    | 10017785 | 1619F-785      | 16LR-785      | 21              | 0                     | 29122.00  | 2296.00  | 2494.00  | 1901.00  | 3680.00  | 2044.00  | 532.00   | 3102.00  | 2795.00  | 1980.00  | 3443.00  | 2756.00  | 2099.00  | 16-19 Formula Protection Funding                                | New          |             |
    | 10017785 | 1619F-785      | 16LR-785      | 22              | 0                     | 24046.00  | 550.00   | 1286.00  | 61.00    | 3737.00  | 2828.00  | 1854.00  | 90.00    | 1681.00  | 2576.00  | 3594.00  | 2274.00  | 3515.00  | 16-19 High Needs Element 2                                      | New          |             |
    | 10017785 | 1619F-785      | 16LR-785      | 24              | 0                     | 23395.00  | 3654.00  | 245.00   | 2088.00  | 1242.00  | 1060.00  | 625.00   | 1929.00  | 1717.00  | 3338.00  | 1193.00  | 2942.00  | 3362.00  | 14-16 Programme Funding                                         | New          |             |
    | 10017785 | 1619F-785      | 16LR-785      | 25              | 0                     | 19172.00  | 538.00   | 1368.00  | 1595.00  | 2648.00  | 473.00   | 577.00   | 1249.00  | 1951.00  | 1580.00  | 3676.00  | 1091.00  | 2426.00  | 14-16 Pupil Premium                                             | New          |             |
    | 10017785 | 1619F-785      | 16LR-785      | 31              | 0                     | 16865.00  | 1552.00  | 2921.00  | 2516.00  | 1765.00  | 317.00   | 959.00   | 998.00   | 880.00   | 1236.00  | 168.00   | 3370.00  | 183.00   | 16-19 Free Meals in FE                                          | New          |             |
    | 10017785 | 1619F-785      | 16LR-785      | 32              | 0                     | 21649.00  | 3485.00  | 708.00   | 654.00   | 1800.00  | 2062.00  | 2259.00  | 1666.00  | 3445.00  | 827.00   | 298.00   | 2867.00  | 1578.00  | 16-19 High Needs SPI Element 1                                  | New          |             |
    | 10017785 | 1619F-785      | 16LR-785      | 33              | 0                     | 25811.00  | 2899.00  | 660.00   | 2691.00  | 3017.00  | 305.00   | 1041.00  | 2533.00  | 3492.00  | 2582.00  | 1609.00  | 3546.00  | 1436.00  | 19+ Continuing Learners Programme Funding                       | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2017'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '1619F-785' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2017'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-785' and actual ContractNumber '1619F-785'

    # Check that the contract is now approved
    Then  the latest version of contract '1619F-785' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017785 | 1619F-785          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017785 | ESFA-785           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '108' deliverable period rows in CRM linked to the latest version of contract '1619F-785'



    # Change the date
    Given the override date is '22/09/2018'

    # Cleardown DEDs and PaaS
    And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017785 |

    # Set up claim data from DC for a 'Year End'
    And   funding claim data is present in the DEDS stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | False         |

    And   allocation data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1619LR1718              |

    And   deliverable data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1001            | 4066.65     | 48.94         | 13.57           | 4129.16    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1002            | 1264.36     | 44.27         | 18.89           | 1327.52    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1003            | 5547.02     | 63.44         | 5.45            | 5615.91    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1004            | 3602.64     | 69.14         | 13.60           | 3685.38    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1005            | 4309.23     | 40.17         | 15.27           | 4364.67    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1006            | 3180.64     | 29.74         | 13.10           | 3223.48    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1007            | 2166.09     | 8.89          | 9.87            | 2184.85    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1008            | 5890.16     | 9.26          | 12.80           | 5912.22    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1009            | 2666.22     | 39.29         | 8.11            | 2713.62    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1010            | 3240.91     | 23.01         | 17.58           | 3281.50    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1011            | 3595.87     | 15.94         | 23.78           | 3635.59    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1012            | 4186.12     | 40.43         | 12.81           | 4239.36    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1013            | 1313.72     | 59.88         | 14.19           | 1387.79    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1014            | 4706.87     | 46.73         | 21.66           | 4775.26    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1015            | 848.48      | 19.72         | 6.47            | 874.67     |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1016            | 1303.62     | 28.22         | 7.56            | 1339.40    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1017            | 751.26      | 42.58         | 18.14           | 811.98     |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1018            | 3606.07     | 62.92         | 6.63            | 3675.62    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1019            | 1757.59     | 52.53         | 14.08           | 1824.20    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1020            | 2624.37     | 15.50         | 19.09           | 2658.96    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1021            | 5626.13     | 42.12         | 6.79            | 5675.04    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1022            | 4728.08     | 33.13         | 14.24           | 4775.45    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1023            | 3333.87     | 19.53         | 11.59           | 3364.99    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1024            | 1251.00     | 46.29         | 8.39            | 1305.68    |
    | ORG0017785     | 10017785 | 1                  | Year End      | AY             | 1718   | 16LR-785      | 1025            | 5619.99     | 11.85         | 13.88           | 5645.72    |

    When  data is retrieved from the DEDS stub and is consumed

	# Manual check ...
	# An entry should appear in the logs for EventId 1723: "A Funding Claim Allocation with FSP: 1619LR1718 has been rejected"

	# Check that the queue is empty
	And   there are no messages on the 'PerformanceManagementDomain.FundingClaimImport' queue

	# Check that the control totals match
   Then  the number of Funding Claims expected for ClaimTypeName 'Year End' and Period '1718' agrees with the number of Funding Claims received 

    # Check that the claim for 1619LR1718 has not arrived in PaaS
    Then  there is no claim data in the PaaS funding claim tables for any of the following
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | 
    | 10017785 | 1718          | Year End         | 1619LR1718          | 16LR-785      | 

	# Tidy up
	And   the override date is reset

@AcceptanceTest @Withdrawn20200404
@FundingClaim
Scenario: A786 Process a 1718 YearEnd Funding Claim for a provider with just a 1619LR1718 allocation and another with both 1619LR1718 and ALLBC1718 allocations. Ignore 1619LR1718 claim data but process ALLBC1718 claim data
    Given there is no Contract, Task or Workflow data for UKPRN '10017786' 
	And   there is no Contract, Task or Workflow data for UKPRN '10017787' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
	And   there isn't any FCR data in the DEDS stub 
	And   there are no master contracts in CRM for master contract number 'ESFA-7861'

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16LR-786      |
    | ALLC-786      |
    | 16LR-787      |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | 16LR-786      |
    | ALLC-786      |
    | 16LR-787      |

    # Set organisation and advisors for 10017786
    And   there is no Organisation data for UKPRN '10017786' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017786 Co Ltd' with UKPRN '10017786' and OrgId 'ORG0017786' and has 'FCS1 Test' as a manager 
    And   UPIN '117786' is associated with UKPRN '10017786' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017786 | 117786 | 10017786 Co Ltd | 0              | Active | Yes           | AA017786      | ?             | 

    # Set organisation and advisors for 10017787
    And   there is no Organisation data for UKPRN '10017787' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017787 Co Ltd' with UKPRN '10017787' and OrgId 'ORG0017787' and has 'FCS1 Test' as a manager 
    And   UPIN '117787' is associated with UKPRN '10017787' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017787 | 117787 | 10017787 Co Ltd | 0              | Active | Yes           | AA017787      | ?             | 
	
	# Change the date
    And   the override date is '01/07/2017'

    # Create 16-19 Funding (1619LR1718) contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017786 | 10017786 Co Ltd      | ESFA-7861            | 1619F-786      | 1                     | 01/08/2017        | 31/07/2018      | 744062.00     |                                | Contract for Services | 1718   | New          | ORG0017786 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName           | UoPCode    | AllocationDescription    | CRMIntent    | DeliveryOrg |
    | 10017786 | 1619F-786      | 16LR-786      | 1619LR            | 1619LR1718              | AY                      | 01/08/2017          | 31/07/2018        | 195204.00       |                   |            |                          | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017786 | 1619F-786      | 16LR-786      | 19              | 0                     | 19372.00  | 719.00   | 822.00   | 1495.00  | 3179.00  | 1826.00  | 220.00   | 1336.00  | 3654.00  | 403.00   | 1771.00  | 2349.00  | 1598.00  | 16-19 Bursary Funds                                             | New          |             |
    | 10017786 | 1619F-786      | 16LR-786      | 20              | 0                     | 15772.00  | 1293.00  | 952.00   | 991.00   | 873.00   | 1229.00  | 161.00   | 3363.00  | 176.00   | 2336.00  | 542.00   | 3205.00  | 651.00   | 16-19 Total Programme Funding                                   | New          |             |
    | 10017786 | 1619F-786      | 16LR-786      | 21              | 0                     | 29122.00  | 2296.00  | 2494.00  | 1901.00  | 3680.00  | 2044.00  | 532.00   | 3102.00  | 2795.00  | 1980.00  | 3443.00  | 2756.00  | 2099.00  | 16-19 Formula Protection Funding                                | New          |             |
    | 10017786 | 1619F-786      | 16LR-786      | 22              | 0                     | 24046.00  | 550.00   | 1286.00  | 61.00    | 3737.00  | 2828.00  | 1854.00  | 90.00    | 1681.00  | 2576.00  | 3594.00  | 2274.00  | 3515.00  | 16-19 High Needs Element 2                                      | New          |             |
    | 10017786 | 1619F-786      | 16LR-786      | 24              | 0                     | 23395.00  | 3654.00  | 245.00   | 2088.00  | 1242.00  | 1060.00  | 625.00   | 1929.00  | 1717.00  | 3338.00  | 1193.00  | 2942.00  | 3362.00  | 14-16 Programme Funding                                         | New          |             |
    | 10017786 | 1619F-786      | 16LR-786      | 25              | 0                     | 19172.00  | 538.00   | 1368.00  | 1595.00  | 2648.00  | 473.00   | 577.00   | 1249.00  | 1951.00  | 1580.00  | 3676.00  | 1091.00  | 2426.00  | 14-16 Pupil Premium                                             | New          |             |
    | 10017786 | 1619F-786      | 16LR-786      | 31              | 0                     | 16865.00  | 1552.00  | 2921.00  | 2516.00  | 1765.00  | 317.00   | 959.00   | 998.00   | 880.00   | 1236.00  | 168.00   | 3370.00  | 183.00   | 16-19 Free Meals in FE                                          | New          |             |
    | 10017786 | 1619F-786      | 16LR-786      | 32              | 0                     | 21649.00  | 3485.00  | 708.00   | 654.00   | 1800.00  | 2062.00  | 2259.00  | 1666.00  | 3445.00  | 827.00   | 298.00   | 2867.00  | 1578.00  | 16-19 High Needs SPI Element 1                                  | New          |             |
    | 10017786 | 1619F-786      | 16LR-786      | 33              | 0                     | 25811.00  | 2899.00  | 660.00   | 2691.00  | 3017.00  | 305.00   | 1041.00  | 2533.00  | 3492.00  | 2582.00  | 1609.00  | 3546.00  | 1436.00  | 19+ Continuing Learners Programme Funding                       | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2017'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '1619F-786' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '09/07/2017'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-7861' and actual ContractNumber '1619F-786'

    # Check that the contract is now approved
    Then  the latest version of contract '1619F-786' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017786 | 1619F-786          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017786 | ESFA-7861          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '108' deliverable period rows in CRM linked to the latest version of contract '1619F-786'



    # Change the date
    Given the override date is '12/07/2017'

    # Create Mainstream (AEBC1718) contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017786 | 10017786 Co Ltd      | ESFA-7862            | 24Loans-786    | 1                     | 01/08/2017        | 31/07/2018      | 22883.00      |                                | Contract for Services | 1718   | New          | ORG0017786 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017786 | 24Loans-786    | ALLC-786      | 24+ ALLBC         | ALLBC1718               | AY                      | 01/08/2017          | 31/07/2018        | 22883.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017786 | 24Loans-786    | ALLC-786      | 9               | 0                     | 22883.00  | 3384.00  | 2697.00  | 2040.00  | 3028.00  | 63.00    | 2539.00  | 2514.00  | 1605.00  | 632.00   | 2569.00  | 459.00   | 1353.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '13/07/2017'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '24Loans-786' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '15/07/2017'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-7862' and actual ContractNumber '24Loans-786'

    # Check that the contract is now approved
    Then  the latest version of contract '24Loans-786' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017786 | 24Loans-786        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017786 | ESFA-7862          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract '24Loans-786'



    # Change the date
    And   the override date is '21/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017787 | 10017787 Co Ltd      | ESFA-787             | 1619F-787      | 1                     | 01/08/2017        | 31/07/2018      | 744062.00     |                                | Contract for Services | 1718   | New          | ORG0017787 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName           | UoPCode    | AllocationDescription    | CRMIntent    | DeliveryOrg |
    | 10017787 | 1619F-787      | 16LR-787      | 1619LR            | 1619LR1718              | AY                      | 01/08/2017          | 31/07/2018        | 195204.00       |                   |            |                          | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017787 | 1619F-787      | 16LR-787      | 19              | 0                     | 19372.00  | 719.00   | 822.00   | 1495.00  | 3179.00  | 1826.00  | 220.00   | 1336.00  | 3654.00  | 403.00   | 1771.00  | 2349.00  | 1598.00  | 16-19 Bursary Funds                                             | New          |             |
    | 10017787 | 1619F-787      | 16LR-787      | 20              | 0                     | 15772.00  | 1293.00  | 952.00   | 991.00   | 873.00   | 1229.00  | 161.00   | 3363.00  | 176.00   | 2336.00  | 542.00   | 3205.00  | 651.00   | 16-19 Total Programme Funding                                   | New          |             |
    | 10017787 | 1619F-787      | 16LR-787      | 21              | 0                     | 29122.00  | 2296.00  | 2494.00  | 1901.00  | 3680.00  | 2044.00  | 532.00   | 3102.00  | 2795.00  | 1980.00  | 3443.00  | 2756.00  | 2099.00  | 16-19 Formula Protection Funding                                | New          |             |
    | 10017787 | 1619F-787      | 16LR-787      | 22              | 0                     | 24046.00  | 550.00   | 1286.00  | 61.00    | 3737.00  | 2828.00  | 1854.00  | 90.00    | 1681.00  | 2576.00  | 3594.00  | 2274.00  | 3515.00  | 16-19 High Needs Element 2                                      | New          |             |
    | 10017787 | 1619F-787      | 16LR-787      | 24              | 0                     | 23395.00  | 3654.00  | 245.00   | 2088.00  | 1242.00  | 1060.00  | 625.00   | 1929.00  | 1717.00  | 3338.00  | 1193.00  | 2942.00  | 3362.00  | 14-16 Programme Funding                                         | New          |             |
    | 10017787 | 1619F-787      | 16LR-787      | 25              | 0                     | 19172.00  | 538.00   | 1368.00  | 1595.00  | 2648.00  | 473.00   | 577.00   | 1249.00  | 1951.00  | 1580.00  | 3676.00  | 1091.00  | 2426.00  | 14-16 Pupil Premium                                             | New          |             |
    | 10017787 | 1619F-787      | 16LR-787      | 31              | 0                     | 16865.00  | 1552.00  | 2921.00  | 2516.00  | 1765.00  | 317.00   | 959.00   | 998.00   | 880.00   | 1236.00  | 168.00   | 3370.00  | 183.00   | 16-19 Free Meals in FE                                          | New          |             |
    | 10017787 | 1619F-787      | 16LR-787      | 32              | 0                     | 21649.00  | 3485.00  | 708.00   | 654.00   | 1800.00  | 2062.00  | 2259.00  | 1666.00  | 3445.00  | 827.00   | 298.00   | 2867.00  | 1578.00  | 16-19 High Needs SPI Element 1                                  | New          |             |
    | 10017787 | 1619F-787      | 16LR-787      | 33              | 0                     | 25811.00  | 2899.00  | 660.00   | 2691.00  | 3017.00  | 305.00   | 1041.00  | 2533.00  | 3492.00  | 2582.00  | 1609.00  | 3546.00  | 1436.00  | 19+ Continuing Learners Programme Funding                       | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '23/07/2017'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '1619F-787' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '25/07/2017'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-787' and actual ContractNumber '1619F-787'

    # Check that the contract is now approved
    Then  the latest version of contract '1619F-787' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017787 | 1619F-787          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017787 | ESFA-787           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '108' deliverable period rows in CRM linked to the latest version of contract '1619F-787'



    # Change the date
    Given the override date is '21/09/2018'

    # Cleardown DEDs and PaaS
    And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017786 |
    | 10017787 |

    #Set up claim data from DC for a 'Year End' for both ALLBC1718 and 1619LR1718 (the latter is to be ignored)
    Given funding claim data is present in the DEDS stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017786     | 10017786 | 1                  | Year End      | AY             | 1718   | False         |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | False         |

    And   allocation data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017786     | 10017786 | 1                  | Year End      | AY             | 1718   | ALLC-786      | ALLBC1718               |
    | ORG0017786     | 10017786 | 1                  | Year End      | AY             | 1718   | 16LR-786      | 1619LR1718              |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1619LR1718              |

    And   deliverable data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017786     | 10017786 | 1                  | Year End      | AY             | 1718   | ALLC-786      | 13              | 1786.49     | 29.79         | 18.32           | 1834.60    |
    | ORG0017786     | 10017786 | 1                  | Year End      | AY             | 1718   | ALLC-786      | 14              | 1128.65     | 58.62         | 7.70            | 1194.97    |
    | ORG0017786     | 10017786 | 1                  | Year End      | AY             | 1718   | ALLC-786      | 15              | 1345.39     | 47.63         | 20.36           | 1413.38    |
    | ORG0017786     | 10017786 | 1                  | Year End      | AY             | 1718   | ALLC-786      | 16              | 3592.42     | 68.51         | 13.77           | 3674.70    |
    #
    | ORG0017786     | 10017786 | 1                  | Year End      | AY             | 1718   | 16LR-786      | 1001            | 4066.65     | 48.94         | 13.57           | 4129.16    |
    | ORG0017786     | 10017786 | 1                  | Year End      | AY             | 1718   | 16LR-786      | 1002            | 1264.36     | 44.27         | 18.89           | 1327.52    |
    | ORG0017786     | 10017786 | 1                  | Year End      | AY             | 1718   | 16LR-786      | 1003            | 5547.02     | 63.44         | 5.45            | 5615.91    |
    | ORG0017786     | 10017786 | 1                  | Year End      | AY             | 1718   | 16LR-786      | 1004            | 3602.64     | 69.14         | 13.60           | 3685.38    |
    | ORG0017786     | 10017786 | 1                  | Year End      | AY             | 1718   | 16LR-786      | 1005            | 4309.23     | 40.17         | 15.27           | 4364.67    |
	#
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1001            | 4066.65     | 48.94         | 13.57           | 4129.16    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1002            | 1264.36     | 44.27         | 18.89           | 1327.52    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1003            | 5547.02     | 63.44         | 5.45            | 5615.91    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1004            | 3602.64     | 69.14         | 13.60           | 3685.38    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1005            | 4309.23     | 40.17         | 15.27           | 4364.67    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1006            | 3180.64     | 29.74         | 13.10           | 3223.48    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1007            | 2166.09     | 8.89          | 9.87            | 2184.85    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1008            | 5890.16     | 9.26          | 12.80           | 5912.22    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1009            | 2666.22     | 39.29         | 8.11            | 2713.62    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1010            | 3240.91     | 23.01         | 17.58           | 3281.50    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1011            | 3595.87     | 15.94         | 23.78           | 3635.59    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1012            | 4186.12     | 40.43         | 12.81           | 4239.36    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1013            | 1313.72     | 59.88         | 14.19           | 1387.79    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1014            | 4706.87     | 46.73         | 21.66           | 4775.26    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1015            | 848.48      | 19.72         | 6.47            | 874.67     |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1016            | 1303.62     | 28.22         | 7.56            | 1339.40    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1017            | 751.26      | 42.58         | 18.14           | 811.98     |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1018            | 3606.07     | 62.92         | 6.63            | 3675.62    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1019            | 1757.59     | 52.53         | 14.08           | 1824.20    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1020            | 2624.37     | 15.50         | 19.09           | 2658.96    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1021            | 5626.13     | 42.12         | 6.79            | 5675.04    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1022            | 4728.08     | 33.13         | 14.24           | 4775.45    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1023            | 3333.87     | 19.53         | 11.59           | 3364.99    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1024            | 1251.00     | 46.29         | 8.39            | 1305.68    |
    | ORG0017787     | 10017787 | 1                  | Year End      | AY             | 1718   | 16LR-787      | 1025            | 5619.99     | 11.85         | 13.88           | 5645.72    |

    When  data is retrieved from the DEDS stub and is consumed

	# Manual check ...
	# Entries should appear in the logs for EventId 1723: "A Funding Claim Allocation with FSP: 1619LR1718 has been rejected"

	# Check that the queue is empty
	And   there are no messages on the 'PerformanceManagementDomain.FundingClaimImport' queue

	# Check that the control totals match
    Then  the number of Funding Claims expected for ClaimTypeName 'Year End' and Period '1718' agrees with the number of Funding Claims received 

    # Check that the claim details have arrived for ALLBC1718 
    And   group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017786 | 1718          | Year End         | ALLBC1718           | 1                  | 22883.00     | 8117.65      | -14765.35                   | -14765.35           | 8117.65          | 0.00            | 8117.65                  | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017786 | 1718          | Year End         | ALLBC1718           | ALLC-786      | 22883.00     | 8117.65      | -14765.35                   | -14765.35           | 8117.65          | 0.00            | ?                     | 8117.65                  | n/a              |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017786 | 1718          | Year End         | ALLBC1718           | ALLC-786      | ALLBC1718_AS_LS      | 13              | Loans - Hardship                                       | 0.00         | 1834.60      |
    | 10017786 | 1718          | Year End         | ALLBC1718           | ALLC-786      | ALLBC1718_AS_LS      | 14              | Loans - Childcare                                      | 0.00         | 1194.97      |
    | 10017786 | 1718          | Year End         | ALLBC1718           | ALLC-786      | ALLBC1718_AS_LS      | 15              | Loans - Residential Access Fund                        | 0.00         | 1413.38      |
    | 10017786 | 1718          | Year End         | ALLBC1718           | ALLC-786      | ALLBC1718_AS_LS      | 16              | Loans - Administration Expenditure                     | 0.00         | 3674.70      |


    # Check that the claim has not arrived for 1619LR1718
    And  there is no claim data in the PaaS funding claim reconciliation tables for any of the following
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | 
    | 10017786 | 1718          | Year End         | 1619LR1718          | 16LR-786      | 
    | 10017787 | 1718          | Year End         | 1619LR1718          | 16LR-787      | 

    # Tidy up
    And   the override date is reset
	
