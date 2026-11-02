namespace Datafix.Tests.Dtos
{
    public class DeliverablePaymentPlannedValue
    {
        public string Period { get; }
        public int DeliverableCode { get; }
        public decimal PlannedValue { get; }

        public DeliverablePaymentPlannedValue(string period, int deliverableCode, decimal plannedValue)
        {
            Period = period;
            DeliverableCode = deliverableCode;
            PlannedValue = plannedValue;
        }

        public int PeriodMonth => int.Parse(Period.Substring(4, 2));

        public int PeriodYear => int.Parse(Period.Substring(0, 4));
    }
}
