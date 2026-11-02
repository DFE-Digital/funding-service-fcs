namespace PerformanceManagementDomain.ReconciliationPublication.Repositories
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IClaimReconciliationPublicationExceptionRepository
    {
        Task<bool> IsForManualPublication(ConnectionInfo connectionInfo, string claimReconciliationAllocationGroupCode, int ukprn);
    }
}
