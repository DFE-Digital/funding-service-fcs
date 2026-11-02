namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    using System.Collections.Generic;
    using Extensions;

    public class UnParkFundingAllocationsCommand
    {
        public IEnumerable<string> FundingAllocationIds { get; set; }

        public override string ToString()
        {
            return $"Funding Ids: {FundingAllocationIds.ToCsv()}";
        }
    }
}
