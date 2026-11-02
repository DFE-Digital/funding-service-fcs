namespace SFA.FCT.PerformanceManagementDomain.Common.Commands
{
    public class BeginPullOfFundingClaimsForClosedCollectionCommand
    {
        public static BeginPullOfFundingClaimsForClosedCollectionCommand Create(string periodClaimType)
        {
            return new BeginPullOfFundingClaimsForClosedCollectionCommand
            {
                PeriodClaimType = periodClaimType
            };
        }

        public string PeriodClaimType { get; set; }

        public override string ToString()
        {
            return $"PeriodClaimType: {PeriodClaimType}";
        }
    }
}
