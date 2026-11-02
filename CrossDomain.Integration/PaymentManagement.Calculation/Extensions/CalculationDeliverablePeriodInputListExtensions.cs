namespace PaymentManagement.Calculation.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;

    public static class CalculationDeliverablePeriodInputListExtensions
    {
        public static decimal GetActualsValueToDate(this IReadOnlyCollection<CalculationDeliverablePeriodInput> periods,
            Period currentPeriod)
        {
            return periods.Where(p => p.Period <= currentPeriod).Sum(p => p.ActualValue) ?? 0;
        }
    }
}
