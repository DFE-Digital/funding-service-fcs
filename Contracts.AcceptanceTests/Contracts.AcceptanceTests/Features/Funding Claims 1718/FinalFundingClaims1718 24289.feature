Feature: FinalFundingClaims1718 24289

@AcceptanceTest @Withdrawn20200404
@FundingClaim
Scenario: A450 Process a 1718 Final Funding Claim against an AEB-LS1718 allocation where the provider has over-delivered. Amend reconciliation then publish. Check CRM, PaaS and PM feed
    Given there is no Contract, Task or Workflow data for UKPRN '10017450' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBL-450      |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEBL-450      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017450' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017450 Co Ltd' with UKPRN '10017450' and OrgId 'ORG0017450' and has 'FCS1 Test' as a manager 
    And   UPIN '117450' is associated with UKPRN '10017450' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017450 | 117450 | 10017450 Co Ltd | 0              | Active | Yes           | AA017450      | ?             | 




    # Change the date
    Given the override date is '01/10/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017450 | 10017450 Co Ltd      | ESFA-450             | AEBP-450       | 1                     | 01/11/2017        | 31/07/2018      | 14269.00      |                                | Contract for Services | 1718   | New          | ORG0017450 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017450 | AEBP-450       | AEBL-450      | AEB-LS            | AEB-LS1718              | AY                      | 01/11/2017          | 31/07/2018        | 14269.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017450 | AEBP-450       | AEBL-450      | 1               | 0                     | 14269.00  | 1680.00  | 993.00   | 336.00   | 1324.00  | 2060.00  | 835.00   | 810.00   | 3602.00  | 2629.00  | Adult Education Budget - Learner Support                        | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-450' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-450' and actual ContractNumber 'AEBP-450'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-450' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017450 | AEBP-450           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/11/2017        | 31/07/2018      | ?             |
    | 10017450 | ESFA-450           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '9' deliverable period rows in CRM linked to the latest version of contract 'AEBP-450'

    # Check that the CRM subnominals have been created before moving on
    Then  CRM subnominals have been created for the following allocations
	| AllocationRef | Subnominal Code | Period | Payment Type   |
	| AEBL-450      | 2372075         | Jul-18 | Profile        |
	| AEBL-450      | 2372065         | Jul-18 | Reconciliation |




    # Change the date
    Given the override date is '22/09/2018'

    # Cleardown DEDs and PaaS
    And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Final         | 1718   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017450 |


    #Set up claim data from DC for a 'Final'
    And   funding claim data is present in the DEDS stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017450     | 10017450 | 1                  | Final         | AY             | 1718   | False         |

    And   allocation data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017450     | 10017450 | 1                  | Final         | AY             | 1718   | AEBL-450      | AEB-LS1718              |

    And   deliverable data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017450     | 10017450 | 1                  | Final         | AY             | 1718   | AEBL-450      | 2               | 4718.19     | 12.94         | 7.93            | 4739.06    |
    | ORG0017450     | 10017450 | 1                  | Final         | AY             | 1718   | AEBL-450      | 3               | 1628.72     | 35.29         | 16.80           | 1680.81    |
    | ORG0017450     | 10017450 | 1                  | Final         | AY             | 1718   | AEBL-450      | 4               | 3088.19     | 28.40         | 24.82           | 3141.41    |
    | ORG0017450     | 10017450 | 1                  | Final         | AY             | 1718   | AEBL-450      | 5               | 5946.47     | 24.30         | 5.08            | 5975.85    |

    When  data is retrieved from the DEDS stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017450 | 1718          | Final            | AEB-LS1718          | 1                  | 14269.00     | 15537.13     | 0.00                        | 0.00                | 15537.13         | 0.00            | 15537.13                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017450 | 1718          | Final            | AEB-LS1718          | AEBL-450      | 14269.00     | 15537.13     | 0.00                        | 0.00                | 15537.13         | 0.00            | ?                     | 15537.13                 | n/a              |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue |  
    | 10017450 | 1718          | Final            | AEB-LS1718          | AEBL-450      | AEB-LS1718           | 2               | 19+ Hardship                                           | 0.00         | 4739.06      |  
    | 10017450 | 1718          | Final            | AEB-LS1718          | AEBL-450      | AEB-LS1718           | 3               | 20+ Childcare                                          | 0.00         | 1680.81      |  
    | 10017450 | 1718          | Final            | AEB-LS1718          | AEBL-450      | AEB-LS1718           | 4               | Residential Access Fund                                | 0.00         | 3141.41      | 
    | 10017450 | 1718          | Final            | AEB-LS1718          | AEBL-450      | AEB-LS1718           | 5               | Administration Expenditure                             | 0.00         | 5975.85      |




    # Change the date 
    Given the override date is '24/09/2018'

    # Amend Proposed Reconciliation value
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017450 | 1718          | Final            | AEB-LS1718          | 1                  | AEBL-450      | 14269.00     | 15537.13     | 0.00                        | 98.54               | 15537.13         | 0.00            | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017450 | 1718          | Final            | AEB-LS1718          | 1                  | 14269.00     | 15537.13     | 0.00                        | 98.54               | 15537.13         | 0.00            | 15537.13                 | Draft      |




    # Change the date
    And   the override date is '26/09/2018'

    # Check in PerformanceManagement.ClaimReconciliationBehaviour that the publication is happening before the publication close date for the AGC
    And   the override date is before the Publication Close Date for Claim Reconciliation Code '1718-Final' and Allocation Group Code 'AEB-LS1718'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017450 | 1718          | Final            | AEB-LS1718          | 1                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017450 | 1718          | Final            | AEB-LS1718          | 1                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017450 | 1718          | Final            | AEB-LS1718          | 1                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017450 | AEBL-450         | 1718   | Final         | Adult Education Budget - Learner Support 17/18              | 14269.00     | 15537.13     | 0.00                        | 98.54                    | 15537.13           | ?               | ?                     | 15537.13                 |

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18   |
    | AEBP-450       | AEBL-450        | 1               | 98.54    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 98.54    | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18   |
    | AEBP-450       | AEBL-450        | 1               | 14367.54 | 1680.00  | 993.00   | 336.00   | 1324.00  | 2060.00  | 835.00   | 810.00   | 3602.00  | 2629.00  | 98.54    | 
	
    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | AEBL-450         | 1             | 1               | 201711 | 2              | 0             | 1680.00      | 1680.00              | 0.00                | 0.00                   | 0.00                        | 1680.00          | ?            | 0.00        |
    | AEBL-450         | 1             | 1               | 201712 | 2              | 0             | 993.00       | 993.00               | 0.00                | 0.00                   | 0.00                        | 993.00           | ?            | 0.00        |
    | AEBL-450         | 1             | 1               | 201801 | 2              | 0             | 336.00       | 336.00               | 0.00                | 0.00                   | 0.00                        | 336.00           | ?            | 0.00        |
    | AEBL-450         | 1             | 1               | 201802 | 2              | 0             | 1324.00      | 1324.00              | 0.00                | 0.00                   | 0.00                        | 1324.00          | ?            | 0.00        |
    | AEBL-450         | 1             | 1               | 201803 | 2              | 0             | 2060.00      | 2060.00              | 0.00                | 0.00                   | 0.00                        | 2060.00          | ?            | 0.00        |
    | AEBL-450         | 1             | 1               | 201804 | 2              | 0             | 835.00       | 835.00               | 0.00                | 0.00                   | 0.00                        | 835.00           | ?            | 0.00        |
    | AEBL-450         | 1             | 1               | 201805 | 2              | 0             | 810.00       | 810.00               | 0.00                | 0.00                   | 0.00                        | 810.00           | ?            | 0.00        |
    | AEBL-450         | 1             | 1               | 201806 | 2              | 0             | 3602.00      | 3602.00              | 0.00                | 0.00                   | 0.00                        | 3602.00          | ?            | 0.00        |
    | AEBL-450         | 1             | 1               | 201807 | 2              | 0             | 2629.00      | 2629.00              | 0.00                | 0.00                   | 0.00                        | 2629.00          | ?            | 0.00        |
    | AEBL-450         | 1             | 1               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 98.54                       | 98.54            | ?            | 0.00        |
	

	# Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20200404
