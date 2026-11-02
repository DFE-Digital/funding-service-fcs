namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IClaimReconciliationAllocationGroupFspRepository
    {
        Task<ClaimReconciliationAllocationGroupFsp> GetClaimAllocationGroupForFundingStreamPeriod(string fundingStreamPeriod, ConnectionInfo connectionInfo);
    }
}