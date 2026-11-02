namespace ContractRequestDomain.Cfs.Feed.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using Dtos;
    using SFA.FCT.ContractRequestDomain.DataStore;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using Optional;

    public class AllocationNotificationRepository : IAllocationNotificationRepository
    {
        public async Task<Option<Bookmark>> GetCurrentBookmark(ConnectionInfo connectionInfo)
        {
            using (ContractRequestDbContext context = new ContractRequestDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                var allocation = await context.AllocationNotifications
                    .OrderByDescending(an => an.Id)
                    .Take(1)
                    .Select(an => new {an.AllocationId, an.FeedPageNumber})
                    .FirstOrDefaultAsync()
                    .ConfigureAwait(continueOnCapturedContext: false);

                Bookmark bookmark = null;

                if (allocation != null)
                {
                    bookmark = new Bookmark(allocation.AllocationId, allocation.FeedPageNumber);
                }

                return bookmark.SomeWhen(b => b != null);
            }
        }

        public async Task AddRange(ConnectionInfo connectionInfo, IReadOnlyCollection<AllocationNotification> allocationNotifications)
        {
            using (ContractRequestDbContext context = new ContractRequestDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                context.AllocationNotifications.AddRange(allocationNotifications);
                await context.SaveChangesAsync()
                    .ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}