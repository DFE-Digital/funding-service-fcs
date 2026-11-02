Feature: FundingClaimReconciliationCalculationFor1819

# AEB (Grant) 18/19
# ~~~~~~~~~~~~~~~~~
# 1  No CL; Variance = £0
# 2  No CL; Under-delivery; Variance within Tolerance
# 3	 No CL; Under-delivery; Variance = Tolerance
# 4	 No CL; Under-delivery ; Variance exceeds Tolerance
# 5	 No CL; Over-delivery; Variance within Limit
# 6	 No CL; Over-delivery; Variance = Limit
# 7	 No CL; Over-delivery; Variance exceeds Limit
# 8	 CL not capped; Under-delivery; Variance within Tolerance
# 9	 CL not capped; Under-delivery; Variance exceeds Tolerance
# 10 CL not capped; Over-delivery; Variance within Limit
# 11 CL not capped; Over-delivery; Variance exceeds Limit
# 12 CL capped to zero; Under-delivery; Variance within Tolerance
# 13 CL capped to zero; Under-delivery; Variance exceeds Tolerance
# 14 CL capped to zero; Over-delivery; Variance within Limit
# 15 CL capped to zero; Over-delivery; Variance exceeds Limit
# 16 CL capped to planned; Under-delivery; Variance within Tolerance
# 17 CL capped to planned; Under-delivery; Variance exceeds Tolerance
# 18 CL capped to planned; Over-delivery; Variance within Limit
# 19 CL capped to planned; Over-delivery; Variance exceeds Limit

# AEB Learner Support (Contract) 18/19
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 20 Variance = £0
# 21 Under-delivery
# 22 Over-delivery

# Loans Bursary (Grant) 18/19
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 23 Variance = £0
# 24 Under-delivery
# 25 Over-delivery


