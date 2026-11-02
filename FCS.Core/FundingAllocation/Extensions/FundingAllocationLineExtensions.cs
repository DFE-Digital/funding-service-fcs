namespace FundingAllocation.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;

    public static class FundingAllocationLineExtensions
    {
        private static readonly Dictionary<int, int> MonthsToFinancialPeriods = new Dictionary<int, int>
        {
            {8, 1},
            {9, 1},
            {10, 1},
            {11, 1},
            {12, 1},
            {1, 1},
            {2, 1},
            {3, 1},
            {4, 2},
            {5, 2},
            {6, 2},
            {7, 2}
        };

        public static bool IsMateriallyEquivalentTo(this FundingAllocationLine currentFundingAllocationLine,
            FundingAllocationLine otherFundingAllocationLine)
        {
            return currentFundingAllocationLine.NonZeroFundingAllocationProfilePeriods
                .SequenceEqual(otherFundingAllocationLine.NonZeroFundingAllocationProfilePeriods);
        }

        public static decimal GetFirstEnvelope(this FundingAllocationLine fundingAllocationLine)
        {
            var periodsWithFinancialPeriod = fundingAllocationLine.FundingAllocationProfilePeriods.WithFinancialPeriod();

            return periodsWithFinancialPeriod.Where(p => p.financialPeriod == 1)
                .Sum(p => p.plannedValue);
        }

        public static bool IsFirstEnvelopeGreaterThan(this FundingAllocationLine fundingAllocationLine,
            FundingAllocationLine otherFundingAllocationLine)
        {
            return otherFundingAllocationLine == null || fundingAllocationLine.GetFirstEnvelope() >
                otherFundingAllocationLine.GetFirstEnvelope();
        }

        public static bool IsSecondEnvelopeGreaterThan(this FundingAllocationLine fundingAllocationLine,
            FundingAllocationLine otherFundingAllocationLine)
        {
            return otherFundingAllocationLine == null || fundingAllocationLine.GetSecondEnvelope() >
                otherFundingAllocationLine.GetSecondEnvelope();
        }

        public static decimal GetSecondEnvelope(this FundingAllocationLine fundingAllocationLine)
        {
            var periodsWithFinancialPeriod = fundingAllocationLine.FundingAllocationProfilePeriods.WithFinancialPeriod();

            return periodsWithFinancialPeriod.Where(p => p.financialPeriod == 2)
                .Sum(p => p.plannedValue);
        }

        public static bool HasNonZeroPlannedValue(this FundingAllocationLine fundingAllocationLine)
        {
            return fundingAllocationLine.FundingAllocationProfilePeriods.Sum(p => p.PlannedValue) != 0;
        }

        private static IReadOnlyCollection<(int periodMonth, int financialPeriod, decimal plannedValue)>
            WithFinancialPeriod(
                this IReadOnlyCollection<FundingAllocationProfilePeriod> periods)
        {
            return periods.Select(pv => (
                pv.PeriodMonth,
                MonthsToFinancialPeriods[pv.PeriodMonth],
                pv.PlannedValue)).ToList();
        }
    }
}