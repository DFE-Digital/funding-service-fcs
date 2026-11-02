namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    public class EnrichProviderFundingCommand
    {
        public string FundingId { get; set; }

        public string ProviderFundingId { get; set; }

        public override string ToString() => $"FundingId: {FundingId}, ProviderFundingId: {ProviderFundingId}";
    }
}
