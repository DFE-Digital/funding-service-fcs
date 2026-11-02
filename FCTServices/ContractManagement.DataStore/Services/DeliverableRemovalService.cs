namespace ContractManagement.DataStore.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    public static class DeliverableRemovalService
    { 
        public static void RemoveNonMatchingDeliverablesFromAllocation(contractAllocationsContractAllocation allocation, IReadOnlyCollection<int> deliverableCodesToKeep)
        {
            allocation.contractDeliverables.ForEach(d => RemoveNonMatchingDeliverablesFromDeliverable(d, deliverableCodesToKeep));
            allocation.contractDeliverables = allocation.contractDeliverables.Where(d => deliverableCodesToKeep.Contains(d.deliverable.deliverableCode)).ToList();
        }

        public static void RemoveNonMatchingDeliverablesFromAllocation(ContractRequest.contractAllocation allocation, IReadOnlyCollection<int> deliverableCodesToKeep)
        {
            allocation.contractDeliverables = allocation.contractDeliverables.Where(d => deliverableCodesToKeep.Contains(d.deliverable.deliverableCode)).ToList();
        }

        private static void RemoveNonMatchingDeliverablesFromDeliverable(contractDeliverablesTypeContractDeliverable deliverable, IReadOnlyCollection<int> deliverableCodesToKeep)
        {
            deliverable.contractDeliverables?.ForEach(d => RemoveNonMatchingDeliverablesFromDeliverable(d, deliverableCodesToKeep));

            if (deliverable.contractDeliverables != null && deliverable.contractDeliverables.Any())
            {
                deliverable.contractDeliverables =
                    deliverable.contractDeliverables.Where(
                        d => deliverableCodesToKeep.Contains(d.deliverable.deliverableCode)).ToList();
            }            
        }
    }
}
