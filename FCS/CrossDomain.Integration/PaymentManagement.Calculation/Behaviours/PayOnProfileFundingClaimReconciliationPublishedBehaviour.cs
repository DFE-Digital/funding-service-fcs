namespace PaymentManagement.Calculation.Behaviours
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using Extensions;

    public static class PayOnProfileFundingClaimReconciliationPublishedBehaviour
    {
        public static IReadOnlyCollection<CalculationResultLine> Calculate(
            CalculationAllocationInput allocation, 
            CensusPeriodInfo currentPeriod,
            decimal fcrReconciliationValue)
        {
            int period = currentPeriod.GetPeriod();
            var deliverables = allocation.Deliverables;

            if (deliverables.IsCurrentPeriodAfterContractEnd(currentPeriod: period))
            {
                deliverables.AddCurrentPeriodToEachDeliverable(currentPeriod: period);
            }

            var totalPlannedValue = allocation.Deliverables.GetPlannedValue();

            return deliverables.SelectMany(d =>
            {
                decimal plannedValueForDeliverable = d.GetPlannedValue() ?? 0;
                return d.DeliverablePeriods.Select(inputPeriod =>
                {
                    decimal? profilePayment = 0;
                    decimal? balancingPayment = 0;
                    decimal? reconciliationPayment = 0;
                    decimal netPayment = 0;

                    if (d.AllowPayment)
                    {
                        profilePayment = GetProfilePayment(inputPeriod);

                        balancingPayment = GetBalancingPayment(inputPeriod);

                        reconciliationPayment = GetReconciliationPayment(period, inputPeriod, plannedValueForDeliverable, totalPlannedValue, fcrReconciliationValue);

                        netPayment = GetNetPayment(
                            currentPeriod: period,
                            inputPeriod: inputPeriod,
                            profilePayment: profilePayment,
                            balancingPayment: balancingPayment,
                            reconciliationPayment: reconciliationPayment);
                    }

                    return new CalculationResultLine(
                        period: inputPeriod.Period,
                        deliverableCode: d.DeliverableCode,
                        profileValue: profilePayment,
                        cappedPaymentAmount: 0,
                        balancingPaymentAmount: balancingPayment,
                        reconciliationPaymentAmount: reconciliationPayment?.RoundPoundsToNearestPenny(),
                        netPaymentAmount: netPayment.RoundPoundsToNearestPenny()
                    );
                });
            }).ToList();
        }

        private static decimal? GetProfilePayment(CalculationDeliverablePeriodInput inputPeriod)
        {
            return inputPeriod.ProfilePayment ?? 0;
        }

        private static decimal? GetBalancingPayment(CalculationDeliverablePeriodInput inputPeriod)
        {
            return inputPeriod.BalancingPayment ?? 0;
        }

        private static decimal? GetReconciliationPayment(
            int currentPeriod,
            CalculationDeliverablePeriodInput inputPeriod,
            decimal plannedValueForDeliverable,
            decimal totalPlannedValue,
            decimal fcrReconciliationValue)
        {
            if (currentPeriod == inputPeriod.Period && totalPlannedValue != 0)
            {
                return fcrReconciliationValue * plannedValueForDeliverable / totalPlannedValue;
            }

            return inputPeriod.ReconciliationPayment;
        }

        private static decimal GetNetPayment(int currentPeriod, CalculationDeliverablePeriodInput inputPeriod, decimal? profilePayment, decimal? balancingPayment, decimal? reconciliationPayment)
        {
            if (currentPeriod == inputPeriod.Period)
            {
                return profilePayment.GetValueOrDefault() + balancingPayment.GetValueOrDefault() + reconciliationPayment.GetValueOrDefault();
            }

            return inputPeriod.NetPayment;
        }
    }
}
