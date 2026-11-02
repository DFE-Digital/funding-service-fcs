namespace SFA.FCT.PerformanceManagementDomain.Common.Commands
{
    using System;
    public class RecalculateFcrOnCappedClaimAdjustmentCommand
    {
        public RecalculateFcrOnCappedClaimAdjustmentCommand()
        {       
        }

        public RecalculateFcrOnCappedClaimAdjustmentCommand(
            string organisationIdentifier,
            int versionNumber,
            string claimTypeName,
            string periodTypeCode,
            string period,
            string allocationGroupCode,
            Guid fcrCrmId,
            decimal cappedClaimAdjustment,
            decimal earningBoostValue,
            bool shouldUpdateFinalReconciliation)
        {
            OrganisationIdentifier = organisationIdentifier;
            VersionNumber = versionNumber;
            ClaimTypeName = claimTypeName;
            PeriodTypeCode = periodTypeCode;
            Period = period;
            AllocationGroupCode = allocationGroupCode;
            FcrCrmId = fcrCrmId;
            CappedClaimAdjustment = cappedClaimAdjustment;
            ShouldUpdateFinalReconciliation = shouldUpdateFinalReconciliation;
            EarningsBoostValue = earningBoostValue;
        }

        public string OrganisationIdentifier { get; set; }

        public int VersionNumber { get; set; }

        public string ClaimTypeName { get; set; }

        public string PeriodTypeCode { get; set; }

        public string Period { get; set; }

        public string AllocationGroupCode { get; set; }

        public Guid FcrCrmId { get; set; }

        public decimal CappedClaimAdjustment { get; set; }

        public decimal? EarningsBoostValue { get; set; }

        public bool ShouldUpdateFinalReconciliation { get; set; }

        public override string ToString()
        {
            return $"OrganisationIdentifier: {OrganisationIdentifier}, VersionNumber: {VersionNumber}, ClaimTypeName: {ClaimTypeName}, PeriodTypeCode: {PeriodTypeCode}," +
                   $" Period: {Period}, CappedClaimAdjustment: {CappedClaimAdjustment}, ShouldUpdateFinalReconciliation: {ShouldUpdateFinalReconciliation}";
        }
    }
}