namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation
{
    public class AmountSummary
    {
        public decimal? PlannedValue { get; set; }

        public decimal? ClaimedValue { get; set; }

        /// <summary>
        /// This the value we calculate
        /// </summary>
        public decimal? ProposedReconciliationValue { get; set; }

        /// <summary>
        /// This the overrideable value from CRM
        /// </summary>
        public decimal? ReconciliationValue { get; set; }

        public decimal? CappedClaimedValue { get; set; }

        public decimal? AdjustedCappedClaimValue { get; set; }

        /// <summary>
        /// Property expected to be an array of ClaimAdjustment(s) in the future.
        /// </summary>
        public ClaimAdjustment ClaimAdjustments { get; set; }

        public decimal? EarningsBoostValue { get; set; }

        /// <summary>
        /// Capped value minus Planned value. Used for reconciliation calculation.
        /// </summary>
        public decimal? VarianceValue => CappedClaimedValue.GetValueOrDefault() - PlannedValue.GetValueOrDefault();

        public void SetReconciliationAmounts(decimal reconciliationAmount)
        {
            ProposedReconciliationValue = reconciliationAmount;
            ReconciliationValue = reconciliationAmount;
        }
    }
}