namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using PerformanceManagementDomain.DataStore;
    using PerformanceManagementDomain.DataStore.Models;
    using System.Collections.Generic;
    using System.Linq;
    using Extensions;

    public static class FcrPublicationExceptionRepository
    {
        public static void UpsertPublicationException(string claimReconciliationAllocationGroupCode, int ukprn)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                var existing = context.ClaimReconciliationPublicationExceptions.Find(claimReconciliationAllocationGroupCode, ukprn);
                if (existing == null)
                {
                    context.ClaimReconciliationPublicationExceptions.Add(new ClaimReconciliationPublicationException(claimReconciliationAllocationGroupCode, ukprn));

                    context.SaveChanges();
                }
            }
        }

        public static void RemoveByUkprns(IReadOnlyCollection<int> ukprnsToRemove)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.ClaimReconciliationPublicationExceptions.RemoveWhere(crpe => ukprnsToRemove.Contains(crpe.Ukprn));
                context.SaveChanges();
            }
        }
    }
}
