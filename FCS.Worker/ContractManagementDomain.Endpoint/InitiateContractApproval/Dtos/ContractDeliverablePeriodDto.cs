namespace ContractManagementDomain.Endpoint.InitiateContractApproval.Dtos
{
    using System;

    public class ContractDeliverablePeriodDto
    {
        public ContractDeliverablePeriodDto(Guid contractId, Guid contractAllocationId, Guid id)
        {
            ContractId = contractId;
            ContractAllocationId = contractAllocationId;
            Id = id;
        }

        public Guid ContractId { get; }

        public Guid ContractAllocationId { get; }

        public Guid Id { get; }
    }
}
