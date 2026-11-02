namespace PerformanceManagementDomain.RecalculationInitiated.Repositories
{
    using System;
    using Dto;

    public interface IFundingClaimReconciliationRepository
    {
        FundingClaimReconciliationInfo GetFundingClaimReconciliationInfo(Guid fundingClaimReconciliationId);
    }
}
