namespace PerformanceManagementDomain.RecalculationInitiated.Dto
{
    using System;
    using System.Collections.Generic;

    public class FundingClaimReconciliationInfo
    {
        public FundingClaimReconciliationInfo(
            Guid fcrId,
            string organisationIdentifier,
            int claimVersionNumber,
            string claimTypeName,
            string periodTypeCode,
            string period,
            string allocationGroupCode,
            IReadOnlyCollection<FundingClaimReconciliationAllocationInfo> allocations)
        {
            OrganisationIdentifier = organisationIdentifier;
            FcrId = fcrId;
            ClaimVersionNumber = claimVersionNumber;
            ClaimTypeName = claimTypeName;
            PeriodTypeCode = periodTypeCode;
            Period = period;
            AllocationGroupCode = allocationGroupCode;
            Allocations = allocations;
        }

        public Guid FcrId { get; }

        public string OrganisationIdentifier { get; }

        public int ClaimVersionNumber { get; }

        public string ClaimTypeName { get; }

        public string PeriodTypeCode { get; }

        public string Period { get; }

        public string AllocationGroupCode { get; }

        public IReadOnlyCollection<FundingClaimReconciliationAllocationInfo> Allocations { get; }
    }
}
