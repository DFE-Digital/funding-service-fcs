namespace ContractRequestDomain.Cfs.Detail.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;
    using SFA.FCT.ContractRequestDomain.DataStore;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class AllocationNotificationRepository : IAllocationNotificationRepository
    {
        public async Task<IReadOnlyCollection<AllocationNotification>> GetNewAllocationNotificationsThatAreNotInProgress(ConnectionInfo connectionInfo)
        {
            using (var context = new ContractRequestDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {               

                return await context.AllocationNotifications.AsNoTracking()
                    .Where(an => an.Status == ProcessingStatus.New)
                    .Where(newA => !context.AllocationNotifications.Where(an => an.Status == ProcessingStatus.Processing)
                        .Select(processing => processing.Ukprn).Contains(newA.Ukprn))
                    .ToListAsync()
                    .ConfigureAwait(continueOnCapturedContext: false);
            }
        }

        public async Task SetAllocationNotificationsToProcessing(ConnectionInfo connectionInfo, IReadOnlyCollection<int> ids)
        {
            if (ids.Any())
            {
                string rowPks = string.Join(",", ids.Select(pk => $"'{pk}'"));
                using (var context = new ContractRequestDbContext(connectionInfo.Connection, connectionInfo.Transaction))
                {
                    context.Database.ExecuteSqlCommand($@"update [ContractRequest].[AllocationNotification]
                set [Status] = @Status
                where id in ({rowPks}); ", new SqlParameter("@Status", ProcessingStatus.Processing));

                    await context.SaveChangesAsync().ConfigureAwait(continueOnCapturedContext: false);
                }
            }
        }
    }
}
