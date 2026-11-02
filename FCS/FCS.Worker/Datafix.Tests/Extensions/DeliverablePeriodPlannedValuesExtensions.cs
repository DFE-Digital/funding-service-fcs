namespace Datafix.Tests.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;

    public static class DeliverablePeriodPlannedValuesExtensions
    {
        public static decimal GetFirstEnvelope(this IEnumerable<DeliverablePeriodPlannedValue> plannedValues, int periodStartYear)
        {
            Func<DeliverablePeriodPlannedValue, bool> filterForRegularContract = p => p.PeriodYear == periodStartYear || p.PeriodMonth <= 3;
            var filter = filterForRegularContract;

            // check if this is a short contract
            if (plannedValues.All(p => p.PeriodYear == periodStartYear))
            {
                
                filter = p => p.PeriodMonth <= 3;
            }

            return plannedValues
                .Where(filter)
                .Sum(p => p.PlannedValue);
        }

        public static decimal GetSecondEnvelope(this IEnumerable<DeliverablePeriodPlannedValue> plannedValues, int periodEndYear)
        {
            //   return deliverablePeriod.year == periodEndYear && deliverablePeriod.period >= 4 && deliverablePeriod.period <= 7;
            return plannedValues
                .Where(p => p.PeriodYear == periodEndYear && p.PeriodMonth >= 4 && p.PeriodMonth <= 7)
                .Sum(p => p.PlannedValue);
        }

        public static int GetStartYear(this IEnumerable<DeliverablePeriodPlannedValue> plannedValues)
        {
            var earliestPeriod = plannedValues.Select(p => int.Parse(p.Period)).OrderBy(p => p).First();
            return earliestPeriod / 100;
        }

        public static int GetEndYear(this IEnumerable<DeliverablePeriodPlannedValue> plannedValues)
        {
            var latestPeriod = plannedValues.Select(p => int.Parse(p.Period)).OrderBy(p => p).Last();
            return latestPeriod / 100;
        }
    }
}
