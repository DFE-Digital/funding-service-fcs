namespace ContractRequest.Cfs.AllocationCreated.Repositories
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAllocationNotificationRepository
    {
        Task SetAllocationNotificationToComplete(ConnectionInfo connectionInfo, string allocationId, int versionNumber);
    }
}