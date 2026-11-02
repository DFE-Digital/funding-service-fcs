namespace ContractRequestDomain.Cfs.Feed.Services
{
    using System;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAllocationNotificationService
    {
        Task ReadLatestNotifications(ConnectionInfo connectionInfo, Func<Task> getMoreNotifications);
    }
}