namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation
{
    public class ClaimAdjustment
    {
        public ClaimAdjustment(decimal claimAdjustmentValue, string claimAdjustmentReason)
        {
            ClaimAdjustmentValue = claimAdjustmentValue;
            ClaimAdjustmentReason = claimAdjustmentReason;
        }

        public decimal ClaimAdjustmentValue { get; }

        public string ClaimAdjustmentReason { get; }
    }
}