@FundingClaim
Scenario: A451 Process a 1718 Final Funding Claim against an ALLBC1718 allocation where the provider has under-delivered. Amend reconciliation then publish. Check CRM, PaaS and PM feed
    Given there is no Contract, Task or Workflow data for UKPRN '10017451' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLC-451      |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | ALLC-451      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017451' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017451 Co Ltd' with UKPRN '10017451' and OrgId 'ORG0017451' and has 'FCS1 Test' as a manager 
    And   UPIN '117451' is associated with UKPRN '10017451' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017451 | 117451 | 10017451 Co Ltd | 0              | Active | Yes           | AA017451      | ?             | 

    # Change the date
    And   the override date is '01/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017451 | 10017451 Co Ltd      | ESFA-451             | 24Loans-451    | 1                     | 01/08/2017        | 31/07/2018      | 22027.00      |                                | Contract for Services | 1718   | New          | ORG0017451 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017451 | 24Loans-451    | ALLC-451      | 24+ ALLBC         | ALLBC1718               | AY                      | 01/08/2017          | 31/07/2018        | 22027.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017451 | 24Loans-451    | ALLC-451      | 9               | 0                     | 22027.00  | 2921.00  | 999.00   | 2081.00  | 1552.00  | 421.00   | 2832.00  | 3000.00  | 762.00   | 2793.00  | 3118.00  | 406.00   | 1142.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2017'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '24Loans-451' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2017'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-451' and actual ContractNumber '24Loans-451'

    # Check that the contract is now approved
    Then  the latest version of contract '24Loans-451' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017451 | 24Loans-451        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017451 | ESFA-451           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract '24Loans-451'

    # Change the date
    Given the override date is '22/09/2018'

    # Cleardown DEDs and PaaS
    And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Final         | 1718   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017451 |


    #Set up claim data from DC for a 'Final'
    And   funding claim data is present in the DEDS stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017451     | 10017451 | 1                  | Final         | AY             | 1718   | False         |

    And   allocation data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017451     | 10017451 | 1                  | Final         | AY             | 1718   | ALLC-451      | ALLBC1718               |

    And   deliverable data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017451     | 10017451 | 1                  | Final         | AY             | 1718   | ALLC-451      | 13              | 5148.97     | 69.08         | 19.44           | 5237.49    |
    | ORG0017451     | 10017451 | 1                  | Final         | AY             | 1718   | ALLC-451      | 14              | 1391.68     | 50.35         | 11.61           | 1453.64    |
    | ORG0017451     | 10017451 | 1                  | Final         | AY             | 1718   | ALLC-451      | 15              | 1756.27     | 62.28         | 14.91           | 1833.46    |
    | ORG0017451     | 10017451 | 1                  | Final         | AY             | 1718   | ALLC-451      | 16              | 1955.76     | 34.13         | 17.57           | 2007.46    |

    When  data is retrieved from the DEDS stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017451 | 1718          | Final            | ALLBC1718           | 1                  | 22027.00     | 10532.05     | -11494.95                   | -11494.95           | 10532.05         | 0.00            | 10532.05                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017451 | 1718          | Final            | ALLBC1718           | ALLC-451      | 22027.00     | 10532.05     | -11494.95                   | -11494.95           | 10532.05         | 0.00            | ?                     | 10532.05                 | n/a              |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017451 | 1718          | Final            | ALLBC1718           | ALLC-451      | ALLBC1718_AS_LS      | 13              | Loans - Hardship                                       | 0.00         | 5237.49      |
    | 10017451 | 1718          | Final            | ALLBC1718           | ALLC-451      | ALLBC1718_AS_LS      | 14              | Loans - Childcare                                      | 0.00         | 1453.64      |
    | 10017451 | 1718          | Final            | ALLBC1718           | ALLC-451      | ALLBC1718_AS_LS      | 15              | Loans - Residential Access Fund                        | 0.00         | 1833.46      |
    | 10017451 | 1718          | Final            | ALLBC1718           | ALLC-451      | ALLBC1718_AS_LS      | 16              | Loans - Administration Expenditure                     | 0.00         | 2007.46      |


    # Change the date 
    Given the override date is '24/09/2018'

    # Amend Proposed Reconciliation value
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017451 | 1718          | Final            | ALLBC1718           | 1                  | ALLC-451      | 22027.00     | 10532.05     | -11494.95                   | -11349.13           | 10532.05         | 0.00            | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017451 | 1718          | Final            | ALLBC1718           | 1                  | 22027.00     | 10532.05     | -11494.95                   | -11349.13           | 10532.05         | 0.00            | 10532.05                 | Draft      |


    # Change the date
    And   the override date is '26/09/2018'

    # Check in PerformanceManagement.ClaimReconciliationBehaviour that the publication is happening before the publication close date for the AGC
    And   the override date is before the Publication Close Date for Claim Reconciliation Code '1718-Final' and Allocation Group Code 'ALLBC1718'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017451 | 1718          | Final            | ALLBC1718           | 1                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017451 | 1718          | Final            | ALLBC1718           | 1                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017451 | 1718          | Final            | ALLBC1718           | 1                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017451 | ALLC-451         | 1718   | Final         | Advanced Learner Loans Bursary (College) 17/18              | 22027.00     | 10532.05     | -11494.95                   | -11349.13                | 10532.05           | ?               | ?                     | 10532.05                 |


    # Check the PROFILE PAYMENTS in CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18   |
    | 24Loans-451    | ALLC-451        | 9               | 22027.00 | 2921.00  | 999.00   | 2081.00  | 1552.00  | 421.00   | 2832.00  | 3000.00  | 762.00   | 2793.00  | 3118.00  | 406.00   | 1142.00  | 0.00     | 
    | 24Loans-451    | ALLC-451        | 10              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-451    | ALLC-451        | 11              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-451    | ALLC-451        | 12              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18   |
    | 24Loans-451    | ALLC-451        | 9               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-451    | ALLC-451        | 10              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-451    | ALLC-451        | 11              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-451    | ALLC-451        | 12              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18   |
    | 24Loans-451    | ALLC-451        | 9               | -11349.13| 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -11349.13| 
    | 24Loans-451    | ALLC-451        | 10              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-451    | ALLC-451        | 11              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-451    | ALLC-451        | 12              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18   |
    | 24Loans-451    | ALLC-451        | 9               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-451    | ALLC-451        | 10              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-451    | ALLC-451        | 11              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-451    | ALLC-451        | 12              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18   |
    | 24Loans-451    | ALLC-451        | 9               | 10677.87 | 2921.00  | 999.00   | 2081.00  | 1552.00  | 421.00   | 2832.00  | 3000.00  | 762.00   | 2793.00  | 3118.00  | 406.00   | 1142.00  | -11349.13| 
    | 24Loans-451    | ALLC-451        | 10              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-451    | ALLC-451        | 11              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 24Loans-451    | ALLC-451        | 12              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | ALLC-451         | 1             | 9               | 201708 | 2              | 0             | 2921.00      | 2921.00              | 0.00                | 0.00                   | 0.00                        | 2921.00          | ?            | 0.00        |
    | ALLC-451         | 1             | 9               | 201709 | 2              | 0             | 999.00       | 999.00               | 0.00                | 0.00                   | 0.00                        | 999.00           | ?            | 0.00        |
    | ALLC-451         | 1             | 9               | 201710 | 2              | 0             | 2081.00      | 2081.00              | 0.00                | 0.00                   | 0.00                        | 2081.00          | ?            | 0.00        |
    | ALLC-451         | 1             | 9               | 201711 | 2              | 0             | 1552.00      | 1552.00              | 0.00                | 0.00                   | 0.00                        | 1552.00          | ?            | 0.00        |
    | ALLC-451         | 1             | 9               | 201712 | 2              | 0             | 421.00       | 421.00               | 0.00                | 0.00                   | 0.00                        | 421.00           | ?            | 0.00        |
    | ALLC-451         | 1             | 9               | 201801 | 2              | 0             | 2832.00      | 2832.00              | 0.00                | 0.00                   | 0.00                        | 2832.00          | ?            | 0.00        |
    | ALLC-451         | 1             | 9               | 201802 | 2              | 0             | 3000.00      | 3000.00              | 0.00                | 0.00                   | 0.00                        | 3000.00          | ?            | 0.00        |
    | ALLC-451         | 1             | 9               | 201803 | 2              | 0             | 762.00       | 762.00               | 0.00                | 0.00                   | 0.00                        | 762.00           | ?            | 0.00        |
    | ALLC-451         | 1             | 9               | 201804 | 2              | 0             | 2793.00      | 2793.00              | 0.00                | 0.00                   | 0.00                        | 2793.00          | ?            | 0.00        |
    | ALLC-451         | 1             | 9               | 201805 | 2              | 0             | 3118.00      | 3118.00              | 0.00                | 0.00                   | 0.00                        | 3118.00          | ?            | 0.00        |
    | ALLC-451         | 1             | 9               | 201806 | 2              | 0             | 406.00       | 406.00               | 0.00                | 0.00                   | 0.00                        | 406.00           | ?            | 0.00        |
    | ALLC-451         | 1             | 9               | 201807 | 2              | 0             | 1142.00      | 1142.00              | 0.00                | 0.00                   | 0.00                        | 1142.00          | ?            | 0.00        |
    | ALLC-451         | 1             | 9               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -11349.13                   | -11349.13        | ?            | 0.00        |

    # Tidy up
    And   the override date is reset
  
