namespace PerformanceManagementDomain.XrmEndpoint.Repositories
{
    using System;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;

    public interface IFundingClaimReconciliationCommandRepository
    {
        Guid CreateFundingClaimReconciliation(FundingClaimReconciliation fundingClaimReconciliation);

        void SetStatusOfFundingClaimReconciliationToPublished(Guid fundingClaimReconciliationId, DateTime publishedDate);

        void SetStatusOfFundingClaimReconciliationToManuallyPublished(Guid fundingClaimReconciliationId, DateTime publishedDate);

        void SetStatusOfFundingClaimReconciliationToPublishFailed(Guid fundingClaimReconciliationId,
            DateTime dateOccurred, string reasonForFailure);
    }
}