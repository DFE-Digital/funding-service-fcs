namespace PerformanceManagementDomain.RecalculationInitiated.Dto
{
    public class FundingClaimReconciliationAllocationInfo
    {
        public FundingClaimReconciliationAllocationInfo(decimal claimAdjustmentValue, decimal earningsBoostValue)
        {
            ClaimAdjustmentValue = claimAdjustmentValue;
            EarningsBoostValue = earningsBoostValue;
        }

        public decimal ClaimAdjustmentValue { get; }
        public decimal EarningsBoostValue { get; }
    }
}
