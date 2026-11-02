Feature: Funding Claim Payment Calculation Test AEBC-ASCL-2021

@DoNotRun_7Mar2024 
@FundingClaimCalculation
Scenario: D571 Final Funding Claim Reconciliation Calculations for AEBC-ASCL-2021

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
    | 10202101 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202102 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202103 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202104 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202105 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202106 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202107 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202108 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202109 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202110 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202111 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202112 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202113 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202114 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202115 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202116 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202117 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202118 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202119 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202120 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202121 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202122 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |
    | 10202123 | 1            | FINAL         | AY         | 2021   | AEBC-ASCL2021       |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10202101 | 1            | FINAL         | AY         | 2021   | AECA-2101     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202102 | 1            | FINAL         | AY         | 2021   | AECA-2102     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202103 | 1            | FINAL         | AY         | 2021   | AECA-2103     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202104 | 1            | FINAL         | AY         | 2021   | AECA-2104     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202105 | 1            | FINAL         | AY         | 2021   | AECA-2105     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202106 | 1            | FINAL         | AY         | 2021   | AECA-2106     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202107 | 1            | FINAL         | AY         | 2021   | AECA-2107     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202108 | 1            | FINAL         | AY         | 2021   | AECA-2108     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202109 | 1            | FINAL         | AY         | 2021   | AECA-2109     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202110 | 1            | FINAL         | AY         | 2021   | AECA-2110     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202111 | 1            | FINAL         | AY         | 2021   | AECA-2111     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202112 | 1            | FINAL         | AY         | 2021   | AECA-2112     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202113 | 1            | FINAL         | AY         | 2021   | AECA-2113     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202114 | 1            | FINAL         | AY         | 2021   | AECA-2114     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202115 | 1            | FINAL         | AY         | 2021   | AECA-2115     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202116 | 1            | FINAL         | AY         | 2021   | AECA-2116     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202117 | 1            | FINAL         | AY         | 2021   | AECA-2117     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202118 | 1            | FINAL         | AY         | 2021   | AECA-2118     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202119 | 1            | FINAL         | AY         | 2021   | AECA-2119     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202120 | 1            | FINAL         | AY         | 2021   | AECA-2120     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202121 | 1            | FINAL         | AY         | 2021   | AECA-2121     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202122 | 1            | FINAL         | AY         | 2021   | AECA-2122     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |
    | 10202123 | 1            | FINAL         | AY         | 2021   | AECA-2123     | AEBC-ASCL2021       | AEBC-ASCL2021           | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10202101 | 1            | FINAL         | AY         | 2021   | AECA-2101     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202101 | 1            | FINAL         | AY         | 2021   | AECA-2101     | AEBC-ASCL2021           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202101 | 1            | FINAL         | AY         | 2021   | AECA-2101     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10202101 | 1            | FINAL         | AY         | 2021   | AECA-2101     | AEBC-ASCL2021           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202101 | 1            | FINAL         | AY         | 2021   | AECA-2101     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202101 | 1            | FINAL         | AY         | 2021   | AECA-2101     | AEBC-ASCL2021           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202101 | 1            | FINAL         | AY         | 2021   | AECA-2101     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202101 | 1            | FINAL         | AY         | 2021   | AECA-2101     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202101 | 1            | FINAL         | AY         | 2021   | AECA-2101     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202101 | 1            | FINAL         | AY         | 2021   | AECA-2101     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£0.00        
    | 10202102 | 1            | FINAL         | AY         | 2021   | AECA-2102     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202102 | 1            | FINAL         | AY         | 2021   | AECA-2102     | AEBC-ASCL2021           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202102 | 1            | FINAL         | AY         | 2021   | AECA-2102     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10202102 | 1            | FINAL         | AY         | 2021   | AECA-2102     | AEBC-ASCL2021           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202102 | 1            | FINAL         | AY         | 2021   | AECA-2102     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202102 | 1            | FINAL         | AY         | 2021   | AECA-2102     | AEBC-ASCL2021           | 6               | 8999.00     | 0.00          | 0.00            | 8999.00           | 0.00         | 10000.00           |
    | 10202102 | 1            | FINAL         | AY         | 2021   | AECA-2102     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202102 | 1            | FINAL         | AY         | 2021   | AECA-2102     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202102 | 1            | FINAL         | AY         | 2021   | AECA-2102     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202102 | 1            | FINAL         | AY         | 2021   | AECA-2102     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£8999.00     
    | 10202103 | 1            | FINAL         | AY         | 2021   | AECA-2103     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202103 | 1            | FINAL         | AY         | 2021   | AECA-2103     | AEBC-ASCL2021           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202103 | 1            | FINAL         | AY         | 2021   | AECA-2103     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10202103 | 1            | FINAL         | AY         | 2021   | AECA-2103     | AEBC-ASCL2021           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202103 | 1            | FINAL         | AY         | 2021   | AECA-2103     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202103 | 1            | FINAL         | AY         | 2021   | AECA-2103     | AEBC-ASCL2021           | 6               | 9000.00     | 0.00          | 0.00            | 9000.00           | 0.00         | 10000.00           |
    | 10202103 | 1            | FINAL         | AY         | 2021   | AECA-2103     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202103 | 1            | FINAL         | AY         | 2021   | AECA-2103     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202103 | 1            | FINAL         | AY         | 2021   | AECA-2103     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202103 | 1            | FINAL         | AY         | 2021   | AECA-2103     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9000.00     
    | 10202104 | 1            | FINAL         | AY         | 2021   | AECA-2104     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202104 | 1            | FINAL         | AY         | 2021   | AECA-2104     | AEBC-ASCL2021           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202104 | 1            | FINAL         | AY         | 2021   | AECA-2104     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10202104 | 1            | FINAL         | AY         | 2021   | AECA-2104     | AEBC-ASCL2021           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202104 | 1            | FINAL         | AY         | 2021   | AECA-2104     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202104 | 1            | FINAL         | AY         | 2021   | AECA-2104     | AEBC-ASCL2021           | 6               | 9001.00     | 0.00          | 0.00            | 9001.00           | 0.00         | 10000.00           |
    | 10202104 | 1            | FINAL         | AY         | 2021   | AECA-2104     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202104 | 1            | FINAL         | AY         | 2021   | AECA-2104     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202104 | 1            | FINAL         | AY         | 2021   | AECA-2104     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202104 | 1            | FINAL         | AY         | 2021   | AECA-2104     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9001.00     
    | 10202105 | 1            | FINAL         | AY         | 2021   | AECA-2105     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202105 | 1            | FINAL         | AY         | 2021   | AECA-2105     | AEBC-ASCL2021           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202105 | 1            | FINAL         | AY         | 2021   | AECA-2105     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10202105 | 1            | FINAL         | AY         | 2021   | AECA-2105     | AEBC-ASCL2021           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202105 | 1            | FINAL         | AY         | 2021   | AECA-2105     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202105 | 1            | FINAL         | AY         | 2021   | AECA-2105     | AEBC-ASCL2021           | 6               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 10000.00           |
    | 10202105 | 1            | FINAL         | AY         | 2021   | AECA-2105     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202105 | 1            | FINAL         | AY         | 2021   | AECA-2105     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202105 | 1            | FINAL         | AY         | 2021   | AECA-2105     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202105 | 1            | FINAL         | AY         | 2021   | AECA-2105     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10000.00    
    | 10202106 | 1            | FINAL         | AY         | 2021   | AECA-2106     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202106 | 1            | FINAL         | AY         | 2021   | AECA-2106     | AEBC-ASCL2021           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202106 | 1            | FINAL         | AY         | 2021   | AECA-2106     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10202106 | 1            | FINAL         | AY         | 2021   | AECA-2106     | AEBC-ASCL2021           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202106 | 1            | FINAL         | AY         | 2021   | AECA-2106     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202106 | 1            | FINAL         | AY         | 2021   | AECA-2106     | AEBC-ASCL2021           | 6               | 10299.00    | 0.00          | 0.00            | 10299.00          | 0.00         | 10000.00           |
    | 10202106 | 1            | FINAL         | AY         | 2021   | AECA-2106     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202106 | 1            | FINAL         | AY         | 2021   | AECA-2106     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202106 | 1            | FINAL         | AY         | 2021   | AECA-2106     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202106 | 1            | FINAL         | AY         | 2021   | AECA-2106     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10299.00    
    | 10202107 | 1            | FINAL         | AY         | 2021   | AECA-2107     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202107 | 1            | FINAL         | AY         | 2021   | AECA-2107     | AEBC-ASCL2021           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202107 | 1            | FINAL         | AY         | 2021   | AECA-2107     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10202107 | 1            | FINAL         | AY         | 2021   | AECA-2107     | AEBC-ASCL2021           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202107 | 1            | FINAL         | AY         | 2021   | AECA-2107     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202107 | 1            | FINAL         | AY         | 2021   | AECA-2107     | AEBC-ASCL2021           | 6               | 10300.00    | 0.00          | 0.00            | 10300.00          | 0.00         | 10000.00           |
    | 10202107 | 1            | FINAL         | AY         | 2021   | AECA-2107     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202107 | 1            | FINAL         | AY         | 2021   | AECA-2107     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202107 | 1            | FINAL         | AY         | 2021   | AECA-2107     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202107 | 1            | FINAL         | AY         | 2021   | AECA-2107     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10300.00    
    | 10202108 | 1            | FINAL         | AY         | 2021   | AECA-2108     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202108 | 1            | FINAL         | AY         | 2021   | AECA-2108     | AEBC-ASCL2021           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202108 | 1            | FINAL         | AY         | 2021   | AECA-2108     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10202108 | 1            | FINAL         | AY         | 2021   | AECA-2108     | AEBC-ASCL2021           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202108 | 1            | FINAL         | AY         | 2021   | AECA-2108     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202108 | 1            | FINAL         | AY         | 2021   | AECA-2108     | AEBC-ASCL2021           | 6               | 10301.00    | 0.00          | 0.00            | 10301.00          | 0.00         | 10000.00           |
    | 10202108 | 1            | FINAL         | AY         | 2021   | AECA-2108     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202108 | 1            | FINAL         | AY         | 2021   | AECA-2108     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202108 | 1            | FINAL         | AY         | 2021   | AECA-2108     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202108 | 1            | FINAL         | AY         | 2021   | AECA-2108     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10301.00    
    | 10202109 | 1            | FINAL         | AY         | 2021   | AECA-2109     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202109 | 1            | FINAL         | AY         | 2021   | AECA-2109     | AEBC-ASCL2021           | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 800.00       | 10000.00           |
    | 10202109 | 1            | FINAL         | AY         | 2021   | AECA-2109     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10202109 | 1            | FINAL         | AY         | 2021   | AECA-2109     | AEBC-ASCL2021           | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202109 | 1            | FINAL         | AY         | 2021   | AECA-2109     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202109 | 1            | FINAL         | AY         | 2021   | AECA-2109     | AEBC-ASCL2021           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202109 | 1            | FINAL         | AY         | 2021   | AECA-2109     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202109 | 1            | FINAL         | AY         | 2021   | AECA-2109     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202109 | 1            | FINAL         | AY         | 2021   | AECA-2109     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202109 | 1            | FINAL         | AY         | 2021   | AECA-2109     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£0.00        
    | 10202110 | 1            | FINAL         | AY         | 2021   | AECA-2110     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202110 | 1            | FINAL         | AY         | 2021   | AECA-2110     | AEBC-ASCL2021           | 5               | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 10000.00           |
    | 10202110 | 1            | FINAL         | AY         | 2021   | AECA-2110     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10202110 | 1            | FINAL         | AY         | 2021   | AECA-2110     | AEBC-ASCL2021           | 3               | 8299.00     | 0.00          | 0.00            | 8299.00           | 0.00         | 9200.00            |
    | 10202110 | 1            | FINAL         | AY         | 2021   | AECA-2110     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202110 | 1            | FINAL         | AY         | 2021   | AECA-2110     | AEBC-ASCL2021           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202110 | 1            | FINAL         | AY         | 2021   | AECA-2110     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202110 | 1            | FINAL         | AY         | 2021   | AECA-2110     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202110 | 1            | FINAL         | AY         | 2021   | AECA-2110     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202110 | 1            | FINAL         | AY         | 2021   | AECA-2110     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£8999.00     
    | 10202111 | 1            | FINAL         | AY         | 2021   | AECA-2111     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202111 | 1            | FINAL         | AY         | 2021   | AECA-2111     | AEBC-ASCL2021           | 5               | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 10000.00           |
    | 10202111 | 1            | FINAL         | AY         | 2021   | AECA-2111     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10202111 | 1            | FINAL         | AY         | 2021   | AECA-2111     | AEBC-ASCL2021           | 3               | 8300.00     | 0.00          | 0.00            | 8300.00           | 0.00         | 9200.00            |
    | 10202111 | 1            | FINAL         | AY         | 2021   | AECA-2111     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202111 | 1            | FINAL         | AY         | 2021   | AECA-2111     | AEBC-ASCL2021           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202111 | 1            | FINAL         | AY         | 2021   | AECA-2111     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202111 | 1            | FINAL         | AY         | 2021   | AECA-2111     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202111 | 1            | FINAL         | AY         | 2021   | AECA-2111     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202111 | 1            | FINAL         | AY         | 2021   | AECA-2111     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£9000.00     
    | 10202112 | 1            | FINAL         | AY         | 2021   | AECA-2112     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202112 | 1            | FINAL         | AY         | 2021   | AECA-2112     | AEBC-ASCL2021           | 5               | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 10000.00           |
    | 10202112 | 1            | FINAL         | AY         | 2021   | AECA-2112     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10202112 | 1            | FINAL         | AY         | 2021   | AECA-2112     | AEBC-ASCL2021           | 3               | 8301.00     | 0.00          | 0.00            | 8301.00           | 0.00         | 9200.00            |
    | 10202112 | 1            | FINAL         | AY         | 2021   | AECA-2112     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202112 | 1            | FINAL         | AY         | 2021   | AECA-2112     | AEBC-ASCL2021           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202112 | 1            | FINAL         | AY         | 2021   | AECA-2112     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202112 | 1            | FINAL         | AY         | 2021   | AECA-2112     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202112 | 1            | FINAL         | AY         | 2021   | AECA-2112     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202112 | 1            | FINAL         | AY         | 2021   | AECA-2112     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£9001.00     
    | 10202113 | 1            | FINAL         | AY         | 2021   | AECA-2113     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202113 | 1            | FINAL         | AY         | 2021   | AECA-2113     | AEBC-ASCL2021           | 5               | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 10000.00           |
    | 10202113 | 1            | FINAL         | AY         | 2021   | AECA-2113     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10202113 | 1            | FINAL         | AY         | 2021   | AECA-2113     | AEBC-ASCL2021           | 3               | 9300.00     | 0.00          | 0.00            | 9300.00           | 0.00         | 9200.00            |
    | 10202113 | 1            | FINAL         | AY         | 2021   | AECA-2113     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202113 | 1            | FINAL         | AY         | 2021   | AECA-2113     | AEBC-ASCL2021           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202113 | 1            | FINAL         | AY         | 2021   | AECA-2113     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202113 | 1            | FINAL         | AY         | 2021   | AECA-2113     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202113 | 1            | FINAL         | AY         | 2021   | AECA-2113     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202113 | 1            | FINAL         | AY         | 2021   | AECA-2113     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£10000.00    
    | 10202114 | 1            | FINAL         | AY         | 2021   | AECA-2114     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202114 | 1            | FINAL         | AY         | 2021   | AECA-2114     | AEBC-ASCL2021           | 5               | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 10000.00           |
    | 10202114 | 1            | FINAL         | AY         | 2021   | AECA-2114     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10202114 | 1            | FINAL         | AY         | 2021   | AECA-2114     | AEBC-ASCL2021           | 3               | 9599.00     | 0.00          | 0.00            | 9599.00           | 0.00         | 9200.00            |
    | 10202114 | 1            | FINAL         | AY         | 2021   | AECA-2114     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202114 | 1            | FINAL         | AY         | 2021   | AECA-2114     | AEBC-ASCL2021           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202114 | 1            | FINAL         | AY         | 2021   | AECA-2114     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202114 | 1            | FINAL         | AY         | 2021   | AECA-2114     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202114 | 1            | FINAL         | AY         | 2021   | AECA-2114     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202114 | 1            | FINAL         | AY         | 2021   | AECA-2114     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£10299.00    
    | 10202115 | 1            | FINAL         | AY         | 2021   | AECA-2115     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202115 | 1            | FINAL         | AY         | 2021   | AECA-2115     | AEBC-ASCL2021           | 5               | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 10000.00           |
    | 10202115 | 1            | FINAL         | AY         | 2021   | AECA-2115     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10202115 | 1            | FINAL         | AY         | 2021   | AECA-2115     | AEBC-ASCL2021           | 3               | 9600.00     | 0.00          | 0.00            | 9600.00           | 0.00         | 9200.00            |
    | 10202115 | 1            | FINAL         | AY         | 2021   | AECA-2115     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202115 | 1            | FINAL         | AY         | 2021   | AECA-2115     | AEBC-ASCL2021           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202115 | 1            | FINAL         | AY         | 2021   | AECA-2115     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202115 | 1            | FINAL         | AY         | 2021   | AECA-2115     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202115 | 1            | FINAL         | AY         | 2021   | AECA-2115     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202115 | 1            | FINAL         | AY         | 2021   | AECA-2115     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£10300.00    
    | 10202116 | 1            | FINAL         | AY         | 2021   | AECA-2116     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202116 | 1            | FINAL         | AY         | 2021   | AECA-2116     | AEBC-ASCL2021           | 5               | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 10000.00           |
    | 10202116 | 1            | FINAL         | AY         | 2021   | AECA-2116     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10202116 | 1            | FINAL         | AY         | 2021   | AECA-2116     | AEBC-ASCL2021           | 3               | 9601.00     | 0.00          | 0.00            | 9601.00           | 0.00         | 9200.00            |
    | 10202116 | 1            | FINAL         | AY         | 2021   | AECA-2116     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202116 | 1            | FINAL         | AY         | 2021   | AECA-2116     | AEBC-ASCL2021           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202116 | 1            | FINAL         | AY         | 2021   | AECA-2116     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202116 | 1            | FINAL         | AY         | 2021   | AECA-2116     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202116 | 1            | FINAL         | AY         | 2021   | AECA-2116     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202116 | 1            | FINAL         | AY         | 2021   | AECA-2116     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£10301.00    
    | 10202117 | 1            | FINAL         | AY         | 2021   | AECA-2117     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202117 | 1            | FINAL         | AY         | 2021   | AECA-2117     | AEBC-ASCL2021           | 5               | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 10000.00           |
    | 10202117 | 1            | FINAL         | AY         | 2021   | AECA-2117     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10202117 | 1            | FINAL         | AY         | 2021   | AECA-2117     | AEBC-ASCL2021           | 3               | 8199.00     | 0.00          | 0.00            | 8199.00           | 0.00         | 9200.00            |
    | 10202117 | 1            | FINAL         | AY         | 2021   | AECA-2117     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202117 | 1            | FINAL         | AY         | 2021   | AECA-2117     | AEBC-ASCL2021           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202117 | 1            | FINAL         | AY         | 2021   | AECA-2117     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202117 | 1            | FINAL         | AY         | 2021   | AECA-2117     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202117 | 1            | FINAL         | AY         | 2021   | AECA-2117     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202117 | 1            | FINAL         | AY         | 2021   | AECA-2117     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£9099.00     
    | 10202118 | 1            | FINAL         | AY         | 2021   | AECA-2118     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202118 | 1            | FINAL         | AY         | 2021   | AECA-2118     | AEBC-ASCL2021           | 5               | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 10000.00           |
    | 10202118 | 1            | FINAL         | AY         | 2021   | AECA-2118     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10202118 | 1            | FINAL         | AY         | 2021   | AECA-2118     | AEBC-ASCL2021           | 3               | 8200.00     | 0.00          | 0.00            | 8200.00           | 0.00         | 9200.00            |
    | 10202118 | 1            | FINAL         | AY         | 2021   | AECA-2118     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202118 | 1            | FINAL         | AY         | 2021   | AECA-2118     | AEBC-ASCL2021           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202118 | 1            | FINAL         | AY         | 2021   | AECA-2118     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202118 | 1            | FINAL         | AY         | 2021   | AECA-2118     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202118 | 1            | FINAL         | AY         | 2021   | AECA-2118     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202118 | 1            | FINAL         | AY         | 2021   | AECA-2118     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£9100.00     
    | 10202119 | 1            | FINAL         | AY         | 2021   | AECA-2119     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202119 | 1            | FINAL         | AY         | 2021   | AECA-2119     | AEBC-ASCL2021           | 5               | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 10000.00           |
    | 10202119 | 1            | FINAL         | AY         | 2021   | AECA-2119     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10202119 | 1            | FINAL         | AY         | 2021   | AECA-2119     | AEBC-ASCL2021           | 3               | 8201.00     | 0.00          | 0.00            | 8201.00           | 0.00         | 9200.00            |
    | 10202119 | 1            | FINAL         | AY         | 2021   | AECA-2119     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202119 | 1            | FINAL         | AY         | 2021   | AECA-2119     | AEBC-ASCL2021           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202119 | 1            | FINAL         | AY         | 2021   | AECA-2119     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202119 | 1            | FINAL         | AY         | 2021   | AECA-2119     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202119 | 1            | FINAL         | AY         | 2021   | AECA-2119     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202119 | 1            | FINAL         | AY         | 2021   | AECA-2119     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£9101.00     
    | 10202120 | 1            | FINAL         | AY         | 2021   | AECA-2120     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202120 | 1            | FINAL         | AY         | 2021   | AECA-2120     | AEBC-ASCL2021           | 5               | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 10000.00           |
    | 10202120 | 1            | FINAL         | AY         | 2021   | AECA-2120     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10202120 | 1            | FINAL         | AY         | 2021   | AECA-2120     | AEBC-ASCL2021           | 3               | 9200.00     | 0.00          | 0.00            | 9200.00           | 0.00         | 9200.00            |
    | 10202120 | 1            | FINAL         | AY         | 2021   | AECA-2120     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202120 | 1            | FINAL         | AY         | 2021   | AECA-2120     | AEBC-ASCL2021           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202120 | 1            | FINAL         | AY         | 2021   | AECA-2120     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202120 | 1            | FINAL         | AY         | 2021   | AECA-2120     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202120 | 1            | FINAL         | AY         | 2021   | AECA-2120     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202120 | 1            | FINAL         | AY         | 2021   | AECA-2120     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£10100.00    
    | 10202121 | 1            | FINAL         | AY         | 2021   | AECA-2121     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202121 | 1            | FINAL         | AY         | 2021   | AECA-2121     | AEBC-ASCL2021           | 5               | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 10000.00           |
    | 10202121 | 1            | FINAL         | AY         | 2021   | AECA-2121     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10202121 | 1            | FINAL         | AY         | 2021   | AECA-2121     | AEBC-ASCL2021           | 3               | 9499.00     | 0.00          | 0.00            | 9499.00           | 0.00         | 9200.00            |
    | 10202121 | 1            | FINAL         | AY         | 2021   | AECA-2121     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202121 | 1            | FINAL         | AY         | 2021   | AECA-2121     | AEBC-ASCL2021           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202121 | 1            | FINAL         | AY         | 2021   | AECA-2121     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202121 | 1            | FINAL         | AY         | 2021   | AECA-2121     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202121 | 1            | FINAL         | AY         | 2021   | AECA-2121     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202121 | 1            | FINAL         | AY         | 2021   | AECA-2121     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£10399.00    
    | 10202122 | 1            | FINAL         | AY         | 2021   | AECA-2122     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202122 | 1            | FINAL         | AY         | 2021   | AECA-2122     | AEBC-ASCL2021           | 5               | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 10000.00           |
    | 10202122 | 1            | FINAL         | AY         | 2021   | AECA-2122     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10202122 | 1            | FINAL         | AY         | 2021   | AECA-2122     | AEBC-ASCL2021           | 3               | 9500.00     | 0.00          | 0.00            | 9500.00           | 0.00         | 9200.00            |
    | 10202122 | 1            | FINAL         | AY         | 2021   | AECA-2122     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202122 | 1            | FINAL         | AY         | 2021   | AECA-2122     | AEBC-ASCL2021           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202122 | 1            | FINAL         | AY         | 2021   | AECA-2122     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202122 | 1            | FINAL         | AY         | 2021   | AECA-2122     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202122 | 1            | FINAL         | AY         | 2021   | AECA-2122     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202122 | 1            | FINAL         | AY         | 2021   | AECA-2122     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£10400.00    
    | 10202123 | 1            | FINAL         | AY         | 2021   | AECA-2123     | AEBC-ASCL2021           | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202123 | 1            | FINAL         | AY         | 2021   | AECA-2123     | AEBC-ASCL2021           | 5               | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 10000.00           |
    | 10202123 | 1            | FINAL         | AY         | 2021   | AECA-2123     | AEBC-ASCL2021           | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10202123 | 1            | FINAL         | AY         | 2021   | AECA-2123     | AEBC-ASCL2021           | 3               | 9501.00     | 0.00          | 0.00            | 9501.00           | 0.00         | 9200.00            |
    | 10202123 | 1            | FINAL         | AY         | 2021   | AECA-2123     | AEBC-ASCL2021           | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202123 | 1            | FINAL         | AY         | 2021   | AECA-2123     | AEBC-ASCL2021           | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202123 | 1            | FINAL         | AY         | 2021   | AECA-2123     | AEBC-ASCL2021           | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202123 | 1            | FINAL         | AY         | 2021   | AECA-2123     | AEBC-ASCL2021           | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202123 | 1            | FINAL         | AY         | 2021   | AECA-2123     | AEBC-ASCL2021           | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10202123 | 1            | FINAL         | AY         | 2021   | AECA-2123     | AEBC-ASCL2021           | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£10401.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10202101 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10202102 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 8999.00      | 8999.00          | -1.00                       | -1.00               |
    | 10202103 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 9000.00      | 9000.00          | 0.00                        | 0.00                |
    | 10202104 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 9001.00      | 9001.00          | 0.00                        | 0.00                |
    | 10202105 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10202106 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 10299.00     | 10299.00         | 299.00                      | 299.00              |
    | 10202107 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 10300.00     | 10300.00         | 300.00                      | 300.00              |
    | 10202108 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 10301.00     | 10301.00         | 300.00                      | 300.00              |
    | 10202109 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10202110 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 8999.00      | 8999.00          | -1.00                       | -1.00               |
    | 10202111 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 9000.00      | 9000.00          | 0.00                        | 0.00                |
    | 10202112 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 9001.00      | 9001.00          | 0.00                        | 0.00                |
    | 10202113 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10202114 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 10299.00     | 10299.00         | 299.00                      | 299.00              |
    | 10202115 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 10300.00     | 10300.00         | 300.00                      | 300.00              |
    | 10202116 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 10301.00     | 10301.00         | 300.00                      | 300.00              |
    | 10202117 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 9099.00      | 8999.00          | -1.00                       | -1.00               |
    | 10202118 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 9100.00      | 9000.00          | 0.00                        | 0.00                |
    | 10202119 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 9101.00      | 9001.00          | 0.00                        | 0.00                |
    | 10202120 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 10100.00     | 10000.00         | 0.00                        | 0.00                |
    | 10202121 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 10399.00     | 10299.00         | 299.00                      | 299.00              |
    | 10202122 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 10400.00     | 10300.00         | 300.00                      | 300.00              |
    | 10202123 | 2021          | FINAL           | AEBC-ASCL2021       | 10000.00     | 10401.00     | 10301.00         | 300.00                      | 300.00              |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10202101 | 2021          | FINAL           | AECA-2101           | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10202102 | 2021          | FINAL           | AECA-2102           | 10000.00     | 8999.00      | 8999.00          | -1.00                       | -1.00               |
    | 10202103 | 2021          | FINAL           | AECA-2103           | 10000.00     | 9000.00      | 9000.00          | 0.00                        | 0.00                |
    | 10202104 | 2021          | FINAL           | AECA-2104           | 10000.00     | 9001.00      | 9001.00          | 0.00                        | 0.00                |
    | 10202105 | 2021          | FINAL           | AECA-2105           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10202106 | 2021          | FINAL           | AECA-2106           | 10000.00     | 10299.00     | 10299.00         | 299.00                      | 299.00              |
    | 10202107 | 2021          | FINAL           | AECA-2107           | 10000.00     | 10300.00     | 10300.00         | 300.00                      | 300.00              |
    | 10202108 | 2021          | FINAL           | AECA-2108           | 10000.00     | 10301.00     | 10301.00         | 300.00                      | 300.00              |
    | 10202109 | 2021          | FINAL           | AECA-2109           | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10202110 | 2021          | FINAL           | AECA-2110           | 10000.00     | 8999.00      | 8999.00          | -1.00                       | -1.00               |
    | 10202111 | 2021          | FINAL           | AECA-2111           | 10000.00     | 9000.00      | 9000.00          | 0.00                        | 0.00                |
    | 10202112 | 2021          | FINAL           | AECA-2112           | 10000.00     | 9001.00      | 9001.00          | 0.00                        | 0.00                |
    | 10202113 | 2021          | FINAL           | AECA-2113           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10202114 | 2021          | FINAL           | AECA-2114           | 10000.00     | 10299.00     | 10299.00         | 299.00                      | 299.00              |
    | 10202115 | 2021          | FINAL           | AECA-2115           | 10000.00     | 10300.00     | 10300.00         | 300.00                      | 300.00              |
    | 10202116 | 2021          | FINAL           | AECA-2116           | 10000.00     | 10301.00     | 10301.00         | 300.00                      | 300.00              |
    | 10202117 | 2021          | FINAL           | AECA-2117           | 10000.00     | 9099.00      | 8999.00          | -1.00                       | -1.00               |
    | 10202118 | 2021          | FINAL           | AECA-2118           | 10000.00     | 9100.00      | 9000.00          | 0.00                        | 0.00                |
    | 10202119 | 2021          | FINAL           | AECA-2119           | 10000.00     | 9101.00      | 9001.00          | 0.00                        | 0.00                |
    | 10202120 | 2021          | FINAL           | AECA-2120           | 10000.00     | 10100.00     | 10000.00         | 0.00                        | 0.00                |
    | 10202121 | 2021          | FINAL           | AECA-2121           | 10000.00     | 10399.00     | 10299.00         | 299.00                      | 299.00              |
    | 10202122 | 2021          | FINAL           | AECA-2122           | 10000.00     | 10400.00     | 10300.00         | 300.00                      | 300.00              |
    | 10202123 | 2021          | FINAL           | AECA-2123           | 10000.00     | 10401.00     | 10301.00         | 300.00                      | 300.00              |

