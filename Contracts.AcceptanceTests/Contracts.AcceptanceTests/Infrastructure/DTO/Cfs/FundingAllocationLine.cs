namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.Cfs
{
    public class FundingAllocationLine
    {
        public string FundingLineCode { get; set; }

        public string Value { get; set; }

        public string Type { get; set; }

        public FundingAllocationProfilePeriod[] FundingAllocationProfilePeriods { get; set; }
    }
}
