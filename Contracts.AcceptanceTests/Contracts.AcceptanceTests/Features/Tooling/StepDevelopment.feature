Feature: Step Development

Scenario: Example of SLD steps to replace DEDS steps to pull funding claims from DCT SLD API
    # Cleardown FCR publications
    Given there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEBL-450      |

    # Cleardown DEDs/SLD and PaaS
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Final         | 1718   |

    #Set up claim data from DC for a 'Final'
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017450     | 10017450 | 1                  | Final         | AY             | 1718   | False         |

    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017450     | 10017450 | 1                  | Final         | AY             | 1718   | AEBL-450      | AEB-LS1718              |

    And   deliverable data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017450     | 10017450 | 1                  | Final         | AY             | 1718   | AEBL-450      | 2               | 4718.19     | 12.94         | 7.93            | 4739.06    |
    | ORG0017450     | 10017450 | 1                  | Final         | AY             | 1718   | AEBL-450      | 3               | 1628.72     | 35.29         | 16.80           | 1680.81    |
    | ORG0017450     | 10017450 | 1                  | Final         | AY             | 1718   | AEBL-450      | 4               | 3088.19     | 28.40         | 24.82           | 3141.41    |
    | ORG0017450     | 10017450 | 1                  | Final         | AY             | 1718   | AEBL-450      | 5               | 5946.47     | 24.30         | 5.08            | 5975.85    |

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed
     
