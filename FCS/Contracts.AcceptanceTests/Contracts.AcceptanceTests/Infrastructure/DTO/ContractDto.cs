namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    using System;
    using System.Collections.Generic;

    public class ContractDto
    {
        public string ContractNumber { get; set; }

        public string MasterContractNumber { get; set; }

        public Guid ContractId { get; set; }

        public DateTime CreatedOn { get; set; }

        public string Upin { get; set; }

        public int ContractVersion { get; set; }

        public string Ukprn { get; set; }

        public IReadOnlyCollection<AllocationNumberPrefix> AllocationNumberPrefixes { get; set; } = new List<AllocationNumberPrefix>();
    }
}
