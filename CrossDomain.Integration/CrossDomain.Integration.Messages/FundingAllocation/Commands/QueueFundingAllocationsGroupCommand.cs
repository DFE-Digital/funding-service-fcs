namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    using System.Collections.Generic;
    using Dtos;

    public class QueueFundingAllocationsGroupCommand
    {
        public IEnumerable<string> FundingAllocationIds { get; set; }

        public CrmContractInfo CrmContractInfo { get; set; }

        public override string ToString()
        {
            return $"Funding Ids: {string.Join(",", FundingAllocationIds ?? new List<string>())}, CrmContractInfo: {CrmContractInfo}";
        }
    }
}