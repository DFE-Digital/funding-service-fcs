namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public interface IContractAllocationDeliverableRepository
    {
        Task<IReadOnlyCollection<ContractAllocationDeliverable>> FindByAllocationNumber(string contractAllocationNumber, ConnectionInfo connectionInfo);

        Task StoreContractAllocationDeliverables(IReadOnlyCollection<ContractAllocationDeliverable> contractAllocationDeliverables, ConnectionInfo connectionInfo);
    }
}