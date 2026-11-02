Feature: FundingClaimReconciliationCalculationsFor2122

@DoNotRun_7Mar2024 
@FundingClaimCalculation
Scenario: D581 Year-End Funding Claim Reconciliation Calculations for AEBC-ASCL2122

    #  1 No CL. Under-delivery - Delivers nothing
    #  2 No CL. Under-delivery - Variance exceeds Tolerance
    #  3 No CL. Under-delivery - Variance = Tolerance
    #  4 No CL. -delivery - Variance within Tolerance
    #  5 No CL. Variance = £0
    #  6 No CL. Over-delivery  - Variance within Limit
    #  7 No CL. Over-delivery  - Variance = Limit
    #  8 No CL. Over-delivery  - Variance exceeds Limit

    #  9 CL not capped. Under-delivery - Delivers nothing
    # 10 CL not capped. Under-delivery - Variance exceeds Tolerance
    # 11 CL not capped. Under-delivery - Variance = Tolerance
    # 12 CL not capped. Under-delivery - Variance within Tolerance
    # 13 CL not capped. Variance = £0
    # 14 CL not capped. Over-delivery  - Variance within Limit
    # 15 CL not capped. Over-delivery  - Variance = Limit
    # 16 CL not capped. Over-delivery  - Variance exceeds Limit

    # 17 CL capped to planned. Under-delivery - Variance exceeds Tolerance
    # 18 CL capped to planned. Under-delivery - Variance = Tolerance
    # 19 CL capped to planned. Under-delivery - Variance within Tolerance
    # 20 CL capped to planned. Variance = £0
    # 21 CL capped to planned. Over-delivery  - Variance within Limit
    # 22 CL capped to planned. Over-delivery  - Variance = Limit
    # 23 CL capped to planned. Over-delivery  - Variance exceeds Limit

    Given there are no Allocations in PaaS (Performance Management)

    And   the following debatched funding claims are received
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationGroupCode |
    | 10212201 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212202 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212203 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212204 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212205 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212206 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212207 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212208 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212209 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212210 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212211 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212212 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212213 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212214 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212215 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212216 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212217 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212218 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212219 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212220 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212221 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212222 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |
    | 10212223 | 1            | YEAR END      | AY         | 2122   | AEBC-ASCL2122       |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10212201 | 1            | YEAR END      | AY         | 2122   | AECA-2201     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212202 | 1            | YEAR END      | AY         | 2122   | AECA-2202     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212203 | 1            | YEAR END      | AY         | 2122   | AECA-2203     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212204 | 1            | YEAR END      | AY         | 2122   | AECA-2204     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212205 | 1            | YEAR END      | AY         | 2122   | AECA-2205     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212206 | 1            | YEAR END      | AY         | 2122   | AECA-2206     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212207 | 1            | YEAR END      | AY         | 2122   | AECA-2207     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212208 | 1            | YEAR END      | AY         | 2122   | AECA-2208     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212209 | 1            | YEAR END      | AY         | 2122   | AECA-2209     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212210 | 1            | YEAR END      | AY         | 2122   | AECA-2210     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212211 | 1            | YEAR END      | AY         | 2122   | AECA-2211     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212212 | 1            | YEAR END      | AY         | 2122   | AECA-2212     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212213 | 1            | YEAR END      | AY         | 2122   | AECA-2213     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212214 | 1            | YEAR END      | AY         | 2122   | AECA-2214     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212215 | 1            | YEAR END      | AY         | 2122   | AECA-2215     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212216 | 1            | YEAR END      | AY         | 2122   | AECA-2216     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212217 | 1            | YEAR END      | AY         | 2122   | AECA-2217     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212218 | 1            | YEAR END      | AY         | 2122   | AECA-2218     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212219 | 1            | YEAR END      | AY         | 2122   | AECA-2219     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212220 | 1            | YEAR END      | AY         | 2122   | AECA-2220     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212221 | 1            | YEAR END      | AY         | 2122   | AECA-2221     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212222 | 1            | YEAR END      | AY         | 2122   | AECA-2222     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |
    | 10212223 | 1            | YEAR END      | AY         | 2122   | AECA-2223     | AEBC-ASCL2122       | AEBC-ASCL2122           | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10212201 | 1            | YEAR END      | AY         | 2122   | AECA-2201     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212201 | 1            | YEAR END      | AY         | 2122   | AECA-2201     | AEBC-ASCL2122           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212201 | 1            | YEAR END      | AY         | 2122   | AECA-2201     | AEBC-ASCL2122           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212201 | 1            | YEAR END      | AY         | 2122   | AECA-2201     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212201 | 1            | YEAR END      | AY         | 2122   | AECA-2201     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212201 | 1            | YEAR END      | AY         | 2122   | AECA-2201     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212201 | 1            | YEAR END      | AY         | 2122   | AECA-2201     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212201 | 1            | YEAR END      | AY         | 2122   | AECA-2201     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212201 | 1            | YEAR END      | AY         | 2122   | AECA-2201     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212201 | 1            | YEAR END      | AY         | 2122   | AECA-2201     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£0.00        
    | 10212202 | 1            | YEAR END      | AY         | 2122   | AECA-2202     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212202 | 1            | YEAR END      | AY         | 2122   | AECA-2202     | AEBC-ASCL2122           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212202 | 1            | YEAR END      | AY         | 2122   | AECA-2202     | AEBC-ASCL2122           | 2               | 9699.00     | 0.00          | 0.00            | 9699.00           | 10000.00     | 0.00               |
    | 10212202 | 1            | YEAR END      | AY         | 2122   | AECA-2202     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212202 | 1            | YEAR END      | AY         | 2122   | AECA-2202     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212202 | 1            | YEAR END      | AY         | 2122   | AECA-2202     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212202 | 1            | YEAR END      | AY         | 2122   | AECA-2202     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212202 | 1            | YEAR END      | AY         | 2122   | AECA-2202     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212202 | 1            | YEAR END      | AY         | 2122   | AECA-2202     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212202 | 1            | YEAR END      | AY         | 2122   | AECA-2202     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£9699.00     
    | 10212203 | 1            | YEAR END      | AY         | 2122   | AECA-2203     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212203 | 1            | YEAR END      | AY         | 2122   | AECA-2203     | AEBC-ASCL2122           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212203 | 1            | YEAR END      | AY         | 2122   | AECA-2203     | AEBC-ASCL2122           | 2               | 9700.00     | 0.00          | 0.00            | 9700.00           | 10000.00     | 0.00               |
    | 10212203 | 1            | YEAR END      | AY         | 2122   | AECA-2203     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212203 | 1            | YEAR END      | AY         | 2122   | AECA-2203     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212203 | 1            | YEAR END      | AY         | 2122   | AECA-2203     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212203 | 1            | YEAR END      | AY         | 2122   | AECA-2203     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212203 | 1            | YEAR END      | AY         | 2122   | AECA-2203     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212203 | 1            | YEAR END      | AY         | 2122   | AECA-2203     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212203 | 1            | YEAR END      | AY         | 2122   | AECA-2203     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£9700.00     
    | 10212204 | 1            | YEAR END      | AY         | 2122   | AECA-2204     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212204 | 1            | YEAR END      | AY         | 2122   | AECA-2204     | AEBC-ASCL2122           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212204 | 1            | YEAR END      | AY         | 2122   | AECA-2204     | AEBC-ASCL2122           | 2               | 9701.00     | 0.00          | 0.00            | 9701.00           | 10000.00     | 0.00               |
    | 10212204 | 1            | YEAR END      | AY         | 2122   | AECA-2204     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212204 | 1            | YEAR END      | AY         | 2122   | AECA-2204     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212204 | 1            | YEAR END      | AY         | 2122   | AECA-2204     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212204 | 1            | YEAR END      | AY         | 2122   | AECA-2204     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212204 | 1            | YEAR END      | AY         | 2122   | AECA-2204     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212204 | 1            | YEAR END      | AY         | 2122   | AECA-2204     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212204 | 1            | YEAR END      | AY         | 2122   | AECA-2204     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£9701.00     
    | 10212205 | 1            | YEAR END      | AY         | 2122   | AECA-2205     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212205 | 1            | YEAR END      | AY         | 2122   | AECA-2205     | AEBC-ASCL2122           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212205 | 1            | YEAR END      | AY         | 2122   | AECA-2205     | AEBC-ASCL2122           | 2               | 10000.00    | 0.00          | 0.00            | 10000.00          | 10000.00     | 0.00               |
    | 10212205 | 1            | YEAR END      | AY         | 2122   | AECA-2205     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212205 | 1            | YEAR END      | AY         | 2122   | AECA-2205     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212205 | 1            | YEAR END      | AY         | 2122   | AECA-2205     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212205 | 1            | YEAR END      | AY         | 2122   | AECA-2205     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212205 | 1            | YEAR END      | AY         | 2122   | AECA-2205     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212205 | 1            | YEAR END      | AY         | 2122   | AECA-2205     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212205 | 1            | YEAR END      | AY         | 2122   | AECA-2205     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£10000.00    
    | 10212206 | 1            | YEAR END      | AY         | 2122   | AECA-2206     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212206 | 1            | YEAR END      | AY         | 2122   | AECA-2206     | AEBC-ASCL2122           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212206 | 1            | YEAR END      | AY         | 2122   | AECA-2206     | AEBC-ASCL2122           | 2               | 10999.00    | 0.00          | 0.00            | 10999.00          | 10000.00     | 0.00               |
    | 10212206 | 1            | YEAR END      | AY         | 2122   | AECA-2206     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212206 | 1            | YEAR END      | AY         | 2122   | AECA-2206     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212206 | 1            | YEAR END      | AY         | 2122   | AECA-2206     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212206 | 1            | YEAR END      | AY         | 2122   | AECA-2206     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212206 | 1            | YEAR END      | AY         | 2122   | AECA-2206     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212206 | 1            | YEAR END      | AY         | 2122   | AECA-2206     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212206 | 1            | YEAR END      | AY         | 2122   | AECA-2206     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£10999.00    
    | 10212207 | 1            | YEAR END      | AY         | 2122   | AECA-2207     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212207 | 1            | YEAR END      | AY         | 2122   | AECA-2207     | AEBC-ASCL2122           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212207 | 1            | YEAR END      | AY         | 2122   | AECA-2207     | AEBC-ASCL2122           | 2               | 11000.00    | 0.00          | 0.00            | 11000.00          | 10000.00     | 0.00               |
    | 10212207 | 1            | YEAR END      | AY         | 2122   | AECA-2207     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212207 | 1            | YEAR END      | AY         | 2122   | AECA-2207     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212207 | 1            | YEAR END      | AY         | 2122   | AECA-2207     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212207 | 1            | YEAR END      | AY         | 2122   | AECA-2207     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212207 | 1            | YEAR END      | AY         | 2122   | AECA-2207     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212207 | 1            | YEAR END      | AY         | 2122   | AECA-2207     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212207 | 1            | YEAR END      | AY         | 2122   | AECA-2207     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£11000.00    
    | 10212208 | 1            | YEAR END      | AY         | 2122   | AECA-2208     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212208 | 1            | YEAR END      | AY         | 2122   | AECA-2208     | AEBC-ASCL2122           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212208 | 1            | YEAR END      | AY         | 2122   | AECA-2208     | AEBC-ASCL2122           | 2               | 11001.00    | 0.00          | 0.00            | 11001.00          | 10000.00     | 0.00               |
    | 10212208 | 1            | YEAR END      | AY         | 2122   | AECA-2208     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212208 | 1            | YEAR END      | AY         | 2122   | AECA-2208     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212208 | 1            | YEAR END      | AY         | 2122   | AECA-2208     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212208 | 1            | YEAR END      | AY         | 2122   | AECA-2208     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212208 | 1            | YEAR END      | AY         | 2122   | AECA-2208     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212208 | 1            | YEAR END      | AY         | 2122   | AECA-2208     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212208 | 1            | YEAR END      | AY         | 2122   | AECA-2208     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£11001.00    
    | 10212209 | 1            | YEAR END      | AY         | 2122   | AECA-2209     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212209 | 1            | YEAR END      | AY         | 2122   | AECA-2209     | AEBC-ASCL2122           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 800.00       | 0.00               |
    | 10212209 | 1            | YEAR END      | AY         | 2122   | AECA-2209     | AEBC-ASCL2122           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 0.00               |
    | 10212209 | 1            | YEAR END      | AY         | 2122   | AECA-2209     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212209 | 1            | YEAR END      | AY         | 2122   | AECA-2209     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212209 | 1            | YEAR END      | AY         | 2122   | AECA-2209     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212209 | 1            | YEAR END      | AY         | 2122   | AECA-2209     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212209 | 1            | YEAR END      | AY         | 2122   | AECA-2209     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212209 | 1            | YEAR END      | AY         | 2122   | AECA-2209     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212209 | 1            | YEAR END      | AY         | 2122   | AECA-2209     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£0.00        
    | 10212210 | 1            | YEAR END      | AY         | 2122   | AECA-2210     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212210 | 1            | YEAR END      | AY         | 2122   | AECA-2210     | AEBC-ASCL2122           | 5               | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 0.00               |
    | 10212210 | 1            | YEAR END      | AY         | 2122   | AECA-2210     | AEBC-ASCL2122           | 2               | 8999.00     | 0.00          | 0.00            | 8999.00           | 9200.00      | 0.00               |
    | 10212210 | 1            | YEAR END      | AY         | 2122   | AECA-2210     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212210 | 1            | YEAR END      | AY         | 2122   | AECA-2210     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212210 | 1            | YEAR END      | AY         | 2122   | AECA-2210     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212210 | 1            | YEAR END      | AY         | 2122   | AECA-2210     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212210 | 1            | YEAR END      | AY         | 2122   | AECA-2210     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212210 | 1            | YEAR END      | AY         | 2122   | AECA-2210     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212210 | 1            | YEAR END      | AY         | 2122   | AECA-2210     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£9699.00     
    | 10212211 | 1            | YEAR END      | AY         | 2122   | AECA-2211     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212211 | 1            | YEAR END      | AY         | 2122   | AECA-2211     | AEBC-ASCL2122           | 5               | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 0.00               |
    | 10212211 | 1            | YEAR END      | AY         | 2122   | AECA-2211     | AEBC-ASCL2122           | 2               | 9000.00     | 0.00          | 0.00            | 9000.00           | 9200.00      | 0.00               |
    | 10212211 | 1            | YEAR END      | AY         | 2122   | AECA-2211     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212211 | 1            | YEAR END      | AY         | 2122   | AECA-2211     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212211 | 1            | YEAR END      | AY         | 2122   | AECA-2211     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212211 | 1            | YEAR END      | AY         | 2122   | AECA-2211     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212211 | 1            | YEAR END      | AY         | 2122   | AECA-2211     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212211 | 1            | YEAR END      | AY         | 2122   | AECA-2211     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212211 | 1            | YEAR END      | AY         | 2122   | AECA-2211     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£9700.00     
    | 10212212 | 1            | YEAR END      | AY         | 2122   | AECA-2212     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212212 | 1            | YEAR END      | AY         | 2122   | AECA-2212     | AEBC-ASCL2122           | 5               | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 0.00               |
    | 10212212 | 1            | YEAR END      | AY         | 2122   | AECA-2212     | AEBC-ASCL2122           | 2               | 9001.00     | 0.00          | 0.00            | 9001.00           | 9200.00      | 0.00               |
    | 10212212 | 1            | YEAR END      | AY         | 2122   | AECA-2212     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212212 | 1            | YEAR END      | AY         | 2122   | AECA-2212     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212212 | 1            | YEAR END      | AY         | 2122   | AECA-2212     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212212 | 1            | YEAR END      | AY         | 2122   | AECA-2212     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212212 | 1            | YEAR END      | AY         | 2122   | AECA-2212     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212212 | 1            | YEAR END      | AY         | 2122   | AECA-2212     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212212 | 1            | YEAR END      | AY         | 2122   | AECA-2212     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£9701.00     
    | 10212213 | 1            | YEAR END      | AY         | 2122   | AECA-2213     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212213 | 1            | YEAR END      | AY         | 2122   | AECA-2213     | AEBC-ASCL2122           | 5               | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 0.00               |
    | 10212213 | 1            | YEAR END      | AY         | 2122   | AECA-2213     | AEBC-ASCL2122           | 2               | 9300.00     | 0.00          | 0.00            | 9300.00           | 9200.00      | 0.00               |
    | 10212213 | 1            | YEAR END      | AY         | 2122   | AECA-2213     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212213 | 1            | YEAR END      | AY         | 2122   | AECA-2213     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212213 | 1            | YEAR END      | AY         | 2122   | AECA-2213     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212213 | 1            | YEAR END      | AY         | 2122   | AECA-2213     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212213 | 1            | YEAR END      | AY         | 2122   | AECA-2213     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212213 | 1            | YEAR END      | AY         | 2122   | AECA-2213     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212213 | 1            | YEAR END      | AY         | 2122   | AECA-2213     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£10000.00    
    | 10212214 | 1            | YEAR END      | AY         | 2122   | AECA-2214     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212214 | 1            | YEAR END      | AY         | 2122   | AECA-2214     | AEBC-ASCL2122           | 5               | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 0.00               |
    | 10212214 | 1            | YEAR END      | AY         | 2122   | AECA-2214     | AEBC-ASCL2122           | 2               | 10299.00    | 0.00          | 0.00            | 10299.00          | 9200.00      | 0.00               |
    | 10212214 | 1            | YEAR END      | AY         | 2122   | AECA-2214     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212214 | 1            | YEAR END      | AY         | 2122   | AECA-2214     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212214 | 1            | YEAR END      | AY         | 2122   | AECA-2214     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212214 | 1            | YEAR END      | AY         | 2122   | AECA-2214     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212214 | 1            | YEAR END      | AY         | 2122   | AECA-2214     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212214 | 1            | YEAR END      | AY         | 2122   | AECA-2214     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212214 | 1            | YEAR END      | AY         | 2122   | AECA-2214     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£10999.00    
    | 10212215 | 1            | YEAR END      | AY         | 2122   | AECA-2215     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212215 | 1            | YEAR END      | AY         | 2122   | AECA-2215     | AEBC-ASCL2122           | 5               | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 0.00               |
    | 10212215 | 1            | YEAR END      | AY         | 2122   | AECA-2215     | AEBC-ASCL2122           | 2               | 10300.00    | 0.00          | 0.00            | 10300.00          | 9200.00      | 0.00               |
    | 10212215 | 1            | YEAR END      | AY         | 2122   | AECA-2215     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212215 | 1            | YEAR END      | AY         | 2122   | AECA-2215     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212215 | 1            | YEAR END      | AY         | 2122   | AECA-2215     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212215 | 1            | YEAR END      | AY         | 2122   | AECA-2215     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212215 | 1            | YEAR END      | AY         | 2122   | AECA-2215     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212215 | 1            | YEAR END      | AY         | 2122   | AECA-2215     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212215 | 1            | YEAR END      | AY         | 2122   | AECA-2215     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£11000.00    
    | 10212216 | 1            | YEAR END      | AY         | 2122   | AECA-2216     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212216 | 1            | YEAR END      | AY         | 2122   | AECA-2216     | AEBC-ASCL2122           | 5               | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 0.00               |
    | 10212216 | 1            | YEAR END      | AY         | 2122   | AECA-2216     | AEBC-ASCL2122           | 2               | 10301.00    | 0.00          | 0.00            | 10301.00          | 9200.00      | 0.00               |
    | 10212216 | 1            | YEAR END      | AY         | 2122   | AECA-2216     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212216 | 1            | YEAR END      | AY         | 2122   | AECA-2216     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212216 | 1            | YEAR END      | AY         | 2122   | AECA-2216     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212216 | 1            | YEAR END      | AY         | 2122   | AECA-2216     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212216 | 1            | YEAR END      | AY         | 2122   | AECA-2216     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212216 | 1            | YEAR END      | AY         | 2122   | AECA-2216     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212216 | 1            | YEAR END      | AY         | 2122   | AECA-2216     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£11001.00    
    | 10212217 | 1            | YEAR END      | AY         | 2122   | AECA-2217     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212217 | 1            | YEAR END      | AY         | 2122   | AECA-2217     | AEBC-ASCL2122           | 5               | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 0.00               |
    | 10212217 | 1            | YEAR END      | AY         | 2122   | AECA-2217     | AEBC-ASCL2122           | 2               | 8899.00     | 0.00          | 0.00            | 8899.00           | 9200.00      | 0.00               |
    | 10212217 | 1            | YEAR END      | AY         | 2122   | AECA-2217     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212217 | 1            | YEAR END      | AY         | 2122   | AECA-2217     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212217 | 1            | YEAR END      | AY         | 2122   | AECA-2217     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212217 | 1            | YEAR END      | AY         | 2122   | AECA-2217     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212217 | 1            | YEAR END      | AY         | 2122   | AECA-2217     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212217 | 1            | YEAR END      | AY         | 2122   | AECA-2217     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212217 | 1            | YEAR END      | AY         | 2122   | AECA-2217     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£9799.00     
    | 10212218 | 1            | YEAR END      | AY         | 2122   | AECA-2218     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212218 | 1            | YEAR END      | AY         | 2122   | AECA-2218     | AEBC-ASCL2122           | 5               | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 0.00               |
    | 10212218 | 1            | YEAR END      | AY         | 2122   | AECA-2218     | AEBC-ASCL2122           | 2               | 8900.00     | 0.00          | 0.00            | 8900.00           | 9200.00      | 0.00               |
    | 10212218 | 1            | YEAR END      | AY         | 2122   | AECA-2218     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212218 | 1            | YEAR END      | AY         | 2122   | AECA-2218     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212218 | 1            | YEAR END      | AY         | 2122   | AECA-2218     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212218 | 1            | YEAR END      | AY         | 2122   | AECA-2218     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212218 | 1            | YEAR END      | AY         | 2122   | AECA-2218     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212218 | 1            | YEAR END      | AY         | 2122   | AECA-2218     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212218 | 1            | YEAR END      | AY         | 2122   | AECA-2218     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£9800.00     
    | 10212219 | 1            | YEAR END      | AY         | 2122   | AECA-2219     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212219 | 1            | YEAR END      | AY         | 2122   | AECA-2219     | AEBC-ASCL2122           | 5               | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 0.00               |
    | 10212219 | 1            | YEAR END      | AY         | 2122   | AECA-2219     | AEBC-ASCL2122           | 2               | 8901.00     | 0.00          | 0.00            | 8901.00           | 9200.00      | 0.00               |
    | 10212219 | 1            | YEAR END      | AY         | 2122   | AECA-2219     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212219 | 1            | YEAR END      | AY         | 2122   | AECA-2219     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212219 | 1            | YEAR END      | AY         | 2122   | AECA-2219     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212219 | 1            | YEAR END      | AY         | 2122   | AECA-2219     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212219 | 1            | YEAR END      | AY         | 2122   | AECA-2219     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212219 | 1            | YEAR END      | AY         | 2122   | AECA-2219     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212219 | 1            | YEAR END      | AY         | 2122   | AECA-2219     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£9801.00     
    | 10212220 | 1            | YEAR END      | AY         | 2122   | AECA-2220     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212220 | 1            | YEAR END      | AY         | 2122   | AECA-2220     | AEBC-ASCL2122           | 5               | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 0.00               |
    | 10212220 | 1            | YEAR END      | AY         | 2122   | AECA-2220     | AEBC-ASCL2122           | 2               | 9200.00     | 0.00          | 0.00            | 9200.00           | 9200.00      | 0.00               |
    | 10212220 | 1            | YEAR END      | AY         | 2122   | AECA-2220     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212220 | 1            | YEAR END      | AY         | 2122   | AECA-2220     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212220 | 1            | YEAR END      | AY         | 2122   | AECA-2220     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212220 | 1            | YEAR END      | AY         | 2122   | AECA-2220     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212220 | 1            | YEAR END      | AY         | 2122   | AECA-2220     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212220 | 1            | YEAR END      | AY         | 2122   | AECA-2220     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212220 | 1            | YEAR END      | AY         | 2122   | AECA-2220     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£10100.00    
    | 10212221 | 1            | YEAR END      | AY         | 2122   | AECA-2221     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212221 | 1            | YEAR END      | AY         | 2122   | AECA-2221     | AEBC-ASCL2122           | 5               | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 0.00               |
    | 10212221 | 1            | YEAR END      | AY         | 2122   | AECA-2221     | AEBC-ASCL2122           | 2               | 10199.00    | 0.00          | 0.00            | 10199.00          | 9200.00      | 0.00               |
    | 10212221 | 1            | YEAR END      | AY         | 2122   | AECA-2221     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212221 | 1            | YEAR END      | AY         | 2122   | AECA-2221     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212221 | 1            | YEAR END      | AY         | 2122   | AECA-2221     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212221 | 1            | YEAR END      | AY         | 2122   | AECA-2221     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212221 | 1            | YEAR END      | AY         | 2122   | AECA-2221     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212221 | 1            | YEAR END      | AY         | 2122   | AECA-2221     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212221 | 1            | YEAR END      | AY         | 2122   | AECA-2221     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£11099.00    
    | 10212222 | 1            | YEAR END      | AY         | 2122   | AECA-2222     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212222 | 1            | YEAR END      | AY         | 2122   | AECA-2222     | AEBC-ASCL2122           | 5               | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 0.00               |
    | 10212222 | 1            | YEAR END      | AY         | 2122   | AECA-2222     | AEBC-ASCL2122           | 2               | 10200.00    | 0.00          | 0.00            | 10200.00          | 9200.00      | 0.00               |
    | 10212222 | 1            | YEAR END      | AY         | 2122   | AECA-2222     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212222 | 1            | YEAR END      | AY         | 2122   | AECA-2222     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212222 | 1            | YEAR END      | AY         | 2122   | AECA-2222     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212222 | 1            | YEAR END      | AY         | 2122   | AECA-2222     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212222 | 1            | YEAR END      | AY         | 2122   | AECA-2222     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212222 | 1            | YEAR END      | AY         | 2122   | AECA-2222     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212222 | 1            | YEAR END      | AY         | 2122   | AECA-2222     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£11100.00    
    | 10212223 | 1            | YEAR END      | AY         | 2122   | AECA-2223     | AEBC-ASCL2122           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212223 | 1            | YEAR END      | AY         | 2122   | AECA-2223     | AEBC-ASCL2122           | 5               | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 0.00               |
    | 10212223 | 1            | YEAR END      | AY         | 2122   | AECA-2223     | AEBC-ASCL2122           | 2               | 10201.00    | 0.00          | 0.00            | 10201.00          | 9200.00      | 0.00               |
    | 10212223 | 1            | YEAR END      | AY         | 2122   | AECA-2223     | AEBC-ASCL2122           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212223 | 1            | YEAR END      | AY         | 2122   | AECA-2223     | AEBC-ASCL2122           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212223 | 1            | YEAR END      | AY         | 2122   | AECA-2223     | AEBC-ASCL2122           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212223 | 1            | YEAR END      | AY         | 2122   | AECA-2223     | AEBC-ASCL2122           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212223 | 1            | YEAR END      | AY         | 2122   | AECA-2223     | AEBC-ASCL2122           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212223 | 1            | YEAR END      | AY         | 2122   | AECA-2223     | AEBC-ASCL2122           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    | 10212223 | 1            | YEAR END      | AY         | 2122   | AECA-2223     | AEBC-ASCL2122           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 0.00               |
    #                                                                                                                                                                      Total=£11101.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10212201 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10212202 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 9699.00      | 9699.00          | -301.00                     | -301.00             |
    | 10212203 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 9700.00      | 9700.00          | 0.00                        | 0.00                |
    | 10212204 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 9701.00      | 9701.00          | 0.00                        | 0.00                |
    | 10212205 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10212206 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 10999.00     | 10999.00         | 999.00                      | 999.00              |
    | 10212207 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 11000.00     | 11000.00         | 1000.00                     | 1000.00             |
    | 10212208 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 11001.00     | 11001.00         | 1000.00                     | 1000.00             |
    | 10212209 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10212210 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 9699.00      | 9699.00          | -301.00                     | -301.00             |
    | 10212211 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 9700.00      | 9700.00          | 0.00                        | 0.00                |
    | 10212212 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 9701.00      | 9701.00          | 0.00                        | 0.00                |
    | 10212213 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10212214 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 10999.00     | 10999.00         | 999.00                      | 999.00              |
    | 10212215 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 11000.00     | 11000.00         | 1000.00                     | 1000.00             |
    | 10212216 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 11001.00     | 11001.00         | 1000.00                     | 1000.00             |
    | 10212217 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 9799.00      | 9699.00          | -301.00                     | -301.00             |
    | 10212218 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 9800.00      | 9700.00          | 0.00                        | 0.00                |
    | 10212219 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 9801.00      | 9701.00          | 0.00                        | 0.00                |
    | 10212220 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 10100.00     | 10000.00         | 0.00                        | 0.00                |
    | 10212221 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 11099.00     | 10999.00         | 999.00                      | 999.00              |
    | 10212222 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 11100.00     | 11000.00         | 1000.00                     | 1000.00             |
    | 10212223 | 2122          | YEAR END        | AEBC-ASCL2122       | 10000.00     | 11101.00     | 11001.00         | 1000.00                     | 1000.00             |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10212201 | 2122          | YEAR END        | AECA-2201           | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10212202 | 2122          | YEAR END        | AECA-2202           | 10000.00     | 9699.00      | 9699.00          | -301.00                     | -301.00             |
    | 10212203 | 2122          | YEAR END        | AECA-2203           | 10000.00     | 9700.00      | 9700.00          | 0.00                        | 0.00                |
    | 10212204 | 2122          | YEAR END        | AECA-2204           | 10000.00     | 9701.00      | 9701.00          | 0.00                        | 0.00                |
    | 10212205 | 2122          | YEAR END        | AECA-2205           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10212206 | 2122          | YEAR END        | AECA-2206           | 10000.00     | 10999.00     | 10999.00         | 999.00                      | 999.00              |
    | 10212207 | 2122          | YEAR END        | AECA-2207           | 10000.00     | 11000.00     | 11000.00         | 1000.00                     | 1000.00             |
    | 10212208 | 2122          | YEAR END        | AECA-2208           | 10000.00     | 11001.00     | 11001.00         | 1000.00                     | 1000.00             |
    | 10212209 | 2122          | YEAR END        | AECA-2209           | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10212210 | 2122          | YEAR END        | AECA-2210           | 10000.00     | 9699.00      | 9699.00          | -301.00                     | -301.00             |
    | 10212211 | 2122          | YEAR END        | AECA-2211           | 10000.00     | 9700.00      | 9700.00          | 0.00                        | 0.00                |
    | 10212212 | 2122          | YEAR END        | AECA-2212           | 10000.00     | 9701.00      | 9701.00          | 0.00                        | 0.00                |
    | 10212213 | 2122          | YEAR END        | AECA-2213           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10212214 | 2122          | YEAR END        | AECA-2214           | 10000.00     | 10999.00     | 10999.00         | 999.00                      | 999.00              |
    | 10212215 | 2122          | YEAR END        | AECA-2215           | 10000.00     | 11000.00     | 11000.00         | 1000.00                     | 1000.00             |
    | 10212216 | 2122          | YEAR END        | AECA-2216           | 10000.00     | 11001.00     | 11001.00         | 1000.00                     | 1000.00             |
    | 10212217 | 2122          | YEAR END        | AECA-2217           | 10000.00     | 9799.00      | 9699.00          | -301.00                     | -301.00             |
    | 10212218 | 2122          | YEAR END        | AECA-2218           | 10000.00     | 9800.00      | 9700.00          | 0.00                        | 0.00                |
    | 10212219 | 2122          | YEAR END        | AECA-2219           | 10000.00     | 9801.00      | 9701.00          | 0.00                        | 0.00                |
    | 10212220 | 2122          | YEAR END        | AECA-2220           | 10000.00     | 10100.00     | 10000.00         | 0.00                        | 0.00                |
    | 10212221 | 2122          | YEAR END        | AECA-2221           | 10000.00     | 11099.00     | 10999.00         | 999.00                      | 999.00              |
    | 10212222 | 2122          | YEAR END        | AECA-2222           | 10000.00     | 11100.00     | 11000.00         | 1000.00                     | 1000.00             |
    | 10212223 | 2122          | YEAR END        | AECA-2223           | 10000.00     | 11101.00     | 11001.00         | 1000.00                     | 1000.00             |

