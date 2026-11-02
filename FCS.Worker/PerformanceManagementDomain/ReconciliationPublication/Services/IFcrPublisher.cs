namespace PerformanceManagementDomain.ReconciliationPublication.Services
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;

    public interface IFcrPublisher
    {
        Task<FcrPublishResult> PublishToFeed(ConnectionInfo connectionInfo, FundingClaimReconciliation fundingClaimReconciliation);

        FcrPublishResult PublishManually(ConnectionInfo connectionInfo, FundingClaimReconciliation fundingClaimReconciliation);
    }
}
