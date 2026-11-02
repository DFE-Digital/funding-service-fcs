namespace PerformanceManagementDomain.PullFundingClaim.Repositories
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IClaimReconciliationBehaviourAsyncRepository
    {
        Task<bool> DoesClaimCollectionCodeExist(string closedCollectionKey, ConnectionInfo connectionInfo);
    }
}