@DoNotRun_7Mar2024 
@FundingClaimCalculation
Scenario: D582 Year-End Funding Claim Reconciliation Calculations for AEBC-19TRN2122

    # 24 Under-delivery - Delivers nothing
    # 25 Under-delivery - Variance exceeds Tolerance
    # 26 Under-delivery - Variance = Tolerance
    # 27 Under-delivery - Variance within Tolerance
    # 28 Variance = £0
    # 29 Over-delivery  - Variance within Limit
    # 30 Over-delivery  - Variance = Limit
    # 31 Over-delivery  - Variance exceeds Limit

    Given there are no Allocations in PaaS (Performance Management)

    And   the following debatched funding claims are received
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationGroupCode |
    | 10212224 | 1            | YEAR END      | AY         | 2122   | AEBC-19TRN2122      |
    | 10212225 | 1            | YEAR END      | AY         | 2122   | AEBC-19TRN2122      |
    | 10212226 | 1            | YEAR END      | AY         | 2122   | AEBC-19TRN2122      |
    | 10212227 | 1            | YEAR END      | AY         | 2122   | AEBC-19TRN2122      |
    | 10212228 | 1            | YEAR END      | AY         | 2122   | AEBC-19TRN2122      |
    | 10212229 | 1            | YEAR END      | AY         | 2122   | AEBC-19TRN2122      |
    | 10212230 | 1            | YEAR END      | AY         | 2122   | AEBC-19TRN2122      |
    | 10212231 | 1            | YEAR END      | AY         | 2122   | AEBC-19TRN2122      |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10212224 | 1            | YEAR END      | AY         | 2122   | AECT-2224     | AEBC-19TRN2122      | AEBC-19TRN2122          | 10000.00        |
    | 10212225 | 1            | YEAR END      | AY         | 2122   | AECT-2225     | AEBC-19TRN2122      | AEBC-19TRN2122          | 10000.00        |
    | 10212226 | 1            | YEAR END      | AY         | 2122   | AECT-2226     | AEBC-19TRN2122      | AEBC-19TRN2122          | 10000.00        |
    | 10212227 | 1            | YEAR END      | AY         | 2122   | AECT-2227     | AEBC-19TRN2122      | AEBC-19TRN2122          | 10000.00        |
    | 10212228 | 1            | YEAR END      | AY         | 2122   | AECT-2228     | AEBC-19TRN2122      | AEBC-19TRN2122          | 10000.00        |
    | 10212229 | 1            | YEAR END      | AY         | 2122   | AECT-2229     | AEBC-19TRN2122      | AEBC-19TRN2122          | 10000.00        |
    | 10212230 | 1            | YEAR END      | AY         | 2122   | AECT-2230     | AEBC-19TRN2122      | AEBC-19TRN2122          | 10000.00        |
    | 10212231 | 1            | YEAR END      | AY         | 2122   | AECT-2231     | AEBC-19TRN2122      | AEBC-19TRN2122          | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10212224 | 1            | YEAR END      | AY         | 2122   | AECT-2224     | AEBC-19TRN2122          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212224 | 1            | YEAR END      | AY         | 2122   | AECT-2224     | AEBC-19TRN2122          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212224 | 1            | YEAR END      | AY         | 2122   | AECT-2224     | AEBC-19TRN2122          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212224 | 1            | YEAR END      | AY         | 2122   | AECT-2224     | AEBC-19TRN2122          | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212224 | 1            | YEAR END      | AY         | 2122   | AECT-2224     | AEBC-19TRN2122          | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212224 | 1            | YEAR END      | AY         | 2122   | AECT-2224     | AEBC-19TRN2122          | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212224 | 1            | YEAR END      | AY         | 2122   | AECT-2224     | AEBC-19TRN2122          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£0.00        
    | 10212225 | 1            | YEAR END      | AY         | 2122   | AECT-2225     | AEBC-19TRN2122          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212225 | 1            | YEAR END      | AY         | 2122   | AECT-2225     | AEBC-19TRN2122          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212225 | 1            | YEAR END      | AY         | 2122   | AECT-2225     | AEBC-19TRN2122          | 3               | 9699.00     | 0.00          | 0.00            | 9699.00           | 0.00         | 10000.00           |
    | 10212225 | 1            | YEAR END      | AY         | 2122   | AECT-2225     | AEBC-19TRN2122          | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212225 | 1            | YEAR END      | AY         | 2122   | AECT-2225     | AEBC-19TRN2122          | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212225 | 1            | YEAR END      | AY         | 2122   | AECT-2225     | AEBC-19TRN2122          | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212225 | 1            | YEAR END      | AY         | 2122   | AECT-2225     | AEBC-19TRN2122          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9699.00     
    | 10212226 | 1            | YEAR END      | AY         | 2122   | AECT-2226     | AEBC-19TRN2122          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212226 | 1            | YEAR END      | AY         | 2122   | AECT-2226     | AEBC-19TRN2122          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212226 | 1            | YEAR END      | AY         | 2122   | AECT-2226     | AEBC-19TRN2122          | 3               | 9700.00     | 0.00          | 0.00            | 9700.00           | 0.00         | 10000.00           |
    | 10212226 | 1            | YEAR END      | AY         | 2122   | AECT-2226     | AEBC-19TRN2122          | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212226 | 1            | YEAR END      | AY         | 2122   | AECT-2226     | AEBC-19TRN2122          | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212226 | 1            | YEAR END      | AY         | 2122   | AECT-2226     | AEBC-19TRN2122          | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212226 | 1            | YEAR END      | AY         | 2122   | AECT-2226     | AEBC-19TRN2122          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9700.00     
    | 10212227 | 1            | YEAR END      | AY         | 2122   | AECT-2227     | AEBC-19TRN2122          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212227 | 1            | YEAR END      | AY         | 2122   | AECT-2227     | AEBC-19TRN2122          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212227 | 1            | YEAR END      | AY         | 2122   | AECT-2227     | AEBC-19TRN2122          | 3               | 9701.00     | 0.00          | 0.00            | 9701.00           | 0.00         | 10000.00           |
    | 10212227 | 1            | YEAR END      | AY         | 2122   | AECT-2227     | AEBC-19TRN2122          | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212227 | 1            | YEAR END      | AY         | 2122   | AECT-2227     | AEBC-19TRN2122          | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212227 | 1            | YEAR END      | AY         | 2122   | AECT-2227     | AEBC-19TRN2122          | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212227 | 1            | YEAR END      | AY         | 2122   | AECT-2227     | AEBC-19TRN2122          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9701.00     
    | 10212228 | 1            | YEAR END      | AY         | 2122   | AECT-2228     | AEBC-19TRN2122          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212228 | 1            | YEAR END      | AY         | 2122   | AECT-2228     | AEBC-19TRN2122          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212228 | 1            | YEAR END      | AY         | 2122   | AECT-2228     | AEBC-19TRN2122          | 3               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 10000.00           |
    | 10212228 | 1            | YEAR END      | AY         | 2122   | AECT-2228     | AEBC-19TRN2122          | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212228 | 1            | YEAR END      | AY         | 2122   | AECT-2228     | AEBC-19TRN2122          | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212228 | 1            | YEAR END      | AY         | 2122   | AECT-2228     | AEBC-19TRN2122          | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212228 | 1            | YEAR END      | AY         | 2122   | AECT-2228     | AEBC-19TRN2122          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10000.00    
    | 10212229 | 1            | YEAR END      | AY         | 2122   | AECT-2229     | AEBC-19TRN2122          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212229 | 1            | YEAR END      | AY         | 2122   | AECT-2229     | AEBC-19TRN2122          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212229 | 1            | YEAR END      | AY         | 2122   | AECT-2229     | AEBC-19TRN2122          | 3               | 10999.00    | 0.00          | 0.00            | 10999.00          | 0.00         | 10000.00           |
    | 10212229 | 1            | YEAR END      | AY         | 2122   | AECT-2229     | AEBC-19TRN2122          | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212229 | 1            | YEAR END      | AY         | 2122   | AECT-2229     | AEBC-19TRN2122          | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212229 | 1            | YEAR END      | AY         | 2122   | AECT-2229     | AEBC-19TRN2122          | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212229 | 1            | YEAR END      | AY         | 2122   | AECT-2229     | AEBC-19TRN2122          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10999.00    
    | 10212230 | 1            | YEAR END      | AY         | 2122   | AECT-2230     | AEBC-19TRN2122          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212230 | 1            | YEAR END      | AY         | 2122   | AECT-2230     | AEBC-19TRN2122          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212230 | 1            | YEAR END      | AY         | 2122   | AECT-2230     | AEBC-19TRN2122          | 3               | 11000.00    | 0.00          | 0.00            | 11000.00          | 0.00         | 10000.00           |
    | 10212230 | 1            | YEAR END      | AY         | 2122   | AECT-2230     | AEBC-19TRN2122          | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212230 | 1            | YEAR END      | AY         | 2122   | AECT-2230     | AEBC-19TRN2122          | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212230 | 1            | YEAR END      | AY         | 2122   | AECT-2230     | AEBC-19TRN2122          | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212230 | 1            | YEAR END      | AY         | 2122   | AECT-2230     | AEBC-19TRN2122          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£11000.00    
    | 10212231 | 1            | YEAR END      | AY         | 2122   | AECT-2231     | AEBC-19TRN2122          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212231 | 1            | YEAR END      | AY         | 2122   | AECT-2231     | AEBC-19TRN2122          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212231 | 1            | YEAR END      | AY         | 2122   | AECT-2231     | AEBC-19TRN2122          | 3               | 11001.00    | 0.00          | 0.00            | 11001.00          | 0.00         | 10000.00           |
    | 10212231 | 1            | YEAR END      | AY         | 2122   | AECT-2231     | AEBC-19TRN2122          | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212231 | 1            | YEAR END      | AY         | 2122   | AECT-2231     | AEBC-19TRN2122          | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212231 | 1            | YEAR END      | AY         | 2122   | AECT-2231     | AEBC-19TRN2122          | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212231 | 1            | YEAR END      | AY         | 2122   | AECT-2231     | AEBC-19TRN2122          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£11001.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10212224 | 2122          | YEAR END        | AEBC-19TRN2122      | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10212225 | 2122          | YEAR END        | AEBC-19TRN2122      | 10000.00     | 9699.00      | 9699.00          | -301.00                     | -301.00             |
    | 10212226 | 2122          | YEAR END        | AEBC-19TRN2122      | 10000.00     | 9700.00      | 9700.00          | 0.00                        | 0.00                |
    | 10212227 | 2122          | YEAR END        | AEBC-19TRN2122      | 10000.00     | 9701.00      | 9701.00          | 0.00                        | 0.00                |
    | 10212228 | 2122          | YEAR END        | AEBC-19TRN2122      | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10212229 | 2122          | YEAR END        | AEBC-19TRN2122      | 10000.00     | 10999.00     | 10999.00         | 999.00                      | 999.00              |
    | 10212230 | 2122          | YEAR END        | AEBC-19TRN2122      | 10000.00     | 11000.00     | 11000.00         | 1000.00                     | 1000.00             |
    | 10212231 | 2122          | YEAR END        | AEBC-19TRN2122      | 10000.00     | 11001.00     | 11001.00         | 1000.00                     | 1000.00             |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10212224 | 2122          | YEAR END        | AECT-2224           | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10212225 | 2122          | YEAR END        | AECT-2225           | 10000.00     | 9699.00      | 9699.00          | -301.00                     | -301.00             |
    | 10212226 | 2122          | YEAR END        | AECT-2226           | 10000.00     | 9700.00      | 9700.00          | 0.00                        | 0.00                |
    | 10212227 | 2122          | YEAR END        | AECT-2227           | 10000.00     | 9701.00      | 9701.00          | 0.00                        | 0.00                |
    | 10212228 | 2122          | YEAR END        | AECT-2228           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10212229 | 2122          | YEAR END        | AECT-2229           | 10000.00     | 10999.00     | 10999.00         | 999.00                      | 999.00              |
    | 10212230 | 2122          | YEAR END        | AECT-2230           | 10000.00     | 11000.00     | 11000.00         | 1000.00                     | 1000.00             |
    | 10212231 | 2122          | YEAR END        | AECT-2231           | 10000.00     | 11001.00     | 11001.00         | 1000.00                     | 1000.00             |

