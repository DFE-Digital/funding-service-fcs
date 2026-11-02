namespace SFA.FCT.Contracts.AcceptanceTests.Utilities.DTO
{
    public class AllocationLineConfig
    {
        public string AllocationFundingStreamCode { get; set; }
        public string AllocationPeriodId { get; set; }
        public string AllocationFundingLineCode { get; set; }
        public string ProviderCategory { get; set; }
        public string FspCode { get; set; }
        public int DeliverableCode { get; set; }
        public PolicyStatus PolicyStatus { get; set; }
    }
}