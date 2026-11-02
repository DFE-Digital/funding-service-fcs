namespace ContractRequestDomain.Cfs.Detail.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAllocationNotificationRepository
    {
        Task<IReadOnlyCollection<AllocationNotification>> GetNewAllocationNotificationsThatAreNotInProgress(
            ConnectionInfo connectionInfo);

        Task SetAllocationNotificationsToProcessing(ConnectionInfo connectionInfo, IReadOnlyCollection<int> ids);
    }
}