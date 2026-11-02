namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.DataStore;
    using Extensions;

    public static class AllocationNotificationRepository
    {
        public static void RemoveByUkprns(IReadOnlyCollection<int> ukprnsToRemove)
        {
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                context.AllocationNotifications.RemoveWhere(an => ukprnsToRemove.Contains(an.Ukprn));
                context.SaveChanges();
            }
        }

        public static bool HasEntries()
        {
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                return context.AllocationNotifications.Any();
            }
        }

        public static bool HasUkprns(IReadOnlyCollection<int> ukprns)
        {
            using (ContractRequestDbContext context = new ContractRequestDbContext())
            {
                var ukrpnsInDb = context.AllocationNotifications.Select(a => a.Ukprn).ToList();
                return ukprns.All(ukprn => ukrpnsInDb.Contains(ukprn));
            }
        }
    }
}
