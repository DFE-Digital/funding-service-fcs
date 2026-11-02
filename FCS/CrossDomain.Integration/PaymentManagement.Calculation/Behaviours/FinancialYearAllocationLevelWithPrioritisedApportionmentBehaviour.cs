namespace PaymentManagement.Calculation.Behaviours
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using Extensions;

    public static class FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour
    {
        public static IReadOnlyCollection<CalculationResultLine> Calculate(CalculationAllocationInput allocation, CensusPeriodInfo currentPeriod)
        {
            Dictionary<string, decimal> groupFspCaps = new Dictionary<string, decimal>();
            Dictionary<string, decimal> financialYearCapApportioned = new Dictionary<string, decimal>();
            var deliverables = allocation.Deliverables;
            int period = currentPeriod.GetPeriod();

            if (deliverables.IsCurrentPeriodAfterContractEnd(period))
            {
                deliverables.AddCurrentPeriodToEachDeliverable(period);
            }

            var plannedValuesAndActualsTotalsForEachFinancialPeriod = allocation.GetPlannedValueAndActualsTotals();

            return deliverables.GroupBy(d => d.CappingApportionmentPriorityOrder.GetValueOrDefault(0)).OrderBy(d => d.Key)
                .SelectMany(apportionmentGroup =>
                {
                    return apportionmentGroup.SelectMany(d =>
                    {
                        var netPaymentsBeforeThisMonthForDeliverable = d.GetNetPaymentsBeforeThisMonth(period);
                        return d.DeliverablePeriods.Select(inputPeriod =>
                        {
                            decimal cappedPaymentAmountForAllFinancialPeriods = inputPeriod.CappedPayment ?? 0;
                            if (inputPeriod.Period == period)
                            {
                                cappedPaymentAmountForAllFinancialPeriods = plannedValuesAndActualsTotalsForEachFinancialPeriod.Sum(pa =>
                                {
                                    decimal cappedPaymentAmountForFinancialPeriod = 0;
                                    var actualsForGroupToDate = apportionmentGroup.GetActualsForGroupToDate(period, pa.FinancialPeriod);
                                    var financialPeriodGrpCapSoFar = GetFinancialPeriodCapSoFar(financialYearCapApportioned, pa.FinancialPeriod, apportionmentGroup.Key);

                                    var groupCap = GetGroupFspCap(groupFspCaps, pa.FinancialPeriod, apportionmentGroup.Key,
                                        () => GetCappingPaymentForApportionmentGroup(
                                            totalCappingPaymentForFinancialPeriod: pa.GetTotalCappingPayment(),
                                            totalCapApportionedSoFar: pa.CapAppliedSoFarForFinancialPeriod,
                                            actualsForGroupToDate: actualsForGroupToDate));
                                    
                                    var unapportionedCap = GetUnappotionedCap(groupCap, financialPeriodGrpCapSoFar);
                                    
                                    var actualsValueForDeliverableToDate = d.GetPeriodsForFinancialYear(pa.FinancialPeriod).GetActualsValueToDate(period);
                                    if (unapportionedCap != 0 && actualsForGroupToDate > 0)
                                    {
                                        if (unapportionedCap.ToAbsolute() < actualsForGroupToDate)
                                        {
                                            cappedPaymentAmountForFinancialPeriod = groupCap * actualsValueForDeliverableToDate / actualsForGroupToDate;
                                        }
                                        else
                                        {
                                            cappedPaymentAmountForFinancialPeriod = actualsValueForDeliverableToDate.ToNegative();
                                        }

                                        UpdateFnancialPeriodCapSoFar(financialYearCapApportioned, pa.FinancialPeriod,  apportionmentGroup.Key, cappedPaymentAmountForFinancialPeriod);
                                    }

                                    pa.CapAppliedSoFarForFinancialPeriod += cappedPaymentAmountForFinancialPeriod;

                                    return cappedPaymentAmountForFinancialPeriod;
                                });
                            }

                            var totalActualsToDateForDeliverable = d.GetTotalActualsToDateForDeliverable(period);

                            var reconciliationPaymentAmount = CalculateOrGetExistingReconciliationPaymentAmount(
                                inputPeriod,
                                period,
                                totalActualsToDateForDeliverable,
                                netPaymentsBeforeThisMonthForDeliverable);

                            cappedPaymentAmountForAllFinancialPeriods = cappedPaymentAmountForAllFinancialPeriods.RoundPoundsToNearestPenny();
                            return new CalculationResultLine(
                                period: inputPeriod.Period,
                                deliverableCode: d.DeliverableCode,
                                profileValue: 0,
                                cappedPaymentAmount: cappedPaymentAmountForAllFinancialPeriods,
                                balancingPaymentAmount: 0,
                                reconciliationPaymentAmount: reconciliationPaymentAmount,
                                netPaymentAmount: reconciliationPaymentAmount + cappedPaymentAmountForAllFinancialPeriods
                            );
                        }).ToList();

                    });
                }).ToList();
        }

        private static decimal GetGroupFspCap(IDictionary<string, decimal> groupFspCaps, int financialPeriod, int apportionmentKey, Func<decimal> getInitial)
        {
            string key = $"{financialPeriod}_{apportionmentKey}";
            if (!groupFspCaps.ContainsKey(key))
            {
                groupFspCaps.Add(key, getInitial());
            }

            return groupFspCaps[key];
        }

        private static decimal GetUnappotionedCap(decimal groupCap, decimal capSoFar)
        {
            if (groupCap == 0)
            {
                return 0;
            }

            return groupCap - capSoFar;
        }

        private static decimal GetFinancialPeriodCapSoFar(IDictionary<string, decimal> financialYearCapApportioned, int financialPeriod, int apportionmentKey)
        {
            string key = $"{financialPeriod}_{apportionmentKey}";
            return financialYearCapApportioned.GetValueOrDefault(key);
        }

        private static void UpdateFnancialPeriodCapSoFar(IDictionary<string, decimal> financialYearCapApportioned, int financialPeriod, int apportionmentKey, decimal capSoFar)
        {
            string key = $"{financialPeriod}_{apportionmentKey}";

            financialYearCapApportioned.AddValueToExistingValue(key, capSoFar, (decimal existing, decimal update) => existing + update);
        }

        private static decimal GetCappingPaymentForApportionmentGroup(
            decimal totalCappingPaymentForFinancialPeriod,
            decimal totalCapApportionedSoFar,
            decimal actualsForGroupToDate)
        {
            if (totalCappingPaymentForFinancialPeriod != 0)
            {
                var maximumCapForGroup = totalCappingPaymentForFinancialPeriod - totalCapApportionedSoFar;
                if (maximumCapForGroup.ToAbsolute() > actualsForGroupToDate)
                {
                    maximumCapForGroup = actualsForGroupToDate.ToNegative();
                }
                
                return maximumCapForGroup;
            }

            return 0;
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
