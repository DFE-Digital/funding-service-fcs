namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.CrmRepositories
{
    using System;

    public class FundingClaimReconciliationInformation
    {
        public FundingClaimReconciliationInformation(bool isDraft, string organisationIdentifier, string claimTypeName, string period, string periodTypeCode, int version, string allocationGroupCode, Guid fcrCrmId, decimal cappedClaimAdjustment)
        {
            IsDraft = isDraft;
            OrganisationIdentifier = organisationIdentifier;
            ClaimTypeName = claimTypeName;
            Period = period;
            PeriodTypeCode = periodTypeCode;
            Version = version;
            AllocationGroupCode = allocationGroupCode;
            FcrCrmId = fcrCrmId;
            CappedClaimAdjustment = cappedClaimAdjustment;
        }

        public bool IsDraft { get; }

        public string OrganisationIdentifier { get; }

        public string ClaimTypeName { get; }

        public string Period { get; }

        public string PeriodTypeCode { get; }

        public int Version { get; }

        public string AllocationGroupCode { get; }

        public Guid FcrCrmId { get; }

        public decimal CappedClaimAdjustment { get; set; }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((FundingClaimReconciliationInformation)obj);
        }

        public override int GetHashCode()
        {
            return FcrCrmId.GetHashCode();
        }

        protected bool Equals(FundingClaimReconciliationInformation other)
        {
            return FcrCrmId.Equals(other.FcrCrmId);
        }
    }
}