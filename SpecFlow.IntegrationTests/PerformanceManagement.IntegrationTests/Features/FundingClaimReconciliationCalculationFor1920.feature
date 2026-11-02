Feature: FundingClaimReconciliationCalculationFor1920

@DoNotRun_7Mar2024
@FundingClaimCalculation
Scenario: D561 Final Funding Claim Reconciliation Calculations for AEBC-ASCL1920

    # 1 Variance = £0
    # 2 Under-delivery - Variance within Tolerance
    # 3 Under-delivery - Variance = Tolerance
    # 4 Under-delivery - Variance exceeds Tolerance
    # 5 Under-delivery - Delivers nothing
    # 6 Over-delivery  - Variance within Limit
    # 7 Over-delivery  - Variance = Limit
    # 8 Over-delivery  - Variance exceeds Limit

    Given there are no Allocations in PaaS (Performance Management)

    And   the following debatched funding claims are received
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationGroupCode |
    | 10192001 | 1            | FINAL         | AY         | 1920   | AEBC-ASCL1920       |
    | 10192002 | 1            | FINAL         | AY         | 1920   | AEBC-ASCL1920       |
    | 10192003 | 1            | FINAL         | AY         | 1920   | AEBC-ASCL1920       |
    | 10192004 | 1            | FINAL         | AY         | 1920   | AEBC-ASCL1920       |
    | 10192005 | 1            | FINAL         | AY         | 1920   | AEBC-ASCL1920       |
    | 10192006 | 1            | FINAL         | AY         | 1920   | AEBC-ASCL1920       |
    | 10192007 | 1            | FINAL         | AY         | 1920   | AEBC-ASCL1920       |
    | 10192008 | 1            | FINAL         | AY         | 1920   | AEBC-ASCL1920       |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10192001 | 1            | FINAL         | AY         | 1920   | AECA-2001     | AEBC-ASCL1920       | AEBC-ASCL1920           | 10000.00        |
    | 10192002 | 1            | FINAL         | AY         | 1920   | AECA-2002     | AEBC-ASCL1920       | AEBC-ASCL1920           | 10000.00        |
    | 10192003 | 1            | FINAL         | AY         | 1920   | AECA-2003     | AEBC-ASCL1920       | AEBC-ASCL1920           | 10000.00        |
    | 10192004 | 1            | FINAL         | AY         | 1920   | AECA-2004     | AEBC-ASCL1920       | AEBC-ASCL1920           | 10000.00        |
    | 10192005 | 1            | FINAL         | AY         | 1920   | AECA-2005     | AEBC-ASCL1920       | AEBC-ASCL1920           | 10000.00        |
    | 10192006 | 1            | FINAL         | AY         | 1920   | AECA-2006     | AEBC-ASCL1920       | AEBC-ASCL1920           | 10000.00        |
    | 10192007 | 1            | FINAL         | AY         | 1920   | AECA-2007     | AEBC-ASCL1920       | AEBC-ASCL1920           | 10000.00        |
    | 10192008 | 1            | FINAL         | AY         | 1920   | AECA-2008     | AEBC-ASCL1920       | AEBC-ASCL1920           | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10192001 | 1            | FINAL         | AY         | 1920   | AECA-2001     | AEBC-ASCL1920           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192001 | 1            | FINAL         | AY         | 1920   | AECA-2001     | AEBC-ASCL1920           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 800.00       | 10000.00           |
    | 10192001 | 1            | FINAL         | AY         | 1920   | AECA-2001     | AEBC-ASCL1920           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10192001 | 1            | FINAL         | AY         | 1920   | AECA-2001     | AEBC-ASCL1920           | 3               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 9200.00            |
    | 10192001 | 1            | FINAL         | AY         | 1920   | AECA-2001     | AEBC-ASCL1920           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192001 | 1            | FINAL         | AY         | 1920   | AECA-2001     | AEBC-ASCL1920           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192001 | 1            | FINAL         | AY         | 1920   | AECA-2001     | AEBC-ASCL1920           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192001 | 1            | FINAL         | AY         | 1920   | AECA-2001     | AEBC-ASCL1920           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192001 | 1            | FINAL         | AY         | 1920   | AECA-2001     | AEBC-ASCL1920           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£10000.00    
    | 10192002 | 1            | FINAL         | AY         | 1920   | AECA-2002     | AEBC-ASCL1920           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192002 | 1            | FINAL         | AY         | 1920   | AECA-2002     | AEBC-ASCL1920           | 5               | 800.00      | 0.00          | 0.00            | 800.00            | 800.00       | 10000.00           |
    | 10192002 | 1            | FINAL         | AY         | 1920   | AECA-2002     | AEBC-ASCL1920           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10192002 | 1            | FINAL         | AY         | 1920   | AECA-2002     | AEBC-ASCL1920           | 3               | 6001.00     | 0.00          | 0.00            | 6001.00           | 0.00         | 9200.00            |
    | 10192002 | 1            | FINAL         | AY         | 1920   | AECA-2002     | AEBC-ASCL1920           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192002 | 1            | FINAL         | AY         | 1920   | AECA-2002     | AEBC-ASCL1920           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192002 | 1            | FINAL         | AY         | 1920   | AECA-2002     | AEBC-ASCL1920           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192002 | 1            | FINAL         | AY         | 1920   | AECA-2002     | AEBC-ASCL1920           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192002 | 1            | FINAL         | AY         | 1920   | AECA-2002     | AEBC-ASCL1920           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£6801.00     
    | 10192003 | 1            | FINAL         | AY         | 1920   | AECA-2003     | AEBC-ASCL1920           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192003 | 1            | FINAL         | AY         | 1920   | AECA-2003     | AEBC-ASCL1920           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 800.00       | 10000.00           |
    | 10192003 | 1            | FINAL         | AY         | 1920   | AECA-2003     | AEBC-ASCL1920           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10192003 | 1            | FINAL         | AY         | 1920   | AECA-2003     | AEBC-ASCL1920           | 3               | 6800.00     | 0.00          | 0.00            | 6800.00           | 0.00         | 9200.00            |
    | 10192003 | 1            | FINAL         | AY         | 1920   | AECA-2003     | AEBC-ASCL1920           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192003 | 1            | FINAL         | AY         | 1920   | AECA-2003     | AEBC-ASCL1920           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192003 | 1            | FINAL         | AY         | 1920   | AECA-2003     | AEBC-ASCL1920           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192003 | 1            | FINAL         | AY         | 1920   | AECA-2003     | AEBC-ASCL1920           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192003 | 1            | FINAL         | AY         | 1920   | AECA-2003     | AEBC-ASCL1920           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£6800.00     
    | 10192004 | 1            | FINAL         | AY         | 1920   | AECA-2004     | AEBC-ASCL1920           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192004 | 1            | FINAL         | AY         | 1920   | AECA-2004     | AEBC-ASCL1920           | 5               | 1799.00     | 0.00          | 0.00            | 1799.00           | 800.00       | 10000.00           |
    | 10192004 | 1            | FINAL         | AY         | 1920   | AECA-2004     | AEBC-ASCL1920           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10192004 | 1            | FINAL         | AY         | 1920   | AECA-2004     | AEBC-ASCL1920           | 3               | 5000.00     | 0.00          | 0.00            | 5000.00           | 0.00         | 9200.00            |
    | 10192004 | 1            | FINAL         | AY         | 1920   | AECA-2004     | AEBC-ASCL1920           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192004 | 1            | FINAL         | AY         | 1920   | AECA-2004     | AEBC-ASCL1920           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192004 | 1            | FINAL         | AY         | 1920   | AECA-2004     | AEBC-ASCL1920           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192004 | 1            | FINAL         | AY         | 1920   | AECA-2004     | AEBC-ASCL1920           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192004 | 1            | FINAL         | AY         | 1920   | AECA-2004     | AEBC-ASCL1920           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£6799.00     
    | 10192005 | 1            | FINAL         | AY         | 1920   | AECA-2005     | AEBC-ASCL1920           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192005 | 1            | FINAL         | AY         | 1920   | AECA-2005     | AEBC-ASCL1920           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 800.00       | 10000.00           |
    | 10192005 | 1            | FINAL         | AY         | 1920   | AECA-2005     | AEBC-ASCL1920           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10192005 | 1            | FINAL         | AY         | 1920   | AECA-2005     | AEBC-ASCL1920           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192005 | 1            | FINAL         | AY         | 1920   | AECA-2005     | AEBC-ASCL1920           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192005 | 1            | FINAL         | AY         | 1920   | AECA-2005     | AEBC-ASCL1920           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192005 | 1            | FINAL         | AY         | 1920   | AECA-2005     | AEBC-ASCL1920           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192005 | 1            | FINAL         | AY         | 1920   | AECA-2005     | AEBC-ASCL1920           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192005 | 1            | FINAL         | AY         | 1920   | AECA-2005     | AEBC-ASCL1920           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£0.00        
    | 10192006 | 1            | FINAL         | AY         | 1920   | AECA-2006     | AEBC-ASCL1920           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192006 | 1            | FINAL         | AY         | 1920   | AECA-2006     | AEBC-ASCL1920           | 5               | 1000.00     | 0.00          | 0.00            | 1000.00           | 800.00       | 10000.00           |
    | 10192006 | 1            | FINAL         | AY         | 1920   | AECA-2006     | AEBC-ASCL1920           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10192006 | 1            | FINAL         | AY         | 1920   | AECA-2006     | AEBC-ASCL1920           | 3               | 9299.00     | 0.00          | 0.00            | 9299.00           | 0.00         | 9200.00            |
    | 10192006 | 1            | FINAL         | AY         | 1920   | AECA-2006     | AEBC-ASCL1920           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192006 | 1            | FINAL         | AY         | 1920   | AECA-2006     | AEBC-ASCL1920           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192006 | 1            | FINAL         | AY         | 1920   | AECA-2006     | AEBC-ASCL1920           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192006 | 1            | FINAL         | AY         | 1920   | AECA-2006     | AEBC-ASCL1920           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192006 | 1            | FINAL         | AY         | 1920   | AECA-2006     | AEBC-ASCL1920           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£10299.00    
    | 10192007 | 1            | FINAL         | AY         | 1920   | AECA-2007     | AEBC-ASCL1920           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192007 | 1            | FINAL         | AY         | 1920   | AECA-2007     | AEBC-ASCL1920           | 5               | 300.00      | 0.00          | 0.00            | 300.00            | 800.00       | 10000.00           |
    | 10192007 | 1            | FINAL         | AY         | 1920   | AECA-2007     | AEBC-ASCL1920           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10192007 | 1            | FINAL         | AY         | 1920   | AECA-2007     | AEBC-ASCL1920           | 3               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 9200.00            |
    | 10192007 | 1            | FINAL         | AY         | 1920   | AECA-2007     | AEBC-ASCL1920           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192007 | 1            | FINAL         | AY         | 1920   | AECA-2007     | AEBC-ASCL1920           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192007 | 1            | FINAL         | AY         | 1920   | AECA-2007     | AEBC-ASCL1920           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192007 | 1            | FINAL         | AY         | 1920   | AECA-2007     | AEBC-ASCL1920           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192007 | 1            | FINAL         | AY         | 1920   | AECA-2007     | AEBC-ASCL1920           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£10300.00    
    | 10192008 | 1            | FINAL         | AY         | 1920   | AECA-2008     | AEBC-ASCL1920           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192008 | 1            | FINAL         | AY         | 1920   | AECA-2008     | AEBC-ASCL1920           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 800.00       | 10000.00           |
    | 10192008 | 1            | FINAL         | AY         | 1920   | AECA-2008     | AEBC-ASCL1920           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10192008 | 1            | FINAL         | AY         | 1920   | AECA-2008     | AEBC-ASCL1920           | 3               | 10301.00    | 0.00          | 0.00            | 10301.00          | 0.00         | 9200.00            |
    | 10192008 | 1            | FINAL         | AY         | 1920   | AECA-2008     | AEBC-ASCL1920           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192008 | 1            | FINAL         | AY         | 1920   | AECA-2008     | AEBC-ASCL1920           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192008 | 1            | FINAL         | AY         | 1920   | AECA-2008     | AEBC-ASCL1920           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192008 | 1            | FINAL         | AY         | 1920   | AECA-2008     | AEBC-ASCL1920           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10192008 | 1            | FINAL         | AY         | 1920   | AECA-2008     | AEBC-ASCL1920           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£10301.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10192001 | 1920          | FINAL           | AEBC-ASCL1920       | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10192002 | 1920          | FINAL           | AEBC-ASCL1920       | 10000.00     | 6801.00      | 6801.00          | 0.00                        | 0.00                |
    | 10192003 | 1920          | FINAL           | AEBC-ASCL1920       | 10000.00     | 6800.00      | 6800.00          | 0.00                        | 0.00                |
    | 10192004 | 1920          | FINAL           | AEBC-ASCL1920       | 10000.00     | 6799.00      | 6799.00          | -1.00                       | -1.00               |
    | 10192005 | 1920          | FINAL           | AEBC-ASCL1920       | 10000.00     | 0.00         | 0.00             | -6800.00                    | -6800.00            |
    | 10192006 | 1920          | FINAL           | AEBC-ASCL1920       | 10000.00     | 10299.00     | 10299.00         | 299.00                      | 299.00              |
    | 10192007 | 1920          | FINAL           | AEBC-ASCL1920       | 10000.00     | 10300.00     | 10300.00         | 300.00                      | 300.00              |
    | 10192008 | 1920          | FINAL           | AEBC-ASCL1920       | 10000.00     | 10301.00     | 10301.00         | 300.00                      | 300.00              |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10192001 | 1920          | FINAL           | AECA-2001           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10192002 | 1920          | FINAL           | AECA-2002           | 10000.00     | 6801.00      | 6801.00          | 0.00                        | 0.00                |
    | 10192003 | 1920          | FINAL           | AECA-2003           | 10000.00     | 6800.00      | 6800.00          | 0.00                        | 0.00                |
    | 10192004 | 1920          | FINAL           | AECA-2004           | 10000.00     | 6799.00      | 6799.00          | -1.00                       | -1.00               |
    | 10192005 | 1920          | FINAL           | AECA-2005           | 10000.00     | 0.00         | 0.00             | -6800.00                    | -6800.00            |
    | 10192006 | 1920          | FINAL           | AECA-2006           | 10000.00     | 10299.00     | 10299.00         | 299.00                      | 299.00              |
    | 10192007 | 1920          | FINAL           | AECA-2007           | 10000.00     | 10300.00     | 10300.00         | 300.00                      | 300.00              |
    | 10192008 | 1920          | FINAL           | AECA-2008           | 10000.00     | 10301.00     | 10301.00         | 300.00                      | 300.00              |

