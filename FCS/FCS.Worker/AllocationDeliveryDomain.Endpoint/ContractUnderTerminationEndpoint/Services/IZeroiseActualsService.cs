namespace AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint.Services
{
    using System;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractTermination;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IZeroiseActualsService
    {
        Task ConditionallyZeroiseActuals(ConnectionInfo connectionInfo, TerminationAllocation terminationAllocation, Func<ContractAllocationActualsType, Task> publishAllocationActuals);
    }
}