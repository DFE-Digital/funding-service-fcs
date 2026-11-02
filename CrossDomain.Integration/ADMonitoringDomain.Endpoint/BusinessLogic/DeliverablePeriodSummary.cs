namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    public class DeliverablePeriodSummary
    {
        public FundingStreamPeriodDeliverable FundingStreamPeriodDeliverable { get; set; }
        public string FundingStreamPeriodCode { get; set; }
        public string ContractNumber { get; set; }
        public int ContractVersionNumber { get; set; }
        public int DeliverableCode { get; set; }
        public string Period { get; set; }
        public decimal? PlannedValue { get; set; }
        public int? PlannedVolumne { get; set; }
    }
}
