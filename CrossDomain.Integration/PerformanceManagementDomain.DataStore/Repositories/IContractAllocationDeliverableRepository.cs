namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using System.Collections.Generic;
    using Models;

    public interface IContractAllocationDeliverableRepository
    {
        ContractAllocationDeliverable Find(string contractAllocationNumber, int deliverableCode);

        IReadOnlyCollection<ContractAllocationDeliverable> FindByAllocationNumber(string contractAllocationNumber);

        void StoreContractAllocationDeliverables(IReadOnlyCollection<ContractAllocationDeliverable> contractAllocationDeliverables);
    }
}
