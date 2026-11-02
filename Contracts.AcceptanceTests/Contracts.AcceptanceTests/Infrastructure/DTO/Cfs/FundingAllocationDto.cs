namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.Cfs
{
    public class FundingAllocationDto
    {
        public string FundingId { get; set; }

        public string FundingVersion { get; set; }

        public string Period { get; set; }

        public string AllocationFundingStream { get; set; }

        public string Ukprn { get; set; }

        public decimal? Value { get; set; }

        public string ReleaseGroupName { get; set; }
        public string Status { get; set; }
        public string SubStatus { get; set; }
    }
}
