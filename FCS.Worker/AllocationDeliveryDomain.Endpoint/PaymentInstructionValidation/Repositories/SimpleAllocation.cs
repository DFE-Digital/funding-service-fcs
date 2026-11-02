namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Repositories
{
    using System;

    public class SimpleAllocation
    {
        public SimpleAllocation(Guid allocationId, Guid fspId, Guid contractId)
        {
            AllocationId = allocationId;
            FspId = fspId;
            ContractId = contractId;
        }

        public Guid AllocationId { get; }

        public Guid FspId { get; }

        public Guid ContractId { get; }
    }
}