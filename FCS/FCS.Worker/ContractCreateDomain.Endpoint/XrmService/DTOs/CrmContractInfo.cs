namespace ContractCreateDomain.Endpoint.XrmService.DTOs
{
    using System;
    using System.Collections.Generic;

    public class CrmContractInfo
    {
        public CrmContractInfo(Guid contractId, string contractNumber, IReadOnlyCollection<CrmAllocationInfo> allocations)
        {
            ContractId = contractId;
            ContractNumber = contractNumber;
            Allocations = allocations;
        }

        public Guid ContractId { get; }

        public string ContractNumber { get; }

        public IReadOnlyCollection<CrmAllocationInfo> Allocations { get; }
    }
}
