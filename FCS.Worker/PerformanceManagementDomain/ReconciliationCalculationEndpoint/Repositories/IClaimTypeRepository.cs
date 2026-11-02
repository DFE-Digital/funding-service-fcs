namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public interface IClaimTypeRepository
    {
        Task<ClaimType> FindByName(string claimTypeName, ConnectionInfo connectionInfo);
    }
}