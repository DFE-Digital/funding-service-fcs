namespace ContractRequestDomain.Cfs.Feed.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dtos;
    using Optional;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAllocationNotificationRepository
    {
        Task<Option<Bookmark>> GetCurrentBookmark(ConnectionInfo connectionInfo);

        Task AddRange(ConnectionInfo connectionInfo,  IReadOnlyCollection<AllocationNotification> allocationNotifications);
    }
}
