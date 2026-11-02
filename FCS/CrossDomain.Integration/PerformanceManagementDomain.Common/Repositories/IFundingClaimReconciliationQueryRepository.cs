namespace SFA.FCT.PerformanceManagementDomain.Common.Repositories
{
    using System;
    using CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;

    public interface IFundingClaimReconciliationQueryRepository
    {
        FundingClaimReconciliation GetFundingClaimReconciliation(Guid id);

        bool IsFundingClaimReconciliationAtDraftForAllocation(string allocationNumber);

        bool IsPlannedValueDifferentForAllocation(string allocationNumber, decimal newPlannedValue);
    }
}