@DoNotRun_7Mar2024 
@FundingClaimCalculation
Scenario: D583 Year-End Funding Claim Reconciliation Calculations for AEBC-NSF2122

    # 32 Under-delivery - Delivers nothing
    # 33 Under-delivery - Variance exceeds Tolerance
    # 34 Under-delivery - Variance = Tolerance
    # 35 Under-delivery - Variance within Tolerance
    # 36 Variance = £0
    # 37 Over-delivery  - Variance within Limit
    # 38 Over-delivery  - Variance = Limit
    # 39 Over-delivery  - Variance exceeds Limit

    Given there are no Allocations in PaaS (Performance Management)

    And   the following debatched funding claims are received
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationGroupCode |
    | 10212232 | 1            | YEAR END      | AY         | 2122   | AEBC-NSF2122        |
    | 10212233 | 1            | YEAR END      | AY         | 2122   | AEBC-NSF2122        |
    | 10212234 | 1            | YEAR END      | AY         | 2122   | AEBC-NSF2122        |
    | 10212235 | 1            | YEAR END      | AY         | 2122   | AEBC-NSF2122        |
    | 10212236 | 1            | YEAR END      | AY         | 2122   | AEBC-NSF2122        |
    | 10212237 | 1            | YEAR END      | AY         | 2122   | AEBC-NSF2122        |
    | 10212238 | 1            | YEAR END      | AY         | 2122   | AEBC-NSF2122        |
    | 10212239 | 1            | YEAR END      | AY         | 2122   | AEBC-NSF2122        |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10212232 | 1            | YEAR END      | AY         | 2122   | NSFC-2232     | AEBC-NSF2122        | AEBC-NSF2122            | 10000.00        |
    | 10212233 | 1            | YEAR END      | AY         | 2122   | NSFC-2233     | AEBC-NSF2122        | AEBC-NSF2122            | 10000.00        |
    | 10212234 | 1            | YEAR END      | AY         | 2122   | NSFC-2234     | AEBC-NSF2122        | AEBC-NSF2122            | 10000.00        |
    | 10212235 | 1            | YEAR END      | AY         | 2122   | NSFC-2235     | AEBC-NSF2122        | AEBC-NSF2122            | 10000.00        |
    | 10212236 | 1            | YEAR END      | AY         | 2122   | NSFC-2236     | AEBC-NSF2122        | AEBC-NSF2122            | 10000.00        |
    | 10212237 | 1            | YEAR END      | AY         | 2122   | NSFC-2237     | AEBC-NSF2122        | AEBC-NSF2122            | 10000.00        |
    | 10212238 | 1            | YEAR END      | AY         | 2122   | NSFC-2238     | AEBC-NSF2122        | AEBC-NSF2122            | 10000.00        |
    | 10212239 | 1            | YEAR END      | AY         | 2122   | NSFC-2239     | AEBC-NSF2122        | AEBC-NSF2122            | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10212232 | 1            | YEAR END      | AY         | 2122   | NSFC-2232     | AEBC-NSF2122            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212232 | 1            | YEAR END      | AY         | 2122   | NSFC-2232     | AEBC-NSF2122            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10212232 | 1            | YEAR END      | AY         | 2122   | NSFC-2232     | AEBC-NSF2122            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212232 | 1            | YEAR END      | AY         | 2122   | NSFC-2232     | AEBC-NSF2122            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212232 | 1            | YEAR END      | AY         | 2122   | NSFC-2232     | AEBC-NSF2122            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212232 | 1            | YEAR END      | AY         | 2122   | NSFC-2232     | AEBC-NSF2122            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212232 | 1            | YEAR END      | AY         | 2122   | NSFC-2232     | AEBC-NSF2122            | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212232 | 1            | YEAR END      | AY         | 2122   | NSFC-2232     | AEBC-NSF2122            | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£0.00        
    | 10212233 | 1            | YEAR END      | AY         | 2122   | NSFC-2233     | AEBC-NSF2122            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212233 | 1            | YEAR END      | AY         | 2122   | NSFC-2233     | AEBC-NSF2122            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10212233 | 1            | YEAR END      | AY         | 2122   | NSFC-2233     | AEBC-NSF2122            | 3               | 9699.00     | 0.00          | 0.00            | 9699.00           | 0.00         | 10000.00           |
    | 10212233 | 1            | YEAR END      | AY         | 2122   | NSFC-2233     | AEBC-NSF2122            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212233 | 1            | YEAR END      | AY         | 2122   | NSFC-2233     | AEBC-NSF2122            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212233 | 1            | YEAR END      | AY         | 2122   | NSFC-2233     | AEBC-NSF2122            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212233 | 1            | YEAR END      | AY         | 2122   | NSFC-2233     | AEBC-NSF2122            | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212233 | 1            | YEAR END      | AY         | 2122   | NSFC-2233     | AEBC-NSF2122            | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9699.00     
    | 10212234 | 1            | YEAR END      | AY         | 2122   | NSFC-2234     | AEBC-NSF2122            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212234 | 1            | YEAR END      | AY         | 2122   | NSFC-2234     | AEBC-NSF2122            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10212234 | 1            | YEAR END      | AY         | 2122   | NSFC-2234     | AEBC-NSF2122            | 3               | 9700.00     | 0.00          | 0.00            | 9700.00           | 0.00         | 10000.00           |
    | 10212234 | 1            | YEAR END      | AY         | 2122   | NSFC-2234     | AEBC-NSF2122            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212234 | 1            | YEAR END      | AY         | 2122   | NSFC-2234     | AEBC-NSF2122            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212234 | 1            | YEAR END      | AY         | 2122   | NSFC-2234     | AEBC-NSF2122            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212234 | 1            | YEAR END      | AY         | 2122   | NSFC-2234     | AEBC-NSF2122            | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212234 | 1            | YEAR END      | AY         | 2122   | NSFC-2234     | AEBC-NSF2122            | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9700.00     
    | 10212235 | 1            | YEAR END      | AY         | 2122   | NSFC-2235     | AEBC-NSF2122            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212235 | 1            | YEAR END      | AY         | 2122   | NSFC-2235     | AEBC-NSF2122            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10212235 | 1            | YEAR END      | AY         | 2122   | NSFC-2235     | AEBC-NSF2122            | 3               | 9701.00     | 0.00          | 0.00            | 9701.00           | 0.00         | 10000.00           |
    | 10212235 | 1            | YEAR END      | AY         | 2122   | NSFC-2235     | AEBC-NSF2122            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212235 | 1            | YEAR END      | AY         | 2122   | NSFC-2235     | AEBC-NSF2122            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212235 | 1            | YEAR END      | AY         | 2122   | NSFC-2235     | AEBC-NSF2122            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212235 | 1            | YEAR END      | AY         | 2122   | NSFC-2235     | AEBC-NSF2122            | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212235 | 1            | YEAR END      | AY         | 2122   | NSFC-2235     | AEBC-NSF2122            | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9701.00     
    | 10212236 | 1            | YEAR END      | AY         | 2122   | NSFC-2236     | AEBC-NSF2122            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212236 | 1            | YEAR END      | AY         | 2122   | NSFC-2236     | AEBC-NSF2122            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10212236 | 1            | YEAR END      | AY         | 2122   | NSFC-2236     | AEBC-NSF2122            | 3               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 10000.00           |
    | 10212236 | 1            | YEAR END      | AY         | 2122   | NSFC-2236     | AEBC-NSF2122            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212236 | 1            | YEAR END      | AY         | 2122   | NSFC-2236     | AEBC-NSF2122            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212236 | 1            | YEAR END      | AY         | 2122   | NSFC-2236     | AEBC-NSF2122            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212236 | 1            | YEAR END      | AY         | 2122   | NSFC-2236     | AEBC-NSF2122            | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212236 | 1            | YEAR END      | AY         | 2122   | NSFC-2236     | AEBC-NSF2122            | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10000.00    
    | 10212237 | 1            | YEAR END      | AY         | 2122   | NSFC-2237     | AEBC-NSF2122            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212237 | 1            | YEAR END      | AY         | 2122   | NSFC-2237     | AEBC-NSF2122            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10212237 | 1            | YEAR END      | AY         | 2122   | NSFC-2237     | AEBC-NSF2122            | 3               | 10999.00    | 0.00          | 0.00            | 10999.00          | 0.00         | 10000.00           |
    | 10212237 | 1            | YEAR END      | AY         | 2122   | NSFC-2237     | AEBC-NSF2122            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212237 | 1            | YEAR END      | AY         | 2122   | NSFC-2237     | AEBC-NSF2122            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212237 | 1            | YEAR END      | AY         | 2122   | NSFC-2237     | AEBC-NSF2122            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212237 | 1            | YEAR END      | AY         | 2122   | NSFC-2237     | AEBC-NSF2122            | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212237 | 1            | YEAR END      | AY         | 2122   | NSFC-2237     | AEBC-NSF2122            | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10999.00    
    | 10212238 | 1            | YEAR END      | AY         | 2122   | NSFC-2238     | AEBC-NSF2122            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212238 | 1            | YEAR END      | AY         | 2122   | NSFC-2238     | AEBC-NSF2122            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10212238 | 1            | YEAR END      | AY         | 2122   | NSFC-2238     | AEBC-NSF2122            | 3               | 11000.00    | 0.00          | 0.00            | 11000.00          | 0.00         | 10000.00           |
    | 10212238 | 1            | YEAR END      | AY         | 2122   | NSFC-2238     | AEBC-NSF2122            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212238 | 1            | YEAR END      | AY         | 2122   | NSFC-2238     | AEBC-NSF2122            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212238 | 1            | YEAR END      | AY         | 2122   | NSFC-2238     | AEBC-NSF2122            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212238 | 1            | YEAR END      | AY         | 2122   | NSFC-2238     | AEBC-NSF2122            | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212238 | 1            | YEAR END      | AY         | 2122   | NSFC-2238     | AEBC-NSF2122            | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£11000.00    
    | 10212239 | 1            | YEAR END      | AY         | 2122   | NSFC-2239     | AEBC-NSF2122            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212239 | 1            | YEAR END      | AY         | 2122   | NSFC-2239     | AEBC-NSF2122            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10212239 | 1            | YEAR END      | AY         | 2122   | NSFC-2239     | AEBC-NSF2122            | 3               | 11001.00    | 0.00          | 0.00            | 11001.00          | 0.00         | 10000.00           |
    | 10212239 | 1            | YEAR END      | AY         | 2122   | NSFC-2239     | AEBC-NSF2122            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212239 | 1            | YEAR END      | AY         | 2122   | NSFC-2239     | AEBC-NSF2122            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212239 | 1            | YEAR END      | AY         | 2122   | NSFC-2239     | AEBC-NSF2122            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212239 | 1            | YEAR END      | AY         | 2122   | NSFC-2239     | AEBC-NSF2122            | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212239 | 1            | YEAR END      | AY         | 2122   | NSFC-2239     | AEBC-NSF2122            | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£11001.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10212232 | 2122          | YEAR END        | AEBC-NSF2122        | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10212233 | 2122          | YEAR END        | AEBC-NSF2122        | 10000.00     | 9699.00      | 9699.00          | -301.00                     | -301.00             |
    | 10212234 | 2122          | YEAR END        | AEBC-NSF2122        | 10000.00     | 9700.00      | 9700.00          | 0.00                        | 0.00                |
    | 10212235 | 2122          | YEAR END        | AEBC-NSF2122        | 10000.00     | 9701.00      | 9701.00          | 0.00                        | 0.00                |
    | 10212236 | 2122          | YEAR END        | AEBC-NSF2122        | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10212237 | 2122          | YEAR END        | AEBC-NSF2122        | 10000.00     | 10999.00     | 10999.00         | 999.00                      | 999.00              |
    | 10212238 | 2122          | YEAR END        | AEBC-NSF2122        | 10000.00     | 11000.00     | 11000.00         | 1000.00                     | 1000.00             |
    | 10212239 | 2122          | YEAR END        | AEBC-NSF2122        | 10000.00     | 11001.00     | 11001.00         | 1000.00                     | 1000.00             |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10212232 | 2122          | YEAR END        | NSFC-2232           | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10212233 | 2122          | YEAR END        | NSFC-2233           | 10000.00     | 9699.00      | 9699.00          | -301.00                     | -301.00             |
    | 10212234 | 2122          | YEAR END        | NSFC-2234           | 10000.00     | 9700.00      | 9700.00          | 0.00                        | 0.00                |
    | 10212235 | 2122          | YEAR END        | NSFC-2235           | 10000.00     | 9701.00      | 9701.00          | 0.00                        | 0.00                |
    | 10212236 | 2122          | YEAR END        | NSFC-2236           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10212237 | 2122          | YEAR END        | NSFC-2237           | 10000.00     | 10999.00     | 10999.00         | 999.00                      | 999.00              |
    | 10212238 | 2122          | YEAR END        | NSFC-2238           | 10000.00     | 11000.00     | 11000.00         | 1000.00                     | 1000.00             |
    | 10212239 | 2122          | YEAR END        | NSFC-2239           | 10000.00     | 11001.00     | 11001.00         | 1000.00                     | 1000.00             |

