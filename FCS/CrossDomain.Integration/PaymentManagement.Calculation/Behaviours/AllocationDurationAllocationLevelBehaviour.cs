namespace PaymentManagement.Calculation.Behaviours
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using Extensions;

    public static class AllocationDurationAllocationLevelBehaviour
    {
        public static IReadOnlyCollection<CalculationResultLine> Calculate(CalculationAllocationInput allocation, CensusPeriodInfo currentPeriod)
        {
            int period = currentPeriod.GetPeriod();
            var deliverables = allocation.Deliverables;

            var totalCappingPayment = deliverables.GetTotalCappingPayment(period, allocation.GetOverDelivery());

            var totalActualsToDate = deliverables.GetTotalActualsToDate(period);

            if (deliverables.IsCurrentPeriodAfterContractEnd(period))
            {
                deliverables.AddCurrentPeriodToEachDeliverable(period);
            }

            return deliverables.SelectMany(d =>
            {
                var totalActualsToDateForDeliverable = d.GetTotalActualsToDateForDeliverable(period);

                var netPaymentsBeforeThisMonthForDeliverable = d.GetNetPaymentsBeforeThisMonth(period);

                return d.DeliverablePeriods.Select(inputPeriod =>
                {
                    var cappedPaymentAmount = CalculateOrGetExistingCappedPaymentAmount(
                        inputPeriod,
                        period,
                        totalCappingPayment,
                        totalActualsToDate,
                        totalActualsToDateForDeliverable);

                    var reconciliationPaymentAmount = CalculateOrGetExistingReconciliationPaymentAmount(
                        inputPeriod,
                        period,
                        totalActualsToDateForDeliverable,
                        netPaymentsBeforeThisMonthForDeliverable);

                    return new CalculationResultLine(
                        period: inputPeriod.Period,
                        deliverableCode: d.DeliverableCode,
                        profileValue: 0,
                        cappedPaymentAmount: cappedPaymentAmount,
                        balancingPaymentAmount: 0,
                        reconciliationPaymentAmount: reconciliationPaymentAmount,
                        netPaymentAmount: reconciliationPaymentAmount + cappedPaymentAmount
                    );
                });
            }).ToList();
        }

        private static decimal CalculateOrGetExistingCappedPaymentAmount(
            CalculationDeliverablePeriodInput inputPeriod,
            int currentPeriod,
            decimal totalCappingPayment,
            decimal totalActualsToDate,
            decimal totalActualsToDateForDeliverable)
        {
            if (inputPeriod.Period == currentPeriod)
            {
                if (totalActualsToDate != 0)
                {
                    return (totalActualsToDateForDeliverable / totalActualsToDate * totalCappingPayment).RoundPoundsToNearestPenny();
                }

                return 0;
            }

            return inputPeriod.CappedPayment ?? 0;
        }

        private static decimal CalculateOrGetExistingReconciliationPaymentAmount(
            CalculationDeliverablePeriodInput inputPeriod,
            int currentPeriod,
            decimal totalActualsToDate,
            decimal netPaymentsBeforeThisMonth)
        {
            if (inputPeriod.Period == currentPeriod)
            {
                return totalActualsToDate - netPaymentsBeforeThisMonth;
            }

            return inputPeriod.ReconciliationPayment ?? 0;
        }
    }
}
