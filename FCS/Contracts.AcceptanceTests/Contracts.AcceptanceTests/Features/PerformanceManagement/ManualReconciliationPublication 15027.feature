Feature: ManualReconciliationPublication 15027

@AcceptanceTest @Withdrawn20200404
@FundingClaim
Scenario: A478 Publish a 1617 YearEnd Funding Claim Reconcilation for a claim where all its AGCs are on the publication exceptions list
    Given there isn't any FCR data in the DEDS stub
	And   there is no data in PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | YearEnd       | 1617   |


   #And   there is no data in the CRM funding claim reconciliation tables 
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    | 
    | 10017478 |

   #And   there is no Contract, Task or Workflow data for contract 'MAIN-478' and master contract 'ESFA-478'
    And   there is no Contract, Task or Workflow data for UKPRN '10017478'

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AAC-478       |
    | AEC-478       |
    | AECL-478      |
    | AELS-478      |
    | ALLC-478      |

#     For 1617 the Claim Reconciliation Exceptions table used UKPRN and FundingPeriod but this has been changed by story 21353 to 
#     UKPRN and AllocationGroupCode. Strictly this is a change for 1718 only but by making the change below A478 remains viable  
#
#     # Add exceptions to the Claim Reconciliation Exceptions table
#     And   the following details are on the PerformanceManagement.ClaimReconciliationPublicationException table
#     | FundingPeriod | UKPRN    |
#     | AY1617        | 10017478 |

    # Add exceptions to the Claim Reconciliation Exceptions table
    And   the following details are on the PerformanceManagement.ClaimReconciliationPublicationException table
    | UKPRN    | AllocationGroupCode |
    | 10017478 | AAC1617             |
    | 10017478 | AEBC1617            |
    | 10017478 | AEBTO-CL1617        |
    | 10017478 | AEBTO-LS1617        |
    | 10017478 | ALLBC1617           |


    # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017478'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017478 Co Ltd' with UKPRN '10017478' and OrgId 'ORG0017478' and has 'FCS1 Test' as a manager
    And   UPIN '117478' is associated with UKPRN '10017478' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017478 | 117478 | 10017478 Co Ltd | 0              | Active |

    # Set 'profile' values for Mental Health and Programme Funding
    And   the following profile values exist in config
    | ClaimReconciliationDeliverableGroupCode | UKPRN    | PlannedValue |
    | AEBC1617_CLMH                           | 10017478 | 4377.80      |
    | AEBC1617_CLPF                           | 10017478 | 5003.20      |
    | AEBTO-CL1617_MH                         | 10017478 | 12602.58     |
    | AEBTO-CL1617_PF                         | 10017478 | 14211.42     |

	# Change the date
	And   the override date is '13/07/2016'

    # Create contract
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017478 | 10017478 Co Ltd      | ESFA-478             | MAIN-478       | 2                     | 01/08/2016        | 31/07/2017      | 151370.00     | Contract for Services | 1617   | New          | ORG0017478 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName             | UoPCode | AllocationDescription  | CRMIntent    |
    | 10017478 | MAIN-478       | AAC-478       | AAC               | AY                      | 01/08/2016          | 31/07/2017        | 31492.00        |                     |         |                        | New          |
    | 10017478 | MAIN-478       | AEC-478       | AEBC              | AY                      | 01/08/2016          | 31/07/2017        | 31270.00        |                     |         |                        | New          |
    | 10017478 | MAIN-478       | AECL-478      | AEBTO-CL          | AY                      | 01/08/2016          | 31/07/2017        | 26814.00        |                     |         |                        | New          |
    | 10017478 | MAIN-478       | AELS-478      | AEBTO-LS          | AY                      | 01/08/2016          | 31/07/2017        | 30484.00        |                     |         |                        | New          |
    | 10017478 | MAIN-478       | ALLC-478      | 24+ ALLBC         | AY                      | 01/08/2016          | 31/07/2017        | 31310.00        |                     |         |                        | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17   | DeliverableDescription                            | CRMIntent    |
    | MAIN-478       | AAC-478       | 1               | 0                     | 31492.00 | 1441.00  | 1013.00  | 3281.00  | 2662.00  | 2757.00  | 1587.00  | 2441.00  | 3388.00  | 3408.00  | 2206.00  | 3921.00  | 3387.00  | Adult Apprenticeships Total Funding               | New          |
    | MAIN-478       | AEC-478       | 1               | 0                     | 31270.00 | 1151.00  | 3008.00  | 3275.00  | 903.00   | 2316.00  | 2217.00  | 1786.00  | 4201.00  | 3579.00  | 3217.00  | 2270.00  | 3347.00  | Adult Education Budget Total Funding              | New          |
    | MAIN-478       | AECL-478      | 1               | 0                     | 26814.00 | 1792.00  | 2062.00  | 2324.00  | 4063.00  | 1263.00  | 3046.00  | 2032.00  | 1205.00  | 1480.00  | 1114.00  | 2321.00  | 4112.00  | Adult Education Budget - Community Learning       | New          |
    | MAIN-478       | AELS-478      | 1               | 0                     | 30484.00 | 2693.00  | 2531.00  | 4159.00  | 1590.00  | 2138.00  | 2196.00  | 1807.00  | 2561.00  | 1321.00  | 2609.00  | 4133.00  | 2746.00  | Adult Education Budget - Learner Support          | New          |
    | MAIN-478       | ALLC-478      | 9               | 0                     | 31310.00 | 3942.00  | 3085.00  | 2350.00  | 3206.00  | 1069.00  | 3421.00  | 3232.00  | 2540.00  | 1378.00  | 1610.00  | 1959.00  | 3518.00  | Total Advanced Learner Loans Bursary Funding      | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

	# Change the date 
	And   the override date is '15/07/2016'

    # Publish the contract
    And   the latest version of contract 'MAIN-478' is in a state of 'Published to Provider'

	# Change the date
	And   the override date is '17/07/2016'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-478' and actual ContractNumber 'MAIN-478'

    # Check that the contract is now approved 
    Then  the latest version of contract 'MAIN-478' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017478 | MAIN-478           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2016        | 31/07/2017      | ?             |
    | 10017478 | ESFA-478           | 2                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2016        | 31/07/2017      | ?             |
   
    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '264' deliverable period rows in CRM linked to the latest version of contract 'MAIN-478'
	

	# Change the date
    Given the override date is '12/09/2017'

    # Inject claim data for a 'Year End' claim
    And   funding claim data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned | 
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | False         |

    And   allocation data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AAC-478       | AAC1617                 |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AEC-478       | AEBC1617                |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AECL-478      | AEBTO-CL1617            |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AELS-478      | AEBTO-LS1617            |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | ALLC-478      | ALLBC1617               |

    And   deliverable data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AAC-478       | 2               | 925.63      | 0.00          | 15.09           | 940.72     |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AAC-478       | 3               | 1492.96     | 14.43         | 0.00            | 1507.39    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AAC-478       | 4               | 2118.83     | 0.00          | 22.82           | 2141.65    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AAC-478       | 5               | 2801.12     | 0.00          | 0.00            | 2801.11    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AAC-478       | 6               | 3038.96     | 0.00          | 0.00            | 3038.96    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AAC-478       | 7               | 3640.94     | 22.45         | 0.00            | 3663.38    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AAC-478       | 8               | 4376.67     | 0.00          | 0.00            | 4376.67    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AAC-478       | 9               | 4655.16     | 20.67         | 11.64           | 4687.47    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AAC-478       | 10              | 5347.25     | 0.00          | 16.28           | 5363.52    |
    #
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AEC-478       | 2               | 649.76      | 0.00          | 0.00            | 649.75     |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AEC-478       | 3               | 974.64      | 0.00          | 0.00            | 974.63     |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AEC-478       | 4               | 1299.53     | 0.00          | 0.00            | 1299.52    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AEC-478       | 5               | 1624.41     | 0.00          | 0.00            | 1624.41    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AEC-478       | 6               | 1949.29     | 0.00          | 0.00            | 1949.28    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AEC-478       | 7               | 2274.18     | 0.00          | 23.67           | 2297.84    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AEC-478       | 8               | 2599.06     | 21.79         | 0.00            | 2620.84    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AEC-478       | 9               | 2923.94     | 24.79         | 0.00            | 2948.73    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AEC-478       | 10              | 3248.83     | 0.00          | 5.32            | 3254.15    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AEC-478       | 11              | 3573.71     | 0.00          | 7.19            | 3580.90    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AEC-478       | 12              | 3898.59     | 0.00          | 0.00            | 3898.59    |
    #
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AECL-478      | 2               | 10725.60    | 0.00          | 0.00            | 10725.60   |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AECL-478      | 3               | 10725.60    | 0.00          | 0.00            | 10725.60   |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AELS-478      | 2               | 4119.79     | 0.00          | 0.00            | 4119.78    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AELS-478      | 3               | 5973.28     | 13.18         | 18.18           | 6004.64    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AELS-478      | 4               | 7978.48     | 17.90         | 0.00            | 7996.37    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | AELS-478      | 5               | 9914.35     | 0.00          | 14.13           | 9928.47    |
    #
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | ALLC-478      | 10              | 3314.21     | 0.00          | 22.80           | 3337.01    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | ALLC-478      | 11              | 3401.49     | 0.00          | 0.00            | 3401.48    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | ALLC-478      | 12              | 3722.91     | 20.22         | 0.00            | 3743.12    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | ALLC-478      | 13              | 4153.91     | 0.00          | 0.00            | 4153.90    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | ALLC-478      | 14              | 4539.61     | 6.86          | 0.00            | 4546.46    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | ALLC-478      | 15              | 4716.96     | 0.00          | 0.00            | 4716.96    |
    | ORG0017478     | 10017478 | 4                  | Year End      | AY             | 1617   | ALLC-478      | 16              | 5137.84     | 0.00          | 0.00            | 5137.84    |

    When  data is retrieved from the DEDS stub and is consumed 

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017478 | 1617          | Year End         | AAC1617             | 4                  | 31492.00     | 28520.87     | -2971.13                    | -2971.13            | 28520.87         | 0.00            | 28520.87                 | Draft      |
    | 10017478 | 1617          | Year End         | AEBC1617            | 4                  | 31270.00     | 25098.64     | -6171.36                    | -6171.36            | 25098.64         | 0.00            | 25098.64                 | Draft      |
    | 10017478 | 1617          | Year End         | AEBTO-CL1617        | 4                  | 26814.00     | 21451.20     | -5362.80                    | -5362.80            | 21451.20         | 0.00            | 21451.20                 | Draft      |
    | 10017478 | 1617          | Year End         | AEBTO-LS1617        | 4                  | 30484.00     | 28049.26     | -2434.74                    | -2434.74            | 28049.26         | 0.00            | 28049.26                 | Draft      |
    | 10017478 | 1617          | Year End         | ALLBC1617           | 4                  | 31310.00     | 29036.77     | -2273.23                    | -2273.23            | 29036.77         | 0.00            | 29036.77                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017478 | 1617          | Year End         | AAC1617             | AAC-478       | 31492.00     | 28520.87     | -2971.13                    | -2971.13            | 28520.87         | 0.00            | ?                     | 28520.87                 | n/a              |
    | 10017478 | 1617          | Year End         | AEBC1617            | AEC-478       | 31270.00     | 25098.64     | -6171.36                    | -6171.36            | 25098.64         | 0.00            | ?                     | 25098.64                 | 938.10           |
    | 10017478 | 1617          | Year End         | AEBTO-CL1617        | AECL-478      | 26814.00     | 21451.20     | -5362.80                    | -5362.80            | 21451.20         | 0.00            | ?                     | 21451.20                 | n/a              |
    | 10017478 | 1617          | Year End         | AEBTO-LS1617        | AELS-478      | 30484.00     | 28049.26     | -2434.74                    | -2434.74            | 28049.26         | 0.00            | ?                     | 28049.26                 | n/a              |
    | 10017478 | 1617          | Year End         | ALLBC1617           | ALLC-478      | 31310.00     | 29036.77     | -2273.23                    | -2273.23            | 29036.77         | 0.00            | ?                     | 29036.77                 | n/a              |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017478 | 1617          | Year End         | AAC1617             | AAC-478       | AAC1617              | 2               | 19-23 Apprenticeships Programme Funding                | 0.00         | 940.72       |
    | 10017478 | 1617          | Year End         | AAC1617             | AAC-478       | AAC1617              | 3               | 19-23 Apprenticeships Learning Support                 | 0.00         | 1507.39      |
    | 10017478 | 1617          | Year End         | AAC1617             | AAC-478       | AAC1617              | 4               | 19+ Apprenticeships Learner Support                    | 0.00         | 2141.65      |
    | 10017478 | 1617          | Year End         | AAC1617             | AAC-478       | AAC1617              | 5               | 24+ Apprenticeships Programme Funding                  | 0.00         | 2801.11      |
    | 10017478 | 1617          | Year End         | AAC1617             | AAC-478       | AAC1617              | 6               | 24+ Apprenticeships Learning Support                   | 0.00         | 3038.96      |
    | 10017478 | 1617          | Year End         | AAC1617             | AAC-478       | AAC1617              | 7               | 19-23 Trailblazer Apprenticeships Programme Funding    | 0.00         | 3663.38      |
    | 10017478 | 1617          | Year End         | AAC1617             | AAC-478       | AAC1617              | 8               | 19-23 Trailblazer Apprenticeships Learning Support     | 0.00         | 4376.67      |
    | 10017478 | 1617          | Year End         | AAC1617             | AAC-478       | AAC1617              | 9               | 24+ Trailblazer Apprenticeships Programme Funding      | 0.00         | 4687.47      |
    | 10017478 | 1617          | Year End         | AAC1617             | AAC-478       | AAC1617              | 10              | 24+ Trailblazer Apprenticeships Learning Support       | 0.00         | 5363.52      |
    #
    | 10017478 | 1617          | Year End         | AEBC1617            | AEC-478       | AEBC1617_OTHER       | 2               | 19-24 Traineeships Programme Funding                   | 0.00         | 649.75       |
    | 10017478 | 1617          | Year End         | AEBC1617            | AEC-478       | AEBC1617_OTHER       | 3               | 19-24 Traineeships Learning Support                    | 0.00         | 974.63       |
    | 10017478 | 1617          | Year End         | AEBC1617            | AEC-478       | AEBC1617_OTHER       | 4               | 19-24 Traineeships Learner Support                     | 0.00         | 1299.52      |
    | 10017478 | 1617          | Year End         | AEBC1617            | AEC-478       | AEBC1617_OTHER       | 5               | Other Learning Programme Funding                       | 0.00         | 1624.41      |
    | 10017478 | 1617          | Year End         | AEBC1617            | AEC-478       | AEBC1617_OTHER       | 6               | Other Learning - Learning Support                      | 0.00         | 1949.28      |
    | 10017478 | 1617          | Year End         | AEBC1617            | AEC-478       | AEBC1617_OTHER       | 7               | Learner Support - 19+ Hardship                         | 0.00         | 2297.84      |
    | 10017478 | 1617          | Year End         | AEBC1617            | AEC-478       | AEBC1617_OTHER       | 8               | Learner Support - 20+ Childcare                        | 0.00         | 2620.84      |
    | 10017478 | 1617          | Year End         | AEBC1617            | AEC-478       | AEBC1617_OTHER       | 9               | Learner Support - Residential Access Fund              | 0.00         | 2948.73      |
    | 10017478 | 1617          | Year End         | AEBC1617            | AEC-478       | AEBC1617_OTHER       | 10              | Learner Support - Administration Expenditure           | 0.00         | 3254.15      |
    | 10017478 | 1617          | Year End         | AEBC1617            | AEC-478       | AEBC1617_CLMH        | 11              | CL - Mental Health Research Project                    | 0.00         | 3580.90      |
    | 10017478 | 1617          | Year End         | AEBC1617            | AEC-478       | AEBC1617_CLPF        | 12              | CL - Programme Funding                                 | 0.00         | 3898.59      |
    #
    | 10017478 | 1617          | Year End         | AEBTO-CL1617        | AECL-478      | AEBTO-CL1617_MH      | 2               | Mental Health Research Project                         | 0.00         | 10725.60     |
    | 10017478 | 1617          | Year End         | AEBTO-CL1617        | AECL-478      | AEBTO-CL1617_PF      | 3               | Programme Funding                                      | 0.00         | 10725.60     |
    | 10017478 | 1617          | Year End         | AEBTO-LS1617        | AELS-478      | AEBTO-LS1617         | 2               | 19+ Hardship                                           | 0.00         | 4119.78      |
    | 10017478 | 1617          | Year End         | AEBTO-LS1617        | AELS-478      | AEBTO-LS1617         | 3               | 20+ Childcare                                          | 0.00         | 6004.64      |
    | 10017478 | 1617          | Year End         | AEBTO-LS1617        | AELS-478      | AEBTO-LS1617         | 4               | Residential Access Fund                                | 0.00         | 7996.37      |
    | 10017478 | 1617          | Year End         | AEBTO-LS1617        | AELS-478      | AEBTO-LS1617         | 5               | Administration Expenditure                             | 0.00         | 9928.47      |
    #
    | 10017478 | 1617          | Year End         | ALLBC1617           | ALLC-478      | ALLBC1617            | 10              | Loans - Bursary Funding                                | 0.00         | 3337.01      |
    | 10017478 | 1617          | Year End         | ALLBC1617           | ALLC-478      | ALLBC1617            | 11              | Loans - Area Costs                                     | 0.00         | 3401.48      |
    | 10017478 | 1617          | Year End         | ALLBC1617           | ALLC-478      | ALLBC1617            | 12              | Loans - Excess Claims                                  | 0.00         | 3743.12      |
    | 10017478 | 1617          | Year End         | ALLBC1617           | ALLC-478      | ALLBC1617            | 13              | Loans - Hardship                                       | 0.00         | 4153.90      |
    | 10017478 | 1617          | Year End         | ALLBC1617           | ALLC-478      | ALLBC1617            | 14              | Loans - Childcare                                      | 0.00         | 4546.46      |
    | 10017478 | 1617          | Year End         | ALLBC1617           | ALLC-478      | ALLBC1617            | 15              | Loans - Residential Access Fund                        | 0.00         | 4716.96      |
    | 10017478 | 1617          | Year End         | ALLBC1617           | ALLC-478      | ALLBC1617            | 16              | Loans - Administration Expenditure                     | 0.00         | 5137.84      |

    # Amend Proposed Reconciliation value
    And   the override date is '16/09/2017'
    When  the reconciliation values on the CRM funding claim allocations are amended as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | 
    | 10017478 | 1617          | Year End         | AAC1617             | 4                  | AAC-478       | 31492.00     | 28520.87     | -2971.13                    | -2526.05            | 28520.87         | 0.00            | ?                     | 
    | 10017478 | 1617          | Year End         | AEBC1617            | 4                  | AEC-478       | 31270.00     | 25098.64     | -6171.36                    | -5686.71            | 25098.64         | 0.00            | ?                     | 
    | 10017478 | 1617          | Year End         | AEBTO-CL1617        | 4                  | AECL-478      | 26814.00     | 21451.20     | -5362.80                    | -5271.36            | 21451.20         | 0.00            | ?                     | 
    | 10017478 | 1617          | Year End         | AEBTO-LS1617        | 4                  | AELS-478      | 30484.00     | 28049.26     | -2434.74                    | -2402.75            | 28049.26         | 0.00            | ?                     | 
    | 10017478 | 1617          | Year End         | ALLBC1617           | 4                  | ALLC-478      | 31310.00     | 29036.77     | -2273.23                    | -2158.16            | 29036.77         | 0.00            | ?                     | 

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017478 | 1617          | Year End         | AAC1617             | 4                  | 31492.00     | 28520.87     | -2971.13                    | -2526.05            | 28520.87         | 0.00            | 28520.87                 | Draft      |
    | 10017478 | 1617          | Year End         | AEBC1617            | 4                  | 31270.00     | 25098.64     | -6171.36                    | -5686.71            | 25098.64         | 0.00            | 25098.64                 | Draft      |
    | 10017478 | 1617          | Year End         | AEBTO-CL1617        | 4                  | 26814.00     | 21451.20     | -5362.80                    | -5271.36            | 21451.20         | 0.00            | 21451.20                 | Draft      |
    | 10017478 | 1617          | Year End         | AEBTO-LS1617        | 4                  | 30484.00     | 28049.26     | -2434.74                    | -2402.75            | 28049.26         | 0.00            | 28049.26                 | Draft      |
    | 10017478 | 1617          | Year End         | ALLBC1617           | 4                  | 31310.00     | 29036.77     | -2273.23                    | -2158.16            | 29036.77         | 0.00            | 29036.77                 | Draft      |


    # Change the date
    Given the override date is '12/10/2017'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017478 | 1617          | Year End         | AAC1617             | 4                  |
    | 10017478 | 1617          | Year End         | AEBC1617            | 4                  |
    | 10017478 | 1617          | Year End         | AEBTO-CL1617        | 4                  |
    | 10017478 | 1617          | Year End         | AEBTO-LS1617        | 4                  |
    | 10017478 | 1617          | Year End         | ALLBC1617           | 4                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Manually Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017478 | 1617          | Year End         | AAC1617             | 4                  |
    | 10017478 | 1617          | Year End         | AEBC1617            | 4                  |
    | 10017478 | 1617          | Year End         | AEBTO-CL1617        | 4                  |
    | 10017478 | 1617          | Year End         | AEBTO-LS1617        | 4                  |
    | 10017478 | 1617          | Year End         | ALLBC1617           | 4                  |

    # Atom feed should not contain claim reconciliation publication events for the following
    And   the PerformanceManagement.AtomFeed does not contain events with ItemType '0' for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017478 | 1617          | Year End         | AAC1617             | 4                  |
    | 10017478 | 1617          | Year End         | AEBC1617            | 4                  |
    | 10017478 | 1617          | Year End         | AEBTO-CL1617        | 4                  |
    | 10017478 | 1617          | Year End         | AEBTO-LS1617        | 4                  |
    | 10017478 | 1617          | Year End         | ALLBC1617           | 4                  |

    # Check the deliverable count in CRM has not changed
    And   there are '264' deliverable period rows in CRM linked to the latest version of contract 'MAIN-478'

    # Tidy up
	And   there are no profile values in config for the following UKPRNs
    | UKPRN    |
    | 10017478 |
    And   the override date is reset 

