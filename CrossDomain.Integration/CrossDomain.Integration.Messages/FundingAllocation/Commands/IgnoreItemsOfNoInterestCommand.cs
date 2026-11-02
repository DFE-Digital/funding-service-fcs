namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    using System.Collections.Generic;

    public class IgnoreItemsOfNoInterestCommand
    {
        public IReadOnlyCollection<string> FundingAllocationIds { get; set; }

        public override string ToString() => $"FundingAllocationIds: {string.Join(", ",FundingAllocationIds ?? new List<string>())}";
    }
}