@IntegrationTest 
@FundingClaimCalculation @25712 @26008 @26007
Scenario: D547 (I003) Funding Claim Reconciliation Calculations for AEBC1819 with under-delivery
    Given there are no Allocations in PaaS (Performance Management)

    And   the following debatched funding claims are received
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationGroupCode |
    | 10021901 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021902 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021903 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021904 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021908 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021909 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021912 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021913 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021916 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021917 | 1            | FINAL         | AY         | 1819   | AEBC1819            |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10021901 | 1            | FINAL         | AY         | 1819   | AEC-1901      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021902 | 1            | FINAL         | AY         | 1819   | AEC-1902      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021903 | 1            | FINAL         | AY         | 1819   | AEC-1903      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021904 | 1            | FINAL         | AY         | 1819   | AEC-1904      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021908 | 1            | FINAL         | AY         | 1819   | AEC-1908      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021909 | 1            | FINAL         | AY         | 1819   | AEC-1909      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021912 | 1            | FINAL         | AY         | 1819   | AEC-1912      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021913 | 1            | FINAL         | AY         | 1819   | AEC-1913      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021916 | 1            | FINAL         | AY         | 1819   | AEC-1916      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021917 | 1            | FINAL         | AY         | 1819   | AEC-1917      | AEBC1819            | AEBC1819                | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10021901 | 1            | FINAL         | AY         | 1819   | AEC-1901      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021901 | 1            | FINAL         | AY         | 1819   | AEC-1901      | AEBC1819                | 13              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021901 | 1            | FINAL         | AY         | 1819   | AEC-1901      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10021901 | 1            | FINAL         | AY         | 1819   | AEC-1901      | AEBC1819                | 2               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 10000.00           |
    | 10021901 | 1            | FINAL         | AY         | 1819   | AEC-1901      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021901 | 1            | FINAL         | AY         | 1819   | AEC-1901      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021901 | 1            | FINAL         | AY         | 1819   | AEC-1901      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021901 | 1            | FINAL         | AY         | 1819   | AEC-1901      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021901 | 1            | FINAL         | AY         | 1819   | AEC-1901      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021901 | 1            | FINAL         | AY         | 1819   | AEC-1901      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021901 | 1            | FINAL         | AY         | 1819   | AEC-1901      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021901 | 1            | FINAL         | AY         | 1819   | AEC-1901      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10000.00    
    | 10021902 | 1            | FINAL         | AY         | 1819   | AEC-1902      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021902 | 1            | FINAL         | AY         | 1819   | AEC-1902      | AEBC1819                | 13              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021902 | 1            | FINAL         | AY         | 1819   | AEC-1902      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10021902 | 1            | FINAL         | AY         | 1819   | AEC-1902      | AEBC1819                | 2               | 9701.00     | 0.00          | 0.00            | 9701.00           | 0.00         | 10000.00           |
    | 10021902 | 1            | FINAL         | AY         | 1819   | AEC-1902      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021902 | 1            | FINAL         | AY         | 1819   | AEC-1902      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021902 | 1            | FINAL         | AY         | 1819   | AEC-1902      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021902 | 1            | FINAL         | AY         | 1819   | AEC-1902      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021902 | 1            | FINAL         | AY         | 1819   | AEC-1902      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021902 | 1            | FINAL         | AY         | 1819   | AEC-1902      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021902 | 1            | FINAL         | AY         | 1819   | AEC-1902      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021902 | 1            | FINAL         | AY         | 1819   | AEC-1902      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9701.00     
    | 10021903 | 1            | FINAL         | AY         | 1819   | AEC-1903      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021903 | 1            | FINAL         | AY         | 1819   | AEC-1903      | AEBC1819                | 13              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021903 | 1            | FINAL         | AY         | 1819   | AEC-1903      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10021903 | 1            | FINAL         | AY         | 1819   | AEC-1903      | AEBC1819                | 2               | 9700.00     | 0.00          | 0.00            | 9700.00           | 0.00         | 10000.00           |
    | 10021903 | 1            | FINAL         | AY         | 1819   | AEC-1903      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021903 | 1            | FINAL         | AY         | 1819   | AEC-1903      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021903 | 1            | FINAL         | AY         | 1819   | AEC-1903      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021903 | 1            | FINAL         | AY         | 1819   | AEC-1903      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021903 | 1            | FINAL         | AY         | 1819   | AEC-1903      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021903 | 1            | FINAL         | AY         | 1819   | AEC-1903      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021903 | 1            | FINAL         | AY         | 1819   | AEC-1903      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021903 | 1            | FINAL         | AY         | 1819   | AEC-1903      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9700.00     
    | 10021904 | 1            | FINAL         | AY         | 1819   | AEC-1904      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021904 | 1            | FINAL         | AY         | 1819   | AEC-1904      | AEBC1819                | 13              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021904 | 1            | FINAL         | AY         | 1819   | AEC-1904      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10021904 | 1            | FINAL         | AY         | 1819   | AEC-1904      | AEBC1819                | 2               | 9699.00     | 0.00          | 0.00            | 9699.00           | 0.00         | 10000.00           |
    | 10021904 | 1            | FINAL         | AY         | 1819   | AEC-1904      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021904 | 1            | FINAL         | AY         | 1819   | AEC-1904      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021904 | 1            | FINAL         | AY         | 1819   | AEC-1904      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021904 | 1            | FINAL         | AY         | 1819   | AEC-1904      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021904 | 1            | FINAL         | AY         | 1819   | AEC-1904      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021904 | 1            | FINAL         | AY         | 1819   | AEC-1904      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021904 | 1            | FINAL         | AY         | 1819   | AEC-1904      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021904 | 1            | FINAL         | AY         | 1819   | AEC-1904      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9699.00     
    | 10021908 | 1            | FINAL         | AY         | 1819   | AEC-1908      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021908 | 1            | FINAL         | AY         | 1819   | AEC-1908      | AEBC1819                | 13              | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 10000.00           |
    | 10021908 | 1            | FINAL         | AY         | 1819   | AEC-1908      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10021908 | 1            | FINAL         | AY         | 1819   | AEC-1908      | AEBC1819                | 2               | 9001.00     | 0.00          | 0.00            | 9001.00           | 0.00         | 9200.00            |
    | 10021908 | 1            | FINAL         | AY         | 1819   | AEC-1908      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021908 | 1            | FINAL         | AY         | 1819   | AEC-1908      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021908 | 1            | FINAL         | AY         | 1819   | AEC-1908      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021908 | 1            | FINAL         | AY         | 1819   | AEC-1908      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021908 | 1            | FINAL         | AY         | 1819   | AEC-1908      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021908 | 1            | FINAL         | AY         | 1819   | AEC-1908      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021908 | 1            | FINAL         | AY         | 1819   | AEC-1908      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021908 | 1            | FINAL         | AY         | 1819   | AEC-1908      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£9701.00     
    | 10021909 | 1            | FINAL         | AY         | 1819   | AEC-1909      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021909 | 1            | FINAL         | AY         | 1819   | AEC-1909      | AEBC1819                | 13              | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 10000.00           |
    | 10021909 | 1            | FINAL         | AY         | 1819   | AEC-1909      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10021909 | 1            | FINAL         | AY         | 1819   | AEC-1909      | AEBC1819                | 2               | 8999.00     | 0.00          | 0.00            | 8999.00           | 0.00         | 9200.00            |
    | 10021909 | 1            | FINAL         | AY         | 1819   | AEC-1909      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021909 | 1            | FINAL         | AY         | 1819   | AEC-1909      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021909 | 1            | FINAL         | AY         | 1819   | AEC-1909      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021909 | 1            | FINAL         | AY         | 1819   | AEC-1909      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021909 | 1            | FINAL         | AY         | 1819   | AEC-1909      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021909 | 1            | FINAL         | AY         | 1819   | AEC-1909      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021909 | 1            | FINAL         | AY         | 1819   | AEC-1909      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021909 | 1            | FINAL         | AY         | 1819   | AEC-1909      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£9699.00     
    | 10021912 | 1            | FINAL         | AY         | 1819   | AEC-1912      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021912 | 1            | FINAL         | AY         | 1819   | AEC-1912      | AEBC1819                | 13              | 700.00      | 0.00          | 0.00            | 700.00            | 0.00         | 10000.00           |
    | 10021912 | 1            | FINAL         | AY         | 1819   | AEC-1912      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10021912 | 1            | FINAL         | AY         | 1819   | AEC-1912      | AEBC1819                | 2               | 9701.00     | 0.00          | 0.00            | 9701.00           | 0.00         | 10000.00           |
    | 10021912 | 1            | FINAL         | AY         | 1819   | AEC-1912      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021912 | 1            | FINAL         | AY         | 1819   | AEC-1912      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021912 | 1            | FINAL         | AY         | 1819   | AEC-1912      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021912 | 1            | FINAL         | AY         | 1819   | AEC-1912      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021912 | 1            | FINAL         | AY         | 1819   | AEC-1912      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021912 | 1            | FINAL         | AY         | 1819   | AEC-1912      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021912 | 1            | FINAL         | AY         | 1819   | AEC-1912      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021912 | 1            | FINAL         | AY         | 1819   | AEC-1912      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10401.00    
    | 10021913 | 1            | FINAL         | AY         | 1819   | AEC-1913      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021913 | 1            | FINAL         | AY         | 1819   | AEC-1913      | AEBC1819                | 13              | 700.00      | 0.00          | 0.00            | 700.00            | 0.00         | 10000.00           |
    | 10021913 | 1            | FINAL         | AY         | 1819   | AEC-1913      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10021913 | 1            | FINAL         | AY         | 1819   | AEC-1913      | AEBC1819                | 2               | 9699.00     | 0.00          | 0.00            | 9699.00           | 0.00         | 10000.00           |
    | 10021913 | 1            | FINAL         | AY         | 1819   | AEC-1913      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021913 | 1            | FINAL         | AY         | 1819   | AEC-1913      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021913 | 1            | FINAL         | AY         | 1819   | AEC-1913      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021913 | 1            | FINAL         | AY         | 1819   | AEC-1913      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021913 | 1            | FINAL         | AY         | 1819   | AEC-1913      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021913 | 1            | FINAL         | AY         | 1819   | AEC-1913      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021913 | 1            | FINAL         | AY         | 1819   | AEC-1913      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021913 | 1            | FINAL         | AY         | 1819   | AEC-1913      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10399.00    
    | 10021916 | 1            | FINAL         | AY         | 1819   | AEC-1916      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021916 | 1            | FINAL         | AY         | 1819   | AEC-1916      | AEBC1819                | 13              | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 10000.00           |
    | 10021916 | 1            | FINAL         | AY         | 1819   | AEC-1916      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10021916 | 1            | FINAL         | AY         | 1819   | AEC-1916      | AEBC1819                | 2               | 8901.00     | 0.00          | 0.00            | 8901.00           | 0.00         | 9200.00            |
    | 10021916 | 1            | FINAL         | AY         | 1819   | AEC-1916      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021916 | 1            | FINAL         | AY         | 1819   | AEC-1916      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021916 | 1            | FINAL         | AY         | 1819   | AEC-1916      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021916 | 1            | FINAL         | AY         | 1819   | AEC-1916      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021916 | 1            | FINAL         | AY         | 1819   | AEC-1916      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021916 | 1            | FINAL         | AY         | 1819   | AEC-1916      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021916 | 1            | FINAL         | AY         | 1819   | AEC-1916      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021916 | 1            | FINAL         | AY         | 1819   | AEC-1916      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£9801.00     
    | 10021917 | 1            | FINAL         | AY         | 1819   | AEC-1917      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021917 | 1            | FINAL         | AY         | 1819   | AEC-1917      | AEBC1819                | 13              | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 10000.00           |
    | 10021917 | 1            | FINAL         | AY         | 1819   | AEC-1917      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10021917 | 1            | FINAL         | AY         | 1819   | AEC-1917      | AEBC1819                | 2               | 8899.00     | 0.00          | 0.00            | 8899.00           | 0.00         | 9200.00            |
    | 10021917 | 1            | FINAL         | AY         | 1819   | AEC-1917      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021917 | 1            | FINAL         | AY         | 1819   | AEC-1917      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021917 | 1            | FINAL         | AY         | 1819   | AEC-1917      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021917 | 1            | FINAL         | AY         | 1819   | AEC-1917      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021917 | 1            | FINAL         | AY         | 1819   | AEC-1917      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021917 | 1            | FINAL         | AY         | 1819   | AEC-1917      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021917 | 1            | FINAL         | AY         | 1819   | AEC-1917      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021917 | 1            | FINAL         | AY         | 1819   | AEC-1917      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£9799.00     

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10021901 | 1819          | FINAL           | AEBC1819            | 10000.00     | 10000        | 10000            | 0                           | 0                   |
    | 10021902 | 1819          | FINAL           | AEBC1819            | 10000.00     | 9701         | 9701             | 0                           | 0                   |
    | 10021903 | 1819          | FINAL           | AEBC1819            | 10000.00     | 9700         | 9700             | 0                           | 0                   |
    | 10021904 | 1819          | FINAL           | AEBC1819            | 10000.00     | 9699         | 9699             | -301                        | -301                |
    | 10021908 | 1819          | FINAL           | AEBC1819            | 10000.00     | 9701         | 9701             | 0                           | 0                   |
    | 10021909 | 1819          | FINAL           | AEBC1819            | 10000.00     | 9699         | 9699             | -301                        | -301                |
    | 10021912 | 1819          | FINAL           | AEBC1819            | 10000.00     | 10401        | 9701             | 0                           | 0                   |
    | 10021913 | 1819          | FINAL           | AEBC1819            | 10000.00     | 10399        | 9699             | -301                        | -301                |
    | 10021916 | 1819          | FINAL           | AEBC1819            | 10000.00     | 9801         | 9701             | 0                           | 0                   |
    | 10021917 | 1819          | FINAL           | AEBC1819            | 10000.00     | 9799         | 9699             | -301                        | -301                |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10021901 | 1819          | FINAL           | AEC-1901            | 10000.00     | 10000        | 10000            | 0                           | 0                   |
    | 10021902 | 1819          | FINAL           | AEC-1902            | 10000.00     | 9701         | 9701             | 0                           | 0                   |
    | 10021903 | 1819          | FINAL           | AEC-1903            | 10000.00     | 9700         | 9700             | 0                           | 0                   |
    | 10021904 | 1819          | FINAL           | AEC-1904            | 10000.00     | 9699         | 9699             | -301                        | -301                |
    | 10021908 | 1819          | FINAL           | AEC-1908            | 10000.00     | 9701         | 9701             | 0                           | 0                   |
    | 10021909 | 1819          | FINAL           | AEC-1909            | 10000.00     | 9699         | 9699             | -301                        | -301                |
    | 10021912 | 1819          | FINAL           | AEC-1912            | 10000.00     | 10401        | 9701             | 0                           | 0                   |
    | 10021913 | 1819          | FINAL           | AEC-1913            | 10000.00     | 10399        | 9699             | -301                        | -301                |
    | 10021916 | 1819          | FINAL           | AEC-1916            | 10000.00     | 9801         | 9701             | 0                           | 0                   |
    | 10021917 | 1819          | FINAL           | AEC-1917            | 10000.00     | 9799         | 9699             | -301                        | -301                |