@AcceptanceTest @Withdrawn20211005
@FundingClaim
@Long2Run @Long2Run45
Scenario: A479SLD Publish a 1718 Final Funding Claim Reconcilation for a claim where just one of its AGCs is on the publication exceptions list
    Given there are no allocations marked as Under Termination for UKPRN '10017479' 
    And   there are no terminated or closed allocations for UKPRN '10017479' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017479' 
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
    | AEC-479       |
    | AECL-479      |
    | AELS-479      |

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
    | 10017479 |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEC-479       |
    | AECL-479      |
    | AELS-479      |

    # Add exceptions to the Claim Reconciliation Exceptions table
    Given the following details are on the PerformanceManagement.ClaimReconciliationPublicationException table
    | UKPRN    | AllocationGroupCode |
    | 10017479 | AEBC1718            |

    # Set 'profile' values for Programme Funding
    And   the following profile values exist in config
    | ClaimReconciliationDeliverableGroupCode | UKPRN    | PlannedValue |
    | AEBC1718_CL                             | 10017479 | 3142.00      |




    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017479' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017479 Co Ltd' with UKPRN '10017479' and OrgId 'ORG0017479' and has 'FCS1 Test' as a manager 
    And   UPIN '117479' is associated with UKPRN '10017479' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017479 | 117479 | 10017479 Co Ltd | 0              | Active | Yes           | AA017479      | ?             | 




    # Change the date
    And   the override date is '01/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017479 | 10017479 Co Ltd      | ESFA-479             | MAIN-479       | 1                     | 01/08/2017        | 31/07/2018      | 82107.00      |                                | Contract for Services | 1718   | New          | ORG0017479 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017479 | MAIN-479       | AEC-479       | AEBC              | AEBC1718                | AY                      | 01/08/2017          | 31/07/2018        | 21992.00        |                                         |            |                                                             | New          |             |
    | 10017479 | MAIN-479       | AECL-479      | AEBTO-CL          | AEBTO-CL1718            | AY                      | 01/08/2017          | 31/07/2018        | 28521.00        |                                         |            |                                                             | New          |             |
    | 10017479 | MAIN-479       | AELS-479      | AEBTO-LS          | AEBTO-LS1718            | AY                      | 01/08/2017          | 31/07/2018        | 31594.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017479 | MAIN-479       | AEC-479       | 1               | 0                     | 21992.00  | 645.00   | 1633.00  | 2370.00  | 1144.00  | 1120.00  | 210.00   | 2938.00  | 1174.00  | 2765.00  | 3659.00  | 976.00   | 3358.00  | Adult Education Budget Total Funding                            | New          |             |
    | 10017479 | MAIN-479       | AECL-479      | 1               | 0                     | 28521.00  | 3434.00  | 2431.00  | 2723.00  | 865.00   | 3721.00  | 3538.00  | 3103.00  | 707.00   | 494.00   | 2115.00  | 3671.00  | 1719.00  | Adult Education Budget - Community Learning                     | New          |             |
    | 10017479 | MAIN-479       | AELS-479      | 1               | 0                     | 31594.00  | 2601.00  | 2324.00  | 3154.00  | 3382.00  | 733.00   | 2260.00  | 2363.00  | 3035.00  | 3737.00  | 3367.00  | 1761.00  | 2877.00  | Adult Education Budget - Learner Support                        | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2017'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-479' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2017'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-479' and actual ContractNumber 'MAIN-479'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-479' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017479 | MAIN-479           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017479 | ESFA-479           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'MAIN-479'




    # Populate stub with Claim data

    # Change the date
    Given the override date is '02/10/2018'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017479     | 10017479 | 1                  | Final         | AY             | 1718   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017479     | 10017479 | 1                  | Final         | AY             | 1718   | AEC-479       | AEBC1718                |
    | ORG0017479     | 10017479 | 1                  | Final         | AY             | 1718   | AECL-479      | AEBTO-CL1718            |
    | ORG0017479     | 10017479 | 1                  | Final         | AY             | 1718   | AELS-479      | AEBTO-LS1718            |

    #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017479     | 10017479 | 1                  | Final         | AY             | 1718   | AEC-479       | 7               | 5431.97     | 10.03         | 9.70            | 5451.70    |
    | ORG0017479     | 10017479 | 1                  | Final         | AY             | 1718   | AEC-479       | 8               | 5072.64     | 23.40         | 5.35            | 5101.39    |
    | ORG0017479     | 10017479 | 1                  | Final         | AY             | 1718   | AEC-479       | 9               | 3225.65     | 15.01         | 14.30           | 3254.96    |
    | ORG0017479     | 10017479 | 1                  | Final         | AY             | 1718   | AEC-479       | 10              | 1677.05     | 71.28         | 7.20            | 1755.53    |
    | ORG0017479     | 10017479 | 1                  | Final         | AY             | 1718   | AEC-479       | 12              | 4083.20     | 54.19         | 15.24           | 4152.63    |
    #
    | ORG0017479     | 10017479 | 1                  | Final         | AY             | 1718   | AECL-479      | 3               | 1972.03     | 9.32          | 10.79           | 1992.14    |
    #
    | ORG0017479     | 10017479 | 1                  | Final         | AY             | 1718   | AELS-479      | 2               | 2845.89     | 66.49         | 14.08           | 2926.46    |
    | ORG0017479     | 10017479 | 1                  | Final         | AY             | 1718   | AELS-479      | 3               | 2713.62     | 47.70         | 7.07            | 2768.39    |
    | ORG0017479     | 10017479 | 1                  | Final         | AY             | 1718   | AELS-479      | 4               | 3141.64     | 46.24         | 16.15           | 3204.03    |
    | ORG0017479     | 10017479 | 1                  | Final         | AY             | 1718   | AELS-479      | 5               | 4590.56     | 33.63         | 14.35           | 4638.54    |

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017479 | 1718          | Final            | AEBC1718            | 1                  | 21992.00     | 19716.21     | -3286.42                    | -3286.42            | 18705.58         | 0.00            | 18705.58                 | Draft      |
    | 10017479 | 1718          | Final            | AEBTO-CL1718        | 1                  | 28521.00     | 1992.14      | -26528.86                   | -26528.86           | 1992.14          | 0.00            | 1992.14                  | Draft      |
    | 10017479 | 1718          | Final            | AEBTO-LS1718        | 1                  | 31594.00     | 13537.42     | -18056.58                   | -18056.58           | 13537.42         | 0.00            | 13537.42                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017479 | 1718          | Final            | AEBC1718            | AEC-479       | 21992.00     | 19716.21     | -3286.42                    | -3286.42            | 18705.58         | 0.00            | ?                     | 18705.58                 | n/a              |
    | 10017479 | 1718          | Final            | AEBTO-CL1718        | AECL-479      | 28521.00     | 1992.14      | -26528.86                   | -26528.86           | 1992.14          | 0.00            | ?                     | 1992.14                  | n/a              |
    | 10017479 | 1718          | Final            | AEBTO-LS1718        | AELS-479      | 31594.00     | 13537.42     | -18056.58                   | -18056.58           | 13537.42         | 0.00            | ?                     | 13537.42                 | n/a              |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017479 | 1718          | Final            | AEBC1718            | AEC-479       | AEBC1718             | 7               | Learner Support - 19+ Hardship                         | 0.00         | 5451.70      |
    | 10017479 | 1718          | Final            | AEBC1718            | AEC-479       | AEBC1718             | 8               | Learner Support - 20+ Childcare                        | 0.00         | 5101.39      |
    | 10017479 | 1718          | Final            | AEBC1718            | AEC-479       | AEBC1718             | 9               | Learner Support - Residential Access Fund              | 0.00         | 3254.96      |
    | 10017479 | 1718          | Final            | AEBC1718            | AEC-479       | AEBC1718             | 10              | Learner Support - Administration Expenditure           | 0.00         | 1755.53      |
    | 10017479 | 1718          | Final            | AEBC1718            | AEC-479       | AEBC1718             | 12              | Community Learning - Programme Funding                 | 0.00         | 4152.63      |
    #
    | 10017479 | 1718          | Final            | AEBTO-CL1718        | AECL-479      | AEBTO-CL1718         | 3               | Programme Funding                                      | 0.00         | 1992.14      |
    #
    | 10017479 | 1718          | Final            | AEBTO-LS1718        | AELS-479      | AEBTO-LS1718         | 2               | 19+ Hardship                                           | 0.00         | 2926.46      |
    | 10017479 | 1718          | Final            | AEBTO-LS1718        | AELS-479      | AEBTO-LS1718         | 3               | 20+ Childcare                                          | 0.00         | 2768.39      |
    | 10017479 | 1718          | Final            | AEBTO-LS1718        | AELS-479      | AEBTO-LS1718         | 4               | Residential Access Fund                                | 0.00         | 3204.03      |
    | 10017479 | 1718          | Final            | AEBTO-LS1718        | AELS-479      | AEBTO-LS1718         | 5               | Administration Expenditure                             | 0.00         | 4638.54      |


    # Change the date 
    Given the override date is '08/10/2018'

    # Amend Proposed Reconciliation value
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | 
    | 10017479 | 1718          | Final            | AEBC1718            | 1                  | AEC-479       | 21992.00     | 19716.21     | -3286.42                    | -2092.93            | 18705.58         | 0.00            | ?                     | 
    | 10017479 | 1718          | Final            | AEBTO-CL1718        | 1                  | AECL-479      | 28521.00     | 1992.14      | -26528.86                   | -26456.89           | 1992.14          | 0.00            | ?                     | 
    | 10017479 | 1718          | Final            | AEBTO-LS1718        | 1                  | AELS-479      | 31594.00     | 13537.42     | -18056.58                   | -18107.14           | 13537.42         | 0.00            | ?                     | 

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017479 | 1718          | Final            | AEBC1718            | 1                  | 21992.00     | 19716.21     | -3286.42                    | -2092.93            | 18705.58         | 0.00            | 18705.58                 | Draft      |
    | 10017479 | 1718          | Final            | AEBTO-CL1718        | 1                  | 28521.00     | 1992.14      | -26528.86                   | -26456.89           | 1992.14          | 0.00            | 1992.14                  | Draft      |
    | 10017479 | 1718          | Final            | AEBTO-LS1718        | 1                  | 31594.00     | 13537.42     | -18056.58                   | -18107.14           | 13537.42         | 0.00            | 13537.42                 | Draft      |


    # Change the date 
    And  the override date is '12/10/2018'

    # Check the current date against the Publication Close Date for the AGC
    And   the override date is before the Publication Close Date for Claim Reconciliation Code '1718-Final' and Allocation Group Code 'AEBC1718'
    And   the override date is before the Publication Close Date for Claim Reconciliation Code '1718-Final' and Allocation Group Code 'AEBTO-CL1718'
    And   the override date is before the Publication Close Date for Claim Reconciliation Code '1718-Final' and Allocation Group Code 'AEBTO-LS1718'


    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017479 | 1718          | Final            | AEBC1718            | 1                  |
    | 10017479 | 1718          | Final            | AEBTO-CL1718        | 1                  |
    | 10017479 | 1718          | Final            | AEBTO-LS1718        | 1                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
   #| 10017479 | 1718          | Final            | AEBC1718            | 1                  |
    | 10017479 | 1718          | Final            | AEBTO-CL1718        | 1                  |
    | 10017479 | 1718          | Final            | AEBTO-LS1718        | 1                  |

   #And   the following funding claim reconciliations will have a status of 'Published'
    And   the following funding claim reconciliations will have a status 'Published' and a sub status 'Manually Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017479 | 1718          | Final            | AEBC1718            | 1                  |
   #| 10017479 | 1718          | Final            | AEBTO-CL1718        | 1                  |
   #| 10017479 | 1718          | Final            | AEBTO-LS1718        | 1                  |


    # Check that the Atom feed only has events for AGCs which are NOT on the exceptions list
    And   the PerformanceManagement.AtomFeed does not contain events with ItemType '0' for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017479 | 1718          | Final            | AEBC1718            | 1                  |

    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
   #| 10017479 | 1718          | Final            | AEBC1718            | 1                  |
    | 10017479 | 1718          | Final            | AEBTO-CL1718        | 1                  |
    | 10017479 | 1718          | Final            | AEBTO-LS1718        | 1                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
   #| 10017479 | AEC-479          | 1718   | Final         | Adult Education Budget (College) 17/18                      | 21992.00     | 19716.21     | -2275.79                    | -2092.93                 | 18705.58           | ?               | ?                     | 18705.58                 |
    | 10017479 | AECL-479         | 1718   | Final         | Adult Education Budget - Community Learning (TO) 17/18      | 28521.00     | 1992.14      | -26528.86                   | -26456.89                | 1992.14            | ?               | ?                     | 1992.14                  |
    | 10017479 | AELS-479         | 1718   | Final         | Adult Education Budget - Learner Support (TO) 17/18         | 31594.00     | 13537.42     | -18056.58                   | -18107.14                | 13537.42           | ?               | ?                     | 13537.42                 |

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | AECL-479         | 1             | 1               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -26456.89                   | -26456.89        | ?            | 0.00        |
    | AELS-479         | 1             | 1               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -18107.14                   | -18107.14        | ?            | 0.00        |

    # Check the deliverable count in CRM has increased by just two periods
    And   there are '98' deliverable period rows in CRM linked to the latest version of contract 'MAIN-479'


    # Tidy up
	And   there are no profile values in config for the following UKPRNs
    | UKPRN    |
    | 10017479 |
    
	And   the override date is reset

