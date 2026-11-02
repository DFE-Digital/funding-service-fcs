namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.CrmRepositories
{
    using System;
    using System.Collections.Generic;

    public interface ICrmFundingClaimReconciliationRepository
    {
        IReadOnlyCollection<FundingClaimReconciliationInformation> GetFundingClaimReconciliationInfos(string allocationNumber);

        void UpdateValues(
            Guid fcrId,
            decimal newProposedReconciliationValue,
            decimal newPlannedValue,
            decimal adjustedCappedClaimValue,
            decimal cappedClaimValue);

        void UpdateFcrAndAllocationValues(
            Guid fcrId,
            decimal? adjustedCappedClaimValue,
            decimal? claimAdjustmentValue,
            decimal? proposedReconciliationValue,
            decimal? earningsBoostValue,
            IReadOnlyCollection<Guid> fcrAllocationIds);
        
        void UpdateFcrAndAllocationValues(
            Guid fcrId,
            decimal? adjustedCappedClaimValue,
            decimal? claimAdjustmentValue,
            decimal? proposedReconciliationValue,
            decimal? reconciliationValue,
            decimal? earningsBoostValue,
            IReadOnlyCollection<Guid> fcrAllocationIds);

        void AssociateAllocationToFcrAndUpdateValues(
            Guid fcrId,
            Guid fcrAllocId,
            string allocationNumber,
            int versionNumber, int subVersionNumber,
            decimal plannedValue,
            decimal proposedReconciliationValue,
            decimal adjustedCappedClaimValue,
            decimal cappedClaimValue);

        IReadOnlyCollection<AllocationPlannedValue> GetFcrAllocationInfos(Guid fcrId);

        void IssueCrmNotificationForAllocation(string contractAllocationNumber, int contractVersionNumber);

        IReadOnlyCollection<Guid> GetFcrAllocationIdsForFcrId(Guid fcrId);
    }
}