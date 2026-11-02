namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using System.Collections.Generic;
    using Dtos;
    using Entities;

    public class ReleaseQueuedFundingAllocationsForContractsCommand
    {
        public ReleaseQueuedFundingAllocationsForContractsCommand(IReadOnlyCollection<ContractIdentity> contractIdentities)
        {
            ContractIdentities = contractIdentities;
        }

        public IReadOnlyCollection<ContractIdentity> ContractIdentities { get; }

        public IReadOnlyCollection<ContractAndStatus> OverrideStatuses { get; set; }

        public bool IgnoreContractIdentitiesWhenConsideringIntent { get; set; }

        public override string ToString()
        {
            return $"ContractIdentities: { string.Join(", ", ContractIdentities)}," +
                   $"OverrideStatuses: { string.Join(", ", GetOverrideStatuses()) }, IgnoreContractIdentitiesWhenConsideringIntent: {IgnoreContractIdentitiesWhenConsideringIntent}";
        }

        public IReadOnlyCollection<ContractAndStatus> GetOverrideStatuses() =>
            OverrideStatuses ?? new List<ContractAndStatus>();
    }
}