@DoNotRun_7Mar2024 
@FundingClaimCalculation
Scenario: D584 Year-End Funding Claim Reconciliation Calculations for ALLBC2122

    # 40 Under-delivery - Delivers nothing
    # 41 Under-delivery - Variance exceeds Tolerance
    # 42 Under-delivery - Variance = Tolerance
    # 43 Under-delivery - Variance within Tolerance
    # 44 Variance = £0
    # 45 Over-delivery  - Small
    # 46 Over-delivery  - Large

    Given there are no Allocations in PaaS (Performance Management)

    And   the following debatched funding claims are received
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationGroupCode |
    | 10212240 | 1            | YEAR END      | AY         | 2122   | ALLBC2122           |
    | 10212241 | 1            | YEAR END      | AY         | 2122   | ALLBC2122           |
    | 10212242 | 1            | YEAR END      | AY         | 2122   | ALLBC2122           |
    | 10212243 | 1            | YEAR END      | AY         | 2122   | ALLBC2122           |
    | 10212244 | 1            | YEAR END      | AY         | 2122   | ALLBC2122           |
    | 10212245 | 1            | YEAR END      | AY         | 2122   | ALLBC2122           |
    | 10212246 | 1            | YEAR END      | AY         | 2122   | ALLBC2122           |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10212240 | 1            | YEAR END      | AY         | 2122   | ALLC-2240     | ALLBC2122           | ALLBC2122               | 10000.00        |
    | 10212241 | 1            | YEAR END      | AY         | 2122   | ALLC-2241     | ALLBC2122           | ALLBC2122               | 10000.00        |
    | 10212242 | 1            | YEAR END      | AY         | 2122   | ALLC-2242     | ALLBC2122           | ALLBC2122               | 10000.00        |
    | 10212243 | 1            | YEAR END      | AY         | 2122   | ALLC-2243     | ALLBC2122           | ALLBC2122               | 10000.00        |
    | 10212244 | 1            | YEAR END      | AY         | 2122   | ALLC-2244     | ALLBC2122           | ALLBC2122               | 10000.00        |
    | 10212245 | 1            | YEAR END      | AY         | 2122   | ALLC-2245     | ALLBC2122           | ALLBC2122               | 10000.00        |
    | 10212246 | 1            | YEAR END      | AY         | 2122   | ALLC-2246     | ALLBC2122           | ALLBC2122               | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10212240 | 1            | YEAR END      | AY         | 2122   | ALLC-2240     | ALLBC2122               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212240 | 1            | YEAR END      | AY         | 2122   | ALLC-2240     | ALLBC2122               | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10212240 | 1            | YEAR END      | AY         | 2122   | ALLC-2240     | ALLBC2122               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212240 | 1            | YEAR END      | AY         | 2122   | ALLC-2240     | ALLBC2122               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212240 | 1            | YEAR END      | AY         | 2122   | ALLC-2240     | ALLBC2122               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212240 | 1            | YEAR END      | AY         | 2122   | ALLC-2240     | ALLBC2122               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212240 | 1            | YEAR END      | AY         | 2122   | ALLC-2240     | ALLBC2122               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212240 | 1            | YEAR END      | AY         | 2122   | ALLC-2240     | ALLBC2122               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£0.00        
    | 10212241 | 1            | YEAR END      | AY         | 2122   | ALLC-2241     | ALLBC2122               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212241 | 1            | YEAR END      | AY         | 2122   | ALLC-2241     | ALLBC2122               | 2               | 8999.00     | 0.00          | 0.00            | 8999.00           | 10000.00     | 10000.00           |
    | 10212241 | 1            | YEAR END      | AY         | 2122   | ALLC-2241     | ALLBC2122               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212241 | 1            | YEAR END      | AY         | 2122   | ALLC-2241     | ALLBC2122               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212241 | 1            | YEAR END      | AY         | 2122   | ALLC-2241     | ALLBC2122               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212241 | 1            | YEAR END      | AY         | 2122   | ALLC-2241     | ALLBC2122               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212241 | 1            | YEAR END      | AY         | 2122   | ALLC-2241     | ALLBC2122               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212241 | 1            | YEAR END      | AY         | 2122   | ALLC-2241     | ALLBC2122               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£8999.00     
    | 10212242 | 1            | YEAR END      | AY         | 2122   | ALLC-2242     | ALLBC2122               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212242 | 1            | YEAR END      | AY         | 2122   | ALLC-2242     | ALLBC2122               | 2               | 9000.00     | 0.00          | 0.00            | 9000.00           | 10000.00     | 10000.00           |
    | 10212242 | 1            | YEAR END      | AY         | 2122   | ALLC-2242     | ALLBC2122               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212242 | 1            | YEAR END      | AY         | 2122   | ALLC-2242     | ALLBC2122               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212242 | 1            | YEAR END      | AY         | 2122   | ALLC-2242     | ALLBC2122               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212242 | 1            | YEAR END      | AY         | 2122   | ALLC-2242     | ALLBC2122               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212242 | 1            | YEAR END      | AY         | 2122   | ALLC-2242     | ALLBC2122               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212242 | 1            | YEAR END      | AY         | 2122   | ALLC-2242     | ALLBC2122               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9000.00     
    | 10212243 | 1            | YEAR END      | AY         | 2122   | ALLC-2243     | ALLBC2122               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212243 | 1            | YEAR END      | AY         | 2122   | ALLC-2243     | ALLBC2122               | 2               | 9001.00     | 0.00          | 0.00            | 9001.00           | 10000.00     | 10000.00           |
    | 10212243 | 1            | YEAR END      | AY         | 2122   | ALLC-2243     | ALLBC2122               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212243 | 1            | YEAR END      | AY         | 2122   | ALLC-2243     | ALLBC2122               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212243 | 1            | YEAR END      | AY         | 2122   | ALLC-2243     | ALLBC2122               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212243 | 1            | YEAR END      | AY         | 2122   | ALLC-2243     | ALLBC2122               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212243 | 1            | YEAR END      | AY         | 2122   | ALLC-2243     | ALLBC2122               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212243 | 1            | YEAR END      | AY         | 2122   | ALLC-2243     | ALLBC2122               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9001.00     
    | 10212244 | 1            | YEAR END      | AY         | 2122   | ALLC-2244     | ALLBC2122               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212244 | 1            | YEAR END      | AY         | 2122   | ALLC-2244     | ALLBC2122               | 2               | 10000.00    | 0.00          | 0.00            | 10000.00          | 10000.00     | 10000.00           |
    | 10212244 | 1            | YEAR END      | AY         | 2122   | ALLC-2244     | ALLBC2122               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212244 | 1            | YEAR END      | AY         | 2122   | ALLC-2244     | ALLBC2122               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212244 | 1            | YEAR END      | AY         | 2122   | ALLC-2244     | ALLBC2122               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212244 | 1            | YEAR END      | AY         | 2122   | ALLC-2244     | ALLBC2122               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212244 | 1            | YEAR END      | AY         | 2122   | ALLC-2244     | ALLBC2122               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212244 | 1            | YEAR END      | AY         | 2122   | ALLC-2244     | ALLBC2122               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10000.00    
    | 10212245 | 1            | YEAR END      | AY         | 2122   | ALLC-2245     | ALLBC2122               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212245 | 1            | YEAR END      | AY         | 2122   | ALLC-2245     | ALLBC2122               | 2               | 10001.00    | 0.00          | 0.00            | 10001.00          | 10000.00     | 10000.00           |
    | 10212245 | 1            | YEAR END      | AY         | 2122   | ALLC-2245     | ALLBC2122               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212245 | 1            | YEAR END      | AY         | 2122   | ALLC-2245     | ALLBC2122               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212245 | 1            | YEAR END      | AY         | 2122   | ALLC-2245     | ALLBC2122               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212245 | 1            | YEAR END      | AY         | 2122   | ALLC-2245     | ALLBC2122               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212245 | 1            | YEAR END      | AY         | 2122   | ALLC-2245     | ALLBC2122               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212245 | 1            | YEAR END      | AY         | 2122   | ALLC-2245     | ALLBC2122               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10001.00    
    | 10212246 | 1            | YEAR END      | AY         | 2122   | ALLC-2246     | ALLBC2122               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10212246 | 1            | YEAR END      | AY         | 2122   | ALLC-2246     | ALLBC2122               | 2               | 21000.00    | 0.00          | 0.00            | 21000.00          | 10000.00     | 10000.00           |
    | 10212246 | 1            | YEAR END      | AY         | 2122   | ALLC-2246     | ALLBC2122               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212246 | 1            | YEAR END      | AY         | 2122   | ALLC-2246     | ALLBC2122               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212246 | 1            | YEAR END      | AY         | 2122   | ALLC-2246     | ALLBC2122               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212246 | 1            | YEAR END      | AY         | 2122   | ALLC-2246     | ALLBC2122               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212246 | 1            | YEAR END      | AY         | 2122   | ALLC-2246     | ALLBC2122               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10212246 | 1            | YEAR END      | AY         | 2122   | ALLC-2246     | ALLBC2122               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£21000.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10212240 | 2122          | YEAR END        | ALLBC2122           | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10212241 | 2122          | YEAR END        | ALLBC2122           | 10000.00     | 8999.00      | 8999.00          | -1001.00                    | -1001.00            |
    | 10212242 | 2122          | YEAR END        | ALLBC2122           | 10000.00     | 9000.00      | 9000.00          | -1000.00                    | -1000.00            |
    | 10212243 | 2122          | YEAR END        | ALLBC2122           | 10000.00     | 9001.00      | 9001.00          | -999.00                     | -999.00             |
    | 10212244 | 2122          | YEAR END        | ALLBC2122           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10212245 | 2122          | YEAR END        | ALLBC2122           | 10000.00     | 10001.00     | 10001.00         | 0.00                        | 0.00                |
    | 10212246 | 2122          | YEAR END        | ALLBC2122           | 10000.00     | 21000.00     | 21000.00         | 0.00                        | 0.00                |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10212240 | 2122          | YEAR END        | ALLC-2240           | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10212241 | 2122          | YEAR END        | ALLC-2241           | 10000.00     | 8999.00      | 8999.00          | -1001.00                    | -1001.00            |
    | 10212242 | 2122          | YEAR END        | ALLC-2242           | 10000.00     | 9000.00      | 9000.00          | -1000.00                    | -1000.00            |
    | 10212243 | 2122          | YEAR END        | ALLC-2243           | 10000.00     | 9001.00      | 9001.00          | -999.00                     | -999.00             |
    | 10212244 | 2122          | YEAR END        | ALLC-2244           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10212245 | 2122          | YEAR END        | ALLC-2245           | 10000.00     | 10001.00     | 10001.00         | 0.00                        | 0.00                |
    | 10212246 | 2122          | YEAR END        | ALLC-2246           | 10000.00     | 21000.00     | 21000.00         | 0.00                        | 0.00                |

