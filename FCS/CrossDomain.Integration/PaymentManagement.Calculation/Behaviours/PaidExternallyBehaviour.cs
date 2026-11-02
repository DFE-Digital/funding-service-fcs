namespace PaymentManagement.Calculation.Behaviours
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;

    public static class PaidExternallyBehaviour
    {
        public static IReadOnlyCollection<CalculationResultLine> Calculate(CalculationAllocationInput allocation, CensusPeriodInfo currentPeriod)
        {
            var period = currentPeriod.GetPeriod();

            return allocation.Deliverables.SelectMany(d =>
            {
                return d.DeliverablePeriods.Select(inputPeriod =>
                {
                    decimal netPayment = inputPeriod.NetPayment;
                    decimal? reconciliationPayment = inputPeriod.ReconciliationPayment;

                    if (d.AllowPayment && inputPeriod.Period <= period)
                    {
                        netPayment = inputPeriod.ActualValue ?? 0;
                        reconciliationPayment = inputPeriod.ActualValue;
                    }

                    return new CalculationResultLine(
                        period: inputPeriod.Period,
                        deliverableCode: d.DeliverableCode,
                        profileValue: 0,
                        cappedPaymentAmount: 0,
                        balancingPaymentAmount: 0,
                        reconciliationPaymentAmount: reconciliationPayment,
                        netPaymentAmount: netPayment
                    );
                });
            }).ToList();
        }
    }
}
