namespace PaymentManagement.Calculation.Behaviours
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using Extensions;

    public static class FinancialYearDeliverableGroupBehaviour
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

            var cappingGroupInfos = GetCappingGroupFinancialYearInfos(deliverables);

            return deliverables.SelectMany(d =>
            {
                var totalActualsToDateForDeliverable = d.GetTotalActualsToDateForDeliverable(period);

                var netPaymentsBeforeThisMonthForDeliverable = d.GetNetPaymentsBeforeThisMonth(period);

                return d.DeliverablePeriods.Select(inputPeriod =>
                {
                    decimal cappedPaymentAmount = inputPeriod.CappedPayment ?? 0;
                    if (inputPeriod.Period == period)
                    {
                        if (d.FundingStreamPeriodCappingGroupId.HasValue)
                        {
                            var cappingGroupInfo = cappingGroupInfos[d.FundingStreamPeriodCappingGroupId.Value];

                            cappedPaymentAmount = cappingGroupInfo.Sum(financialYearGroup =>
                            {
                                var totalActualsToDateForDeliverableForFinancialYearInGroup =
                                    d.GetTotalActualsToDateForDeliverableForFinancialYear(period,
                                        financialYearGroup.FinancialYear);

                                var totalCapForGroup = GetTotalCapForGroup(
                                    financialYearGroup.DeliverablePeriodsForFinancialYear,
                                    financialYearGroup.PlannedValueForGroupYear,
                                    period);

                                var totalActualsForGroup = financialYearGroup.DeliverablePeriodsForFinancialYear.Sum(
                                    dp => dp.ActualValue) ?? 0;

                                cappedPaymentAmount = CalculateOrGetExistingCappedPaymentAmount(
                                    inputPeriod: inputPeriod,
                                    currentPeriod: period,
                                    totalActualsToDateForDeliverableForFinancialYearInGroup: totalActualsToDateForDeliverableForFinancialYearInGroup,
                                    totalCapForGroup: totalCapForGroup,
                                    totalActualsForGroup: totalActualsForGroup);

                                return cappedPaymentAmount;
                            });
                        }
                    }

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

        private class CappingGroupFinancialYearInfo
        {
            public int FundingStreamPeriodCappingGroupId { get; }
            public int FinancialYear { get; }
            public IReadOnlyCollection<CalculationDeliverablePeriodInput> DeliverablePeriodsForFinancialYear { get; }

            public decimal PlannedValueForGroupYear { get; }
            public CappingGroupFinancialYearInfo(
                int fundingStreamPeriodCappingGroupId,
                IReadOnlyCollection<CalculationDeliverablePeriodInput> deliverablePeriodsForFinancialYear,
                int financialYear, decimal plannedValueForGroupYear)
            {
                FundingStreamPeriodCappingGroupId = fundingStreamPeriodCappingGroupId;
                DeliverablePeriodsForFinancialYear = deliverablePeriodsForFinancialYear;
                FinancialYear = financialYear;
                PlannedValueForGroupYear = plannedValueForGroupYear;
            }
        }

        private static decimal GetTotalCapForGroup(IReadOnlyCollection<CalculationDeliverablePeriodInput> deliverablePeriods,
            decimal totalPlannedValue,
            int currentPeriod)
        {
            var totalActualsToDate = deliverablePeriods.Where(dp => dp.Period <= currentPeriod)
                .Sum(dp => dp.ActualValue) ?? 0;

            var totalCappingPayment = totalPlannedValue - totalActualsToDate;

            if (totalCappingPayment > 0)
            {
                totalCappingPayment = 0;
            }

            return totalCappingPayment;
        }

        private static decimal CalculateOrGetExistingCappedPaymentAmount(
            CalculationDeliverablePeriodInput inputPeriod,
            int currentPeriod,
            decimal totalActualsToDateForDeliverableForFinancialYearInGroup,
            decimal totalCapForGroup,
            decimal totalActualsForGroup)
        {
            if (inputPeriod.Period == currentPeriod )
            {
                decimal cappedPayment = 0;
                if (totalActualsForGroup != 0)
                {
                    cappedPayment = (totalActualsToDateForDeliverableForFinancialYearInGroup / totalActualsForGroup * totalCapForGroup).RoundPoundsToNearestPenny();
                }

                return cappedPayment;
            }

            return inputPeriod.CappedPayment ?? 0;
        }

        private static ILookup<int, CappingGroupFinancialYearInfo> GetCappingGroupFinancialYearInfos(
            IReadOnlyCollection<CalculationDeliverableInput> deliverables)
        {
            return deliverables.Where(d => d.FundingStreamPeriodCappingGroupId.HasValue)
                .GroupBy(d => d.FundingStreamPeriodCappingGroupId)
                .SelectMany(fspCappingGroup =>
                {
                    var plannedValuesForFinancialYear = fspCappingGroup
                        .Where(d => d.AllowProfile)
                        .SelectMany(d => d.DeliverablePeriods)
                        .GroupBy(dp => new Period(dp.Period).GetTaxYear())
                        .ToDictionary(
                            grp => grp.Key,
                            grp => grp.Sum(dp => dp.PlannedValue));

                    return fspCappingGroup
                        .SelectMany(d => d.DeliverablePeriods)
                        .GroupBy(dp => new Period(dp.Period).GetTaxYear())
                        .Select(grp =>
                        {
                            return new CappingGroupFinancialYearInfo(
                                fundingStreamPeriodCappingGroupId: fspCappingGroup.Key.Value,
                                deliverablePeriodsForFinancialYear: grp.ToList(),
                                financialYear: grp.Key,
                                plannedValueForGroupYear:
                                   DictionaryExtensions
                                        .GetValueOrDefault(plannedValuesForFinancialYear, grp.Key) ?? 0
                            );
                        })
                        .ToList();

                })
                .ToLookup(c => c.FundingStreamPeriodCappingGroupId);
        }

    }
}