namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services
{
    using System;
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;

    public interface IFcrUpdateService
    {
        void UpdateFundingClaimReconciliationInCrm(AmountSummary amounts, IEnumerable<ContractAllocation> contractAllocations, Guid fcrCrmId);

        void UpdateFcrAdjustedCappedClaimValueInCrm(
            decimal? adjustedCappedClaimValue,
            decimal? claimAdjustmentValue,
            decimal? proposedReconciliationValue,
            decimal? earningsBoostValue,
            Guid fcrCrmId);

        void UpdateFundingClaimReconciliationInCrm(
            decimal? adjustedCappedClaimValue,
            decimal? claimAdjustmentValue,
            decimal? proposedReconciliationValue,
            decimal? reconciliationValue,
            decimal? earningsBoostValue,
            Guid fcrCrmId);
    }
}