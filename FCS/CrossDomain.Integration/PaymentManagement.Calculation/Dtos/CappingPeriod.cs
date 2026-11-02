namespace PaymentManagement.Calculation.Dtos
{
    public class CappingPeriod
    {
        public CappingPeriod(int cappingPeriodNumber, decimal overDeliveryLimit)
        {
            CappingPeriodNumber = cappingPeriodNumber;
            OverDeliveryLimit = overDeliveryLimit;
        }

        public int CappingPeriodNumber { get; }

        public decimal OverDeliveryLimit { get; }
    }
}
