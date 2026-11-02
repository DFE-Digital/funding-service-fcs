namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation;

    public interface IContractAllocationRepository
    {
        Task<ContractAllocation> Find(string allocationNumber, ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<AllocationInfo>> GetAllocationsWithPlannedValue(IReadOnlyCollection<string> allocationNumbers, ConnectionInfo connectionInfo);

        Task AddOrUpdateAllocation(ContractAllocation contractAllocation, ConnectionInfo connectionInfo);
    }
}