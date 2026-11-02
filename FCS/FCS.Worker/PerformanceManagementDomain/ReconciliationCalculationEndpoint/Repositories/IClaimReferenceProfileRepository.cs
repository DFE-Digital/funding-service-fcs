namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IClaimReferenceProfileRepository
    {
        Task<decimal?> GetPlannedValue(string claimReconciliationDeliverableGroupCode, int ukprn, ConnectionInfo connectionInfo);

        Task<bool> IsProfileFromReferenceData(string claimReconciliationDeliverableGroupCode, ConnectionInfo connectionInfo);
    }
}