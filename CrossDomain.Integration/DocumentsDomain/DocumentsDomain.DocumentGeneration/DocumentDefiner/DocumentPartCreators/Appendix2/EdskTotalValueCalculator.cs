namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix2
{
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;

    public static class EdskTotalValueCalculator
    {
        public static decimal GetAllocationTotal(contractAllocationsContractAllocation contractAllocation)
        {
            int periodStartYear = GetStartYearFromPeriod(contractAllocation.period);
            int periodEndYear = GetEndYearFromPeriod(contractAllocation.period);

            var allDeliverablePeriods = contractAllocation
                .GetAllDeliverables()
                .SelectMany(d => d.contractDeliverablePeriods)
                .ToList();

            var periodOne = allDeliverablePeriods.Where(dp => IsInFyOne(dp, periodStartYear, periodEndYear))
                .Sum(dp => dp.plannedValue);

            var periodTwo = allDeliverablePeriods.Where(dp => IsInFyTwo(dp, periodStartYear, periodEndYear))
                .Sum(dp => dp.plannedValue);

            var total = allDeliverablePeriods.Sum(dp => dp.plannedValue);

            return EdskSummaryOfFundingRoundingService.GetSummaryRowResult(periodOne, periodTwo, total,
                contractAllocation.fundingStreamPeriodCode).Total;
        }

        private static bool IsInFyOne(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod, int periodStartYear, int periodEndYear)
        {
            return deliverablePeriod.year == periodStartYear || deliverablePeriod.period <= 3;
        }

        private static bool IsInFyTwo(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod, int periodStartYear, int periodEndYear)
        {
            return deliverablePeriod.year == periodEndYear && deliverablePeriod.period >= 4 && deliverablePeriod.period <= 7;
        }

        private static int GetStartYearFromPeriod(Period period)
        {
            string startYearString = period.period1.Substring(0, 2);
            int startYear;
            if (!int.TryParse(startYearString, out startYear))
            {
                throw new ApplicationException("Could not determine the start year from the period given");
            }

            startYear += 2000;
            return startYear;
        }

        private static int GetEndYearFromPeriod(Period period)
        {
            string endYearString = period.period1.Substring(2, 2);
            int endYear;
            if (!int.TryParse(endYearString, out endYear))
            {
                throw new ApplicationException("Could not determine the end year from the period given");
            }

            endYear += 2000;
            return endYear;
        }
    }
}