@AcceptanceTest @Withdrawn20200404
@FundingClaim
Scenario: A452 Process a 1718 Final Funding Claim against a mainstream contract with AEBC1718, AEBTO-CL1718 and AEBTO-LS1718 allocations where the provider has under and over-delivered. Amend reconciliation then publish. Check CRM, PaaS and PM feed
    Given there is no Contract, Task or Workflow data for UKPRN '10017452' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEC-452       |
    | AECL-452      |
    | AELS-452      |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEC-452       |
    | AECL-452      |
    | AELS-452      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017452' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017452 Co Ltd' with UKPRN '10017452' and OrgId 'ORG0017452' and has 'FCS1 Test' as a manager 
    And   UPIN '117452' is associated with UKPRN '10017452' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017452 | 117452 | 10017452 Co Ltd | 0              | Active | Yes           | AA017452      | ?             | 

    # Change the date
    And   the override date is '01/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017452 | 10017452 Co Ltd      | ESFA-452             | MAIN-452       | 1                     | 01/08/2017        | 31/07/2018      | 68114.00      |                                | Contract for Services | 1718   | New          | ORG0017452 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017452 | MAIN-452       | AEC-452       | AEBC              | AEBC1718                | AY                      | 01/08/2017          | 31/07/2018        | 20222.00        |                         |            |                                                             | New          |             |
    | 10017452 | MAIN-452       | AECL-452      | AEBTO-CL          | AEBTO-CL1718            | AY                      | 01/08/2017          | 31/07/2018        | 27976.00        |                         |            |                                                             | New          |             |
    | 10017452 | MAIN-452       | AELS-452      | AEBTO-LS          | AEBTO-LS1718            | AY                      | 01/08/2017          | 31/07/2018        | 19916.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017452 | MAIN-452       | AEC-452       | 1               | 0                     | 20222.00  | 1731.00  | 2720.00  | 3456.00  | 2230.00  | 2206.00  | 1296.00  | 323.00   | 2260.00  | 150.00   | 1044.00  | 2063.00  | 743.00   | Adult Education Budget Total Funding                            | New          |             |
    | 10017452 | MAIN-452       | AECL-452      | 1               | 0                     | 27976.00  | 3389.00  | 2386.00  | 2677.00  | 819.00   | 3675.00  | 3493.00  | 3058.00  | 661.00   | 449.00   | 2069.00  | 3626.00  | 1674.00  | Adult Education Budget - Community Learning                     | New          |             |
    | 10017452 | MAIN-452       | AELS-452      | 1               | 0                     | 19916.00  | 3478.00  | 3201.00  | 330.00   | 558.00   | 1610.00  | 3137.00  | 3241.00  | 212.00   | 914.00   | 543.00   | 2638.00  | 54.00    | Adult Education Budget - Learner Support                        | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2017'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-452' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2017'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-452' and actual ContractNumber 'MAIN-452'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-452' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017452 | MAIN-452           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017452 | ESFA-452           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'MAIN-452'

    # Check the PROFILE PAYMENTS in CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-452       | AEC-452         | 1               | 20222.00 | 1731.00  | 2720.00  | 3456.00  | 2230.00  | 2206.00  | 1296.00  | 323.00   | 2260.00  | 150.00   | 1044.00  | 2063.00  | 743.00   | 
    | MAIN-452       | AEC-452         | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-452       | AEC-452         | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-452       | AEC-452         | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-452       | AEC-452         | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-452       | AEC-452         | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-452       | AECL-452        | 1               | 27976.00 | 3389.00  | 2386.00  | 2677.00  | 819.00   | 3675.00  | 3493.00  | 3058.00  | 661.00   | 449.00   | 2069.00  | 3626.00  | 1674.00  | 
    | MAIN-452       | AELS-452        | 1               | 19916.00 | 3478.00  | 3201.00  | 330.00   | 558.00   | 1610.00  | 3137.00  | 3241.00  | 212.00   | 914.00   | 543.00   | 2638.00  | 54.00    | 


    # Change the date
    Given the override date is '22/09/2018'

    # Cleardown DEDs and PaaS
    And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Final         | 1718   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017452 |

    # Set 'profile' values for Programme Funding
    And   the following profile values exist in config
    | ClaimReconciliationDeliverableGroupCode | UKPRN    | PlannedValue |
    | AEBC1718_CL                             | 10017452 | 2889.00      |


    #Set up claim data from DC for a 'Final'
    And   funding claim data is present in the DEDS stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017452     | 10017452 | 1                  | Final         | AY             | 1718   | False         |

    And   allocation data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017452     | 10017452 | 1                  | Final         | AY             | 1718   | AEC-452       | AEBC1718                |
    | ORG0017452     | 10017452 | 1                  | Final         | AY             | 1718   | AECL-452      | AEBTO-CL1718            |
    | ORG0017452     | 10017452 | 1                  | Final         | AY             | 1718   | AELS-452      | AEBTO-LS1718            |

    And   deliverable data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017452     | 10017452 | 1                  | Final         | AY             | 1718   | AEC-452       | 7               | 5489.00     | 16.50         | 16.66           | 5522.16    |
    | ORG0017452     | 10017452 | 1                  | Final         | AY             | 1718   | AEC-452       | 8               | 5501.38     | 50.00         | 5.04            | 5556.42    |
    | ORG0017452     | 10017452 | 1                  | Final         | AY             | 1718   | AEC-452       | 9               | 1493.38     | 23.05         | 19.91           | 1536.34    |
    | ORG0017452     | 10017452 | 1                  | Final         | AY             | 1718   | AEC-452       | 10              | 3167.07     | 55.42         | 23.30           | 3245.79    |
    | ORG0017452     | 10017452 | 1                  | Final         | AY             | 1718   | AEC-452       | 12              | 5196.39     | 18.41         | 18.41           | 5233.21    |
    #
    | ORG0017452     | 10017452 | 1                  | Final         | AY             | 1718   | AECL-452      | 3               | 5384.66     | 56.57         | 12.80           | 5454.03    |
    #
    | ORG0017452     | 10017452 | 1                  | Final         | AY             | 1718   | AELS-452      | 2               | 4548.68     | 7.12          | 17.47           | 4573.27    |
    | ORG0017452     | 10017452 | 1                  | Final         | AY             | 1718   | AELS-452      | 3               | 5957.07     | 31.71         | 23.28           | 6012.06    |
    | ORG0017452     | 10017452 | 1                  | Final         | AY             | 1718   | AELS-452      | 4               | 4162.55     | 14.15         | 16.16           | 4192.86    |
    | ORG0017452     | 10017452 | 1                  | Final         | AY             | 1718   | AELS-452      | 5               | 5244.89     | 51.21         | 21.79           | 5317.89    |

    When  data is retrieved from the DEDS stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017452 | 1718          | Final            | AEBTO-CL1718        | 1                  | 27976.00     | 5454.03      | -22521.97                   | -22521.97           | 5454.03          | 0.00            | 5454.03                  | Draft      |
    | 10017452 | 1718          | Final            | AEBTO-LS1718        | 1                  | 19916.00     | 20096.08     | 0.00                        | 0.00                | 20096.08         | 0.00            | 20096.08                 | Draft      |
    | 10017452 | 1718          | Final            | AEBC1718            | 1                  | 20222.00     | 21093.92     | -1472.29                    | -1472.29            | 18749.71         | 0.00            | 18749.71                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017452 | 1718          | Final            | AEBTO-CL1718        | AECL-452      | 27976.00     | 5454.03      | -22521.97                   | -22521.97           | 5454.03          | 0.00            | ?                     | 5454.03                  | n/a              |
    | 10017452 | 1718          | Final            | AEBTO-LS1718        | AELS-452      | 19916.00     | 20096.08     | 0.00                        | 0.00                | 20096.08         | 0.00            | ?                     | 20096.08                 | n/a              |
    | 10017452 | 1718          | Final            | AEBC1718            | AEC-452       | 20222.00     | 21093.92     | -1472.29                    | -1472.29            | 18749.71         | 0.00            | ?                     | 18749.71                 | n/a              |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017452 | 1718          | Final            | AEBC1718            | AEC-452       | AEBC1718             | 7               | Learner Support - 19+ Hardship                         | 0.00         | 5522.16      |
    | 10017452 | 1718          | Final            | AEBC1718            | AEC-452       | AEBC1718             | 8               | Learner Support - 20+ Childcare                        | 0.00         | 5556.42      |
    | 10017452 | 1718          | Final            | AEBC1718            | AEC-452       | AEBC1718             | 9               | Learner Support - Residential Access Fund              | 0.00         | 1536.34      |
    | 10017452 | 1718          | Final            | AEBC1718            | AEC-452       | AEBC1718             | 10              | Learner Support - Administration Expenditure           | 0.00         | 3245.79      |
    | 10017452 | 1718          | Final            | AEBC1718            | AEC-452       | AEBC1718             | 12              | Community Learning - Programme Funding                 | 0.00         | 5233.21      |
    #
    | 10017452 | 1718          | Final            | AEBTO-CL1718        | AECL-452      | AEBTO-CL1718         | 3               | Programme Funding                                      | 0.00         | 5454.03      |
    #
    | 10017452 | 1718          | Final            | AEBTO-LS1718        | AELS-452      | AEBTO-LS1718         | 2               | 19+ Hardship                                           | 0.00         | 4573.27      |
    | 10017452 | 1718          | Final            | AEBTO-LS1718        | AELS-452      | AEBTO-LS1718         | 3               | 20+ Childcare                                          | 0.00         | 6012.06      |
    | 10017452 | 1718          | Final            | AEBTO-LS1718        | AELS-452      | AEBTO-LS1718         | 4               | Residential Access Fund                                | 0.00         | 4192.86      |
    | 10017452 | 1718          | Final            | AEBTO-LS1718        | AELS-452      | AEBTO-LS1718         | 5               | Administration Expenditure                             | 0.00         | 5317.89      |


    # Change the date 
    Given the override date is '24/09/2018'

    # Amend Proposed Reconciliation value
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017452 | 1718          | Final            | AEBC1718            | 1                  | AEC-452       | 20222.00     | 21093.92     | -1472.29                    | -4013.19            | 18749.71         | 0.00            | ?                     |
    | 10017452 | 1718          | Final            | AEBTO-CL1718        | 1                  | AECL-452      | 27976.00     | 5454.03      | -22521.97                   | -2611.87            | 5454.03          | 0.00            | ?                     |
    | 10017452 | 1718          | Final            | AEBTO-LS1718        | 1                  | AELS-452      | 19916.00     | 20096.08     | 0.00                        | -114.97             | 20096.08         | 0.00            | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017452 | 1718          | Final            | AEBC1718            | 1                  | 20222.00     | 21093.92     | -1472.29                    | -4013.19            | 18749.71         | 0.00            | 18749.71                 | Draft      |
    | 10017452 | 1718          | Final            | AEBTO-CL1718        | 1                  | 27976.00     | 5454.03      | -22521.97                   | -2611.87            | 5454.03          | 0.00            | 5454.03                  | Draft      |
    | 10017452 | 1718          | Final            | AEBTO-LS1718        | 1                  | 19916.00     | 20096.08     | 0.00                        | -114.97             | 20096.08         | 0.00            | 20096.08                 | Draft      |


    # Change the date
    And   the override date is '26/09/2018'

    # Check in PerformanceManagement.ClaimReconciliationBehaviour that the publication is happening before the publication close date for the AGC
    And   the override date is before the Publication Close Date for Claim Reconciliation Code '1718-Final' and Allocation Group Code 'AEBC1718'
    And   the override date is before the Publication Close Date for Claim Reconciliation Code '1718-Final' and Allocation Group Code 'AEBTO-CL1718'
	And   the override date is before the Publication Close Date for Claim Reconciliation Code '1718-Final' and Allocation Group Code 'AEBTO-LS1718'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017452 | 1718          | Final            | AEBC1718            | 1                  |
    | 10017452 | 1718          | Final            | AEBTO-CL1718        | 1                  |
    | 10017452 | 1718          | Final            | AEBTO-LS1718        | 1                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017452 | 1718          | Final            | AEBC1718            | 1                  |
    | 10017452 | 1718          | Final            | AEBTO-CL1718        | 1                  |
    | 10017452 | 1718          | Final            | AEBTO-LS1718        | 1                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017452 | 1718          | Final            | AEBC1718            | 1                  |
    | 10017452 | 1718          | Final            | AEBTO-CL1718        | 1                  |
    | 10017452 | 1718          | Final            | AEBTO-LS1718        | 1                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017452 | AEC-452          | 1718   | Final         | Adult Education Budget (College) 17/18                      | 20222.00     | 21093.92     | -1472.29                    | -4013.19                 | 18749.71           | ?               | ?                     | 18749.71                 |
    | 10017452 | AECL-452         | 1718   | Final         | Adult Education Budget - Community Learning (TO) 17/18      | 27976.00     | 5454.03      | -22521.97                   | -2611.87                 | 5454.03            | ?               | ?                     | 5454.03                  |
    | 10017452 | AELS-452         | 1718   | Final         | Adult Education Budget - Learner Support (TO) 17/18         | 19916.00     | 20096.08     | 0.00                        | -114.97                  | 20096.08           | ?               | ?                     | 20096.08                 |

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18    |
    | MAIN-452       | AEC-452         | 1               | -4013.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4013.19  | 
    | MAIN-452       | AEC-452         | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AEC-452         | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AEC-452         | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AEC-452         | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AEC-452         | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AECL-452        | 1               | -2611.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2611.87  | 
    | MAIN-452       | AELS-452        | 1               | -114.97   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -114.97   | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18    |
    | MAIN-452       | AEC-452         | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AEC-452         | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AEC-452         | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AEC-452         | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AEC-452         | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AEC-452         | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AECL-452        | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AELS-452        | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18    |
    | MAIN-452       | AEC-452         | 1               | 16208.81  | 1731.00  | 2720.00  | 3456.00  | 2230.00  | 2206.00  | 1296.00  | 323.00   | 2260.00  | 150.00   | 1044.00  | 2063.00  | 743.00   | -4013.19  | 
    | MAIN-452       | AEC-452         | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AEC-452         | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AEC-452         | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AEC-452         | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AEC-452         | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | MAIN-452       | AECL-452        | 1               | 25364.13  | 3389.00  | 2386.00  | 2677.00  | 819.00   | 3675.00  | 3493.00  | 3058.00  | 661.00   | 449.00   | 2069.00  | 3626.00  | 1674.00  | -2611.87  | 
    | MAIN-452       | AELS-452        | 1               | 19801.03  | 3478.00  | 3201.00  | 330.00   | 558.00   | 1610.00  | 3137.00  | 3241.00  | 212.00   | 914.00   | 543.00   | 2638.00  | 54.00    | -114.97   | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table for Oct 2018 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | AEC-452          | 1             | 1               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -4013.19                    | -4013.19         | ?            | 0.00        |
    | AEC-452          | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | AEC-452          | 1             | 3               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | AEC-452          | 1             | 4               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | AEC-452          | 1             | 5               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | AEC-452          | 1             | 6               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | AECL-452         | 1             | 1               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -2611.87                    | -2611.87         | ?            | 0.00        |
    | AELS-452         | 1             | 1               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -114.97                     | -114.97          | ?            | 0.00        |

	# Tidy up
	And   there are no profile values in config for the following UKPRNs
    | UKPRN    |
    | 10017452 |

    And   the override date is reset
	                 
