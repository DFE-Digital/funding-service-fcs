namespace Datafix.Tests.Dtos
{
    public class DeliverablePeriodPlannedValue
    {
        public DeliverablePeriodPlannedValue(string period, decimal plannedValue)
        {
            Period = period;
            PlannedValue = plannedValue;
        }

        public string Period { get; }

        public int PeriodMonth => int.Parse(Period.Substring(4, 2));

        public int PeriodYear => int.Parse(Period.Substring(0, 4));

        public decimal PlannedValue { get; }
    }
}
