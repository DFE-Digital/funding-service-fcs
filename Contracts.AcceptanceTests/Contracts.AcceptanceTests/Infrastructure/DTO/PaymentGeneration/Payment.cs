namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.PaymentGeneration
{
    public class Payment
    {
        public string AllocationNumber { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public string Period { get; set; }

        public string SubnominalCode { get; set; }

        public string SubnominalType { get; set; }

        public int VersionNumber { get; set; }

        public string OrganisationId { get; set; }
        
        public string PeriodTypeCode { get; set; }
        
        public bool PostedFlag { get; set; }

        public decimal AggregatedValue { get; set; }

        public int Ukprn { get; set; }

        public override string ToString()
        {
            return $"AllocationNumber: {AllocationNumber}, Period: {Period}, SubnominalCode: {SubnominalCode}, SubnominalType: {SubnominalType}";
        }
    }
}
