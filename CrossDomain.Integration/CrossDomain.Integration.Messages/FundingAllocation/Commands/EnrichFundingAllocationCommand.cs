namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    using Dtos;

    public class EnrichFundingAllocationCommand
    {
        public FundingAllocationDto FundingAllocation { get; set; }

        public override string ToString() => FundingAllocation.ToString();
    }
}