@DoNotRun_7Mar2024 
@FundingClaimCalculation
Scenario: D572 Final Funding Claim Reconciliation Calculations for AEBC-19TRN2021

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
    | 10202124 | 1            | FINAL         | AY         | 2021   | AEBC-19TRN2021      |
    | 10202125 | 1            | FINAL         | AY         | 2021   | AEBC-19TRN2021      |
    | 10202126 | 1            | FINAL         | AY         | 2021   | AEBC-19TRN2021      |
    | 10202127 | 1            | FINAL         | AY         | 2021   | AEBC-19TRN2021      |
    | 10202128 | 1            | FINAL         | AY         | 2021   | AEBC-19TRN2021      |
    | 10202129 | 1            | FINAL         | AY         | 2021   | AEBC-19TRN2021      |
    | 10202130 | 1            | FINAL         | AY         | 2021   | AEBC-19TRN2021      |
    | 10202131 | 1            | FINAL         | AY         | 2021   | AEBC-19TRN2021      |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10202124 | 1            | FINAL         | AY         | 2021   | AECT-2124     | AEBC-19TRN2021      | AEBC-19TRN2021          | 10000.00        |
    | 10202125 | 1            | FINAL         | AY         | 2021   | AECT-2125     | AEBC-19TRN2021      | AEBC-19TRN2021          | 10000.00        |
    | 10202126 | 1            | FINAL         | AY         | 2021   | AECT-2126     | AEBC-19TRN2021      | AEBC-19TRN2021          | 10000.00        |
    | 10202127 | 1            | FINAL         | AY         | 2021   | AECT-2127     | AEBC-19TRN2021      | AEBC-19TRN2021          | 10000.00        |
    | 10202128 | 1            | FINAL         | AY         | 2021   | AECT-2128     | AEBC-19TRN2021      | AEBC-19TRN2021          | 10000.00        |
    | 10202129 | 1            | FINAL         | AY         | 2021   | AECT-2129     | AEBC-19TRN2021      | AEBC-19TRN2021          | 10000.00        |
    | 10202130 | 1            | FINAL         | AY         | 2021   | AECT-2130     | AEBC-19TRN2021      | AEBC-19TRN2021          | 10000.00        |
    | 10202131 | 1            | FINAL         | AY         | 2021   | AECT-2131     | AEBC-19TRN2021      | AEBC-19TRN2021          | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10202124 | 1            | FINAL         | AY         | 2021   | AECT-2124     | AEBC-19TRN2021          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202124 | 1            | FINAL         | AY         | 2021   | AECT-2124     | AEBC-19TRN2021          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202124 | 1            | FINAL         | AY         | 2021   | AECT-2124     | AEBC-19TRN2021          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202124 | 1            | Final         | AY         | 2021   | AECT-2124     | AEBC-19TRN2021          | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202124 | 1            | FINAL         | AY         | 2021   | AECT-2124     | AEBC-19TRN2021          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£0.00        
    | 10202125 | 1            | FINAL         | AY         | 2021   | AECT-2125     | AEBC-19TRN2021          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202125 | 1            | FINAL         | AY         | 2021   | AECT-2125     | AEBC-19TRN2021          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202125 | 1            | FINAL         | AY         | 2021   | AECT-2125     | AEBC-19TRN2021          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202125 | 1            | FINAL         | AY         | 2021   | AECT-2125     | AEBC-19TRN2021          | 4               | 8999.00     | 0.00          | 0.00            | 8999.00           | 0.00         | 10000.00           |
    | 10202125 | 1            | FINAL         | AY         | 2021   | AECT-2125     | AEBC-19TRN2021          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£8999.00     
    | 10202126 | 1            | FINAL         | AY         | 2021   | AECT-2126     | AEBC-19TRN2021          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202126 | 1            | FINAL         | AY         | 2021   | AECT-2126     | AEBC-19TRN2021          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202126 | 1            | FINAL         | AY         | 2021   | AECT-2126     | AEBC-19TRN2021          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202126 | 1            | FINAL         | AY         | 2021   | AECT-2126     | AEBC-19TRN2021          | 4               | 9000.00     | 0.00          | 0.00            | 9000.00           | 0.00         | 10000.00           |
    | 10202126 | 1            | FINAL         | AY         | 2021   | AECT-2126     | AEBC-19TRN2021          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9000.00     
    | 10202127 | 1            | FINAL         | AY         | 2021   | AECT-2127     | AEBC-19TRN2021          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202127 | 1            | FINAL         | AY         | 2021   | AECT-2127     | AEBC-19TRN2021          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202127 | 1            | FINAL         | AY         | 2021   | AECT-2127     | AEBC-19TRN2021          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202127 | 1            | FINAL         | AY         | 2021   | AECT-2127     | AEBC-19TRN2021          | 4               | 9001.00     | 0.00          | 0.00            | 9001.00           | 0.00         | 10000.00           |
    | 10202127 | 1            | FINAL         | AY         | 2021   | AECT-2127     | AEBC-19TRN2021          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9001.00     
    | 10202128 | 1            | FINAL         | AY         | 2021   | AECT-2128     | AEBC-19TRN2021          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202128 | 1            | FINAL         | AY         | 2021   | AECT-2128     | AEBC-19TRN2021          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202128 | 1            | FINAL         | AY         | 2021   | AECT-2128     | AEBC-19TRN2021          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202128 | 1            | FINAL         | AY         | 2021   | AECT-2128     | AEBC-19TRN2021          | 4               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 10000.00           |
    | 10202128 | 1            | FINAL         | AY         | 2021   | AECT-2128     | AEBC-19TRN2021          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10000.00    
    | 10202129 | 1            | FINAL         | AY         | 2021   | AECT-2129     | AEBC-19TRN2021          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202129 | 1            | FINAL         | AY         | 2021   | AECT-2129     | AEBC-19TRN2021          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202129 | 1            | FINAL         | AY         | 2021   | AECT-2129     | AEBC-19TRN2021          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202129 | 1            | FINAL         | AY         | 2021   | AECT-2129     | AEBC-19TRN2021          | 4               | 12999.00    | 0.00          | 0.00            | 12999.00          | 0.00         | 10000.00           |
    | 10202129 | 1            | FINAL         | AY         | 2021   | AECT-2129     | AEBC-19TRN2021          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£12999.00    
    | 10202130 | 1            | FINAL         | AY         | 2021   | AECT-2130     | AEBC-19TRN2021          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202130 | 1            | FINAL         | AY         | 2021   | AECT-2130     | AEBC-19TRN2021          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202130 | 1            | FINAL         | AY         | 2021   | AECT-2130     | AEBC-19TRN2021          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202130 | 1            | FINAL         | AY         | 2021   | AECT-2130     | AEBC-19TRN2021          | 4               | 13000.00    | 0.00          | 0.00            | 13000.00          | 0.00         | 10000.00           |
    | 10202130 | 1            | FINAL         | AY         | 2021   | AECT-2130     | AEBC-19TRN2021          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£13000.00    
    | 10202131 | 1            | FINAL         | AY         | 2021   | AECT-2131     | AEBC-19TRN2021          | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202131 | 1            | FINAL         | AY         | 2021   | AECT-2131     | AEBC-19TRN2021          | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202131 | 1            | FINAL         | AY         | 2021   | AECT-2131     | AEBC-19TRN2021          | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202131 | 1            | FINAL         | AY         | 2021   | AECT-2131     | AEBC-19TRN2021          | 4               | 13001.00    | 0.00          | 0.00            | 13001.00          | 0.00         | 10000.00           |
    | 10202131 | 1            | FINAL         | AY         | 2021   | AECT-2131     | AEBC-19TRN2021          | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£13001.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10202124 | 2021          | FINAL           | AEBC-19TRN2021      | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10202125 | 2021          | FINAL           | AEBC-19TRN2021      | 10000.00     | 8999.00      | 8999.00          | -1.00                       | -1.00               |
    | 10202126 | 2021          | FINAL           | AEBC-19TRN2021      | 10000.00     | 9000.00      | 9000.00          | 0.00                        | 0.00                |
    | 10202127 | 2021          | FINAL           | AEBC-19TRN2021      | 10000.00     | 9001.00      | 9001.00          | 0.00                        | 0.00                |
    | 10202128 | 2021          | FINAL           | AEBC-19TRN2021      | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10202129 | 2021          | FINAL           | AEBC-19TRN2021      | 10000.00     | 12999.00     | 12999.00         | 2999.00                     | 2999.00             |
    | 10202130 | 2021          | FINAL           | AEBC-19TRN2021      | 10000.00     | 13000.00     | 13000.00         | 3000.00                     | 3000.00             |
    | 10202131 | 2021          | FINAL           | AEBC-19TRN2021      | 10000.00     | 13001.00     | 13001.00         | 3000.00                     | 3000.00             |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10202124 | 2021          | FINAL           | AECT-2124           | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10202125 | 2021          | FINAL           | AECT-2125           | 10000.00     | 8999.00      | 8999.00          | -1.00                       | -1.00               |
    | 10202126 | 2021          | FINAL           | AECT-2126           | 10000.00     | 9000.00      | 9000.00          | 0.00                        | 0.00                |
    | 10202127 | 2021          | FINAL           | AECT-2127           | 10000.00     | 9001.00      | 9001.00          | 0.00                        | 0.00                |
    | 10202128 | 2021          | FINAL           | AECT-2128           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10202129 | 2021          | FINAL           | AECT-2129           | 10000.00     | 12999.00     | 12999.00         | 2999.00                     | 2999.00             |
    | 10202130 | 2021          | FINAL           | AECT-2130           | 10000.00     | 13000.00     | 13000.00         | 3000.00                     | 3000.00             |
    | 10202131 | 2021          | FINAL           | AECT-2131           | 10000.00     | 13001.00     | 13001.00         | 3000.00                     | 3000.00             |

