namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.PerformanceManagement.FundingClaim;

    public class FundingClaimDebatchedEvent
    {
        public DebatchedFundingClaim DebatchedFundingClaim { get; set; }
    }
}