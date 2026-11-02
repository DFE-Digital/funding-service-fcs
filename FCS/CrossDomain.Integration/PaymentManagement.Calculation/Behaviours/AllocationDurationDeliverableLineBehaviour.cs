namespace PaymentManagement.Calculation.Behaviours
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using Services;

    public static class AllocationDurationDeliverableLineBehaviour
    {
        public static IReadOnlyCollection<CalculationResultLine> Calculate(CalculationAllocationInput allocation, CensusPeriodInfo currentPeriod)
        {
            var deliverables = allocation.Deliverables;
            IEnumerable<DeliverableLineInfo> deliverableLines = ToDeliverableLines(deliverables);

            int period = currentPeriod.GetPeriod();

            IReadOnlyCollection<CalculationResultLine> resultLines =
                deliverableLines.SelectMany(d => CreateAllocationDeliverable(d, period)).ToList();

            return resultLines;
        }

        private static IEnumerable<DeliverableLineInfo> ToDeliverableLines(IReadOnlyCollection<CalculationDeliverableInput> deliverables)
        {
            return deliverables
                .Select(d => new DeliverableLineInfo
                {
                    DeliverableCode = d.DeliverableCode,
                    Periods = d.DeliverablePeriods
                });
        }

        private static IReadOnlyCollection<CalculationResultLine> CreateAllocationDeliverable(DeliverableLineInfo deliverableLine, int currentPeriod)
        {
            // we need a list of periods including post year end but not periods before the contract
            var periods = deliverableLine.Periods.Select(p => p.Period).ToList();
            if (currentPeriod > periods.DefaultIfEmpty().Max())
            {
                periods.Add(currentPeriod);
            }
            
            return periods.Select(period =>
            {
                var cappedPaymentAmount = GetCappingPayment(deliverableLine, currentPeriod, period);
                var reconciliationAmount = GetReconciliationPayment(deliverableLine, currentPeriod, period);
                    return new CalculationResultLine(
                        period: period,
                        deliverableCode: deliverableLine.DeliverableCode,
                        profileValue: 0,
                        cappedPaymentAmount: cappedPaymentAmount,
                        balancingPaymentAmount: 0,
                        reconciliationPaymentAmount: reconciliationAmount,
                        netPaymentAmount: reconciliationAmount + cappedPaymentAmount ?? 0);
                }).ToList();
        }

        private static decimal? GetReconciliationPayment(DeliverableLineInfo deliverableLine, int currentPeriod, int actualPeriod)
        {
            if (currentPeriod == actualPeriod)
            {
                return ReconciliationCalculator.CalculateReconciliationPayment(deliverableLine.Periods, currentPeriod);
            }

            return deliverableLine.Periods.SingleOrDefault(pp => pp.Period == actualPeriod)?.ReconciliationPayment;
        }

        private static decimal? GetCappingPayment(DeliverableLineInfo deliverableLine, int currentPeriod, int actualPeriod)
        {
            if (currentPeriod == actualPeriod)
            {
                return CalculateCappingPayment(deliverableLine.Periods, currentPeriod);
            }

            return deliverableLine.Periods.SingleOrDefault(pp => pp.Period == actualPeriod)?.CappedPayment;
        }

        /*
        Capping Payment = PV minus AV
             where:
             PV = Sum of (deliverable line's Planned values for the capping period, in this case allocation duration)
             AV = Sum of (deliverable line's Actual values for "past periods" and the "current period")
        */
        private static decimal CalculateCappingPayment(IEnumerable<CalculationDeliverablePeriodInput> periods, int currentPeriod)
        {
            decimal plannedValuesForAllocationDuration = periods.Sum(dp => dp.PlannedValue) ?? 0;

            decimal actualValuesToDate = periods
                .Where(a => a.Period <= currentPeriod)
                .Sum(a => a.ActualValue ?? 0);

            decimal cappingPayment = plannedValuesForAllocationDuration - actualValuesToDate;

            if (cappingPayment > 0)
            {
                cappingPayment = 0;
            }

            return cappingPayment;
        }

        private class DeliverableLineInfo
        {
            public int DeliverableCode { get; set; }

            public IEnumerable<CalculationDeliverablePeriodInput> Periods { get; set; }
        }
    }
}
