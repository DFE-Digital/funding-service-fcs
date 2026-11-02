namespace SFA.FCT.PerformanceManagementDomain.Common.Commands
{
    using System;

    public class RecalculateFundingClaimReconciliationCommand
    {
        public RecalculateFundingClaimReconciliationCommand()
        {
        }

        public RecalculateFundingClaimReconciliationCommand(string organisationIdentifier, int versionNumber, string claimTypeName, string periodTypeCode, string period, string allocationGroupCode, Guid fcrCrmId, decimal cappedClaimAdjustment)
        {
            OrganisationIdentifier = organisationIdentifier;
            VersionNumber = versionNumber;
            ClaimTypeName = claimTypeName;
            PeriodTypeCode = periodTypeCode;
            Period = period;
            AllocationGroupCode = allocationGroupCode;
            FcrCrmId = fcrCrmId;
            CappedClaimAdjustment = cappedClaimAdjustment;
        }

        public string OrganisationIdentifier { get; set; }

        public int VersionNumber { get; set; }

        public string ClaimTypeName { get; set; }

        public string PeriodTypeCode { get; set; }

        public string Period { get; set; }

        public string AllocationGroupCode { get; set; }

        public Guid FcrCrmId { get; set; }

        public decimal CappedClaimAdjustment { get; set; }

        public override string ToString()
        {
            return $"OrganisationIdentifier: {OrganisationIdentifier}, VersionNumber: {VersionNumber}, ClaimTypeName: {ClaimTypeName}, PeriodTypeCode: {PeriodTypeCode}, Period {Period}";
        }


    }
}
