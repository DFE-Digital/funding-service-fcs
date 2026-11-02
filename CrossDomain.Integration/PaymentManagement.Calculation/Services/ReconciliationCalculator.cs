namespace PaymentManagement.Calculation.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;

    public static class ReconciliationCalculator
    {
        /*
        Reconciliation Payment = AV minus NP
             where:
             AV = Sum of (deliverable line's Actual values for "past periods" and the "current period")
             NP = Sum of (deliverable line's Net Payment values for "past periods")
        */
        public static decimal? CalculateReconciliationPayment(
            IEnumerable<CalculationDeliverablePeriodInput> periods,
            int currentPeriod)
        {
            decimal actualValuesToCurrentPeriod = periods
                .Where(a => a.Period <= currentPeriod)
                .Sum(a => a.ActualValue ?? 0);
            
            decimal netPayments = periods
                .Where(pp => pp.Period < currentPeriod)
                .Sum(dp => dp.NetPayment);

            return actualValuesToCurrentPeriod - netPayments;
        }
    }
}