@DoNotRun_7Mar2024 
@FundingClaimCalculation
Scenario: D562 Final Funding Claim Reconciliation Calculations for AEBC-19TRN1920

    #  9 Variance = £0
    # 10 Under-delivery - Variance within Tolerance
    # 11 Under-delivery - Variance = Tolerance
    # 12 Under-delivery - Variance exceeds Tolerance
    # 13 Under-delivery - Delivers nothing
    # 14 Over-delivery  - Variance within Limit
    # 15 Over-delivery  - Variance = Limit
    # 16 Over-delivery  - Variance exceeds Limit

    Given there are no Allocations in PaaS (Performance Management)

    And   the following debatched funding claims are received
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationGroupCode |
    | 10192009 | 1            | FINAL         | AY         | 1920   | AEBC-19TRN1920      |
    | 10192010 | 1            | FINAL         | AY         | 1920   | AEBC-19TRN1920      |
    | 10192011 | 1            | FINAL         | AY         | 1920   | AEBC-19TRN1920      |
    | 10192012 | 1            | FINAL         | AY         | 1920   | AEBC-19TRN1920      |
    | 10192013 | 1            | FINAL         | AY         | 1920   | AEBC-19TRN1920      |
    | 10192014 | 1            | FINAL         | AY         | 1920   | AEBC-19TRN1920      |
    | 10192015 | 1            | FINAL         | AY         | 1920   | AEBC-19TRN1920      |
    | 10192016 | 1            | FINAL         | AY         | 1920   | AEBC-19TRN1920      |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10192009 | 1            | FINAL         | AY         | 1920   | AECT-2009     | AEBC-19TRN1920      | AEBC-19TRN1920          | 10000.00        |
    | 10192010 | 1            | FINAL         | AY         | 1920   | AECT-2010     | AEBC-19TRN1920      | AEBC-19TRN1920          | 10000.00        |
    | 10192011 | 1            | FINAL         | AY         | 1920   | AECT-2011     | AEBC-19TRN1920      | AEBC-19TRN1920          | 10000.00        |
    | 10192012 | 1            | FINAL         | AY         | 1920   | AECT-2012     | AEBC-19TRN1920      | AEBC-19TRN1920          | 10000.00        |
    | 10192013 | 1            | FINAL         | AY         | 1920   | AECT-2013     | AEBC-19TRN1920      | AEBC-19TRN1920          | 10000.00        |
    | 10192014 | 1            | FINAL         | AY         | 1920   | AECT-2014     | AEBC-19TRN1920      | AEBC-19TRN1920          | 10000.00        |
    | 10192015 | 1            | FINAL         | AY         | 1920   | AECT-2015     | AEBC-19TRN1920      | AEBC-19TRN1920          | 10000.00        |
    | 10192016 | 1            | FINAL         | AY         | 1920   | AECT-2016     | AEBC-19TRN1920      | AEBC-19TRN1920          | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10192009 | 1            | FINAL         | AY         | 1920   | AECT-2009     | AEBC-19TRN1920          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192009 | 1            | FINAL         | AY         | 1920   | AECT-2009     | AEBC-19TRN1920          | 2               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 10000.00           |
    | 10192009 | 1            | FINAL         | AY         | 1920   | AECT-2009     | AEBC-19TRN1920          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192009 | 1            | FINAL         | AY         | 1920   | AECT-2009     | AEBC-19TRN1920          | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192009 | 1            | FINAL         | AY         | 1920   | AECT-2009     | AEBC-19TRN1920          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10000.00    
    | 10192010 | 1            | FINAL         | AY         | 1920   | AECT-2010     | AEBC-19TRN1920          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192010 | 1            | FINAL         | AY         | 1920   | AECT-2010     | AEBC-19TRN1920          | 2               | 1101.00     | 0.00          | 0.00            | 1101.00           | 0.00         | 10000.00           |
    | 10192010 | 1            | FINAL         | AY         | 1920   | AECT-2010     | AEBC-19TRN1920          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192010 | 1            | FINAL         | AY         | 1920   | AECT-2010     | AEBC-19TRN1920          | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192010 | 1            | FINAL         | AY         | 1920   | AECT-2010     | AEBC-19TRN1920          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£1101.00     
    | 10192011 | 1            | FINAL         | AY         | 1920   | AECT-2011     | AEBC-19TRN1920          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192011 | 1            | FINAL         | AY         | 1920   | AECT-2011     | AEBC-19TRN1920          | 2               | 1100.00     | 0.00          | 0.00            | 1100.00           | 0.00         | 10000.00           |
    | 10192011 | 1            | FINAL         | AY         | 1920   | AECT-2011     | AEBC-19TRN1920          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192011 | 1            | FINAL         | AY         | 1920   | AECT-2011     | AEBC-19TRN1920          | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192011 | 1            | FINAL         | AY         | 1920   | AECT-2011     | AEBC-19TRN1920          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£1100.00     
    | 10192012 | 1            | FINAL         | AY         | 1920   | AECT-2012     | AEBC-19TRN1920          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192012 | 1            | FINAL         | AY         | 1920   | AECT-2012     | AEBC-19TRN1920          | 2               | 1099.00     | 0.00          | 0.00            | 1099.00           | 0.00         | 10000.00           |
    | 10192012 | 1            | FINAL         | AY         | 1920   | AECT-2012     | AEBC-19TRN1920          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192012 | 1            | FINAL         | AY         | 1920   | AECT-2012     | AEBC-19TRN1920          | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192012 | 1            | FINAL         | AY         | 1920   | AECT-2012     | AEBC-19TRN1920          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£1099.00     
    | 10192013 | 1            | FINAL         | AY         | 1920   | AECT-2013     | AEBC-19TRN1920          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192013 | 1            | FINAL         | AY         | 1920   | AECT-2013     | AEBC-19TRN1920          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192013 | 1            | FINAL         | AY         | 1920   | AECT-2013     | AEBC-19TRN1920          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192013 | 1            | FINAL         | AY         | 1920   | AECT-2013     | AEBC-19TRN1920          | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192013 | 1            | FINAL         | AY         | 1920   | AECT-2013     | AEBC-19TRN1920          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£0.00        
    | 10192014 | 1            | FINAL         | AY         | 1920   | AECT-2014     | AEBC-19TRN1920          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192014 | 1            | FINAL         | AY         | 1920   | AECT-2014     | AEBC-19TRN1920          | 2               | 10999.00    | 0.00          | 0.00            | 10999.00          | 0.00         | 10000.00           |
    | 10192014 | 1            | FINAL         | AY         | 1920   | AECT-2014     | AEBC-19TRN1920          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192014 | 1            | FINAL         | AY         | 1920   | AECT-2014     | AEBC-19TRN1920          | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192014 | 1            | FINAL         | AY         | 1920   | AECT-2014     | AEBC-19TRN1920          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10999.00    
    | 10192015 | 1            | FINAL         | AY         | 1920   | AECT-2015     | AEBC-19TRN1920          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192015 | 1            | FINAL         | AY         | 1920   | AECT-2015     | AEBC-19TRN1920          | 2               | 11000.00    | 0.00          | 0.00            | 11000.00          | 0.00         | 10000.00           |
    | 10192015 | 1            | FINAL         | AY         | 1920   | AECT-2015     | AEBC-19TRN1920          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192015 | 1            | FINAL         | AY         | 1920   | AECT-2015     | AEBC-19TRN1920          | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192015 | 1            | FINAL         | AY         | 1920   | AECT-2015     | AEBC-19TRN1920          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£11000.00    
    | 10192016 | 1            | FINAL         | AY         | 1920   | AECT-2016     | AEBC-19TRN1920          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192016 | 1            | FINAL         | AY         | 1920   | AECT-2016     | AEBC-19TRN1920          | 2               | 11001.00    | 0.00          | 0.00            | 11001.00          | 0.00         | 10000.00           |
    | 10192016 | 1            | FINAL         | AY         | 1920   | AECT-2016     | AEBC-19TRN1920          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192016 | 1            | FINAL         | AY         | 1920   | AECT-2016     | AEBC-19TRN1920          | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192016 | 1            | FINAL         | AY         | 1920   | AECT-2016     | AEBC-19TRN1920          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£11001.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10192009 | 1920          | FINAL           | AEBC-19TRN1920      | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10192010 | 1920          | FINAL           | AEBC-19TRN1920      | 10000.00     | 1101.00      | 1101.00          | 0.00                        | 0.00                |
    | 10192011 | 1920          | FINAL           | AEBC-19TRN1920      | 10000.00     | 1100.00      | 1100.00          | 0.00                        | 0.00                |
    | 10192012 | 1920          | FINAL           | AEBC-19TRN1920      | 10000.00     | 1099.00      | 1099.00          | -1.00                       | -1.00               |
    | 10192013 | 1920          | FINAL           | AEBC-19TRN1920      | 10000.00     | 0.00         | 0.00             | -1100.00                    | -1100.00            |
    | 10192014 | 1920          | FINAL           | AEBC-19TRN1920      | 10000.00     | 10999.00     | 10999.00         | 999.00                      | 999.00              |
    | 10192015 | 1920          | FINAL           | AEBC-19TRN1920      | 10000.00     | 11000.00     | 11000.00         | 1000.00                     | 1000.00             |
    | 10192016 | 1920          | FINAL           | AEBC-19TRN1920      | 10000.00     | 11001.00     | 11001.00         | 1000.00                     | 1000.00             |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10192009 | 1920          | FINAL           | AECT-2009           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10192010 | 1920          | FINAL           | AECT-2010           | 10000.00     | 1101.00      | 1101.00          | 0.00                        | 0.00                |
    | 10192011 | 1920          | FINAL           | AECT-2011           | 10000.00     | 1100.00      | 1100.00          | 0.00                        | 0.00                |
    | 10192012 | 1920          | FINAL           | AECT-2012           | 10000.00     | 1099.00      | 1099.00          | -1.00                       | -1.00               |
    | 10192013 | 1920          | FINAL           | AECT-2013           | 10000.00     | 0.00         | 0.00             | -1100.00                    | -1100.00            |
    | 10192014 | 1920          | FINAL           | AECT-2014           | 10000.00     | 10999.00     | 10999.00         | 999.00                      | 999.00              |
    | 10192015 | 1920          | FINAL           | AECT-2015           | 10000.00     | 11000.00     | 11000.00         | 1000.00                     | 1000.00             |
    | 10192016 | 1920          | FINAL           | AECT-2016           | 10000.00     | 11001.00     | 11001.00         | 1000.00                     | 1000.00             |

