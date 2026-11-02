namespace PaymentManagement.Calculation.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;

    public static class CalculationDeliverableInputListExtensions
    {
        public static decimal GetTotalCappingPayment(this IReadOnlyCollection<CalculationDeliverableInput> deliverableinputLines,
            int currentPeriod, decimal overDeliveryPercentage)
        {
            // Total Capping Payment (TCP) = Total Planned Value - Total Actuals up to and including current period)
            var totalPlannedValue = deliverableinputLines.Where(d => d.AllowProfile)
                .Sum(l => l.DeliverablePeriods.Sum(dp => dp.PlannedValue));

            var plannedValueIncludingTolerance = totalPlannedValue * (1 + overDeliveryPercentage / 100);

            var totalActuals = deliverableinputLines.GetTotalActualsToDate(currentPeriod);

            decimal cappingPayment = (plannedValueIncludingTolerance - totalActuals) ?? 0;

            if (cappingPayment > 0)
            {
                cappingPayment = 0;
            }

            return cappingPayment;
        }

        public static decimal GetTotalActualsToDate(this IReadOnlyCollection<CalculationDeliverableInput> inputLines,
            int currentPeriod)
        {
            return inputLines.Sum(l => l.DeliverablePeriods
                .Where(dp => dp.Period <= currentPeriod)
                .Sum(dp => dp.ActualValue)) ?? 0;
        }

        public static bool IsCurrentPeriodAfterContractEnd(this IReadOnlyCollection<CalculationDeliverableInput> inputLines, int currentPeriod)
        {
            int greatestPeriod = inputLines.SelectMany(l => l.DeliverablePeriods.Select(dp => dp.Period)).Max();

            return currentPeriod > greatestPeriod;
        }

        public static bool IsCurrentPeriodBeforeContractStarts(this IReadOnlyCollection<CalculationDeliverableInput> inputLines, int currentPeriod)
        {
            int earliestPeriod = inputLines.SelectMany(l => l.DeliverablePeriods.Select(dp => dp.Period)).Min();

            return currentPeriod < earliestPeriod;
        }

        public static void AddCurrentPeriodToEachDeliverable(this IReadOnlyCollection<CalculationDeliverableInput> deliverables,
            int currentPeriod)
        {
            deliverables.ToList().ForEach(d => d.DeliverablePeriods.Add(CreateCalculationDeliverablePeriodInput(currentPeriod)));
        }

        public static void SetAllProfileValuesToBePlannedValues(this IReadOnlyCollection<CalculationDeliverableInput> deliverables)
        {
            deliverables.ToList().ForEach(d => d.DeliverablePeriods.ToList().ForEach(dp => dp.ProfilePayment = dp.PlannedValue));
        }

        private static CalculationDeliverablePeriodInput CreateCalculationDeliverablePeriodInput(int period)
        {
            return new CalculationDeliverablePeriodInput(period: period, plannedValue: 0, plannedVolume: 0);
        }
    }
}
