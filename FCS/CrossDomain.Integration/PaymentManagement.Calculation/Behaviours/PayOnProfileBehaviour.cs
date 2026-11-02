namespace PaymentManagement.Calculation.Behaviours
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using Extensions;

    public static class PayOnProfileBehaviour
    {
        public static IReadOnlyCollection<CalculationResultLine> Calculate(CalculationAllocationInput allocation,
            CensusPeriodInfo currentPeriod)
        {
            int period = currentPeriod.GetPeriod();
            var deliverables = allocation.Deliverables;

            if (deliverables.IsCurrentPeriodAfterContractEnd(currentPeriod: period))
            {
                deliverables.AddCurrentPeriodToEachDeliverable(currentPeriod: period);
            }

            if (deliverables.IsCurrentPeriodBeforeContractStarts(currentPeriod: period))
            {
                deliverables.SetAllProfileValuesToBePlannedValues();
            }

            return deliverables.SelectMany(d =>
            {
                var netPaymentsBeforeThisMonthForDeliverable = d.GetNetPaymentsBeforeThisMonth(period);
                var plannedValueForDeliverable = d.GetPlannedValue();
                return d.DeliverablePeriods.Select(inputPeriod =>
                {
                    decimal? profilePayment = 0;
                    decimal? balancingPayment = 0;
                    decimal netPayment = 0;

                    if (d.AllowPayment)
                    {
                        profilePayment = GetProfilePayment(currentPeriod: period, inputPeriod: inputPeriod);

                        balancingPayment = GetBalancingPayment(
                            currentPeriod: period,
                            inputPeriod: inputPeriod,
                            deliverable: d);

                        netPayment = GetNetPayment(
                            currentPeriod: period,
                            inputPeriod: inputPeriod,
                            profilePayment: profilePayment,
                            balancingPayment: balancingPayment);
                    }
                    
                    return new CalculationResultLine(
                        period: inputPeriod.Period,
                        deliverableCode: d.DeliverableCode,
                        profileValue: profilePayment,
                        cappedPaymentAmount: 0,
                        balancingPaymentAmount: balancingPayment,
                        reconciliationPaymentAmount: 0,
                        netPaymentAmount: netPayment
                    );
                });
            }).ToList();
        }

        private static decimal? GetProfilePayment(int currentPeriod, CalculationDeliverablePeriodInput inputPeriod)
        {
            if (currentPeriod <= inputPeriod.Period)
            {
                return inputPeriod.PlannedValue;
            }

            return inputPeriod.ProfilePayment;
        }

        private static decimal? GetBalancingPayment(int currentPeriod, CalculationDeliverablePeriodInput inputPeriod, CalculationDeliverableInput deliverable)
        {
            if (currentPeriod == inputPeriod.Period)
            {
                decimal previousMonthsNetPayments = deliverable.GetNetPaymentsBeforeThisMonth(currentPeriod);
                decimal? previousMonthsPlannedValues = deliverable.GetPlannedValueBeforeThisMonth(currentPeriod);

                return previousMonthsPlannedValues - previousMonthsNetPayments;
            }

            return inputPeriod.BalancingPayment;
        }

        private static decimal GetNetPayment(int currentPeriod, CalculationDeliverablePeriodInput inputPeriod, decimal? profilePayment, decimal? balancingPayment)
        {
            decimal netPayment = inputPeriod.NetPayment;

            if (currentPeriod == inputPeriod.Period)
            {
                netPayment = profilePayment.GetValueOrDefault() + balancingPayment.GetValueOrDefault();
            }
            else if(inputPeriod.Period > currentPeriod)
            {
                netPayment = profilePayment ?? 0;
            }

            return netPayment;
        }
    }
}
