namespace PerformanceManagementDomain.ReconciliationPublication.Repositories
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IClaimReconciliationReferenceDataReconProfilingRepository
    {
        Task<bool> ShouldStaggerPayments(ConnectionInfo connectionInfo, string fundingPeriod, int ukprn);
    }
}