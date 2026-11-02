namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    using CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class ReleaseGroupInfo
    {
        public string Name { get; set; }

        public sfa_ReleaseGroupStatus Status { get; set; }

        public int FundingAllocationCount { get; set; }

        public decimal FundingAllocationValue { get; set; }
    }
}