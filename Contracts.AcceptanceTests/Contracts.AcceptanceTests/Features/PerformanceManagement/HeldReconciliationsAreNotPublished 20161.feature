Feature: HeldReconciliationsAreNotPublished 20161

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run67
@FundingClaim
Scenario: A788SLD Attempt to publish 1617 Final Funding Claim Reconciliations that are on hold. Release hold then publish
    Given there are no allocations marked as Under Termination for UKPRN '10017788' 
    And   there are no terminated or closed allocations for UKPRN '10017788' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017788' 
    And   there are no notifications of type 'Approval Received'
    And   there are no notifications of type 'Reconciliation Publication Failed'
    And   there are no notifications of type 'FCR Hold Failed'
    And   there are no notifications of type 'Held FCR Release Failed'
    And   there are no notifications of type 'FCR Allocation Update Failed'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1617   | 
    | Final         | 1617   |

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AAC-788       |
    | AEC-788       |
    | AECL-788      |
    | AELS-788      |
    | ALLC-788      |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AAC-788       |
    | AEC-788       |
    | AECL-788      |
    | AELS-788      |
    | ALLC-788      |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables 
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    | 
    | 10017788 |




    # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017788'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017788 Co Ltd' with UKPRN '10017788' and OrgId 'ORG0017788' and has 'FCS1 Test' as a manager
    And   UPIN '117788' is associated with UKPRN '10017788' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017788 | 117788 | 10017788 Co Ltd | 0              | Active |

    # Set 'profile' values for Mental Health and Programme Funding
    And   the following profile values exist in config
    | ClaimReconciliationDeliverableGroupCode | UKPRN    | PlannedValue |
    | AEBC1617_CLMH                           | 10017788 | 3567.06      |
    | AEBC1617_CLPF                           | 10017788 | 4076.64      |
    | AEBTO-CL1617_MH                         | 10017788 | 12526.44     |
    | AEBTO-CL1617_PF                         | 10017788 | 14125.56     |

    # Create contract
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017788 | 10017788 Co Ltd      | ESFA-788             | MAIN-788       | 1                     | 01/08/2016        | 31/07/2017      | 108606.00     |                                | Contract for Services | 1617   | New          | ORG0017788 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName             | UoPCode | AllocationDescription  | CRMIntent    | DeliveryOrg |
    | 10017788 | MAIN-788       | AAC-788       | AAC               | AAC1617                 | AY                      | 01/08/2016          | 31/07/2017        | 31463.00        |                     |         |                        | New          |             |
    | 10017788 | MAIN-788       | AEC-788       | AEBC              | AEBC1617                | AY                      | 01/08/2016          | 31/07/2017        | 25479.00        |                     |         |                        | New          |             |
    | 10017788 | MAIN-788       | AECL-788      | AEBTO-CL          | AEBTO-CL1617            | AY                      | 01/08/2016          | 31/07/2017        | 26652.00        |                     |         |                        | New          |             |
    | 10017788 | MAIN-788       | AELS-788      | AEBTO-LS          | AEBTO-LS1617            | AY                      | 01/08/2016          | 31/07/2017        | 25012.00        |                     |         |                        | New          |             |

   And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17   | DeliverableDescription                            | CRMIntent    | DeliveryOrg |
    | 10017788 | MAIN-788       | AAC-788       | 1               | 0                     | 31463.00 | 2529.00  | 2545.00  | 1302.00  | 4146.00  | 1454.00  | 2855.00  | 3168.00  | 1222.00  | 3063.00  | 3360.00  | 3502.00  | 2317.00  | Adult Apprenticeships Total Funding               | New          |             |
    | 10017788 | MAIN-788       | AEC-788       | 1               | 0                     | 25479.00 | 1131.00  | 2549.00  | 2804.00  | 1052.00  | 2252.00  | 1252.00  | 1346.00  | 1919.00  | 4219.00  | 2905.00  | 1785.00  | 2265.00  | Adult Education Budget Total Funding              | New          |             |
    | 10017788 | MAIN-788       | AECL-788      | 1               | 0                     | 26652.00 | 2448.00  | 1064.00  | 2408.00  | 2337.00  | 4064.00  | 1778.00  | 1440.00  | 2571.00  | 2018.00  | 2594.00  | 2198.00  | 1732.00  | Adult Education Budget - Community Learning       | New          |             |
    | 10017788 | MAIN-788       | AELS-788      | 1               | 0                     | 25012.00 | 1078.00  | 3030.00  | 2090.00  | 2708.00  | 3848.00  | 2288.00  | 2871.00  | 2145.00  | 1044.00  | 1222.00  | 1346.00  | 1342.00  | Adult Education Budget - Learner Support          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract 'MAIN-788' is in a state of 'Published to Provider'

    # Change the date
	And   the override date is '13/07/2016'

	# Month end is not running
	And   the PaaS MonthEndIsRunning indicator is set to 'False'

	# Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-788' and actual ContractNumber 'MAIN-788'

    # Check that the contract is now approved 
    Then  the latest version of contract 'MAIN-788' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017788 | MAIN-788           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2016        | 31/07/2017      | ?             |
    | 10017788 | ESFA-788           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2016        | 31/07/2017      | ?             |


    # Check that the deliverable count in CRM has increased to reflect the addition of monitoring deliverables 
    #Then  there are '216' deliverable period rows in CRM linked to the latest version of contract 'MAIN-788'
    Then  there are '120' deliverable periods in CRM linked to the latest version of contract 'MAIN-788' and allocation 'AAC-788'
    And   there are '72' deliverable periods in CRM linked to the latest version of contract 'MAIN-788' and allocation 'AEC-788'
    And   there are '12' deliverable periods in CRM linked to the latest version of contract 'MAIN-788' and allocation 'AECL-788'
    And   there are '12' deliverable periods in CRM linked to the latest version of contract 'MAIN-788' and allocation 'AELS-788'

    # Check that the Deliverable Payment table has been updated before processing the claim
    And   the PaymentSchedule.DeliverablePayment table contains the following values
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | AECL-788         | 1             | 1               | 201608 | 2              | 0             | 2448.00      | 2448.00              | 0.00                | 0.00                   | 0.00                        | 2448.00          | ?            | ?           |




    # Populate stub with Claim data

	# Change the date
	Given the override date is '12/09/2017'

	# Inject claim data for a 'Final' claim
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned | 
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AAC-788       | AAC1617                 |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AEC-788       | AEBC1617                |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AECL-788      | AEBTO-CL1617            |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AELS-788      | AEBTO-LS1617            |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AAC-788       | 2               | 1004.30     | 0.00          | 0.00            | 1004.29    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AAC-788       | 3               | 1739.26     | 0.00          | 9.80            | 1749.05    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AAC-788       | 4               | 1979.50     | 5.73          | 0.00            | 1985.23    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AAC-788       | 5               | 2786.98     | 11.64         | 0.00            | 2798.61    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AAC-788       | 6               | 3397.99     | 0.00          | 0.00            | 3397.98    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AAC-788       | 7               | 3874.93     | 0.00          | 0.00            | 3874.92    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AAC-788       | 8               | 4437.61     | 0.00          | 17.29           | 4454.89    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AAC-788       | 9               | 4767.45     | 12.42         | 0.00            | 4779.86    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AAC-788       | 10              | 5256.79     | 22.87         | 0.00            | 5279.65    |
    #
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AEC-788       | 2               | 529.43      | 17.43         | 20.13           | 566.98     |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AEC-788       | 3               | 794.15      | 0.00          | 0.00            | 794.14     |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AEC-788       | 4               | 1058.86     | 8.06          | 13.56           | 1080.47    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AEC-788       | 5               | 1323.58     | 0.00          | 0.00            | 1323.57    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AEC-788       | 6               | 1588.30     | 0.00          | 24.69           | 1612.99    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AEC-788       | 7               | 1853.01     | 0.00          | 0.00            | 1853.00    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AEC-788       | 8               | 2117.73     | 7.40          | 0.00            | 2125.13    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AEC-788       | 9               | 2382.45     | 0.00          | 8.38            | 2390.82    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AEC-788       | 10              | 2647.16     | 18.05         | 0.00            | 2665.21    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AEC-788       | 11              | 2911.88     | 0.00          | 14.81           | 2926.69    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AEC-788       | 12              | 3176.60     | 0.00          | 0.00            | 3176.59    |
    #
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AECL-788      | 2               | 10660.80    | 0.00          | 9.19            | 10669.98   |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AECL-788      | 3               | 10660.80    | 13.90         | 0.00            | 10674.69   |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AELS-788      | 2               | 3209.10     | 22.07         | 0.00            | 3231.17    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AELS-788      | 3               | 4874.73     | 22.18         | 0.00            | 4896.90    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AELS-788      | 4               | 6609.79     | 0.00          | 10.17           | 6619.96    |
    | ORG0017788     | 10017788 | 1                  | Final         | AY             | 1617   | AELS-788      | 5               | 8040.73     | 0.00          | 0.00            | 8040.72    |

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017788 | 1617          | Final            | AAC1617             | 1                  | 31463.00     | 29324.48     | -2138.52                    | -2138.52            | 29324.48         | 0.00            | 29324.48                 | Draft      |
    | 10017788 | 1617          | Final            | AEBC1617            | 1                  | 25479.00     | 20515.59     | -4963.41                    | -4963.41            | 20515.59         | 0.00            | 20515.59                 | Draft      |
    | 10017788 | 1617          | Final            | AEBTO-CL1617        | 1                  | 26652.00     | 21344.67     | -5307.33                    | -5307.33            | 21344.67         | 0.00            | 21344.67                 | Draft      |
    | 10017788 | 1617          | Final            | AEBTO-LS1617        | 1                  | 25012.00     | 22788.75     | -2223.25                    | -2223.25            | 22788.75         | 0.00            | 22788.75                 | Draft      |
 
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017788 | 1617          | Final            | AAC1617             | AAC-788       | 31463.00     | 29324.48     | -2138.52                    | -2138.52            | 29324.48         | 0.00            | ?                     | 29324.48                 | n/a              |
    | 10017788 | 1617          | Final            | AEBC1617            | AEC-788       | 25479.00     | 20515.59     | -4963.41                    | -4963.41            | 20515.59         | 0.00            | ?                     | 20515.59                 | 764.37           |
    | 10017788 | 1617          | Final            | AEBTO-CL1617        | AECL-788      | 26652.00     | 21344.67     | -5307.33                    | -5307.33            | 21344.67         | 0.00            | ?                     | 21344.67                 | n/a              |
    | 10017788 | 1617          | Final            | AEBTO-LS1617        | AELS-788      | 25012.00     | 22788.75     | -2223.25                    | -2223.25            | 22788.75         | 0.00            | ?                     | 22788.75                 | n/a              |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017788 | 1617          | Final            | AAC1617             | AAC-788       | AAC1617              | 2               | 19-23 Apprenticeships Programme Funding                | 0.00         | 1004.29      |
    | 10017788 | 1617          | Final            | AAC1617             | AAC-788       | AAC1617              | 3               | 19-23 Apprenticeships Learning Support                 | 0.00         | 1749.05      |
    | 10017788 | 1617          | Final            | AAC1617             | AAC-788       | AAC1617              | 4               | 19+ Apprenticeships Learner Support                    | 0.00         | 1985.23      |
    | 10017788 | 1617          | Final            | AAC1617             | AAC-788       | AAC1617              | 5               | 24+ Apprenticeships Programme Funding                  | 0.00         | 2798.61      |
    | 10017788 | 1617          | Final            | AAC1617             | AAC-788       | AAC1617              | 6               | 24+ Apprenticeships Learning Support                   | 0.00         | 3397.98      |
    | 10017788 | 1617          | Final            | AAC1617             | AAC-788       | AAC1617              | 7               | 19-23 Trailblazer Apprenticeships Programme Funding    | 0.00         | 3874.92      |
    | 10017788 | 1617          | Final            | AAC1617             | AAC-788       | AAC1617              | 8               | 19-23 Trailblazer Apprenticeships Learning Support     | 0.00         | 4454.89      |
    | 10017788 | 1617          | Final            | AAC1617             | AAC-788       | AAC1617              | 9               | 24+ Trailblazer Apprenticeships Programme Funding      | 0.00         | 4779.86      |
    | 10017788 | 1617          | Final            | AAC1617             | AAC-788       | AAC1617              | 10              | 24+ Trailblazer Apprenticeships Learning Support       | 0.00         | 5279.65      |
	#
    | 10017788 | 1617          | Final            | AEBC1617            | AEC-788       | AEBC1617_OTHER       | 2               | 19-24 Traineeships Programme Funding                   | 0.00         | 566.98       |
    | 10017788 | 1617          | Final            | AEBC1617            | AEC-788       | AEBC1617_OTHER       | 3               | 19-24 Traineeships Learning Support                    | 0.00         | 794.14       |
    | 10017788 | 1617          | Final            | AEBC1617            | AEC-788       | AEBC1617_OTHER       | 4               | 19-24 Traineeships Learner Support                     | 0.00         | 1080.47      |
    | 10017788 | 1617          | Final            | AEBC1617            | AEC-788       | AEBC1617_OTHER       | 5               | Other Learning Programme Funding                       | 0.00         | 1323.57      |
    | 10017788 | 1617          | Final            | AEBC1617            | AEC-788       | AEBC1617_OTHER       | 6               | Other Learning - Learning Support                      | 0.00         | 1612.99      |
    | 10017788 | 1617          | Final            | AEBC1617            | AEC-788       | AEBC1617_OTHER       | 7               | Learner Support - 19+ Hardship                         | 0.00         | 1853.00      |
    | 10017788 | 1617          | Final            | AEBC1617            | AEC-788       | AEBC1617_OTHER       | 8               | Learner Support - 20+ Childcare                        | 0.00         | 2125.13      |
    | 10017788 | 1617          | Final            | AEBC1617            | AEC-788       | AEBC1617_OTHER       | 9               | Learner Support - Residential Access Fund              | 0.00         | 2390.82      |
    | 10017788 | 1617          | Final            | AEBC1617            | AEC-788       | AEBC1617_OTHER       | 10              | Learner Support - Administration Expenditure           | 0.00         | 2665.21      |
    | 10017788 | 1617          | Final            | AEBC1617            | AEC-788       | AEBC1617_CLMH        | 11              | CL - Mental Health Research Project                    | 0.00         | 2926.69      |
    | 10017788 | 1617          | Final            | AEBC1617            | AEC-788       | AEBC1617_CLPF        | 12              | CL - Programme Funding                                 | 0.00         | 3176.59      |
    #
    | 10017788 | 1617          | Final            | AEBTO-CL1617        | AECL-788      | AEBTO-CL1617_MH      | 2               | Mental Health Research Project                         | 0.00         | 10669.98     |
    | 10017788 | 1617          | Final            | AEBTO-CL1617        | AECL-788      | AEBTO-CL1617_PF      | 3               | Programme Funding                                      | 0.00         | 10674.69     |
    | 10017788 | 1617          | Final            | AEBTO-LS1617        | AELS-788      | AEBTO-LS1617         | 2               | 19+ Hardship                                           | 0.00         | 3231.17      |
    | 10017788 | 1617          | Final            | AEBTO-LS1617        | AELS-788      | AEBTO-LS1617         | 3               | 20+ Childcare                                          | 0.00         | 4896.90      |
    | 10017788 | 1617          | Final            | AEBTO-LS1617        | AELS-788      | AEBTO-LS1617         | 4               | Residential Access Fund                                | 0.00         | 6619.96      |
    | 10017788 | 1617          | Final            | AEBTO-LS1617        | AELS-788      | AEBTO-LS1617         | 5               | Administration Expenditure                             | 0.00         | 8040.72      |

	# Change the date
	And   the override date is '16/09/2017'    
	
	# Amend Proposed Reconciliation value
    When  the reconciliation values on the CRM funding claim allocations are amended as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |  
    | 10017788 | 1617          | Final            | AAC1617             | 1                  | AAC-788       | 31463.00     | 29324.48     | -2138.52                    | -2008.73            | 29324.48         | 0.00            | ?                     | 
    | 10017788 | 1617          | Final            | AEBC1617            | 1                  | AEC-788       | 25479.00     | 20515.59     | -4963.41                    | -4776.50            | 20515.59         | 0.00            | ?                     | 
    | 10017788 | 1617          | Final            | AEBTO-CL1617        | 1                  | AECL-788      | 26652.00     | 21344.67     | -5307.33                    | -5029.39            | 21344.67         | 0.00            | ?                     | 
    | 10017788 | 1617          | Final            | AEBTO-LS1617        | 1                  | AELS-788      | 25012.00     | 22788.75     | -2223.25                    | -2318.08            | 22788.75         | 0.00            | ?                     | 

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017788 | 1617          | Final            | AAC1617             | 1                  | 31463.00     | 29324.48     | -2138.52                    | -2008.73            | 29324.48         | 0.00            | 29324.48                 | Draft      |
    | 10017788 | 1617          | Final            | AEBC1617            | 1                  | 25479.00     | 20515.59     | -4963.41                    | -4776.50            | 20515.59         | 0.00            | 20515.59                 | Draft      |
    | 10017788 | 1617          | Final            | AEBTO-CL1617        | 1                  | 26652.00     | 21344.67     | -5307.33                    | -5029.39            | 21344.67         | 0.00            | 21344.67                 | Draft      |
    | 10017788 | 1617          | Final            | AEBTO-LS1617        | 1                  | 25012.00     | 22788.75     | -2223.25                    | -2318.08            | 22788.75         | 0.00            | 22788.75                 | Draft      |

    # Put selected Funding Claim Reconciliations on hold
    Given the following funding claim reconciliations have been put on hold
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017788 | 1617          | Final            | AAC1617             | 1                  |
    | 10017788 | 1617          | Final            | AEBC1617            | 1                  |
   #| 10017788 | 1617          | Final            | AEBTO-CL1617        | 1                  |
   #| 10017788 | 1617          | Final            | AEBTO-LS1617        | 1                  |

	# Change the date
	And   the override date is '12/10/2017'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017788 | 1617          | Final            | AAC1617             | 1                  |
    | 10017788 | 1617          | Final            | AEBC1617            | 1                  |
    | 10017788 | 1617          | Final            | AEBTO-CL1617        | 1                  |
    | 10017788 | 1617          | Final            | AEBTO-LS1617        | 1                  |

    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
   #| 10017788 | 1617          | Final            | AAC1617             | 1                  |
   #| 10017788 | 1617          | Final            | AEBC1617            | 1                  |
    | 10017788 | 1617          | Final            | AEBTO-CL1617        | 1                  |
    | 10017788 | 1617          | Final            | AEBTO-LS1617        | 1                  |

    And   the following funding claim reconciliations will have a status 'Draft' and a sub status 'Held'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017788 | 1617          | Final            | AAC1617             | 1                  |
    | 10017788 | 1617          | Final            | AEBC1617            | 1                  |
   #| 10017788 | 1617          | Final            | AEBTO-CL1617        | 1                  |
   #| 10017788 | 1617          | Final            | AEBTO-LS1617        | 1                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication events
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
   #| 10017788 | 1617          | Final            | AAC1617             | 1                  |
   #| 10017788 | 1617          | Final            | AEBC1617            | 1                  |
    | 10017788 | 1617          | Final            | AEBTO-CL1617        | 1                  |
    | 10017788 | 1617          | Final            | AEBTO-LS1617        | 1                  |

    And   the PerformanceManagement.AtomFeed does not contain events with ItemType '0' for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017788 | 1617          | Final            | AAC1617             | 1                  |
    | 10017788 | 1617          | Final            | AEBC1617            | 1                  |
   #| 10017788 | 1617          | Final            | AEBTO-CL1617        | 1                  |
   #| 10017788 | 1617          | Final            | AEBTO-LS1617        | 1                  |

    # Put the Draft\Held Funding Claim Reconciliations back to Draft\Draft
    Given the following funding claim reconciliations have been taken off hold
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017788 | 1617          | Final            | AAC1617             | 1                  |
    | 10017788 | 1617          | Final            | AEBC1617            | 1                  |

    # Change the date
	And   the override date is '14/10/2017'
	
	# Update the previously held Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017788 | 1617          | Final            | AAC1617             | 1                  |
    | 10017788 | 1617          | Final            | AEBC1617            | 1                  |

    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017788 | 1617          | Final            | AAC1617             | 1                  |
    | 10017788 | 1617          | Final            | AEBC1617            | 1                  |
    | 10017788 | 1617          | Final            | AEBTO-CL1617        | 1                  |
    | 10017788 | 1617          | Final            | AEBTO-LS1617        | 1                  |
 
    # Use Atom feed to inform downstream systems of claim reconciliation publication events
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017788 | 1617          | Final            | AAC1617             | 1                  |
    | 10017788 | 1617          | Final            | AEBC1617            | 1                  |
    | 10017788 | 1617          | Final            | AEBTO-CL1617        | 1                  |
    | 10017788 | 1617          | Final            | AEBTO-LS1617        | 1                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                    | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |  
    | 10017788 | AAC-788          | 1617   | Final         | Adult Apprenticeships (College) 16/17                  | 31463.00     | 29324.48     | -2138.52                    | -2008.73                 | 29324.48           | ?               | ?                     | 29324.48                 |
    | 10017788 | AEC-788          | 1617   | Final         | Adult Education Budget (College) 16/17                 | 25479.00     | 20515.59     | -4963.41                    | -4776.50                 | 20515.59           | ?               | ?                     | 20515.59                 |
    | 10017788 | AECL-788         | 1617   | Final         | Adult Education Budget - Community Learning (TO) 16/17 | 26652.00     | 21344.67     | -5307.33                    | -5029.39                 | 21344.67           | ?               | ?                     | 21344.67                 |
    | 10017788 | AELS-788         | 1617   | Final         | Adult Education Budget - Learner Support (TO) 16/17    | 25012.00     | 22788.75     | -2223.25                    | -2318.08                 | 22788.75           | ?               | ?                     | 22788.75                 |

	# Check the data in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-17   |
    | MAIN-788       | AAC-788         | 1               | -2008.73 | -2008.73 | 
    | MAIN-788       | AEC-788         | 1               | -4776.50 | -4776.50 | 
    | MAIN-788       | AECL-788        | 1               | -5029.39 | -5029.39 | 
    | MAIN-788       | AELS-788        | 1               | -2318.08 | -2318.08 | 

    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-17   |
    | MAIN-788       | AAC-788         | 1               | -2008.73 | -2008.73 | 
    | MAIN-788       | AEC-788         | 1               | -4776.50 | -4776.50 | 
    | MAIN-788       | AECL-788        | 1               | -5029.39 | -5029.39 | 
    | MAIN-788       | AELS-788        | 1               | -2318.08 | -2318.08 | 

#    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
#    And   the PaymentSchedule.DeliverablePayment table contains the following values 
#    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
#    | AAC-788          | 1             | 1               | 201711 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -2008.73                    | -2008.73         | ?            | 0.00        |
#    | AEC-788          | 1             | 1               | 201711 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -4776.50                    | -4776.50         | ?            | 0.00        |
#    | AECL-788         | 1             | 1               | 201711 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -5029.39                    | -5029.39         | ?            | 0.00        |
#    | AELS-788         | 1             | 1               | 201711 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -2318.08                    | -2318.08         | ?            | 0.00        |



    # Tidy up
	And   the override date is reset

	And   there are no profile values in config for the following UKPRNs
    | UKPRN    |
    | 10017788 |
  
