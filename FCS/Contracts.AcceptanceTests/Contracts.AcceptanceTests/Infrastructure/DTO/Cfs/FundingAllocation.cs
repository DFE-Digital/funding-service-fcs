namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.Cfs
{
    using System.Linq;

    public class FundingAllocation
    {
        public string FundingId { get; set; }

        public string FundingVersion { get; set; }

        public string Period { get; set; }

        public string AllocationFundingStream { get; set; }

        public string Ukprn { get; set; }

        public decimal? Value { get; set; }

        public string[] ProviderFundingIds => ProviderFundingAllocations.Select(pfa => pfa.ProviderFundingId).ToArray();

        public int PageNumber { get; set; }

        /// <remarks>
        /// Used for testing stub storage convenience and not represented in the corresponding production code DTO
        /// </remarks>
        public ProviderFundingAllocation[] ProviderFundingAllocations { get; set; } = Enumerable.Empty<ProviderFundingAllocation>().ToArray();
    }
}