@DoNotRun_7Mar2024
@FundingClaimCalculation
Scenario: D573 Final Funding Claim Reconciliation Calculations for AEBC-CSO2021

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
    | 10202132 | 1            | FINAL         | AY         | 2021   | AEBC-CSO2021        |
    | 10202133 | 1            | FINAL         | AY         | 2021   | AEBC-CSO2021        |
    | 10202134 | 1            | FINAL         | AY         | 2021   | AEBC-CSO2021        |
    | 10202135 | 1            | FINAL         | AY         | 2021   | AEBC-CSO2021        |
    | 10202136 | 1            | FINAL         | AY         | 2021   | AEBC-CSO2021        |
    | 10202137 | 1            | FINAL         | AY         | 2021   | AEBC-CSO2021        |
    | 10202138 | 1            | FINAL         | AY         | 2021   | AEBC-CSO2021        |
    | 10202139 | 1            | FINAL         | AY         | 2021   | AEBC-CSO2021        |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10202132 | 1            | FINAL         | AY         | 2021   | AECS-2132     | AEBC-CSO2021        | AEBC-CSO2021            | 10000.00        |
    | 10202133 | 1            | FINAL         | AY         | 2021   | AECS-2133     | AEBC-CSO2021        | AEBC-CSO2021            | 10000.00        |
    | 10202134 | 1            | FINAL         | AY         | 2021   | AECS-2134     | AEBC-CSO2021        | AEBC-CSO2021            | 10000.00        |
    | 10202135 | 1            | FINAL         | AY         | 2021   | AECS-2135     | AEBC-CSO2021        | AEBC-CSO2021            | 10000.00        |
    | 10202136 | 1            | FINAL         | AY         | 2021   | AECS-2136     | AEBC-CSO2021        | AEBC-CSO2021            | 10000.00        |
    | 10202137 | 1            | FINAL         | AY         | 2021   | AECS-2137     | AEBC-CSO2021        | AEBC-CSO2021            | 10000.00        |
    | 10202138 | 1            | FINAL         | AY         | 2021   | AECS-2138     | AEBC-CSO2021        | AEBC-CSO2021            | 10000.00        |
    | 10202139 | 1            | FINAL         | AY         | 2021   | AECS-2139     | AEBC-CSO2021        | AEBC-CSO2021            | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10202132 | 1            | FINAL         | AY         | 2021   | AECS-2132     | AEBC-CSO2021            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202132 | 1            | FINAL         | AY         | 2021   | AECS-2132     | AEBC-CSO2021            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202132 | 1            | FINAL         | AY         | 2021   | AECS-2132     | AEBC-CSO2021            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202132 | 1            | FINAL         | AY         | 2021   | AECS-2132     | AEBC-CSO2021            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202132 | 1            | FINAL         | AY         | 2021   | AECS-2132     | AEBC-CSO2021            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202132 | 1            | FINAL         | AY         | 2021   | AECS-2132     | AEBC-CSO2021            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£0.00        
    | 10202133 | 1            | FINAL         | AY         | 2021   | AECS-2133     | AEBC-CSO2021            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202133 | 1            | FINAL         | AY         | 2021   | AECS-2133     | AEBC-CSO2021            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202133 | 1            | FINAL         | AY         | 2021   | AECS-2133     | AEBC-CSO2021            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202133 | 1            | FINAL         | AY         | 2021   | AECS-2133     | AEBC-CSO2021            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202133 | 1            | FINAL         | AY         | 2021   | AECS-2133     | AEBC-CSO2021            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202133 | 1            | FINAL         | AY         | 2021   | AECS-2133     | AEBC-CSO2021            | 5               | 9699.00     | 0.00          | 0.00            | 9699.00           | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9699.00     
    | 10202134 | 1            | FINAL         | AY         | 2021   | AECS-2134     | AEBC-CSO2021            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202134 | 1            | FINAL         | AY         | 2021   | AECS-2134     | AEBC-CSO2021            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202134 | 1            | FINAL         | AY         | 2021   | AECS-2134     | AEBC-CSO2021            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202134 | 1            | FINAL         | AY         | 2021   | AECS-2134     | AEBC-CSO2021            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202134 | 1            | FINAL         | AY         | 2021   | AECS-2134     | AEBC-CSO2021            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202134 | 1            | FINAL         | AY         | 2021   | AECS-2134     | AEBC-CSO2021            | 5               | 9700.00     | 0.00          | 0.00            | 9700.00           | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9700.00     
    | 10202135 | 1            | FINAL         | AY         | 2021   | AECS-2135     | AEBC-CSO2021            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202135 | 1            | FINAL         | AY         | 2021   | AECS-2135     | AEBC-CSO2021            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202135 | 1            | FINAL         | AY         | 2021   | AECS-2135     | AEBC-CSO2021            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202135 | 1            | FINAL         | AY         | 2021   | AECS-2135     | AEBC-CSO2021            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202135 | 1            | FINAL         | AY         | 2021   | AECS-2135     | AEBC-CSO2021            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202135 | 1            | FINAL         | AY         | 2021   | AECS-2135     | AEBC-CSO2021            | 5               | 9701.00     | 0.00          | 0.00            | 9701.00           | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9701.00     
    | 10202136 | 1            | FINAL         | AY         | 2021   | AECS-2136     | AEBC-CSO2021            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202136 | 1            | FINAL         | AY         | 2021   | AECS-2136     | AEBC-CSO2021            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202136 | 1            | FINAL         | AY         | 2021   | AECS-2136     | AEBC-CSO2021            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202136 | 1            | FINAL         | AY         | 2021   | AECS-2136     | AEBC-CSO2021            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202136 | 1            | FINAL         | AY         | 2021   | AECS-2136     | AEBC-CSO2021            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202136 | 1            | FINAL         | AY         | 2021   | AECS-2136     | AEBC-CSO2021            | 5               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10000.00    
    | 10202137 | 1            | FINAL         | AY         | 2021   | AECS-2137     | AEBC-CSO2021            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202137 | 1            | FINAL         | AY         | 2021   | AECS-2137     | AEBC-CSO2021            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202137 | 1            | FINAL         | AY         | 2021   | AECS-2137     | AEBC-CSO2021            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202137 | 1            | FINAL         | AY         | 2021   | AECS-2137     | AEBC-CSO2021            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202137 | 1            | FINAL         | AY         | 2021   | AECS-2137     | AEBC-CSO2021            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202137 | 1            | FINAL         | AY         | 2021   | AECS-2137     | AEBC-CSO2021            | 5               | 14999.00    | 0.00          | 0.00            | 14999.00          | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£14999.00    
    | 10202138 | 1            | FINAL         | AY         | 2021   | AECS-2138     | AEBC-CSO2021            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202138 | 1            | FINAL         | AY         | 2021   | AECS-2138     | AEBC-CSO2021            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202138 | 1            | FINAL         | AY         | 2021   | AECS-2138     | AEBC-CSO2021            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202138 | 1            | FINAL         | AY         | 2021   | AECS-2138     | AEBC-CSO2021            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202138 | 1            | FINAL         | AY         | 2021   | AECS-2138     | AEBC-CSO2021            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202138 | 1            | FINAL         | AY         | 2021   | AECS-2138     | AEBC-CSO2021            | 5               | 15000.00    | 0.00          | 0.00            | 15000.00          | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£15000.00    
    | 10202139 | 1            | FINAL         | AY         | 2021   | AECS-2139     | AEBC-CSO2021            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202139 | 1            | FINAL         | AY         | 2021   | AECS-2139     | AEBC-CSO2021            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202139 | 1            | FINAL         | AY         | 2021   | AECS-2139     | AEBC-CSO2021            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202139 | 1            | FINAL         | AY         | 2021   | AECS-2139     | AEBC-CSO2021            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202139 | 1            | FINAL         | AY         | 2021   | AECS-2139     | AEBC-CSO2021            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202139 | 1            | FINAL         | AY         | 2021   | AECS-2139     | AEBC-CSO2021            | 5               | 15001.00    | 0.00          | 0.00            | 15001.00          | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£15001.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10202132 | 2021          | FINAL           | AEBC-CSO2021        | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10202133 | 2021          | FINAL           | AEBC-CSO2021        | 10000.00     | 9699.00      | 9699.00          | -301.00                     | -301.00             |
    | 10202134 | 2021          | FINAL           | AEBC-CSO2021        | 10000.00     | 9700.00      | 9700.00          | 0.00                        | 0.00                |
    | 10202135 | 2021          | FINAL           | AEBC-CSO2021        | 10000.00     | 9701.00      | 9701.00          | 0.00                        | 0.00                |
    | 10202136 | 2021          | FINAL           | AEBC-CSO2021        | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10202137 | 2021          | FINAL           | AEBC-CSO2021        | 10000.00     | 14999.00     | 14999.00         | 4999.00                     | 4999.00             |
    | 10202138 | 2021          | FINAL           | AEBC-CSO2021        | 10000.00     | 15000.00     | 15000.00         | 5000.00                     | 5000.00             |
    | 10202139 | 2021          | FINAL           | AEBC-CSO2021        | 10000.00     | 15001.00     | 15001.00         | 5000.00                     | 5000.00             |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10202132 | 2021          | FINAL           | AECS-2132           | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10202133 | 2021          | FINAL           | AECS-2133           | 10000.00     | 9699.00      | 9699.00          | -301.00                     | -301.00             |
    | 10202134 | 2021          | FINAL           | AECS-2134           | 10000.00     | 9700.00      | 9700.00          | 0.00                        | 0.00                |
    | 10202135 | 2021          | FINAL           | AECS-2135           | 10000.00     | 9701.00      | 9701.00          | 0.00                        | 0.00                |
    | 10202136 | 2021          | FINAL           | AECS-2136           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10202137 | 2021          | FINAL           | AECS-2137           | 10000.00     | 14999.00     | 14999.00         | 4999.00                     | 4999.00             |
    | 10202138 | 2021          | FINAL           | AECS-2138           | 10000.00     | 15000.00     | 15000.00         | 5000.00                     | 5000.00             |
    | 10202139 | 2021          | FINAL           | AECS-2139           | 10000.00     | 15001.00     | 15001.00         | 5000.00                     | 5000.00             |