@DoNotRun_7Mar2024 
@FundingClaimCalculation @25712 @26008 @26007
Scenario: D548 (I004) Funding Claim Reconciliation Calculations for AEB-LS1819 and ALLBC1819
    Given there are no Allocations in PaaS (Performance Management)

    And   the following debatched funding claims are received
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationGroupCode |
    | 10021920 | 1            | FINAL         | AY         | 1819   | AEB-LS1819          |
    | 10021921 | 1            | FINAL         | AY         | 1819   | AEB-LS1819          |
    | 10021922 | 1            | FINAL         | AY         | 1819   | AEB-LS1819          |
	#
    | 10021923 | 1            | FINAL         | AY         | 1819   | ALLBC1819           |
    | 10021924 | 1            | FINAL         | AY         | 1819   | ALLBC1819           |
    | 10021925 | 1            | FINAL         | AY         | 1819   | ALLBC1819           |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10021920 | 1            | FINAL         | AY         | 1819   | AEBL-1920     | AEB-LS1819          | AEB-LS1819              | 10000.00        |
    | 10021921 | 1            | FINAL         | AY         | 1819   | AEBL-1921     | AEB-LS1819          | AEB-LS1819              | 10000.00        |
    | 10021922 | 1            | FINAL         | AY         | 1819   | AEBL-1922     | AEB-LS1819          | AEB-LS1819              | 10000.00        |
	#
    | 10021923 | 1            | FINAL         | AY         | 1819   | ALLC-1923     | ALLBC1819           | ALLBC1819               | 10000.00        |
    | 10021924 | 1            | FINAL         | AY         | 1819   | ALLC-1924     | ALLBC1819           | ALLBC1819               | 10000.00        |
    | 10021925 | 1            | FINAL         | AY         | 1819   | ALLC-1925     | ALLBC1819           | ALLBC1819               | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10021920 | 1            | FINAL         | AY         | 1819   | AEBL-1920     | AEB-LS1819              | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021920 | 1            | FINAL         | AY         | 1819   | AEBL-1920     | AEB-LS1819              | 2               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 10000.00           |
    | 10021920 | 1            | FINAL         | AY         | 1819   | AEBL-1920     | AEB-LS1819              | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021920 | 1            | FINAL         | AY         | 1819   | AEBL-1920     | AEB-LS1819              | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021920 | 1            | FINAL         | AY         | 1819   | AEBL-1920     | AEB-LS1819              | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10000.00    
    | 10021921 | 1            | FINAL         | AY         | 1819   | AEBL-1921     | AEB-LS1819              | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021921 | 1            | FINAL         | AY         | 1819   | AEBL-1921     | AEB-LS1819              | 2               | 9901.00     | 0.00          | 0.00            | 9901.00           | 0.00         | 10000.00           |
    | 10021921 | 1            | FINAL         | AY         | 1819   | AEBL-1921     | AEB-LS1819              | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021921 | 1            | FINAL         | AY         | 1819   | AEBL-1921     | AEB-LS1819              | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021921 | 1            | FINAL         | AY         | 1819   | AEBL-1921     | AEB-LS1819              | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9901.00     
    | 10021922 | 1            | FINAL         | AY         | 1819   | AEBL-1922     | AEB-LS1819              | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021922 | 1            | FINAL         | AY         | 1819   | AEBL-1922     | AEB-LS1819              | 2               | 10099.00    | 0.00          | 0.00            | 10099.00          | 0.00         | 10000.00           |
    | 10021922 | 1            | FINAL         | AY         | 1819   | AEBL-1922     | AEB-LS1819              | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021922 | 1            | FINAL         | AY         | 1819   | AEBL-1922     | AEB-LS1819              | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021922 | 1            | FINAL         | AY         | 1819   | AEBL-1922     | AEB-LS1819              | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10099.00    
    | 10021923 | 1            | FINAL         | AY         | 1819   | ALLC-1923     | ALLBC1819               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021923 | 1            | FINAL         | AY         | 1819   | ALLC-1923     | ALLBC1819               | 2               | 10000.00    | 0.00          | 0.00            | 10000.00          | 0.00         | 10000.00           |
    | 10021923 | 1            | FINAL         | AY         | 1819   | ALLC-1923     | ALLBC1819               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021923 | 1            | FINAL         | AY         | 1819   | ALLC-1923     | ALLBC1819               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021923 | 1            | FINAL         | AY         | 1819   | ALLC-1923     | ALLBC1819               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021923 | 1            | FINAL         | AY         | 1819   | ALLC-1923     | ALLBC1819               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021923 | 1            | FINAL         | AY         | 1819   | ALLC-1923     | ALLBC1819               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021923 | 1            | FINAL         | AY         | 1819   | ALLC-1923     | ALLBC1819               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10000.00    
    | 10021924 | 1            | FINAL         | AY         | 1819   | ALLC-1924     | ALLBC1819               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021924 | 1            | FINAL         | AY         | 1819   | ALLC-1924     | ALLBC1819               | 2               | 9901.00     | 0.00          | 0.00            | 9901.00           | 0.00         | 10000.00           |
    | 10021924 | 1            | FINAL         | AY         | 1819   | ALLC-1924     | ALLBC1819               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021924 | 1            | FINAL         | AY         | 1819   | ALLC-1924     | ALLBC1819               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021924 | 1            | FINAL         | AY         | 1819   | ALLC-1924     | ALLBC1819               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021924 | 1            | FINAL         | AY         | 1819   | ALLC-1924     | ALLBC1819               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021924 | 1            | FINAL         | AY         | 1819   | ALLC-1924     | ALLBC1819               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021924 | 1            | FINAL         | AY         | 1819   | ALLC-1924     | ALLBC1819               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£9901.00     
    | 10021925 | 1            | FINAL         | AY         | 1819   | ALLC-1925     | ALLBC1819               | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021925 | 1            | FINAL         | AY         | 1819   | ALLC-1925     | ALLBC1819               | 2               | 10099.00    | 0.00          | 0.00            | 10099.00          | 0.00         | 10000.00           |
    | 10021925 | 1            | FINAL         | AY         | 1819   | ALLC-1925     | ALLBC1819               | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021925 | 1            | FINAL         | AY         | 1819   | ALLC-1925     | ALLBC1819               | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021925 | 1            | FINAL         | AY         | 1819   | ALLC-1925     | ALLBC1819               | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021925 | 1            | FINAL         | AY         | 1819   | ALLC-1925     | ALLBC1819               | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021925 | 1            | FINAL         | AY         | 1819   | ALLC-1925     | ALLBC1819               | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021925 | 1            | FINAL         | AY         | 1819   | ALLC-1925     | ALLBC1819               | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10099.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10021920 | 1819          | FINAL           | AEB-LS1819          | 10000.00     | 10000        | 10000            | 0                           | 0                   |
    | 10021921 | 1819          | FINAL           | AEB-LS1819          | 10000.00     | 9901         | 9901             | -99                         | -99                 |
    | 10021922 | 1819          | FINAL           | AEB-LS1819          | 10000.00     | 10099        | 10099            | 99                          | 99                  |
	#
    | 10021923 | 1819          | FINAL           | ALLBC1819           | 10000.00     | 10000        | 10000            | 0                           | 0                   |
    | 10021924 | 1819          | FINAL           | ALLBC1819           | 10000.00     | 9901         | 9901             | -99                         | -99                 |
    | 10021925 | 1819          | FINAL           | ALLBC1819           | 10000.00     | 10099        | 10099            | 99                          | 99                  |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10021920 | 1819          | FINAL           | AEBL-1920           | 10000.00     | 10000        | 10000            | 0                           | 0                   |
    | 10021921 | 1819          | FINAL           | AEBL-1921           | 10000.00     | 9901         | 9901             | -99                         | -99                 |
    | 10021922 | 1819          | FINAL           | AEBL-1922           | 10000.00     | 10099        | 10099            | 99                          | 99                  |
	#
    | 10021923 | 1819          | FINAL           | ALLC-1923           | 10000.00     | 10000        | 10000            | 0                           | 0                   |
    | 10021924 | 1819          | FINAL           | ALLC-1924           | 10000.00     | 9901         | 9901             | -99                         | -99                 |
    | 10021925 | 1819          | FINAL           | ALLC-1925           | 10000.00     | 10099        | 10099            | 99                          | 99                  |


