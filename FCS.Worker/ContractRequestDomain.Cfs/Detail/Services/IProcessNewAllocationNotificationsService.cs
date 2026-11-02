namespace ContractRequestDomain.Cfs.Detail.Services
{
    using System.Threading.Tasks;
    using ContractRequestDomain.Cfs.Detail.DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IProcessNewAllocationNotificationsService
    {
        Task<AllocationWithEntityId[]> GetPopulatedNewAllocations(ConnectionInfo connectionInfo);
    }
}