@DoNotRun_7Mar2024 
@FundingClaimCalculation
Scenario: D574 Final Funding Claim Reconciliation Calculations for AEB-ASLS2021

    # 40 Under-delivery - Delivers nothing
    # 41 Under-delivery - Minimal
    # 42 Variance = £0
    # 43 Over-delivery  - Variance within Limit
    # 44 Over-delivery  - Variance = Limit
    # 45 Over-delivery  - Variance exceeds Limit

    Given there are no Allocations in PaaS (Performance Management)

    And   the following debatched funding claims are received
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationGroupCode |
    | 10202140 | 1            | FINAL         | AY         | 2021   | AEB-ASLS2021        |
    | 10202141 | 1            | FINAL         | AY         | 2021   | AEB-ASLS2021        |
    | 10202142 | 1            | FINAL         | AY         | 2021   | AEB-ASLS2021        |
    | 10202143 | 1            | FINAL         | AY         | 2021   | AEB-ASLS2021        |
    | 10202144 | 1            | FINAL         | AY         | 2021   | AEB-ASLS2021        |
    | 10202145 | 1            | FINAL         | AY         | 2021   | AEB-ASLS2021        |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10202140 | 1            | FINAL         | AY         | 2021   | AEAL-2140     | AEB-ASLS2021        | AEB-ASLS2021            | 10000.00        |
    | 10202141 | 1            | FINAL         | AY         | 2021   | AEAL-2141     | AEB-ASLS2021        | AEB-ASLS2021            | 10000.00        |
    | 10202142 | 1            | FINAL         | AY         | 2021   | AEAL-2142     | AEB-ASLS2021        | AEB-ASLS2021            | 10000.00        |
    | 10202143 | 1            | FINAL         | AY         | 2021   | AEAL-2143     | AEB-ASLS2021        | AEB-ASLS2021            | 10000.00        |
    | 10202144 | 1            | FINAL         | AY         | 2021   | AEAL-2144     | AEB-ASLS2021        | AEB-ASLS2021            | 10000.00        |
    | 10202145 | 1            | FINAL         | AY         | 2021   | AEAL-2145     | AEB-ASLS2021        | AEB-ASLS2021            | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10202140 | 1            | FINAL         | AY         | 2021   | AEAL-2140     | AEB-ASLS2021            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202140 | 1            | FINAL         | AY         | 2021   | AEAL-2140     | AEB-ASLS2021            | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202140 | 1            | FINAL         | AY         | 2021   | AEAL-2140     | AEB-ASLS2021            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202140 | 1            | FINAL         | AY         | 2021   | AEAL-2140     | AEB-ASLS2021            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202140 | 1            | FINAL         | AY         | 2021   | AEAL-2140     | AEB-ASLS2021            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202140 | 1            | FINAL         | AY         | 2021   | AEAL-2140     | AEB-ASLS2021            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£0.00        
    | 10202141 | 1            | FINAL         | AY         | 2021   | AEAL-2141     | AEB-ASLS2021            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202141 | 1            | FINAL         | AY         | 2021   | AEAL-2141     | AEB-ASLS2021            | 2               | 9999.00     | 0.00          | 0.00            | 9999.00           | 0.00         | 10000.00           |
    | 10202141 | 1            | FINAL         | AY         | 2021   | AEAL-2141     | AEB-ASLS2021            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202141 | 1            | FINAL         | AY         | 2021   | AEAL-2141     | AEB-ASLS2021            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202141 | 1            | FINAL         | AY         | 2021   | AEAL-2141     | AEB-ASLS2021            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202141 | 1            | FINAL         | AY         | 2021   | AEAL-2141     | AEB-ASLS2021            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9999.00     
    | 10202142 | 1            | FINAL         | AY         | 2021   | AEAL-2142     | AEB-ASLS2021            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202142 | 1            | FINAL         | AY         | 2021   | AEAL-2142     | AEB-ASLS2021            | 2               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 10000.00           |
    | 10202142 | 1            | FINAL         | AY         | 2021   | AEAL-2142     | AEB-ASLS2021            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202142 | 1            | FINAL         | AY         | 2021   | AEAL-2142     | AEB-ASLS2021            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202142 | 1            | FINAL         | AY         | 2021   | AEAL-2142     | AEB-ASLS2021            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202142 | 1            | FINAL         | AY         | 2021   | AEAL-2142     | AEB-ASLS2021            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10000.00    
    | 10202143 | 1            | FINAL         | AY         | 2021   | AEAL-2143     | AEB-ASLS2021            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202143 | 1            | FINAL         | AY         | 2021   | AEAL-2143     | AEB-ASLS2021            | 2               | 10299.00    | 0.00          | 0.00            | 10299.00          | 0.00         | 10000.00           |
    | 10202143 | 1            | FINAL         | AY         | 2021   | AEAL-2143     | AEB-ASLS2021            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202143 | 1            | FINAL         | AY         | 2021   | AEAL-2143     | AEB-ASLS2021            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202143 | 1            | FINAL         | AY         | 2021   | AEAL-2143     | AEB-ASLS2021            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202143 | 1            | FINAL         | AY         | 2021   | AEAL-2143     | AEB-ASLS2021            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10299.00    
    | 10202144 | 1            | FINAL         | AY         | 2021   | AEAL-2144     | AEB-ASLS2021            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202144 | 1            | FINAL         | AY         | 2021   | AEAL-2144     | AEB-ASLS2021            | 2               | 10300.00    | 0.00          | 0.00            | 10300.00          | 0.00         | 10000.00           |
    | 10202144 | 1            | FINAL         | AY         | 2021   | AEAL-2144     | AEB-ASLS2021            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202144 | 1            | FINAL         | AY         | 2021   | AEAL-2144     | AEB-ASLS2021            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202144 | 1            | FINAL         | AY         | 2021   | AEAL-2144     | AEB-ASLS2021            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202144 | 1            | FINAL         | AY         | 2021   | AEAL-2144     | AEB-ASLS2021            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10300.00    
    | 10202145 | 1            | FINAL         | AY         | 2021   | AEAL-2145     | AEB-ASLS2021            | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202145 | 1            | FINAL         | AY         | 2021   | AEAL-2145     | AEB-ASLS2021            | 2               | 10301.00    | 0.00          | 0.00            | 10301.00          | 0.00         | 10000.00           |
    | 10202145 | 1            | FINAL         | AY         | 2021   | AEAL-2145     | AEB-ASLS2021            | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202145 | 1            | FINAL         | AY         | 2021   | AEAL-2145     | AEB-ASLS2021            | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202145 | 1            | FINAL         | AY         | 2021   | AEAL-2145     | AEB-ASLS2021            | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202145 | 1            | FINAL         | AY         | 2021   | AEAL-2145     | AEB-ASLS2021            | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10301.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10202140 | 2021          | FINAL           | AEB-ASLS2021        | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10202141 | 2021          | FINAL           | AEB-ASLS2021        | 10000.00     | 9999.00      | 9999.00          | -1.00                       | -1.00               |
    | 10202142 | 2021          | FINAL           | AEB-ASLS2021        | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10202143 | 2021          | FINAL           | AEB-ASLS2021        | 10000.00     | 10299.00     | 10299.00         | 299.00                      | 299.00              |
    | 10202144 | 2021          | FINAL           | AEB-ASLS2021        | 10000.00     | 10300.00     | 10300.00         | 300.00                      | 300.00              |
    | 10202145 | 2021          | FINAL           | AEB-ASLS2021        | 10000.00     | 10301.00     | 10301.00         | 300.00                      | 300.00              |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10202140 | 2021          | FINAL           | AEAL-2140           | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10202141 | 2021          | FINAL           | AEAL-2141           | 10000.00     | 9999.00      | 9999.00          | -1.00                       | -1.00               |
    | 10202142 | 2021          | FINAL           | AEAL-2142           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10202143 | 2021          | FINAL           | AEAL-2143           | 10000.00     | 10299.00     | 10299.00         | 299.00                      | 299.00              |
    | 10202144 | 2021          | FINAL           | AEAL-2144           | 10000.00     | 10300.00     | 10300.00         | 300.00                      | 300.00              |
    | 10202145 | 2021          | FINAL           | AEAL-2145           | 10000.00     | 10301.00     | 10301.00         | 300.00                      | 300.00              |