@DoNotRun_7Mar2024 
@FundingClaimCalculation
Scenario: D563 Final Funding Claim Reconciliation Calculations for AEB-ASLS1920

    # 17 Variance = £0
    # 18 Under-delivery
    # 19 Under-delivery - Delivers nothing
    # 20 Over-delivery  - Variance within Limit
    # 21 Over-delivery  - Variance = Limit
    # 22 Over-delivery  - Variance exceeds Limit

    Given there are no Allocations in PaaS (Performance Management)

    And   the following debatched funding claims are received
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationGroupCode |
    | 10192017 | 1            | FINAL         | AY         | 1920   | AEB-ASLS1920        |
    | 10192018 | 1            | FINAL         | AY         | 1920   | AEB-ASLS1920        |
    | 10192019 | 1            | FINAL         | AY         | 1920   | AEB-ASLS1920        |
    | 10192020 | 1            | FINAL         | AY         | 1920   | AEB-ASLS1920        |
    | 10192021 | 1            | FINAL         | AY         | 1920   | AEB-ASLS1920        |
    | 10192022 | 1            | FINAL         | AY         | 1920   | AEB-ASLS1920        |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10192017 | 1            | FINAL         | AY         | 1920   | AEAL-2017     | AEB-ASLS1920        | AEB-ASLS1920            | 10000.00        |
    | 10192018 | 1            | FINAL         | AY         | 1920   | AEAL-2018     | AEB-ASLS1920        | AEB-ASLS1920            | 10000.00        |
    | 10192019 | 1            | FINAL         | AY         | 1920   | AEAL-2019     | AEB-ASLS1920        | AEB-ASLS1920            | 10000.00        |
    | 10192020 | 1            | FINAL         | AY         | 1920   | AEAL-2020     | AEB-ASLS1920        | AEB-ASLS1920            | 10000.00        |
    | 10192021 | 1            | FINAL         | AY         | 1920   | AEAL-2021     | AEB-ASLS1920        | AEB-ASLS1920            | 10000.00        |
    | 10192022 | 1            | FINAL         | AY         | 1920   | AEAL-2022     | AEB-ASLS1920        | AEB-ASLS1920            | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10192017 | 1            | FINAL         | AY         | 1920   | AEAL-2017     | AEB-ASLS1920            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192017 | 1            | FINAL         | AY         | 1920   | AEAL-2017     | AEB-ASLS1920            | 2               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 10000.00           |
    | 10192017 | 1            | FINAL         | AY         | 1920   | AEAL-2017     | AEB-ASLS1920            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192017 | 1            | FINAL         | AY         | 1920   | AEAL-2017     | AEB-ASLS1920            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192017 | 1            | FINAL         | AY         | 1920   | AEAL-2017     | AEB-ASLS1920            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10000.00    
    | 10192018 | 1            | FINAL         | AY         | 1920   | AEAL-2018     | AEB-ASLS1920            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192018 | 1            | FINAL         | AY         | 1920   | AEAL-2018     | AEB-ASLS1920            | 2               | 9999.00     | 0.00          | 0.00            | 9999.00           | 0.00         | 10000.00           |
    | 10192018 | 1            | FINAL         | AY         | 1920   | AEAL-2018     | AEB-ASLS1920            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192018 | 1            | FINAL         | AY         | 1920   | AEAL-2018     | AEB-ASLS1920            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192018 | 1            | FINAL         | AY         | 1920   | AEAL-2018     | AEB-ASLS1920            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9999.00     
    | 10192019 | 1            | FINAL         | AY         | 1920   | AEAL-2019     | AEB-ASLS1920            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192019 | 1            | FINAL         | AY         | 1920   | AEAL-2019     | AEB-ASLS1920            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192019 | 1            | FINAL         | AY         | 1920   | AEAL-2019     | AEB-ASLS1920            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192019 | 1            | FINAL         | AY         | 1920   | AEAL-2019     | AEB-ASLS1920            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192019 | 1            | FINAL         | AY         | 1920   | AEAL-2019     | AEB-ASLS1920            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£0.00        
    | 10192020 | 1            | FINAL         | AY         | 1920   | AEAL-2020     | AEB-ASLS1920            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192020 | 1            | FINAL         | AY         | 1920   | AEAL-2020     | AEB-ASLS1920            | 2               | 10299.00    | 0.00          | 0.00            | 10299.00          | 0.00         | 10000.00           |
    | 10192020 | 1            | FINAL         | AY         | 1920   | AEAL-2020     | AEB-ASLS1920            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192020 | 1            | FINAL         | AY         | 1920   | AEAL-2020     | AEB-ASLS1920            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192020 | 1            | FINAL         | AY         | 1920   | AEAL-2020     | AEB-ASLS1920            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10299.00    
    | 10192021 | 1            | FINAL         | AY         | 1920   | AEAL-2021     | AEB-ASLS1920            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192021 | 1            | FINAL         | AY         | 1920   | AEAL-2021     | AEB-ASLS1920            | 2               | 10300.00    | 0.00          | 0.00            | 10300.00          | 0.00         | 10000.00           |
    | 10192021 | 1            | FINAL         | AY         | 1920   | AEAL-2021     | AEB-ASLS1920            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192021 | 1            | FINAL         | AY         | 1920   | AEAL-2021     | AEB-ASLS1920            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192021 | 1            | FINAL         | AY         | 1920   | AEAL-2021     | AEB-ASLS1920            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10300.00    
    | 10192022 | 1            | FINAL         | AY         | 1920   | AEAL-2022     | AEB-ASLS1920            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192022 | 1            | FINAL         | AY         | 1920   | AEAL-2022     | AEB-ASLS1920            | 2               | 10301.00    | 0.00          | 0.00            | 10301.00          | 0.00         | 10000.00           |
    | 10192022 | 1            | FINAL         | AY         | 1920   | AEAL-2022     | AEB-ASLS1920            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192022 | 1            | FINAL         | AY         | 1920   | AEAL-2022     | AEB-ASLS1920            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192022 | 1            | FINAL         | AY         | 1920   | AEAL-2022     | AEB-ASLS1920            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10301.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10192017 | 1920          | FINAL           | AEB-ASLS1920        | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10192018 | 1920          | FINAL           | AEB-ASLS1920        | 10000.00     | 9999.00      | 9999.00          | -1.00                       | -1.00               |
    | 10192019 | 1920          | FINAL           | AEB-ASLS1920        | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10192020 | 1920          | FINAL           | AEB-ASLS1920        | 10000.00     | 10299.00     | 10299.00         | 299.00                      | 299.00              |
    | 10192021 | 1920          | FINAL           | AEB-ASLS1920        | 10000.00     | 10300.00     | 10300.00         | 300.00                      | 300.00              |
    | 10192022 | 1920          | FINAL           | AEB-ASLS1920        | 10000.00     | 10301.00     | 10301.00         | 300.00                      | 300.00              |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10192017 | 1920          | FINAL           | AEAL-2017           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10192018 | 1920          | FINAL           | AEAL-2018           | 10000.00     | 9999.00      | 9999.00          | -1.00                       | -1.00               |
    | 10192019 | 1920          | FINAL           | AEAL-2019           | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10192020 | 1920          | FINAL           | AEAL-2020           | 10000.00     | 10299.00     | 10299.00         | 299.00                      | 299.00              |
    | 10192021 | 1920          | FINAL           | AEAL-2021           | 10000.00     | 10300.00     | 10300.00         | 300.00                      | 300.00              |
    | 10192022 | 1920          | FINAL           | AEAL-2022           | 10000.00     | 10301.00     | 10301.00         | 300.00                      | 300.00              |

