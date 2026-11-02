namespace ContractManagementDomain.Endpoint.ContractApproved.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public static class PlannedValueFinancialEnvelopeCalculationExtensions
    {
        public static decimal GetFirstEnvelope(this IEnumerable<contractDeliverablePeriodsTypeContractDeliverablePeriod> deliverablePeriods, int allocationStartYear)
        {
            Func<contractDeliverablePeriodsTypeContractDeliverablePeriod, bool> filterForRegularContract = p => p.year == allocationStartYear || p.period <= 3;
            var filter = filterForRegularContract;

            
            // if all the periods are on the same year
            if (deliverablePeriods.Select(dp => dp.year).Distinct().Count() == 1)
            {
                deliverablePeriods = deliverablePeriods.OrderBy(dp => dp.period);
                if (deliverablePeriods.First().period >= 8)
                {
                    filter = p => p.period >= 8;
                }
                else
                {
                    filter = p => p.period <= 3;
                }
            }

            return deliverablePeriods
                .Where(filter)
                .Sum(p => p.plannedValue);
        }

        public static decimal GetSecondEnvelope(this IEnumerable<contractDeliverablePeriodsTypeContractDeliverablePeriod> deliverablePeriods, int allocationEndYear)
        {
            return deliverablePeriods
                .Where(dp => dp.year == allocationEndYear && dp.period >= 4 && dp.period <= 7)
                .Sum(dp => dp.plannedValue);
        }

        public static int GetStartYear(this IEnumerable<contractDeliverablePeriodsTypeContractDeliverablePeriod> deliverablePeriods)
        {
            if (!deliverablePeriods.Any()) return 0;

            return deliverablePeriods
                .OrderBy(dp => dp.year)
                .Select(dp => dp.year)
                .First();
        }

        public static int GetEndYear(this IEnumerable<contractDeliverablePeriodsTypeContractDeliverablePeriod> deliverablePeriods)
        {
            if (!deliverablePeriods.Any()) return 0;

            return deliverablePeriods
                .OrderByDescending(dp => dp.year)
                .Select(dp => dp.year)
                .First();
        }
    }
}
