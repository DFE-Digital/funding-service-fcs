namespace SFA.FCT.PerformanceManagementDomain.Common.Repositories
{
    using System;
    using CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;

    public interface IFundingClaimReconciliationCommandRepository
    {
        Guid CreateFundingClaimReconciliation(FundingClaimReconciliation fundingClaimReconciliation);
    }
}
