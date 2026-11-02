namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class HoldFundingAllocationCommand
    {
        public string FundingId { get; set; }

        public override string ToString() => $"FundingId: {FundingId}";
    }
}
