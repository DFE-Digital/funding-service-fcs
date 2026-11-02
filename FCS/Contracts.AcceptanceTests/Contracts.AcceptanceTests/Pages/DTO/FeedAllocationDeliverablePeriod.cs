namespace SFA.FCT.Contracts.AcceptanceTests.Pages.DTO
{
    public class FeedAllocationDeliverablePeriod
    {
        public FeedAllocationDeliverablePeriod(int deliverableCode, string period, decimal plannedValue, int plannedVolume)
        {
            DeliverableCode = deliverableCode;
            Period = period;
            PlannedValue = plannedValue;
            PlannedVolume = plannedVolume;
        }

        public FeedAllocationDeliverablePeriod(int deliverableCode, string period,  int actualVolume)
        {
            DeliverableCode = deliverableCode;
            Period = period;
            ActualVolume = actualVolume;
        }

        public int DeliverableCode { get; set; }

        public string Period { get; set; }

        public decimal PlannedValue { get; set; }

        public int PlannedVolume { get; set; }

        public int ActualVolume { get; set; }

        public bool IsPlannedVolumeMatches { get; set; }

        public bool IsActualVolumeMatches { get; set; }
    }
}
