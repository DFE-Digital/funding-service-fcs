namespace FundingAllocation.Dto
{
    public class ProviderFundingAllocationApiDto
    {
        public string ProviderFundingId { get; set; }

        public string ProviderType { get; set; }

        public string ProviderSubType { get; set; }

        public int DeliveryUkprn { get; set; }

        public FundingAllocationLineApiDto[] FundingAllocationLines { get; set; }
    }
}
