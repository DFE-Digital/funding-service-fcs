namespace PerformanceManagementDomain.ReconciliationPublication.Repositories
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public interface IAtomFeedItemRepository
    {
        Task Add(ConnectionInfo connectionInfo, AtomFeedItem atomFeedItem);

        Task<AtomFeedItem> GetByUkprnClaimTypeAllocationGroupAndPeriod(ConnectionInfo connectionInfo, int ukprn, string claimTypeName, string allocationGroup, string period);
    }
}
