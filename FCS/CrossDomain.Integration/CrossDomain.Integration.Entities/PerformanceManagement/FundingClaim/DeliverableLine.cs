namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim
{
    public class DeliverableLine
    {
        public int DeliverableCode { get; set; }

        public decimal? ActualValue { get; set; }

        public decimal? ForecastValue { get; set; }

        public decimal? AdjustmentValue { get; set; }

        public decimal? PlannedValue { get; set; }

        public decimal? ParentPlannedValue { get; set; }

        public decimal? TotalDelivery { get; set; }
    }
}