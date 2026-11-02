namespace ContractRequest.Cfs.AllocationCreated.Repositories
{
    using System.Linq;
    using System.Threading.Tasks;
    using SFA.FCT.ContractRequestDomain.DataStore;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class AllocationNotificationRepository : IAllocationNotificationRepository
    {
        public async Task SetAllocationNotificationToComplete(ConnectionInfo connectionInfo, string allocationId, int versionNumber)
        {
            using (var context = new ContractRequestDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                var allocationNotification = context.AllocationNotifications.Single(an => an.AllocationId == allocationId && an.VersionNumber == versionNumber);

                allocationNotification.Status = ProcessingStatus.Complete;

                await context.SaveChangesAsync().ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}