@DoNotRun_7Mar2024 
@FundingClaimCalculation
Scenario: D564 Final Funding Claim Reconciliation Calculations for AEB-19TRLS1920

    # 23 Variance = £0
    # 24 Under-delivery
    # 25 Under-delivery - Delivers nothing
    # 26 Over-delivery  - Variance within Limit
    # 27 Over-delivery  - Variance = Limit
    # 28 Over-delivery  - Variance exceeds Limit

    Given there are no Allocations in PaaS (Performance Management)

    And   the following debatched funding claims are received
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationGroupCode |
    | 10192023 | 1            | FINAL         | AY         | 1920   | AEB-19TRLS1920      |
    | 10192024 | 1            | FINAL         | AY         | 1920   | AEB-19TRLS1920      |
    | 10192025 | 1            | FINAL         | AY         | 1920   | AEB-19TRLS1920      |
    | 10192026 | 1            | FINAL         | AY         | 1920   | AEB-19TRLS1920      |
    | 10192027 | 1            | FINAL         | AY         | 1920   | AEB-19TRLS1920      |
    | 10192028 | 1            | FINAL         | AY         | 1920   | AEB-19TRLS1920      |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10192023 | 1            | FINAL         | AY         | 1920   | AETL-2023     | AEB-19TRLS1920      | AEB-19TRLS1920          | 10000.00        |
    | 10192024 | 1            | FINAL         | AY         | 1920   | AETL-2024     | AEB-19TRLS1920      | AEB-19TRLS1920          | 10000.00        |
    | 10192025 | 1            | FINAL         | AY         | 1920   | AETL-2025     | AEB-19TRLS1920      | AEB-19TRLS1920          | 10000.00        |
    | 10192026 | 1            | FINAL         | AY         | 1920   | AETL-2026     | AEB-19TRLS1920      | AEB-19TRLS1920          | 10000.00        |
    | 10192027 | 1            | FINAL         | AY         | 1920   | AETL-2027     | AEB-19TRLS1920      | AEB-19TRLS1920          | 10000.00        |
    | 10192028 | 1            | FINAL         | AY         | 1920   | AETL-2028     | AEB-19TRLS1920      | AEB-19TRLS1920          | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10192023 | 1            | FINAL         | AY         | 1920   | AETL-2023     | AEB-19TRLS1920          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192023 | 1            | FINAL         | AY         | 1920   | AETL-2023     | AEB-19TRLS1920          | 2               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 10000.00           |
    | 10192023 | 1            | FINAL         | AY         | 1920   | AETL-2023     | AEB-19TRLS1920          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10000.00    
    | 10192024 | 1            | FINAL         | AY         | 1920   | AETL-2024     | AEB-19TRLS1920          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192024 | 1            | FINAL         | AY         | 1920   | AETL-2024     | AEB-19TRLS1920          | 2               | 9999.00     | 0.00          | 0.00            | 9999.00           | 0.00         | 10000.00           |
    | 10192024 | 1            | FINAL         | AY         | 1920   | AETL-2024     | AEB-19TRLS1920          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9999.00     
    | 10192025 | 1            | FINAL         | AY         | 1920   | AETL-2025     | AEB-19TRLS1920          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192025 | 1            | FINAL         | AY         | 1920   | AETL-2025     | AEB-19TRLS1920          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192025 | 1            | FINAL         | AY         | 1920   | AETL-2025     | AEB-19TRLS1920          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£0.00        
    | 10192026 | 1            | FINAL         | AY         | 1920   | AETL-2026     | AEB-19TRLS1920          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192026 | 1            | FINAL         | AY         | 1920   | AETL-2026     | AEB-19TRLS1920          | 2               | 10999.00    | 0.00          | 0.00            | 10999.00          | 0.00         | 10000.00           |
    | 10192026 | 1            | FINAL         | AY         | 1920   | AETL-2026     | AEB-19TRLS1920          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10999.00    
    | 10192027 | 1            | FINAL         | AY         | 1920   | AETL-2027     | AEB-19TRLS1920          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192027 | 1            | FINAL         | AY         | 1920   | AETL-2027     | AEB-19TRLS1920          | 2               | 11000.00    | 0.00          | 0.00            | 11000.00          | 0.00         | 10000.00           |
    | 10192027 | 1            | FINAL         | AY         | 1920   | AETL-2027     | AEB-19TRLS1920          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£11000.00    
    | 10192028 | 1            | FINAL         | AY         | 1920   | AETL-2028     | AEB-19TRLS1920          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192028 | 1            | FINAL         | AY         | 1920   | AETL-2028     | AEB-19TRLS1920          | 2               | 11001.00    | 0.00          | 0.00            | 11001.00          | 0.00         | 10000.00           |
    | 10192028 | 1            | FINAL         | AY         | 1920   | AETL-2028     | AEB-19TRLS1920          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£11001.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10192023 | 1920          | FINAL           | AEB-19TRLS1920      | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10192024 | 1920          | FINAL           | AEB-19TRLS1920      | 10000.00     | 9999.00      | 9999.00          | -1.00                       | -1.00               |
    | 10192025 | 1920          | FINAL           | AEB-19TRLS1920      | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10192026 | 1920          | FINAL           | AEB-19TRLS1920      | 10000.00     | 10999.00     | 10999.00         | 999.00                      | 999.00              |
    | 10192027 | 1920          | FINAL           | AEB-19TRLS1920      | 10000.00     | 11000.00     | 11000.00         | 1000.00                     | 1000.00             |
    | 10192028 | 1920          | FINAL           | AEB-19TRLS1920      | 10000.00     | 11001.00     | 11001.00         | 1000.00                     | 1000.00             |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10192023 | 1920          | FINAL           | AETL-2023           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10192024 | 1920          | FINAL           | AETL-2024           | 10000.00     | 9999.00      | 9999.00          | -1.00                       | -1.00               |
    | 10192025 | 1920          | FINAL           | AETL-2025           | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10192026 | 1920          | FINAL           | AETL-2026           | 10000.00     | 10999.00     | 10999.00         | 999.00                      | 999.00              |
    | 10192027 | 1920          | FINAL           | AETL-2027           | 10000.00     | 11000.00     | 11000.00         | 1000.00                     | 1000.00             |
    | 10192028 | 1920          | FINAL           | AETL-2028           | 10000.00     | 11001.00     | 11001.00         | 1000.00                     | 1000.00             |

