namespace Datafix.Tests.Dtos
{
    public class ApprovedContractAllocationIdentifier
    {
        public ApprovedContractAllocationIdentifier(string ContractAllocationNumber, int ContractVersionNumber, int approvedContractId, bool includeAllContractsOnSummaryOfFunding)
        {
            AllocationNumber = ContractAllocationNumber;
            VersionNumber = ContractVersionNumber;
            ApprovedContractId = approvedContractId;
            IncludeAllContractsOnSummaryOfFunding = includeAllContractsOnSummaryOfFunding;
        }

        public string AllocationNumber { get; }
        public int VersionNumber { get; }
        public int ApprovedContractId { get; }
        public bool IncludeAllContractsOnSummaryOfFunding { get; }
    }
}
