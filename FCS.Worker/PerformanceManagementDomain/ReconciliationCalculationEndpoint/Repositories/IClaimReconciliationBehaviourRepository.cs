namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public interface IClaimReconciliationBehaviourRepository
    {
        Task<ClaimReconciliationBehaviour> Find(string claimCollectionCode, string claimAllocationGroup, ConnectionInfo connectionInfo);
    }
}