namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAllocationUnderTerminationRepository
    {
        Task AddRange(IReadOnlyCollection<AllocationUnderTermination> allocationUnderTermination, ConnectionInfo connectionInfo);

        Task RemoveAllocationUnderTerminationsForContract(string contractNumber, ConnectionInfo connectionInfo);
    }
}