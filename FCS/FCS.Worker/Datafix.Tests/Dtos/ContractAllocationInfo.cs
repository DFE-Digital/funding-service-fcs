namespace Datafix.Tests.Dtos
{
    public class ContractAllocationInfo
    {
        public ContractAllocationInfo(string allocationNumber, int versionNumber, int approvedContractId, string fundingType, string fundingPeriod)
        {
            AllocationNumber = allocationNumber;
            VersionNumber = versionNumber;
            ApprovedContractId = approvedContractId;
            FundingType = fundingType;
            FundingPeriod = fundingPeriod;
        }

        public string AllocationNumber { get; }

        public int VersionNumber { get; }

        public int ApprovedContractId { get; }

        public string FundingType { get; }

        public string FundingPeriod { get; }
    }
}
