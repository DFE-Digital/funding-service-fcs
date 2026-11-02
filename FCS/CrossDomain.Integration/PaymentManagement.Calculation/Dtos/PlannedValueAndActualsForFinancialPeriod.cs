namespace PaymentManagement.Calculation.Dtos
{
    using System.Linq;

    public class PlannedValueAndActualsForFinancialPeriod
    {
        public PlannedValueAndActualsForFinancialPeriod(
            decimal plannedValue,
            decimal overrideLimitPercentage,
            Period financialPeriod,
            decimal actualsValue)
        {
            PlannedValue = plannedValue;
            OverrideLimitPercentage = overrideLimitPercentage;
            FinancialPeriod = financialPeriod;
            ActualsValue = actualsValue;
        }

        public decimal PlannedValue { get; }

        public decimal OverrideLimitPercentage { get; }

        public Period FinancialPeriod { get; }

        public decimal ActualsValue { get; }

        public decimal PlannedValueIncludingTolerance => PlannedValue * (1 + OverrideLimitPercentage/100);

        public decimal GetTotalCappingPayment()
        {
            var totalCapping = PlannedValueIncludingTolerance - ActualsValue;

            if (totalCapping > 0)
            {
                return 0;
            }

            return totalCapping;
        }

        public decimal CapAppliedSoFarForFinancialPeriod { get; set; }
    }
}
