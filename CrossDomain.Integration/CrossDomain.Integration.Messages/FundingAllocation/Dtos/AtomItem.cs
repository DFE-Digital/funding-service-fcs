namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos
{
    public class AtomItem
    {
        public string FundingId { get; set; }

        public string FundingVersion { get; set; }

        public string Period { get; set; }

        public string AllocationFundingStream { get; set; }

        public string Ukprn { get; set; }

        public decimal Value { get; set; }
        
        public string[] ProviderFundingIds { get; set; }
        
        public int PageNumber { get; set; }

        public int PositionInPage { get; set; }
    }
}
