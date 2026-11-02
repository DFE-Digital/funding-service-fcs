namespace PaymentManagement.Calculation.Behaviours
{ 
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using Extensions;

    public static class FinancialYearAllocationLevelBehaviour
    {
        public static IReadOnlyCollection<CalculationResultLine> Calculate(CalculationAllocationInput allocation, CensusPeriodInfo currentPeriod)
        {
            var deliverables = allocation.Deliverables;
            int period = currentPeriod.GetPeriod();

            // the code below maybe helpful for debugging
            //var totalActualsToDatePreviousPeriod =
            //    deliverables.Sum(d => d.GetPeriodsForPreviousFinancialYear(period).Sum(dp => dp.ActualValue)) ?? 0;

            //var totalActualsToDateCurrentPeriod =
            //    deliverables.Sum(d => d.GetPeriodsForThisFinancialYear(period).Sum(dp => dp.ActualValue)) ?? 0;

            //var totalPlannedValuePreviousPeriod =
            //    deliverables.Where(d => d.AllowProfile).Sum(d => d.GetPeriodsForPreviousFinancialYear(period).Sum(dp => dp.PlannedValue)) ?? 0;

            //var totalPlannedValueCurrentPeriod =
            //    deliverables.Where(d => d.AllowProfile).Sum(d => d.GetPeriodsForThisFinancialYear(period).Sum(dp => dp.PlannedValue)) ?? 0;

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
                    decimal cappedPaymentAmount = inputPeriod.CappedPayment ?? 0;
                    if (inputPeriod.Period == period)
                    {
                        IReadOnlyCollection<PlannedValueAndActualsForFinancialPeriod> plannedValuesAndActualsTotals = allocation.GetPlannedValueAndActualsTotals();

                        cappedPaymentAmount = plannedValuesAndActualsTotals.Sum(pa =>
                        {
                            var cappingInputParam = GetCappingInputParam(
                                deliverablePeriods:d.GetPeriodsForFinancialYear(pa.FinancialPeriod),
                                totalActualsToDateAcrossAllDeliverablesForPeriod: pa.ActualsValue,
                                totalPlannedValue: pa.PlannedValueIncludingTolerance,
                                currentPeriod: period);

                                cappedPaymentAmount = CalculateOrGetExistingCappedPaymentAmount(
                                inputPeriod:inputPeriod,
                                currentPeriod: period,
                                cappingInputParam:cappingInputParam);

                            return cappedPaymentAmount;
                        });

                        // the code below is left to help debugging, it cab be removed.
                        //var previousFinancialPeriodValue = GetCappingInputParam(d.GetPeriodsForPreviousFinancialYear(period), 
                        //    totalActualsToDatePreviousPeriod,
                        //    totalPlannedValuePreviousPeriod,
                        //    period);

                        //var previousCappedPayment =
                        //    CalculateOrGetExistingCappedPaymentAmount(inputPeriod, period,
                        //        previousFinancialPeriodValue);

                        //var currentFinancialPeriodValue = GetCappingInputParam(d.GetPeriodsForThisFinancialYear(period),
                        //    totalActualsToDateCurrentPeriod,
                        //    totalPlannedValueCurrentPeriod,
                        //    period);

                        //var currentCappedPayment =
                        //    CalculateOrGetExistingCappedPaymentAmount(inputPeriod, period,
                        //        currentFinancialPeriodValue);

                        //cappedPaymentAmount = previousCappedPayment + currentCappedPayment;
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

        private static decimal CalculateOrGetExistingCappedPaymentAmount(
            CalculationDeliverablePeriodInput inputPeriod,
            int currentPeriod,
            CappingInputParam cappingInputParam)
        {
            if (inputPeriod.Period == currentPeriod)
            {
                if (cappingInputParam.TotalActualsToDate != 0)
                {
                    return (cappingInputParam.TotalActualsToDateForDeliverable / cappingInputParam.TotalActualsToDate * cappingInputParam.TotalCappingPayment).RoundPoundsToNearestPenny();
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

        private static CappingInputParam GetCappingInputParam(IReadOnlyCollection<CalculationDeliverablePeriodInput> deliverablePeriods,
            decimal totalActualsToDateAcrossAllDeliverablesForPeriod,
            decimal totalPlannedValue,
            int currentPeriod)
        {
            var totalActualsToDateForDeliverable = deliverablePeriods.Where(dp => dp.Period <= currentPeriod)
                                .Sum(dp => dp.ActualValue) ?? 0;

            var totalCappingPayment = (totalPlannedValue - totalActualsToDateAcrossAllDeliverablesForPeriod);

            if (totalCappingPayment > 0)
            {
                totalCappingPayment = 0;
            }

            return new CappingInputParam(totalActualsToDateForDeliverable, totalCappingPayment, totalActualsToDateAcrossAllDeliverablesForPeriod);
        }

        private class CappingInputParam
        {
            public CappingInputParam(decimal totalActualsToDateForDeliverable, decimal totalCappingPayment, decimal totalActualsToDate)
            {
                TotalActualsToDateForDeliverable = totalActualsToDateForDeliverable;
                TotalCappingPayment = totalCappingPayment;
                this.TotalActualsToDate = totalActualsToDate;
            }

            public decimal TotalActualsToDateForDeliverable { get; }

            public decimal TotalCappingPayment { get; }

            public decimal TotalActualsToDate { get; }
        }
    }
}
