namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class ReinstateFundingAllocationCommand
    {
        public ReinstateFundingAllocationCommand(string fundingId)
        {
            FundingId = fundingId;
        }

        public string FundingId { get; }

        public override string ToString() => $"FundingId: {FundingId}";
    }
}