@IntegrationTest 
@FundingClaimCalculation @25712 @26008 @26007
Scenario: D549 (I005) Funding Claim Reconciliation Calculations for AEBC1819 with over-delivery
    Given there are no Allocations in PaaS (Performance Management)

    And   the following debatched funding claims are received
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationGroupCode |
    | 10021905 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021906 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021907 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021910 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021911 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021914 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021915 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021918 | 1            | FINAL         | AY         | 1819   | AEBC1819            |
    | 10021919 | 1            | FINAL         | AY         | 1819   | AEBC1819            |

    And   the following funding claim allocations exist
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | AllocationGroupCode | FundingStreamPeriodCode | AllocationValue |
    | 10021905 | 1            | FINAL         | AY         | 1819   | AEC-1905      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021906 | 1            | FINAL         | AY         | 1819   | AEC-1906      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021907 | 1            | FINAL         | AY         | 1819   | AEC-1907      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021910 | 1            | FINAL         | AY         | 1819   | AEC-1910      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021911 | 1            | FINAL         | AY         | 1819   | AEC-1911      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021914 | 1            | FINAL         | AY         | 1819   | AEC-1914      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021915 | 1            | FINAL         | AY         | 1819   | AEC-1915      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021918 | 1            | FINAL         | AY         | 1819   | AEC-1918      | AEBC1819            | AEBC1819                | 10000.00        |
    | 10021919 | 1            | FINAL         | AY         | 1819   | AEC-1919      | AEBC1819            | AEBC1819                | 10000.00        |

    And the following funding claim deliverables exist
    # Have included lines for parent deliverables 
    | UKPRN    | ClaimVersion | ClaimTypeName | PeriodType | Period | AllocationRef | FundingStreamPeriodCode | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalClaimedValue | PlannedValue | ParentPlannedValue |
    | 10021905 | 1            | FINAL         | AY         | 1819   | AEC-1905      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021905 | 1            | FINAL         | AY         | 1819   | AEC-1905      | AEBC1819                | 13              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021905 | 1            | FINAL         | AY         | 1819   | AEC-1905      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10021905 | 1            | FINAL         | AY         | 1819   | AEC-1905      | AEBC1819                | 2               | 10299.00    | 0.00          | 0.00            | 10299.00          | 0.00         | 10000.00           |
    | 10021905 | 1            | FINAL         | AY         | 1819   | AEC-1905      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021905 | 1            | FINAL         | AY         | 1819   | AEC-1905      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021905 | 1            | FINAL         | AY         | 1819   | AEC-1905      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021905 | 1            | FINAL         | AY         | 1819   | AEC-1905      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021905 | 1            | FINAL         | AY         | 1819   | AEC-1905      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021905 | 1            | FINAL         | AY         | 1819   | AEC-1905      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021905 | 1            | FINAL         | AY         | 1819   | AEC-1905      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021905 | 1            | FINAL         | AY         | 1819   | AEC-1905      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10299.00    
    | 10021906 | 1            | FINAL         | AY         | 1819   | AEC-1906      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021906 | 1            | FINAL         | AY         | 1819   | AEC-1906      | AEBC1819                | 13              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021906 | 1            | FINAL         | AY         | 1819   | AEC-1906      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10021906 | 1            | FINAL         | AY         | 1819   | AEC-1906      | AEBC1819                | 2               | 10300.00    | 0.00          | 0.00            | 10300.00          | 0.00         | 10000.00           |
    | 10021906 | 1            | FINAL         | AY         | 1819   | AEC-1906      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021906 | 1            | FINAL         | AY         | 1819   | AEC-1906      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021906 | 1            | FINAL         | AY         | 1819   | AEC-1906      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021906 | 1            | FINAL         | AY         | 1819   | AEC-1906      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021906 | 1            | FINAL         | AY         | 1819   | AEC-1906      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021906 | 1            | FINAL         | AY         | 1819   | AEC-1906      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021906 | 1            | FINAL         | AY         | 1819   | AEC-1906      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021906 | 1            | FINAL         | AY         | 1819   | AEC-1906      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10300.00    
    | 10021907 | 1            | FINAL         | AY         | 1819   | AEC-1907      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021907 | 1            | FINAL         | AY         | 1819   | AEC-1907      | AEBC1819                | 13              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021907 | 1            | FINAL         | AY         | 1819   | AEC-1907      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10021907 | 1            | FINAL         | AY         | 1819   | AEC-1907      | AEBC1819                | 2               | 10301.00    | 0.00          | 0.00            | 10301.00          | 0.00         | 10000.00           |
    | 10021907 | 1            | FINAL         | AY         | 1819   | AEC-1907      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021907 | 1            | FINAL         | AY         | 1819   | AEC-1907      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021907 | 1            | FINAL         | AY         | 1819   | AEC-1907      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021907 | 1            | FINAL         | AY         | 1819   | AEC-1907      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021907 | 1            | FINAL         | AY         | 1819   | AEC-1907      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021907 | 1            | FINAL         | AY         | 1819   | AEC-1907      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021907 | 1            | FINAL         | AY         | 1819   | AEC-1907      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021907 | 1            | FINAL         | AY         | 1819   | AEC-1907      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10301.00    
    | 10021910 | 1            | FINAL         | AY         | 1819   | AEC-1910      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021910 | 1            | FINAL         | AY         | 1819   | AEC-1910      | AEBC1819                | 13              | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 10000.00           |
    | 10021910 | 1            | FINAL         | AY         | 1819   | AEC-1910      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10021910 | 1            | FINAL         | AY         | 1819   | AEC-1910      | AEBC1819                | 2               | 9599.00     | 0.00          | 0.00            | 9599.00           | 0.00         | 9200.00            |
    | 10021910 | 1            | FINAL         | AY         | 1819   | AEC-1910      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021910 | 1            | FINAL         | AY         | 1819   | AEC-1910      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021910 | 1            | FINAL         | AY         | 1819   | AEC-1910      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021910 | 1            | FINAL         | AY         | 1819   | AEC-1910      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021910 | 1            | FINAL         | AY         | 1819   | AEC-1910      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021910 | 1            | FINAL         | AY         | 1819   | AEC-1910      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021910 | 1            | FINAL         | AY         | 1819   | AEC-1910      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021910 | 1            | FINAL         | AY         | 1819   | AEC-1910      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£10299.00    
    | 10021911 | 1            | FINAL         | AY         | 1819   | AEC-1911      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021911 | 1            | FINAL         | AY         | 1819   | AEC-1911      | AEBC1819                | 13              | 700.00      | 0.00          | 0.00            | 700.00            | 800.00       | 10000.00           |
    | 10021911 | 1            | FINAL         | AY         | 1819   | AEC-1911      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10021911 | 1            | FINAL         | AY         | 1819   | AEC-1911      | AEBC1819                | 2               | 9601.00     | 0.00          | 0.00            | 9601.00           | 0.00         | 9200.00            |
    | 10021911 | 1            | FINAL         | AY         | 1819   | AEC-1911      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021911 | 1            | FINAL         | AY         | 1819   | AEC-1911      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021911 | 1            | FINAL         | AY         | 1819   | AEC-1911      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021911 | 1            | FINAL         | AY         | 1819   | AEC-1911      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021911 | 1            | FINAL         | AY         | 1819   | AEC-1911      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021911 | 1            | FINAL         | AY         | 1819   | AEC-1911      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021911 | 1            | FINAL         | AY         | 1819   | AEC-1911      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021911 | 1            | FINAL         | AY         | 1819   | AEC-1911      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£10301.00    
    | 10021914 | 1            | FINAL         | AY         | 1819   | AEC-1914      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021914 | 1            | FINAL         | AY         | 1819   | AEC-1914      | AEBC1819                | 13              | 700.00      | 0.00          | 0.00            | 700.00            | 0.00         | 10000.00           |
    | 10021914 | 1            | FINAL         | AY         | 1819   | AEC-1914      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10021914 | 1            | FINAL         | AY         | 1819   | AEC-1914      | AEBC1819                | 2               | 10299.00    | 0.00          | 0.00            | 10299.00          | 0.00         | 10000.00           |
    | 10021914 | 1            | FINAL         | AY         | 1819   | AEC-1914      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021914 | 1            | FINAL         | AY         | 1819   | AEC-1914      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021914 | 1            | FINAL         | AY         | 1819   | AEC-1914      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021914 | 1            | FINAL         | AY         | 1819   | AEC-1914      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021914 | 1            | FINAL         | AY         | 1819   | AEC-1914      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021914 | 1            | FINAL         | AY         | 1819   | AEC-1914      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021914 | 1            | FINAL         | AY         | 1819   | AEC-1914      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021914 | 1            | FINAL         | AY         | 1819   | AEC-1914      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£10999.00    
    | 10021915 | 1            | FINAL         | AY         | 1819   | AEC-1915      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021915 | 1            | FINAL         | AY         | 1819   | AEC-1915      | AEBC1819                | 13              | 700.00      | 0.00          | 0.00            | 700.00            | 0.00         | 10000.00           |
    | 10021915 | 1            | FINAL         | AY         | 1819   | AEC-1915      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 10000.00           |
    | 10021915 | 1            | FINAL         | AY         | 1819   | AEC-1915      | AEBC1819                | 2               | 10301.00    | 0.00          | 0.00            | 10301.00          | 0.00         | 10000.00           |
    | 10021915 | 1            | FINAL         | AY         | 1819   | AEC-1915      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021915 | 1            | FINAL         | AY         | 1819   | AEC-1915      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021915 | 1            | FINAL         | AY         | 1819   | AEC-1915      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021915 | 1            | FINAL         | AY         | 1819   | AEC-1915      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021915 | 1            | FINAL         | AY         | 1819   | AEC-1915      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021915 | 1            | FINAL         | AY         | 1819   | AEC-1915      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021915 | 1            | FINAL         | AY         | 1819   | AEC-1915      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    | 10021915 | 1            | FINAL         | AY         | 1819   | AEC-1915      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 10000.00           |
    #                                                                                                                                                                      Total=£11001.00    
    | 10021918 | 1            | FINAL         | AY         | 1819   | AEC-1918      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021918 | 1            | FINAL         | AY         | 1819   | AEC-1918      | AEBC1819                | 13              | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 10000.00           |
    | 10021918 | 1            | FINAL         | AY         | 1819   | AEC-1918      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10021918 | 1            | FINAL         | AY         | 1819   | AEC-1918      | AEBC1819                | 2               | 9499.00     | 0.00          | 0.00            | 9499.00           | 0.00         | 9200.00            |
    | 10021918 | 1            | FINAL         | AY         | 1819   | AEC-1918      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021918 | 1            | FINAL         | AY         | 1819   | AEC-1918      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021918 | 1            | FINAL         | AY         | 1819   | AEC-1918      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021918 | 1            | FINAL         | AY         | 1819   | AEC-1918      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021918 | 1            | FINAL         | AY         | 1819   | AEC-1918      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021918 | 1            | FINAL         | AY         | 1819   | AEC-1918      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021918 | 1            | FINAL         | AY         | 1819   | AEC-1918      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021918 | 1            | FINAL         | AY         | 1819   | AEC-1918      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£10399.00    
    | 10021919 | 1            | FINAL         | AY         | 1819   | AEC-1919      | AEBC1819                | 1               | 0.00        | 0.00          | 0.00            | 0.00              | 10000.00     | 0.00               |
    | 10021919 | 1            | FINAL         | AY         | 1819   | AEC-1919      | AEBC1819                | 13              | 900.00      | 0.00          | 0.00            | 900.00            | 800.00       | 10000.00           |
    | 10021919 | 1            | FINAL         | AY         | 1819   | AEC-1919      | AEBC1819                | 14              | 0.00        | 0.00          | 0.00            | 0.00              | 9200.00      | 10000.00           |
    | 10021919 | 1            | FINAL         | AY         | 1819   | AEC-1919      | AEBC1819                | 2               | 9501.00     | 0.00          | 0.00            | 9501.00           | 0.00         | 9200.00            |
    | 10021919 | 1            | FINAL         | AY         | 1819   | AEC-1919      | AEBC1819                | 3               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021919 | 1            | FINAL         | AY         | 1819   | AEC-1919      | AEBC1819                | 4               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021919 | 1            | FINAL         | AY         | 1819   | AEC-1919      | AEBC1819                | 5               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021919 | 1            | FINAL         | AY         | 1819   | AEC-1919      | AEBC1819                | 6               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021919 | 1            | FINAL         | AY         | 1819   | AEC-1919      | AEBC1819                | 7               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021919 | 1            | FINAL         | AY         | 1819   | AEC-1919      | AEBC1819                | 8               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021919 | 1            | FINAL         | AY         | 1819   | AEC-1919      | AEBC1819                | 9               | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    | 10021919 | 1            | FINAL         | AY         | 1819   | AEC-1919      | AEBC1819                | 10              | 0.00        | 0.00          | 0.00            | 0.00              | 0.00         | 9200.00            |
    #                                                                                                                                                                      Total=£10401.00    

    When  the funding claim reconciliation calculation is run

    Then group claim data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationGroupCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10021905 | 1819          | FINAL           | AEBC1819            | 10000.00     | 10299        | 10299            | 299                         | 299                 |
    | 10021906 | 1819          | FINAL           | AEBC1819            | 10000.00     | 10300        | 10300            | 300                         | 300                 |
    | 10021907 | 1819          | FINAL           | AEBC1819            | 10000.00     | 10301        | 10301            | 300                         | 300                 |
    | 10021910 | 1819          | FINAL           | AEBC1819            | 10000.00     | 10299        | 10299            | 299                         | 299                 |
    | 10021911 | 1819          | FINAL           | AEBC1819            | 10000.00     | 10301        | 10301            | 300                         | 300                 |
    | 10021914 | 1819          | FINAL           | AEBC1819            | 10000.00     | 10999        | 10299            | 299                         | 299                 |
    | 10021915 | 1819          | FINAL           | AEBC1819            | 10000.00     | 11001        | 10301            | 300                         | 300                 |
    | 10021918 | 1819          | FINAL           | AEBC1819            | 10000.00     | 10399        | 10299            | 299                         | 299                 |
    | 10021919 | 1819          | FINAL           | AEBC1819            | 10000.00     | 10401        | 10301            | 300                         | 300                 |

    And   allocation data is present in the calculated funding claim reconciliations as follows
    | UKPRN    | FundingPeriod | ClaimTypeName   | AllocationRef       | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
    | 10021905 | 1819          | FINAL           | AEC-1905            | 10000.00     | 10299        | 10299            | 299                         | 299                 |
    | 10021906 | 1819          | FINAL           | AEC-1906            | 10000.00     | 10300        | 10300            | 300                         | 300                 |
    | 10021907 | 1819          | FINAL           | AEC-1907            | 10000.00     | 10301        | 10301            | 300                         | 300                 |
    | 10021910 | 1819          | FINAL           | AEC-1910            | 10000.00     | 10299        | 10299            | 299                         | 299                 |
    | 10021911 | 1819          | FINAL           | AEC-1911            | 10000.00     | 10301        | 10301            | 300                         | 300                 |
    | 10021914 | 1819          | FINAL           | AEC-1914            | 10000.00     | 10999        | 10299            | 299                         | 299                 |
    | 10021915 | 1819          | FINAL           | AEC-1915            | 10000.00     | 11001        | 10301            | 300                         | 300                 |
    | 10021918 | 1819          | FINAL           | AEC-1918            | 10000.00     | 10399        | 10299            | 299                         | 299                 |
    | 10021919 | 1819          | FINAL           | AEC-1919            | 10000.00     | 10401        | 10301            | 300                         | 300                 |

