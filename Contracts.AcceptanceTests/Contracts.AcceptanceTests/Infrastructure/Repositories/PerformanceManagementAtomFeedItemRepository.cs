namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Linq;
    using Extensions;
    using PerformanceManagementDomain.DataStore;
    using PerformanceManagementDomain.DataStore.Models;

    public static class PerformanceManagementAtomFeedItemRepository
    {
        public static AtomFeedItem FindByNaturalKey(int ukprn, string claimTypeName, string allocationGroupName, string period)
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                return context.AtomFeedItems
                    .SingleOrDefault(a => a.Ukprn == ukprn && a.ClaimTypeName == claimTypeName && a.AllocationGroupName == allocationGroupName && a.Period == period);
            }
        }
    }
}