@AcceptanceTest @Complete
@FundingClaim
Scenario: A948SLD Attempt to publish a 1718 Final Funding Claim after the Publication Close Date. Check Notification 
    Given there are no allocations marked as Under Termination for UKPRN '10017948' 
    And   there are no terminated or closed allocations for UKPRN '10017948' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017948' 
    And   there are no notifications of type 'Approval Received'
    And   there are no notifications of type 'Reconciliation Publication Failed'
    And   there are no notifications of type 'Reconciliation Publish To Provider Failed'
    And   there are no notifications of type 'FCR Hold Failed'
    And   there are no notifications of type 'Held FCR Release Failed'
    And   there are no notifications of type 'FCR Allocation Update Failed'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBL-948      |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Final         | 1718   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017948 |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEBL-948      |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017948' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017948 Co Ltd' with UKPRN '10017948' and OrgId 'ORG0017948' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017948 | 117948 | 10017948 Co Ltd | 0              | Active                | Yes           | AA017948      | ?             | 49 Lyon Meade          | Stanmore               | London                 | ?                      | ?                      | ?                      | HA7 1HZ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017948 |




    # Change the date
    Given the override date is '01/10/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017948 | 10017948 Co Ltd      | ESFA-948             | AEBP-948       | 1                     | 01/11/2017        | 31/07/2018      | 14269.00      |                                | Contract for Services | 1718   | New          | ORG0017948 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017948 | AEBP-948       | AEBL-948      | AEB-LS            | AEB-LS1718              | AY                      | 01/11/2017          | 31/07/2018        | 14269.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017948 | AEBP-948       | AEBL-948      | 1               | 0                     | 14269.00  | 1680.00  | 993.00   | 336.00   | 1324.00  | 2060.00  | 835.00   | 810.00   | 3602.00  | 2629.00  | Adult Education Budget - Learner Support                        | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-948' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-948' and actual ContractNumber 'AEBP-948'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-948' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017948 | AEBP-948           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/11/2017        | 31/07/2018      | ?             |
    | 10017948 | ESFA-948           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '9' deliverable period rows in CRM linked to the latest version of contract 'AEBP-948'




    # Change the date
    Given the override date is '22/09/2018'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017948     | 10017948 | 1                  | Final         | AY             | 1718   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017948     | 10017948 | 1                  | Final         | AY             | 1718   | AEBL-948      | AEB-LS1718              |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017948     | 10017948 | 1                  | Final         | AY             | 1718   | AEBL-948      | 2               | 4718.19     | 12.94         | 7.93            | 4739.06    |
    | ORG0017948     | 10017948 | 1                  | Final         | AY             | 1718   | AEBL-948      | 3               | 1628.72     | 35.29         | 16.80           | 1680.81    |
    | ORG0017948     | 10017948 | 1                  | Final         | AY             | 1718   | AEBL-948      | 4               | 3088.19     | 28.40         | 24.82           | 3141.41    |
    | ORG0017948     | 10017948 | 1                  | Final         | AY             | 1718   | AEBL-948      | 5               | 5946.47     | 24.30         | 5.08            | 5975.85    |

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017948 | 1718          | Final            | AEB-LS1718          | 1                  | 14269.00     | 15537.13     | 0.00                        | 0.00                | 15537.13         | 0.00            | 15537.13                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017948 | 1718          | Final            | AEB-LS1718          | AEBL-948      | 14269.00     | 15537.13     | 0.00                        | 0.00                | 15537.13         | 0.00            | ?                     | 15537.13                 | n/a              |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017948 | 1718          | Final            | AEB-LS1718          | AEBL-948      | AEB-LS1718           | 2               | 19+ Hardship                                           | 0.00         | 4739.06      |
    | 10017948 | 1718          | Final            | AEB-LS1718          | AEBL-948      | AEB-LS1718           | 3               | 20+ Childcare                                          | 0.00         | 1680.81      |
    | 10017948 | 1718          | Final            | AEB-LS1718          | AEBL-948      | AEB-LS1718           | 4               | Residential Access Fund                                | 0.00         | 3141.41      |
    | 10017948 | 1718          | Final            | AEB-LS1718          | AEBL-948      | AEB-LS1718           | 5               | Administration Expenditure                             | 0.00         | 5975.85      |




    # Change the date 
    Given the override date is '01/08/2019'

    # Check in PerformanceManagement.ClaimReconciliationBehaviour that the publication is happening after the publication close date for the AGC
    Then  the override date is after the Publication Close Date for Claim Reconciliation Code '1718-Final' and Allocation Group Code 'AEB-LS1718'

    # Attempt to update the status of the draft claim to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017948 | 1718          | Final            | AEB-LS1718          | 1                  |

	# The claim should still be at Draft
    Then  the following funding claim reconciliations will have a status of 'Draft'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017948 | 1718          | Final            | AEB-LS1718          | 1                  |

	# Check that a notification has been sent to the Claim Publisher Team
	And   there is '1' notification of type 'Reconciliation Publish to Provider Failed' owned by team 'Claim Publisher Team' which matches the following
    | Status | NotificationName                                                                                   | NotificationText                                                                                                                                                                                                           |
    | New    | Reconciliation Publish Failed - 1718_Final_Adult Education Budget - Learner Support 17/18_10017948 | There was a failure to publish the funding claim reconciliation for UKPRN: 10017948. This failure was caused by funding claim reconciliation publication activity having closed for AEB-LS1718 1718-Final reconciliations. |


	# Tidy up
    And   the override date is reset

	   