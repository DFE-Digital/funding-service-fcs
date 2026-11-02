namespace PaymentManagement.Calculation.Behaviours
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using Extensions;

    public static class AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour
    {
        public static IReadOnlyCollection<CalculationResultLine> Calculate(CalculationAllocationInput allocation, CensusPeriodInfo currentPeriod)
        {
            var deliverables = allocation.Deliverables;
            int period = currentPeriod.GetPeriod();

            if (deliverables.IsCurrentPeriodAfterContractEnd(period))
            {
                deliverables.AddCurrentPeriodToEachDeliverable(period);
            }

            var totalCappingPayment = deliverables.GetTotalCappingPayment(period, allocation.GetOverDelivery());
            decimal capApportionedSoFar = 0;
            return deliverables.GroupBy(d => d.CappingApportionmentPriorityOrder.GetValueOrDefault(0)).OrderBy(d => d.Key)
                .SelectMany(apportionmentGroup =>
                {
                    var actualsForApportionmentGroup = apportionmentGroup.GetActualsToDate(currentPeriod: period);
                    var groupCap = GetApportionmentGroupCap(
                                            totalCappingPayment,
                                            actualsForApportionmentGroup,
                                            capApportionedSoFar);

                    return apportionmentGroup.SelectMany(d =>
                    {
                        var netPaymentsBeforeThisMonthForDeliverable = d.GetNetPaymentsBeforeThisMonth(period);
                        return d.DeliverablePeriods.Select(inputPeriod =>
                        {
                            decimal cappedPaymentAmount = inputPeriod.CappedPayment ?? 0;
                            if (inputPeriod.Period == period)
                            {
                                cappedPaymentAmount = GetCappedPayment(
                                    actualsForApportionmentGroupToDate: actualsForApportionmentGroup,
                                    groupCap: groupCap,
                                    actualsForDeliverableToDate: d.GetTotalActualsToDateForDeliverable(period));

                                capApportionedSoFar += cappedPaymentAmount;
                            }

                            var totalActualsToDateForDeliverable = d.GetTotalActualsToDateForDeliverable(period);

                            var reconciliationPaymentAmount = CalculateOrGetExistingReconciliationPaymentAmount(
                                inputPeriod,
                                period,
                                totalActualsToDateForDeliverable,
                                netPaymentsBeforeThisMonthForDeliverable);

                            cappedPaymentAmount = cappedPaymentAmount.RoundPoundsToNearestPenny();
                            return new CalculationResultLine(
                                period: inputPeriod.Period,
                                deliverableCode: d.DeliverableCode,
                                profileValue: 0,
                                cappedPaymentAmount: cappedPaymentAmount,
                                balancingPaymentAmount: 0,
                                reconciliationPaymentAmount: reconciliationPaymentAmount,
                                netPaymentAmount: reconciliationPaymentAmount + cappedPaymentAmount
                            );
                        }).ToList();
                    });
                }).ToList();
        }

        private static decimal GetCappedPayment(decimal actualsForApportionmentGroupToDate, decimal groupCap,  decimal actualsForDeliverableToDate)
        {
            if (actualsForApportionmentGroupToDate != 0)
            {
                return actualsForDeliverableToDate / actualsForApportionmentGroupToDate * groupCap;
            }

            return 0;
        }

        private static decimal GetApportionmentGroupCap(
            decimal totalCappingPayment,
            decimal actualsForApportionmentGroup, 
            decimal capApportionedSoFar)
        {
            decimal unApportionedCap = 0;
            if (actualsForApportionmentGroup > 0)
            {
                unApportionedCap = totalCappingPayment - capApportionedSoFar;
                if (unApportionedCap.ToAbsolute() > actualsForApportionmentGroup.ToAbsolute())
                {
                    unApportionedCap = actualsForApportionmentGroup.ToNegative();
                }
            }

            return unApportionedCap;
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
