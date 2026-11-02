namespace AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractTermination;

    public static class TerminationAllocationMapper
    {
        public static IReadOnlyCollection<AllocationUnderTermination> ToAllocationsUnderTermination(
            string contractNumber,
            IReadOnlyCollection<TerminationAllocation> terminationAllocations)
        {
            return terminationAllocations
                .Where(ta => ta.TerminationDate.HasValue)
                .Select(ta => new AllocationUnderTermination(contractNumber, ta.AllocationNumber, ta.TerminationDate.Value))
                .ToList();
        }
    }
}