@AcceptanceTest @Withdrawn20200717
@Long2Run @Long2Run67
Scenario: A600 Process a Final 1718 Funding Claim against an AEB contract with AEB-LS1718 (PoP) and AEB-TOL1718 (PoA) allocations. Amend and approve contract. Check PoP is not recalculated
    Given there is no Contract, Task or Workflow data for UKPRN '10017600' 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBL-600      |
    | AEBT-600      |

    # Cleardown DEDs and PaaS
    And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Final         | 1718   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017600 |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEBL-600      |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017600' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017600 Co Ltd' with UKPRN '10017600' and OrgId 'ORG0017600' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017600' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017600 | 117600 | 10017600 Co Ltd | 0              | Provider Under Change | Yes           | AA017600      | ?             | 4 St John's Court      | Moulsham Street        | ?                      | ?                      | Chelmsford             | Essex                  | CM2 0JD   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017600 |




    # Change the date
    Given the override date is '01/10/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017600 | 10017600 Co Ltd      | ESFA-600             | AEBP-600       | 1                     | 01/11/2017        | 31/07/2018      | 28311.00      |                                | Contract for Services | 1718   | New          | ORG0017600 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName   | UoPCode    | AllocationDescription   | CRMIntent    | DeliveryOrg |
    | 10017600 | AEBP-600       | AEBL-600      | AEB-LS            | AEB-LS1718              | AY                      | 01/11/2017          | 31/07/2018        | 13312.00        |           |            |                         | New          |             |
    | 10017600 | AEBP-600       | AEBT-600      | AEB-TOL           | AEB-TOL1718             | AY                      | 01/11/2017          | 31/07/2018        | 14999.00        |           |            |                         | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017600 | AEBP-600       | AEBL-600      | 1               | 0                     | 13312.00  | 977.00   | 320.00   | 1308.00  | 2045.00  | 819.00   | 795.00   | 3586.00  | 2613.00  | 849.00   | Adult Education Budget - Learner Support                        | New          |             |
    | 10017600 | AEBP-600       | AEBT-600      | 1               | 0                     | 14999.00  | 3593.00  | 786.00   | 1805.00  | 485.00   | 1725.00  | 722.00   | 1014.00  | 2857.00  | 2012.00  | Adult Education - Traineeships and Other Learning Total Funding | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-600' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-600' and actual ContractNumber 'AEBP-600'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-600' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017600 | AEBP-600           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/11/2017        | 31/07/2018      | ?             |
    | 10017600 | ESFA-600           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '63' deliverable period rows in CRM linked to the latest version of contract 'AEBP-600'



    # Change the date
    Given the override date is '22/09/2018'

    #Set up claim data from DC for a 'Final'
    And   funding claim data is present in the DEDS stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017600     | 10017600 | 1                  | Final         | AY             | 1718   | False         |

    And   allocation data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017600     | 10017600 | 1                  | Final         | AY             | 1718   | AEBL-600      | AEB-LS1718              |

    And   deliverable data is present in the DEDS stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017600     | 10017600 | 1                  | Final         | AY             | 1718   | AEBL-600      | 2               | 3706.47     | 72.76         | 20.08           | 3799.31    |
    | ORG0017600     | 10017600 | 1                  | Final         | AY             | 1718   | AEBL-600      | 3               | 5120.14     | 73.30         | 11.94           | 5205.38    |
    | ORG0017600     | 10017600 | 1                  | Final         | AY             | 1718   | AEBL-600      | 4               | 843.79      | 11.19         | 11.26           | 866.24     |
    | ORG0017600     | 10017600 | 1                  | Final         | AY             | 1718   | AEBL-600      | 5               | 2155.55     | 54.47         | 23.36           | 2233.38    |

    When  data is retrieved from the DEDS stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017600 | 1718          | Final            | AEB-LS1718          | 1                  | 13312.00     | 12104.31     | -1207.69                    | -1207.69            | 12104.31         | 0.00            | 12104.31                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017600 | 1718          | Final            | AEB-LS1718          | AEBL-600      | 13312.00     | 12104.31     | -1207.69                    | -1207.69            | 12104.31         | 0.00            | ?                     | 12104.31                 | n/a              |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017600 | 1718          | Final            | AEB-LS1718          | AEBL-600      | AEB-LS1718           | 2               | 19+ Hardship                                           | 0.00         | 3799.31      |
    | 10017600 | 1718          | Final            | AEB-LS1718          | AEBL-600      | AEB-LS1718           | 3               | 20+ Childcare                                          | 0.00         | 5205.38      |
    | 10017600 | 1718          | Final            | AEB-LS1718          | AEBL-600      | AEB-LS1718           | 4               | Residential Access Fund                                | 0.00         | 866.24       |
    | 10017600 | 1718          | Final            | AEB-LS1718          | AEBL-600      | AEB-LS1718           | 5               | Administration Expenditure                             | 0.00         | 2233.38      |




    # Change the date
    Given the override date is '26/09/2018'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017600 | 1718          | Final            | AEB-LS1718          | 1                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017600 | 1718          | Final            | AEB-LS1718          | 1                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017600 | 1718          | Final            | AEB-LS1718          | 1                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |  
    | 10017600 | AEBL-600         | 1718   | Final         | Adult Education Budget - Learner Support 17/18              | 13312.00     | 12104.31     | -1207.69                    | -1207.69                 | 12104.31           | ?               | ?                     | 12104.31                 |

	# Check that the deliverable period count has increased from 63 to 64 (extra period for AEBL-600 for Oct 18)
    And   there are '64' deliverable period rows in CRM linked to the latest version of contract 'AEBP-600'

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | AEBP-600       | AEBT-600        | 1               | 14999.00 | 3593.00  | 786.00   | 1805.00  | 485.00   | 1725.00  | 722.00   | 1014.00  | 2857.00  | 2012.00  | 

    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18   |
    | AEBP-600       | AEBL-600        | 1               | 13312.00 | 977.00   | 320.00   | 1308.00  | 2045.00  | 819.00   | 795.00   | 3586.00  | 2613.00  | 849.00   | ?        | 

	# Check the PROFILE PAYMENTS in CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18   |
    | AEBP-600       | AEBL-600        | 1               | 13312.00 | 977.00   | 320.00   | 1308.00  | 2045.00  | 819.00   | 795.00   | 3586.00  | 2613.00  | 849.00   | 0.00     | 

	# Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18   |
    | AEBP-600       | AEBL-600        | 1               | -1207.69 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1207.69 | 

	# Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18   |
    | AEBP-600       | AEBL-600        | 1               | 12104.31 | 977.00   | 320.00   | 1308.00  | 2045.00  | 819.00   | 795.00   | 3586.00  | 2613.00  | 849.00   | -1207.69 | 




	# Change the date
	Given the override date is '28/09/2018'

	# Bulk import to amend the financials on both allocations in contract
    And   there are no files prefixed '10017600_AEBP' in the Sharepoint 'AEB-1718-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1718 28082018144214 v2_A600' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1718 28082018144214 v2_A600' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1718 28082018144214 v2_A600.xlsx' exists in the Datafiles folder and UKPRN '10017600' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-600' is in a state of 'Published to Provider'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017600 | AEBP-600           | 2                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/11/2017        | 31/07/2018      | Variation     |
    | 10017600 | AEBP-600           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/11/2017        | 31/07/2018      | ?             |
    | 10017600 | ESFA-600           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2017        | 31/07/2018      | ?             |




    # Change the date
    Given the override date is '29/09/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-600' and actual ContractNumber 'AEBP-600'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017600 | AEBP-600           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/11/2017        | 31/07/2018      | Variation     |
    | 10017600 | AEBP-600           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/11/2017        | 31/07/2018      | ?             |
    | 10017600 | ESFA-600           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2017        | 31/07/2018      | ?             |

	# Check that the deliverable period count has increased from 64 to 70 (extra periods are for AEBT-600 for Nov 18)
    And   there are '70' deliverable period rows in CRM linked to the latest version of contract 'AEBP-600'

	# Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Nov-18   |
    | AEBP-600       | AEBT-600        | 1               | 23629.00 | 4050.00  | 4441.00  | 1955.00  | 824.00   | 580.00   | 4949.00  | 1744.00  | 1459.00  | 3627.00  | ?        | 
    | AEBP-600       | AEBT-600        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | AEBP-600       | AEBT-600        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | AEBP-600       | AEBT-600        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | AEBP-600       | AEBT-600        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | AEBP-600       | AEBT-600        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 

    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18   |
    | AEBP-600       | AEBL-600        | 1               | 23770.00 | 1047.00  | 4782.00  | 3480.00  | 1120.00  | 3248.00  | 4445.00  | 856.00   | 4042.00  | 750.00   | 0.00     | 

   # Check the PROFILE PAYMENTS in CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18   |
    | AEBP-600       | AEBL-600        | 1               | 13312.00 | 977.00   | 320.00   | 1308.00  | 2045.00  | 819.00   | 795.00   | 3586.00  | 2613.00  | 849.00   | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18   |
    | AEBP-600       | AEBL-600        | 1               | -1207.69 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1207.69 | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Oct-18   |
    | AEBP-600       | AEBL-600        | 1               | 12104.31 | 977.00   | 320.00   | 1308.00  | 2045.00  | 819.00   | 795.00   | 3586.00  | 2613.00  | 849.00   | -1207.69 | 
	

    # Tidy up
     And   the override date is reset 