@DoNotRun_7Mar2024 
@FundingClaimCalculation
Scenario: D575 Final Funding Claim Reconciliation Calculations for AEB-19TRLS2021 & 19TRN2020-LS2021

    # 46 Under-delivery - Delivers nothing
    # 47 Under-delivery - Minimal
    # 48 Variance = £0
    # 49 Over-delivery  - Variance within Limit
    # 50 Over-delivery  - Variance = Limit
    # 51 Over-delivery  - Variance exceeds Limit

    Given there are no Allocations in PaaS (Performance Management)

    And   the following debatched funding claims are received
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationGroupCode |
    | 10202146 | 1            | FINAL         | AY         | 2021   | 19TRN2020-LS2021    |
    | 10202147 | 1            | FINAL         | AY         | 2021   | 19TRN2020-LS2021    |
    | 10202148 | 1            | FINAL         | AY         | 2021   | 19TRN2020-LS2021    |
    | 10202149 | 1            | FINAL         | AY         | 2021   | 19TRN2020-LS2021    |
    | 10202150 | 1            | FINAL         | AY         | 2021   | 19TRN2020-LS2021    |
    | 10202151 | 1            | FINAL         | AY         | 2021   | 19TRN2020-LS2021    |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10202146 | 1            | FINAL         | AY         | 2021   | 19TL-2146     | 19TRN2020-LS2021    | 19TRN2020-LS2021        | 10000.00        |
    | 10202147 | 1            | FINAL         | AY         | 2021   | 19TL-2147     | 19TRN2020-LS2021    | 19TRN2020-LS2021        | 10000.00        |
    | 10202148 | 1            | FINAL         | AY         | 2021   | 19TL-2148     | 19TRN2020-LS2021    | 19TRN2020-LS2021        | 10000.00        |
    | 10202149 | 1            | FINAL         | AY         | 2021   | 19TL-2149     | 19TRN2020-LS2021    | 19TRN2020-LS2021        | 10000.00        |
    | 10202150 | 1            | FINAL         | AY         | 2021   | 19TL-2150     | 19TRN2020-LS2021    | 19TRN2020-LS2021        | 10000.00        |
    | 10202151 | 1            | FINAL         | AY         | 2021   | 19TL-2151     | 19TRN2020-LS2021    | 19TRN2020-LS2021        | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10202146 | 1            | FINAL         | AY         | 2021   | 19TL-2146     | 19TRN2020-LS2021        | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202146 | 1            | FINAL         | AY         | 2021   | 19TL-2146     | 19TRN2020-LS2021        | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202146 | 1            | FINAL         | AY         | 2021   | 19TL-2146     | 19TRN2020-LS2021        | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£0.00        
    | 10202147 | 1            | FINAL         | AY         | 2021   | 19TL-2147     | 19TRN2020-LS2021        | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202147 | 1            | FINAL         | AY         | 2021   | 19TL-2147     | 19TRN2020-LS2021        | 2               | 9999.00     | 0.00          | 0.00            | 9999.00           | 0.00         | 10000.00           |
    | 10202147 | 1            | FINAL         | AY         | 2021   | 19TL-2147     | 19TRN2020-LS2021        | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9999.00     
    | 10202148 | 1            | FINAL         | AY         | 2021   | 19TL-2148     | 19TRN2020-LS2021        | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202148 | 1            | FINAL         | AY         | 2021   | 19TL-2148     | 19TRN2020-LS2021        | 2               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 10000.00           |
    | 10202148 | 1            | FINAL         | AY         | 2021   | 19TL-2148     | 19TRN2020-LS2021        | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10000.00    
    | 10202149 | 1            | FINAL         | AY         | 2021   | 19TL-2149     | 19TRN2020-LS2021        | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202149 | 1            | FINAL         | AY         | 2021   | 19TL-2149     | 19TRN2020-LS2021        | 2               | 12999.00    | 0.00          | 0.00            | 12999.00          | 0.00         | 10000.00           |
    | 10202149 | 1            | FINAL         | AY         | 2021   | 19TL-2149     | 19TRN2020-LS2021        | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£12999.00    
    | 10202150 | 1            | FINAL         | AY         | 2021   | 19TL-2150     | 19TRN2020-LS2021        | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202150 | 1            | FINAL         | AY         | 2021   | 19TL-2150     | 19TRN2020-LS2021        | 2               | 13000.00    | 0.00          | 0.00            | 13000.00          | 0.00         | 10000.00           |
    | 10202150 | 1            | FINAL         | AY         | 2021   | 19TL-2150     | 19TRN2020-LS2021        | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£13000.00    
    | 10202151 | 1            | FINAL         | AY         | 2021   | 19TL-2151     | 19TRN2020-LS2021        | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202151 | 1            | FINAL         | AY         | 2021   | 19TL-2151     | 19TRN2020-LS2021        | 2               | 13001.00    | 0.00          | 0.00            | 13001.00          | 0.00         | 10000.00           |
    | 10202151 | 1            | FINAL         | AY         | 2021   | 19TL-2151     | 19TRN2020-LS2021        | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£13001.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10202146 | 2021          | FINAL           | 19TRN2020-LS2021    | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10202147 | 2021          | FINAL           | 19TRN2020-LS2021    | 10000.00     | 9999.00      | 9999.00          | -1.00                       | -1.00               |
    | 10202148 | 2021          | FINAL           | 19TRN2020-LS2021    | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10202149 | 2021          | FINAL           | 19TRN2020-LS2021    | 10000.00     | 12999.00     | 12999.00         | 2999.00                     | 2999.00             |
    | 10202150 | 2021          | FINAL           | 19TRN2020-LS2021    | 10000.00     | 13000.00     | 13000.00         | 3000.00                     | 3000.00             |
    | 10202151 | 2021          | FINAL           | 19TRN2020-LS2021    | 10000.00     | 13001.00     | 13001.00         | 3000.00                     | 3000.00             |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10202146 | 2021          | FINAL           | 19TL-2146           | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10202147 | 2021          | FINAL           | 19TL-2147           | 10000.00     | 9999.00      | 9999.00          | -1.00                       | -1.00               |
    | 10202148 | 2021          | FINAL           | 19TL-2148           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10202149 | 2021          | FINAL           | 19TL-2149           | 10000.00     | 12999.00     | 12999.00         | 2999.00                     | 2999.00             |
    | 10202150 | 2021          | FINAL           | 19TL-2150           | 10000.00     | 13000.00     | 13000.00         | 3000.00                     | 3000.00             |
    | 10202151 | 2021          | FINAL           | 19TL-2151           | 10000.00     | 13001.00     | 13001.00         | 3000.00                     | 3000.00             |