@DoNotRun_7Mar2024 
@FundingClaimCalculation
Scenario: D565 Final Funding Claim Reconciliation Calculations for ALLBC1920

    # 29 Variance = £0
    # 30 Under-delivery - Variance within Tolerance
    # 31 Under-delivery - Variance = Tolerance
    # 32 Under-delivery - Variance exceeds Tolerance
    # 33 Under-delivery - Delivers nothing
    # 34 Over-delivery  - Small
    # 35 Over-delivery  - Large

    Given there are no Allocations in PaaS (Performance Management)

    And   the following debatched funding claims are received
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationGroupCode |
    | 10192029 | 1            | FINAL         | AY         | 1920   | ALLBC1920           |
    | 10192030 | 1            | FINAL         | AY         | 1920   | ALLBC1920           |
    | 10192031 | 1            | FINAL         | AY         | 1920   | ALLBC1920           |
    | 10192032 | 1            | FINAL         | AY         | 1920   | ALLBC1920           |
    | 10192033 | 1            | FINAL         | AY         | 1920   | ALLBC1920           |
    | 10192034 | 1            | FINAL         | AY         | 1920   | ALLBC1920           |
    | 10192035 | 1            | FINAL         | AY         | 1920   | ALLBC1920           |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10192029 | 1            | FINAL         | AY         | 1920   | ALLC-2029     | ALLBC1920           | ALLBC1920               | 10000.00        |
    | 10192030 | 1            | FINAL         | AY         | 1920   | ALLC-2030     | ALLBC1920           | ALLBC1920               | 10000.00        |
    | 10192031 | 1            | FINAL         | AY         | 1920   | ALLC-2031     | ALLBC1920           | ALLBC1920               | 10000.00        |
    | 10192032 | 1            | FINAL         | AY         | 1920   | ALLC-2032     | ALLBC1920           | ALLBC1920               | 10000.00        |
    | 10192033 | 1            | FINAL         | AY         | 1920   | ALLC-2033     | ALLBC1920           | ALLBC1920               | 10000.00        |
    | 10192034 | 1            | FINAL         | AY         | 1920   | ALLC-2034     | ALLBC1920           | ALLBC1920               | 10000.00        |
    | 10192035 | 1            | FINAL         | AY         | 1920   | ALLC-2035     | ALLBC1920           | ALLBC1920               | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10192029 | 1            | FINAL         | AY         | 1920   | ALLC-2029     | ALLBC1920               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192029 | 1            | FINAL         | AY         | 1920   | ALLC-2029     | ALLBC1920               | 2               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 10000.00           |
    | 10192029 | 1            | FINAL         | AY         | 1920   | ALLC-2029     | ALLBC1920               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192029 | 1            | FINAL         | AY         | 1920   | ALLC-2029     | ALLBC1920               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192029 | 1            | FINAL         | AY         | 1920   | ALLC-2029     | ALLBC1920               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192029 | 1            | FINAL         | AY         | 1920   | ALLC-2029     | ALLBC1920               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192029 | 1            | FINAL         | AY         | 1920   | ALLC-2029     | ALLBC1920               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192029 | 1            | FINAL         | AY         | 1920   | ALLC-2029     | ALLBC1920               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10000.00    
    | 10192030 | 1            | FINAL         | AY         | 1920   | ALLC-2030     | ALLBC1920               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192030 | 1            | FINAL         | AY         | 1920   | ALLC-2030     | ALLBC1920               | 2               | 3001.00     | 0.00          | 0.00            | 3001.00           | 0.00         | 10000.00           |
    | 10192030 | 1            | FINAL         | AY         | 1920   | ALLC-2030     | ALLBC1920               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192030 | 1            | FINAL         | AY         | 1920   | ALLC-2030     | ALLBC1920               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192030 | 1            | FINAL         | AY         | 1920   | ALLC-2030     | ALLBC1920               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192030 | 1            | FINAL         | AY         | 1920   | ALLC-2030     | ALLBC1920               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192030 | 1            | FINAL         | AY         | 1920   | ALLC-2030     | ALLBC1920               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192030 | 1            | FINAL         | AY         | 1920   | ALLC-2030     | ALLBC1920               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£3001.00     
    | 10192031 | 1            | FINAL         | AY         | 1920   | ALLC-2031     | ALLBC1920               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192031 | 1            | FINAL         | AY         | 1920   | ALLC-2031     | ALLBC1920               | 2               | 3000.00     | 0.00          | 0.00            | 3000.00           | 0.00         | 10000.00           |
    | 10192031 | 1            | FINAL         | AY         | 1920   | ALLC-2031     | ALLBC1920               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192031 | 1            | FINAL         | AY         | 1920   | ALLC-2031     | ALLBC1920               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192031 | 1            | FINAL         | AY         | 1920   | ALLC-2031     | ALLBC1920               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192031 | 1            | FINAL         | AY         | 1920   | ALLC-2031     | ALLBC1920               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192031 | 1            | FINAL         | AY         | 1920   | ALLC-2031     | ALLBC1920               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192031 | 1            | FINAL         | AY         | 1920   | ALLC-2031     | ALLBC1920               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£3000.00     
    | 10192032 | 1            | FINAL         | AY         | 1920   | ALLC-2032     | ALLBC1920               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192032 | 1            | FINAL         | AY         | 1920   | ALLC-2032     | ALLBC1920               | 2               | 2999.00     | 0.00          | 0.00            | 2999.00           | 0.00         | 10000.00           |
    | 10192032 | 1            | FINAL         | AY         | 1920   | ALLC-2032     | ALLBC1920               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192032 | 1            | FINAL         | AY         | 1920   | ALLC-2032     | ALLBC1920               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192032 | 1            | FINAL         | AY         | 1920   | ALLC-2032     | ALLBC1920               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192032 | 1            | FINAL         | AY         | 1920   | ALLC-2032     | ALLBC1920               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192032 | 1            | FINAL         | AY         | 1920   | ALLC-2032     | ALLBC1920               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192032 | 1            | FINAL         | AY         | 1920   | ALLC-2032     | ALLBC1920               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£2999.00     
    | 10192033 | 1            | FINAL         | AY         | 1920   | ALLC-2033     | ALLBC1920               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192033 | 1            | FINAL         | AY         | 1920   | ALLC-2033     | ALLBC1920               | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192033 | 1            | FINAL         | AY         | 1920   | ALLC-2033     | ALLBC1920               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192033 | 1            | FINAL         | AY         | 1920   | ALLC-2033     | ALLBC1920               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192033 | 1            | FINAL         | AY         | 1920   | ALLC-2033     | ALLBC1920               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192033 | 1            | FINAL         | AY         | 1920   | ALLC-2033     | ALLBC1920               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192033 | 1            | FINAL         | AY         | 1920   | ALLC-2033     | ALLBC1920               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192033 | 1            | FINAL         | AY         | 1920   | ALLC-2033     | ALLBC1920               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£0.00        
    | 10192034 | 1            | FINAL         | AY         | 1920   | ALLC-2034     | ALLBC1920               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192034 | 1            | FINAL         | AY         | 1920   | ALLC-2034     | ALLBC1920               | 2               | 10001.00    | 0.00          | 0.00            | 10001.00          | 0.00         | 10000.00           |
    | 10192034 | 1            | FINAL         | AY         | 1920   | ALLC-2034     | ALLBC1920               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192034 | 1            | FINAL         | AY         | 1920   | ALLC-2034     | ALLBC1920               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192034 | 1            | FINAL         | AY         | 1920   | ALLC-2034     | ALLBC1920               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192034 | 1            | FINAL         | AY         | 1920   | ALLC-2034     | ALLBC1920               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192034 | 1            | FINAL         | AY         | 1920   | ALLC-2034     | ALLBC1920               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192034 | 1            | FINAL         | AY         | 1920   | ALLC-2034     | ALLBC1920               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10001.00    
    | 10192035 | 1            | FINAL         | AY         | 1920   | ALLC-2035     | ALLBC1920               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10192035 | 1            | FINAL         | AY         | 1920   | ALLC-2035     | ALLBC1920               | 2               | 21000.00    | 0.00          | 0.00            | 21000.00          | 0.00         | 10000.00           |
    | 10192035 | 1            | FINAL         | AY         | 1920   | ALLC-2035     | ALLBC1920               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192035 | 1            | FINAL         | AY         | 1920   | ALLC-2035     | ALLBC1920               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192035 | 1            | FINAL         | AY         | 1920   | ALLC-2035     | ALLBC1920               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192035 | 1            | FINAL         | AY         | 1920   | ALLC-2035     | ALLBC1920               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192035 | 1            | FINAL         | AY         | 1920   | ALLC-2035     | ALLBC1920               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10192035 | 1            | FINAL         | AY         | 1920   | ALLC-2035     | ALLBC1920               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£21000.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10192029 | 1920          | FINAL           | ALLBC1920           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10192030 | 1920          | FINAL           | ALLBC1920           | 10000.00     | 3001.00      | 3001.00          | 0.00                        | 0.00                |
    | 10192031 | 1920          | FINAL           | ALLBC1920           | 10000.00     | 3000.00      | 3000.00          | 0.00                        | 0.00                |
    | 10192032 | 1920          | FINAL           | ALLBC1920           | 10000.00     | 2999.00      | 2999.00          | -1.00                       | -1.00               |
    | 10192033 | 1920          | FINAL           | ALLBC1920           | 10000.00     | 0.00         | 0.00             | -3000.00                    | -3000.00            |
    | 10192034 | 1920          | FINAL           | ALLBC1920           | 10000.00     | 10001.00     | 10001.00         | 0.00                        | 0.00                |
    | 10192035 | 1920          | FINAL           | ALLBC1920           | 10000.00     | 21000.00     | 21000.00         | 0.00                        | 0.00                |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10192029 | 1920          | FINAL           | ALLC-2029           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10192030 | 1920          | FINAL           | ALLC-2030           | 10000.00     | 3001.00      | 3001.00          | 0.00                        | 0.00                |
    | 10192031 | 1920          | FINAL           | ALLC-2031           | 10000.00     | 3000.00      | 3000.00          | 0.00                        | 0.00                |
    | 10192032 | 1920          | FINAL           | ALLC-2032           | 10000.00     | 2999.00      | 2999.00          | -1.00                       | -1.00               |
    | 10192033 | 1920          | FINAL           | ALLC-2033           | 10000.00     | 0.00         | 0.00             | -3000.00                    | -3000.00            |
    | 10192034 | 1920          | FINAL           | ALLC-2034           | 10000.00     | 10001.00     | 10001.00         | 0.00                        | 0.00                |
    | 10192035 | 1920          | FINAL           | ALLC-2035           | 10000.00     | 21000.00     | 21000.00         | 0.00                        | 0.00                |

       