namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    using Dtos;

    public class CreateFundingAllocationInCrmCommand
    {
        public FundingAllocationDto FundingAllocation { get; set; }

        public int ReadId { get; set; }

        public override string ToString() => $"FundingId: {FundingAllocation?.FundingId}, FundingVersion: {FundingAllocation?.FundingVersion}";
    }
}