@DoNotRun_7Mar2024 
@FundingClaimCalculation
Scenario: D576 Final Funding Claim Reconciliation Calculations for ALLBC2021

    # 52 Under-delivery - Delivers nothing
    # 53 Under-delivery - Variance exceeds Tolerance
    # 54 Under-delivery - Variance = Tolerance
    # 55 Under-delivery - Variance within Tolerance
    # 56 Variance = £0
    # 57 Over-delivery  - Small
    # 58 Over-delivery  - Large

    Given there are no Allocations in PaaS (Performance Management)

    And   the following debatched funding claims are received
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationGroupCode |
    | 10202152 | 1            | FINAL         | AY         | 2021   | ALLBC2021           |
    | 10202153 | 1            | FINAL         | AY         | 2021   | ALLBC2021           |
    | 10202154 | 1            | FINAL         | AY         | 2021   | ALLBC2021           |
    | 10202155 | 1            | FINAL         | AY         | 2021   | ALLBC2021           |
    | 10202156 | 1            | FINAL         | AY         | 2021   | ALLBC2021           |
    | 10202157 | 1            | FINAL         | AY         | 2021   | ALLBC2021           |
    | 10202158 | 1            | FINAL         | AY         | 2021   | ALLBC2021           |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10202152 | 1            | FINAL         | AY         | 2021   | ALLC-2152     | ALLBC2021           | ALLBC2021               | 10000.00        |
    | 10202153 | 1            | FINAL         | AY         | 2021   | ALLC-2153     | ALLBC2021           | ALLBC2021               | 10000.00        |
    | 10202154 | 1            | FINAL         | AY         | 2021   | ALLC-2154     | ALLBC2021           | ALLBC2021               | 10000.00        |
    | 10202155 | 1            | FINAL         | AY         | 2021   | ALLC-2155     | ALLBC2021           | ALLBC2021               | 10000.00        |
    | 10202156 | 1            | FINAL         | AY         | 2021   | ALLC-2156     | ALLBC2021           | ALLBC2021               | 10000.00        |
    | 10202157 | 1            | FINAL         | AY         | 2021   | ALLC-2157     | ALLBC2021           | ALLBC2021               | 10000.00        |
    | 10202158 | 1            | FINAL         | AY         | 2021   | ALLC-2158     | ALLBC2021           | ALLBC2021               | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10202152 | 1            | FINAL         | AY         | 2021   | ALLC-2152     | ALLBC2021               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202152 | 1            | FINAL         | AY         | 2021   | ALLC-2152     | ALLBC2021               | 2               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202152 | 1            | FINAL         | AY         | 2021   | ALLC-2152     | ALLBC2021               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202152 | 1            | FINAL         | AY         | 2021   | ALLC-2152     | ALLBC2021               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202152 | 1            | FINAL         | AY         | 2021   | ALLC-2152     | ALLBC2021               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202152 | 1            | FINAL         | AY         | 2021   | ALLC-2152     | ALLBC2021               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202152 | 1            | FINAL         | AY         | 2021   | ALLC-2152     | ALLBC2021               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202152 | 1            | FINAL         | AY         | 2021   | ALLC-2152     | ALLBC2021               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£0.00        
    | 10202153 | 1            | FINAL         | AY         | 2021   | ALLC-2153     | ALLBC2021               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202153 | 1            | FINAL         | AY         | 2021   | ALLC-2153     | ALLBC2021               | 2               | 8999.00     | 0.00          | 0.00            | 8999.00           | 0.00         | 10000.00           |
    | 10202153 | 1            | FINAL         | AY         | 2021   | ALLC-2153     | ALLBC2021               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202153 | 1            | FINAL         | AY         | 2021   | ALLC-2153     | ALLBC2021               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202153 | 1            | FINAL         | AY         | 2021   | ALLC-2153     | ALLBC2021               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202153 | 1            | FINAL         | AY         | 2021   | ALLC-2153     | ALLBC2021               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202153 | 1            | FINAL         | AY         | 2021   | ALLC-2153     | ALLBC2021               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202153 | 1            | FINAL         | AY         | 2021   | ALLC-2153     | ALLBC2021               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£8999.00     
    | 10202154 | 1            | FINAL         | AY         | 2021   | ALLC-2154     | ALLBC2021               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202154 | 1            | FINAL         | AY         | 2021   | ALLC-2154     | ALLBC2021               | 2               | 9000.00     | 0.00          | 0.00            | 9000.00           | 0.00         | 10000.00           |
    | 10202154 | 1            | FINAL         | AY         | 2021   | ALLC-2154     | ALLBC2021               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202154 | 1            | FINAL         | AY         | 2021   | ALLC-2154     | ALLBC2021               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202154 | 1            | FINAL         | AY         | 2021   | ALLC-2154     | ALLBC2021               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202154 | 1            | FINAL         | AY         | 2021   | ALLC-2154     | ALLBC2021               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202154 | 1            | FINAL         | AY         | 2021   | ALLC-2154     | ALLBC2021               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202154 | 1            | FINAL         | AY         | 2021   | ALLC-2154     | ALLBC2021               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9000.00     
    | 10202155 | 1            | FINAL         | AY         | 2021   | ALLC-2155     | ALLBC2021               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202155 | 1            | FINAL         | AY         | 2021   | ALLC-2155     | ALLBC2021               | 2               | 9001.00     | 0.00          | 0.00            | 9001.00           | 0.00         | 10000.00           |
    | 10202155 | 1            | FINAL         | AY         | 2021   | ALLC-2155     | ALLBC2021               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202155 | 1            | FINAL         | AY         | 2021   | ALLC-2155     | ALLBC2021               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202155 | 1            | FINAL         | AY         | 2021   | ALLC-2155     | ALLBC2021               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202155 | 1            | FINAL         | AY         | 2021   | ALLC-2155     | ALLBC2021               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202155 | 1            | FINAL         | AY         | 2021   | ALLC-2155     | ALLBC2021               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202155 | 1            | FINAL         | AY         | 2021   | ALLC-2155     | ALLBC2021               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9001.00     
    | 10202156 | 1            | FINAL         | AY         | 2021   | ALLC-2156     | ALLBC2021               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202156 | 1            | FINAL         | AY         | 2021   | ALLC-2156     | ALLBC2021               | 2               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 10000.00           |
    | 10202156 | 1            | FINAL         | AY         | 2021   | ALLC-2156     | ALLBC2021               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202156 | 1            | FINAL         | AY         | 2021   | ALLC-2156     | ALLBC2021               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202156 | 1            | FINAL         | AY         | 2021   | ALLC-2156     | ALLBC2021               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202156 | 1            | FINAL         | AY         | 2021   | ALLC-2156     | ALLBC2021               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202156 | 1            | FINAL         | AY         | 2021   | ALLC-2156     | ALLBC2021               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202156 | 1            | FINAL         | AY         | 2021   | ALLC-2156     | ALLBC2021               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10000.00    
    | 10202157 | 1            | FINAL         | AY         | 2021   | ALLC-2157     | ALLBC2021               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202157 | 1            | FINAL         | AY         | 2021   | ALLC-2157     | ALLBC2021               | 2               | 10001.00    | 0.00          | 0.00            | 10001.00          | 0.00         | 10000.00           |
    | 10202157 | 1            | FINAL         | AY         | 2021   | ALLC-2157     | ALLBC2021               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202157 | 1            | FINAL         | AY         | 2021   | ALLC-2157     | ALLBC2021               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202157 | 1            | FINAL         | AY         | 2021   | ALLC-2157     | ALLBC2021               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202157 | 1            | FINAL         | AY         | 2021   | ALLC-2157     | ALLBC2021               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202157 | 1            | FINAL         | AY         | 2021   | ALLC-2157     | ALLBC2021               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202157 | 1            | FINAL         | AY         | 2021   | ALLC-2157     | ALLBC2021               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10001.00    
    | 10202158 | 1            | FINAL         | AY         | 2021   | ALLC-2158     | ALLBC2021               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10202158 | 1            | FINAL         | AY         | 2021   | ALLC-2158     | ALLBC2021               | 2               | 21000.00    | 0.00          | 0.00            | 21000.00          | 0.00         | 10000.00           |
    | 10202158 | 1            | FINAL         | AY         | 2021   | ALLC-2158     | ALLBC2021               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202158 | 1            | FINAL         | AY         | 2021   | ALLC-2158     | ALLBC2021               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202158 | 1            | FINAL         | AY         | 2021   | ALLC-2158     | ALLBC2021               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202158 | 1            | FINAL         | AY         | 2021   | ALLC-2158     | ALLBC2021               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202158 | 1            | FINAL         | AY         | 2021   | ALLC-2158     | ALLBC2021               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10202158 | 1            | FINAL         | AY         | 2021   | ALLC-2158     | ALLBC2021               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£21000.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10202152 | 2021          | FINAL           | ALLBC2021           | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10202153 | 2021          | FINAL           | ALLBC2021           | 10000.00     | 8999.00      | 8999.00          | -1.00                       | -1.00               |
    | 10202154 | 2021          | FINAL           | ALLBC2021           | 10000.00     | 9000.00      | 9000.00          | 0.00                        | 0.00                |
    | 10202155 | 2021          | FINAL           | ALLBC2021           | 10000.00     | 9001.00      | 9001.00          | 0.00                        | 0.00                |
    | 10202156 | 2021          | FINAL           | ALLBC2021           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10202157 | 2021          | FINAL           | ALLBC2021           | 10000.00     | 10001.00     | 10001.00         | 0.00                        | 0.00                |
    | 10202158 | 2021          | FINAL           | ALLBC2021           | 10000.00     | 21000.00     | 21000.00         | 0.00                        | 0.00                |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10202152 | 2021          | FINAL           | ALLC-2152           | 10000.00     | 0.00         | 0.00             | -10000.00                   | -10000.00           |
    | 10202153 | 2021          | FINAL           | ALLC-2153           | 10000.00     | 8999.00      | 8999.00          | -1.00                       | -1.00               |
    | 10202154 | 2021          | FINAL           | ALLC-2154           | 10000.00     | 9000.00      | 9000.00          | 0.00                        | 0.00                |
    | 10202155 | 2021          | FINAL           | ALLC-2155           | 10000.00     | 9001.00      | 9001.00          | 0.00                        | 0.00                |
    | 10202156 | 2021          | FINAL           | ALLC-2156           | 10000.00     | 10000.00     | 10000.00         | 0.00                        | 0.00                |
    | 10202157 | 2021          | FINAL           | ALLC-2157           | 10000.00     | 10001.00     | 10001.00         | 0.00                        | 0.00                |
    | 10202158 | 2021          | FINAL           | ALLC-2158           | 10000.00     | 21000.00     | 21000.00         | 0.00                        | 0.00                |

