namespace PaymentManagement.Calculation.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;

    public static class ContractDeliverableInputsExtensions
    {
        public static decimal GetActualsForGroupToDate(
            this IEnumerable<CalculationDeliverableInput> calculationDeliverableInputs, Period currentPeriod, Period financialPeriod)
        {
            return calculationDeliverableInputs.Sum(d => d.GetPeriodsForFinancialYear(financialPeriod)
                    .Where(dp => dp.Period <= currentPeriod)
                    .Sum(dp => dp.ActualValue)).GetValueOrDefault(0);
        }

        public static decimal GetActualsToDate(
            this IEnumerable<CalculationDeliverableInput> calculationDeliverableInputs, Period currentPeriod)
        {
            return calculationDeliverableInputs.Sum(d => d.DeliverablePeriods
                .Where(dp => dp.Period <= currentPeriod)
                .Sum(dp => dp.ActualValue)).GetValueOrDefault(0);
        }

        public static decimal GetPlannedValue(
            this IEnumerable<CalculationDeliverableInput> calculationDeliverableInputs)
        {
            return calculationDeliverableInputs
                .Where(d => d.AllowProfile)
                .Sum(d => d.DeliverablePeriods
                    .Sum(dp => dp.PlannedValue)).GetValueOrDefault(0);
        }
    }
}
