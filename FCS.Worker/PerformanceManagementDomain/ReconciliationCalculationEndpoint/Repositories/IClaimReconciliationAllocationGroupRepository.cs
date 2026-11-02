namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public interface IClaimReconciliationAllocationGroupRepository
    {
        Task<ClaimReconciliationAllocationGroup> Find(string allocationGroupCode, ConnectionInfo connectionInfo);
    }
}