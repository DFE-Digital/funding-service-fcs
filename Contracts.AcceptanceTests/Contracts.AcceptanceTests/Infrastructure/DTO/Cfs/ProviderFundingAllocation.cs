namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.Cfs
{
    public class ProviderFundingAllocation
    {
        public string ProviderFundingId { get; set; }

        public string ProviderType { get; set; }

        public string ProviderSubType { get; set; }

        public int DeliveryUkprn { get; set; }
        
        public FundingAllocationLine[] FundingAllocationLines { get; set; }
    }
}