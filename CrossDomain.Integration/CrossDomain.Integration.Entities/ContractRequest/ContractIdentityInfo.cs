namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Collections.Generic;

    public class ContractIdentityInfo
    {
        public ContractIdentityInfo(string contractNumber, IReadOnlyCollection<AllocationIdentityInfo> allocations)
        {
            if (allocations == null)
            {
                throw new ArgumentException("Allocations cannot be null", nameof(allocations));
            }

            ContractNumber = contractNumber;
            Allocations = allocations;
        }

        public string ContractNumber { get; set; }

        public IReadOnlyCollection<AllocationIdentityInfo> Allocations { get; }

        public static ContractIdentityInfo Empty => new ContractIdentityInfo(null, new List<AllocationIdentityInfo>());
    }
}
