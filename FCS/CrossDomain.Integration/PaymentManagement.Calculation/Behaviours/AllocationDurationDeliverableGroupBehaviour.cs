namespace PaymentManagement.Calculation.Behaviours
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using Extensions;
    using Optional.Collections;

    public static class AllocationDurationDeliverableGroupBehaviour
    {
        public static IReadOnlyCollection<CalculationResultLine> Calculate(CalculationAllocationInput allocation,
            CensusPeriodInfo currentPeriod)
        {
            int period = currentPeriod.GetPeriod();
            var deliverables = allocation.Deliverables;

            if (deliverables.IsCurrentPeriodAfterContractEnd(period))
            {
                deliverables.AddCurrentPeriodToEachDeliverable(period);
            }

            var cappingGroupInfos = deliverables.Where(d => d.FundingStreamPeriodCappingGroupId.HasValue)
                .GroupBy(d => d.FundingStreamPeriodCappingGroupId).Select(
                fspCappingGroup =>
                {
                    var cappingGroup = allocation.CappingGroups
                        .Single(cg => cg.FundingStreamPeriodCappingGroupId == fspCappingGroup.Key);

                    return new CappingGroupInfo(
                        fundingStreamPeriodCappingGroupId: fspCappingGroup.Key.Value,
                        plannedValue: fspCappingGroup.GetPlannedValue(),
                        actualValue: fspCappingGroup.GetActualsToDate(period),
                        allowUnderDeliveryToBeUsed: cappingGroup.AllowUnderDeliveryToBeReUsed, 
                        allowOverDeliveryToBeOffset: cappingGroup.AllowOverDeliveryToBeOffset);
                }).ToList();

            return deliverables.GroupBy(d => d.FundingStreamPeriodCappingGroupId.GetValueOrDefault(0))
                .SelectMany(fspCappingGroup =>
                {
                    var currentGroupInfoOptional = cappingGroupInfos.SingleOrNone(cgi =>
                        cgi.FundingStreamPeriodCappingGroupId == fspCappingGroup.Key);

                    return fspCappingGroup.SelectMany(d => d.DeliverablePeriods.Select(inputPeriod =>
                    {
                        var totalActualsToDateForDeliverable = d.GetTotalActualsToDateForDeliverable(period);
                        decimal cappedPaymentAmount = 0;
                        currentGroupInfoOptional.MatchSome(currentGroupInfo =>
                        {
                            cappedPaymentAmount = CalculateOrGetExistingCappedPaymentAmount(
                                inputPeriod:inputPeriod,
                                currentPeriod:period,
                                totalActualsForGroup: currentGroupInfo.ActualValue,
                                getAdjustedCapForGroup: () => CappingGroupInfo.GetAdjustedCapForGroup(cappingGroupInfos, fspCappingGroup.Key),
                                totalActualsToDateForDeliverable:totalActualsToDateForDeliverable);
                        });

                        var netPaymentsBeforeThisMonthForDeliverable = d.GetNetPaymentsBeforeThisMonth(period);

                        var reconciliationPaymentAmount = CalculateOrGetExistingReconciliationPaymentAmount(
                            inputPeriod,
                            period,
                            totalActualsToDateForDeliverable,
                            netPaymentsBeforeThisMonthForDeliverable);

                        return new CalculationResultLine(
                            inputPeriod.Period,
                            d.DeliverableCode,
                            0,
                            cappedPaymentAmount,
                            0,
                            reconciliationPaymentAmount,
                            reconciliationPaymentAmount + cappedPaymentAmount
                        );
                    }));
                }).ToList();
        }

        private static decimal CalculateOrGetExistingCappedPaymentAmount(
            CalculationDeliverablePeriodInput inputPeriod,
            int currentPeriod,
            decimal totalActualsForGroup,
            Func<decimal> getAdjustedCapForGroup,
            decimal totalActualsToDateForDeliverable)
        {
            if (inputPeriod.Period == currentPeriod)
            {
                if (totalActualsForGroup != 0)
                {
                    decimal adjustCapForGroup = getAdjustedCapForGroup();

                    return (totalActualsToDateForDeliverable / totalActualsForGroup * adjustCapForGroup).RoundPoundsToNearestPenny();
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
