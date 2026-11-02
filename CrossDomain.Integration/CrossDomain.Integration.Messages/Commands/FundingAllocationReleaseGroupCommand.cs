namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using System.Collections.Generic;
    using Dtos;
    using Entities;

    public class FundingAllocationReleaseGroupCommand
    {
        public IEnumerable<string> ReleaseGroupNames { get; set; }

        public bool OnlyQueuedFundingAllocations { get; set; }

        public IReadOnlyCollection<ContractIdentity> EventSourceContractIdentities { get; set; } = new List<ContractIdentity>();

        public IReadOnlyCollection<ContractAndStatus> OverrideStatuses { get; set; } = new List<ContractAndStatus>();

        public bool IgnoreContractIdentitiesWhenConsideringIntent { get; set; }

        public override string ToString()
        {
            return $"ReleaseGroupNames: {string.Join(", ", ReleaseGroupNames ?? new List<string>())}, OnlyQueuedFundingAllocations: {OnlyQueuedFundingAllocations}" +
                   $", EventSourceContractIdentities: {string.Join(", ", EventSourceContractIdentities)}" +
                   $", OverrideStatuses: { string.Join(", ", OverrideStatuses) }, IgnoreContractIdentitiesWhenConsideringIntent: {IgnoreContractIdentitiesWhenConsideringIntent}";
        }
    }
}
